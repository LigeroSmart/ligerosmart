# --
# Kernel/System/Ticket/Acl/RestrictRFCTicketType.pm - acl module
# - restrict the usage of the ticket type 'RfC' to certain groups -
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: RestrictRFCTicketType.pm,v 1.2 2009-11-12 10:54:56 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Acl::RestrictRFCTicketType;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject DBObject TicketObject LogObject UserObject MainObject TimeObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Config Acl)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if user id is given
    return 1 if !$Param{UserID};

    # if ticket id was given
    if ( $Param{TicketID} ) {

        # get ticket data
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $Param{TicketID},
        );

        # check if ticket exists
        return 1 if !%Ticket;

        # don't remove type 'RfC' from type list if ticket already has this type
        return 1 if $Ticket{Type} eq 'RfC';
    }

    # get user groups, where the user has the rw privilege
    my %Groups = $Self->{GroupObject}->GroupMemberList(
        UserID => $Param{UserID},
        Type   => 'rw',
        Result => 'HASH',
        Cached => 1,
    );

    # check if the user is in one of these groups
    for my $Group (qw(itsm-change itsm-change-builder itsm-change-manager)) {

        # get the group id
        my $GroupID = $Self->{GroupObject}->GroupLookup(
            Group => $Group,
        );

        # do not remove the ticket type 'RfC' if user is in one of the groups
        return 1 if $Groups{$GroupID};
    }

    # generate acl
    $Param{Acl}->{RestrictRFCTicketType} = {

        # remove ticket type 'RfC' from type dropdown list
        PossibleNot => {
            Ticket => {
                Type => ['RfC'],
            },
        },
    };

    return 1;
}

1;
