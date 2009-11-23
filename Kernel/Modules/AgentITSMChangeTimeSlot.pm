# --
# Kernel/Modules/AgentITSMChangeTimeSlot.pm - the OTRS::ITSM::ChangeManagement move time slot module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeTimeSlot.pm,v 1.4 2009-11-23 08:36:18 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeTimeSlot;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed ChangeID
    my $ChangeID = $Self->{ParamObject}->GetParam( Param => 'ChangeID' );

    # check needed stuff
    if ( !$ChangeID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No ChangeID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type     => $Self->{Config}->{Permission},
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # error screen, don't show change edit mask
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get change data
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # check if change is found
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change $ChangeID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # check whether there are any workorders
    if ( !@{ $Change->{WorkOrderIDs} } ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => q{The change has no workorders, therefore it can't be moved.},
            Comment => 'Add a workorder first.',
        );
    }

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (qw(TimeType)) {
        $GetParam{$ParamName}
            = $Self->{ParamObject}->GetParam( Param => $ParamName ) || 'PlannedStartTime';
    }

    # store time related fields in %GetParam
    for my $TimePart (qw(Year Month Day Hour Minute)) {
        my $ParamName = 'Planned' . $TimePart;
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam(
            Param => $ParamName
        );
    }

    # Remember the reason why saving was not attempted.
    # The items are the names of the dtl validation error blocks.
    my @ValidationErrors;

    # move time slot change
    if ( $Self->{Subaction} eq 'MoveTimeSlot' ) {

        # check validity of the time type
        my $TimeType = $GetParam{TimeType};
        if (
            !defined $TimeType
            || ( $TimeType ne 'PlannedStartTime' && $TimeType ne 'PlannedEndTime' )
            )
        {
            push @ValidationErrors, 'InvalidTimeType';
        }

        # check the completeness of the time parameter list
        if (
            !$GetParam{PlannedYear}
            || !$GetParam{PlannedMonth}
            || !$GetParam{PlannedDay}
            || !$GetParam{PlannedHour}
            || !$GetParam{PlannedMinute}
            )
        {
            push @ValidationErrors, 'InvalidPlannedTime';
        }

        # get the system time from the input, it it can't be determined we have a validation error
        my $PlannedSystemTime;
        if ( !@ValidationErrors ) {

            # format as timestamp
            my $PlannedTime = sprintf '%04d-%02d-%02d %02d:%02d:00',
                $GetParam{PlannedYear},
                $GetParam{PlannedMonth},
                $GetParam{PlannedDay},
                $GetParam{PlannedHour},
                $GetParam{PlannedMinute};

            # sanity check of the assembled timestamp
            $PlannedSystemTime
                = $Self->{TimeObject}->TimeStamp2SystemTime( String => $PlannedTime );

            if ( !$PlannedSystemTime ) {
                push @ValidationErrors, 'InvalidPlannedTime';
            }
        }

        # move time slot only when there are no validation errors
        if ( !@ValidationErrors ) {

            # Determine the difference in seconds
            my $CurrentPlannedTime = $Change->{$TimeType};

            # When there are no workorders, then there is no planned start or end time.
            # In that case moving the time slot is not possible.
            if ( !$CurrentPlannedTime ) {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "The current $TimeType could not be determined.",
                    Comment => 'There has to be at least one workorder.',
                );
            }

            my $CurrentPlannedSystemTime
                = $Self->{TimeObject}->TimeStamp2SystemTime( String => $CurrentPlannedTime );
            my $DiffSeconds = $PlannedSystemTime - $CurrentPlannedSystemTime;

            # TODO: think about locking
            my @CollectedUpdateParams;
            WORKORDERID:
            for my $WorkOrderID ( @{ $Change->{WorkOrderIDs} } ) {
                my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
                    WorkOrderID => $WorkOrderID,
                    UserID      => $Self->{UserID},
                );

                next WORKORDERID if !$WorkOrder;
                next WORKORDERID if ref $WorkOrder ne 'HASH';
                next WORKORDERID if !%{$WorkOrder};

                my %UpdateParams;
                TYPE:
                for my $Type (qw(PlannedStartTime PlannedEndTime)) {

                    next TYPE if !$WorkOrder->{$Type};

                    my $SystemTime
                        = $Self->{TimeObject}
                        ->TimeStamp2SystemTime( String => $WorkOrder->{$Type} );
                    next TYPE if !$SystemTime;

                    $SystemTime += $DiffSeconds;
                    $UpdateParams{$Type}
                        = $Self->{TimeObject}->SystemTime2TimeStamp( SystemTime => $SystemTime );
                }

                next WORKORDERID if !%UpdateParams;

                $UpdateParams{WorkOrderID} = $WorkOrderID;

                push @CollectedUpdateParams, \%UpdateParams;
            }

            my $UpdateOk = 1;
            UPDATEPARAMS:
            for my $UpdateParams (@CollectedUpdateParams) {
                $UpdateOk = $Self->{WorkOrderObject}->WorkOrderUpdate(
                    %{$UpdateParams},
                    UserID => $Self->{UserID},
                );

                last UPDATEPARAMS if !$UpdateOk;
            }

            if ($UpdateOk) {

                # redirect to zoom mask
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMChangeZoom&ChangeID=$ChangeID",
                );
            }
            else {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Was not able to move time slot for Change $ChangeID!",
                    Comment => 'Please contact the admin.',
                );
            }
        }
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {

        # get planned start time or planned end time from the change
        my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Change->{ $GetParam{TimeType} },
        );

        # set the parameter hash for the answers
        # the seconds are ignored
        # TODO: discuss this code with ub
        ( undef, @GetParam{qw(PlannedMinute PlannedHour PlannedDay PlannedMonth PlannedYear)} )
            = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $SystemTime,
            );

        # assemble the data that will be returned
        my @Answers = (
            {
                Name       => 'PlannedMinute',
                Data       => [ map { sprintf( '%02d', $_ ); } ( 0 .. 59 ) ],
                SelectedID => $GetParam{PlannedMinute},
            },
            {
                Name       => 'PlannedHour',
                Data       => [ map { sprintf( '%02d', $_ ); } ( 0 .. 23 ) ],
                SelectedID => $GetParam{PlannedHour},
            },
            {
                Name       => 'PlannedDay',
                Data       => [ map { sprintf( '%02d', $_ ); } ( 1 .. 31 ) ],
                SelectedID => $GetParam{PlannedDay},
            },
            {
                Name       => 'PlannedMonth',
                Data       => [ map { sprintf( '%02d', $_ ); } ( 1 .. 12 ) ],
                SelectedID => $GetParam{PlannedMonth},
            },
            {
                Name       => 'PlannedYear',
                Data       => [ $GetParam{PlannedYear} - 5 .. $GetParam{PlannedYear} + 5 ],
                SelectedID => $GetParam{PlannedYear},
            },
        );
        my $JSON = $Self->{LayoutObject}->BuildJSON( \@Answers );

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    else {
        my $TimeType = $GetParam{TimeType};
        if ( $Change->{$TimeType} ) {

            # get planned start time or planned end time from the change
            my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $Change->{$TimeType},
            );

            # set the parameter hash for BuildDateSelection()
            # the seconds are ignored
            # TODO: discuss this code with ub
            ( undef, @GetParam{qw(PlannedMinute PlannedHour PlannedDay PlannedMonth PlannedYear)} )
                = $Self->{TimeObject}->SystemTime2Date(
                SystemTime => $SystemTime,
                );
        }
    }

    # build drop-down with time types
    my $TimeTypeSelectionString = $Self->{LayoutObject}->BuildSelection(
        Data => [
            { Key => 'PlannedStartTime', Value => 'Planned start time' },
            { Key => 'PlannedEndTime',   Value => 'Planned end time' },
        ],
        Name       => 'TimeType',
        SelectedID => $GetParam{TimeType},
        Ajax       => {
            Update => [
                qw(PlannedMinute PlannedHour PlannedDay PlannedMonth PlannedYear),
            ],
            Depend => [
                qw(ChangeID TimeType),
            ],
            Subaction => 'AJAXUpdate',
        },
    );

    # time period that can be selected from the GUI
    my %TimePeriod = %{ $Self->{ConfigObject}->Get('ITSMWorkOrder::TimePeriod') };

    # add selection for the time
    my $TimeSelectionString = $Self->{LayoutObject}->BuildDateSelection(
        %GetParam,
        Format => 'DateInputFormatLong',
        Prefix => 'Planned',
        %TimePeriod,
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Move Time Slot',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # Add the validation error messages.
    for my $BlockName (@ValidationErrors) {

        # show validation error message
        $Self->{LayoutObject}->Block(
            Name => $BlockName,
        );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeTimeSlot',
        Data         => {
            %{$Change},
            TimeTypeSelectionString => $TimeTypeSelectionString,
            TimeSelectionString     => $TimeSelectionString,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
