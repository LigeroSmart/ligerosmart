# --
# Kernel/Output/HTML/NavBarChangeManager.pm
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: NavBarChangeManager.pm,v 1.4 2010-04-27 20:39:02 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NavBarChangeManager;

use strict;
use warnings;

use Kernel::System::ITSMChange;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject TicketObject GroupObject LayoutObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create needed objects
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # define action, group, label, image and prio
    my $Action = 'AgentITSMChangeManager';
    my $Group  = 'itsm-change-manager';
    my $Label  = 'ChangeManager';
    my $Image  = 'new-message.png';
    my $Prio   = '0991000';

    # get config of frontend module
    my $Config = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Action");

    # get the group id
    my $GroupID = $Self->{GroupObject}->GroupLookup( Group => $Group );

    # deny access, when the group is not found
    return if !$GroupID;

    # get user groups, where the user has the appropriate privilege
    my %Groups = $Self->{GroupObject}->GroupMemberList(
        UserID => $Self->{UserID},
        Type   => $Config->{Permission},
        Result => 'HASH',
        Cached => 1,
    );

    # deny access if the agent doesn't have the appropriate type in the appropriate group
    return if !$Groups{$GroupID};

    # do not show icon if frontend module is not registered
    return if !$Self->{ConfigObject}->Get('Frontend::Module')->{$Action};

    # get the number of viewable changes
    my $Count = 0;
    if ( $Config->{'Filter::ChangeStates'} && @{ $Config->{'Filter::ChangeStates'} } ) {

        # count the number of viewable changes
        $Count = $Self->{ChangeObject}->ChangeSearch(
            ChangeManagerIDs => [ $Self->{UserID} ],
            ChangeStates     => $Config->{'Filter::ChangeStates'},
            Limit            => 1000,
            Result           => 'COUNT',
            UserID           => $Self->{UserID},
        );
    }

    # build icon label
    my $Text = $Self->{LayoutObject}->{LanguageObject}->Get($Label) . " ($Count)";

    # build icon data
    my %Icon = (
        $Prio => {
            Block       => 'ItemPersonal',
            Description => $Text,
            Name        => $Text,
            Image       => $Image,
            Link        => 'Action=' . $Action,
            AccessKey   => '',
        },
    );

    return %Icon;
}

1;
