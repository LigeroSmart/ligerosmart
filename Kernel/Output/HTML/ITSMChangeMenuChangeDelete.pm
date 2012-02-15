# --
# Kernel/Output/HTML/ITSMChangeMenuChangeDelete.pm - Menu module with check
# if there is a change in a configured state
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: ITSMChangeMenuChangeDelete.pm,v 1.1 2012-02-15 17:10:33 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ITSMChangeMenuChangeDelete;

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
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Change!',
        );
        return;
    }

    # get config for the relevant action
    my $FrontendConfig
        = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Param{Config}->{Action}");

    # get the required privilege, 'ro' or 'rw'
    my $RequiredPriv;
    if ($FrontendConfig) {

        # get the required priv from the frontend configuration
        $RequiredPriv = $FrontendConfig->{Permission};
    }

    my $Access;
    if ( !$RequiredPriv ) {

        # Display the menu-link, when no privilege is required
        $Access = 1;
    }
    else {

        # check permissions, based on the required privilege
        $Access = $Self->{ChangeObject}->Permission(
            Type     => $RequiredPriv,
            ChangeID => $Param{Change}->{ChangeID},
            UserID   => $Self->{UserID},
            LogNo    => 1,
        );
    }

    return $Param{Counter} if !$Access;

    # build a lookup hash for the allowed change states
    my %AllowedChangeStates = map { $_ => 1 } @{ $FrontendConfig->{ChangeStates} };

    # only show the delete link for changes in the allowed change states
    return if !$AllowedChangeStates{ $Param{Change}->{ChangeState} };

    # output menu block
    $Self->{LayoutObject}->Block( Name => 'Menu' );

    # output seperator, when this is not the first menu item
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

    # check if a dialog has to be shown
    if ( $Param{Config}->{DialogTitle} ) {

        # output confirmation dialog
        $Self->{LayoutObject}->Block(
            Name => 'ShowConfirmationDialog',
            Data => {
                %Param,
                %{ $Param{Change} },
                %{ $Param{Config} },
            },
        );
    }

    $Param{Counter}++;

    return $Param{Counter};
}

1;
