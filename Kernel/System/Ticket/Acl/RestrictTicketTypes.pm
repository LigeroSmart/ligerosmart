# --
# Kernel/System/Ticket/Acl/RestrictTicketTypes.pm - acl module
# - restrict the usage of the ticket types as defined in
# - sysconfig option 'ITSMChange::AddChangeLinkTicketTypes' to certain groups -
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: RestrictTicketTypes.pm,v 1.5 2009-11-19 16:42:35 mae Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Acl::RestrictTicketTypes;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (
        qw(ConfigObject DBObject TicketObject LogObject UserObject MainObject TimeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Config Acl)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check if user id is given
    return 1 if !$Param{UserID};

    # get and check the list of relevant ticket types
    my $AddChangeLinkTicketTypes
        = $Self->{ConfigObject}->Get('ITSMChange::AddChangeLinkTicketTypes');

    return 1 if !$AddChangeLinkTicketTypes;
    return 1 if ref $AddChangeLinkTicketTypes ne 'ARRAY';
    return 1 if !@{$AddChangeLinkTicketTypes};

    # create a lookup hash for the relevant ticket types
    my %IsRelevant = map { $_ => 1 } @{$AddChangeLinkTicketTypes};

    # if ticket id was given
    if ( $Param{TicketID} ) {

        # get ticket data
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $Param{TicketID},
        );

        # check if ticket exists
        return 1 if !%Ticket;

        # don't remove relevant types from type list
        # if the ticket type is already one of these types
        return 1 if $IsRelevant{ $Ticket{Type} };
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
    $Param{Acl}->{RestrictTicketTypes} = {

        # remove ticket types listed in sysconfig option 'ITSMChange::AddChangeLinkTicketTypes'
        # from type dropdown list in all frontend modules
        PossibleNot => {
            Ticket => {
                Type => $AddChangeLinkTicketTypes,
            },
        },
    };

    return 1;
}

1;
