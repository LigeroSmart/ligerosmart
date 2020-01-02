# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

#
# Generates auto increment change numbers like ss.... (e. g. 1010138, 1010139, ...)
# --

package Kernel::System::ITSMChange::Number::AutoIncrement;

use strict;
use warnings;

use parent qw(Kernel::System::ITSMChange::NumberBase);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::ITSMChange',
);

sub IsDateBased {
    return 0;
}

sub ChangeNumberBuild {
    my ( $Self, $Offset ) = @_;

    $Offset ||= 0;

    my $BaseCounter = 1;
    if ( $Self->ChangeNumberCounterIsEmpty() ) {
        $BaseCounter = $Self->InitialCounterOffsetCalculate();
    }

    my $Counter = $Self->ChangeNumberCounterAdd(
        Offset => $BaseCounter + $Offset,
    );

    return if !$Counter;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SystemID = $ConfigObject->Get('SystemID');
    my $MinSize  = $ConfigObject->Get('ITSMChange::NumberGenerator::AutoIncrement::MinCounterSize')
        || $ConfigObject->Get('ITSMChange::NumberGenerator::MinCounterSize')
        || 5;

    # Pad change number with leading '0' to length $MinSize (config option).
    $Counter = sprintf "%.*u", $MinSize, $Counter;

    my $ChangeNumber = $SystemID . $Counter;

    return $ChangeNumber;
}

#
# Calculate initial counter value on (migrated) systems that already have changes,
#   but no counter entries yet.
#
sub InitialCounterOffsetCalculate {
    my ( $Self, %Param ) = @_;

    my $LastChangeNumber = $Self->_GetLastChangeNumber();
    return 1 if !$LastChangeNumber;

    # If the change number was created by a date based generator, change counter needs to start from 1
    return 1 if $Self->_LooksLikeDateBasedChangeNumber($LastChangeNumber);

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $SystemID     = $ConfigObject->Get('SystemID');

    # Remove SystemID and leading zeros
    $LastChangeNumber =~ s{\A $SystemID 0* }{}msx;

    return 1 if !$LastChangeNumber;

    return $LastChangeNumber + 1;
}

sub _GetLastChangeNumber {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => 'SELECT MAX(id) FROM change_item',
    );

    my $ChangeID;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $ChangeID = $Data[0];
    }

    return if $ChangeID && $ChangeID == 1;

    my %Change = $Kernel::OM->Get('Kernel::System::ITSMChange')->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => 1,
        LogNo    => 1,
    );

    return if !%Change;
    return if !$Change{ChangeNumber};

    return $Change{ChangeNumber};
}

sub _LooksLikeDateBasedChangeNumber {
    my ( $Self, $ChangeNumber ) = @_;

    return if !$ChangeNumber;

    my $PossibleDate = substr $ChangeNumber, 0, 8;
    return if length $PossibleDate != 8;

    # Format possible date as a date string
    $PossibleDate =~ s{\A (\d{4}) (\d{2}) (\d{2}) \z}{$1-$2-$3 00:00:00}gsmx;

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    my $Result = $DateTimeObject->Set( String => $PossibleDate );

    return if !$Result;

    return 1;
}

1;
