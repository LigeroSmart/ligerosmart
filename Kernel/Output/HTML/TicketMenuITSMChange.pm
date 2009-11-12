# --
# Kernel/Output/HTML/TicketMenuITSMChange.pm - ITSMChange specific module for the ticket menu
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: TicketMenuITSMChange.pm,v 1.2 2009-11-12 09:00:56 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketMenuITSMChange;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

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

    # The link is shown only for the configured ticket types,
    # so the Ticket needs to have a type.
    return $Param{Counter} if !$Param{Ticket}->{Type};

    # get and check the list of relevant ticket types
    my $TicketTypes = $Param{Config}->{TicketTypes};

    return $Param{Counter} if !$TicketTypes;
    return $Param{Counter} if ref $TicketTypes ne 'ARRAY';

    # check whether the ticket's type is relevant
    my %IsRelevant = map { $_ => 1 } @{$TicketTypes};

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
