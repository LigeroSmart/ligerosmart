# --
# Kernel/Language/hu_CIBarcode.pm - the Hungarian translation of CIBarcode
# Copyright (C) 2016 - 2022 Perl-Services, https://www.perl-services.de
# Copyright (C) 2016 Balázs Úr, http://www.otrs-megoldasok.hu
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::hu_CIBarcode;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Type of barcode generated for the config items.'} = 'A konfigurációelemekhez előállított vonalkód típusa.';
    $Lang->{'Attribute that is encoded in the barcode.'} = 'A vonalkódba belekódolt attribútum.';
    $Lang->{'Encode config item URL in the barcode (overrides ITSMConfigItemBarcode::BarcodeAttribute and only usable with QR codes).'} =
        'Konfigurációelem URL-ének belekódolása a vonalkódba (felülbírálja az ITSMConfigItemBarcode::BarcodeAttribute beállítást, és csak QR-kódoknál használható).';
    $Lang->{'The barcode should be rebuilt when the barcode type and/or the value of the attribute (or the attribute itself) changed.'} =
        'A vonalkódot újra elő kell-e állítani, amikor a vonalkód típusa és/vagy az attribútum értéke (vagy maga az attribútum) megváltozik.';
    $Lang->{'Height of the barcode image.'} = 'A vonalkód képének magassága.';
    $Lang->{'Factor for the barcode image.'} = 'Nagyítási tényező a vonalkód képéhez.';
    $Lang->{'No'} = 'Nem';
    $Lang->{'Yes'} = 'Igen';

    return 1;
}

1;

