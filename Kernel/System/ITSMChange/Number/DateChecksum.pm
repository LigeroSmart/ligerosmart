# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

#
# The algorithm to calculate the checksum is derived from the one
# Deutsche Bundesbahn (german railway company) uses for calculation
# of the check digit of their vehikel numbering.
# The checksum is calculated by alternately multiplying the digits
# with 1 and 2 and adding the resulsts from left to right of the
# vehikel number. The modulus to 10 of this sum is substracted from
# 10. See: http://www.pruefziffernberechnung.de/F/Fahrzeugnummer.shtml
# (german)
#
# Generates change numbers like yyyymmddssID#####C (e. g. 2002062310100011)

package Kernel::System::ITSMChange::Number::DateChecksum;

use strict;
use warnings;

use parent qw(Kernel::System::ITSMChange::NumberBase);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub IsDateBased {
    return 1;
}

sub ChangeNumberBuild {
    my ( $Self, $Offset ) = @_;

    $Offset ||= 0;

    my $Counter = $Self->ChangeNumberCounterAdd(
        Offset => 1 + $Offset,
    );

    return if !$Counter;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SystemID = $ConfigObject->Get('SystemID');

    # Pad ticket number with leading '0' to length 5.
    $Counter = sprintf "%.5u", $Counter;

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime'
    );
    my $DateTimeSettings = $DateTimeObject->Get();

    # Create new ticket number.
    my $ChangeNumber = $DateTimeSettings->{Year}
        . sprintf( "%.2u", $DateTimeSettings->{Month} )
        . sprintf( "%.2u", $DateTimeSettings->{Day} )
        . $SystemID . $Counter;

    # Calculate a checksum.
    my $CheckSum = 0;
    my $Multiply = 1;
    for ( my $i = 0; $i < length($ChangeNumber); ++$i ) {

        my $Digit = substr( $ChangeNumber, $i, 1 );

        $CheckSum = $CheckSum + ( $Multiply * $Digit );
        $Multiply += 1;

        if ( $Multiply == 3 ) {
            $Multiply = 1;
        }
    }

    $CheckSum %= 10;
    $CheckSum = 10 - $CheckSum;

    if ( $CheckSum == 10 ) {
        $CheckSum = 1;
    }

    $ChangeNumber .= $CheckSum;

    return $ChangeNumber;
}

1;
