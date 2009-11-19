# --
# Kernel/Modules/AgentITSMChangeTimeSlot.pm - the OTRS::ITSM::ChangeManagement move time slot module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeTimeSlot.pm,v 1.2 2009-11-19 16:22:31 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeTimeSlot;

use strict;
use warnings;

use Kernel::System::ITSMChange;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

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
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new(%Param);

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

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (qw(TimeType)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # store time related fields in %GetParam
    for my $TimePart (qw(Year Month Day Hour Minute Used)) {
        my $ParamName = 'Planned' . $TimePart;
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # Remember the reason why saving was not attempted.
    # This entries are the names of the dtl validation error blocks.
    my @ValidationErrors;

    # update change
    if ( $Self->{Subaction} eq 'Save' ) {

        # check the planned time
        if (
            $GetParam{PlannedYear}
            && $GetParam{PlannedMonth}
            && $GetParam{PlannedDay}
            && $GetParam{PlannedHour}
            && $GetParam{PlannedMinute}
            )
        {

            # format as timestamp, when all required time param were passed
            $GetParam{PlannedTime} = sprintf '%04d-%02d-%02d %02d:%02d:00',
                $GetParam{PlannedYear},
                $GetParam{PlannedMonth},
                $GetParam{PlannedDay},
                $GetParam{PlannedHour},
                $GetParam{PlannedMinute};

            # sanity check of the assembled timestamp
            my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $GetParam{PlannedTime},
            );

            # do not save when time is invalid
            if ( !$SystemTime ) {
                push @ValidationErrors, 'InvalidPlannedTime';
            }
        }
        else {

            # at least one of the required time params is missing
            push @ValidationErrors, 'InvalidPlannedTime';
        }

        # update only when there are no validation errors
        if ( !@ValidationErrors ) {
            my $CouldMoveTimeSlot = 1;
            if ($CouldMoveTimeSlot) {

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

    # build drop-down with time types
    my $TimeTypeSelectionString = $Self->{LayoutObject}->BuildSelection(
        Data => [
            { Key => 'PlannedStartTime', Value => 'Planned start time' },
            { Key => 'PlannedEndTime',   Value => 'Planned end time' },
        ],
        Name => 'TimeType',
        SelectedID => $GetParam{TimeType} || 'PlannedStartTime',
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
