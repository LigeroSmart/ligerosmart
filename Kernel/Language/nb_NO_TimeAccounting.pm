# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nb_NO_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Vil du virkelig fjerne tidsregistreringen for denne dagen?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Endre tidsregistrering';
    $Self->{Translation}->{'Go to settings'} = 'Innstillinger';
    $Self->{Translation}->{'Date Navigation'} = 'Navigering mellom datoer';
    $Self->{Translation}->{'Days without entries'} = 'Dager uten tidregistrering';
    $Self->{Translation}->{'Select all days'} = 'Velg alle dager';
    $Self->{Translation}->{'Mass entry'} = 'Masseregistrering';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Vennligst velg årsaken til ditt fravær på de valgte dagene';
    $Self->{Translation}->{'On vacation'} = 'Ferie';
    $Self->{Translation}->{'On sick leave'} = 'Sykefravær';
    $Self->{Translation}->{'On overtime leave'} = 'Avspassering';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'Obligatoriske felt er markert med "*".';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Du må fylle ut start- og sluttidspunkt, eller periodelengden.';
    $Self->{Translation}->{'Project'} = 'Prosjekt';
    $Self->{Translation}->{'Task'} = 'Aktivitet';
    $Self->{Translation}->{'Remark'} = 'Merknad';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = 'Vennligst skriv inn en merknad på minst 8 tegn!';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Negativ tid godtas ikke.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Overlappende perioder ikke tillatt. Starttiden er i en annen periode.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'Feil format! Vennligst oppgi ett tidspunkt i formatet TT:MM.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '24:00 godtas bare som sluttid.';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'Feilaktig tid! Et døgn har kun 24 timer.';
    $Self->{Translation}->{'End time must be after start time.'} = 'Sluttid må være senere enn starttid.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Overlappende perioder ikke tillatt. Sluttiden er i en annen periode.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Feilaktig tid! Et døgn har kun 24 timer.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'En tidsperiode må være større enn null.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Feilaktid tid.  Negativ tid godtas ikke.';
    $Self->{Translation}->{'Add one row'} = 'Legg til en rad.';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Du kan bare gjøre en avkrysning.';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Er du sikker på at du arbeidet mens du var sykemeldt.';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Er du sikker på at du arbeidet mens du hadde ferie?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Er du sikker på at du arbeidet mens du avspasserte.';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Er du sikker på at du arbeidet i flere enn 16 timer?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Månedsoversikt registrert tid';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Overtid (timer)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Overtid (denne måned)';
    $Self->{Translation}->{'Overtime (total)'} = 'Overtid (totalt)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Gjenstående avspasseringstimer';
    $Self->{Translation}->{'Vacation (Days)'} = 'Ferie (dager)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Ferie tatt (denne måned)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Ferie tatt (totalt)';
    $Self->{Translation}->{'Remaining vacation'} = 'Gjenstående feriedager';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Sykefravær (dager)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Sykefravær (denne måned)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Sykefravær (totalt)';
    $Self->{Translation}->{'Previous month'} = 'Forrige måned';
    $Self->{Translation}->{'Next month'} = 'Neste måned';
    $Self->{Translation}->{'Weekday'} = 'Ukedag';
    $Self->{Translation}->{'Working Hours'} = 'Arbeidet tid';
    $Self->{Translation}->{'Total worked hours'} = 'Total arbeidet tid';
    $Self->{Translation}->{'User\'s project overview'} = 'Brukers prosjektoversikt';
    $Self->{Translation}->{'Hours (monthly)'} = 'Timer (månedlig)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Timer (totalt)';
    $Self->{Translation}->{'Grand total'} = 'Sluttsum';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Tidrapportering';
    $Self->{Translation}->{'Month Navigation'} = 'Navigering mellom måneder';
    $Self->{Translation}->{'Go to date'} = 'Gå til dato';
    $Self->{Translation}->{'User reports'} = 'Brukerrapporter';
    $Self->{Translation}->{'Monthly total'} = 'Månedssum';
    $Self->{Translation}->{'Lifetime total'} = 'Totalsum';
    $Self->{Translation}->{'Overtime leave'} = 'Avspassering';
    $Self->{Translation}->{'Vacation'} = 'Ferie';
    $Self->{Translation}->{'Sick leave'} = 'Sykefravær';
    $Self->{Translation}->{'Vacation remaining'} = 'Gjenstående ferie';
    $Self->{Translation}->{'Project reports'} = 'Prosjektrapporter';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Prosjektrapport';
    $Self->{Translation}->{'Go to reporting overview'} = 'Gå til rapporteringsoversikt';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        'For tiden vises bare de aktive brukerne i dette prosjektet. For å endre dette må følgende innstilling endres:';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'For tiden vises alle tidsregistreringsbrukere. For å endre dette må følgende innstilling endres:';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Endre instillinger for tidsregistreringsprosjekt';
    $Self->{Translation}->{'Add project'} = 'Legg til et prosjekt';
    $Self->{Translation}->{'Go to settings overview'} = 'Gå til oversikten over innstillinger';
    $Self->{Translation}->{'Add Project'} = 'Legg til et prosjekt';
    $Self->{Translation}->{'Edit Project Settings'} = 'Endre instillinger for prosjektet';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Det finnes allerede et prosjekt med dette navnet. Vennligst velg et annet navn.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Endre instillinger for tidsregistrering';
    $Self->{Translation}->{'Add task'} = 'Legg til en aktivitet';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = '';
    $Self->{Translation}->{'Time periods can not be deleted.'} = 'Tidsperioder kan ikke slettes.';
    $Self->{Translation}->{'Project List'} = 'Prosjektliste';
    $Self->{Translation}->{'Task List'} = 'Aktivitetsliste';
    $Self->{Translation}->{'Add Task'} = 'Legg til en aktivitet';
    $Self->{Translation}->{'Edit Task Settings'} = 'Endre instillinger for aktiviteten';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Det finnes allerede en aktivitet med dette navnet. Vennligst velg et annet navn.';
    $Self->{Translation}->{'User List'} = 'Brukerliste';
    $Self->{Translation}->{'User Settings'} = '';
    $Self->{Translation}->{'User is allowed to see overtimes'} = '';
    $Self->{Translation}->{'Show Overtime'} = 'Vis overtid';
    $Self->{Translation}->{'User is allowed to create projects'} = '';
    $Self->{Translation}->{'Allow project creation'} = 'Tillatt bruker å opprette prosjekter';
    $Self->{Translation}->{'Time Spans'} = '';
    $Self->{Translation}->{'Period Begin'} = 'Periodestart';
    $Self->{Translation}->{'Period End'} = 'Periodeslutt';
    $Self->{Translation}->{'Days of Vacation'} = 'Feriedager';
    $Self->{Translation}->{'Hours per Week'} = 'Timer per uke';
    $Self->{Translation}->{'Authorized Overtime'} = 'Pålagt overtid';
    $Self->{Translation}->{'Start Date'} = 'Startdato';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Vennligst sett inn en gyldig dato.';
    $Self->{Translation}->{'End Date'} = 'Sluttdato';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Periodeslutt må være etter periodestart.';
    $Self->{Translation}->{'Leave Days'} = 'Dager med gyldig fravær';
    $Self->{Translation}->{'Weekly Hours'} = 'Ukentlige timer';
    $Self->{Translation}->{'Overtime'} = 'Overtid';
    $Self->{Translation}->{'No time periods found.'} = 'Ingen tidsperioder funnet';
    $Self->{Translation}->{'Add time period'} = 'Legg til en tidsperiode';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Se på tidsregistrering';
    $Self->{Translation}->{'View of '} = 'Visning av';
    $Self->{Translation}->{'Previous day'} = 'Forrige dag';
    $Self->{Translation}->{'Next day'} = 'Neste dag';
    $Self->{Translation}->{'No data found for this day.'} = 'Ingen data funnet for denne dagen.';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = '';
    $Self->{Translation}->{'Last Projects'} = 'Seneste prosjekter';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = 'Kan ikke lagre instillingene fordi et døgn har kun 24 timer.';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = '';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        'Denne datoen er utenfor tillatt område. Men, du har ikke satt inn denne dagen ennå, så du får en(!) sjanse';
    $Self->{Translation}->{'Incomplete Working Days'} = 'Ufullstendige arbeidsdager';
    $Self->{Translation}->{'Please insert your working hours!'} = 'Vennligst sett inn dine arbeidstimer!';
    $Self->{Translation}->{'Successful insert!'} = 'Vellykket innsetting!';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = 'Feil under innsetting av flere datoer!';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = 'Innsetting av registreringer for flere datoer var vellykket.';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = 'Oppgitt dato var ugyldig! Dato endret til dagens dato.';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        '';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        '';
    $Self->{Translation}->{'Last Selected Projects'} = 'Seneste valgte prosjekter';
    $Self->{Translation}->{'All Projects'} = 'Alle prosjekter';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = '';
    $Self->{Translation}->{'Reporting Project'} = 'Prosjekt som rapporteres';
    $Self->{Translation}->{'Reporting'} = 'Rapportering';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = 'Kan ikke endre brukerinnstillinger!';
    $Self->{Translation}->{'Project added!'} = 'Prosjekt lagt til!';
    $Self->{Translation}->{'Project updated!'} = 'Prosjekt oppdatert!';
    $Self->{Translation}->{'Task added!'} = 'Aktivitet lagt til!';
    $Self->{Translation}->{'Task updated!'} = 'Aktivitet oppdatert!';
    $Self->{Translation}->{'The UserID is not valid!'} = 'BrukerID er ikke gyldig!';
    $Self->{Translation}->{'Can\'t insert user data!'} = 'Kan ikke legge til brukerdata!';
    $Self->{Translation}->{'Unable to add time period!'} = 'Kan ikke legge til tidsperiode!';
    $Self->{Translation}->{'Setting'} = 'Innstilling';
    $Self->{Translation}->{'User updated!'} = 'Bruker oppdatert!';
    $Self->{Translation}->{'User added!'} = 'Bruker lagt til!';
    $Self->{Translation}->{'Add a user to time accounting...'} = '';
    $Self->{Translation}->{'New User'} = 'Ny bruker';
    $Self->{Translation}->{'Period Status'} = 'Periodestatus';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = 'Visning: Trenger %s!';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = 'Ufullstendige arbeidsdager';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = 'Vennligst velg minst en dag!';
    $Self->{Translation}->{'Mass Entry'} = 'Masseregistrering';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Vennligst velg fraværsårsak!';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Slett en tidsregistrering';
    $Self->{Translation}->{'Confirm insert'} = 'Bekreft innsetting';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        '';
    $Self->{Translation}->{'Default name for new actions.'} = '';
    $Self->{Translation}->{'Default name for new projects.'} = '';
    $Self->{Translation}->{'Default setting for date end.'} = '';
    $Self->{Translation}->{'Default setting for date start.'} = '';
    $Self->{Translation}->{'Default setting for description.'} = '';
    $Self->{Translation}->{'Default setting for leave days.'} = '';
    $Self->{Translation}->{'Default setting for overtime.'} = '';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = '';
    $Self->{Translation}->{'Default status for new actions.'} = '';
    $Self->{Translation}->{'Default status for new projects.'} = '';
    $Self->{Translation}->{'Default status for new users.'} = '';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        '';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        '';
    $Self->{Translation}->{'Edit time accounting settings.'} = 'Endre innstillinger for tidsregistrering.';
    $Self->{Translation}->{'Edit time record.'} = 'Endre tidsregistrering';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Hvor manger dager tilbake i tid det er anledning til å legge til en tidsbolk.';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        '';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        '';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        '';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        '';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        '';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        '';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        '';
    $Self->{Translation}->{'Overview.'} = 'Oversikt.';
    $Self->{Translation}->{'Project time reporting.'} = 'Tidrapportering for prosjekt.';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        '';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        '';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        '';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = '';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        '';
    $Self->{Translation}->{'Time Accounting'} = 'Tidsregistrering';
    $Self->{Translation}->{'Time accounting edit.'} = 'Endre tidsregistrering.';
    $Self->{Translation}->{'Time accounting overview.'} = 'Oversikt over registrert tid.';
    $Self->{Translation}->{'Time accounting reporting.'} = 'Rapportering av registrert tid.';
    $Self->{Translation}->{'Time accounting settings.'} = 'Innstillinger for tidsregistrering.';
    $Self->{Translation}->{'Time accounting view.'} = 'Se på tidsregistrering.';
    $Self->{Translation}->{'Time accounting.'} = 'Tidsregistrering.';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        '';


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
