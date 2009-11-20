# --
# Kernel/Output/HTML/LayoutITSMChange.pm - provides generic HTML output for ITSMChange
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: LayoutITSMChange.pm,v 1.10 2009-11-20 11:47:38 mae Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutITSMChange;

use strict;
use warnings;

use POSIX qw(ceil);

use Kernel::Output::HTML::Layout;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

=item ITSMChangeBuildWorkOrderGraph()

returns a output string for WorkOrder graph

    my $String = $LayoutObject->ITSMChangeBuildWorkOrderGraph(
        Change => $ChangeRef,
        WorkOrderObject => $WorkOrderObject,
    );

=cut

sub ITSMChangeBuildWorkOrderGraph {
    my ( $Self, %Param ) = @_;

    # check needed objects
    for my $Object (qw(TimeObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError(
                Message => "Got no $Object!",
            );
            return;
        }
    }

    # check for change
    my $Change = $Param{Change};
    if ( !$Change ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Change!',
        );
        return;
    }

    # check work order object
    if ( !$Param{WorkOrderObject} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need WorkOrderObject!',
        );
        return;
    }
    $Self->{WorkOrderObject} = $Param{WorkOrderObject};

    # check if work orders are available
    return if !$Change->{WorkOrderIDs};

    # check for ARRAY-ref and empty ARRAY-ref
    return if ref $Change->{WorkOrderIDs} ne 'ARRAY' || !@{ $Change->{WorkOrderIDs} };

    # get smallest start time
    my $StartTime;

    if ( !$Change->{ActualStartTime} ) {

        # translate to timestamp
        $StartTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Change->{PlannedStartTime},
        );
    }
    else {

        # translate to timestamp for equation
        my $PlannedStartTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Change->{PlannedStartTime},
        );
        my $ActualStartTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Change->{ActualStartTime},
        );

        # set start time
        $StartTime = ( $PlannedStartTime > $ActualStartTime )
            ? $ActualStartTime
            : $PlannedStartTime
            ;
    }

    # get highest end time
    my $EndTime;

    if ( !$Change->{ActualEndTime} ) {

        # translate to timestamp
        $EndTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Change->{PlannedEndTime},
        );
    }
    else {

        # translate to timestamp for equation
        my $PlannedEndTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Change->{PlannedEndTime},
        );
        my $ActualEndTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Change->{ActualEndTime},
        );

        # set end time
        $EndTime = ( $PlannedEndTime < $ActualEndTime )
            ? $ActualEndTime
            : $PlannedEndTime
            ;
    }

    # calculate ticks for change
    my $ChangeTicks = $Self->_ITSMChangeGetChangeTicks(
        Start => $StartTime,
        End   => $EndTime,
    );

    # check for valid ticks
    if ( !$ChangeTicks ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Unable to calculate time scale.'
        );
        return;
    }

    # get work orders of change
    my @WorkOrders;
    WORKORDERID:
    for my $WorkOrderID ( @{ $Change->{WorkOrderIDs} } ) {
        my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $WorkOrderID,
            UserID      => $Self->{UserID},
        );
        next WORKORDERID if !$WorkOrder;

        push @WorkOrders, $WorkOrder;
    }

    # sort work order ascending to WorkOrderNumber
    @WorkOrders = sort { $a->{WorkOrderNumber} <=> $b->{WorkOrderNumber} } @WorkOrders;

    # load graph sceleton
    $Self->Block(
        Name => 'WorkOrderGraph',
        Data => {
        },
    );

    # build graph of each work order
    WORKORDER:
    for my $WorkOrder (@WorkOrders) {
        next WORKORDER if !$WorkOrder;

        $Self->_ITSMChangeGetWorkOrderGraph(
            WorkOrder => $WorkOrder,
            StartTime => $StartTime,
            EndTime   => $EndTime,
            Ticks     => $ChangeTicks,
        );
    }

    # build scale of graph
    $Self->_ITSMChangeGetChangeScale(
        StartTime => $StartTime,
        EndTime   => $EndTime,
        Ticks     => $ChangeTicks,
    );

    # render graph and return HTML with ITSMChange.dtl template
    return $Self->Output(
        TemplateFile => 'ITSMChange',
    );
}

sub _ITSMChangeGetChangeTicks {
    my ( $Self, %Param ) = @_;

    # check for start and end
    return if !$Param{Start} || !$Param{End};

    # make sure we got integers
    return if $Param{Start} !~ m{ \A \d+ \z }xms;
    return if $Param{End} !~ m{ \A \d+ \z }xms;

    # calculate time span in sec
    my $Ticks;
    $Ticks = $Param{End} - $Param{Start};

    # check for computing error
    return if $Ticks <= 0;

    # get seconds per percent and round down
    $Ticks = ceil( $Ticks / 100 );

    return $Ticks;
}

sub _ITSMChangeGetChangeScale {
    my ( $Self, %Param ) = @_;

    # check for start time
    return if !$Param{StartTime};

    # check for start time is an integer value
    return if $Param{StartTime} !~ m{\A \d+ \z}xms;

    # calculate scale naming
    my %ScaleName = (
        Scale20 => ( $Param{StartTime} + 20 * $Param{Ticks} ),
        Scale40 => ( $Param{StartTime} + 40 * $Param{Ticks} ),
        Scale60 => ( $Param{StartTime} + 60 * $Param{Ticks} ),
        Scale80 => ( $Param{StartTime} + 80 * $Param{Ticks} ),
    );

    # create scale block
    $Self->Block(
        Name => 'Scale',
        Data => {
            %ScaleName,
        },
    );

    INTERVAL:
    for my $Interval ( sort keys %ScaleName ) {

        # translate timestamps in date format
        $ScaleName{$Interval} = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $ScaleName{$Interval},
        );

        # do not display scale if translating failed
        next INTERVAL if !$ScaleName{$Interval};

        # build scale label block
        $Self->Block(
            Name => 'ScaleLabel',
            Data => {
                ScaleLabel => $ScaleName{$Interval},
            },
        );
    }
}

sub _ITSMChangeGetWorkOrderGraph {
    my ( $Self, %Param ) = @_;

    # check for work order
    return if !$Param{WorkOrder};

    # extract work order
    my $WorkOrder = $Param{WorkOrder};

    # set planned if no actual time is set
    $WorkOrder->{ActualStartTime} = $WorkOrder->{PlannedStartTime}
        if !$WorkOrder->{ActualStartTime};
    $WorkOrder->{ActualEndTime} = $WorkOrder->{PlannedEndTime}
        if !$WorkOrder->{ActualEndTime};

    # hash for time values
    my %Time;

    for my $TimeType (
        qw(
        PlannedStartTime
        PlannedEndTime
        ActualStartTime
        ActualEndTime
        )
        )
    {

        # translate time
        $Time{$TimeType} = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $WorkOrder->{$TimeType},
        );
    }

    # determine length of work order
    my %TickValue;

    for my $TimeType (qw( Planned Actual )) {

        # get values for padding span
        $TickValue{"${TimeType}Padding"} = ceil(
            ( $Time{"${TimeType}StartTime"} - $Param{StartTime} ) / $Param{Ticks}
        );

        # get values for display span
        $TickValue{"${TimeType}Ticks"} = ceil(
            ( $Time{"${TimeType}EndTime"} - $Time{"${TimeType}StartTime"} ) / $Param{Ticks}
        ) || 1;

        # get at least 1 percent for display span
        # if padding would gain 100 percent
        $TickValue{"${TimeType}Padding"} =
            ( $TickValue{"${TimeType}Ticks"} == 1 && $TickValue{"${TimeType}Padding"} == 100 )
            ? 99
            : $TickValue{"${TimeType}Padding"}
            ;

        # get trailing space
        $TickValue{"${TimeType}Trailing"} =
            100 - ( $TickValue{"${TimeType}Padding"} + $TickValue{"${TimeType}Ticks"} );
    }

    # create work order item
    $Self->Block(
        Name => 'WorkOrderItem',
        Data => {
            %{$WorkOrder},
            %TickValue,
        },
    );
}

1;
