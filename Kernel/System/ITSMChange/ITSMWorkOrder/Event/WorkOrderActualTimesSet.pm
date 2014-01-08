# --
# Kernel/System/ITSMChange/ITSMWorkOrder/Event/WorkOrderActualTimesSet.pm - to set actual workorder times
# event module for ITSMWorkOrder
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderActualTimesSet;

use strict;
use warnings;

use Kernel::System::ITSMChange::ITSMStateMachine;

=head1 NAME

use Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderActualTimesSet - WorkOrderActualTimesSet
event module for ITSMWorkOrder

=head1 SYNOPSIS

Event handler module for setting the actual start and end time in WorkOrders.

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
    use Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderActualTimesSet;

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
    my $WorkOrderActualTimesSetObject = Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderActualTimesSet->new(
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

    # create additional objects
    $Self->{StateMachineObject} = Kernel::System::ITSMChange::ITSMStateMachine->new( %{$Self} );

    return $Self;
}

=item Run()

The C<Run()> method sets the actual start and end time of a workorder if it is not yet set.
The actual start time is set if a configurable workorder state is reached, the actual end time is set
if the workorder reaches any end state.

This is triggered by the C<WorkOrderUpdate> event.

The methods returns 1 on success, C<undef> otherwise.

    my $Success = $EventObject->Run(
        Event => 'WorkOrderUpdatePost',
        Data => {
            WorkOrderID => 123,
        },
        Config => {
            Event       => 'WorkOrderUpdatePost',
            Module      => 'Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderActualTimesSet',
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

    # handle WorkOrderUpdate event
    if ( $Param{Event} eq 'WorkOrderUpdatePost' ) {

        # get WorkOrder
        my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $Param{Data}->{WorkOrderID},
            UserID      => $Param{UserID},
        );

        # check error
        return if !$WorkOrder;

        # get actual start time from workorder
        my $ActualStartTime = $WorkOrder->{ActualStartTime};

        # get configured workorder states when to set actual start time
        my $ConfiguredWorkOrderStartStates
            = $Self->{ConfigObject}->Get('ITSMWorkOrder::ActualStartTimeSet::States');

        # convert into hash for easier lookup
        my %ActualStartTimeSetStates = map { $_ => 1 } @{$ConfiguredWorkOrderStartStates};

        # get current time stamp
        my $CurrentTimeStamp = $Self->{TimeObject}->CurrentTimestamp();

        # check if ActualStartTime is empty,
        # and WorkOrderState is in an ActualStartTimeSetState
        if ( !$ActualStartTime && $ActualStartTimeSetStates{ $WorkOrder->{WorkOrderState} } ) {

            # set the actual start time
            my $Success = $Self->{WorkOrderObject}->WorkOrderUpdate(
                WorkOrderID     => $Param{Data}->{WorkOrderID},
                ActualStartTime => $CurrentTimeStamp,
                UserID          => $Param{UserID},
            );

            # check error
            if ( !$Success ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Could not set ActualStartTime for WorkOrderID '$Param{Data}->{WorkOrderID}'!",
                );
                return;
            }

            # remember the just set actual start time
            $ActualStartTime = $CurrentTimeStamp;
        }

        # check if the ActualEndTime is empty
        # and the current workorder state is an end state
        if ( !$WorkOrder->{ActualEndTime} ) {

            # get the possible next state ids
            my $NextStateIDsRef = $Self->{StateMachineObject}->StateTransitionGet(
                StateID => $WorkOrder->{WorkOrderStateID},
                Class   => 'ITSM::ChangeManagement::WorkOrder::State',
            ) || [];

            # if there is only one next state, which is also 0,
            # which means that this is an end state
            if ( ( scalar @{$NextStateIDsRef} == 1 ) && ( !$NextStateIDsRef->[0] ) ) {

                # if no actual start time is set, use the current time
                if ( !$ActualStartTime ) {
                    $ActualStartTime = $CurrentTimeStamp;
                }

                # increase the current time stamp by one second to avoid the case that
                # actual start and end times are the same
                my $CurrentSystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                    String => $CurrentTimeStamp,
                );
                my $ActualEndTime = $Self->{TimeObject}->SystemTime2TimeStamp(
                    SystemTime => $CurrentSystemTime + 1,
                );

                # set the actual end time,
                # and if the actual start time was not set, set it also
                my $Success = $Self->{WorkOrderObject}->WorkOrderUpdate(
                    WorkOrderID     => $Param{Data}->{WorkOrderID},
                    ActualStartTime => $ActualStartTime,
                    ActualEndTime   => $ActualEndTime,
                    UserID          => $Param{UserID},
                );

                # check error
                if ( !$Success ) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message =>
                            "Could not set ActualStartTime for WorkOrderID '$Param{Data}->{WorkOrderID}'!",
                    );
                    return;
                }
            }
        }
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

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
