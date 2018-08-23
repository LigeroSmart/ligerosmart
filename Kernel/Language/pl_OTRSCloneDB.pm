# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pl_OTRSCloneDB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'List of tables should be skipped, perhaps internal DB tables. Please use lowercase.'} =
        'Lista tabel, które mają zostać pominięte, prawdopodobnie wewnętrzne tabele DB. Nazwy podaj małymi literami.';
    $Self->{Translation}->{'Log file for replacement of malformed UTF-8 data values.'} = 'Plik dziennika dla zastąpionych lub zniekształconych wartości danych UTF-8.';
    $Self->{Translation}->{'Settings for connecting with the target database.'} = 'Ustawienie połączenia z bazą docelową.';
    $Self->{Translation}->{'Specifies which columns should be checked for valid UTF-8 source data.'} =
        'Określa które kolumny mają zostać sprawdzone pod kątem prawidłowych danych UTF-8.';
    $Self->{Translation}->{'This setting specifies which table columns contain blob data as these need special treatment.'} =
        'Ten parametr określa które kolumny tabeli zawierają dane blob, i wymagają specjalnego traktowania.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
