# --
# Kernel/Output/HTML/TicketMenuITSMChange.pm - ITSMChange specific module for the ticket menu
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: TicketMenuITSMChange.pm,v 1.4 2009-11-13 16:55:41 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketMenuITSMChange;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

use Kernel::System::ITSMChange;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID GroupObject TicketObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create needed objects
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Ticket} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Ticket!' );
        return;
    }

    # check if frontend module is registered, if not, do not show action
    if ( $Param{Config}->{Action} ) {
        my $Module = $Self->{ConfigObject}->Get('Frontend::Module')->{ $Param{Config}->{Action} };
        return $Param{Counter} if !$Module;
    }

    # the link is shown only for the configured ticket types,
    # so the ticket needs to have a type.
    return $Param{Counter} if !$Param{Ticket}->{Type};

    # get and check the list of relevant ticket types
    my $AddChangeLinkTicketTypes
        = $Self->{ConfigObject}->Get('ITSMChange::AddChangeLinkTicketTypes');

    return $Param{Counter} if !$AddChangeLinkTicketTypes;
    return $Param{Counter} if ref $AddChangeLinkTicketTypes ne 'ARRAY';
    return $Param{Counter} if !@{$AddChangeLinkTicketTypes};

    # check whether the ticket's type is relevant
    my %IsRelevant = map { $_ => 1 } @{$AddChangeLinkTicketTypes};

    return $Param{Counter} if !$IsRelevant{ $Param{Ticket}->{Type} };

    # check permission
    my $FrontendConfig
        = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Param{Config}->{Action}");
    if ( $FrontendConfig && $FrontendConfig->{Permission} ) {
        my $Access = $Self->{ChangeObject}->Permission(
            Type   => $FrontendConfig->{Permission},
            UserID => $Self->{UserID},
            LogNo  => 1,
        );

        return $Param{Counter} if !$Access;
    }

    # display the menu item
    $Self->{LayoutObject}->Block(
        Name => 'Menu',
        Data => {},
    );
    if ( $Param{Counter} ) {
        $Self->{LayoutObject}->Block(
            Name => 'MenuItemSplit',
            Data => {},
        );
    }
    $Self->{LayoutObject}->Block(
        Name => 'MenuItem',
        Data => { %{ $Param{Config} }, %{ $Param{Ticket} }, %Param, },
    );
    $Param{Counter}++;

    return $Param{Counter};
}

1;
