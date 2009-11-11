# --
# Kernel/Output/HTML/TicketMenuITSMChange.pm - ITSMChange specific module for the ticket menu
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: TicketMenuITSMChange.pm,v 1.1 2009-11-11 14:28:53 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketMenuITSMChange;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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

    # TODO: check TicketType

    # check permission
    my $Config = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Param{Config}->{Action}");
    if ($Config) {
        if ( $Config->{Permission} ) {
            my $Access = $Self->{ChangeObject}->Permission(
                Type   => $Config->{Permission},
                UserID => $Self->{UserID},
                LogNo  => 1,
            );
            return $Param{Counter} if !$Access;
        }
    }

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
