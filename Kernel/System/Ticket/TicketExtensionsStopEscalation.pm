# --
# --

package Kernel::System::Ticket::TicketExtensionsStopEscalation;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.39.2.3 $) [1];


=item GetTotalNonEscalationRelevantBusinessTime()

Calculate non relevant time for escalation.

    my $Result = $TicketObject->GetTotalNonEscalationRelevantBusinessTime(
        TicketID => 123,  # required
        Type     => "",   # optional ( Response | Solution )
    );

=cut

sub GetTotalNonEscalationRelevantBusinessTime {
    my ( $Self, %Param ) = @_;

    return if !$Param{TicketID};

    # get optional parameter
    $Param{Type} ||= '';
    
    if ( $Param{StartTimestamp} ) {
        $Param{StartTime} = $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
            String => $Param{StartTimestamp},
        );
    }
    if ( $Param{StopTimestamp} ) {
        $Param{StopTime} = $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
            String => $Param{StopTimestamp},
        );
    }

    # get some config values if required...
    if ( !$Param{RelevantStates} ) {
        my $RelevantStateNamesArrRef =
            $Kernel::OM->Get('Kernel::Config')->Get('Ticket::EscalationDisabled::RelevantStates');
            
        if ( ref($RelevantStateNamesArrRef) eq 'ARRAY' ) {
            my $RelevantStateNamesArrStrg = join( ',', @{$RelevantStateNamesArrRef} );
            my %StateListHash = $Kernel::OM->Get('Kernel::System::State')->StateList( UserID => 1 );
            for my $CurrStateID ( keys(%StateListHash) ) {
                if ( $RelevantStateNamesArrStrg =~ /(^|.*,)$StateListHash{$CurrStateID}(,.*|$)/ ) {
                    $Param{RelevantStates}->{$CurrStateID} = $StateListHash{$CurrStateID};
                }
            }
        }
    }
    my %RelevantStates = ();
    if ( ref( $Param{RelevantStates} ) eq 'HASH' ) {
        %RelevantStates = %{ $Param{RelevantStates} };
    }

    #---------------------------------------------------------------------------
    # get escalation data...
    my %Ticket = $Self->TicketGet(
        TicketID => $Param{TicketID},
        UserID   => 1,
    );
    my %Escalation = $Self->TicketEscalationPreferences(
        Ticket => \%Ticket,
        UserID => 1,
    );

    #---------------------------------------------------------------------------
    # get all history lines...
    my @HistoryLines = $Self->HistoryGet(
        TicketID => $Param{TicketID},
        UserID   => 1,
    );

    my $PendStartTime = 0;
    my $PendTotalTime = 0;
    my $Solution      = 0;

    my %ClosedStateList = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
        StateType => ['closed'],
        Result    => 'HASH',
    );
    for my $HistoryHash (@HistoryLines) {
        my $CreateTime = $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
            String => $HistoryHash->{CreateTime},
        );

        # skip not relevant history information
        next if ( $Param{StartTime} && $Param{StartTime} >= $CreateTime );
        next if ( $Param{StopTime}  && $Param{StopTime} <= $CreateTime );

        # proceed history information
        if (
            $HistoryHash->{HistoryType} eq 'StateUpdate'
            || $HistoryHash->{HistoryType} eq 'NewTicket'
            )
        {
            if ( $RelevantStates{ $HistoryHash->{StateID} } && $PendStartTime == 0 ) {
                # datetime to unixtime
                $PendStartTime = $CreateTime;
                next;
            }
            elsif ( $PendStartTime != 0 && !$RelevantStates{ $HistoryHash->{StateID} } ) {
                my $UnixEndTime = $CreateTime;
                my $WorkingTime = $Kernel::OM->Get('Kernel::System::Time')->WorkingTime(
                    StartTime => $PendStartTime,
                    StopTime  => $UnixEndTime,
                    Calendar  => $Escalation{Calendar},
                );
                $PendTotalTime += $WorkingTime;
                $PendStartTime = 0;
            }
        }
        if (
            (
                $HistoryHash->{HistoryType} eq 'SendAnswer'
                || $HistoryHash->{HistoryType} eq 'PhoneCallAgent'
            )
            && $Param{Type} eq 'Response'
            )
        {
            if ( $PendStartTime != 0 ) {
                my $UnixEndTime = $CreateTime;
                my $WorkingTime = $Kernel::OM->Get('Kernel::System::Time')->WorkingTime(
                    StartTime => $PendStartTime,
                    StopTime  => $UnixEndTime,
                    Calendar  => $Escalation{Calendar},
                );
                $PendTotalTime += $WorkingTime;
                $PendStartTime = 0;
            }
            return $PendTotalTime;
        }
        if ( $HistoryHash->{HistoryType} eq 'StateUpdate' && $Param{Type} eq 'Solution' ) {
            for my $State ( keys %ClosedStateList ) {
                if ( $HistoryHash->{StateID} == $State ) {
                    if ( $PendStartTime != 0 ) {
                        my $UnixEndTime = $CreateTime;
                        my $WorkingTime = $Kernel::OM->Get('Kernel::System::Time')->WorkingTime(
                            StartTime => $PendStartTime,
                            StopTime  => $UnixEndTime,
                            Calendar  => $Escalation{Calendar},
                        );
                        $PendTotalTime += $WorkingTime;
                        $PendStartTime = 0;
                    }
                    return $PendTotalTime;
                }
            }
        }
    }
   
    return $PendTotalTime;
}


# disable redefine warnings in this scope
{
    no warnings 'redefine';

    # overwrite sub _TicketGetFirstResponse to get correct time and not only for escalated tickets
    sub Kernel::System::Ticket::_TicketGetFirstResponse {
        my ( $Self, %Param ) = @_;

        # check needed stuff
        for my $Needed (qw(TicketID Ticket)) {
            if ( !defined $Param{$Needed} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $Needed!" );
                return;
            }
        }

        # 
        my $SQL =
            'SELECT a.create_time, a.id FROM article a, article_sender_type ast'
            . ' WHERE a.article_sender_type_id = ast.id  AND'
            . ' a.ticket_id = ? 
                AND a.is_visible_for_customer = ? AND ( ';

        my $SQL1 =
            '( ast.name = \'agent\')';

        my $SQL2 = ') ORDER BY a.create_time';

        my $RespTimeByPhone = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ResponsetimeSetByPhoneTicket');
        my @RespTimeByPhoneTicketTypes;
        my $RespTimeByPhoneTicketTypeStrg = join( ",", @RespTimeByPhoneTicketTypes );
        if (
            0 && $RespTimeByPhone &&
            (
                !$RespTimeByPhoneTicketTypeStrg ||
                $RespTimeByPhoneTicketTypeStrg =~ /(^|.*,)$Param{Ticket}->{Type}(,.*|$)/
            )
            )
        {
            $SQL1 .= ' OR ( ast.name = \'customer\' AND art.name = \'phone\')';
        }

        my $RespTimeByAutoReply = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ResponsetimeSetByAutoReply');
        my @RespTimeByAutoReplyTypes;
        my $RespTimeByAutoReplyTypeStrg = join( ",", @RespTimeByAutoReplyTypes );
        if (
            $RespTimeByAutoReply &&
            (
                !$RespTimeByAutoReplyTypeStrg ||
                $RespTimeByAutoReplyTypeStrg =~ /(^|.*,)$Param{Ticket}->{Type}(,.*|$)/
            )
            )
        {
            $SQL1 .= ' OR ( ast.name = \'system\' AND art.name LIKE \'email%-ext%\')';
        }

        $SQL .= $SQL1 . $SQL2;

        # 

        # check if first response is already done
        return if !$Kernel::OM->Get('Kernel::System::DB')->Prepare(
            SQL => $SQL,
            Bind  => [ \$Param{TicketID}, \1 ],
            Limit => 1,
        );
        my %Data;
        while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
            $Data{FirstResponse} = $Row[0];

            # cleanup time stamps (some databases are using e. g. 2008-02-25 22:03:00.000000
            # and 0000-00-00 00:00:00 time stamps)
            $Data{FirstResponse} =~ s/^(\d\d\d\d-\d\d-\d\d\s\d\d:\d\d:\d\d)\..+?$/$1/;
        }

        return if !$Data{FirstResponse};

        # get escalation properties
        my %Escalation = $Self->TicketEscalationPreferences(
            Ticket => $Param{Ticket},
            UserID => $Param{UserID} || 1,
        );

        # get unix time stamps
        my $CreateTime = $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
            String => $Param{Ticket}->{Created},
        );
        my $FirstResponseTime = $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
            String => $Data{FirstResponse},
        );

        # get time between creation and first response
        my $WorkingTime = $Kernel::OM->Get('Kernel::System::Time')->WorkingTime(
            StartTime => $CreateTime,
            StopTime  => $FirstResponseTime,
            Calendar  => $Escalation{Calendar},
        );

        $Data{FirstResponseInMin} = int( $WorkingTime / 60 );

        if ( $Escalation{FirstResponseTime} ) {

            # 
            # moved content upwards
            # 

            my $EscalationFirstResponseTime = $Escalation{FirstResponseTime} * 60;
            $Data{FirstResponseDiffInMin}
                = int( ( $EscalationFirstResponseTime - $WorkingTime ) / 60 );
        }
        return %Data;
    }

    # overwrite sub _TicketGetClosed to get correct time and not only for escalated tickets
    sub Kernel::System::Ticket::_TicketGetClosed {
        my ( $Self, %Param ) = @_;

        # check needed stuff
        for my $Needed (qw(TicketID Ticket)) {
            if ( !defined $Param{$Needed} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $Needed!" );
                return;
            }
        }

        # get close time
        my @List = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
            StateType => ['closed'],
            Result    => 'ID',
        );
        return if !@List;

        # Get id for StateUpdate;
        my $HistoryTypeID = $Self->HistoryTypeLookup( Type => 'StateUpdate' );
        # 
        #return if !$HistoryTypeID;
        my @HistoryTypeIDs = ();
        if ($HistoryTypeID) {
            push @HistoryTypeIDs , $HistoryTypeID;
        }
        push @HistoryTypeIDs , $HistoryTypeID;

        # ticket can also created as closed Ticket and then there is no StateUpdate
        $HistoryTypeID = $Self->HistoryTypeLookup( Type => 'NewTicket' );
        if ($HistoryTypeID) {
            push @HistoryTypeIDs , $HistoryTypeID;
        }
        return if scalar(@HistoryTypeIDs) == 0;
        
        # Here, the order by clausule standard from OTRS AG is ASC, so it brings the first close date.
        # COMPLEMENTO: As asked by some customers, we change it to DESC in order to bring the last closed time,
        # for open and reopened tickets.
        my $OrderSort = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Closed::Order');
        return if !$Kernel::OM->Get('Kernel::System::DB')->Prepare(
            SQL => "SELECT create_time FROM ticket_history WHERE ticket_id = ? AND "
                . " state_id IN (${\(join ', ', sort @List)}) AND history_type_id IN (${\(join ', ', @HistoryTypeIDs)}) "
                . " ORDER BY create_time $OrderSort",
            Bind => [ \$Param{TicketID} ],
            Limit => 1,
        );

        # 

        my %Data;
        while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
            $Data{Closed} = $Row[0];

            # cleanup time stamps (some databases are using e. g. 2008-02-25 22:03:00.000000
            # and 0000-00-00 00:00:00 time stamps)
            $Data{Closed} =~ s/^(\d\d\d\d-\d\d-\d\d\s\d\d:\d\d:\d\d)\..+?$/$1/;
        }

        return if !$Data{Closed};

        # for compat. wording reasons
        $Data{SolutionTime} = $Data{Closed};

        # get escalation properties
        my %Escalation = $Self->TicketEscalationPreferences(
            Ticket => $Param{Ticket},
            UserID => $Param{UserID} || 1,
        );

        # get unix time stamps
        my $CreateTime = $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
            String => $Param{Ticket}->{Created},
        );
        my $SolutionTime = $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
            String => $Data{Closed},
        );

        # get time between creation and solution
        my $WorkingTime = $Kernel::OM->Get('Kernel::System::Time')->WorkingTime(
            StartTime => $CreateTime,
            StopTime  => $SolutionTime,
            Calendar  => $Escalation{Calendar},
        );

        $Data{SolutionInMin} = int( $WorkingTime / 60 );

        # COMPLEMENTO - ADICIONA AS HORAS QUE NÃO CONTA SLA NO CALCULO
        my $NaoContaSLA = $Self->GetTotalNonEscalationRelevantBusinessTime(
                TicketID       => $Param{TicketID},
            ) || 0;

        
        if ( $Escalation{SolutionTime} ) {

            # 
            # moved content upwards
            # 

            my $EscalationSolutionTime = $Escalation{SolutionTime} * 60;
            $Data{SolutionDiffInMin} = int( ( $EscalationSolutionTime - $WorkingTime + $NaoContaSLA) / 60 );

        }


        return %Data;
    }

    # overwrite sub TicketEscalationIndexBuild to disable escalation under certain conditions
    sub Kernel::System::Ticket::TicketEscalationIndexBuild {
        my ( $Self, %Param ) = @_;

        # check needed stuff
        for my $Needed (qw(TicketID UserID)) {
            if ( !defined $Param{$Needed} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $Needed!" );
                return;
            }
        }

        my %Ticket = $Self->TicketGet(
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
        );

        #-----------------------------------------------------------------------
        # 
        # no escalation for certain ticket types
        my $RelevantTypeNamesArrRef = $Kernel::OM->Get('Kernel::Config')->Get(
            'Ticket::EscalationDisabled::RelevantTypes'
        );
        if ( $Ticket{Type} && $RelevantTypeNamesArrRef && ref($RelevantTypeNamesArrRef) eq 'ARRAY' )
        {
            my $RelevantTypeNamesStrg = join( ',', @{$RelevantTypeNamesArrRef} );
            if ( $RelevantTypeNamesStrg =~ /(^|.*,)$Ticket{Type}(,.*|$)/ ) {
                $Ticket{DoNotSetEscalation} = 1;
            }
        }

        # no escalation for certain queues
        my $RelevantQueueNamesArrRef = $Kernel::OM->Get('Kernel::Config')->Get(
            'Ticket::EscalationDisabled::RelevantQueues'
        );
        if (
            $Ticket{Queue}
            && $RelevantQueueNamesArrRef
            && ref($RelevantQueueNamesArrRef) eq 'ARRAY'
            )
        {
            my $RelevantQueueNamesStrg = join( ',', @{$RelevantQueueNamesArrRef} );
            if ( $RelevantQueueNamesStrg =~ /(^|.*,)$Ticket{Queue}(,.*|$)/ ) {
                $Ticket{DoNotSetEscalation} = 1;
            }
        }

        # check for Non-SLA-relevant pending time...
        my $RelevantStateNamesArrRef = $Kernel::OM->Get('Kernel::Config')->Get(
            'Ticket::EscalationDisabled::RelevantStates'
        );
        my %RelevantStateHash         = ();
        my $RelevantStateNamesArrStrg = '';

        if ( $RelevantStateNamesArrRef && ref($RelevantStateNamesArrRef) eq 'ARRAY' ) {
            $RelevantStateNamesArrStrg = join( ',', @{$RelevantStateNamesArrRef} );
            my %StateListHash = $Self->StateList( %Param, );
            for my $CurrStateID ( keys(%StateListHash) ) {
                if ( $RelevantStateNamesArrStrg =~ /(^|.*,)$StateListHash{$CurrStateID}(,.*|$)/ ) {
                    $RelevantStateHash{$CurrStateID} = $StateListHash{$CurrStateID};
                }
            }
        }

        my $PendSumTime = 0;
        my $StatePend   = 0;

        if ( $RelevantStateNamesArrStrg =~ /(^|.*,)$Ticket{State}(,.*|$)/ ) {
            $PendSumTime = 1767139200;
            $StatePend   = 1;
        }
        else {
            $PendSumTime = $Self->GetTotalNonEscalationRelevantBusinessTime(
                TicketID       => $Param{TicketID},
# comentado em 10/6/15 complemento
#                RelevantStates => \%RelevantStateHash,
            ) || 0;
        }

        # 
        #-----------------------------------------------------------------------

        # do no escalations on (merge|close|remove) tickets
        # 
        # if ( $Ticket{StateType} =~ /^(merge|close|remove)/i ) {
        if ( $Ticket{DoNotSetEscalation} || $Ticket{StateType} =~ /^(merge|close|remove)/i ) {

            # 

            # update escalation times with 0
            my %EscalationTimes = (
                EscalationTime         => 'escalation_time',
                EscalationResponseTime => 'escalation_response_time',
                EscalationUpdateTime   => 'escalation_update_time',
                EscalationSolutionTime => 'escalation_solution_time',
            );
            for my $Key ( keys %EscalationTimes ) {

                # check if table update is needed
                next if !$Ticket{$Key};

                # update ticket table
                $Kernel::OM->Get('Kernel::System::DB')->Do(
                    SQL  => "UPDATE ticket SET $EscalationTimes{$Key} = 0 WHERE id = ?",
                    Bind => [ \$Ticket{TicketID}, ]
                );
            }

            # clear ticket cache
            delete $Self->{ 'Cache::GetTicket' . $Param{TicketID} };

            return 1;
        }

        # get escalation properties
        my %Escalation = $Self->TicketEscalationPreferences(
            Ticket => \%Ticket,
            UserID => $Param{UserID},
        );

        # find escalation times
        my $EscalationTime = 0;

        # update first response (if not responded till now)
        if ( !$Escalation{FirstResponseTime} ) {
            $Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL  => 'UPDATE ticket SET escalation_response_time = 0 WHERE id = ?',
                Bind => [ \$Ticket{TicketID}, ]
            );
        }
        else {

            # check if first response is already done
            my %FirstResponseDone = $Self->_TicketGetFirstResponse(
                TicketID => $Ticket{TicketID},
                Ticket   => \%Ticket,
            );

            # 
            # find solution time / first close time
            my %SolutionDone = $Self->_TicketGetClosed(
                TicketID => $Ticket{TicketID},
                Ticket   => \%Ticket,
            );

            # update first response time to 0
            # if (%FirstResponseDone) {
            if (%FirstResponseDone || %SolutionDone) {
            # 
                $Kernel::OM->Get('Kernel::System::DB')->Do(
                    SQL  => 'UPDATE ticket SET escalation_response_time = 0 WHERE id = ?',
                    Bind => [ \$Ticket{TicketID}, ]
                );
            }

            # update first response time to expected escalation destination time
            else {
                my $DestinationTime = $Kernel::OM->Get('Kernel::System::Time')->DestinationTime(
                    StartTime => $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
                        String => $Ticket{Created}
                    ),
                    Time     => $Escalation{FirstResponseTime} * 60,
                    Calendar => $Escalation{Calendar},
                );

                # update first response time to $DestinationTime
                $Kernel::OM->Get('Kernel::System::DB')->Do(
                    SQL => 'UPDATE ticket SET escalation_response_time = ? WHERE id = ?',
                    Bind => [ \$DestinationTime, \$Ticket{TicketID}, ]
                );

                # remember escalation time
                $EscalationTime = $DestinationTime;
            }
        }

        # update update && do not escalate in "pending auto" for escalation update time
        if ( !$Escalation{UpdateTime} || $Ticket{StateType} =~ /^(pending)/i ) {
            $Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL  => 'UPDATE ticket SET escalation_update_time = 0 WHERE id = ?',
                Bind => [ \$Ticket{TicketID}, ]
            );
        }
        else {

            # check if update escalation should be set
            my @SenderHistory;
            return if !$Kernel::OM->Get('Kernel::System::DB')->Prepare(
                SQL => 'SELECT article_sender_type_id, create_time FROM '
                    . 'article WHERE ticket_id = ? ORDER BY create_time ASC',
                Bind => [ \$Param{TicketID} ],
            );
            while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
                push @SenderHistory, {
                    SenderTypeID  => $Row[0],
                    ArticleTypeID => $Row[1],
                    Created       => $Row[2],
                };
            }

            # fill up lookups
            for my $Row (@SenderHistory) {

                # get sender type

                # get article type
            }

            # get latest customer contact time
            my $LastSenderTime;
            my $LastSenderType = '';
            for my $Row ( reverse @SenderHistory ) {

                # fill up latest sender time (as initial value)
                if ( !$LastSenderTime ) {
                    $LastSenderTime = $Row->{Created};
                }

                # do not use locked tickets for calculation
                #last if $Ticket{Lock} eq 'lock';

            	next if !$Row->{IsVisibleForCustomer};
                # do not use /int/ article types for calculation

                # only use 'agent' and 'customer' sender types for calculation

                # last if latest was customer and the next was not customer
                # otherwise use also next, older customer article as latest
                # customer followup for starting escalation
                if ( $Row->{SenderType} eq 'agent' && $LastSenderType eq 'customer' ) {
                    last;
                }

                # start escalation on latest customer article
                if ( $Row->{SenderType} eq 'customer' ) {
                    $LastSenderType = 'customer';
                    $LastSenderTime = $Row->{Created};
                }

                # start escalation on latest agent article
                if ( $Row->{SenderType} eq 'agent' ) {
                    $LastSenderTime = $Row->{Created};
                    last;
                }
            }
            if ($LastSenderTime) {
                my $DestinationTime = $Kernel::OM->Get('Kernel::System::Time')->DestinationTime(
                    StartTime => $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
                        String => $LastSenderTime,
                    ),
                    Time     => $Escalation{UpdateTime} * 60,
                    Calendar => $Escalation{Calendar},
                );

                # update update time to $DestinationTime
                $Kernel::OM->Get('Kernel::System::DB')->Do(
                    SQL => 'UPDATE ticket SET escalation_update_time = ? WHERE id = ?',
                    Bind => [ \$DestinationTime, \$Ticket{TicketID}, ]
                );

                # remember escalation time
                if ( $EscalationTime == 0 || $DestinationTime < $EscalationTime ) {
                    $EscalationTime = $DestinationTime;
                }
            }

            # else, no not escalate, because latest sender was agent
            else {
                $Kernel::OM->Get('Kernel::System::DB')->Do(
                    SQL  => 'UPDATE ticket SET escalation_update_time = 0 WHERE id = ?',
                    Bind => [ \$Ticket{TicketID}, ]
                );
            }
        }

        # update solution
        if ( !$Escalation{SolutionTime} ) {
            $Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL  => 'UPDATE ticket SET escalation_solution_time = 0 WHERE id = ?',
                Bind => [ \$Ticket{TicketID}, ]
            );
        }
        else {

            # find solution time / first close time
            my %SolutionDone = $Self->_TicketGetClosed(
                TicketID => $Ticket{TicketID},
                Ticket   => \%Ticket,
            );

            my $EscalationDelayByFreeTimeRef =
                $Kernel::OM->Get('Kernel::Config')->Get('Ticket::EscalationDelayed::FreeTimeField');

            if (
                $EscalationDelayByFreeTimeRef
                && ref($EscalationDelayByFreeTimeRef) eq 'HASH'
                && $EscalationDelayByFreeTimeRef->{Index}
                && $EscalationDelayByFreeTimeRef->{KeyRegExp}
                )
            {

                my $TicketFTimeKey =
                    $Kernel::OM->Get('Kernel::Config')
                    ->Get( 'TicketFreeTimeKey' . $EscalationDelayByFreeTimeRef->{Index} ) || '';
                my $CreateTimeStamp = $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
                    String => $Ticket{Created},
                );
                my $TicketFreeTimeStamp = $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
                    String => $Ticket{ 'TicketFreeTime' . $EscalationDelayByFreeTimeRef->{Index} }
                        || '2000-01-01 00:00:00',
                );

                if (
                    (
                        $TicketFTimeKey
                        && $TicketFTimeKey =~ /$EscalationDelayByFreeTimeRef->{KeyRegExp}/
                        && $Ticket{ 'TicketFreeTime' . $EscalationDelayByFreeTimeRef->{Index} }
                    )
                    && ( $CreateTimeStamp < $TicketFreeTimeStamp )
                    )
                {
                    $Ticket{SLAStartTime} =
                        $Ticket{ 'TicketFreeTime' . $EscalationDelayByFreeTimeRef->{Index} };
                }

            }

            # update solution time to 0
            if (%SolutionDone) {
                $Kernel::OM->Get('Kernel::System::DB')->Do(
                    SQL  => 'UPDATE ticket SET escalation_solution_time = 0 WHERE id = ?',
                    Bind => [ \$Ticket{TicketID}, ]
                );
            }
            else {
            	
                # 
            	my $DestinationTime;
                if ( $StatePend && $PendSumTime ) {
                   $DestinationTime = $PendSumTime;
                }
                else {
                # 

	                $DestinationTime = $Kernel::OM->Get('Kernel::System::Time')->DestinationTime(
	                    StartTime => $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
	
	                        # 
	                        # String => $Ticket{Created}
	                        String => $Ticket{SLAStartTime} || $Ticket{Created},
	
	                        # 
	
	                    ),
                        # 
                        # Time     => $Escalation{SolutionTime} * 60,
	                    Time     => $Escalation{SolutionTime} * 60 + $PendSumTime,
                        # 
	                    Calendar => $Escalation{Calendar},
	                );
                }

                # update solution time to $DestinationTime
                $Kernel::OM->Get('Kernel::System::DB')->Do(
                    SQL => 'UPDATE ticket SET escalation_solution_time = ? WHERE id = ?',
                    Bind => [ \$DestinationTime, \$Ticket{TicketID}, ]
                );

                # remember escalation time
                if ( $EscalationTime == 0 || $DestinationTime < $EscalationTime ) {
                    $EscalationTime = $DestinationTime;
                }
            }
        }

        # update escalation time (< escalation time)
        if ( defined $EscalationTime ) {
            $Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL => 'UPDATE ticket SET escalation_time = ? WHERE id = ?',
                Bind => [ \$EscalationTime, \$Ticket{TicketID}, ]
            );
        }

        # COMPLEMENTO: clear ticket cache - From OTRS 3.2.9 on
        $Self->_TicketCacheClear( TicketID => $Param{TicketID} );


        return 1;
    }

    # 
    
    sub GetLinkedTickets {
        my ( $Self, %Param ) = @_;
    
        my $SQL = 'SELECT target_key FROM link_relation WHERE source_key = ?';

        return if !$Kernel::OM->Get('Kernel::System::DB')->Prepare(
            SQL => $SQL,
            Bind  => [ \$Param{Customer} ],
        );
        my @TicketIDs;
        while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
            push @TicketIDs, $Row[0];
        }
        return @TicketIDs;
    }


	# Rewrite this function in order to return when it's a paused SLA status
	sub Kernel::System::Ticket::TicketEscalationDateCalculation {
		my ( $Self, %Param ) = @_;

		# check needed stuff
		for my $Needed (qw(Ticket UserID)) {
			if ( !defined $Param{$Needed} ) {
				$Kernel::OM->Get('Kernel::System::Log')->Log(
					Priority => 'error',
					Message  => "Need $Needed!"
				);
				return;
			}
		}

		# get ticket attributes
		my %Ticket = %{ $Param{Ticket} };

		# do no escalations on (merge|close|remove) tickets
		return if $Ticket{StateType} eq 'merged';
		return if $Ticket{StateType} eq 'closed';
		return if $Ticket{StateType} eq 'removed';
		
		# get escalation properties
		my %Escalation = $Self->TicketEscalationPreferences(
			Ticket => $Param{Ticket},
			UserID => $Param{UserID} || 1,
		);

		# return if we do not have any escalation attributes
		my %Map = (
			EscalationResponseTime => 'FirstResponse',
			EscalationUpdateTime   => 'Update',
			EscalationSolutionTime => 'Solution',
		);
		my $EscalationAttribute;
		KEY:
		for my $Key ( sort keys %Map ) {
			if ( $Escalation{ $Map{$Key} . 'Time' } ) {
				$EscalationAttribute = 1;
				last KEY;
			}
		}

		return if !$EscalationAttribute;

		# get time object
		my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

		# calculate escalation times based on escalation properties
		my $Time = $TimeObject->SystemTime();
		my %Data;

		#####################################################################################################
		# Return if paused SLA State
		# get some config values if required...
		if ( !$Param{RelevantStates} ) {
			my $RelevantStateNamesArrRef =
				$Kernel::OM->Get('Kernel::Config')->Get('Ticket::EscalationDisabled::RelevantStates');
				
			if ( ref($RelevantStateNamesArrRef) eq 'ARRAY' ) {
				my $RelevantStateNamesArrStrg = join( ',', @{$RelevantStateNamesArrRef} );
				my %StateListHash = $Kernel::OM->Get('Kernel::System::State')->StateList( UserID => 1 );
				for my $CurrStateID ( keys(%StateListHash) ) {
					if ( $RelevantStateNamesArrStrg =~ /(^|.*,)$StateListHash{$CurrStateID}(,.*|$)/ ) {
						$Param{RelevantStates}->{$CurrStateID} = $StateListHash{$CurrStateID};
					}
				}
			}
		}
		my %RelevantStates = ();
		if ( ref( $Param{RelevantStates} ) eq 'HASH' ) {
			%RelevantStates = %{ $Param{RelevantStates} };
		}
		#####################################################################################################
		
		
		TIME:
		for my $Key ( sort keys %Map ) {

			next TIME if !$Ticket{$Key};

			# if it's a paused SLA state and it's Solution Escalation key
			if ($RelevantStates{ $Ticket{StateID} } && $Key =~ /Solution/ ){
				$Data{ $Map{$Key} . 'TimeDestinationTime' } = $Ticket{$Key};
				$Data{ $Map{$Key} . 'TimeDestinationDate' } = $TimeObject->SystemTime2TimeStamp(
					SystemTime => $Ticket{$Key},
					);
				$Data{ $Map{$Key} . 'TimeWorkingTime' }     = 100000000000000;
				$Data{ $Map{$Key} . 'Time' }                = 100000000000000;
				next TIME;
			}

			# get time before or over escalation (escalation_destination_unixtime - now)
			my $TimeTillEscalation = $Ticket{$Key} - $Time;

			# ticket is not escalated till now ($TimeTillEscalation > 0)
			my $WorkingTime = 0;
			if ( $TimeTillEscalation > 0 ) {

				$WorkingTime = $TimeObject->WorkingTime(
					StartTime => $Time,
					StopTime  => $Ticket{$Key},
					Calendar  => $Escalation{Calendar},
				);

				# extract needed data
				my $Notify = $Escalation{ $Map{$Key} . 'Notify' };
				my $Time   = $Escalation{ $Map{$Key} . 'Time' };

				# set notification if notify % is reached
				if ( $Notify && $Time ) {

					my $Reached = 100 - ( $WorkingTime / ( $Time * 60 / 100 ) );

					if ( $Reached >= $Notify ) {
						$Data{ $Map{$Key} . 'TimeNotification' } = 1;
					}
				}
			}

			# ticket is overtime ($TimeTillEscalation < 0)
			else {
				$WorkingTime = $TimeObject->WorkingTime(
					StartTime => $Ticket{$Key},
					StopTime  => $Time,
					Calendar  => $Escalation{Calendar},
				);
				$WorkingTime = "-$WorkingTime";

				# set escalation
				$Data{ $Map{$Key} . 'TimeEscalation' } = 1;
			}
			my $DestinationDate = $TimeObject->SystemTime2TimeStamp(
				SystemTime => $Ticket{$Key},
			);
			$Data{ $Map{$Key} . 'TimeDestinationTime' } = $Ticket{$Key};
			$Data{ $Map{$Key} . 'TimeDestinationDate' } = $DestinationDate;
			$Data{ $Map{$Key} . 'TimeWorkingTime' }     = $WorkingTime;
			$Data{ $Map{$Key} . 'Time' }                = $TimeTillEscalation;

			# set global escalation attributes (set the escalation which is the first in time)
			if (
				!$Data{EscalationDestinationTime}
				|| $Data{EscalationDestinationTime} > $Ticket{$Key}
				)
			{
				$Data{EscalationDestinationTime} = $Ticket{$Key};
				$Data{EscalationDestinationDate} = $DestinationDate;
				$Data{EscalationTimeWorkingTime} = $WorkingTime;
				$Data{EscalationTime}            = $TimeTillEscalation;

				# escalation time in readable way
				$Data{EscalationDestinationIn} = '';
				$WorkingTime = abs($WorkingTime);
				if ( $WorkingTime >= 3600 ) {
					$Data{EscalationDestinationIn} .= int( $WorkingTime / 3600 ) . 'h ';
					$WorkingTime = $WorkingTime
						- ( int( $WorkingTime / 3600 ) * 3600 );    # remove already shown hours
				}
				if ( $WorkingTime <= 3600 || int( $WorkingTime / 60 ) ) {
					$Data{EscalationDestinationIn} .= int( $WorkingTime / 60 ) . 'm';
				}
			}
		}

		return %Data;
	}


    # reset all warnings
}

1;
