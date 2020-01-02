# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pl_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Zarządzanie Importem/Exportem';
    $Self->{Translation}->{'Add template'} = 'Dodaj szablon';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Utwórz szablon do importu i eksportu danych obiektów.';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        '';
    $Self->{Translation}->{'Start Import'} = 'Rozpocznij import';
    $Self->{Translation}->{'Start Export'} = 'Rozpocznij eksport';
    $Self->{Translation}->{'Delete this template'} = '';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = 'Krok 1 z 5 - Edycja danych ogólnych';
    $Self->{Translation}->{'Name is required!'} = 'Nazwa jest wymagana!';
    $Self->{Translation}->{'Object is required!'} = 'Obiekt jest wymagany!';
    $Self->{Translation}->{'Format is required!'} = 'Format jest wymagany!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = 'Krok 2 z 5 - Edycja danych obiektowych';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = 'Krok 3 z 5 - Edycja danych formatu';
    $Self->{Translation}->{'is required!'} = 'jest wymagana(y)!';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = 'Krok 4 z 5 - Edycja danych mapowania';
    $Self->{Translation}->{'No map elements found.'} = 'Nie znaleziono elementów mapy.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Dodaj element mapowania';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = 'Krok 5 z 5 - Edycja danych wyszukiwania';
    $Self->{Translation}->{'Restrict export per search'} = 'Ogranicz eksport przez wyszukanie';
    $Self->{Translation}->{'Import information'} = 'Importuj informacje';
    $Self->{Translation}->{'Source File'} = 'Plik źródłowy';
    $Self->{Translation}->{'Import summary for %s'} = 'Podsumowanie importu dla %s';
    $Self->{Translation}->{'Records'} = 'Rekordy';
    $Self->{Translation}->{'Success'} = 'Powodzenie';
    $Self->{Translation}->{'Duplicate names'} = 'Duplikaty nazw';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Nr ostaniej przetworzonej linii pliku importowego';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Do you really want to delete this template item?'} = '';

    # Perl Module: Kernel/Modules/AdminImportExport.pm
    $Self->{Translation}->{'No object backend found!'} = '';
    $Self->{Translation}->{'No format backend found!'} = '';
    $Self->{Translation}->{'Template not found!'} = '';
    $Self->{Translation}->{'Can\'t insert/update template!'} = 'Nie można dodać/zmienić szablonu!';
    $Self->{Translation}->{'Needed TemplateID!'} = 'Potrzebny TemplateID!';
    $Self->{Translation}->{'Error occurred. Import impossible! See Syslog for details.'} = 'Wystąpił błąd. Import niemożliwy! Szczegóły w Logu systemowym.';
    $Self->{Translation}->{'Error occurred. Export impossible! See Syslog for details.'} = 'Wystąpił błąd. Eksport niemożliwy! Szczegóły w Logu systemowym.';
    $Self->{Translation}->{'Template List'} = 'Lista Szablonów';
    $Self->{Translation}->{'number'} = 'liczba';
    $Self->{Translation}->{'number bigger than zero'} = 'liczba większa od zera';
    $Self->{Translation}->{'integer'} = 'liczba całkowita';
    $Self->{Translation}->{'integer bigger than zero'} = 'liczba całkowita większa od zera';
    $Self->{Translation}->{'Element required, please insert data'} = 'Element wymagany, podaj dane';
    $Self->{Translation}->{'Invalid data, please insert a valid %s'} = 'Nieprawidłowe dane, wprowadź prawidłowe %s';
    $Self->{Translation}->{'Format not found!'} = 'Nieznany format!';

    # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
    $Self->{Translation}->{'Column Separator'} = 'Separator kolumny';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulator (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Średnik (;)';
    $Self->{Translation}->{'Colon (:)'} = 'Dwukropek (:)';
    $Self->{Translation}->{'Dot (.)'} = 'Kropka (.)';
    $Self->{Translation}->{'Comma (,)'} = 'Przecinek (,)';
    $Self->{Translation}->{'Charset'} = 'Kodowanie ';
    $Self->{Translation}->{'Include Column Headers'} = 'Umieść nagłówki kolumn';
    $Self->{Translation}->{'Column'} = 'Kolumna';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = '';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        '';
    $Self->{Translation}->{'Template was deleted successfully.'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Moduł formatowania backend dla modułu import/eksport.';
    $Self->{Translation}->{'Import and export object information.'} = 'Importuj i eksportuj informacje obiektów.';
    $Self->{Translation}->{'Import/Export'} = 'Import/eksport';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Confirm',
    'Delete this template',
    'Deleting template...',
    'Template was deleted successfully.',
    'There was an error deleting the template. Please check the logs for more information.',
    );

}

1;
