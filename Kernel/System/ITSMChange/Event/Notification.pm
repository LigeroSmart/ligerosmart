# --
# Kernel/System/ITSMChange/Event/Notification.pm - a event module to send notifications
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: Notification.pm,v 1.12 2010-01-07 11:57:16 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Event::Notification;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::Notification;
use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.12 $) [1];

=head1 NAME

Kernel::System::ITSMChange::Event::Notification - ITSM change management notification lib

=head1 SYNOPSIS

Event handler module for notifications for changes and workorders.

=head1 PUBLIC INTERFACE

=over 4

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::ITSMChange::Event::Notification;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $NotificationEventObject = Kernel::System::ITSMChange::Event::Notification->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (
        qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{ChangeObject}             = Kernel::System::ITSMChange->new( %{$Self} );
    $Self->{WorkOrderObject}          = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );
    $Self->{ChangeNotificationObject} = Kernel::System::ITSMChange::Notification->new( %{$Self} );
    $Self->{LinkObject}               = Kernel::System::LinkObject->new( %{$Self} );

    # TODO: find better was to look up event ids
    $Self->{HistoryObject} = Kernel::System::ITSMChange::History->new( %{$Self} );

    return $Self;
}

=item Run()

The C<Run()> method handles the events and sends notifications about
the given change or workorder object.

It returns 1 on success, C<undef> otherwise.

    my $Success = $NotificationEventObject->Run(
        Event => 'ChangeUpdatePost',
        Data => {
            ChangeID    => 123,
            ChangeTitle => 'test',
        },
        Config => {
            Event       => '(ChangeAddPost|ChangeUpdatePost|ChangeCABUpdatePost|ChangeCABDeletePost|ChangeDeletePost)',
            Module      => 'Kernel::System::ITSMChange::Event::NotificationEvent',
            Transaction => '0',
        },
        UserID => 1,
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Data Event Config UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # in notification event handling we use the event name without the trailing 'Post'.
    my $Event = $Param{Event};
    $Event =~ s{ Post \z }{}xms;

    # distinguish between Change and WorkOrder events, based on naming convention
    my ($Type) = $Event =~ m{ \A (Change|WorkOrder) }xms;
    if ( !$Type ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not determine the object type for the event '$Event'!"
        );
        return;
    }

    # get the event id, for looking up the list of relevant rules
    my $EventID = $Self->{HistoryObject}->HistoryTypeLookup( HistoryType => $Event );
    if ( !$EventID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Encountered unknown event '$Event'!"
        );
        return;
    }

    my $NotificationRuleIDs = $Self->{ChangeNotificationObject}->NotificationRuleSearch(
        EventID => $EventID,
    );
    if ( !$NotificationRuleIDs ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not get notification rules for the event '$Event'!"
        );
        return;
    }

    # in case of an update, we have the old data for comparison
    my $OldData = $Param{Data}->{"Old${Type}Data"};

    # The notification rules are based on names, while the ChangeUpdate-Function
    # primarily cares about IDs. So there needs to be a mapping.
    my %Name2ID = (
        ChangeState => 'ChangeStateID',
    );

    # loop over the notification rules and check the condition
    RULE_ID:
    for my $RuleID ( @{$NotificationRuleIDs} ) {
        my $Rule = $Self->{ChangeNotificationObject}->NotificationRuleGet(
            ID => $RuleID,
        );

        my $Attribute = $Rule->{Attribute} || '';
        if ( $Name2ID{$Attribute} ) {
            $Attribute = $Name2ID{$Attribute};
        }

        # no notification if the attribute is not relevant
        next RULE_ID if $Attribute && !exists $Param{Data}->{$Attribute};

        # in case of an update, check whether the attribute has changed
        if (
            $Attribute
            && ( $Event eq 'ChangeUpdate' || $Event eq 'WorkOrderUpdate' )
            )
        {
            my $HasChanged = $Self->_HasFieldChanged(
                New => $Param{Data}->{$Attribute},
                Old => $OldData->{$Attribute},
            );

            next RULE_ID if !$HasChanged;
        }

        # get the string to match against
        # TODO: support other combinations, maybe use GeneralCatalog directly
        my $NewFieldContent = $Attribute ? $Param{Data}->{$Attribute} : '';

        if ( $Attribute eq 'ChangeStateID' ) {
            $NewFieldContent = $Self->{ChangeObject}->ChangeStateLookup(
                ChangeStateID => $NewFieldContent,
            );
        }

        # should the notification be sent ?
        # the x-modifier is harmful here, as $Rule->{Rule} can contain spaces
        next RULE_ID if defined $Rule->{Rule} && $NewFieldContent !~ m/^$Rule->{Rule}$/;

        # determine list of agents and customers
        my $AgentAndCustomerIDs = $Self->_AgentAndCustomerIDsGet(
            Recipients  => $Rule->{Recipients},
            ChangeID    => $Param{ChangeID},
            WorkOrderID => $Param{WorkOrderID},
            UserID      => $Param{UserID},
        );

        next RULE_ID if !$AgentAndCustomerIDs;

        $Self->{ChangeNotificationObject}->NotificationSend(
            %{$AgentAndCustomerIDs},
            Type   => $Type,
            Event  => $Event,
            UserID => $Param{UserID},
            Data   => $Param{Data},
        );
    }

    return 1;
}

=begin Internal:

=item _HasFieldChanged()

This method checks whether a field was changed or not. It returns 1 when field
was changed, 0 otherwise

    my $FieldHasChanged = $NotificationEventObject->_HasFieldChanged(
        Old => 'old value', # can be array reference or hash reference as well
        New => 'new value', # can be array reference or hash reference as well
    );

=cut

sub _HasFieldChanged {
    my ( $Self, %Param ) = @_;

    # field has changed when either 'new' or 'old is not set
    return 1 if !( $Param{New} && $Param{Old} ) && ( $Param{New} || $Param{Old} );

    # field has not changed when both values are empty
    return if !$Param{New} && !$Param{Old};

    # return result of 'eq' when both params are scalars
    return $Param{New} ne $Param{Old} if !ref( $Param{New} ) && !ref( $Param{Old} );

    # a field has changed when 'ref' is different
    return 1 if ref( $Param{New} ) ne ref( $Param{Old} );

    # check hashes
    if ( ref $Param{New} eq 'HASH' ) {

        # field has changed when number of keys are different
        return 1 if scalar keys %{ $Param{New} } != scalar keys %{ $Param{Old} };

        # check the values for each key
        for my $Key ( keys %{ $Param{New} } ) {
            return 1 if $Param{New}->{$Key} ne $Param{Old}->{$Key};
        }
    }

    # check arrays
    if ( ref $Param{New} eq 'ARRAY' ) {

        # changed when number of elements differ
        return 1 if scalar @{ $Param{New} } != scalar @{ $Param{Old} };

        # check each element
        for my $Index ( 0 .. $#{ $Param{New} } ) {
            return 1 if $Param{New}->[$Index] ne $Param{Old}->[$Index];
        }
    }

    # field has not been changed
    return 0;
}

=item _AgentAndCustomerIDsGet()

Get the agent and customer IDs from the recipient list.

    my $AgentAndCustomerIDs = $HistoryObject->_AgentAndCustomerIDsGet(
        Recipients => ['ChangeBuilder', 'ChangeManager'],
    );

returns

    $AgentAndCustomerIDs = {
        AgentIDs    => [ 2, 4 ],
        CustomerIDs => [],
    };

=cut

sub _AgentAndCustomerIDsGet {
    my ( $Self, %Param ) = @_;

    my ( @AgentIDs, @CustomerIDs );

    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    for my $Recipient ( @{ $Param{Recipients} } ) {

        if (
            $Recipient eq 'ChangeBuilder'
            || $Recipient eq 'ChangeManager'
            )
        {
            push @AgentIDs, $Change->{ $Recipient . 'ID' };
        }
        elsif ( $Recipient eq 'CABCustomers' ) {
            push @CustomerIDs, @{ $Change->{CABCustomers} };
        }
        elsif ( $Recipient eq 'CABAgents' ) {
            push @AgentIDs, @{ $Change->{CABAgents} };
        }
        elsif ( $Recipient eq 'WorkOrderAgent' ) {
            if ( !$Param{WorkOrderID} ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Recipient WorkOrderAgent is only valid for workorder events.!",
                );
            }
            else {
                my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
                    WorkOrderID => $Param{WorkOrderID},
                    UserID      => $Param{UserID},
                );

                push @AgentIDs, $WorkOrder->{WorkOrderAgentID};
            }
        }
        elsif ( $Recipient eq 'WorkOrderAgents' ) {

            # loop over the workorders of a change and get their workorder agents
            for my $WorkOrderID ( @{ $Change->{WorkOrderIDs} } ) {
                my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
                    WorkOrderID => $WorkOrderID,
                    UserID      => $Param{UserID},
                );

                push @AgentIDs, $WorkOrder->{WorkOrderAgentID};
            }
        }
        elsif ( $Recipient eq 'ChangeInitiators' ) {

            # get linked objects which are directly linked with this change object
            my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
                Object => 'ITSMChange',
                Key    => $Param{ChangeID},
                State  => 'Valid',
                UserID => $Param{UserID},
            );

            # get change initiators (customer users of linked tickets)
            # This should be the same list a displayed in ChangeZoom.
            my $TicketsRef = $LinkListWithData->{Ticket} || {};
            for my $LinkType ( keys %{$TicketsRef} ) {

                my $TicketRef = $TicketsRef->{$LinkType}->{Source};
                for my $TicketID ( keys %{$TicketRef} ) {

                    # get id of customer user
                    my $CustomerUserID = $TicketRef->{$TicketID}->{CustomerUserID};

                    # if a customer
                    if ($CustomerUserID) {
                        push @CustomerIDs, $CustomerUserID;
                    }
                    else {
                        push @AgentIDs, $TicketRef->{$TicketID}->{OwnerID};
                    }
                }
            }
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Unknown recipient '$Recipient'!",
            );
            return;
        }
    }

    # remove empty IDs
    @AgentIDs    = grep {$_} @AgentIDs;
    @CustomerIDs = grep {$_} @CustomerIDs;

    return {
        AgentIDs    => \@AgentIDs,
        CustomerIDs => \@CustomerIDs,
    };
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.12 $ $Date: 2010-01-07 11:57:16 $

=cut
