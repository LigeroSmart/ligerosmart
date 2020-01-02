# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::hu_OTRSCloneDB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'List of tables should be skipped, perhaps internal DB tables. Please use lowercase.'} =
        'Azon táblák listája, amelyeket ki kell hagyni. Valószínűleg belső adatbázistáblák. Használjon kisbetűs neveket.';
    $Self->{Translation}->{'Log file for replacement of malformed UTF-8 data values.'} = 'Naplófájl a helytelenül formázott UTF-8 adatértékek helyettesítéséhez.';
    $Self->{Translation}->{'Settings for connecting with the target database.'} = 'Beállítások a céladatbázissal történő csatlakozáshoz.';
    $Self->{Translation}->{'Specifies which columns should be checked for valid UTF-8 source data.'} =
        'Meghatározza, hogy mely oszlopokat kell ellenőrizni érvényes UTF-8 forrásadatokhoz.';
    $Self->{Translation}->{'This setting specifies which table columns contain blob data as these need special treatment.'} =
        'Ez a beállítás határozza meg, hogy mely táblaoszlopok tartalmaznak blob adatokat, mivel ezek különleges bánásmódot igénylenek.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
