# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sr_Latn_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Uvoz/Izvoz upravljanje';
    $Self->{Translation}->{'Add template'} = 'Dodaj šablon';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Kreiraj šablon za uvoz i izvoz informacija o objektu.';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        'Za korišćenje ovog modula, morate instalirati ITSMConfigurationManagement ili neki drugi paket koji obezbeđuje pozadinske module za entitete uvoza i izvoza.';
    $Self->{Translation}->{'Start Import'} = 'Počni uvoz';
    $Self->{Translation}->{'Start Export'} = 'Počni izvoz';
    $Self->{Translation}->{'Delete this template'} = '';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = 'Korak 1 od 5 - Uredi zajedničke informacije';
    $Self->{Translation}->{'Name is required!'} = 'Ime je obavezno!';
    $Self->{Translation}->{'Object is required!'} = 'Objekt je obavezan!';
    $Self->{Translation}->{'Format is required!'} = 'Format je obavezan!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = 'Korak 2 od 5 - Uredi informacije o objektu';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = 'Korak 3 od 5 - Uredi informacije o formatu';
    $Self->{Translation}->{'is required!'} = 'je obavezno!';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = 'Korak 4 od 5 - Uredi informacije o mapiranju';
    $Self->{Translation}->{'No map elements found.'} = 'Nijedan element mape nije pronađen.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Dodaj element za mapiranje';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = 'Korak 5 od 5 - Uredi informacije za pretragu';
    $Self->{Translation}->{'Restrict export per search'} = 'Ograničenje izvoza po pretrazi';
    $Self->{Translation}->{'Import information'} = 'Uvoz informacija';
    $Self->{Translation}->{'Source File'} = 'Izvorna datoteka';
    $Self->{Translation}->{'Import summary for %s'} = 'Rezime uvoza za %s';
    $Self->{Translation}->{'Records'} = 'Zapisi';
    $Self->{Translation}->{'Success'} = 'Uspešno';
    $Self->{Translation}->{'Duplicate names'} = 'Duplikat imena';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Broj poslednje obrađene linije uvezene datoteke';
    $Self->{Translation}->{'Ok'} = 'U redu';
    $Self->{Translation}->{'Do you really want to delete this template item?'} = 'Da li stvarno želite da obrišete ovaj šablon?';

    # Perl Module: Kernel/Modules/AdminImportExport.pm
    $Self->{Translation}->{'No object backend found!'} = 'Nije pronađen pozadinski modul objekta!';
    $Self->{Translation}->{'No format backend found!'} = 'Nije pronađen pozadinski modul formata!';
    $Self->{Translation}->{'Template not found!'} = 'Šablon nije pronađen!';
    $Self->{Translation}->{'Can\'t insert/update template!'} = 'Šablon se ne može uneti/ažurirati!';
    $Self->{Translation}->{'Needed TemplateID!'} = 'Potreban ID šablona!';
    $Self->{Translation}->{'Error occurred. Import impossible! See Syslog for details.'} = 'Dogodila se greška. Uvoz je nemoguć! Za detalje pogledajte u sistemski dnevnik.';
    $Self->{Translation}->{'Error occurred. Export impossible! See Syslog for details.'} = 'Dogodila se greška. Izvoz je nemoguć! Za detalje pogledajte u sistemski dnevnik.';
    $Self->{Translation}->{'Template List'} = 'Lista šablona';
    $Self->{Translation}->{'number'} = 'broj';
    $Self->{Translation}->{'number bigger than zero'} = 'broj veći od nula';
    $Self->{Translation}->{'integer'} = 'ceo broj';
    $Self->{Translation}->{'integer bigger than zero'} = 'ceo broj veći od nula';
    $Self->{Translation}->{'Element required, please insert data'} = 'Neophodan element, molimo unesite podatke';
    $Self->{Translation}->{'Invalid data, please insert a valid %s'} = 'Neispravni podaci, unesete važeći %s';
    $Self->{Translation}->{'Format not found!'} = 'Format nije pronađen!';

    # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
    $Self->{Translation}->{'Column Separator'} = 'Separator kolona';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulator (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Tačka i zapeta (;)';
    $Self->{Translation}->{'Colon (:)'} = 'Dvotačka (:)';
    $Self->{Translation}->{'Dot (.)'} = 'Tačka (.)';
    $Self->{Translation}->{'Comma (,)'} = 'Zarez (,)';
    $Self->{Translation}->{'Charset'} = 'Karakterset';
    $Self->{Translation}->{'Include Column Headers'} = 'Uključi naslove kolona';
    $Self->{Translation}->{'Column'} = 'Kolona';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = 'Brisanje šablona...';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        'Greška prilikom brisanja šablona. Molimo proverite log datoteku za više informacija.';
    $Self->{Translation}->{'Template was deleted successfully.'} = 'Šablon je uspešno obrisan.';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Format registracije „backend” modula za uvoz/izvoz modul.';
    $Self->{Translation}->{'Import and export object information.'} = 'Informacije o uvozu i izvozu objekata';
    $Self->{Translation}->{'Import/Export'} = 'Uvoz/Izvoz';


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
