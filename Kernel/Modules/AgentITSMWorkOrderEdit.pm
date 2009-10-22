# --
# Kernel/Modules/AgentITSMWorkOrderEdit.pm - the OTRS::ITSM::ChangeManagement work order edit module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMWorkOrderEdit.pm,v 1.11 2009-10-22 14:19:05 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderEdit;

use strict;
use warnings;

use Kernel::System::ITSMChange::WorkOrder;
use Kernel::System::ITSMChange;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

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

    my $WorkOrderID = $Self->{ParamObject}->GetParam( Param => 'WorkOrderID' );

    # check needed stuff
    if ( !$WorkOrderID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No WorkOrderID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get workorder data
    my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    if ( !$WorkOrder ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "WorkOrder $WorkOrderID not found in database!",
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

    # update workorder
    if ( $Self->{Subaction} eq 'Save' ) {

        # update only if WorkOrderTitle is given
        if ( $GetParam{WorkOrderTitle} ) {

            # check whether complete times are passed and build the time stamps
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
                $GetParam{$TimeType} =
                    join q{}, $GetParam{ $TimeType . 'Year' }, '-',
                    $GetParam{ $TimeType . 'Month' },
                    '-', $GetParam{ $TimeType . 'Day' }, q{ }, $GetParam{ $TimeType . 'Hour' }, ':',
                    $GetParam{ $TimeType . 'Minute' }, ':', '00';
            }

            my $CouldUpdateWorkOrder = $Self->{WorkOrderObject}->WorkOrderUpdate(
                WorkOrderID => $WorkOrder->{WorkOrderID},
                UserID      => $Self->{UserID},
                %GetParam,
            );

            if ($CouldUpdateWorkOrder) {

                # redirect to zoom mask
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMWorkOrderZoom&WorkOrderID=$WorkOrder->{WorkOrderID}",
                );
            }
            else {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Was not able to update WorkOrder $WorkOrder->{WorkOrderID}!",
                    Comment => 'Please contact the admin.',
                );
            }
        }
        else {

            # show invalid message
            $Self->{LayoutObject}->Block(
                Name => 'InvalidTitle',
            );
        }
    }

    # delete all keys from GetParam when it is no Subaction
    else {
        %GetParam = ();
        for my $TimeType (qw(PlannedStartTime PlannedEndTime)) {

            if ( $WorkOrder->{$TimeType} ) {

                # get planned start time from workorder
                my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                    String => $WorkOrder->{$TimeType},
                );
                my ( $Second, $Minute, $Hour, $Day, $Month, $Year )
                    = $Self->{TimeObject}->SystemTime2Date(
                    SystemTime => $SystemTime,
                    );

                # set the parameter hash for BuildDateSelection()
                $WorkOrder->{ $TimeType . 'Used' }   = 1;
                $WorkOrder->{ $TimeType . 'Minute' } = $Minute;
                $WorkOrder->{ $TimeType . 'Hour' }   = $Hour;
                $WorkOrder->{ $TimeType . 'Day' }    = $Day;
                $WorkOrder->{ $TimeType . 'Month' }  = $Month;
                $WorkOrder->{ $TimeType . 'Year' }   = $Year;
            }
        }
    }

    # get change that workorder belongs to
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not find Change for WorkOrder $WorkOrderID!",
            Comment => 'Please contact the admin.',
        );
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => $WorkOrder->{WorkOrderTitle},
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    $Self->{LayoutObject}->Block(
        Name => 'RichText',
    );

    for my $TimeType (qw(PlannedStartTime PlannedEndTime)) {

        # set default value for $DiffTime
        # When no time is given yet, then use the current time plus the difftime
        # When an explicit time was retrieved, $DiffTime is not used
        my $DiffTime = $TimeType eq 'PlannedStartTime' ? 0 : 60 * 60;

        # add selection for the time
        my $TimeSelectionString = $Self->{LayoutObject}->BuildDateSelection(
            %{$WorkOrder},
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

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderEdit',
        Data         => {
            %Param,
            %{$Change},
            %{$WorkOrder},
            %GetParam,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
