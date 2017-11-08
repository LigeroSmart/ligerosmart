# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::sr_Latn_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Da li zaista želite da obrišete obračun vremena za ovaj dan?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Uredi vremenski zapis';
    $Self->{Translation}->{'Go to settings'} = 'Idi u podešavanja';
    $Self->{Translation}->{'Date Navigation'} = 'Datumska navigacija';
    $Self->{Translation}->{'Days without entries'} = 'Dani bez unosa';
    $Self->{Translation}->{'Select all days'} = 'Selektuj sve dane';
    $Self->{Translation}->{'Mass entry'} = 'Masovni unos';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Molimo Vas izaberite razlog vašeg odsustva za izabrane dane';
    $Self->{Translation}->{'On vacation'} = 'Na odmoru';
    $Self->{Translation}->{'On sick leave'} = 'Na bolovanju';
    $Self->{Translation}->{'On overtime leave'} = 'Na slobodnim danima';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'Obavezna polja su označena sa "*".';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Morate uneti vreme početka i završetka ili vremenski period.';
    $Self->{Translation}->{'Project'} = 'Projekat';
    $Self->{Translation}->{'Task'} = 'Zadatak';
    $Self->{Translation}->{'Remark'} = 'Napomena';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = 'Molimo da dodate napomenu dužu od 8 karaktera!';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Negativna vremena nisu dozvoljena.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Ponavljanje sati nije dozvoljeno. Vreme početka se poklapa sa drugim intervalom.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'Neispravan format! Molimo da unesete vreme u formatu HH:MM.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '24:00 je dozvoljeno samo kao vreme završetka.';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'Neispravno vreme! Dan ima samo 24 sata.';
    $Self->{Translation}->{'End time must be after start time.'} = 'Vreme završetka mora biti nakon početka.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Ponavljanje sati nije dozvoljeno. Vreme završetka se poklapa sa drugim intervalom.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Neispravan period! Dan ima samo 24 sata.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Ispravan period mora biti veći od nule.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Neispravan period! Negativni periodi nisu dozvoljeni.';
    $Self->{Translation}->{'Add one row'} = 'Dodaj jedan red';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Možete izabrati samo jedno polje za potvrdu.';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Da li ste sigurni da ste radili dok ste bili na bolovanju?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Da li ste sigurni da ste radili dok ste bili na odmoru?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Da li ste sigurni da ste radili dok ste bili na slobodnim danima?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Da li ste sigurni da ste radili više od 16 sati?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Pregled mesečnog obračuna vremena';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Prekovremeno (sati)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Prekovremeno (ovaj mesec)';
    $Self->{Translation}->{'Overtime (total)'} = 'Prekovremeno (ukupno)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Preostali slobodni dani';
    $Self->{Translation}->{'Vacation (Days)'} = 'Odmor (dani)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Iskorišćen odmor (ovaj mesec)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Iskorišćen odmor (ukupno)';
    $Self->{Translation}->{'Remaining vacation'} = 'Preostao odmor';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Bolovanje (dani)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Bolovanje (ovaj mesec)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Bolovanje (ukupno)';
    $Self->{Translation}->{'Previous month'} = 'Prethodni mesec';
    $Self->{Translation}->{'Next month'} = 'Sledeći mesec';
    $Self->{Translation}->{'Weekday'} = 'Radni dan';
    $Self->{Translation}->{'Working Hours'} = 'Radni sati';
    $Self->{Translation}->{'Total worked hours'} = 'Ukupno radnih sati';
    $Self->{Translation}->{'User\'s project overview'} = 'Pregled korisničkog projekta';
    $Self->{Translation}->{'Hours (monthly)'} = 'Sati (mesečno)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Sati (ukupno)';
    $Self->{Translation}->{'Grand total'} = 'Ukupan zbir';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Izveštavanje o vremenu';
    $Self->{Translation}->{'Month Navigation'} = 'Navigacija po mesecima';
    $Self->{Translation}->{'Go to date'} = 'Idi na datum';
    $Self->{Translation}->{'User reports'} = 'Korisnički izveštaji';
    $Self->{Translation}->{'Monthly total'} = 'Mesečni zbir';
    $Self->{Translation}->{'Lifetime total'} = 'Svega do sada';
    $Self->{Translation}->{'Overtime leave'} = 'Slobodni dani';
    $Self->{Translation}->{'Vacation'} = 'Odmor';
    $Self->{Translation}->{'Sick leave'} = 'Bolovanje';
    $Self->{Translation}->{'Vacation remaining'} = 'Preostao odmor';
    $Self->{Translation}->{'Project reports'} = 'Izveštaji o projektu';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Izveštaj o projektu';
    $Self->{Translation}->{'Go to reporting overview'} = 'Idi na pregled izveštavanja';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        'Trenutno su prikazani samo aktivni korisnici u ovom projektu. Za promenu ovakvog ponašanja, molimo Vas ažurirajte podešavanja:';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'Trenutno su prikazani svi korisnici obračuna vremena. Za promenu ovakvog ponašanja, molimo ažurirajte podešavanja:';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Izmena podešavanja obračunavanja vremena projekta';
    $Self->{Translation}->{'Add project'} = 'Dodaj projekat';
    $Self->{Translation}->{'Go to settings overview'} = 'Idi na pregled podešavanja';
    $Self->{Translation}->{'Add Project'} = 'Dodaj Projekat';
    $Self->{Translation}->{'Edit Project Settings'} = 'Izmeni podešavanja Projekta';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Već postoji projekat sa tim imenom. Molimo vas, izaberite neko drugo.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Izmeni podešavanja obračunavanja vremena';
    $Self->{Translation}->{'Add task'} = 'Dodaj zadatak';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = 'Filter za projekte, zadatke ili korisnike';
    $Self->{Translation}->{'Time periods can not be deleted.'} = 'Vremenski periodi se ne mogu obrisati.';
    $Self->{Translation}->{'Project List'} = 'Lista projekata';
    $Self->{Translation}->{'Task List'} = 'Lista zadataka';
    $Self->{Translation}->{'Add Task'} = 'Dodaj zadatak';
    $Self->{Translation}->{'Edit Task Settings'} = 'Uredi podešavanja zadatka';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Već postoji zadatak sa tim imenom. Molimo vas, izaberite neko drugo.';
    $Self->{Translation}->{'User List'} = 'Lista korisnika';
    $Self->{Translation}->{'User Settings'} = 'Korisnička podešavanja';
    $Self->{Translation}->{'User is allowed to see overtimes'} = 'Korisniku je omogućeno da vidi prekovremeno';
    $Self->{Translation}->{'Show Overtime'} = 'Prikaži prekovremeno';
    $Self->{Translation}->{'User is allowed to create projects'} = 'Korisniku je omogućeno da kreira projekte';
    $Self->{Translation}->{'Allow project creation'} = 'Dozvoli kreiranje projekta';
    $Self->{Translation}->{'Time Spans'} = 'Rasponi vremena';
    $Self->{Translation}->{'Period Begin'} = 'Početak perioda';
    $Self->{Translation}->{'Period End'} = 'Kraj perioda';
    $Self->{Translation}->{'Days of Vacation'} = 'Dani odmora';
    $Self->{Translation}->{'Hours per Week'} = 'Sati po nedelji';
    $Self->{Translation}->{'Authorized Overtime'} = 'Dozvoljeno prekovremeno';
    $Self->{Translation}->{'Start Date'} = 'Datum početka';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Molimo da unesete važeći datum.';
    $Self->{Translation}->{'End Date'} = 'Datum završetka';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Kraj perioda mora biti posle početka perioda.';
    $Self->{Translation}->{'Leave Days'} = 'Dani odsustva';
    $Self->{Translation}->{'Weekly Hours'} = 'Sedmični sati';
    $Self->{Translation}->{'Overtime'} = 'Prekovremeno';
    $Self->{Translation}->{'No time periods found.'} = 'Nisu pronađeni vremenski periodi.';
    $Self->{Translation}->{'Add time period'} = 'Dodaj vremenski period';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Prikaz vremenskog zapisa';
    $Self->{Translation}->{'View of '} = 'Prikaz';
    $Self->{Translation}->{'Previous day'} = 'Prethodni dan';
    $Self->{Translation}->{'Next day'} = 'Sledeći dan';
    $Self->{Translation}->{'No data found for this day.'} = 'Nema podataka za ovaj dan.';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = 'Radne jedinice se ne mogu uneti!';
    $Self->{Translation}->{'Last Projects'} = 'Poslednji projekti';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = 'Ne mogu da sačuvam podešavanja, jer dan ima samo 24 sata!';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = 'Radne jedinice se ne mogu obrisati!';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        'Ovaj datum je izvan granica ali ga niste još uvek uneli, pa imate još jednu(!) šansu za unos';
    $Self->{Translation}->{'Incomplete Working Days'} = 'Nepotpuni radni dani';
    $Self->{Translation}->{'Please insert your working hours!'} = 'Molimo vas unesite vaše radno vreme!';
    $Self->{Translation}->{'Successful insert!'} = 'Uspešno dodavanje!';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = 'Greška pri unosu više datuma!';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = 'Uspešno ubačeni unosi za više datuma!';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = 'Uneti datum je nevažeći! Datum je promenjen na današnji.';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        'Nije konfigurisan vremenski period ili je navedeni datum van definisanih vremenskih perioda.';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        'Molimo da kontaktirate administratora obračuna vremena za ažuriranje vremenskih perioda!';
    $Self->{Translation}->{'Last Selected Projects'} = 'Poslednji izabrani projekti';
    $Self->{Translation}->{'All Projects'} = 'Svi projekti';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = 'Izveštavanje o projektu: neophodan je ProjectID';
    $Self->{Translation}->{'Reporting Project'} = 'Izveštavanje o projektu';
    $Self->{Translation}->{'Reporting'} = 'Izveštavanje';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = 'Korisnička podešavanja se ne mogu ažurirati!';
    $Self->{Translation}->{'Project added!'} = 'Dodat projekat!';
    $Self->{Translation}->{'Project updated!'} = 'Ažuriran projekat!';
    $Self->{Translation}->{'Task added!'} = 'Dodat zadatak!';
    $Self->{Translation}->{'Task updated!'} = 'Ažuriran zadatak!';
    $Self->{Translation}->{'The UserID is not valid!'} = 'UserID je nevažeći!';
    $Self->{Translation}->{'Can\'t insert user data!'} = 'Korisnički podaci se ne mogu uneti!';
    $Self->{Translation}->{'Unable to add time period!'} = 'Vremenski period se ne može dodati!';
    $Self->{Translation}->{'Setting'} = 'Podešavanje';
    $Self->{Translation}->{'User updated!'} = 'Ažuriran korisnik!';
    $Self->{Translation}->{'User added!'} = 'Dodat korisnik!';
    $Self->{Translation}->{'Add a user to time accounting...'} = 'Dodaj korisnika u obračunavanje vremena...';
    $Self->{Translation}->{'New User'} = 'Novi korisnik';
    $Self->{Translation}->{'Period Status'} = 'Status perioda';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = 'Prikaz: neophodan %s!';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = '';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = 'Molimo vas izaberite bar jedan dan!';
    $Self->{Translation}->{'Mass Entry'} = 'Masovni unos';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Molimo vas izaberite razlog vašeg odsustva!';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Obriši stavku obračuna vremena';
    $Self->{Translation}->{'Confirm insert'} = 'Potvrdi unos';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'Modul za obaveštavanje u interfejsu operatera koji prikazuje broj nekompletnih radnih dana za korisnika.';
    $Self->{Translation}->{'Default name for new actions.'} = 'Podrazumevano ime novih akcija.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Podrazumevano ime novih projekata.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Podrazumevano podešavanje za datum završetka.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Podrazumevano podešavanje za datum početka.';
    $Self->{Translation}->{'Default setting for description.'} = 'Podrazumevano podešavanje za opis.';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Podrazumevano podešavanje za dane odsustva.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Podrazumevano podešavanje za prekovremeni rad.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Podrazumevano podešavanje za standardnu radnu nedelju.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Podrazumevani status za nove akcije.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Podrazumevani status za nove projekte.';
    $Self->{Translation}->{'Default status for new users.'} = 'Podrazumevani status novih korisnika.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        'Određuje projekte za koje je napomena obavezna. Ako se RegExp poklopi na projektu, morate tekođe uneti napomenu. RegExp koristi smx parametar.';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        'Određuje da li statistički modul može generisati informacije o obračunu vremena.';
    $Self->{Translation}->{'Edit time accounting settings.'} = 'Izmeni podešavanja obračunavanja vremena.';
    $Self->{Translation}->{'Edit time record.'} = 'Izmeni vremenski zapis.';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Za koliko dana unazad možete uneti radne jedinice.';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        'Ako je aktivirano, prikazani su samo korisnici koji su dodali radno vreme u izabrani projekat.';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        'Ako je aktivirano, padajući elementi na ekranu za izmenu se menjaju u modernizovana samodovršavajuća polja.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        'Ako je aktivirano, filter prethodnih projekata se može koristiti umesto dve liste projekata (poslednji i svi). Može se koristiti samo ako je TimeAccounting::EnableAutoCompletion aktivirano.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        'Ako je aktivirano, filter prethodnih projekata je podrazumevano aktivan ako ima projekata od pre. Može se koristiti samo ako je EnableAutoCompletion i TimeAccounting::UseFilter aktivirano.';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        'Ako je aktivirano, korisniku je dozvoljeno da unese "na odmoru", "na bolovanju" i "na slobodnim danima" na više datuma odjednom.';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        'Maksimalni broj radnih dana posle kog treba dodati radne jedinice.';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        'Maksimalni broj radnih dana bez unosa radnih jedinica posle kog će biti prikazano upozorenje.';
    $Self->{Translation}->{'Overview.'} = 'Pregled.';
    $Self->{Translation}->{'Project time reporting.'} = 'Izveštavanje o vremenu projekta.';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'Regularni izrazi za ograničavanje liste akcija prema izabranim projektima. Ključ sadrži regularni izraz za projekt(e), u sadržaju je regularni izraz za akciju(e).';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'Regularni izrazi za ograničavanje liste akcija prema izabranim korisničkim grupama. Ključ sadrži regularni izraz za projekt(e), u sadržaju je regularni izraz za grupe.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        'Određuje da li radni sati mogu da se unesu bez vremena početka i završetka.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Ovaj modul nameće unos u obračun vremena.';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'Ovaj modul za obaveštavanje daje upozorenje ako ima previše nekompletnih radnih dana.';
    $Self->{Translation}->{'Time Accounting'} = 'Obračunavanje vremena';
    $Self->{Translation}->{'Time accounting edit.'} = 'Uređivanje obračunavanja vremena.';
    $Self->{Translation}->{'Time accounting overview.'} = 'Pregled obračunavanja vremena.';
    $Self->{Translation}->{'Time accounting reporting.'} = 'Izveštaji obračunavanja vremena.';
    $Self->{Translation}->{'Time accounting settings.'} = 'Podešavanja obračunavanja vremena.';
    $Self->{Translation}->{'Time accounting view.'} = 'Pregled obračunavanja vremena.';
    $Self->{Translation}->{'Time accounting.'} = 'Obračunavanje vremena.';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        'Za upotrebu ako neke akcije smanjuju radne sate (na primer, ako se plaća samo pola vremena putovanja Ključ => putovanje; Sadržaj => 50).';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Confirm insert',
    'Delete Time Accounting Entry',
    'Mass Entry',
    'No',
    'Please choose a reason for absence!',
    'Please choose at least one day!',
    'Submit',
    'Yes',
    );

}

1;
