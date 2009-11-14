# --
# Kernel/System/ITSMChange/ITSMWorkOrder/Event/WorkOrderNumberCalc.pm - WorkOrderNumberCalc
# event module for ITSMWorkOrder
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: WorkOrderNumberCalc.pm,v 1.2 2009-11-14 17:25:38 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderNumberCalc;

use strict;
use warnings;

use Kernel::System::ITSMChange;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::System::ITSMChange::Event::WorkOrderNumberCalc - WorkOrderNumberCalc
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
    use Kernel::System::ITSMChange;
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
    my $ChangeObject = Kernel::System::ITSMChange->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );
    my $HistoryAddObject = Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderNumberCalc->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
        ChangeObject => $ChangeObject,
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

    # create additional objects
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new( %{$Self} );

    return $Self;
}

=item Run()

The C<Run()> method recalculates the workordernumbers for a given change.
This is triggered by WorkOrderAdd, WorkOrderUpdate, WorkOrderDelete events.

It returns 1 on success, C<undef> otherwise.

    my $Success = $EventObject->Run(
        Event => 'WorkOrderUpdate',
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
    for my $Needed (qw(Data Event Config)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # handle WorkOrderUpdate und WorkOrderDelete events
    if ( $Param{Event} eq 'WorkOrderUpdatePost' || $Param{Event} eq 'WorkOrderDeletePost' ) {

        # TODO: Should the new numbers be tracked in history?

        # get WorkOrder
        my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $Param{Data}->{WorkOrderID},
            UserID      => $Param{UserID},
        );

        return if !$WorkOrder;

        # recalculate WorkOrder numbers
        return if !$Self->_WorkOrderNumberCalc(
            ChangeID => $WorkOrder->{ChangeID},
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

=item _WorkOrderNumberCalc()

This method actually recalculates the WorkOrderNumbers. It returns 1
on success, C<undef> otherwise.

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

    # use WorkOrderSearch: Search for given IDs, ordered by:
    # ActualStartTime, PlannedStartTime, ActualEndTime, PlannedEndTime, WorOrderID
    my $WorkOrders = $Self->{WorkOrderObject}->WorkOrderSearch(
        ChangeIDs => [ $Param{ChangeID} ],
        OrderBy   => [
            qw(
                ActualStartTime
                PlannedStartTime
                ActualEndTime
                PlannedEndTime
                WorkOrderID
                )
        ],
        OrderByDirection => [
            qw(
                Up
                Up
                Down
                Down
                Up
                )
        ],
        UserID => $Param{UserID},
    ) || [];

    # counter - used as WorkOrderNumber
    my $Counter = 0;

    # set new WorkOrderNumber
    WORKORDERID:
    for my $WorkOrderID ( @{$WorkOrders} ) {

        # increment Counter to get new WorkOrderNumber
        $Counter++;

        # get WorkOrder
        my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $WorkOrderID,
            UserID      => $Param{UserID},
        );

        # update only when Number changed - to avoid infinit loops
        next WORKORDERID if $Counter == $WorkOrder->{WorkOrderNumber};

        my $CouldUpdateWorkOrder = $Self->{WorkOrderObject}->WorkOrderUpdate(
            WorkOrderID     => $WorkOrderID,
            WorkOrderNumber => $Counter,
            UserID          => $Param{UserID},
        );
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2009-11-14 17:25:38 $

=cut
