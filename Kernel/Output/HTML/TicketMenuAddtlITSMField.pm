# --
# Kernel/Output/HTML/TicketMenuAddtlITSMField.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: TicketMenuAddtlITSMField.pm,v 1.1.1.1 2008-06-30 08:58:41 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::TicketMenuAddtlITSMField;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1.1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject LogObject LayoutObject UserID TicketObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Ticket} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Ticket!' );
        return;
    }

    if (
        !defined( $Param{ACL}->{ $Param{Config}->{Action} } )
        || $Param{ACL}->{ $Param{Config}->{Action} }
        )
    {

        $Self->{LayoutObject}->Block( Name => 'Menu' );

        if ( $Param{Counter} ) {
            $Self->{LayoutObject}->Block( Name => 'MenuItemSplit' );
        }

        $Self->{LayoutObject}->Block(
            Name => 'MenuItem',
            Data => {
                %{ $Param{Config} },
                %Param,
                Name        => 'Additional ITSM Fields',
                Description => 'Additional ITSM Fields',
                Link        => 'Action=AgentTicketAddtlITSMField&TicketID=$QData{"TicketID"}',
            },
        );

        $Param{Counter}++;
    }

    return $Param{Counter};
}

1;
