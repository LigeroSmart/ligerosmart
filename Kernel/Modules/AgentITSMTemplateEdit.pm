# --
# Kernel/Modules/AgentITSMTemplateEdit.pm - the template edit module
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMTemplateEdit.pm,v 1.3 2010-01-21 12:44:00 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMTemplateEdit;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::Template;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

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

    # get config for frontend
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type   => $Self->{Config}->{Permission},
        UserID => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permission!",
            WithHeader => 'yes',
        );
    }

    # get needed TemplateID
    my $TemplateID = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

    # check needed stuff
    if ( !$TemplateID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No TemplateID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (qw(TemplateName Comment ValidID)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    my @ValidationErrors;

    # update the template
    if ( $Self->{Subaction} eq 'UpdateTemplate' ) {

        # check validity of the template name
        my $TemplateName = $GetParam{TemplateName};
        if ( !$TemplateName ) {
            push @ValidationErrors, 'InvalidTemplateName';
        }

        if ( !@ValidationErrors ) {
            my $CouldUpdateTemplate = $Self->{TemplateObject}->TemplateUpdate(
                TemplateID => $TemplateID,
                Name       => $GetParam{TemplateName},
                Comment    => $GetParam{Comment},
                ValidID    => $GetParam{ValidID},
                UserID     => $Self->{UserID},
            );

            if ($CouldUpdateTemplate) {

                # redirect to zoom mask, TODO: use the stored last view
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMTemplateOverview",
                );
            }
            else {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Was not able to update Template $TemplateID!",
                    Comment => 'Please contact the admin.',
                );
            }
        }
    }
    else {

        # initially use the data from $Template
        %GetParam = ();
    }

    # get template data
    my $Template = $Self->{TemplateObject}->TemplateGet(
        TemplateID => $TemplateID,
        UserID     => $Self->{UserID},
    );

    # check error
    if ( !$Template ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Template $TemplateID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # fix up the name
    $Template->{TemplateName} = $Template->{Name};

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => $Template->{TemplateName},
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    my $ValidSelectionString = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{ValidObject}->ValidList(),
        },
        Name       => 'ValidID',
        SelectedID => $GetParam{ValidID}
            || $Template->{ValidID}
            || ( $Self->{ValidObject}->ValidIDsGet() )[0],
        Sort => 'NumericKey',
    );

    # add the validation error messages
    for my $BlockName (@ValidationErrors) {
        $Self->{LayoutObject}->Block( Name => $BlockName );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMTemplateEdit',
        Data         => {
            %{$Template},
            %GetParam,
            ValidSelectionString => $ValidSelectionString,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
