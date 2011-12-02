# --
# Kernel/Output/HTML/ToolBarMyChanges.pm
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ToolBarMyChanges.pm,v 1.5 2011-12-02 11:08:14 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBarMyChanges;

use strict;
use warnings;

use Kernel::System::ITSMChange;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(ConfigObject LogObject DBObject TicketObject UserObject GroupObject LayoutObject UserID)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create needed objects
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # define action, group, label, image and prio
    my $Action = 'AgentITSMChangeMyChanges';
    my $Group  = 'itsm-change-builder';

    # do not show icon if frontend module is not registered
    return if !$Self->{ConfigObject}->Get('Frontend::Module')->{$Action};

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
    );

    # deny access if the agent doesn't have the appropriate type in the appropriate group
    return if !$Groups{$GroupID};

    # get the number of viewable changes
    my $Count = 0;
    if ( $Config->{'Filter::ChangeStates'} && @{ $Config->{'Filter::ChangeStates'} } ) {

        # count the number of viewable changes
        $Count = $Self->{ChangeObject}->ChangeSearch(
            ChangeBuilderIDs => [ $Self->{UserID} ],
            ChangeStates     => $Config->{'Filter::ChangeStates'},
            Limit            => 1000,
            Result           => 'COUNT',
            MirrorDB         => 1,
            UserID           => $Self->{UserID},
        );
    }

    # get ToolBar object parameters
    my $Class = $Param{Config}->{CssClass};
    my $Text  = $Self->{LayoutObject}->{LanguageObject}->Get('My Changes');

    # set ToolBar object
    my $URL      = $Self->{LayoutObject}->{Baselink};
    my $Priority = $Param{Config}->{Priority};
    my %Return;
    if ($Count) {
        $Return{$Priority} = {
            Block       => 'ToolBarItem',
            Description => $Text,
            Count       => $Count,
            Class       => $Class,
            Link        => $URL . 'Action=' . $Action,
            AccessKey   => '',
        };
    }
    return %Return;
}

1;
