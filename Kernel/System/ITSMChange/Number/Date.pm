# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

#
# Generates change numbers like yyyymmddss.... (e. g. 200206231010138)
# --

package Kernel::System::ITSMChange::Number::Date;

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

    if ( $ConfigObject->Get('ITSMChange::NumberGenerator::Date::UseFormattedCounter') ) {
        my $MinSize = $ConfigObject->Get('ITSMChange::NumberGenerator::MinCounterSize')
            || 5;

        # Pad change number with leading '0' to length $MinSize (config option).
        $Counter = sprintf "%.*u", $MinSize, $Counter;
    }

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime'
    );
    my $DateTimeSettings = $DateTimeObject->Get();

    # Create new change number.
    my $ChangeNumber = $DateTimeSettings->{Year}
        . sprintf( "%.2u", $DateTimeSettings->{Month} )
        . sprintf( "%.2u", $DateTimeSettings->{Day} )
        . $Counter;

    return $ChangeNumber;
}

1;
