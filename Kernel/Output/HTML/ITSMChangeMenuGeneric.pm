# --
# Kernel/Output/HTML/ITSMChangeMenuGeneric.pm
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMChangeMenuGeneric.pm,v 1.2 2009-11-05 12:27:09 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ITSMChangeMenuGeneric;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ConfigObject EncodeObject LogObject DBObject LayoutObject ChangeObject UserID)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Change} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Change!' );
        return;
    }

    # get config for the relevant action
    my $FrontendConfig
        = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Param{Config}->{Action}");

    my $Access;
    if ( !$FrontendConfig || !$FrontendConfig->{Permission} ) {

        # Display the menu-link, when no privilege is required
        $Access = 1;
    }
    else {

        # check permissions, based on the required privilege
        $Access = $Self->{ChangeObject}->Permission(
            Type     => $FrontendConfig->{Permission},
            ChangeID => $Param{Change}->{ChangeID},
            UserID   => $Self->{UserID},
        );
    }

    return $Param{Counter} if !$Access;

    # output menu block
    $Self->{LayoutObject}->Block( Name => 'Menu' );

    # output seperator
    if ( $Param{Counter} ) {
        $Self->{LayoutObject}->Block( Name => 'MenuItemSplit' );
    }

    # output menu item
    $Self->{LayoutObject}->Block(
        Name => 'MenuItem',
        Data => {
            %Param,
            %{ $Param{Change} },
            %{ $Param{Config} },
        },
    );
    $Param{Counter}++;

    return $Param{Counter};
}

1;
