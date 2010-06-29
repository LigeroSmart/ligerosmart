# --
# Kernel/Modules/AgentITSMWorkOrderTemplate.pm - the OTRS::ITSM::ChangeManagement add template module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentITSMWorkOrderTemplate.pm,v 1.10 2010-06-29 13:45:17 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderTemplate;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::Template;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

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

    # create additional objects
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);
    $Self->{TemplateObject}  = Kernel::System::ITSMChange::Template->new(%Param);
    $Self->{ValidObject}     = Kernel::System::Valid->new(%Param);

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

    # get workorder data
    my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # check if LayoutObject has TranslationObject
    if ( $Self->{LayoutObject}->{LanguageObject} ) {

        # translate workorder type
        $WorkOrder->{WorkOrderType} = $Self->{LayoutObject}->{LanguageObject}->Get(
            $WorkOrder->{WorkOrderType}
        );
    }

    # check error
    if ( !$WorkOrder ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "WorkOrder '$WorkOrderID' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type     => $Self->{Config}->{Permission},
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (qw(TemplateName Comment ValidID StateReset)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # Remember the reason why saving was not attempted.
    # The items are the names of the dtl validation error blocks.
    my @ValidationErrors;

    # add a template
    if ( $Self->{Subaction} eq 'AddTemplate' ) {

        # check validity of the template name
        if ( !$GetParam{TemplateName} ) {
            push @ValidationErrors, 'InvalidTemplateName';
        }

        if ( !@ValidationErrors ) {

            # serialize the workorder
            my $TemplateContent = $Self->{TemplateObject}->TemplateSerialize(
                TemplateType => 'ITSMWorkOrder',
                StateReset   => $GetParam{StateReset} || 0,
                WorkOrderID  => $WorkOrderID,
                UserID       => $Self->{UserID},
            );

            # show error message
            if ( !$TemplateContent ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "The workorder '$WorkOrderID' could not be serialized.",
                    Comment => 'Please contact the admin.',
                );
            }

            # store the serialized workorder
            my $TemplateID = $Self->{TemplateObject}->TemplateAdd(
                Name         => $GetParam{TemplateName},
                Comment      => $GetParam{Comment},
                ValidID      => $GetParam{ValidID},
                TemplateType => 'ITSMWorkOrder',
                Content      => $TemplateContent,
                UserID       => $Self->{UserID},
            );

            # show error message
            if ( !$TemplateID ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Could not add the template.",
                    Comment => 'Please contact the admin.',
                );
            }

            # everything went well, redirect to zoom mask
            return $Self->{LayoutObject}->Redirect(
                OP => $Self->{LastWorkOrderView},
            );
        }
    }
    else {

        # no subaction,
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

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Template',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    my $ValidSelectionString = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{ValidObject}->ValidList(),
        },
        Name       => 'ValidID',
        SelectedID => $GetParam{ValidID} || ( $Self->{ValidObject}->ValidIDsGet() )[0],
        Sort       => 'NumericKey',
    );

    # add the validation error messages
    for my $BlockName (@ValidationErrors) {
        $Self->{LayoutObject}->Block( Name => $BlockName );
    }

    # set checkbox for state reset
    if ( $GetParam{StateReset} ) {
        $GetParam{StateReset} = 'checked="checked"';
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderTemplate',
        Data         => {
            %GetParam,
            %{$Change},
            %{$WorkOrder},
            ValidSelectionString => $ValidSelectionString,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
