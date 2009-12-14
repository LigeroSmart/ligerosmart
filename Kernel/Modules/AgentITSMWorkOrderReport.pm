# --
# Kernel/Modules/AgentITSMWorkOrderReport.pm - the OTRS::ITSM::ChangeManagement workorder report module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMWorkOrderReport.pm,v 1.18 2009-12-14 16:42:11 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderReport;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.18 $) [1];

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
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMWorkOrder::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed WorkOrderID
    my $WorkOrderID = $Self->{ParamObject}->GetParam( Param => 'WorkOrderID' );

    # check needed stuff
    if ( !$WorkOrderID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No WorkOrderID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{WorkOrderObject}->Permission(
        Type        => $Self->{Config}->{Permission},
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get workorder data
    my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # check error
    if ( !$WorkOrder ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "WorkOrder $WorkOrderID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # store needed parameters in %GetParam to make this page reloadable
    my %GetParam;
    for my $ParamName (qw(Report WorkOrderStateID)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # store actual time related fields in %GetParam
    if ( $Self->{Config}->{ActualTimeSpan} ) {
        for my $TimeType (qw(ActualStartTime ActualEndTime)) {
            for my $TimePart (qw(Year Month Day Hour Minute Used)) {
                my $ParamName = $TimeType . $TimePart;
                $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
            }
        }
    }

    # Remember the reason why perfoming the subaction was not attempted.
    # The entries are the names of the dtl validation error blocks.
    my %ValidationError;

    # update workorder
    if ( $Self->{Subaction} eq 'Save' ) {

        # validate the actual time related parameters
        if ( $Self->{Config}->{ActualTimeSpan} ) {
            TIME_TYPE:
            for my $TimeType (qw(ActualStartTime ActualEndTime)) {

                # only when the checkbutton has been checked
                next TIME_TYPE if !$GetParam{ $TimeType . 'Used' };

                if (
                    $GetParam{ $TimeType . 'Year' }
                    && $GetParam{ $TimeType . 'Month' }
                    && $GetParam{ $TimeType . 'Day' }
                    && $GetParam{ $TimeType . 'Hour' }
                    && $GetParam{ $TimeType . 'Minute' }
                    )
                {

                    # format as timestamp, when all required time params were passed
                    $GetParam{$TimeType} = sprintf '%04d-%02d-%02d %02d:%02d:00',
                        $GetParam{ $TimeType . 'Year' },
                        $GetParam{ $TimeType . 'Month' },
                        $GetParam{ $TimeType . 'Day' },
                        $GetParam{ $TimeType . 'Hour' },
                        $GetParam{ $TimeType . 'Minute' };

                    # sanity check of the assembled timestamp
                    my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                        String => $GetParam{$TimeType},
                    );

                    # do not save when time is invalid
                    if ( !$SystemTime ) {
                        $ValidationError{ 'Invalid' . $TimeType } = 1;
                    }
                }
                else {

                    # it was indicated that the time should be set,
                    # but at least one of the required time params is missing
                    $ValidationError{ 'Invalid' . $TimeType } = 1;
                }
            }
        }

        # update only when there are no input validation errors
        if ( !%ValidationError ) {

            # the time related fields are configurable
            my %AdditionalParam;
            if ( $Self->{Config}->{ActualTimeSpan} ) {
                for my $TimeType (qw(ActualStartTime ActualEndTime)) {
                    if ( $GetParam{$TimeType} ) {
                        $AdditionalParam{$TimeType} = $GetParam{$TimeType};
                    }
                }
            }

            my $CouldUpdateWorkOrder = $Self->{WorkOrderObject}->WorkOrderUpdate(
                WorkOrderID      => $WorkOrder->{WorkOrderID},
                Report           => $GetParam{Report},
                WorkOrderStateID => $GetParam{WorkOrderStateID},
                UserID           => $Self->{UserID},
                %AdditionalParam,
            );

            # if workorder update was successful
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
    }
    else {

        # initialize the actual time related fields
        if ( $Self->{Config}->{ActualTimeSpan} ) {
            TIME_TYPE:
            for my $TimeType (qw(ActualStartTime ActualEndTime)) {

                next TIME_TYPE if !$WorkOrder->{$TimeType};

                # get the time from the workorder
                my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                    String => $WorkOrder->{$TimeType},
                );

                my ( $Second, $Minute, $Hour, $Day, $Month, $Year )
                    = $Self->{TimeObject}->SystemTime2Date( SystemTime => $SystemTime );

                # set the parameter hash for BuildDateSelection()
                $GetParam{ $TimeType . 'Used' }   = 1;
                $GetParam{ $TimeType . 'Minute' } = $Minute;
                $GetParam{ $TimeType . 'Hour' }   = $Hour;
                $GetParam{ $TimeType . 'Day' }    = $Day;
                $GetParam{ $TimeType . 'Month' }  = $Month;
                $GetParam{ $TimeType . 'Year' }   = $Year;
            }
        }
    }

    # get change that the workorder belongs to
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # no change found
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not find Change for WorkOrder $WorkOrderID!",
            Comment => 'Please contact the admin.',
        );
    }

    # get workorder state list
    my $WorkOrderPossibleStates = $Self->{WorkOrderObject}->WorkOrderPossibleStatesGet(
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # build drop-down with workorder states
    $Param{StateSelect} = $Self->{LayoutObject}->BuildSelection(
        Data       => $WorkOrderPossibleStates,
        Name       => 'WorkOrderStateID',
        SelectedID => $WorkOrder->{WorkOrderStateID},
    );

    # show state dropdown
    $Self->{LayoutObject}->Block(
        Name => 'State',
        Data => {
            %Param,
        },
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => $WorkOrder->{WorkOrderTitle},
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # add rich text editor
    if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
        );
    }

    if ( $Self->{Config}->{ActualTimeSpan} ) {
        for my $TimeType (qw(ActualStartTime ActualEndTime)) {

            # time period that can be selected from the GUI
            my %TimePeriod = %{ $Self->{ConfigObject}->Get('ITSMWorkOrder::TimePeriod') };

            # add selection for the time
            my $TimeSelectionString = $Self->{LayoutObject}->BuildDateSelection(
                %GetParam,
                Format                => 'DateInputFormatLong',
                Prefix                => $TimeType,
                "${TimeType}Optional" => 1,
                %TimePeriod,
            );

            # show time field
            $Self->{LayoutObject}->Block(
                Name => $TimeType,
                Data => {
                    $TimeType . 'SelectionString' => $TimeSelectionString,
                },
            );

            # show time validation error
            if ( $ValidationError{ 'Invalid' . $TimeType } ) {
                $Self->{LayoutObject}->Block(
                    Name => 'Invalid' . $TimeType,
                );
            }
        }
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderReport',
        Data         => {
            %Param,
            %{$Change},
            %{$WorkOrder},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
