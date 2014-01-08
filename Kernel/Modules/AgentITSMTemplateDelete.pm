# --
# Kernel/Modules/AgentITSMTemplateDelete.pm - the OTRS ITSM ChangeManagement template delete module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMTemplateDelete;

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
            Comment => 'Please contact the admin.',
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
            Comment => 'Please contact the admin.',
        );
    }

    if ( $Self->{Subaction} eq 'TemplateDelete' ) {

        my $CouldDeleteTemplate = $Self->{TemplateObject}->TemplateDelete(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        if ($CouldDeleteTemplate) {

            # redirect to change zoom mask, when update was successful
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMTemplateOverview",
            );
        }
        else {

            # show error message, when delete failed
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Was not able to delete the template $TemplateID!",
                Comment => 'Please contact the admin.',
            );
        }
    }

    # output content
    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMTemplateDelete',
        Data         => {
            %{$Template},
        },
    );

    # build the returned data structure
    my %Data = (
        HTML       => $Output,
        DialogType => 'Confirmation',
    );

    # return JSON-String because of AJAX-Mode
    my $OutputJSON = $Self->{LayoutObject}->JSONEncode( Data => \%Data );

    return $Self->{LayoutObject}->Attachment(
        ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
        Content     => $OutputJSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
