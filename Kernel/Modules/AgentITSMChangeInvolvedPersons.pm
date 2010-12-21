# --
# Kernel/Modules/AgentITSMChangeInvolvedPersons.pm - the OTRS::ITSM::ChangeManagement change involved persons module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentITSMChangeInvolvedPersons.pm,v 1.40 2010-12-21 05:13:50 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeInvolvedPersons;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::Template;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.40 $) [1];

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

    # create needed objects
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{ChangeObject}       = Kernel::System::ITSMChange->new(%Param);
    $Self->{TemplateObject}     = Kernel::System::ITSMChange::Template->new(%Param);

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

    # store all needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (
        qw(ChangeBuilder ChangeBuilderSelected ChangeManager ChangeManagerSelected
        NewCABMember NewCABMemberSelected NewCABMemberType CABTemplate CABMemberID
        AddCABMember AddCABTemplate TemplateID)
        )
    {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # server error hash, to store the items with ServerError class
    my %ServerError;

    # Remember the reason why saving was not attempted.
    # The entries are the names of the dtl validation error blocks.
    my @ValidationErrors;

    if ( $Self->{Subaction} eq 'Save' ) {

        #DELETE DELETE
        print STDERR $Self->{MainObject}->Dump( \%GetParam );

        # change manager and change builder are required for an update
        my %ErrorAllRequired = $Self->_CheckChangeManagerAndChangeBuilder(
            %GetParam,
        );

        # is cab member delete requested
        my %DeleteMember = $Self->_IsMemberDeletion(
            Change => $Change,
        );

        # update change
        if ( $GetParam{AddCABMember} && $GetParam{NewCABMember} ) {

            # add a member
            my %CABUpdateInfo = $Self->_IsNewCABMemberOk(
                %GetParam,
                Change => $Change,
            );

            # if member is valid
            if (%CABUpdateInfo) {

                # update change CAB
                my $CouldUpdateCAB = $Self->{ChangeObject}->ChangeCABUpdate(
                    %CABUpdateInfo,
                    ChangeID => $Change->{ChangeID},
                    UserID   => $Self->{UserID},
                );

                # if update was successful
                if ($CouldUpdateCAB) {

                    # get new change data as a member was added
                    $Change = $Self->{ChangeObject}->ChangeGet(
                        ChangeID => $Change->{ChangeID},
                        UserID   => $Self->{UserID},
                    );

                    # do not display a name in autocomplete field
                    # and do not set values in hidden fields as the
                    # user was already added
                    delete @GetParam{qw(NewCABMember NewCABMemberSelected NewCABMemberType)};
                }
                else {

                    # show error message
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => "Was not able to update Change CAB for Change $ChangeID!",
                        Comment => 'Please contact the admin.',
                    );
                }
            }

            # if member is invalid
            else {
                $ServerError{NewCABMemberError} = 'ServerError';
            }
        }
        elsif ( $GetParam{AddCABTemplate} ) {

            if ( $GetParam{TemplateID} ) {

                # create CAB based on the template
                my $CreatedID = $Self->{TemplateObject}->TemplateDeSerialize(
                    TemplateID => $GetParam{TemplateID},
                    UserID     => $Self->{UserID},
                    ChangeID   => $ChangeID,
                );

                # redirect to involved person, when adding was successful
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMChangeInvolvedPersons;ChangeID=$ChangeID",
                );
            }

            # notify about the missing template id
            $ServerError{TemplateIDError} = 'ServerError';
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
        elsif ( !%ErrorAllRequired ) {

            # update change
            my $CanUpdateChange = $Self->{ChangeObject}->ChangeUpdate(
                ChangeID        => $ChangeID,
                ChangeManagerID => $GetParam{ChangeManagerSelected},
                ChangeBuilderID => $GetParam{ChangeBuilderSelected},
                UserID          => $Self->{UserID},
            );

            # check successful update
            if ($CanUpdateChange) {

                # redirect to change zoom mask
                # load new URL in parent window and close popup
                return $Self->{LayoutObject}->PopupClose(
                    URL => $Self->{LastChangeView},
                );
            }
            else {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Was not able to update Change $ChangeID!",
                    Comment => 'Please contact the admin.',
                );
            }
        }
        elsif (%ErrorAllRequired) {

            # show error message for change builder
            if ( $ErrorAllRequired{ChangeBuilder} ) {
                $ServerError{ChangeBuilderError} = 'ServerError';
            }

            # show error message for change manager
            if ( $ErrorAllRequired{ChangeManager} ) {
                $ServerError{ChangeManagerError} = 'ServerError';
            }
        }
    }

    # set default values if it is not 'Save' subaction
    else {

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
                $ChangeManager = sprintf '"%s %s" <%s>',
                    $ChangeManager{UserFirstname},
                    $ChangeManager{UserLastname},
                    $ChangeManager{UserEmail};
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
                $ChangeBuilder = sprintf '"%s %s" <%s>',
                    $ChangeBuilder{UserFirstname},
                    $ChangeBuilder{UserLastname},
                    $ChangeBuilder{UserEmail};
            }
        }

        # fill GetParam hash
        %GetParam = (
            ChangeManager   => $ChangeManager,
            ChangeManagerID => $Change->{ChangeManagerID},
            ChangeBuilder   => $ChangeBuilder,
            ChangeBuilderID => $Change->{ChangeBuilderID},
        );
    }

    # show all agent members of CAB
    if ( @{ $Change->{CABAgents} } ) {
        $Self->{LayoutObject}->Block( Name => 'CABMemberTable' );
    }

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
            Name => 'CABMemberRow',
            Data => {
                UserType => 'Agent',
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
            Name => 'CABMemberRow',
            Data => {
                UserType => 'Customer',
                %CustomerUser,
            },
        );
    }

    # build changebuilder and changemanager search autocomplete field
    my $UserAutoCompleteConfig
        = $Self->{ConfigObject}->Get('ITSMChange::Frontend::UserSearchAutoComplete');

    my $AutoComplete = 'true';
    if ( !$UserAutoCompleteConfig->{Active} ) {
        $AutoComplete = 'false';
    }

    # code and return blocks for change builder and change manager (AgentITSMUserSearch.dtl)
    for my $Group (qw( itsm-change-manager itsm-change-builder )) {

        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoComplete',
            Data => {
                minQueryLength      => $UserAutoCompleteConfig->{MinQueryLength}      || 2,
                queryDelay          => $UserAutoCompleteConfig->{QueryDelay}          || 0.1,
                maxResultsDisplayed => $UserAutoCompleteConfig->{MaxResultsDisplayed} || 20,
                dynamicWidth        => $UserAutoCompleteConfig->{DynamicWidth}        || 'false',
                groups              => $Group,
            },
        );

        my $ItemID = 'ChangeManager';
        if ( $Group eq 'itsm-change-builder' ) {
            $ItemID = 'ChangeBuilder';
        }

        $Self->{LayoutObject}->Block(
            Name => 'UserSearchInit',
            Data => {
                ItemID             => $ItemID,
                ActiveAutoComplete => $AutoComplete,
            },
        );

    }

    # show validation errors in CABTemplate block
    my %ValidationErrorNames;
    my $TemplateError = '';

    $ValidationErrorNames{@ValidationErrors} = (1) x @ValidationErrors;

    for my $ChangeTemplateValidationError (qw(InvalidTemplate)) {
        if ( $ValidationErrorNames{$ChangeTemplateValidationError} ) {
            $ServerError{TemplateIDError} = 'ServerError';
        }
    }

    # build template dropdown
    my $TemplateList = $Self->{TemplateObject}->TemplateList(
        UserID        => $Self->{UserID},
        CommentLength => 15,
        TemplateType  => 'CAB',
    );

    my $TemplateDropDown = $Self->{LayoutObject}->BuildSelection(
        Name         => 'TemplateID',
        Data         => $TemplateList,
        PossibleNone => 1,
    );

    # show block with template dropdown
    $Self->{LayoutObject}->Block(
        Name => 'CABTemplate',
        Data => {
            CABTemplateStrg => $TemplateDropDown,
        },
    );

    # build CAB member search autocomplete field
    my $CABMemberAutoCompleteConfig
        = $Self->{ConfigObject}->Get('ITSMChange::Frontend::CABMemberSearchAutoComplete');

    # CABMember
    $Self->{LayoutObject}->Block(
        Name => 'CABMemberSearchAutoComplete',
        Data => {
            minQueryLength      => $CABMemberAutoCompleteConfig->{MinQueryLength}      || 2,
            queryDelay          => $CABMemberAutoCompleteConfig->{QueryDelay}          || 0.1,
            typeAhead           => $CABMemberAutoCompleteConfig->{TypeAhead}           || 'false',
            maxResultsDisplayed => $CABMemberAutoCompleteConfig->{MaxResultsDisplayed} || 20,
            dynamicWidth        => $CABMemberAutoCompleteConfig->{DynamicWidth}        || 1,
        },
    );

    my $ActiveAutoComplete = 'true';
    if ( !$CABMemberAutoCompleteConfig->{Active} ) {
        $ActiveAutoComplete = 'false';
    }

    # search init
    $Self->{LayoutObject}->Block(
        Name => 'CABMemberSearchInit',
        Data => {
            ActiveAutoComplete => $ActiveAutoComplete,
            ItemID             => 'NewCABMember',
            }
    );

    # output header and navigation
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Involved Persons',
        Type  => 'Small',
    );

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeInvolvedPersons',
        Data         => {
            %Param,
            %{$Change},
            %GetParam,
            %ServerError,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}

sub _IsMemberDeletion {
    my ( $Self, %Param ) = @_;

    # do not detect deletion when no subaction is given
    return if !$Self->{Subaction};

    # check needed stuff
    return if !$Param{Change};

    # info about what to delete
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

    # The hash with the error info will be returned.
    my %Errors;

    ROLE:
    for my $Role (qw(ChangeBuilder ChangeManager)) {

        # check the role
        if ( !$Param{$Role} || !$Param{ $Role . 'Selected' } ) {
            $Errors{$Role} = 1;
            next ROLE;
        }

        # get user data
        my %User = $Self->{UserObject}->GetUserData(
            UserID => $Param{ $Role . 'Selected' },
        );

        # show error if user does not exist
        if ( !%User ) {
            $Errors{$Role} = 1;
            next ROLE;
        }

        # Check whether the input has been manually edited.
        # Look for exact match at beginning,
        # as $User{UserLastname} might contain a trailing 'out of office' note.
        # Note that this won't catch deletions of $Param{$Role} at the end.
        my $CheckString = sprintf '"%s %s" <%s>',
            $User{UserFirstname},
            $User{UserLastname},
            $User{UserEmail};
        if ( index( $CheckString, $Param{$Role} ) != 0 ) {
            $Errors{$Role} = 1;
        }
    }

    #DELETE DELETE
    print STDERR $Self->{MainObject}->Dump( \%Errors );

    return %Errors
}

sub _IsNewCABMemberOk {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{Change};

    # The member info will be returned.
    my %MemberInfo;

    # CABCustomers or CABAgents?
    my $MemberType = $Param{NewCABMemberType};

    # current members
    my @CurrentMembers;

    # an agent is requested to be added
    if ( $MemberType eq 'Agent' ) {
        my %User = $Self->{UserObject}->GetUserData(
            UserID => $Param{CABMemberID},
        );

        if (%User) {

            # check current users
            USERID:
            for my $UserID ( @{ $Param{Change}->{$MemberType} } ) {

                # get user data
                my %UserData = $Self->{UserObject}->GetUserData(
                    UserID => $UserID,
                    Valid  => 1,
                );

                # remove invalid users from CAB
                next USERID if !$UserData{UserID};

                push @CurrentMembers, $UserID;
            }

            # Compare input value with user data.
            # Look for exact match at beginning,
            # as $User{UserLastname} might contain a trailing 'out of office' note.
            # Note that this won't catch deletions of $Param{NewCABMember} at the end.
            my $CheckString = sprintf '"%s %s" <%s>',
                $User{UserFirstname},
                $User{UserLastname},
                $User{UserEmail};
            if ( index( $CheckString, $Param{NewCABMember} ) == 0 ) {

                # save member infos
                %MemberInfo = (
                    $MemberType => [ @CurrentMembers, $User{UserID} ],
                );
            }
        }
    }

    # an customer is requested to be added
    else {

        # check current customer users
        CUSTOMERUSER:
        for my $CustomerUser ( @{ $Param{Change}->{$MemberType} } ) {

            # get customer user data
            my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User  => $CustomerUser,
                Valid => 1,
            );

            # remove invalid customer users from CAB
            next CUSTOMERUSER if !%CustomerUserData;

            push @CurrentMembers, $CustomerUser;
        }

        # For the sanity check we use the same function as we use for Autocompletion
        # and customer user expansion
        # CustomerSearch() does funny formating, when it thinks that it has
        # encountered an Email-address.
        # Furthermore the returned hash from CustomerSearch() depends on the setting of
        # 'CustomerUserListFields'.
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerSearch(
            UserLogin => $Param{NewCABMemberSelected},
        );

        if ( scalar( keys %CustomerUser ) == 1 ) {

            # compare input value with user data
            # string comparision can be used for checking, as there are no 'out of office' notes
            my ($CheckString) = values %CustomerUser;
            if ( $CheckString eq $Param{NewCABMember} ) {

                # save member infos
                %MemberInfo = (
                    $MemberType => [ @CurrentMembers, $Param{NewCABMemberSelected} ],
                );
            }
        }
    }

    return %MemberInfo;
}

sub _GetExpandInfo {
    my ( $Self, %Param ) = @_;

    my %Info;

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

    for my $Name (qw(Builder Manager)) {

        # the fields in .dtl have a number at the end
        my $Key = $Name eq 'Manager' ? 1 : 2;

        # handle the "search user" button for either ExpandBuilder or ExpandManager
        if ( $Param{ 'Expand' . $Name . '1' } ) {

            # search agents
            my %UserFound = $Self->{UserObject}->UserSearch(
                Search => $Param{ 'Change' . $Name } . '*',
                Valid  => 1,
            );

            # UserSearch() returns values with a trailing space, get rid of it
            for my $Name ( values %UserFound ) {
                $Name =~ s{ \s+ \z }{}xms;
            }

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
            if ( scalar @KeysUserList == 1 ) {

                # if user is found, display the name
                $Info{ 'Change' . $Name } = $UserList{ $KeysUserList[0] };

                # get user
                my %UserData = $Self->{UserObject}->GetUserData(
                    UserID => $KeysUserList[0],
                );

                # if user is found set hidden field
                if ( $UserData{UserID} ) {
                    $Info{ 'SelectedUser' . $Key } = $UserData{UserID};
                }
            }

            # if more the one user exists, show list
            # and clean UserID
            else {

                # reset input field
                $Info{ 'SelectedUser' . $Key } = '';

                # build drop down with found users
                $Info{ 'Change' . $Name . 'Strg' } = $Self->{LayoutObject}->BuildSelection(
                    Name => 'Change' . $Name . 'ID',
                    Data => \%UserList,
                );

                # show 'take this user' button
                $Self->{LayoutObject}->Block(
                    Name => 'TakeChange' . $Name,
                );

                # clear to if there is no customer found
                if ( !%UserList ) {
                    $Info{ 'Change' . $Name }      = '';
                    $Info{ 'SelectedUser' . $Key } = '';
                }
            }
        }

        # handle the "take this user" button
        elsif ( $Param{ 'Expand' . $Name . '2' } ) {

            # show user data
            my $UserID   = $Param{ 'Change' . $Name . 'ID' };
            my %UserData = $Self->{UserObject}->GetUserData(
                UserID => $UserID,
            );

            # if user is found
            if (%UserData) {

                # set hidden field
                $Info{ 'SelectedUser' . $Key } = $UserID;
                $Info{ 'Change' . $Name }      = sprintf '"%s %s" <%s>',
                    $UserData{UserFirstname},
                    $UserData{UserLastname},
                    $UserData{UserEmail};
            }
        }
    }

    if ( $Param{ExpandCABMember1} ) {

        # search agents
        my %UserFound = $Self->{UserObject}->UserSearch(
            Search => $Param{'NewCABMember'} . '*',
            Valid  => 1,
        );

        # UserSearch() returns values with a trailing space, get rid of it
        for my $Name ( values %UserFound ) {
            $Name =~ s{ \s+ \z }{}xms;
        }

        # filter the itsm-change users in found users
        my @UserList;
        CHANGEUSERID:
        for my $ChangeUserID ( keys %UserFound ) {

            # save found user in @UserList
            push @UserList, {
                Name => $UserFound{$ChangeUserID},
                ID   => $ChangeUserID,
                Type => 'CABAgents',
            };
        }

        # search customers
        my %CustomerUserFound = $Self->{CustomerUserObject}->CustomerSearch(
            Search => $Param{'NewCABMember'} . '*',
            Valid  => 1,
        );

        # save found customer users in @UserList
        for my $CustomerUserID ( keys %CustomerUserFound ) {

            push @UserList, {
                Name => $CustomerUserFound{$CustomerUserID},
                ID   => $CustomerUserID,
                Type => 'CABCustomers',
            };
        }

        # check if just one customer user exists
        # if just one, fillup CustomerUserID and CustomerID
        if ( scalar @UserList == 1 ) {

            # if user is found, display the name
            $Info{NewCABMember}  = $UserList[0]->{Name};
            $Info{CABMemberID}   = $UserList[0]->{ID};
            $Info{CABMemberType} = $UserList[0]->{Type};
        }

        # if more the one user exists, show list
        # and clean UserID
        else {

            # build list for drop down
            my @UserListForDropDown;
            for my $User (@UserList) {
                push @UserListForDropDown, {
                    Key   => $User->{ID},
                    Value => $User->{Name},
                };
            }

            # reset input field
            $Info{NewCABMember} = '';

            # build drop down with found users
            $Info{CABMemberStrg} = $Self->{LayoutObject}->BuildSelection(
                Name => 'MemberID',
                Data => \@UserListForDropDown,
            );

            # show 'take this user' button
            $Self->{LayoutObject}->Block(
                Name => 'TakeCABMember',
            );

            # clear to if there is no customer found
            if ( !@UserList ) {
                $Info{'NewCABMember'}  = '';
                $Info{'CABMemberID'}   = '';
                $Info{'CABMemberType'} = '';
            }
        }
    }

    # handle the "take this user" button
    elsif ( $Param{ExpandCABMember2} ) {

        # show user data
        my $UserID = $Param{'MemberID'};
        my %UserData;

        if ( $UserID =~ m{ \A \d+ \z }xms ) {
            %UserData = $Self->{UserObject}->GetUserData(
                UserID => $UserID,
            );
        }

        # if user is found
        if (%UserData) {

            # set hidden field
            $Info{'CABMemberID'}   = $UserID;
            $Info{'CABMemberType'} = 'CABAgents';
            $Info{'NewCABMember'}  = sprintf '%s %s %s',
                $UserData{UserLogin},
                $UserData{UserFirstname},
                $UserData{UserLastname};
        }

        # maybe it's a customer user
        else {

            # get customer user data
            my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User  => $UserID,
                Valid => 1,
            );

            # if user is found
            if (%CustomerUserData) {

                # set hidden field
                $Info{'CABMemberID'}   = $UserID;
                $Info{'CABMemberType'} = 'CABCustomers';
                $Info{'NewCABMember'}  = sprintf '%s %s %s',
                    $CustomerUserData{UserFirstname},
                    $CustomerUserData{UserLastname},
                    $CustomerUserData{UserEmail};
            }
        }
    }

    return %Info;
}

1;
