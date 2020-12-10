# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::ITSMChange::MenuGeneric;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::ITSMChange',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Change} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Change!',
        );
        return;
    }

    # get config for the relevant action
    my $FrontendConfig = $Kernel::OM->Get('Kernel::Config')->Get("ITSMChange::Frontend::$Param{Config}->{Action}");

    # get the required privilege, 'ro' or 'rw'
    my $RequiredPriv;
    if ( $FrontendConfig && $FrontendConfig->{Permission} ) {

        # get the required priv from the frontend configuration
        $RequiredPriv = $FrontendConfig->{Permission};
    }
    elsif ( $Param{Config}->{Action} eq 'AgentLinkObject' ) {

        # the Link-link is a special case, as it is not specific to ITSMChange
        $RequiredPriv = 'rw';
    }

    # Display the menu-link, when no privilege is required
    my $Access = 1;

    if ($RequiredPriv) {

        # check permissions, based on the required privilege
        $Access = $Kernel::OM->Get('Kernel::System::ITSMChange')->Permission(
            Type     => $RequiredPriv,
            Action   => $Param{Config}->{Action},
            ChangeID => $Param{Change}->{ChangeID},
            UserID   => $Self->{UserID},
            LogNo    => 1,
        );
    }

    return $Param{Counter} if !$Access;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # output menu block
    $LayoutObject->Block( Name => 'Menu' );

    # output seperator, when this is not the first menu item
    if ( $Param{Counter} ) {
        $LayoutObject->Block( Name => 'MenuItemSplit' );
    }

    # output menu item
    $LayoutObject->Block(
        Name => 'MenuItem',
        Data => {
            %Param,
            %{ $Param{Change} },
            %{ $Param{Config} },
        },
    );

    # check if a dialog has to be shown
    if ( $Param{Config}->{DialogTitle} ) {
        my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
        my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

        my %JSData = (
            %Param,
            %{ $Param{Change} },
            %{ $Param{Config} },
        );

        delete $JSData{Config};
        delete $JSData{Change};

        $JSData{ElementSelector}            =~ s/\[%\s*Data\.MenuID\s*\|\s*html\s*%\]/$JSData{MenuID}/i;
        $JSData{DialogContentQueryString}   =~ s/\[%\s*Data\.ChangeID\s*\|\s*html\s*%\]/$JSData{ChangeID}/i;
        $JSData{ConfirmedActionQueryString} =~ s/\[%\s*Data\.ChangeID\s*\|\s*html\s*%\]/$JSData{ChangeID}/i;

        $JSData{DialogTitle} =~ s/\[%\s*Translate\("(.*)"\)\s*\|\s*html\s*%\]/$LanguageObject->Translate($1)/ei;
        $JSData{DialogTitle} =~ s/\[%\s*Config\("(.*)"\)\s*%\]/$ConfigObject->Get($1)/ei;
        $JSData{DialogTitle} =~ s/\[%\s*Data.ChangeNumber\s*\|\s*html\s*%\]/$JSData{ChangeNumber}/ei;

        $JSData{MenuID} = 'Menu' . $JSData{MenuID};

        $LayoutObject->AddJSData(
            Key   => 'ITSMShowConfirmDialog.' . $Param{MenuID},
            Value => \%JSData,
        );
    }

    $Param{Counter}++;

    return $Param{Counter};
}

1;
