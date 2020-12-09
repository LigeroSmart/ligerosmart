# --
# Kernel/System/OLA.pm - lib for OLA accouting and control
# Copyright (C) 2001-2017 Complemento - Liberdade e Tecnologia, http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::OLA;

use POSIX;
use strict;
use warnings;
use Data::Dumper;
our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Valid',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
);

=head1 NAME

Kernel::System::OLA - OLA lib

=head1 SYNOPSIS

OLA helper functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $OLAObject = $Kernel::OM->Get('Kernel::System::OLA');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}


=item CleanTicketQueueOlaInformation()

Clean the OLA Information from a Ticket.
If you don't inform QueueID parameter, all Queues OLA will cleaned.

    my $Success = $OLAObject->CleanQueueOlaInformation(
        Ticket       => %Ticket,  # Required, Ticket structure, obtained
                                  # with TicketGet and DynamicFields => 1 Parameter
        QueueID      => 123       # Optional, if not informed, all Queues OLA will 
                                  # be erased
    );

=cut
sub CleanQueueOlaInformation {
    my ( $Self, %Param ) = @_;

    for (qw(Ticket)) {
        if ( !defined( $Param{$_} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $Regex = 'DynamicField_OlaQueue.*';
    if(defined $Param{QueueID}){
        $Regex = "DynamicField_OlaQueue$Param{QueueID}(State|Diff|Destination)";
    }

    for my $TicketAttribute (grep $_ =~ /^$Regex/,keys %{$Param{Ticket}})
    {
            $TicketAttribute =~ s/DynamicField_//gi;

            # get dynamic field config
            my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
                Name => $TicketAttribute,
            );
            my $Success = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueDelete(
                FieldID  => $DynamicField->{ID},
                ObjectID => $Param{Ticket}->{TicketID},
                UserID   => 1,
            );
    }
}

=item GetQueuesAccountedTime()

Calculate the time used by each queue for a ticket, using ticket history.

    my %QueueAccountedTime = $OLAObject->GetQueuesAccountedTime(
        TicketID        => 123,
        OlaQueues       => %OlaQueues,    # Parsed JSON to Hash obtained by $SLAPreferences{'OLA_Queues'},
        Calendar        => '3' # Optional, Calendar to be used to calculation
        NotAccountedTicketStates => [2 , 3 ,4], # ARRAY with not accounted ticket state
                                                # Optional, it will get if not passed
    );
    
Returns {
    "32" => {  # QueueID
        DestinationTime => '2017-10-01 20:00:00', # LastDestinationTime of this Queue
        Diff            => -50,
        Used            => 200, # Total accounted time used by the queue
    },
    "22" => {  # QueueID
        DestinationTime => '2017-10-01 20:00:00', # LastDestinationTime of this Queue
        Diff            => -50,
        Used            => 200, # Total accounted time used by the queue
    }
}

=cut
sub GetQueuesAccountedTime {
    my ( $Self, %Param ) = @_;

    for (qw(TicketID OlaQueues)) {
        if ( !defined( $Param{$_} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
    my $SystemTime = $TimeObject->SystemTime();

    my %QueueAccountedTime;
    my $Calendar = $Param{Calendar} || '';
    my @OlaQueueIDs = keys %{$Param{OlaQueues}};

    my @NotAccountedTicketStates;
    # Check if we have NotAccountedTicketStates (states which we do not account OLA)
    if (! defined $Param{NotAccountedTicketStates})
    {
        @NotAccountedTicketStates = $Self->GetNotAccountedTicketStates();
    } else {
        @NotAccountedTicketStates = $Param{NotAccountedTicketStates};
    }
    # Get Ticket History Lines
    my @HistoryLines = $Kernel::OM->Get('Kernel::System::Ticket')->HistoryGet(
       TicketID   => $Param{TicketID},
       UserID     => 1,
    );

    my %PreviousHistoryLine;

    # History changes that we need to deal with
    my @HistoryTypes = qw(NewTicket StateUpdate Move);

    HISTORYLINE:
    for my $CurHistoryLineRef (@HistoryLines){
        # Ignore History lines with history types we don't care
        if ((scalar grep $_ eq $CurHistoryLineRef->{HistoryType},@HistoryTypes) == 0){
           next HISTORYLINE;
        }
        
        if ($CurHistoryLineRef->{HistoryType} eq 'NewTicket') 
        {
            TicketCreation:
            # If the current queue is not part of OlaQueueIDs or if states does not count OLA, go to next line
            if ((scalar grep $_ == $CurHistoryLineRef->{QueueID},@OlaQueueIDs) == 0 ||
                (scalar grep $_ eq $CurHistoryLineRef->{StateID},@NotAccountedTicketStates) ne '0'){
               next HISTORYLINE;
            }
            
            # Se o estado atual conta OLA, marca as variaveis da fila
            $QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{Diff}=$Param{OlaQueues}->{$CurHistoryLineRef->{QueueID}}->{Time};
            # Store destination and diff for later calculation, so we do not need to calculate destination every iteration
            $QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{DestinationFrom} = $CurHistoryLineRef->{CreateTime};
            $QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{DestinationDiff} = $QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{Diff};
            
        } elsif ($CurHistoryLineRef->{HistoryType} eq 'Move') {
            TicketQueueUpdate:

            # Calculos para a fila anterior:
            # Se fila anterior definida e a mesma conta OLA:
            if (defined $PreviousHistoryLine{QueueID} &&
                (scalar grep $_ == $PreviousHistoryLine{QueueID},@OlaQueueIDs) > 0)
            {
                # Se estado anterior conta OLA, diminui o Diff
                if ((scalar grep $_ eq $PreviousHistoryLine{StateID}, @NotAccountedTicketStates) eq '0')
                {
                    $QueueAccountedTime{$PreviousHistoryLine{QueueID}}->{Diff} -= 
                    ($TimeObject->WorkingTime(
                        StartTime => $TimeObject->TimeStamp2SystemTime(String => $PreviousHistoryLine{CreateTime}),
                        StopTime  => $TimeObject->TimeStamp2SystemTime(String => $CurHistoryLineRef->{CreateTime}),
                        Calendar  => $Calendar
                    )/60);
                }

            }

            # Fila Atual: Se ela conta OLA e Se estado atual conta OLA
            if ((scalar grep $_ == $CurHistoryLineRef->{QueueID},@OlaQueueIDs) > 0 &&
                (scalar grep $_ eq $CurHistoryLineRef->{StateID},@NotAccountedTicketStates) eq '0'){

                # Se Diff ainda não foi definido, define pela primeira vez:
                if (!defined $QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{Diff})
                {
                    $QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{Diff}=$Param{OlaQueues}->{$CurHistoryLineRef->{QueueID}}->{Time};
                }

                # Se Diff > 0, redefine o DiffFrom e o Diff que será utilizado para o calculo final, evitando recalcular a cada step
                if ($QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{Diff} > 0)
                {
                    $QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{DestinationFrom} = $CurHistoryLineRef->{CreateTime};
                    $QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{DestinationDiff} = $QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{Diff};
                }
            } else {
                ## TODO: Se não conta SLA na fila atual, precisamos fazer algo? Tipo um NEXT para não atualizar o "PreviousHistoryLine"? Precisamos confirmar se esta é a melhor estratégia...
                #next HISTORYLINE;
            }

            
        } elsif ($CurHistoryLineRef->{HistoryType} eq 'StateUpdate') {
            StateUpdate:
            # If the current queue is not part of OlaQueueIDs, go to next line
            if ((scalar grep $_ == $CurHistoryLineRef->{QueueID},@OlaQueueIDs) == 0){
               next HISTORYLINE;
            }
            
            # Se o estado anterior e o atual contam SLA, ou se, o estado anterior e o atual não contam, simplesmente vá para a próxima iteração
            if (   # se o estado anterior está definido e anterior e atual contam OLA
                (  defined $PreviousHistoryLine{StateID} && 
                    (scalar grep $_ eq $PreviousHistoryLine{StateID}, @NotAccountedTicketStates) eq '0' &&
                    (scalar grep $_ eq $CurHistoryLineRef->{StateID}, @NotAccountedTicketStates) eq '0' 
                ) # OU
                  ||
                 (   # Se estado anterior definido e ambos não contam OLA, ou não está definido o anterior e o atual conta OLA
                    (   defined $PreviousHistoryLine{StateID} && 
                        (scalar grep $_ eq $PreviousHistoryLine{StateID}, @NotAccountedTicketStates) ne '0' &&
                        (scalar grep $_ eq $CurHistoryLineRef->{StateID}, @NotAccountedTicketStates) ne '0' 
                    )
                    || 
                    (   ! defined $PreviousHistoryLine{StateID} && 
                          (scalar grep $_ eq $CurHistoryLineRef->{StateID}, @NotAccountedTicketStates) ne '0' 
                    )
                ) )
            {
               next HISTORYLINE;
            }
            
            # Se agora o Estado conta OLA, verifica se precisa fazer primeira definição
            if ((scalar grep $_ eq $CurHistoryLineRef->{StateID},@NotAccountedTicketStates) eq '0'){
                if (!defined $QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{Diff})
                {
                    $QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{Diff}=$Param{OlaQueues}->{$CurHistoryLineRef->{QueueID}}->{Time};
                }
                # Se Diff > 0, redefine o DiffFrom e o Diff que será utilizado para o calculo final, evitando recalcular a cada step
                if ($QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{Diff} > 0) 
                {
                    $QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{DestinationFrom} = $CurHistoryLineRef->{CreateTime};
                    $QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{DestinationDiff} = $QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{Diff};
                }
            } else {
                # Se estado atual não conta OLA:
                $QueueAccountedTime{$CurHistoryLineRef->{QueueID}}->{Diff} -= 
                    ($TimeObject->WorkingTime(
                        StartTime => $TimeObject->TimeStamp2SystemTime(String => $PreviousHistoryLine{CreateTime}),
                        StopTime  => $TimeObject->TimeStamp2SystemTime(String => $CurHistoryLineRef->{CreateTime}),
                        Calendar  => $Calendar
                    )/60);
            }
            
        }
        
        %PreviousHistoryLine = %{$CurHistoryLineRef};
    }
    
    # Ao final, verifica se ultima linha conta OLA na fila e para o estado
    # se sim, diminui o Diff
    if (defined $PreviousHistoryLine{QueueID} && 
        (scalar grep $_ == $PreviousHistoryLine{QueueID},@OlaQueueIDs) > 0 &&
        (scalar grep $_ eq $PreviousHistoryLine{StateID},@NotAccountedTicketStates) eq '0')
    {
        $QueueAccountedTime{$PreviousHistoryLine{QueueID}}->{Diff} -= 
        ($TimeObject->WorkingTime(
            StartTime => $TimeObject->TimeStamp2SystemTime(String => $PreviousHistoryLine{CreateTime}),
            StopTime  => $SystemTime,
            Calendar  => $Calendar
        )/60);
    }

    # Calcula ultimo destination de todas as filas
    for my $QueueID (keys %QueueAccountedTime){
        $QueueAccountedTime{$QueueID}->{DestinationTime} = $TimeObject->SystemTime2TimeStamp(
                SystemTime =>
                    $TimeObject->DestinationTime(
                        StartTime => $TimeObject->TimeStamp2SystemTime(String => $QueueAccountedTime{$QueueID}->{DestinationFrom}),
                        Time  => ($QueueAccountedTime{$QueueID}->{DestinationDiff} * 60),
                        Calendar  => $Calendar
                    )
                );
        delete $QueueAccountedTime{$QueueID}->{DestinationFrom};
        delete $QueueAccountedTime{$QueueID}->{DestinationDiff};
    }

    return \%QueueAccountedTime;
}



=item FastDiffAndState()

Fast process function that can be used in some places of the system to
recalculate OLA using low processing, since it does not calculate whole ticket history.

    my $NewDiff = $OLAObject->FastDiffAndState(
                                                TicketID        => $Param{ObjectID},
                                                Destination     => $Destination->[0]->{ValueDateTime},
                                                CurrentOlaState => $CurrentOlaState->[0]->{ValueText},
                                                OlaStateFieldId => $OlaStateFieldId,
                                                OlaDiffFieldId  => $Param{DynamicFieldConfig}->{ID},
    );
    
Returns the new calculated diff

=cut
sub FastDiffAndState {
    my ( $Self, %Param ) = @_;

    for (qw(TicketID Destination CurrentOlaState OlaStateFieldId OlaDiffFieldId)) {
        if ( !defined( $Param{$_} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
    my $SystemTime = $TimeObject->SystemTime();

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(TicketID => $Param{TicketID}, UserID => 1);
    my %SLA    = $Kernel::OM->Get('Kernel::System::SLA')->SLAGet(SLAID => $Ticket{SLAID}, UserID => 1);
    my %Queue    = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet(ID => $Ticket{QueueID});

    # We need to check if it's notify time (alert)
    my %Preferences = $Kernel::OM->Get('Kernel::System::SLA')->SLAPreferencesGet(
       SLAID  => $Ticket{SLAID},
       UserID => 1,
    );

    # Make sure OLA_Queues can be treat by JSON Decode
    if (!$Preferences{'OLA_Queues'} || ($Preferences{'OLA_Queues'} && $Preferences{'OLA_Queues'} eq '')){
        return '0';
    }

    # PARSE OLA Queue from this SLA
    my %OlaQueues = %{$Kernel::OM->Get('Kernel::System::JSON')->Decode(
                        Data => $Preferences{'OLA_Queues'},
                    )};
                    
    my $Calendar = $SLA{Calendar} || '';

    if($OlaQueues{$Ticket{QueueID}} && $OlaQueues{$Ticket{QueueID}}->{Calendar}){
      $Calendar = $OlaQueues{$Ticket{QueueID}}->{Calendar};
    }

    my $UnixDestination = $TimeObject->TimeStamp2SystemTime(String => $Param{Destination});

    my $From    = '';
    my $To      = '';
    my $Add     = 0;
    my $Signal  = '';
    my $NewDiff = 0;
    
    if ($UnixDestination < $SystemTime)
    {
        # Destination is in the past, we will need to check the history
        
        my %QueueOla = (
            "$Ticket{QueueID}" =>  {
                Time   => $OlaQueues{"$Ticket{QueueID}"}->{Time}   || 0,
                Notify => $OlaQueues{"$Ticket{QueueID}"}->{Notify} || '',
                Calendar => $OlaQueues{"$Ticket{QueueID}"}->{Calendar} || '',
            }
        );

        my %QueueAccountedTime = %{ $Self->GetQueuesAccountedTime(
            TicketID        => $Param{TicketID},
            OlaQueues       => \%QueueOla,
            Calendar        => $Queue{Calendar} || $SLA{Calendar} || ''
        )};
        
        $NewDiff = $QueueAccountedTime{$Ticket{QueueID}}->{Diff};
        
    } else {
        # If Destination is in the future
        $From = $SystemTime;
        $To   = $UnixDestination;

        $NewDiff = $TimeObject->WorkingTime(
            StartTime => $From,
            StopTime  => $To,
            Calendar  => $Calendar
        )/60;
    }

    my $Success = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueSet(
        FieldID  => $Param{OlaDiffFieldId},
        ObjectID => $Param{TicketID},
        Value    => [
            {
                ValueText => $NewDiff,
            },
        ],
        UserID => 1,
    );
    
    if ($Param{CurrentOlaState} ne 'In Progress - Expired'){
        my $State = '';
        # If it's not expired yet, we should calculate to check if OLA State changed
        if ($NewDiff < 0) 
        {
            $State = "In Progress - Expired";
        } else {
            
            if (defined $OlaQueues{$Ticket{QueueID}}->{"Notify"} && 
                        $OlaQueues{$Ticket{QueueID}}->{"Notify"} ne '' &&
                        $OlaQueues{$Ticket{QueueID}}->{"Notify"} > 0 &&
                        ( $NewDiff < ( $OlaQueues{$Ticket{QueueID}}->{"Time"} * (1-($OlaQueues{$Ticket{QueueID}}->{"Notify"}/100))) ) )
                        {
                # Se for positivo
                $State = 'In Progress - Alert';
            }
        }

        if ($State ne '' && $State ne $Param{CurrentOlaState}) 
        {
            my $Success = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueSet(
                FieldID  => $Param{OlaStateFieldId},
                ObjectID => $Param{TicketID},
                Value    => [
                    {
                        ValueText => $State,
                    },
                ],
                UserID => 1,
            );
        }
    }
    
    return $NewDiff;
}


=item GetTicketUsedQueues()

Gets an ARRAY of all queues where the ticket passed by.

    my @UsedQueues = $OLAObject->GetTicketUsedQueues(
        TicketID        => 123,
    );

=cut
sub GetTicketUsedQueues {
    my ( $Self, %Param ) = @_;

    for (qw(TicketID)) {
        if ( !defined( $Param{$_} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    
    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get all groups of the given user
    return if !$DBObject->Prepare(
        SQL => "select distinct(queue_id) from ticket_history where ticket_id = ?",
        Bind => [
            \$Param{TicketID},
        ],
    );

    my @UsedQueues;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @UsedQueues, $Row[0];
    }
    
    return @UsedQueues;

}


=item GetNotAccountedTicketStates()

Returns an ARRAY if not accounted states

    my @NotAccountedTicketStates = $Self>GetNotAccountedTicketStates();

=cut
sub GetNotAccountedTicketStates {
    my ( $Self, %Param ) = @_;

    # Get States which doesnot count SLA/OLA
    # If you have SlaStop AddOn from Kix or Complemento, it is under SysConfig
    # Otherwirse, you can define it at Config.pm:
    # Self->{'Ticket::EscalationDisabled::RelevantStates'} = ['Waiting Customer','Solved'];
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $StateObject = $Kernel::OM->Get('Kernel::System::State');

    my @NotAccountedTicketStates = $StateObject->StateGetStatesByType(
       StateType => ['closed', 'removed','merged' ],
       Result    => 'ID',
    );
    
    my @PausedStates;

		if(scalar $ConfigObject->Get('Ticket::EscalationDisabled::RelevantStates')){		
    my $ConfigPausedStates = $ConfigObject->Get('Ticket::EscalationDisabled::RelevantStates');
    push @PausedStates,@$ConfigPausedStates;
    
    for my $StateName (@PausedStates){
        my $StateID = $StateObject->StateLookup(
           State => $StateName,
        );
        push(@NotAccountedTicketStates,$StateID);
    }
		}
    return @NotAccountedTicketStates;
}


=item CheckAndCreateQueueOlaDynamicFields()

Verifies if the required DynamicFields for OLA controlling exists for a specific Queue.
If don't, create it!

    my $Success = $OLAObject->CheckAndCreateQueueOlaDynamicFields(
        QueueID      => 123
    );

=cut

sub CheckAndCreateQueueOlaDynamicFields(){
    my ( $Self, %Param ) = @_;
    
    # check needed stuff
    for (qw(QueueID)) {
        if ( !defined( $Param{$_} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    
    my $DynamicField = $DynamicFieldObject->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    # Verify if OlaQueueXXState Dynamic Field exists
    if (scalar (grep $_->{Name} eq 'OlaQueue'.$Param{QueueID}.'State', @{$DynamicField}) ne '0'){
        # Control fields already exists, return
        return 1;
    }

    my $NextOrderNumber = 1;
    
    my $DFConfig = $ConfigObject->Get('Ticket::Frontend::AgentTicketZoom');
    my %ExistingSetting = %{ $DFConfig->{DynamicField} || {} };    

    my @DynamicFieldsToCreate = $Self->_GetQueueOlaDynamicFieldsStructure(QueueID => $Param{QueueID});
    DYNAMICFIELD:
    for my $DynamicField (@DynamicFieldsToCreate) {
            # create a new field
            my $FieldID = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldAdd(
                InternalField => 0,
                Name          => $DynamicField->{Name},
                Label         => $DynamicField->{Label},
                FieldOrder    => $NextOrderNumber,
                FieldType     => $DynamicField->{FieldType},
                ObjectType    => $DynamicField->{ObjectType},
                Config        => $DynamicField->{Config},
                ValidID       => 1,
                UserID        => 1,
            );
            
            next DYNAMICFIELD if !$FieldID;
    }
    
    return 1;

}


=item _GetQueueOlaDynamicFieldsStructure()

Internal function to help Dynamic Fields creation for OLA control

    my @DynamicFieldStructure = $Self>_GetQueueOlaDynamicFieldsStructure(
        QueueID      => 123
    );

=cut
sub _GetQueueOlaDynamicFieldsStructure {
    my ( $Self, %Param ) = @_;

    for (qw(QueueID)) {
        if ( !defined( $Param{$_} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    
    my %Queue = $QueueObject->QueueGet(ID => $Param{QueueID});
    
    my $QueueName = substr($Queue{Name},-150);
    # define all dynamic fields for Queue Control
    my @DynamicFields = (
        {
            Name       => 'OlaQueue'.$Param{QueueID}.'State',
            Label      => "$QueueName OLA",
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => 'No',
                Link           => '',
                PossibleNone   => 1,
                PossibleValues => {
                    'In Progress'           => 'In Progress',
                    'In Progress - Alert'   => 'In Progress - Alert',
                    'In Progress - Expired' => 'In Progress - Expired',
                    'Stopped'               => 'Stopped',
                    'Stopped - Expired'     => 'Stopped - Expired',
                },
                TranslatableValues => 1,
            },
        },
        {
            Name       => 'OlaQueue'.$Param{QueueID}.'Diff',
            Label      => "$QueueName Diff",
            FieldType  => 'OlaDiff',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => '',
                Link           => '',
            },
        },
        {
            Name       => 'OlaQueue'.$Param{QueueID}.'Destination',
            Label      => "$QueueName Due Time",
            FieldType  => 'DateTime',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue  => 0,
                Link          => '',
                YearsInFuture => 5,
                YearsInPast   => 5,
                YearsPeriod   => 1,
            },
        },
    );

    return @DynamicFields;
}
1;

=back

=head1 TERMS AND CONDITIONS

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
