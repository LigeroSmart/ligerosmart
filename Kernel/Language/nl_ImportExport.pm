# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::nl_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Import/Export Management';
    $Self->{Translation}->{'Add template'} = 'Sjabloon toevoegen';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Maak een sjabloon om objectinformatie te importeren en exporteren.';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        'Om deze module te gebruiken, moet u ITSMConfigurationManagement of een ander pakket installeren dat back-end biedt voor objecten die moeten worden geïmporteerd en geëxporteerd.';
    $Self->{Translation}->{'Start Import'} = 'Import starten';
    $Self->{Translation}->{'Start Export'} = 'Export starten';
    $Self->{Translation}->{'Delete this template'} = 'Verwijder deze sjabloon';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = 'Stap 1 van 5 - Bewerk algemene informatie';
    $Self->{Translation}->{'Name is required!'} = 'Naam is verplicht!';
    $Self->{Translation}->{'Object is required!'} = 'Object is verplicht!';
    $Self->{Translation}->{'Format is required!'} = 'Formaat is vereist!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = 'Stap 2 van 5 - Bewerk objectinformatie';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = 'Stap 3 van 5 - Bewerk fromaatinformatie';
    $Self->{Translation}->{'is required!'} = 'is verplicht!';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = 'Stap 4 van 5 - Bewerk de toewijzingsinformatie';
    $Self->{Translation}->{'No map elements found.'} = 'Geen toewijzingselementen gevonden.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Toewijzingselement toevoegen';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = 'Stap 5 van 5 - Bewerk zoekinformatie';
    $Self->{Translation}->{'Restrict export per search'} = 'Export beperken met zoeken';
    $Self->{Translation}->{'Import information'} = 'Importinformatie';
    $Self->{Translation}->{'Source File'} = 'Bron bestand';
    $Self->{Translation}->{'Import summary for %s'} = 'Importeer samenvatting voor %s';
    $Self->{Translation}->{'Records'} = 'Records';
    $Self->{Translation}->{'Success'} = 'Succes';
    $Self->{Translation}->{'Duplicate names'} = 'Dubbele namen';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Laatst verwerkte regelnummer van importbestand';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Do you really want to delete this template item?'} = 'Wilt u dit sjabloonitem echt verwijderen?';

    # Perl Module: Kernel/Modules/AdminImportExport.pm
    $Self->{Translation}->{'No object backend found!'} = 'Geen object-backend gevonden!';
    $Self->{Translation}->{'No format backend found!'} = 'Geen formaat-backend gevonden!';
    $Self->{Translation}->{'Template not found!'} = 'Sjabloon niet gevonden!';
    $Self->{Translation}->{'Can\'t insert/update template!'} = 'Kan sjabloon niet invoegen/bijwerken!';
    $Self->{Translation}->{'Needed TemplateID!'} = 'TemplateID nodig!';
    $Self->{Translation}->{'Error occurred. Import impossible! See Syslog for details.'} = 'Fout opgetreden. Import onmogelijk! Zie Syslog voor details.';
    $Self->{Translation}->{'Error occurred. Export impossible! See Syslog for details.'} = 'Fout opgetreden. Export onmogelijk! Zie Syslog voor details.';
    $Self->{Translation}->{'Template List'} = 'Sjabloonlijst';
    $Self->{Translation}->{'number'} = 'Getal';
    $Self->{Translation}->{'number bigger than zero'} = 'getal groter dan nul';
    $Self->{Translation}->{'integer'} = 'geheel getal';
    $Self->{Translation}->{'integer bigger than zero'} = 'geheel getal groter dan nul';
    $Self->{Translation}->{'Element required, please insert data'} = 'Element vereist, voer gegevens in';
    $Self->{Translation}->{'Invalid data, please insert a valid %s'} = 'Ongeldige gegevens, voer een geldige %s in';
    $Self->{Translation}->{'Format not found!'} = 'Formaat niet gevonden!';

    # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
    $Self->{Translation}->{'Column Separator'} = 'Kolomscheidingsteken';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulator (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Puntkomma (;)';
    $Self->{Translation}->{'Colon (:)'} = 'Dubbele punt (:)';
    $Self->{Translation}->{'Dot (.)'} = 'Punt (.)';
    $Self->{Translation}->{'Comma (,)'} = 'Komma (,)';
    $Self->{Translation}->{'Charset'} = 'Tekenset';
    $Self->{Translation}->{'Include Column Headers'} = 'Kolomkoppen opnemen';
    $Self->{Translation}->{'Column'} = 'Kolom';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = 'Sjabloon verwijderen...';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        'Er is een fout opgetreden bij het verwijderen van de sjabloon. Controleer de logboeken voor meer informatie.';
    $Self->{Translation}->{'Template was deleted successfully.'} = 'Sjabloon is succesvol verwijderd.';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Formaat backend module registratie voor de import/export module.';
    $Self->{Translation}->{'Import and export object information.'} = 'Objectinformatie importeren en exporteren.';
    $Self->{Translation}->{'Import/Export'} = 'Importeren/Exporteren';


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
