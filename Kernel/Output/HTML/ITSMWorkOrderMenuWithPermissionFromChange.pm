# --
# Kernel/Output/HTML/ITSMWorkOrderMenuWithPermissionFromChange.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ITSMWorkOrderMenuWithPermissionFromChange;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ConfigObject EncodeObject LogObject DBObject UserObject GroupObject LayoutObject WorkOrderObject UserID)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{WorkOrder} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need WorkOrder!',
        );
        return;
    }

    # get config for the relevant action
    my $FrontendConfig
        = $Self->{ConfigObject}->Get("ITSMWorkOrder::Frontend::$Param{Config}->{Action}");

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
            Type        => $RequiredPriv,
            Action      => $Param{Config}->{Action},
            ChangeID    => $Param{WorkOrder}->{ChangeID},
            WorkOrderID => $Param{WorkOrder}->{WorkOrderID},
            UserID      => $Self->{UserID},
            LogNo       => 1,
        );
    }

    return $Param{Counter} if !$Access;

    # get the change data
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $Param{WorkOrder}->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # output menu block
    $Self->{LayoutObject}->Block( Name => 'Menu' );

    # output menu item
    $Self->{LayoutObject}->Block(
        Name => 'MenuItem',
        Data => {
            %Param,
            %{$Change},
            %{ $Param{WorkOrder} },
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
                %{$Change},
                %{ $Param{WorkOrder} },
                %{ $Param{Config} },
            },
        );
    }

    $Param{Counter}++;

    return $Param{Counter};
}

1;
