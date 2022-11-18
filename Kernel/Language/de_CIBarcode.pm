# --
# Kernel/Language/de_CIBarcode.pm - the German translation of CIBarcode
# Copyright (C) 2016 - 2022 Perl-Services, https://www.perl-services.de
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_CIBarcode;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Type of barcode generated for the config items.'} = 'Art des Barcodes der für Config Items generiert wird.';
    $Lang->{'Attribute that is encoded in the barcode.'} = 'Attribut, das im Barcode codiert wird.';
    $Lang->{'Encode config item URL in the barcode (overrides ITSMConfigItemBarcode::BarcodeAttribute and only usable with QR codes).'} =
        'Kodiere die URL zum Config Item im Barcode (überschreibt ITSMConfigItemBarcode::BarcodeAttribute und nutzt QR-Codes).';
    $Lang->{'The barcode should be rebuilt when the barcode type and/or the value of the attribute (or the attribute itself) changed.'} =
        'Der Barcode soll neu erstellt werden wenn der Barcodetyp und/oder der Wert des Attributs (oder das Attribut selbst) sich ändert.';
    $Lang->{'Height of the barcode image.'} = 'Höhe des Barcodes';
    $Lang->{'Factor for the barcode image.'} = '';
    $Lang->{'No'} = 'Nein';
    $Lang->{'Yes'} = 'Ja';

    return 1;
}

1;

