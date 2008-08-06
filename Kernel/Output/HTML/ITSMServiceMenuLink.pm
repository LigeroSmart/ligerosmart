# --
# Kernel/Output/HTML/ITSMServiceMenuLink.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ITSMServiceMenuLink.pm,v 1.1 2008-08-06 07:39:57 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::ITSMServiceMenuLink;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject LogObject DBObject LayoutObject ServiceObject LinkObject UserID)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Service} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Service!' );
        return;
    }

    # check if services can be linked with other objects
    my %PossibleObjects = $Self->{LinkObject}->PossibleObjectsList(
        Object => 'Service',
        UserID => $Self->{UserID},
    );

    # don't show link menu item if there are no linkable objects
    return if !%PossibleObjects;

    $Self->{LayoutObject}->Block( Name => 'Menu' );
    if ( $Param{Counter} ) {
        $Self->{LayoutObject}->Block( Name => 'MenuItemSplit' );
    }

    $Self->{LayoutObject}->Block(
        Name => 'MenuItem',
        Data => {
            %Param,
            %{ $Param{Service} },
            %{ $Param{Config} },
        },
    );

    $Param{Counter}++;

    return $Param{Counter};
}

1;
