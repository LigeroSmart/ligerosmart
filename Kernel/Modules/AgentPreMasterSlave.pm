# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentPreMasterSlave;

use strict;
use warnings;

# prevent used once warning
use Kernel::System::ObjectManager;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # do only use this in phone and email ticket
    return if ( $Self->{Action} !~ /^AgentTicket(Email|Phone)$/ );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get master/slave dynamic field
    my $MasterSlaveDynamicField = $ConfigObject->Get('MasterSlave::DynamicField') || '';

    # return if no config option is used
    return if !$MasterSlaveDynamicField;

    # set dynamic field as shown
    $ConfigObject->{"Ticket::Frontend::$Self->{Action}"}->{DynamicField}->{$MasterSlaveDynamicField} = 1;

    return;
}

1;
