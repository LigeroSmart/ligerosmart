# --
# Kernel/Modules/AgentITSMChangeInvolvedPersons.pm - the OTRS::ITSM::ChangeManagement change involved persons module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeInvolvedPersons.pm,v 1.4 2009-10-21 20:40:43 reb Exp $
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
$VERSION = qw($Revision: 1.4 $) [1];

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
        ExpandBuilder1 ExpandBuilder2 ExpandManager1 ExpandManager2
        ExpandMember1 ExpandMember2 NewMemberType NewMemberID
        SelectedUser1 SelectedUser2
        AddCABMember AddCABTemplate)
        )
    {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # changemanager and changebuilder is required for an update
    my %ErrorAllRequired = $Self->_CheckChangeManagerAndChangeBuilder(
        %GetParam,
    );

    # is a "search user" button clicked
    my $ExpandUser = 0;

    # is cab member delete requested
    my %DeleteMember = $Self->_IsMemberDeletion(
        Change => $Change,
    );

    # update workorder
    if ( $GetParam{AddCABMember} && $GetParam{NewCABMember} ) {

        # add a member
    }
    elsif ( $GetParam{AddCABTemplate} ) {

        # add a template
    }
    elsif (%DeleteMember) {

        # find users who are still member of CAB
        my $Type = $DeleteMember{Type};
        my @StillMembers = grep { $_ ne $DeleteMember{ID} } @{ $Change->{$Type} };

        # update ChangeCAB
        my $CouldUpdateCABMember = $Self->{ChangeObject}->ChangeCABUpdate(
            ChangeID => $Change->{ChangeID},
            $Type    => \@StillMembers,
            UserID   => $Self->{UserID},
        );

        # check successful update
        if ( !$CouldUpdateCABMember ) {

            # show error message
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Was not able to update Change CAB for Change $ChangeID!",
                Comment => 'Please contact the admin.',
            );
        }

        # get new change data as a member was removed
        $Change = $Self->{ChangeObject}->ChangeGet(
            ChangeID => $Change->{ChangeID},
            UserID   => $Self->{UserID},
        );
    }
    elsif ($ExpandUser) {

    }
    elsif ( $Self->{Subaction} eq 'Save' && !%ErrorAllRequired ) {

        # update change
        my $CanUpdateChange = $Self->{ChangeObject}->ChangeUpdate(
            ChangeID        => $ChangeID,
            ChangeManagerID => $GetParam{SelectedUser1},
            ChangeBuilderID => $GetParam{SelectedUser2},
            UserID          => $Self->{UserID},
        );

        # check successful update
        if ( !$CanUpdateChange ) {

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
    elsif ( $Self->{Subaction} eq 'Save' && %ErrorAllRequired ) {

        # show error message for change builder
        if ( $ErrorAllRequired{ChangeBuilder} ) {
            $Self->{LayoutObject}->Block(
                Name => 'InvalidChangeBuilder',
            );
        }

        # show error message for change manager
        if ( $ErrorAllRequired{ChangeManager} ) {
            $Self->{LayoutObject}->Block(
                Name => 'InvalidChangeManager',
            );
        }
    }

    # set default values if it is not 'Save' subaction
    if ( $Self->{Subaction} ne 'Save' ) {

        # initialize variables
        my $ChangeManager = '';
        my $ChangeBuilder = '';

        # get changemanager string
        if ( $Change->{ChangeManagerID} ) {

            # get changemanager data
            my %ChangeManager = $Self->{UserObject}->GetUserData(
                UserID => $Change->{ChangeManagerID},
            );

            if (%ChangeManager) {

                # build string to display
                $ChangeManager = sprintf '%s %s %s ',
                    $ChangeManager{UserLogin},
                    $ChangeManager{UserFirstname},
                    $ChangeManager{UserLastname};
            }
        }

        # get changebuilder string
        if ( $Change->{ChangeBuilderID} ) {

            # get changebuilder data
            my %ChangeBuilder = $Self->{UserObject}->GetUserData(
                UserID => $Change->{ChangeBuilderID},
            );

            if (%ChangeBuilder) {

                # build string to display
                $ChangeBuilder = sprintf '%s %s %s ',
                    $ChangeBuilder{UserLogin},
                    $ChangeBuilder{UserFirstname},
                    $ChangeBuilder{UserLastname};
            }
        }

        # fill GetParam hash
        %GetParam = (
            SelectedUser1 => $Change->{ChangeManagerID},
            SelectedUser2 => $Change->{ChangeBuilderID},
            ChangeManager => $ChangeManager,
            ChangeBuilder => $ChangeBuilder,
        );
    }

    # show all agent members of CAB
    USERID:
    for my $UserID ( @{ $Change->{CABAgents} } ) {

        # get user data
        my %User = $Self->{UserObject}->GetUserData(
            UserID => $UserID,
        );

        # next if no user data can be found
        next USERID if !%User;

        # display cab member info
        $Self->{LayoutObject}->Block(
            Name => 'AgentCAB',
            Data => {
                %User,
            },
        );

    }

    # show all customer members of CAB
    CUSTOMERLOGIN:
    for my $CustomerLogin ( @{ $Change->{CABCustomers} } ) {

        # get user data
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User  => $CustomerLogin,
            Valid => 1,
        );

        # next if no user data can be found
        next CUSTOMERLOGIN if !%CustomerUser;

        # display cab member info
        $Self->{LayoutObject}->Block(
            Name => 'CustomerCAB',
            Data => {
                %CustomerUser,
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

        # TODO: autocomplete for newcabmember
    }
    else {

        # show usersearch buttons for change manager
        $Self->{LayoutObject}->Block(
            Name => 'SearchUserButton1',
        );

        # show usersearch buttons for change builder
        $Self->{LayoutObject}->Block(
            Name => 'SearchUserButton2',
        );

        # TODO: show usersearch buttons for newcabmember
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

sub _IsMemberDeletion {
    my ( $Self, %Param ) = @_;

    # do not detect deletion when no subaction is given
    return if !$Self->{Subaction};

    # check needed stuff
    return if !$Param{Change};

    my %DeleteInfo;

    # check possible agent ids
    AGENTID:
    for my $AgentID ( @{ $Param{Change}->{CABAgents} } ) {
        if ( $Self->{ParamObject}->GetParam( Param => 'DeleteCABAgent' . $AgentID ) ) {

            # save info
            %DeleteInfo = (
                Type => 'CABAgents',
                ID   => $AgentID,
            );

            last AGENTID;
        }
    }

    if ( !%DeleteInfo ) {

        # check possible customer ids
        CUSTOMERID:
        for my $CustomerID ( @{ $Param{Change}->{CABCustomers} } ) {
            if ( $Self->{ParamObject}->GetParam( Param => 'DeleteCABCustomer' . $CustomerID ) ) {

                # save info
                %DeleteInfo = (
                    Type => 'CABCustomers',
                    ID   => $CustomerID,
                );

                last CUSTOMERID;
            }
        }
    }

    return %DeleteInfo;
}

sub _CheckChangeManagerAndChangeBuilder {
    my ( $Self, %Param ) = @_;

    my %Errors;

    # check change manager
    if ( !$Param{ChangeManager} || !$Param{SelectedUser1} ) {
        $Errors{ChangeManager} = 1;
    }
    else {

        # get changemanager data
        my %ChangeManager = $Self->{UserObject}->GetUserData(
            UserID => $Param{SelectedUser1},
        );

        # show error if user not exists
        if ( !%ChangeManager ) {
            $Errors{ChangeManager} = 1;
        }
        else {

            # compare input value with user data
            my $CheckString = sprintf '%s %s %s ',
                $ChangeManager{UserLogin},
                $ChangeManager{UserFirstname},
                $ChangeManager{UserLastname};

            # show error
            if ( $CheckString ne $Param{ChangeManager} ) {
                $Errors{ChangeManager} = 1;
            }
        }
    }

    # check change builder
    if ( !$Param{ChangeBuilder} || !$Param{SelectedUser2} ) {
        $Errors{ChangeBuilder} = 1;
    }
    else {

        # get changemanager data
        my %ChangeBuilder = $Self->{UserObject}->GetUserData(
            UserID => $Param{SelectedUser2},
        );

        # show error if user not exists
        if ( !%ChangeBuilder ) {
            $Errors{ChangeBuilder} = 1;
        }
        else {

            # compare input value with user data
            my $CheckString = sprintf '%s %s %s ',
                $ChangeBuilder{UserLogin},
                $ChangeBuilder{UserFirstname},
                $ChangeBuilder{UserLastname};

            # show error
            if ( $CheckString ne $Param{ChangeBuilder} ) {
                $Errors{ChangeBuilder} = 1;
            }
        }
    }

    return %Errors
}

1;
