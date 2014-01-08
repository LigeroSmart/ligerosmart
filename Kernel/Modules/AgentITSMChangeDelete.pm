# --
# Kernel/Modules/AgentITSMChangeDelete.pm - the OTRS ITSM ChangeManagement change delete module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeDelete;

use strict;
use warnings;

use Kernel::System::ITSMChange;

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
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new(%Param);

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

    # get change data
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # check if change is found
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change '$ChangeID' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # build a lookup hash for the allowed change states
    my %AllowedChangeStates = map { $_ => 1 } @{ $Self->{Config}->{ChangeStates} };

    # only allow deletion if change is in one of the allowed change states
    if ( !$AllowedChangeStates{ $Change->{ChangeState} } ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change '$ChangeID' does not have an allowed change state to be deleted!",
            Comment => 'Please contact the admin.',
        );
    }

    if ( $Self->{Subaction} eq 'ChangeDelete' ) {

        # delete the change
        my $CouldDeleteChange = $Self->{ChangeObject}->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => $Self->{UserID},
        );

        if ($CouldDeleteChange) {

            # redirect to change overview, when the deletion was successful
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMChange",
            );
        }
        else {

            # show error message, when delete failed
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Was not able to delete the change ID $ChangeID!",
                Comment => 'Please contact the administrator.',
            );
        }
    }

    # set the dialog type. As default, the dialog will have 2 buttons: Yes and No
    my $DialogType = 'Confirmation';

    # output content
    my $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeDelete',
        Data         => {
            %Param,
            %{$Change},
        },
    );

    # build the returned data structure
    my %Data = (
        HTML       => $Output,
        DialogType => $DialogType,
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
