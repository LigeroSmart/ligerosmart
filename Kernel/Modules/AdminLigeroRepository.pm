# --
# Copyright (C) 2001-2017 Complemento http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Modules::AdminLigeroRepository;

use strict;
use warnings;
use Data::Dumper;

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

    if ( !$Self->{SessionID} || $Self->{UserRepository} ) {
        return;
    }

	$Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
		SessionID => $Self->{SessionID},
		Key       => 'UserRepository',
		Value     => 'http://addons.ligerosmart.com/AddOns/6.0/',
	);
    
    return;

}

sub Run {
    my ( $Self, %Param ) = @_;
}

1;
