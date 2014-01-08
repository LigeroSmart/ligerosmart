# --
# Kernel/Modules/AgentITSMChangeCABTemplate.pm - the OTRS ITSM ChangeManagement add CAB template module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeCABTemplate;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::Template;
use Kernel::System::Valid;

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
        Action   => $Self->{Action},
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
    for my $ParamName (qw(TemplateName Comment ValidID)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # return ServerError class when needed
    my %ServerError;

    # add a template
    if ( $Self->{Subaction} eq 'AddTemplate' ) {

        # check validity of the template name
        if ( !$GetParam{TemplateName} ) {
            $ServerError{TemplateNameServerError} = 'ServerError';
        }

        if ( !%ServerError ) {

            # serialize the change
            my $TemplateContent = $Self->{TemplateObject}->TemplateSerialize(
                TemplateType => 'CAB',
                ChangeID     => $ChangeID,
                UserID       => $Self->{UserID},
            );

            # show error message
            if ( !$TemplateContent ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "The CAB of change '$ChangeID' could not be serialized.",
                    Comment => 'Please contact the admin.',
                );
            }

            # store the serialized change
            my $TemplateID = $Self->{TemplateObject}->TemplateAdd(
                Name         => $GetParam{TemplateName},
                Comment      => $GetParam{Comment},
                ValidID      => $GetParam{ValidID},
                TemplateType => 'CAB',
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
                OP => "Action=AgentITSMChangeInvolvedPersons;ChangeID=$ChangeID",
            );
        }
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Template',
        Type  => 'Small',
    );

    my $ValidSelectionString = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{ValidObject}->ValidList(),
        },
        Name       => 'ValidID',
        SelectedID => $GetParam{ValidID} || ( $Self->{ValidObject}->ValidIDsGet() )[0],
        Sort       => 'NumericKey',
    );

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeCABTemplate',
        Data         => {
            %GetParam,
            %ServerError,
            ChangeID             => $ChangeID,
            ValidSelectionString => $ValidSelectionString,
            ChangeNumber         => $Change->{ChangeNumber},
            ChangeTitle          => $Change->{ChangeTitle},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}

1;
