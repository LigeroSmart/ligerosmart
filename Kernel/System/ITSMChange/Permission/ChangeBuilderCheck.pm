# --
# Kernel/System/ITSMChange/Permission/ChangeBuilderCheck.pm - change builder based permission check
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ChangeBuilderCheck.pm,v 1.4 2009-11-02 17:16:45 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Permission::ChangeBuilderCheck;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject ChangeObject UserObject GroupObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserID Type)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );

            return;
        }
    }

    # the check is based upon the change builder
    my $GroupID = $Self->{GroupObject}->GroupLookup( Group => 'itsm-change-builder' );

    # deny access, when the group is not found
    return if !$GroupID;

    # get user groups, where the user has the appropriate privilege
    my %Groups = $Self->{GroupObject}->GroupMemberList(
        UserID => $Param{UserID},
        Type   => $Param{Type},
        Result => 'HASH',
        Cached => 1,
    );

    # deny access if the agent doens't have the appropriate type in the appropriate group
    return if !$Groups{$GroupID};

    # change builders always get ro access
    return 1 if $Param{Type} eq 'ro';

    # Allow a change builder to create a change, when there isn't a change yet.
    return 1 if !$Param{ChangeID};

    # there already is a change. e.g. AgentITSMChangeEdit
    my $Change = $Self->{ChangeObject}->ChangeGet(
        UserID   => $Param{UserID},
        ChangeID => $Param{ChangeID},
    );

    # allow access, when the agent is the change builder of the change
    return 1 if $Change->{ChangeBuilderID} && $Change->{ChangeBuilderID} == $Param{UserID};

    # deny rw access otherwise
    return;
}

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=head1 VERSION

$Id: ChangeBuilderCheck.pm,v 1.4 2009-11-02 17:16:45 bes Exp $

=cut

1;
