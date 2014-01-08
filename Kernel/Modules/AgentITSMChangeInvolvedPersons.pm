# --
# Kernel/Modules/AgentITSMChangeInvolvedPersons.pm - the OTRS ITSM ChangeManagement change involved persons module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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

    # store all needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (
        qw(ChangeBuilder ChangeBuilderSelected ChangeManager ChangeManagerSelected
        NewCABMember NewCABMemberSelected NewCABMemberType CABTemplate AddCABMember
        AddCABTemplate TemplateID NewTemplate Submit)
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

        # go to store the new template
        if ( $GetParam{NewTemplate} ) {
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMChangeCABTemplate;ChangeID=$ChangeID",
            );
        }

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

        # just update change when submit button clicked
        elsif ( !%ErrorAllRequired && $GetParam{Submit} ) {

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
                    URL => "Action=AgentITSMChangeZoom;ChangeID=$ChangeID",
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

        # show field errors just when submit
        elsif ( %ErrorAllRequired && $GetParam{Submit} ) {

            # show error message for change builder
            if ( $ErrorAllRequired{ChangeBuilder} ) {
                $ServerError{ChangeBuilderError} = 'ServerError';
            }

            # show error message for change manager
            if ( $ErrorAllRequired{ChangeManager} ) {
                $ServerError{ChangeManagerError} = 'ServerError';
            }
        }

        # use the selected change and builder managers
        if ( $GetParam{ChangeManagerSelected} ) {
            $Change->{ChangeManagerID} = $GetParam{ChangeManagerSelected};
        }

        if ( $GetParam{ChangeBuilderSelected} ) {
            $Change->{ChangeBuilderID} = $GetParam{ChangeBuilderSelected};
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
    if ( @{ $Change->{CABAgents} } || @{ $Change->{CABCustomers} } ) {
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
                UserType         => 'Agent',
                InternalUserType => 'CABAgents',
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
                UserType         => 'Customer',
                InternalUserType => 'CABCustomers',
                %CustomerUser,
            },
        );
    }

    # code and return blocks for change builder and change manager (AgentITSMUserSearch.dtl)
    for my $ItemID (qw(ChangeManager ChangeBuilder)) {
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchInit',
            Data => {
                ItemID => $ItemID,
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

    # if CAB Members show New Template Button
    if ( @{ $Change->{CABAgents} } || @{ $Change->{CABCustomers} } ) {
        $Self->{LayoutObject}->Block( Name => 'NewTemplateButton' );
    }

    # search init
    $Self->{LayoutObject}->Block(
        Name => 'CABMemberSearchInit',
        Data => {
            ItemID => 'NewCABMember',
        },
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
        if ( $Self->{ParamObject}->GetParam( Param => 'DeleteCABAgents' . $AgentID ) ) {

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
            if ( $Self->{ParamObject}->GetParam( Param => 'DeleteCABCustomers' . $CustomerID ) ) {

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
    if ( $MemberType eq 'CABAgents' ) {
        my %User = $Self->{UserObject}->GetUserData(
            UserID => $Param{NewCABMemberSelected},
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

        # remove spaces at the end of the string
        for my $Value ( sort values %CustomerUser ) {
            $Value =~ s{ \s* \z }{}xms;
        }

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

1;
