# --
# Kernel/Modules/AgentITSMTemplateEdit.pm - the template edit module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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
        Action => $Self->{Action},
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
            Comment => 'Please contact the administrator.',
        );
    }

    # get template data
    my $Template = $Self->{TemplateObject}->TemplateGet(
        TemplateID => $TemplateID,
        UserID     => $Self->{UserID},
    );

    # check error
    if ( !$Template ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Template '$TemplateID' not found in database!",
            Comment => 'Please contact the administrator.',
        );
    }

    my %GetParam;

    # update the template
    if ( $Self->{Subaction} eq 'UpdateTemplate' ) {

        # store needed parameters in %GetParam to make it reloadable
        for my $ParamName (qw(TemplateName Comment ValidID)) {
            $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
        }

        # check validity of the template name
        my $TemplateName = $GetParam{TemplateName} || $Template->{Name};

        if ($TemplateName) {

            my $CouldUpdateTemplate = $Self->{TemplateObject}->TemplateUpdate(
                TemplateID => $TemplateID,
                Name       => $TemplateName,
                Comment    => $GetParam{Comment},
                ValidID    => $GetParam{ValidID} || $Template->{ValidID},
                UserID     => $Self->{UserID},
            );

            if ($CouldUpdateTemplate) {

                # load new URL in parent window and close popup
                return $Self->{LayoutObject}->PopupClose(
                    URL => "Action=AgentITSMTemplateOverview",
                );
            }
            else {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Was not able to update Template $TemplateID!",
                    Comment => 'Please contact the administrator.',
                );
            }
        }
    }
    else {

        # no subaction
    }

    # fix up the name
    $Template->{TemplateName} = $GetParam{TemplateName} || $Template->{Name};

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Type  => 'Small',
        Title => $Template->{TemplateName},
    );

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
