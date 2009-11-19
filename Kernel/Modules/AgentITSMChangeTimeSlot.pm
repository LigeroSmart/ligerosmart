# --
# Kernel/Modules/AgentITSMChangeTimeSlot.pm - the OTRS::ITSM::ChangeManagement move time slot module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeTimeSlot.pm,v 1.1 2009-11-19 14:36:07 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeTimeSlot;

use strict;
use warnings;

use Kernel::System::ITSMChange;

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

    # create needed objects
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
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # error screen, don't show change edit mask
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
            Message => "Change $ChangeID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (qw()) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # Remember the reason why saving was not attempted.
    # This entries are the names of the dtl validation error blocks.
    my @ValidationErrors;

    # update change
    if ( $Self->{Subaction} eq 'Save' ) {

        # update only when there are no validation errors
        if ( !@ValidationErrors ) {
            my $CouldMoveTimeSlot = 1;
            if ($CouldMoveTimeSlot) {

                # redirect to zoom mask
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMChangeZoom&ChangeID=$ChangeID",
                );
            }
            else {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Was not able to move time slot for Change $ChangeID!",
                    Comment => 'Please contact the admin.',
                );
            }
        }
    }

    # delete all keys from %GetParam when it is no Subaction
    else {
        %GetParam = ();
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Move Time Slot',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # Add the validation error messages as late as possible
    # as the enclosing blocks, e.g. 'RealizeTime' muss first be set.
    for my $BlockName (@ValidationErrors) {

        # show validation error message
        $Self->{LayoutObject}->Block(
            Name => $BlockName,
        );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeTimeSlot',
        Data         => {
            %Param,
            %{$Change},
            %GetParam,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
