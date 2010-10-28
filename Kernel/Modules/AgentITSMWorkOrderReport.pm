# --
# Kernel/Modules/AgentITSMWorkOrderReport.pm - the OTRS::ITSM::ChangeManagement workorder report module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentITSMWorkOrderReport.pm,v 1.29 2010-10-28 12:56:32 ub Exp $
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
$VERSION = qw($Revision: 1.29 $) [1];

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
            Message => "WorkOrder '$WorkOrderID' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # store needed parameters in %GetParam to make this page reloadable
    my %GetParam;
    for my $ParamName (qw(Report WorkOrderStateID AccountedTime)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # get configured workorder freetext field numbers
    my @ConfiguredWorkOrderFreeTextFields
        = $Self->{WorkOrderObject}->WorkOrderGetConfiguredFreeTextFields();

    # get workorder freetext params
    my %WorkOrderFreeTextParam;
    NUMBER:
    for my $Number (@ConfiguredWorkOrderFreeTextFields) {

        # consider only freetext fields which are activated in this frontend
        next NUMBER if !$Self->{Config}->{WorkOrderFreeText}->{$Number};

        my $Key   = 'WorkOrderFreeKey' . $Number;
        my $Value = 'WorkOrderFreeText' . $Number;

        $WorkOrderFreeTextParam{$Key}   = $Self->{ParamObject}->GetParam( Param => $Key );
        $WorkOrderFreeTextParam{$Value} = $Self->{ParamObject}->GetParam( Param => $Value );
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

    # remember the numbers of the workorder freetext fields with validation errors
    my %WorkOrderFreeTextValidationErrors;

    # update workorder
    if ( $Self->{Subaction} eq 'Save' ) {

        # validate the actual time related parameters
        if ( $Self->{Config}->{ActualTimeSpan} ) {
            for my $TimeType (qw(ActualStartTime ActualEndTime)) {

                if ( !$GetParam{ $TimeType . 'Used' } ) {

                    # when the button was not checked, then clear the time
                    $GetParam{$TimeType} = undef;
                }
                elsif (
                    $GetParam{ $TimeType . 'Year' }
                    && $GetParam{ $TimeType . 'Month' }
                    && $GetParam{ $TimeType . 'Day' }
                    && defined $GetParam{ $TimeType . 'Hour' }
                    && defined $GetParam{ $TimeType . 'Minute' }
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

        # validate format of accounted time
        if ( $GetParam{AccountedTime} !~ m{ \A -? \d* (?: [.] \d{1,2} )? \z }xms ) {
            $ValidationError{'InvalidAccountedTime'} = 1;
        }

        # check for required workorder freetext fields (if configured)
        for my $Number (@ConfiguredWorkOrderFreeTextFields) {
            if (
                $Self->{Config}->{WorkOrderFreeText}->{$Number}
                && $Self->{Config}->{WorkOrderFreeText}->{$Number} == 2
                && $WorkOrderFreeTextParam{ 'WorkOrderFreeText' . $Number } eq ''
                )
            {

                # remember the workorder freetext field number with validation errors
                $WorkOrderFreeTextValidationErrors{$Number}++;
            }
        }

        # update only when there are no input validation errors
        if ( !%ValidationError && !%WorkOrderFreeTextValidationErrors ) {

            # the actual time related fields are configurable
            my %AdditionalParam;
            if ( $Self->{Config}->{ActualTimeSpan} ) {
                for my $TimeType (qw(ActualStartTime ActualEndTime)) {

                    # $GetParam{$TimeType} is either a valid timestamp or undef
                    $AdditionalParam{$TimeType} = $GetParam{$TimeType};
                }
            }

            my $CouldUpdateWorkOrder = $Self->{WorkOrderObject}->WorkOrderUpdate(
                WorkOrderID      => $WorkOrder->{WorkOrderID},
                Report           => $GetParam{Report},
                WorkOrderStateID => $GetParam{WorkOrderStateID},
                UserID           => $Self->{UserID},
                AccountedTime    => $GetParam{AccountedTime},
                %AdditionalParam,
                %WorkOrderFreeTextParam,
            );

            # if workorder update was successful
            if ($CouldUpdateWorkOrder) {

                # redirect to zoom mask
                return $Self->{LayoutObject}->Redirect(
                    OP => $Self->{LastWorkOrderView},
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
            TIMETYPE:
            for my $TimeType (qw(ActualStartTime ActualEndTime)) {

                next TIMETYPE if !$WorkOrder->{$TimeType};

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

    # get the workorder freetext config and fillup workorder freetext fields from workorder data
    my %WorkOrderFreeTextConfig;
    NUMBER:
    for my $Number (@ConfiguredWorkOrderFreeTextFields) {

        TYPE:
        for my $Type (qw(WorkOrderFreeKey WorkOrderFreeText)) {

            # get workorder freetext fields from workorder if page is loaded the first time
            if ( !$Self->{Subaction} ) {

                $WorkOrderFreeTextParam{ $Type . $Number } ||= $WorkOrder->{ $Type . $Number };
            }

            # get config
            my $Config = $Self->{ConfigObject}->Get( $Type . $Number );

            next TYPE if !$Config;
            next TYPE if ref $Config ne 'HASH';

            # store the workorder freetext config
            $WorkOrderFreeTextConfig{ $Type . $Number } = $Config;
        }
    }

    # build the workorder freetext HTML
    my %WorkOrderFreeTextHTML = $Self->{LayoutObject}->BuildFreeTextHTML(
        Config                   => \%WorkOrderFreeTextConfig,
        WorkOrderData            => \%WorkOrderFreeTextParam,
        ConfiguredFreeTextFields => \@ConfiguredWorkOrderFreeTextFields,
    );

    # show workorder freetext fields
    my $WorkOrderFreeTextShown;
    for my $Number (@ConfiguredWorkOrderFreeTextFields) {

        # check if this freetext field should be shown in this frontend
        if ( $Self->{Config}->{WorkOrderFreeText}->{$Number} ) {

            # remember that at least one freetext field is shown
            $WorkOrderFreeTextShown = 1;

            # show single workorder freetext fields
            $Self->{LayoutObject}->Block(
                Name => 'WorkOrderFreeText' . $Number,
                Data => {
                    %WorkOrderFreeTextHTML,
                },
            );

            # show workorder freetext validation error for single workorder freetext field
            if ( $WorkOrderFreeTextValidationErrors{$Number} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'InvalidWorkOrderFreeText' . $Number,
                    Data => {
                        %WorkOrderFreeTextHTML,
                    },
                );
            }

            # show all workorder freetext fields
            $Self->{LayoutObject}->Block(
                Name => 'WorkOrderFreeText',
                Data => {
                    WorkOrderFreeKeyField =>
                        $WorkOrderFreeTextHTML{ 'WorkOrderFreeKeyField' . $Number },
                    WorkOrderFreeTextField =>
                        $WorkOrderFreeTextHTML{ 'WorkOrderFreeTextField' . $Number },
                },
            );

            # show all workorder freetext validation errors
            if ( $WorkOrderFreeTextValidationErrors{$Number} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'InvalidWorkOrderFreeText',
                    Data => {
                        %WorkOrderFreeTextHTML,
                    },
                );
            }
        }
    }

    # show space before and after workorder freetext fields
    if ($WorkOrderFreeTextShown) {

        $Self->{LayoutObject}->Block(
            Name => 'WorkOrderFreeTextSpacerTop',
            Data => {},
        );

        $Self->{LayoutObject}->Block(
            Name => 'WorkOrderFreeTextSpacerBottom',
            Data => {},
        );
    }

    # build workorder freetext java script check
    NUMBER:
    for my $Number (@ConfiguredWorkOrderFreeTextFields) {

        next NUMBER if !$Self->{Config}->{WorkOrderFreeText}->{$Number};

        # java script check for required workorder free text fields by form submit
        if ( $Self->{Config}->{WorkOrderFreeText}->{$Number} == 2 ) {
            $Self->{LayoutObject}->Block(
                Name => 'WorkOrderFreeTextCheckJs',
                Data => {
                    WorkOrderFreeKeyField  => 'WorkOrderFreeKey' . $Number,
                    WorkOrderFreeTextField => 'WorkOrderFreeText' . $Number,
                },
            );
        }
    }

    if ( $Self->{Config}->{ActualTimeSpan} ) {

        # enable the time checks, only when ActualStartTime and ActualEndTime are selectable
        $Self->{LayoutObject}->Block(
            Name => 'ActualTimeSpanJS',
            Data => {},
        );

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

                delete $ValidationError{ 'Invalid' . $TimeType };
            }
        }
    }

    # show accounted time only when form was submitted
    if ( $Self->{Config}->{AccountedTime} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ShowAccountedTime',
        );
    }

    # show accounted time only when form was submitted
    my $AccountedTime = '';
    if ( $GetParam{AccountedTime} ) {
        $AccountedTime = $GetParam{AccountedTime};
    }

    # show validation errors
    for my $Error ( keys %ValidationError ) {
        $Self->{LayoutObject}->Block(
            Name => $Error,
        );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderReport',
        Data         => {
            %Param,
            %{$Change},
            %{$WorkOrder},
            AccountedTime => $AccountedTime,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
