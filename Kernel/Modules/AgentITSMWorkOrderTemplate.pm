# --
# Kernel/Modules/AgentITSMWorkOrderTemplate.pm - the OTRS::ITSM::ChangeManagement add template module
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMWorkOrderTemplate.pm,v 1.1 2010-01-18 16:37:11 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderTemplate;

use strict;
use warnings;

use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::Template;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);
    $Self->{TemplateObject}  = Kernel::System::ITSMChange::Template->new(%Param);
    $Self->{ValidObject}     = Kernel::System::Valid->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

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
            Message => "WorkOrder $WorkOrderID not found in database!",
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
            Message    => "You need $Self->{Config}->{Permission} permissions on the change!",
            WithHeader => 'yes',
        );
    }

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (qw(TemplateName Comment ValidID )) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # Remember the reason why saving was not attempted.
    # The items are the names of the dtl validation error blocks.
    my @ValidationErrors;

    # move time slot of change
    if ( $Self->{Subaction} eq 'AddTemplate' ) {

        # check validity of the template name
        my $TemplateName = $GetParam{TemplateName};
        if ( !$TemplateName ) {
            push @ValidationErrors, 'InvalidTemplateName';
        }

        if ( !@ValidationErrors ) {

            # serialize the change
            my $TemplateContent = $Self->{TemplateObject}->TemplateSerialize(
                TemplateType => 'ITSMWorkOrder',
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

            my $TemplateTypeID = $Self->{TemplateObject}->TemplateTypeLookup(
                TemplateType => 'ITSMWorkOrder',
                UserID       => $Self->{UserID},
            );

            # show error message
            if ( !$TemplateTypeID ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "The template type 'ITSMWorkOrder' is not known.",
                    Comment => 'Please contact the admin.',
                );
            }

            # store the serialized change
            my $TemplateID = $Self->{TemplateObject}->TemplateAdd(
                Name    => $GetParam{TemplateName},
                Comment => $GetParam{Comment},
                ValidID => $GetParam{ValidID},
                TypeID  => $TemplateTypeID,
                Content => $TemplateContent,
                UserID  => $Self->{UserID},
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
                OP => "Action=AgentITSMWorkOrderZoom&WorkOrderID=$WorkOrderID",
            );
        }
    }
    else {

        # no subaction,
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

    # Add the validation error messages.
    for my $BlockName (@ValidationErrors) {

        # show validation error message
        $Self->{LayoutObject}->Block( Name => $BlockName );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeTemplate',
        Data         => {
            %GetParam,
            ChangeID             => $ChangeID,
            ValidSelectionString => $ValidSelectionString,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
