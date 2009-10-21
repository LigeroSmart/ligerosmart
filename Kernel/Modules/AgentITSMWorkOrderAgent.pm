# --
# Kernel/Modules/AgentITSMWorkOrderAgent.pm - the OTRS::ITSM::ChangeManagement work order agent edit module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMWorkOrderAgent.pm,v 1.11 2009-10-21 13:07:02 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderAgent;

use strict;
use warnings;

use Kernel::System::Group;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::WorkOrder;
use Kernel::System::User;

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
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::WorkOrder->new(%Param);
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new(%Param);
    $Self->{UserObject}      = Kernel::System::User->new(%Param);
    $Self->{GroupObject}     = Kernel::System::Group->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChangeManagement::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

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

    if ( !$WorkOrder ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "WorkOrder $WorkOrder not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    my $ExpandUserName1 = $Self->{ParamObject}->GetParam( Param => 'ExpandUserName1' );
    my $ExpandUserName2 = $Self->{ParamObject}->GetParam( Param => 'ExpandUserName2' );
    my $ClearUser       = $Self->{ParamObject}->GetParam( Param => 'ClearUser' );
    my $ExpandUserName = $ExpandUserName1 || $ExpandUserName2 || $ClearUser || 0;

    my $WorkOrderAgentID = $Self->{ParamObject}->GetParam( Param => 'SelectedUser' );

    if ( $Self->{Subaction} eq 'Save' && !$WorkOrderAgentID ) {
        $Self->{LayoutObject}->Block(
            Name => 'InvalidUser',
        );

        $ExpandUserName = 1;
    }

    # update workorder
    if ( $Self->{Subaction} eq 'Save' && !$ExpandUserName && $WorkOrderAgentID ) {
        my $Success = $Self->{WorkOrderObject}->WorkOrderUpdate(
            WorkOrderID      => $WorkOrder->{WorkOrderID},
            WorkOrderAgentID => $WorkOrderAgentID,
            UserID           => $Self->{UserID},
        );

        if ( !$Success ) {

            # show error message
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Was not able to update WorkOrder $WorkOrder->{WorkOrderID}!",
                Comment => 'Please contact the admin.',
            );
        }
        else {

            # redirect to zoom mask
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMWorkOrderZoom&WorkOrderID=$WorkOrder->{WorkOrderID}",
            );
        }
    }
    elsif ($ExpandUserName1) {

        # search agents
        my %UserFound = $Self->{UserObject}->UserSearch(
            Search => $Self->{ParamObject}->GetParam( Param => 'User' ),
            Valid => 1,
        );

        # get group of group itsm-change
        my $GroupID = $Self->{GroupObject}->GroupLookup(
            Group => 'itsm-change',
        );

        # get members of group
        my %ITSMChangeUsers = $Self->{GroupObject}->GroupMemberList(
            GroupID => $GroupID,
            Type    => 'ro',
            Result  => 'HASH',
            Cached  => 1,
        );

        # filter the itsm-change users in found users
        my %UserList;
        CHANGEUSERID:
        for my $ChangeUserID ( keys %ITSMChangeUsers ) {
            next CHANGEUSERID if !$UserFound{$ChangeUserID};

            $UserList{$ChangeUserID} = $UserFound{$ChangeUserID};
        }

        # check if just one customer user exists
        # if just one, fillup CustomerUserID and CustomerID
        my @KeysUserList = keys %UserList;
        if ( 1 == scalar @KeysUserList ) {
            $Param{User} = $UserList{ $KeysUserList[0] };

            my %UserData = $Self->{UserObject}->GetUserData(
                UserID => $KeysUserList[0],
            );

            if ( $UserData{UserID} ) {
                $Param{UserID} = $UserData{UserID};
            }
        }

        # if more the one user exists, show list
        # and clean UserID
        else {

            $Param{UserID} = '';

            $Param{"UserStrg"} = $Self->{LayoutObject}->BuildSelection(
                Name => 'UserID',
                Data => \%UserList,
            );

            # clear to if there is no customer found
            if ( !%UserList ) {
                $Param{User}   = '';
                $Param{UserID} = '';
            }
        }
    }
    elsif ($ExpandUserName2) {

        # show user data
        my $UserID = $Self->{ParamObject}->GetParam( Param => 'UserID' );
        my %UserData = $Self->{UserObject}->GetUserData(
            UserID => $UserID,
        );

        if (%UserData) {
            $Param{UserID} = $UserID;
            $Param{User}   = sprintf '%s %s %s',
                $UserData{UserLogin},
                $UserData{UserFirstname},
                $UserData{UserLastname};
        }
    }

    # show current workorder agent
    if ( !$ExpandUserName && $WorkOrder->{WorkOrderAgentID} ) {
        my %UserData = $Self->{UserObject}->GetUserData(
            UserID => $WorkOrder->{WorkOrderAgentID},
        );

        $Param{UserID} = $UserData{UserID};
        $Param{User}   = sprintf '%s %s %s',
            $UserData{UserLogin},
            $UserData{UserFirstname},
            $UserData{UserLastname};
    }

    # get change that workorder belongs to
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not find Change for WorkOrder $WorkOrder!",
            Comment => 'Please contact the admin.',
        );
    }

    # build user search autocomplete field
    my $AutoCompleteConfig
        = $Self->{ConfigObject}->Get('ITSMChange::Frontend::UserSearchAutoComplete');
    if ( $AutoCompleteConfig->{Active} ) {
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoComplete',
        );
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteCode',
            Data => {
                minQueryLength      => $AutoCompleteConfig->{MinQueryLength}      || 2,
                queryDelay          => $AutoCompleteConfig->{QueryDelay}          || 0.1,
                typeAhead           => $AutoCompleteConfig->{TypeAhead}           || 'false',
                maxResultsDisplayed => $AutoCompleteConfig->{MaxResultsDisplayed} || 20,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteReturn',
            Data => {},
        );
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteReturnElements',
            Data => {},
        );
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteDivStart',
        );
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteDivEnd',
        );
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'SearchUserButton',
        );
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => $WorkOrder->{WorkOrderTitle},
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderAgent',
        Data         => {
            %Param,
            %{$Change},
            %{$WorkOrder},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
