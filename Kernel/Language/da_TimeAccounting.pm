# --
# Kernel/Language/da_TimeAccounting.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: da_TimeAccounting.pm,v 1.2 2011-09-28 08:02:21 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::da_TimeAccounting;

use strict;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} = 'Vil du virkelig slette tidsregnskabet for denne dag?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Rediger tidsregistrering';
    $Self->{Translation}->{'Project settings'} = 'Projektindstillinger';
    $Self->{Translation}->{'Date Navigation'} = 'Datonavigation';
    $Self->{Translation}->{'Previous day'} = 'Forrige dag';
    $Self->{Translation}->{'Next day'} = 'Næste dag';
    $Self->{Translation}->{'Days without entries'} = 'Dage uden optegnelser';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'De påkrævede felter er markeret med "*".';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Du skal indtaste en start- og slutdato eller en tidsperiode.';
    $Self->{Translation}->{'Project'} = 'Projekt';
    $Self->{Translation}->{'Task'} = 'Opgave';
    $Self->{Translation}->{'Remark'} = 'Bemærkning';
    $Self->{Translation}->{'Date Navigation'} = 'Datonavigation';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!.'} = 'Tilføj venligst en bemærkning med mere end 8 tegn!';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Negativ tid er ikke tilladt.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} = 'Gentagne timer er ikke tilladt. Starttiden svarer til et andet interval.';
    $Self->{Translation}->{'End time must be after start time.'} = 'Sluttiden skal være senere end starttiden.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} = 'Gentagne timer er ikke tilladt. Sluttiden svarer til et andet interval.';
    $Self->{Translation}->{'Period is bigger than the interval between start and end times!'} = 'Perioden er længere end intervallet mellem start- og sluttid!';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Ugyldig periode! En dag har kun 24 timer.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'En gyldig periode skal være større end 0';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Ugyldig periode! Negative perioder er ikke tilladt.';
    $Self->{Translation}->{'Add one row'} = 'Tilføj en række';
    $Self->{Translation}->{'Total'} = 'I alt';
    $Self->{Translation}->{'On vacation'} = 'På ferie';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Du kan kun vælge et afkrydsningsfelt!';
    $Self->{Translation}->{'On sick leave'} = 'Sygefravær';
    $Self->{Translation}->{'On overtime leave'} = 'Afspadsering';
    $Self->{Translation}->{'Show all items'} = 'Vis alle punkter';
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Slet tidsregnskabsindtastning';
    $Self->{Translation}->{'Confirm insert'} = 'Bekræft indsættelse';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Er du sikker på, at du arbejdede under dit sygefravær?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Er du sikker på, at du arbejdede, mens du var på ferie?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} = 'Er du sikker på, at du arbejdede, mens du var på afspadsering?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Er du sikker på, at du arbejdede mere end 16 timer?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Månedlig oversigt over tidsraportering';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Overtid (timer)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Overtid (denne måned)';
    $Self->{Translation}->{'Overtime (total)'} = 'Overtid (i alt)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Resterende afspadsering';
    $Self->{Translation}->{'Vacation (Days)'} = 'Ferie (dage)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Feriedage brugt (denne måned)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Feriedage brugt (i alt)';
    $Self->{Translation}->{'Remaining vacation'} = 'Resterende feriedage';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Sygefravær (dage)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Sygefravær brugt (denne måned)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Sygefravær brugt (i alt)';
    $Self->{Translation}->{'Previous month'} = 'Forrige måned';
    $Self->{Translation}->{'Next month'} = 'Næste måned';
    $Self->{Translation}->{'Day'} = 'Dag';
    $Self->{Translation}->{'Weekday'} = 'Ugedag';
    $Self->{Translation}->{'Working Hours'} = 'Arbejdstimer';
    $Self->{Translation}->{'Total worked hours'} = 'Arbejdstimer i alt';
    $Self->{Translation}->{'User\'s project overview'} = 'Brugers projektoverblik';
    $Self->{Translation}->{'Hours (monthly)'} = 'Timer (månedlig)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Samlet antal timer';
    $Self->{Translation}->{'Grand total'} = 'Alt i alt';

    # Template: AgentTimeAccountingProjectReporting
    $Self->{Translation}->{'Project report'} = 'Projektrapport';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Tidsraportering';
    $Self->{Translation}->{'Month Navigation'} = 'Månedsnavigation';
    $Self->{Translation}->{'User reports'} = 'Brugerrapporter';
    $Self->{Translation}->{'Monthly total'} = 'I alt for måned';
    $Self->{Translation}->{'Lifetime total'} = 'Samlet total';
    $Self->{Translation}->{'Overtime leave'} = 'Afspadsering';
    $Self->{Translation}->{'Vacation'} = 'Ferie';
    $Self->{Translation}->{'Sick leave'} = 'Sygefravær';
    $Self->{Translation}->{'LeaveDay Remaining'} = 'Resterende fraværsdage';
    $Self->{Translation}->{'Project reports'} = 'Projektrapporter';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Rediger indstillinger for tidsregnskabsprojekt';
    $Self->{Translation}->{'Add project'} = 'Tilføj projekt';
    $Self->{Translation}->{'Add Project'} = 'Tilføj projekt';
    $Self->{Translation}->{'Edit Project Settings'} = 'Rediger projektindstillinger';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} = 'Der er allerede et projekt med dette navn. Vælg venligst et andet.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Rediger tidsregnskabsindstilinger';
    $Self->{Translation}->{'Add task'} = 'Tilføj opgave';
    $Self->{Translation}->{'New user'} = 'Ny bruger';
    $Self->{Translation}->{'Filter for Projects'} = 'Filtrér projekter';
    $Self->{Translation}->{'Filter for Tasks'} = 'Filtrér opgaver';
    $Self->{Translation}->{'Filter for Users'} = 'Filtrér brugere';
    $Self->{Translation}->{'Project List'} = 'Projektliste';
    $Self->{Translation}->{'Task List'} = 'Opgaveliste';
    $Self->{Translation}->{'Add Task'} = 'Tilføj opgave';
    $Self->{Translation}->{'Edit Task Settings'} = 'Rediger opgaveindstillinger';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} = 'Der er allerede en opgave med dette navn. Vælg venligst et andet.';
    $Self->{Translation}->{'User List'} = 'Brugerliste';
    $Self->{Translation}->{'New User Settings'} = 'Nye brugerindstillinger';
    $Self->{Translation}->{'Edit User Settings'} = 'Rediger brugerindstillinger';
    $Self->{Translation}->{'Comments'} = 'Kommentarer';
    $Self->{Translation}->{'Show Overtime'} = 'Vis overtid';
    $Self->{Translation}->{'Allow project creation'} = 'Tillad oprettelse af projekt';
    $Self->{Translation}->{'Period Begin'} = 'Begynd periode';
    $Self->{Translation}->{'Period End'} = 'Afslut periode';
    $Self->{Translation}->{'Days of Vacation'} = 'Feriedage';
    $Self->{Translation}->{'Hours per Week'} = 'Timer pr. uge';
    $Self->{Translation}->{'Authorized Overtime'} = 'Godkendt overtid';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Periodens afslutning skal være efter periodens start.';
    $Self->{Translation}->{'No time periods found.'} = 'Ingen tidsperioder fundet.';
    $Self->{Translation}->{'Add time period'} = 'Tilføj tidsperiode';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Se tidsregistrering';
    $Self->{Translation}->{'View of '} = 'Se ';
    $Self->{Translation}->{'Date navigation'} = 'Datonavigation';
    $Self->{Translation}->{'No data found for this day.'} = 'Der er ikke fundet data for denne dag.';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} = 'Agent interface-notificationsmodulet skal se antallet af uafsluttede arbejdsdage for brugeren.';
    $Self->{Translation}->{'Default name for new actions.'} = 'Standardnavn for nye handlinger.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Standardnavn for nye projekter.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Standardindstilling for slutdato.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Standardindstilling for begyndelsesdato.';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Standardindstilling for fraværsdage.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Standardindstilling for overtid.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Standardindstilling for normale ugentlige timer.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Standardindstilling for nye handlinger.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Standardindstilling for nye projekter.';
    $Self->{Translation}->{'Default status for new users.'} = 'Standardindstilling for nye brugere.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} = 'Definerer de projekter, for hvilke en bemærkning er påkrævet. Hvis RegExp matcher på projektet, skal du også indføje en bemærkning. RegExp bruger smx parameteret.';
    $Self->{Translation}->{'Edit time accounting settings'} = 'Rediger indstillinger for tidsregistrering';
    $Self->{Translation}->{'Edit time record'} = 'Rediger tidsoptegnelse';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Angiver for hvor mange dage, du kan indsætte arbejdsenheder.';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to autocompletion fields.'} = 'Hvis denne er aktiveret, ændres dropdown-elementerne på redigeringsskærmbilledet til autofuldføringsfelter.';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} = 'Maksimalt antal af arbejdsdage efter hvilket arbejdsenhederne skal indsættes.';
    $Self->{Translation}->{'Maximum number of working days withouth working units entry after which a warning will be shown.'} = 'Maksimalt antal af arbejdsdage uden indtastning af arbejdsenheder efter hvilket en advarsel vil blive vist.';
    $Self->{Translation}->{'Project time reporting'} = 'Projekttidsrapportering';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} = 'Regulære udtryk for begrænsning af handlingsliste ifølge det valgte projekt. Nøglen indeholder et regulært udtryk for projekt(er), indholdet rummer regulære udtryk for handling(er).';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} = 'Regulære udtryk for begrænsning af projektliste ifølge brugergrupper. Nøglen indeholder et regulært udtryk for projekt(er), indholdet rummer kommasepareret liste over grupper.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} = 'Angiver, om arbejdstimer kan indsættes uden start- og sluttider.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Dette modul gennemtvinger indsættelser i tidsregnskab.';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} = 'Dette adviseringsmodul giver en advarsel, hvis der er for mange ufuldstændige arbejdsdage.';
    $Self->{Translation}->{'Time accounting.'} = 'Tidsregnskab';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} = 'Bruges, hvis nogle handlinger har reduceret arbejdstimerne (f.eks. hvis kun halvdelen af rejsetiden er betalt Key => traveling; Content => 50)';

    $Self->{Translation}->{'Mon'} = 'Man';
    $Self->{Translation}->{'Tue'} = 'Tirs';
    $Self->{Translation}->{'Wed'} = 'Ons';
    $Self->{Translation}->{'Thu'} = 'Tors';
    $Self->{Translation}->{'Fri'} = 'Fre';
    $Self->{Translation}->{'Sat'} = 'Lør';
    $Self->{Translation}->{'Sun'} = 'Søn';
    $Self->{Translation}->{'January'} = 'Januar';
    $Self->{Translation}->{'February'} = 'Februar';
    $Self->{Translation}->{'March'} = 'Marts';
    $Self->{Translation}->{'April'} = 'April';
    $Self->{Translation}->{'May'} = 'Maj';
    $Self->{Translation}->{'June'} = 'Juni';
    $Self->{Translation}->{'July'} = 'Juli';
    $Self->{Translation}->{'August'} = 'August';
    $Self->{Translation}->{'September'} = 'September';
    $Self->{Translation}->{'October'} = 'Oktober';
    $Self->{Translation}->{'November'} = 'November';
    $Self->{Translation}->{'December'} = 'December';

    $Self->{Translation}->{'Show all projects'} = 'Vis alle projekter';
    $Self->{Translation}->{'Show valid projects'} = 'Vis gyldige projekter';
    $Self->{Translation}->{'TimeAccounting'} = 'Tidsregnskab';
    $Self->{Translation}->{'Actions'} = 'Handlinger';
    $Self->{Translation}->{'User updated!'} = 'Bruger opdateret!';
    $Self->{Translation}->{'User added!'} = 'Bruger tilføjet!';
    $Self->{Translation}->{'Project added!'} = 'Projekt tilføjet!';
    $Self->{Translation}->{'Project updated!'} = 'Projekt opdateret!';
    $Self->{Translation}->{'Task added!'} = 'Opgave tilføjet!';
    $Self->{Translation}->{'Task updated!'} = 'Opgave opdateret!';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Can\'t delete Working Units!'} = 'Tidsenheder kan ikke slettes!';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = 'Indstillinger kan ikke gemmes, fordi et døgn kun har 24 timer!';
    $Self->{Translation}->{'Please insert your working hours!'} = 'Indtast venligst dine arbejdstimer!';
    $Self->{Translation}->{'Reporting'} = 'Raportering';
    $Self->{Translation}->{'Successful insert!'} = 'Vellykket indtastning!';

}

1;
