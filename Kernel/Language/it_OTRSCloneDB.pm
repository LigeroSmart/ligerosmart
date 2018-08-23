# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::it_OTRSCloneDB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'List of tables should be skipped, perhaps internal DB tables. Please use lowercase.'} =
        'Lista delle tabelle da escludere, presumibilmente le tabelle interne del Database. Usare solo caratteri minuscoli.';
    $Self->{Translation}->{'Log file for replacement of malformed UTF-8 data values.'} = 'File di log riguardante la sostituzione di valori UTF-8 non correttamente formati.';
    $Self->{Translation}->{'Settings for connecting with the target database.'} = 'Impostazioni di connessione per il database di destinazione.';
    $Self->{Translation}->{'Specifies which columns should be checked for valid UTF-8 source data.'} =
        'Specifica quali colonne dovrebbero essere controllate per i dati in formato UTF-8 validi.';
    $Self->{Translation}->{'This setting specifies which table columns contain blob data as these need special treatment.'} =
        'Queste impostazioni indicano quali colonne della tabella utilizzano i dati in formato BLOB, poichè le suddette necessitano di una gestione speciale.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
