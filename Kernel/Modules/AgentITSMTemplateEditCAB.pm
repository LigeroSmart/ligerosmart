# --
# Kernel/Modules/AgentITSMTemplateEditCAB.pm - the OTRS ITSM ChangeManagement template edit CAB module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMTemplateEditCAB;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::Template;
use Kernel::System::CustomerUser;

## nofilter(TidyAll::Plugin::OTRS::Perl::Dumper)
use Data::Dumper;

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
    $Self->{ChangeObject}       = Kernel::System::ITSMChange->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{TemplateObject}     = Kernel::System::ITSMChange::Template->new(%Param);

    # get config of frontend module
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

    # store all needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (
        qw(TemplateID TemplateContent NewCABMember NewCABMemberSelected NewCABMemberType AddCABMember)
        )
    {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # check needed stuff
    if ( !$GetParam{TemplateID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No TemplateID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get template data
    my $Template = $Self->{TemplateObject}->TemplateGet(
        TemplateID => $GetParam{TemplateID},
        UserID     => $Self->{UserID},
    );

    # check error
    if ( !$Template ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Template '$GetParam{TemplateID}' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # on first page load we fill the template content string parameter from the templete
    if ( !$Self->{Subaction} ) {
        $GetParam{TemplateContent} = $Template->{Content};
    }

    # de-serialize the CAB content
    my $CABReference = $Self->_CABDeSerialize(
        Content => $GetParam{TemplateContent},
        UserID  => $Self->{UserID},
    );

    # is cab member delete requested
    my %DeleteMember = $Self->_IsMemberDeletion(
        CABReference => $CABReference,
    );
    if (%DeleteMember) {

        # find users who are still member of CAB
        my $Type = $DeleteMember{Type};
        my @StillMembers = grep { $_ ne $DeleteMember{ID} } @{ $CABReference->{CABAdd}->{$Type} };

        # store the remaining members
        $CABReference->{CABAdd}->{$Type} = \@StillMembers;

        # reset the "save" subaction, because we only want to show the updated member list
        $Self->{Subaction} = '';
    }

    # server error hash, to store the items with ServerError class
    my %ServerError;

    # Remember the reason why saving was not attempted.
    # The entries are the names of the dtl validation error blocks.
    my @ValidationErrors;

    # add a CAB member
    if ( $GetParam{AddCABMember} && $GetParam{NewCABMember} ) {

        # add a member
        my %CABUpdateInfo = $Self->_IsNewCABMemberOk(
            CABReference => $CABReference,
            %GetParam,
        );

        # if member is valid
        if (%CABUpdateInfo) {

            # add new member
            $CABReference->{CABAdd}->{ $GetParam{NewCABMemberType} }
                = $CABUpdateInfo{ $GetParam{NewCABMemberType} };

            # do not display a name in autocomplete field
            # and do not set values in hidden fields as the
            # user was already added
            delete @GetParam{qw(NewCABMember NewCABMemberSelected NewCABMemberType)};
        }

        # if member is invalid
        else {
            $ServerError{NewCABMemberError} = 'ServerError';
        }

        # reset the "save" subaction, because we only want to show the updated member list
        $Self->{Subaction} = '';
    }

    # save the CAB template
    if ( $Self->{Subaction} eq 'Save' ) {

        # update the template
        my $UpdateSuccess = $Self->{TemplateObject}->TemplateUpdate(
            TemplateID => $GetParam{TemplateID},
            Content    => $GetParam{TemplateContent},
            UserID     => $Self->{UserID},
        );

        if ($UpdateSuccess) {

            # redirect to template overview
            # load new URL in parent window and close popup
            return $Self->{LayoutObject}->PopupClose(
                URL => "Action=AgentITSMTemplateOverview",
            );
        }
        else {

            # show error message
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Was not able to update Template '$GetParam{TemplateID}'!",
                Comment => 'Please contact the admin.',
            );
        }
    }

    # check if CAB contains anyone
    if ( @{ $CABReference->{CABAdd}->{CABAgents} } || @{ $CABReference->{CABAdd}->{CABCustomers} } )
    {
        $Self->{LayoutObject}->Block( Name => 'CABMemberTable' );
    }

    USERID:
    for my $UserID ( @{ $CABReference->{CABAdd}->{CABAgents} } ) {

        # get user data
        my %UserData = $Self->{UserObject}->GetUserData(
            UserID => $UserID,
        );

        # next if no user data can be found
        next USERID if !%UserData;

        # display cab member info
        $Self->{LayoutObject}->Block(
            Name => 'CABMemberRow',
            Data => {
                UserType         => 'Agent',
                InternalUserType => 'CABAgents',
                %UserData,
            },
        );
    }

    # show all customer members of CAB
    CUSTOMERLOGIN:
    for my $CustomerLogin ( @{ $CABReference->{CABAdd}->{CABCustomers} } ) {

        # get user data
        my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User  => $CustomerLogin,
            Valid => 1,
        );

        # next if no user data can be found
        next CUSTOMERLOGIN if !%CustomerUserData;

        # display cab member info
        $Self->{LayoutObject}->Block(
            Name => 'CABMemberRow',
            Data => {
                UserType         => 'Customer',
                InternalUserType => 'CABCustomers',
                %CustomerUserData,
            },
        );
    }

    # serialize the CAB to be used as parameter in hidden field
    $GetParam{TemplateContent} = $Self->_CABSerialize(
        Content => $CABReference,
        UserID  => 1,
    );

    # search init
    $Self->{LayoutObject}->Block(
        Name => 'CABMemberSearchInit',
        Data => {
            ItemID => 'NewCABMember',
        },
    );

    # output header and navigation
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Edit CAB Template',
        Type  => 'Small',
    );

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMTemplateEditCAB',
        Data         => {
            %Param,
            %{$Template},
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

    # info about what to delete
    my %DeleteInfo;

    # check possible agent ids
    AGENTID:
    for my $AgentID ( @{ $Param{CABReference}->{CABAdd}->{CABAgents} } ) {
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
        for my $CustomerID ( @{ $Param{CABReference}->{CABAdd}->{CABCustomers} } ) {
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

sub _IsNewCABMemberOk {
    my ( $Self, %Param ) = @_;

    # The member info will be returned.
    my %MemberInfo;

    # CABCustomers or CABAgents?
    my $MemberType = $Param{NewCABMemberType};

    # member lookup
    my %CurrentMemberLookup;

    # an agent is requested to be added
    if ( $MemberType eq 'CABAgents' ) {

        my %User = $Self->{UserObject}->GetUserData(
            UserID => $Param{NewCABMemberSelected},
        );

        if (%User) {

            # check current users
            USERID:
            for my $UserID ( @{ $Param{CABReference}->{CABAdd}->{$MemberType} } ) {

                # get user data
                my %UserData = $Self->{UserObject}->GetUserData(
                    UserID => $UserID,
                    Valid  => 1,
                );

                # remove invalid users from CAB
                next USERID if !$UserData{UserID};

                # store in lookup
                $CurrentMemberLookup{$UserID} = 1;
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

                $CurrentMemberLookup{ $User{UserID} } = 1;

                # save member infos
                %MemberInfo = (
                    $MemberType => [ sort keys %CurrentMemberLookup ],
                );
            }
        }
    }

    # an customer is requested to be added
    else {

        # check current customer users
        CUSTOMERUSER:
        for my $CustomerUser ( @{ $Param{CABReference}->{CABAdd}->{$MemberType} } ) {

            # get customer user data
            my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User  => $CustomerUser,
                Valid => 1,
            );

            # remove invalid customer users from CAB
            next CUSTOMERUSER if !%CustomerUserData;

            # store in lookup
            $CurrentMemberLookup{$CustomerUser} = 1;
        }

        # check if customer can be found
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerSearch(
            UserLogin => $Param{NewCABMemberSelected},
        );

        if ( $CustomerUser{ $Param{NewCABMemberSelected} } ) {

            $CurrentMemberLookup{ $Param{NewCABMemberSelected} } = 1;

            # save member infos
            %MemberInfo = (
                $MemberType => [ sort keys %CurrentMemberLookup ],
            );
        }
    }

    return %MemberInfo;
}

sub _CABDeSerialize {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID Content)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get the Perl datastructure
    my $VAR1;

    return if !eval "\$VAR1 = $Param{Content}; 1;";    ## no critic

    return if !$VAR1;
    return if ref $VAR1 ne 'HASH';

    return $VAR1;
}

sub _CABSerialize {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID Content)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # no indentation (saves space)
    local $Data::Dumper::Indent = 0;

    # do not use cross-referencing
    local $Data::Dumper::Deepcopy = 1;

    # serialize the data (do not use $VAR1, but $TemplateData for Dumper output)
    my $SerializedData = $Self->{MainObject}->Dump( $Param{Content}, 'binary' );

    return $SerializedData;
}

1;
