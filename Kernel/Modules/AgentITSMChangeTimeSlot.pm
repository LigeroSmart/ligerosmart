# --
# Kernel/Modules/AgentITSMChangeTimeSlot.pm - the OTRS ITSM ChangeManagement move time slot module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject GroupObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create additional objects
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
        Action   => $Self->{Action},
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # error screen
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
            Message => "Change '$ChangeID' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # Moving is possible only when there are workorders.
    if ( !$Change->{WorkOrderCount} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "The change can't be moved, as it has no workorders.",
            Comment => 'Add a workorder first.',
        );
    }

    # Moving is allowed only when there the change has not started yet.
    if ( $Change->{ActualStartTime} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Can't move a change which already has started!",
            Comment => 'Please move the individual workorders instead.',
        );
    }

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    $GetParam{MoveTimeType} = $Self->{ParamObject}->GetParam(
        Param => 'MoveTimeType',
    ) || 'PlannedStartTime';

    # store time related fields in %GetParam
    for my $TimePart (qw(Year Month Day Hour Minute)) {
        my $ParamName = 'MoveTime' . $TimePart;
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam(
            Param => $ParamName,
        );
    }

    # Remember the reason why saving was not attempted.
    my %ValidationErrors;

    # move time slot of change
    if ( $Self->{Subaction} eq 'MoveTimeSlot' ) {

        # check validity of the time type
        my $MoveTimeType = $GetParam{MoveTimeType};
        if ( !defined $MoveTimeType )
        {
            $ValidationErrors{MoveTimeInvalid} = 'ServerError';
        }
        else {

            # check the completeness of the time parameter list,
            # only hour and minute are allowed to be '0'
            if (
                !$GetParam{MoveTimeYear}
                || !$GetParam{MoveTimeMonth}
                || !$GetParam{MoveTimeDay}
                || !defined $GetParam{MoveTimeHour}
                || !defined $GetParam{MoveTimeMinute}
                )
            {
                $ValidationErrors{MoveTimeInvalid} = 'ServerError';
            }
        }

        # get the system time from the input, if it can't be determined we have a validation error
        my $PlannedSystemTime;
        if ( !%ValidationErrors ) {

            # transform change planned time, time stamp based on user time zone
            %GetParam = $Self->{LayoutObject}->TransformDateSelection(
                %GetParam,
                Prefix => 'MoveTime',
            );

            # format as timestamp
            my $PlannedTime = sprintf '%04d-%02d-%02d %02d:%02d:00',
                $GetParam{MoveTimeYear},
                $GetParam{MoveTimeMonth},
                $GetParam{MoveTimeDay},
                $GetParam{MoveTimeHour},
                $GetParam{MoveTimeMinute};

            # sanity check of the assembled timestamp
            $PlannedSystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $PlannedTime,
            );

            if ( !$PlannedSystemTime ) {
                $ValidationErrors{MoveTimeInvalid} = 'ServerError';
            }
        }

        # move time slot only when there are no validation errors
        if ( !%ValidationErrors ) {

            # Determine the difference in seconds
            my $CurrentPlannedTime = $Change->{$MoveTimeType};

            # Even when there are workorders, a change might still miss a planned time.
            # In that case moving the time slot is not possible.
            if ( !$CurrentPlannedTime ) {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "The current $MoveTimeType could not be determined.",
                    Comment => "The $MoveTimeType of all workorders has to be defined.",
                );
            }

            my $CurrentPlannedSystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $CurrentPlannedTime,
            );
            my $DiffSeconds = $PlannedSystemTime - $CurrentPlannedSystemTime;

            my $MoveError = $Self->_MoveWorkOrders(
                DiffSeconds  => $DiffSeconds,
                WorkOrderIDs => $Change->{WorkOrderIDs},
                ChangeNumber => $Change->{ChangeNumber},
            );

            if ($MoveError) {
                return $MoveError;
            }

            # load new URL in parent window and close popup
            return $Self->{LayoutObject}->PopupClose(
                URL => "Action=AgentITSMChangeZoom;ChangeID=$ChangeID",
            );
        }
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {

        # get planned start time or planned end time from the change
        my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Change->{ $GetParam{MoveTimeType} },
        );

        # time zone translation
        if ( $Self->{ConfigObject}->Get('TimeZoneUser') && $Self->{UserTimeZone} ) {
            $SystemTime = $SystemTime + ( $Self->{UserTimeZone} * 3600 );
        }

        # set the parameter hash for the answers
        # the seconds are ignored
        my ( $Second, $Minute, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $SystemTime,
        );

        # get config for the number of years which should be selectable
        my $TimePeriod = $Self->{ConfigObject}->Get('ITSMWorkOrder::TimePeriod');
        my $StartYear  = $Year - $TimePeriod->{YearPeriodPast};
        my $EndYear    = $Year + $TimePeriod->{YearPeriodFuture};

        # assemble the data that will be returned
        my $JSON = $Self->{LayoutObject}->BuildSelectionJSON(
            [
                {
                    Name       => 'MoveTimeMinute',
                    Data       => [ map { sprintf '%02d', $_ } ( 0 .. 59 ) ],
                    SelectedID => $Minute,
                },
                {
                    Name       => 'MoveTimeHour',
                    Data       => [ map { sprintf '%02d', $_ } ( 0 .. 23 ) ],
                    SelectedID => $Hour,
                },
                {
                    Name       => 'MoveTimeDay',
                    Data       => [ map { sprintf '%02d', $_ } ( 1 .. 31 ) ],
                    SelectedID => $Day,
                },
                {
                    Name       => 'MoveTimeMonth',
                    Data       => [ map { sprintf '%02d', $_ } ( 1 .. 12 ) ],
                    SelectedID => $Month,
                },
                {
                    Name       => 'MoveTimeYear',
                    Data       => [ $StartYear .. $EndYear ],
                    SelectedID => $GetParam{MoveTimeYear},
                },
            ],
        );

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    else {

        # no subaction,
        # get planned start time or planned end time from the change
        my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Change->{ $GetParam{MoveTimeType} },
        );

        # set the parameter hash for BuildDateSelection()
        # the seconds are ignored
        my ( $Second, $Minute, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $SystemTime,
        );
        $GetParam{MoveTimeMinute} = $Minute;
        $GetParam{MoveTimeHour}   = $Hour;
        $GetParam{MoveTimeDay}    = $Day;
        $GetParam{MoveTimeMonth}  = $Month;
        $GetParam{MoveTimeYear}   = $Year;
    }

    # build drop-down with time types
    my $MoveTimeTypeSelectionString = $Self->{LayoutObject}->BuildSelection(
        Data => [
            { Key => 'PlannedStartTime', Value => 'PlannedStartTime' },
            { Key => 'PlannedEndTime',   Value => 'PlannedEndTime' },
        ],
        Name       => 'MoveTimeType',
        SelectedID => $GetParam{MoveTimeType},
    );

    # time period that can be selected from the GUI
    my %TimePeriod = %{ $Self->{ConfigObject}->Get('ITSMWorkOrder::TimePeriod') };

    # add selection for the time
    my $MoveTimeSelectionString = $Self->{LayoutObject}->BuildDateSelection(
        %GetParam,
        Format        => 'DateInputFormatLong',
        Prefix        => 'MoveTime',
        Validate      => 1,
        MoveTimeClass => $ValidationErrors{MoveTimeInvalid} || '',
        %TimePeriod,
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Move Time Slot',
        Type  => 'Small',
    );

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeTimeSlot',
        Data         => {
            %{$Change},
            %ValidationErrors,
            MoveTimeTypeSelectionString => $MoveTimeTypeSelectionString,
            MoveTimeSelectionString     => $MoveTimeSelectionString,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}

# the actual moving is done here
sub _MoveWorkOrders {
    my ( $Self, %Param ) = @_;

    my @CollectedUpdateParams;    # an array of params for WorkOrderUpdate()
    my %WorkOrderID2Number;       # used only for error messages

    # determine the new times
    WORKORDERID:
    for my $WorkOrderID ( @{ $Param{WorkOrderIDs} } ) {
        my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $WorkOrderID,
            UserID      => $Self->{UserID},
        );

        next WORKORDERID if !$WorkOrder;
        next WORKORDERID if ref $WorkOrder ne 'HASH';
        next WORKORDERID if !%{$WorkOrder};

        $WorkOrderID2Number{$WorkOrderID} = $WorkOrder->{WorkOrderNumber};
        my %UpdateParams;
        TYPE:
        for my $Type (qw(PlannedStartTime PlannedEndTime)) {

            next TYPE if !$WorkOrder->{$Type};

            my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $WorkOrder->{$Type},
            );
            next TYPE if !$SystemTime;

            # add the number of seconds that the time slot should be moved
            $SystemTime += $Param{DiffSeconds};
            $UpdateParams{$Type} = $Self->{TimeObject}->SystemTime2TimeStamp(
                SystemTime => $SystemTime,
            );
        }

        next WORKORDERID if !%UpdateParams;

        # remember the workorder that should be moved
        $UpdateParams{WorkOrderID} = $WorkOrderID;

        push @CollectedUpdateParams, \%UpdateParams;
    }

    # do the updating
    UPDATEPARAMS:
    for my $UpdateParams (@CollectedUpdateParams) {

        # no number calculation necessary because the workorder order doesn't change
        my $UpdateOk = $Self->{WorkOrderObject}->WorkOrderUpdate(
            %{$UpdateParams},
            NoNumberCalc => 1,
            UserID       => $Self->{UserID},
        );

        if ( !$UpdateOk ) {

            # show error message
            my $Number = join '-',
                $Param{ChangeNumber},
                $WorkOrderID2Number{ $UpdateParams->{WorkOrderID} };

            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Was not able to move time slot for workorder #$Number!",
                Comment => 'Please contact the admin.',
            );
        }
    }

    # moving was successful
    return;
}

1;
