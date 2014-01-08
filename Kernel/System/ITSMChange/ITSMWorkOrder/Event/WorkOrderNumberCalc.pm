# --
# Kernel/System/ITSMChange/ITSMWorkOrder/Event/WorkOrderNumberCalc.pm - WorkOrderNumberCalc
# event module for ITSMWorkOrder
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderNumberCalc;

use strict;
use warnings;

=head1 NAME

use Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderNumberCalc - WorkOrderNumberCalc
event module for ITSMWorkOrder

=head1 SYNOPSIS

Event handler module for recalculation of WorkOrderNumbers in ITSMWorkOrder.

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
    use Kernel::System::ITSMChange::ITSMWorkOrder;
    use Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderNumberCalc;

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
    my $WorkOrderObject = Kernel::System::ITSMChange::ITSMWorkOrder->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );
    my $CalcObject = Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderNumberCalc->new(
        ConfigObject    => $ConfigObject,
        EncodeObject    => $EncodeObject,
        LogObject       => $LogObject,
        DBObject        => $DBObject,
        TimeObject      => $TimeObject,
        MainObject      => $MainObject,
        WorkOrderObject => $WorkOrderObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (
        qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject WorkOrderObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

=item Run()

The C<Run()> method recalculates the workorder numbers for the given workorder
and it's siblings.
This is triggered by the C<WorkOrderUpdate> and C<WorkOrderDelete> events.
This isn't triggered by C<WorkOrderAdd> events as C<WorkOrderAdd()> sets the
correct workorder number by itself.

The methods returns 1 on success, C<undef> otherwise.

    my $Success = $EventObject->Run(
        Event => 'WorkOrderUpdatePost',
        Data => {
            WorkOrderID => 123,
        },
        Config => {
            Event       => '(WorkOrderUpdatePost|WorkOrderDeletePost)',
            Module      => 'Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderNumberCalc',
            Transaction => '0',
        },
        UserID => 1,
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Data Event Config UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # check if recalculation of workorder numbers is needed
    return 1 if $Param{Data}->{NoNumberCalc};

    # handle WorkOrderUpdate and WorkOrderDeletePost events
    if ( $Param{Event} =~ m{ \A ( WorkOrderUpdatePost | WorkOrderDeletePost ) \z }xms ) {

        # recalculate WorkOrder numbers
        # the ChangeID is in the OldWorkOrderData so we do not need to make a WorkOrderGet() here
        return if !$Self->_WorkOrderNumberCalc(
            ChangeID => $Param{Data}->{OldWorkOrderData}->{ChangeID},
            UserID   => $Param{UserID},
        );
    }

    # error
    else {

        # an unknown event
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "$Param{Event} is an unknown event for this eventhandler!",
        );

        return;
    }

    return 1;
}

=begin Internal:

=item _WorkOrderNumberCalc()

This method actually recalculates the WorkOrderNumbers for the workorders of
the given change.
It returns 1 on success, C<undef> otherwise.

    my $Success = $EventObject->_WorkOrderNumberCalc(
        ChangeID => 123,
        UserID   => 1,
    );

=cut

sub _WorkOrderNumberCalc {
    my ( $Self, %Param ) = @_;

    # check for needed stuff - ChangeID and UserID
    for my $Needed (qw(ChangeID UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # define the order direction for each attribute
    my %OrderDirection = (
        PlannedStartTime => 'Up',
        PlannedEndTime   => 'Down',
        WorkOrderID      => 'Up',
    );

    # define the OrderBy array
    my @OrderBy = (
        'PlannedStartTime',
        'PlannedEndTime',
        'WorkOrderID',
    );

    # define the OrderByDirection array
    my @OrderByDirection = map { $OrderDirection{$_} } @OrderBy;

    # use WorkOrderSearch: Search for given IDs, ordered by:
    # PlannedStartTime, PlannedEndTime, WorOrderID
    my $SortedWorkOrderIDs = $Self->{WorkOrderObject}->WorkOrderSearch(
        ChangeIDs        => [ $Param{ChangeID} ],
        OrderBy          => \@OrderBy,
        OrderByDirection => \@OrderByDirection,
        UserID           => $Param{UserID},
    ) || [];

    # counter - used as WorkOrderNumber
    my $Counter = 0;

    # to store the WorkOrderIDs and their new WorkOrderNumbers
    my %NewWorkOrderNumber;

    # set new WorkOrderNumber
    WORKORDERID:
    for my $WorkOrderID ( @{$SortedWorkOrderIDs} ) {

        # increment Counter to get new WorkOrderNumber
        $Counter++;

        # get WorkOrder
        my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $WorkOrderID,
            UserID      => $Param{UserID},
        );

        # update only when Number changed - to avoid infinit loops
        next WORKORDERID if $Counter == $WorkOrder->{WorkOrderNumber};

        # store the new WorkOrderNumber for this WorkOrderID
        $NewWorkOrderNumber{$WorkOrderID} = $Counter;
    }

    # update the workorders that need a new WorkOrderNumber
    for my $WorkOrderID ( sort keys %NewWorkOrderNumber ) {

        # update each workorder, prevent recalculation of the WorkOrderNumber again
        my $CouldUpdateWorkOrder = $Self->{WorkOrderObject}->WorkOrderUpdate(
            WorkOrderID     => $WorkOrderID,
            WorkOrderNumber => $NewWorkOrderNumber{$WorkOrderID},
            NoNumberCalc    => 1,
            UserID          => $Param{UserID},
        );
    }

    return 1;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
