# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Utwórz szablon do importu i eksportu danych obiektów.';
    $Self->{Translation}->{'Start Import'} = 'Rozpocznij import';
    $Self->{Translation}->{'Start Export'} = 'Rozpocznij eksport';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = '';
    $Self->{Translation}->{'Name is required!'} = 'Nazwa jest wymagana!';
    $Self->{Translation}->{'Object is required!'} = 'Obiekt jest wymagany!';
    $Self->{Translation}->{'Format is required!'} = 'Format jest wymagany!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = '';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = '';
    $Self->{Translation}->{'is required!'} = 'jest wymagana(y)!';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = '';
    $Self->{Translation}->{'No map elements found.'} = 'Nie znaleziono elementów mapy.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Dodaj element mapowania';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = '';
    $Self->{Translation}->{'Restrict export per search'} = 'Ogranicz eksport przez wyszukanie';
    $Self->{Translation}->{'Import information'} = 'Importuj informacje';
    $Self->{Translation}->{'Source File'} = 'Plik źródłowy';
    $Self->{Translation}->{'Import summary for %s'} = 'Podsumowanie importu dla %s';
    $Self->{Translation}->{'Records'} = 'Rekordy';
    $Self->{Translation}->{'Success'} = 'Powodzenie';
    $Self->{Translation}->{'Duplicate names'} = 'Duplikaty nazw';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Nr ostaniej przetworzonej linii pliku importowego';
    $Self->{Translation}->{'Ok'} = 'Ok';

    # Perl Module: Kernel/Modules/AdminImportExport.pm
    $Self->{Translation}->{'No object backend found!'} = '';
    $Self->{Translation}->{'No format backend found!'} = '';
    $Self->{Translation}->{'Template not found!'} = '';
    $Self->{Translation}->{'Can\'t insert/update template!'} = '';
    $Self->{Translation}->{'Needed TemplateID!'} = '';
    $Self->{Translation}->{'Error occurred. Import impossible! See Syslog for details.'} = '';
    $Self->{Translation}->{'Error occurred. Export impossible! See Syslog for details.'} = '';
    $Self->{Translation}->{'Template List'} = '';
    $Self->{Translation}->{'number'} = '';
    $Self->{Translation}->{'number bigger than zero'} = '';
    $Self->{Translation}->{'integer'} = '';
    $Self->{Translation}->{'integer bigger than zero'} = '';
    $Self->{Translation}->{'Element required, please insert data'} = '';
    $Self->{Translation}->{'Invalid data, please insert a valid %s'} = '';
    $Self->{Translation}->{'Format not found!'} = '';

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

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Moduł formatowania backend dla modułu import/eksport.';
    $Self->{Translation}->{'Import and export object information.'} = 'Importuj i eksportuj informacje obiektów.';
    $Self->{Translation}->{'Import/Export'} = 'Import/eksport';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
