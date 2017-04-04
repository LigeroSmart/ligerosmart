# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::MasterSlave;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CheckItem',
    'Kernel::System::CustomerUser',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::LinkObject',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Time',
);

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data Event Config)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );

            return;
        }
    }
    if ( !$Param{Data}->{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Data->{TicketID}!"
        );

        return;
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket attributes
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        DynamicFields => 1,
    );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get master/slave dynamic field
    my $MasterSlaveDynamicField = $ConfigObject->Get('MasterSlave::DynamicField');

    # check if it's a master/slave ticket
    return 1 if !$Ticket{ 'DynamicField_' . $MasterSlaveDynamicField };
    return 1 if $Ticket{ 'DynamicField_' . $MasterSlaveDynamicField } !~ /^(master|yes)$/i;

    # get link object
    my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');

    # find slaves
    my %Links = $LinkObject->LinkKeyList(
        Object1   => 'Ticket',
        Key1      => $Param{Data}->{TicketID},
        Object2   => 'Ticket',
        State     => 'Valid',
        Type      => 'ParentChild',              # (optional)
        Direction => 'Target',                   # (optional) default Both (Source|Target|Both)
        UserID    => $Param{UserID},
    );
    my @TicketIDs;
    TICKETID:
    for my $TicketID ( sort keys %Links ) {
        next TICKETID if !$Links{$TicketID};

        # just take ticket with slave attributes for action
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 1,
        );

        my $TicketValue = $Ticket{ 'DynamicField_' . $MasterSlaveDynamicField };
        next TICKETID if !$TicketValue;
        next TICKETID if $TicketValue !~ /^SlaveOf:(.*?)$/;

        # remember ticket id
        push @TicketIDs, $TicketID;
    }

    # no slaves
    if ( !@TicketIDs ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "No Slaves of ticket $Ticket{TicketID}!",
        );

        return 1;
    }

    # get ticket object
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    # auto response action
    if ( $Param{Event} eq 'ArticleSend' ) {
        my @Index = $TicketObject->ArticleIndex( TicketID => $Param{Data}->{TicketID} );

        return 1 if !@Index;

        my %Article = $TicketObject->ArticleGet( ArticleID => $Index[-1] );

        # check if the send mail is of type forward
        my $IsForward = $Self->_ArticleHistoryTypeGiven(
            TicketID    => $Param{Data}->{TicketID},
            ArticleID   => $Article{ArticleID},
            HistoryType => 'Forward',
            UserID      => $Param{UserID},
        );

        # if the SysConfig is disabled and the new article is an forward article
        # then we don't want to have the forward for the slave tickets
        my $ForwardSlaves = $ConfigObject->Get('MasterSlave::ForwardSlaves');

        return 1 if $IsForward && !$ForwardSlaves;

        # mark ticket to prevent a loop
        $TicketObject->HistoryAdd(
            TicketID     => $Param{Data}->{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType  => 'Misc',
            Name         => 'MasterTicketAction: ArticleSend',
        );

        # just a flag for know when the first slave ticket is present
        my $FirstSlaveTicket = 1;
        my $TmpArticleBody;

        # perform action on linked tickets
        TICKETID:
        for my $TicketID (@TicketIDs) {
            my $CheckSuccess = $Self->_LoopCheck(
                TicketID => $TicketID,
                UserID   => $Param{UserID},
                String   => 'MasterTicketAction: ArticleSend',
            );
            next TICKETID if !$CheckSuccess;

            my %TicketSlave = $TicketObject->TicketGet(
                TicketID => $TicketID,
            );

            # try to get the customer data of the slave ticket
            my %Customer;
            if ( $TicketSlave{CustomerUserID} ) {
                %Customer = $CustomerUserObject->CustomerUserDataGet(
                    User => $TicketSlave{CustomerUserID},
                );
            }

            my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

            # check if customer email is valid
            if (
                $Customer{UserEmail}
                && !$CheckItemObject->CheckEmail( Address => $Customer{UserEmail} )
                )
            {
                $Customer{UserEmail} = '';
            }

            # if we can't find a valid UserEmail in CustomerData
            # we have to get the last Article with SenderType 'customer'
            # and get the UserEmail
            if ( !$Customer{UserEmail} ) {
                my @Index = $TicketObject->ArticleGet(
                    TicketID          => $TicketID,
                    ArticleSenderType => ['customer'],
                );

                if (@Index) {
                    $Customer{UserEmail} = $Index[-1]{From};
                }
            }

            # check if customer email is valid
            if (
                $Customer{UserEmail}
                && !$CheckItemObject->CheckEmail( Address => $Customer{UserEmail} )
                )
            {
                $Customer{UserEmail} = '';
            }

            # if we still have no UserEmail, drop an error
            if ( !$Customer{UserEmail} ) {
                $TicketObject->HistoryAdd(
                    TicketID     => $TicketID,
                    CreateUserID => $Param{UserID},
                    HistoryType  => 'Misc',
                    Name =>
                        "MasterTicket: no customer email found, send no master message to customer.",
                );
                next TICKETID;
            }

            # set the new To for ArticleSend
            $Article{To} = $Customer{UserEmail};

            # rebuild subject
            $ConfigObject->Set(
                Key   => 'Ticket::SubjectCleanAllNumbers',
                Value => 1,
            );
            my $Subject = $TicketObject->TicketSubjectBuild(
                TicketNumber => $TicketSlave{TicketNumber},
                Subject      => $Article{Subject} || '',
            );

            # exchange Customer from MasterTicket for the one into the SlaveTicket
            my $ReplaceOnNoteTypes = $ConfigObject->Get('ReplaceCustomerRealNameOnSlaveArticleTypes');
            if (
                defined $ReplaceOnNoteTypes->{ $Article{ArticleType} } &&
                $ReplaceOnNoteTypes->{ $Article{ArticleType} } eq '1'
                )
            {
                if ($FirstSlaveTicket) {
                    $FirstSlaveTicket = 0;
                    $TmpArticleBody   = $Article{Body};
                }
                else {
                    # get body from temporal in oder to get it
                    # without changes from previous slave tickets
                    $Article{Body} = $TmpArticleBody;
                }

                my $Search = $CustomerUserObject->CustomerName(
                    UserLogin => $Article{CustomerUserID},
                ) || '';
                my $Replace = $CustomerUserObject->CustomerName(
                    UserLogin => $TicketSlave{CustomerUserID},
                ) || '';
                if ( $Search && $Replace ) {
                    $Article{Body} =~ s{ \Q$Search\E }{$Replace}xmsg;
                }
            }

            # send article again
            $TicketObject->ArticleSend(
                %Article,
                Subject        => $Subject,
                Cc             => '',
                Bcc            => '',
                HistoryType    => 'SendAnswer',
                HistoryComment => "Sent answer to '$Article{To}' based on master ticket.",
                TicketID       => $TicketID,
                UserID         => $Param{UserID},
            );
        }
        return 1;
    }

    # article create
    elsif ( $Param{Event} eq 'ArticleCreate' ) {
        my @Index = $TicketObject->ArticleIndex( TicketID => $Param{Data}->{TicketID} );

        return 1 if !@Index;

        my %Article = $TicketObject->ArticleGet( ArticleID => $Index[-1] );

        # mark ticket to prevent a loop
        $TicketObject->HistoryAdd(
            TicketID     => $Param{Data}->{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType  => 'Misc',
            Name         => "MasterTicketAction: ArticleCreate",
        );

        # do not process email articles (already done in ArticleSend event!)
        if ( $Article{SenderType} eq 'agent' && $Article{ArticleType} eq 'email-external' ) {

            return 1;
        }

        # set the same state, but only for notes
        if ( $Article{ArticleType} !~ /^note-/i ) {

            return 1;
        }

        # perform action on linked tickets
        TICKETID:
        for my $TicketID (@TicketIDs) {
            my $CheckSuccess = $Self->_LoopCheck(
                TicketID => $TicketID,
                UserID   => $Param{UserID},
                String   => 'MasterTicketAction: ArticleCreate',
            );
            next TICKETID if !$CheckSuccess;

            # article create
            $TicketObject->ArticleCreate(
                %Article,
                HistoryType    => 'AddNote',
                HistoryComment => 'Added article based on master ticket.',
                TicketID       => $TicketID,
                UserID         => $Param{UserID},
            );
        }

        return 1;
    }

    # state action
    elsif ( $Param{Event} eq 'TicketStateUpdate' ) {

        # mark ticket to prevent a loop
        $TicketObject->HistoryAdd(
            TicketID     => $Param{Data}->{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType  => 'Misc',
            Name         => "MasterTicketAction: TicketStateUpdate",
        );

        # perform action on linked tickets
        TICKETID:
        for my $TicketID (@TicketIDs) {
            my $CheckSuccess = $Self->_LoopCheck(
                TicketID => $TicketID,
                UserID   => $Param{UserID},
                String   => 'MasterTicketAction: TicketStateUpdate',
            );
            next TICKETID if !$CheckSuccess;

            # set the same state
            $TicketObject->TicketStateSet(
                StateID  => $Ticket{StateID},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }

        return 1;
    }

    # set pending time
    elsif ( $Param{Event} eq 'TicketPendingTimeUpdate' ) {

        # mark ticket to prevent a loop
        $TicketObject->HistoryAdd(
            TicketID     => $Param{Data}->{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType  => 'Misc',
            Name         => "MasterTicketAction: TicketPendingTimeUpdate",
        );

        # perform action on linked tickets
        TICKETID:
        for my $TicketID (@TicketIDs) {
            my $CheckSuccess = $Self->_LoopCheck(
                TicketID => $TicketID,
                UserID   => $Param{UserID},
                String   => 'MasterTicketAction: TicketPendingTimeUpdate',
            );

            next TICKETID if !$CheckSuccess;

            # set the same pending time
            my $TimeStamp = '0000-00-00 00:00:00';
            if ( $Ticket{RealTillTimeNotUsed} ) {
                my ( $Sec, $Min, $Hour, $Day, $Month, $Year )
                    = $Kernel::OM->Get('Kernel::System::Time')->SystemTime2Date(
                    SystemTime => $Ticket{RealTillTimeNotUsed},
                    );
                $TimeStamp = "$Year-$Month-$Day $Hour:$Min:$Sec";
            }
            $TicketObject->TicketPendingTimeSet(
                String   => $TimeStamp,
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        return 1;
    }

    # priority action
    elsif ( $Param{Event} eq 'TicketPriorityUpdate' ) {

        # mark ticket to prevent a loop
        $TicketObject->HistoryAdd(
            TicketID     => $Param{Data}->{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType  => 'Misc',
            Name         => "MasterTicketAction: TicketPriorityUpdate",
        );

        # perform action on linked tickets
        TICKETID:
        for my $TicketID (@TicketIDs) {
            my $CheckSuccess = $Self->_LoopCheck(
                TicketID => $TicketID,
                UserID   => $Param{UserID},
                String   => 'MasterTicketAction: TicketPriorityUpdate',
            );
            next TICKETID if !$CheckSuccess;

            # set the same state
            $TicketObject->TicketPrioritySet(
                TicketID   => $TicketID,
                PriorityID => $Ticket{PriorityID},
                UserID     => $Param{UserID},
            );
        }
        return 1;
    }

    # owner action
    elsif ( $Param{Event} eq 'TicketOwnerUpdate' ) {

        # mark ticket to prevent a loop
        $TicketObject->HistoryAdd(
            TicketID     => $Param{Data}->{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType  => 'Misc',
            Name         => "MasterTicketAction: TicketOwnerUpdate",
        );

        # perform action on linked tickets
        TICKETID:
        for my $TicketID (@TicketIDs) {
            my $CheckSuccess = $Self->_LoopCheck(
                TicketID => $TicketID,
                UserID   => $Param{UserID},
                String   => 'MasterTicketAction: TicketOwnerUpdate',
            );
            next TICKETID if !$CheckSuccess;

            # set the same state
            $TicketObject->TicketOwnerSet(
                TicketID           => $TicketID,
                NewUserID          => $Ticket{OwnerID},
                SendNoNotification => 0,
                UserID             => $Param{UserID},
            );
        }
        return 1;
    }

    # responsible action
    elsif ( $Param{Event} eq 'TicketResponsibleUpdate' ) {

        # mark ticket to prevent a loop
        $TicketObject->HistoryAdd(
            TicketID     => $Param{Data}->{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType  => 'Misc',
            Name         => "MasterTicketAction: TicketResponsibleUpdate",
        );

        # perform action on linked tickets
        TICKETID:
        for my $TicketID (@TicketIDs) {
            my $CheckSuccess = $Self->_LoopCheck(
                TicketID => $TicketID,
                UserID   => $Param{UserID},
                String   => 'MasterTicketAction: TicketResponsibleUpdate',
            );
            next TICKETID if !$CheckSuccess;

            # set the same state
            $TicketObject->TicketResponsibleSet(
                TicketID           => $TicketID,
                NewUserID          => $Ticket{ResponsibleID},
                SendNoNotification => 0,
                UserID             => $Param{UserID},
            );
        }
        return 1;
    }

    # unlock/lock action
    elsif ( $Param{Event} eq 'TicketLockUpdate' ) {

        # mark ticket to prevent a loop
        $TicketObject->HistoryAdd(
            TicketID     => $Param{Data}->{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType  => 'Misc',
            Name         => "MasterTicketAction: TicketLockUpdate",
        );

        # perform action on linked tickets
        TICKETID:
        for my $TicketID (@TicketIDs) {
            my $CheckSuccess = $Self->_LoopCheck(
                TicketID => $TicketID,
                UserID   => $Param{UserID},
                String   => 'MasterTicketAction: TicketLockUpdate',
            );
            next TICKETID if !$CheckSuccess;

            # set the same state
            $TicketObject->TicketLockSet(
                Lock               => $Ticket{Lock},
                TicketID           => $TicketID,
                SendNoNotification => 1,
                UserID             => $Param{UserID},
            );
        }
        return 1;
    }
    return 1;
}

sub _LoopCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TicketID String UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );

            return;
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my @Lines = $TicketObject->HistoryGet(
        TicketID => $Param{TicketID},
        UserID   => $Param{UserID},
    );

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    for my $Data ( reverse @Lines ) {
        if ( $Data->{HistoryType} eq 'Misc' && $Data->{Name} eq $Param{String} ) {
            my $TimeCreated = $TimeObject->TimeStamp2SystemTime(
                String => $Data->{CreateTime}
            ) + 15;
            my $TimeCurrent = $TimeObject->SystemTime();
            if ( $TimeCreated > $TimeCurrent ) {
                $TicketObject->HistoryAdd(
                    TicketID     => $Param{TicketID},
                    CreateUserID => $Param{UserID},
                    HistoryType  => 'Misc',
                    Name         => "MasterTicketLoop: stopped",
                );

                return;
            }
        }
    }
    return 1;
}

=item _ArticleHistoryTypeGiven()

Check if history type for article is given

    my $IsHistoryType = $EventObject->_ArticleHistoryTypeGiven(
        TicketID    => $TicketID,
        ArticleID   => $ArticleID,
        HistoryType => 'Forward',
        UserID      => $UserID,
    );

Returns

   my $IsHistoryType = 1;

=cut

sub _ArticleHistoryTypeGiven {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TicketID ArticleID HistoryType UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $TicketID    = $Param{TicketID};
    my $ArticleID   = $Param{ArticleID};
    my $HistoryType = $Param{HistoryType};
    my $UserID      = $Param{UserID};

    my @Lines = $TicketObject->HistoryGet(
        TicketID => $TicketID,
        UserID   => $UserID,
    );

    my $Matched = 0;

    return $Matched if !IsArrayRefWithData( \@Lines );

    HISTORYDATA:
    for my $HistoryData ( reverse @Lines ) {
        next HISTORYDATA if $HistoryData->{ArticleID} != $ArticleID;
        next HISTORYDATA if $HistoryData->{HistoryType} ne $HistoryType;

        $Matched = 1;

        last HISTORYDATA;
    }

    return $Matched;
}

1;
