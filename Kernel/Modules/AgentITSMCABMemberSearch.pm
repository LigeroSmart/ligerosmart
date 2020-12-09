# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentITSMCABMemberSearch;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $JSON = '';

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # search for possible CAB members
    if ( !$Self->{Subaction} ) {

        # get param object
        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

        # get needed params
        my $Search = $ParamObject->GetParam( Param => 'Term' )   || '';
        my $Groups = $ParamObject->GetParam( Param => 'Groups' ) || '';

        # get all members of the groups
        my %GroupUsers;
        if ($Groups) {
            my @GroupNames = split /,\s+/, $Groups;

            for my $GroupName (@GroupNames) {

                # get group object
                my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

                my $GroupID = $GroupObject->GroupLookup(
                    Group => $GroupName,
                );

                # get user groups
                my %Users = $GroupObject->GroupMemberList(
                    GroupID => $GroupID,
                    Type    => 'ro',
                    Result  => 'HASH',
                    Cached  => 1,
                );

                my @UserIDs = keys %Users;
                @GroupUsers{@UserIDs} = @UserIDs;
            }
        }

        # get user object
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # get agent list
        my %UserList = $UserObject->UserSearch(
            Search => $Search,
            Valid  => 1,
        );

        # UserSearch() returns values with a trailing space, get rid of it
        for my $Name ( values %UserList ) {
            $Name =~ s{ \s+ \z }{}xms;
        }

        # the data that will be sent as response
        my @Data;

        USERID:
        for my $UserID ( sort { $UserList{$a} cmp $UserList{$b} } keys %UserList ) {

            # if groups are required and user is not member of one of the groups
            # the skip the user
            next USERID if $Groups && !$GroupUsers{$UserID};

            # The values in %UserList are in the form: 'mm Max Mustermann'.
            # So assemble a neater string for display.
            # (Actually UserSearch() contains code for formating, but that is usually not called.)
            my %User = $UserObject->GetUserData(
                UserID => $UserID,
                Valid  => $Param{Valid},
            );
            my $UserValuePlain = sprintf '"%s" <%s>',
                $User{UserFullname},
                $User{UserEmail};

            push @Data, {
                UserKey   => $UserID,
                UserValue => $UserValuePlain,
                UserType  => 'CABAgents',
            };
        }

        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # get customer list
        my %CustomerUserList = $CustomerUserObject->CustomerSearch(
            Search => $Search,
            Valid  => 1,
        );

        CUSTOMERUSERLOGIN:
        for my $CustomerUserLogin (
            sort { $CustomerUserList{$a} cmp $CustomerUserList{$b} }
            keys %CustomerUserList
            )
        {

            # if groups are required and user is not member of one of the groups
            # the skip the user
            next USERID if $Groups && !$GroupUsers{$CustomerUserLogin};

            my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
                User => $CustomerUserLogin,
            );

            my $CustomerUserValuePlain = '"' . $CustomerUser{UserFullname} . '" <' . $CustomerUser{UserEmail} . '>';

            push @Data, {
                UserKey   => $CustomerUserLogin,
                UserValue => $CustomerUserValuePlain,
                UserType  => 'CABCustomers',
            };
        }

        # build JSON output
        $JSON = $LayoutObject->JSONEncode(
            Data => \@Data,
        );
    }

    # send JSON response
    return $LayoutObject->Attachment(
        ContentType => 'text/plain; charset=' . $LayoutObject->{Charset},
        Content     => $JSON || '',
        Type        => 'inline',
        NoCache     => 1,
    );

}

1;
