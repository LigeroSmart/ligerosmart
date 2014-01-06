# --
# Kernel/Language/pl_ImportExport.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_ImportExport;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = 'Dodaj szablon mapowania';
    $Self->{Translation}->{'Charset'} = 'Kodowanie';
    $Self->{Translation}->{'Colon (:)'} = 'Dwukropek (:)';
    $Self->{Translation}->{'Column'} = 'Kolumna';
    $Self->{Translation}->{'Column Separator'} = 'Separator kolumny';
    $Self->{Translation}->{'Dot (.)'} = 'Kropka (.)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Średnik (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulator (TAB)';
    $Self->{Translation}->{'Include Column Headers'} = 'Umieść nagłówki kolumn';
    $Self->{Translation}->{'Import summary for'} = 'Podsumowanie importu dla';
    $Self->{Translation}->{'Imported records'} = 'Zaimportowane rekordy';
    $Self->{Translation}->{'Exported records'} = 'Wyeksportowane rekordy';
    $Self->{Translation}->{'Records'} = 'Rekordy';
    $Self->{Translation}->{'Skipped'} = 'Pominięte';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Zarządzanie Importem/Exportem';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Utwórz szablon do importu i eksportu danych obiektów.';
    $Self->{Translation}->{'Start Import'} = 'Rozpocznij import';
    $Self->{Translation}->{'Start Export'} = 'Rozpocznij eksport';
    $Self->{Translation}->{'Delete Template'} = 'Usuń szablon';
    $Self->{Translation}->{'Step'} = 'Krok';
    $Self->{Translation}->{'Edit common information'} = 'Edytuj informacje wspólne';
    $Self->{Translation}->{'Name is required!'} = '';
    $Self->{Translation}->{'Object is required!'} = 'Obiekt jest wymagany!';
    $Self->{Translation}->{'Format is required!'} = 'Format jest wymagany!';
    $Self->{Translation}->{'Edit object information'} = 'Edytuj informacje obiektu';
    $Self->{Translation}->{'Edit format information'} = 'Edytuj format obiektu';
    $Self->{Translation}->{' is required!'} = ' jest wymagane!';
    $Self->{Translation}->{'Edit mapping information'} = 'Edytuj informacje mapowania';
    $Self->{Translation}->{'No map elements found.'} = 'Nie znaleziono elementów mapy.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Dodaj element mapowania';
    $Self->{Translation}->{'Edit search information'} = 'Edytuj informacje wyszukiwania';
    $Self->{Translation}->{'Restrict export per search'} = 'Ogranicz eksport przez wyszukanie';
    $Self->{Translation}->{'Import information'} = 'Importuj informacje';
    $Self->{Translation}->{'Source File'} = 'Plik źródłowy';
    $Self->{Translation}->{'Success'} = 'Powodzenie';
    $Self->{Translation}->{'Failed'} = 'Niepowodzenie';
    $Self->{Translation}->{'Duplicate names'} = 'Duplikaty nazw';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Nr ostaniej przetworzonej linii pliku importowego';
    $Self->{Translation}->{'Ok'} = 'Ok';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Moduł formatowania backend dla modułu import/eksport.';
    $Self->{Translation}->{'Import and export object information.'} = 'Importuj i eksportuj informacje obiektów.';
    $Self->{Translation}->{'Import/Export'} = 'Import/eksport';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Class'} = 'Klasa';
    $Self->{Translation}->{'Config Item'} = 'CI';
    $Self->{Translation}->{'Element required, please insert data'} = 'Element wymagany, podaj wartość';
    $Self->{Translation}->{'Empty fields indicate that the current values are kept'} = 'Puste pola oznaczają zachowanie bieżącej wartości';
    $Self->{Translation}->{'Maximum number of one element'} = 'Maksymalna liczba wystąpień pojedynczego elementu';
    $Self->{Translation}->{'Template List'} = 'Lista szablonów';

}

1;
