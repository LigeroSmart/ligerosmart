# --
# Kernel/Modules/AgentITSMChangeTemplate.pm - the OTRS::ITSM::ChangeManagement add template module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentITSMChangeTemplate.pm,v 1.11 2010-06-29 13:45:17 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeTemplate;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::Template;
use Kernel::System::Valid;

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

    # create additional objects
    $Self->{ChangeObject}   = Kernel::System::ITSMChange->new(%Param);
    $Self->{TemplateObject} = Kernel::System::ITSMChange::Template->new(%Param);
    $Self->{ValidObject}    = Kernel::System::Valid->new(%Param);

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

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get change
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # error screen
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "No change found for change ID $ChangeID.",
            Comment => 'Please contact the admin.',
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

            # serialize the change
            my $TemplateContent = $Self->{TemplateObject}->TemplateSerialize(
                TemplateType => 'ITSMChange',
                StateReset   => $GetParam{StateReset} || 0,
                ChangeID     => $ChangeID,
                UserID       => $Self->{UserID},
            );

            # show error message
            if ( !$TemplateContent ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "The change '$ChangeID' could not be serialized.",
                    Comment => 'Please contact the admin.',
                );
            }

            # store the serialized change
            my $TemplateID = $Self->{TemplateObject}->TemplateAdd(
                Name         => $GetParam{TemplateName},
                Comment      => $GetParam{Comment},
                ValidID      => $GetParam{ValidID},
                TemplateType => 'ITSMChange',
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
                OP => $Self->{LastChangeView},
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
        TemplateFile => 'AgentITSMChangeTemplate',
        Data         => {
            %GetParam,
            ChangeID             => $ChangeID,
            ValidSelectionString => $ValidSelectionString,
            ChangeNumber         => $Change->{ChangeNumber},
            ChangeTitle          => $Change->{ChangeTitle},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
