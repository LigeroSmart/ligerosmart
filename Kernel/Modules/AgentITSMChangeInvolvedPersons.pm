# --
# Kernel/Modules/AgentITSMChangeInvolvedPersons.pm - the OTRS::ITSM::ChangeManagement change involved persons module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeInvolvedPersons.pm,v 1.3 2009-10-21 13:07:02 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeInvolvedPersons;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::User;
use Kernel::System::CustomerUser;

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

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{UserObject}         = Kernel::System::User->new(%Param);
    $Self->{ChangeObject}       = Kernel::System::ITSMChange->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChangeManagement::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ChangeID = $Self->{ParamObject}->GetParam( Param => 'ChangeID' );

    # check needed stuff
    if ( !$ChangeID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No ChangeID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get workorder data
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change $ChangeID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # store all needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (
        qw(ChangeBuilder ChangeManager NewCABMember CABTemplate
        ExpandBuilder1 ExpandBuilder2 ExpandManager1 ExpandManager2)
        )
    {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    my $AllRequired = $GetParam{ChangeBuilder} && $GetParam{ChangeManager};
    my $DeleteMember = 0;

    # update workorder
    if ( $Self->{ParamObject}->GetParam( Param => 'AddCABMember' ) ) {

        # add a member
    }
    if ( $Self->{ParamObject}->GetParam( Param => 'AddCABTemplate' ) ) {

        # add a template
    }
    elsif ( $Self->{Subaction} eq 'Save' && $AllRequired && !$DeleteMember ) {
        my $Success = $Self->{ChangeObject}->ChangeCABUpdate(
            ChangeID => $ChangeID,
            UserID   => $Self->{UserID},
        );

        if ( !$Success ) {

            # show error message
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Was not able to update Change $ChangeID!",
                Comment => 'Please contact the admin.',
            );
        }
        else {

            # redirect to zoom mask
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMChangeZoom&ChangeID=$ChangeID",
            );
        }
    }
    elsif ( $Self->{Subaction} eq 'Save' && !$AllRequired ) {

        # show error message for change builder
        if ( !$GetParam{ChangeBuilder} ) {
            $Self->{LayoutObject}->Block(
                Name => 'InvalidChangeBuilder',
            );
        }

        # show error message for change manager
        if ( !$GetParam{ChangeManager} ) {
            $Self->{LayoutObject}->Block(
                Name => 'InvalidChangeManager',
            );
        }
    }

    # show all customer members of CAB
    CUSTOMERLOGIN:
    for my $CustomerLogin ( @{ $Change->{CABCustomers} } ) {
        my %CustomerUser = $Self->{CustomerUserObject}->GetCustomerUserData(
            User  => $CustomerLogin,
            Valid => 1,
        );

        next CUSTOMERLOGIN if !%CustomerUser;

        $Self->{LayoutObject}->Block(
            Name => 'CustomerCAB',
            Data => {
                %CustomerUser,
            },
        );
    }

    # show all agent members of CAB
    USERID:
    for my $UserID ( @{ $Change->{CABAgents} } ) {
        my %User = $Self->{UserObject}->GetUserData(
            UserID => $UserID,
            Valid  => 1,
        );

        next USERID if !%User;

        $Self->{LayoutObject}->Block(
            Name => 'AgentCAB',
            Data => {
                %User,
            },
        );

    }

    # build changebuilder and changemanager search autocomplete field
    my $AutoCompleteConfig
        = $Self->{ConfigObject}->Get('ITSMChange::Frontend::UserSearchAutoComplete');
    if ( $AutoCompleteConfig->{Active} ) {

        # general blocks
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoComplete',
        );

        # change manager
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteCode',
            Data => {
                minQueryLength      => $AutoCompleteConfig->{MinQueryLength}      || 2,
                queryDelay          => $AutoCompleteConfig->{QueryDelay}          || 0.1,
                typeAhead           => $AutoCompleteConfig->{TypeAhead}           || 'false',
                maxResultsDisplayed => $AutoCompleteConfig->{MaxResultsDisplayed} || 20,
                InputNr             => 1,
            },
        );

        # change builder
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteCode',
            Data => {
                minQueryLength      => $AutoCompleteConfig->{MinQueryLength}      || 2,
                queryDelay          => $AutoCompleteConfig->{QueryDelay}          || 0.1,
                typeAhead           => $AutoCompleteConfig->{TypeAhead}           || 'false',
                maxResultsDisplayed => $AutoCompleteConfig->{MaxResultsDisplayed} || 20,
                InputNr             => 2,
            },
        );

        # general block
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteReturn',
        );

        # change manager
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteReturnElements',
            Data => {
                InputNr => 1,
            },
        );

        # change builder
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteReturnElements',
            Data => {
                InputNr => 2,
            },
        );

        # change manager
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteDivStart1',
        );
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteDivEnd1',
        );

        # change builder
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteDivStart2',
        );
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteDivEnd2',
        );
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'SearchUserButton1',
        );
        $Self->{LayoutObject}->Block(
            Name => 'SearchUserButton2',
        );
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Involved Persons',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeInvolvedPersons',
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
