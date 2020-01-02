# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::de_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Import/Export-Verwaltung';
    $Self->{Translation}->{'Add template'} = 'Vorlage hinzufügen';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Erstellen einer Vorlage zum Importieren und Exportieren von Objektinformationen.';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        'Damit Sie dieses Modul nutzen können, müssen Sie das Paket ITSM Configuration Management oder jedes andere Paket installieren, das ein Backend für zu exportierende und importierende Objekte bereitstellt.';
    $Self->{Translation}->{'Start Import'} = 'Import starten';
    $Self->{Translation}->{'Start Export'} = 'Export starten';
    $Self->{Translation}->{'Delete this template'} = '';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = 'Schritt 1 von 5 - Allgemeine Informationen bearbeiten';
    $Self->{Translation}->{'Name is required!'} = 'Name wird benötigt!';
    $Self->{Translation}->{'Object is required!'} = 'Objekt ist erforderlich!';
    $Self->{Translation}->{'Format is required!'} = 'Format ist erforderlich!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = 'Schritt 2 von 5 - Objektinformationen bearbeiten';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = 'Schritt 3 von 5 - Formatinformationen bearbeiten';
    $Self->{Translation}->{'is required!'} = 'wird benötigt!';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = 'Schritt 4 von 5 - Mapping-Informationen bearbeiten';
    $Self->{Translation}->{'No map elements found.'} = 'Keine Mapping-Elemente gefunden.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Mapping-Element hinzufügen';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = 'Schritt 5 von 5 - Suchinformationen bearbeiten';
    $Self->{Translation}->{'Restrict export per search'} = 'Export per Suche einschränken';
    $Self->{Translation}->{'Import information'} = 'Import-Informationen';
    $Self->{Translation}->{'Source File'} = 'Quell-Datei';
    $Self->{Translation}->{'Import summary for %s'} = 'Import-Zusammenfassung für %s';
    $Self->{Translation}->{'Records'} = 'Datensätze';
    $Self->{Translation}->{'Success'} = 'Erfolgreich';
    $Self->{Translation}->{'Duplicate names'} = 'Doppelte Namen';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Zuletzt verarbeitete Zeilennummer der Import-Datei';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Do you really want to delete this template item?'} = 'Möchten Sie dieses Vorlagenelement wirklich löschen?';

    # Perl Module: Kernel/Modules/AdminImportExport.pm
    $Self->{Translation}->{'No object backend found!'} = 'Kein Backend für das Objekt verfügbar!';
    $Self->{Translation}->{'No format backend found!'} = 'Kein Backend für das Format verfügbar!';
    $Self->{Translation}->{'Template not found!'} = 'Vorlage nicht verfügbar!';
    $Self->{Translation}->{'Can\'t insert/update template!'} = 'Die Vorlage konnte nicht eingefügt oder aktualisiert werden!';
    $Self->{Translation}->{'Needed TemplateID!'} = 'Die ID der Vorlage wird benötigt!';
    $Self->{Translation}->{'Error occurred. Import impossible! See Syslog for details.'} = 'Fehler aufgetreten. Importieren unmöglich! Für Details siehe Systemprotokoll.';
    $Self->{Translation}->{'Error occurred. Export impossible! See Syslog for details.'} = 'Fehler aufgetreten. Exportieren unmöglich! Für Details siehe Systemprotokoll.';
    $Self->{Translation}->{'Template List'} = 'Vorlagenliste';
    $Self->{Translation}->{'number'} = 'Zahl';
    $Self->{Translation}->{'number bigger than zero'} = 'Zahl größer als Null';
    $Self->{Translation}->{'integer'} = 'Ganzzahl';
    $Self->{Translation}->{'integer bigger than zero'} = 'Ganzzahl größer als Null';
    $Self->{Translation}->{'Element required, please insert data'} = 'Element erforderlich, bitte fügen Sie Daten ein';
    $Self->{Translation}->{'Invalid data, please insert a valid %s'} = 'Ungültige Daten, bitte geben Sie ein gültiges %s ein';
    $Self->{Translation}->{'Format not found!'} = 'Format nicht gefunden!';

    # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
    $Self->{Translation}->{'Column Separator'} = 'Spaltentrenner';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulator (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Semikolon (;)';
    $Self->{Translation}->{'Colon (:)'} = 'Doppelpunkt (:)';
    $Self->{Translation}->{'Dot (.)'} = 'Punkt (.)';
    $Self->{Translation}->{'Comma (,)'} = 'Komma (,)';
    $Self->{Translation}->{'Charset'} = 'Zeichensatz';
    $Self->{Translation}->{'Include Column Headers'} = 'Mit Spaltenüberschriften';
    $Self->{Translation}->{'Column'} = 'Spalte';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = 'Lösche Vorlage...';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        'Beim Löschen der Vorlage ist ein Fehler aufgetreten. Bitte schauen Sie im Systemprotokoll für mehr Informationen.';
    $Self->{Translation}->{'Template was deleted successfully.'} = 'Vorlage wurde erfolgreich gelöscht.';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Format-Backend Modul-Registration des Import/Export Moduls.';
    $Self->{Translation}->{'Import and export object information.'} = 'Importieren und Exportieren von Objekt-Informationen.';
    $Self->{Translation}->{'Import/Export'} = 'Import/Export';


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
