# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::de_OTRSCloneDB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'List of tables should be skipped, perhaps internal DB tables. Please use lowercase.'} =
        'Liste von Tabellen, die übersprungen werden sollen, z. B. interne Tabellen. Bitte Kleinbuchstaben verwenden.';
    $Self->{Translation}->{'Log file for replacement of malformed UTF-8 data values.'} = 'Logdatei für die Ersetzung ungültiger UTF-8-Zeichen.';
    $Self->{Translation}->{'Settings for connecting with the target database.'} = 'Einstellungen für die Verbindung zur Zieldatenbank.';
    $Self->{Translation}->{'Specifies which columns should be checked for valid UTF-8 source data.'} =
        'Gibt an, welche Spalten auf gültige UTF-8-Zeichenketten geprüft werden sollen.';
    $Self->{Translation}->{'This setting specifies which table columns contain blob data as these need special treatment.'} =
        'Diese Einstellung gibt an, welche Tabellenspalten Binärdaten enthalten, da diese besonders behandelt werden müssen.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
