# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::da_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Vil du virkelig slette tidsregnskabet for denne dag?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Rediger tidsregistrering';
    $Self->{Translation}->{'Go to settings'} = '';
    $Self->{Translation}->{'Date Navigation'} = 'Datonavigation';
    $Self->{Translation}->{'Days without entries'} = 'Dage uden optegnelser';
    $Self->{Translation}->{'Select all days'} = '';
    $Self->{Translation}->{'Mass entry'} = '';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        '';
    $Self->{Translation}->{'On vacation'} = 'På ferie';
    $Self->{Translation}->{'On sick leave'} = 'Sygefravær';
    $Self->{Translation}->{'On overtime leave'} = 'Afspadsering';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'De påkrævede felter er markeret med "*".';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Du skal indtaste en start- og slutdato eller en tidsperiode.';
    $Self->{Translation}->{'Project'} = 'Projekt';
    $Self->{Translation}->{'Task'} = 'Opgave';
    $Self->{Translation}->{'Remark'} = 'Bemærkning';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = '';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Negativ tid er ikke tilladt.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Gentagne timer er ikke tilladt. Starttiden svarer til et andet interval.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = '';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = '';
    $Self->{Translation}->{'End time must be after start time.'} = 'Sluttiden skal være senere end starttiden.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Gentagne timer er ikke tilladt. Sluttiden svarer til et andet interval.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Ugyldig periode! En dag har kun 24 timer.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'En gyldig periode skal være større end 0';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Ugyldig periode! Negative perioder er ikke tilladt.';
    $Self->{Translation}->{'Add one row'} = 'Tilføj en række';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Du kan kun vælge et afkrydsningsfelt!';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Er du sikker på, at du arbejdede under dit sygefravær?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Er du sikker på, at du arbejdede, mens du var på ferie?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Er du sikker pá, at du arbejdede, mens du var på afspadsering?';
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
    $Self->{Translation}->{'Weekday'} = 'Ugedag';
    $Self->{Translation}->{'Working Hours'} = 'Arbejdstimer';
    $Self->{Translation}->{'Total worked hours'} = 'Arbejdstimer i alt';
    $Self->{Translation}->{'User\'s project overview'} = 'Brugers projektoverblik';
    $Self->{Translation}->{'Hours (monthly)'} = 'Timer (månedlig)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Samlet antal timer';
    $Self->{Translation}->{'Grand total'} = 'Alt i alt';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Tidsraportering';
    $Self->{Translation}->{'Month Navigation'} = 'Månedsnavigation';
    $Self->{Translation}->{'Go to date'} = '';
    $Self->{Translation}->{'User reports'} = 'Brugerrapporter';
    $Self->{Translation}->{'Monthly total'} = 'I alt for måned';
    $Self->{Translation}->{'Lifetime total'} = 'Samlet total';
    $Self->{Translation}->{'Overtime leave'} = 'Afspadsering';
    $Self->{Translation}->{'Vacation'} = 'Ferie';
    $Self->{Translation}->{'Sick leave'} = 'Sygefravær';
    $Self->{Translation}->{'Vacation remaining'} = 'Resterende fraværsdage';
    $Self->{Translation}->{'Project reports'} = 'Projektrapporter';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Projektrapport';
    $Self->{Translation}->{'Go to reporting overview'} = '';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        '';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        '';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Rediger indstillinger for tidsregnskabsprojekt';
    $Self->{Translation}->{'Add project'} = 'Tilføj projekt';
    $Self->{Translation}->{'Go to settings overview'} = '';
    $Self->{Translation}->{'Add Project'} = 'Tilføj projekt';
    $Self->{Translation}->{'Edit Project Settings'} = 'Rediger projektindstillinger';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Der er allerede et projekt med dette navn. Vælg venligst et andet.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Rediger tidsregnskabsindstilinger';
    $Self->{Translation}->{'Add task'} = 'Tilføj opgave';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = '';
    $Self->{Translation}->{'Time periods can not be deleted.'} = '';
    $Self->{Translation}->{'Project List'} = 'Projektliste';
    $Self->{Translation}->{'Task List'} = 'Opgaveliste';
    $Self->{Translation}->{'Add Task'} = 'Tilføj opgave';
    $Self->{Translation}->{'Edit Task Settings'} = 'Rediger opgaveindstillinger';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Der er allerede en opgave med dette navn. Vælg venligst et andet.';
    $Self->{Translation}->{'User List'} = 'Brugerliste';
    $Self->{Translation}->{'User Settings'} = '';
    $Self->{Translation}->{'User is allowed to see overtimes'} = '';
    $Self->{Translation}->{'Show Overtime'} = 'Vis overtid';
    $Self->{Translation}->{'User is allowed to create projects'} = '';
    $Self->{Translation}->{'Allow project creation'} = 'Tillad oprettelse af projekt';
    $Self->{Translation}->{'User is allowed to skip time accounting'} = '';
    $Self->{Translation}->{'Allow time accounting skipping'} = '';
    $Self->{Translation}->{'If this option is selected, time accounting is effectively optional for the user.'} =
        '';
    $Self->{Translation}->{'There will be no warnings about missing entries and no entry enforcement.'} =
        '';
    $Self->{Translation}->{'Time Spans'} = '';
    $Self->{Translation}->{'Period Begin'} = 'Begynd periode';
    $Self->{Translation}->{'Period End'} = 'Afslut periode';
    $Self->{Translation}->{'Days of Vacation'} = 'Feriedage';
    $Self->{Translation}->{'Hours per Week'} = 'Timer pr. uge';
    $Self->{Translation}->{'Authorized Overtime'} = 'Godkendt overtid';
    $Self->{Translation}->{'Start Date'} = '';
    $Self->{Translation}->{'Please insert a valid date.'} = '';
    $Self->{Translation}->{'End Date'} = '';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Periodens afslutning skal være efter periodens start.';
    $Self->{Translation}->{'Leave Days'} = '';
    $Self->{Translation}->{'Weekly Hours'} = '';
    $Self->{Translation}->{'Overtime'} = '';
    $Self->{Translation}->{'No time periods found.'} = 'Ingen tidsperioder fundet.';
    $Self->{Translation}->{'Add time period'} = 'Tilføj tidsperiode';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Se tidsregistrering';
    $Self->{Translation}->{'View of '} = 'Se ';
    $Self->{Translation}->{'Previous day'} = 'Forrige dag';
    $Self->{Translation}->{'Next day'} = 'Næste dag';
    $Self->{Translation}->{'No data found for this day.'} = 'Der er ikke fundet data for denne dag.';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = '';
    $Self->{Translation}->{'Last Projects'} = '';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = '';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = '';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        '';
    $Self->{Translation}->{'Incomplete Working Days'} = '';
    $Self->{Translation}->{'Successful insert!'} = '';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = '';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = '';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = '';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        '';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        '';
    $Self->{Translation}->{'Last Selected Projects'} = '';
    $Self->{Translation}->{'All Projects'} = '';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = '';
    $Self->{Translation}->{'Reporting Project'} = '';
    $Self->{Translation}->{'Reporting'} = 'Reportering';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = '';
    $Self->{Translation}->{'Project added!'} = '';
    $Self->{Translation}->{'Project updated!'} = '';
    $Self->{Translation}->{'Task added!'} = '';
    $Self->{Translation}->{'Task updated!'} = '';
    $Self->{Translation}->{'The UserID is not valid!'} = '';
    $Self->{Translation}->{'Can\'t insert user data!'} = '';
    $Self->{Translation}->{'Unable to add time period!'} = '';
    $Self->{Translation}->{'Setting'} = 'Indstilling';
    $Self->{Translation}->{'User updated!'} = '';
    $Self->{Translation}->{'User added!'} = '';
    $Self->{Translation}->{'Add a user to time accounting...'} = '';
    $Self->{Translation}->{'New User'} = '';
    $Self->{Translation}->{'Period Status'} = '';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = '';

    # Perl Module: Kernel/Output/HTML/Notification/TimeAccounting.pm
    $Self->{Translation}->{'Please insert your working hours!'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = '';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = '';
    $Self->{Translation}->{'Mass Entry'} = '';
    $Self->{Translation}->{'Please choose a reason for absence!'} = '';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Slet tidsregnskabsindtastning';
    $Self->{Translation}->{'Confirm insert'} = 'Bekræft indsættelse';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'Agent interface-notificationsmodulet skal se antallet af uafsluttede arbejdsdage for brugeren.';
    $Self->{Translation}->{'Default name for new actions.'} = 'Standardnavn for nye handlinger.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Standardnavn for nye projekter.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Standardindstilling for slutdato.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Standardindstilling for begyndelsesdato.';
    $Self->{Translation}->{'Default setting for description.'} = '';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Standardindstilling for fraværsdage.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Standardindstilling for overtid.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Standardindstilling for normale ugentlige timer.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Standardindstilling for nye handlinger.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Standardindstilling for nye projekter.';
    $Self->{Translation}->{'Default status for new users.'} = 'Standardindstilling for nye brugere.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        'Definerer de projekter, for hvilke en bemærkning er påkrævet. Hvis RegExp matcher på projektet, skal du også indføje en bemærkning. RegExp bruger smx parameteret.';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        '';
    $Self->{Translation}->{'Edit time accounting settings.'} = '';
    $Self->{Translation}->{'Edit time record.'} = '';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Angiver for hvor mange dage, du kan indsætte arbejdsenheder.';
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
        'Maksimalt antal af arbejdsdage efter hvilket arbejdsenhederne skal indsættes.';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        '';
    $Self->{Translation}->{'Overview.'} = '';
    $Self->{Translation}->{'Project time reporting.'} = '';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'Regulære udtryk for begrænsning af handlingsliste ifølge det valgte projekt. Nøglen indeholder et regulært udtryk for projekt(er), indholdet rummer regulære udtryk for handling(er).';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'Regulære udtryk for begrænsning af projektliste ifølge brugergrupper. Nøglen indeholder et regulært udtryk for projekt(er), indholdet rummer kommasepareret liste over grupper.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        'Angiver, om arbejdstimer kan indsættes uden start- og sluttider.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Dette modul gennemtvinger indsættelser i tidsregnskab.';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'Dette adviseringsmodul giver en advarsel, hvis der er for mange ufuldstændige arbejdsdage.';
    $Self->{Translation}->{'Time Accounting'} = '';
    $Self->{Translation}->{'Time accounting edit.'} = '';
    $Self->{Translation}->{'Time accounting overview.'} = '';
    $Self->{Translation}->{'Time accounting reporting.'} = '';
    $Self->{Translation}->{'Time accounting settings.'} = '';
    $Self->{Translation}->{'Time accounting view.'} = '';
    $Self->{Translation}->{'Time accounting.'} = 'Tidsregnskab';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        'Bruges, hvis nogle handlinger har reduceret arbejdstimerne (f.eks. hvis kun halvdelen af rejsetiden er betalt Key => traveling; Content => 50)';


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
