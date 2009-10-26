# --
# Kernel/Modules/AgentITSMWorkOrderAdd.pm - the OTRS::ITSM::ChangeManagement work order add module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMWorkOrderAdd.pm,v 1.5 2009-10-26 09:47:00 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderAdd;

use strict;
use warnings;

use Kernel::System::ITSMChange::WorkOrder;
use Kernel::System::ITSMChange;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

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

    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::WorkOrder->new(%Param);
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChangeManagement::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ChangeID = $Self->{ParamObject}->GetParam( Param => 'ChangeID' );

    # check needed stuff
    if ( !$ChangeID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No ChangeID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get workorder data
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change $ChangeID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # store all needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (qw(WorkOrderTitle Instruction)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }
    for my $TimeType (qw(PlannedStartTime PlannedEndTime)) {
        for my $TimePart (qw(Year Month Day Hour Minute)) {
            my $ParamName = $TimeType . $TimePart;
            $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
        }
    }

    # add workorder
    my %Invalid;
    if ( $Self->{Subaction} eq 'Save' ) {

        # add only if WorkOrderTitle is given
        if ( !$GetParam{WorkOrderTitle} ) {
            $Invalid{Title} = 'missing';
        }

        # check whether complete times are passed and build the time stamps
        my %SystemTime;
        TIMETYPE:
        for my $TimeType (qw(PlannedStartTime PlannedEndTime)) {
            for my $TimePart (qw(Year Month Day Hour Minute)) {
                my $ParamName = $TimeType . $TimePart;
                if ( !defined $GetParam{$ParamName} ) {
                    $Self->{LogObject}
                        ->Log( Priority => 'error', Message => "Need $ParamName!" );
                    next TIMETYPE;
                }
            }

            # format as timestamp
            $GetParam{$TimeType} = sprintf '%04d-%02d-%02d %02d:%02d:00',
                $GetParam{ $TimeType . 'Year' },
                $GetParam{ $TimeType . 'Month' },
                $GetParam{ $TimeType . 'Day' },
                $GetParam{ $TimeType . 'Hour' },
                $GetParam{ $TimeType . 'Minute' };

            # sanity check the assembled timestamp
            $SystemTime{$TimeType} = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $GetParam{$TimeType},
            );
            if ( !$SystemTime{$TimeType} ) {
                $Invalid{$TimeType} = 'invalid format';
            }
        }

        # check the ordering of the times
        if (
            $SystemTime{PlannedStartTime}
            && $SystemTime{PlannedEndTime}
            && $SystemTime{PlannedStartTime} >= $SystemTime{PlannedEndTime}
            )
        {
            $Invalid{PlannedEndTime} = 'Start time is equal or greater that the end time.';
        }

        if ( !%Invalid ) {
            my $WorkOrderID = $Self->{WorkOrderObject}->WorkOrderAdd(
                ChangeID         => $ChangeID,
                WorkOrderTitle   => $GetParam{WorkOrderTitle},
                Instruction      => $GetParam{Instruction},
                PlannedStartTime => $GetParam{PlannedStartTime},
                PlannedEndTime   => $GetParam{PlannedEndTime},
                UserID           => $Self->{UserID},
            );

            if ( !$WorkOrderID ) {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Was not able to add WorkOrder!",
                    Comment => 'Please contact the admin.',
                );
            }
            else {

                # redirect to zoom mask
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMWorkOrderZoom&WorkOrderID=$WorkOrderID",
                );
            }
        }
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Add',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    $Self->{LayoutObject}->Block(
        Name => 'RichText',
    );

    # set the time selection
    for my $TimeType (qw(PlannedStartTime PlannedEndTime)) {

        # set default value for $DiffTime
        # When no time is given yet, then use the current time plus the difftime
        # When an explicit time was retrieved, $DiffTime is not used
        my $DiffTime = $TimeType eq 'PlannedStartTime' ? 0 : 60 * 60;

        # add selection for the time
        my $TimeSelectionString = $Self->{LayoutObject}->BuildDateSelection(
            %GetParam,
            Format   => 'DateInputFormatLong',
            Prefix   => $TimeType,
            DiffTime => $DiffTime,
        );

        $Self->{LayoutObject}->Block(
            Name => $TimeType,
            Data => {
                $TimeType . 'String' => $TimeSelectionString,
                }
        );
    }

    # The blocks InvalidPlannedStartTime and InvalidPlannedEndTime need to be filled after
    # the blocks PlannedStartTime and PlannedEndTime
    for my $Param ( keys %Invalid ) {

        # show invalid message
        $Self->{LayoutObject}->Block(
            Name => 'Invalid' . $Param,
        );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderAdd',
        Data         => {
            %Param,
            %{$Change},
            %GetParam,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
