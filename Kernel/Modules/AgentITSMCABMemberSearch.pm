# --
# Kernel/Modules/AgentITSMCABMemberSearch.pm - a module used for the autocomplete feature
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMCABMemberSearch.pm,v 1.6 2009-12-13 14:28:05 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMCABMemberSearch;

use strict;
use warnings;

use Kernel::System::User;
use Kernel::System::CustomerUser;
use Kernel::System::Group;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{UserObject}         = Kernel::System::User->new(%Param);
    $Self->{GroupObject}        = Kernel::System::Group->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    # get config
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $JSON = '';

    # search for possible CAB members
    if ( !$Self->{Subaction} ) {

        # get needed params
        my $Search = $Self->{ParamObject}->GetParam( Param => 'Search' ) || '';
        my $Groups = $Self->{ParamObject}->GetParam( Param => 'Groups' ) || '';

        # get all members of the groups
        my %GroupUsers;
        if ($Groups) {
            my @GroupNames = split /,\s+/, $Groups;

            for my $GroupName (@GroupNames) {
                my $GroupID = $Self->{GroupObject}->GroupLookup(
                    Group => $GroupName,
                );

                # get user groups
                my %Users = $Self->{GroupObject}->GroupMemberList(
                    GroupID => $GroupID,
                    Type    => 'ro',
                    Result  => 'HASH',
                    Cached  => 1,
                );

                my @UserIDs = keys %Users;
                @GroupUsers{@UserIDs} = @UserIDs;
            }
        }

        # get agent list
        my %UserList = $Self->{UserObject}->UserSearch(
            Search => $Search,
            Valid  => 1,
        );

        # UserSearch() returns values with a trailing space, get rid of it
        for my $Name ( values %UserList ) {
            $Name =~ s{ \s+ \z }{}xms;
        }

        # build data
        my @Data;

        USERID:
        for my $UserID (
            sort { $UserList{$a} cmp $UserList{$b} }
            keys %UserList
            )
        {

            # if groups are required and user is not member of one of the groups
            # the skip the user
            next USERID if $Groups && !$GroupUsers{$UserID};

            # html quote characters like <>
            my $UserValuePlain = $UserList{$UserID};
            $UserList{$UserID} = $Self->{LayoutObject}->Ascii2Html(
                Text => $UserList{$UserID},
            );

            push @Data, {
                UserKey        => $UserID,
                UserValue      => $UserList{$UserID},
                UserValuePlain => $UserValuePlain,
                UserType       => 'CABAgents',
            };
        }

        # get customer list
        my %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
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

            # html quote characters like <>
            my $CustomerUserValuePlain = $CustomerUserList{$CustomerUserLogin};
            $CustomerUserList{$CustomerUserLogin} = $Self->{LayoutObject}->Ascii2Html(
                Text => $CustomerUserList{$CustomerUserLogin},
            );

            push @Data, {
                UserKey        => $CustomerUserLogin,
                UserValue      => $CustomerUserList{$CustomerUserLogin},
                UserValuePlain => $CustomerUserValuePlain,
                UserType       => 'CABCustomers',
            };
        }

        # build JSON output
        $JSON = $Self->{LayoutObject}->JSON(
            Data => {
                Response => {
                    Results => \@Data,
                    }
            },
        );
    }

    # send JSON response
    return $Self->{LayoutObject}->Attachment(
        ContentType => 'text/plain; charset=' . $Self->{LayoutObject}->{Charset},
        Content     => $JSON || '',
        Type        => 'inline',
        NoCache     => 1,
    );

}

1;
