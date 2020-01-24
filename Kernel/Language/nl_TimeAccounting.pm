# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::nl_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Weet u zeker dat u de Time Accounting wilt verwijderen van deze dag?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = '';
    $Self->{Translation}->{'Go to settings'} = 'Ga naar instellingen';
    $Self->{Translation}->{'Date Navigation'} = 'Datum Navigatie';
    $Self->{Translation}->{'Days without entries'} = 'Dag zonder boeking';
    $Self->{Translation}->{'Select all days'} = 'Selecteer alle dagen';
    $Self->{Translation}->{'Mass entry'} = 'Massa toevoegen';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Kies een reden van absentie voor de geselecteerde dagen';
    $Self->{Translation}->{'On vacation'} = 'Op vakantie';
    $Self->{Translation}->{'On sick leave'} = 'Ziekmelding';
    $Self->{Translation}->{'On overtime leave'} = '';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'Verplichte velden zijn gemarkeerd met "*".';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'U moet een begin en eindtijd of een tijdperiode invullen.';
    $Self->{Translation}->{'Project'} = 'Project';
    $Self->{Translation}->{'Task'} = 'Taak';
    $Self->{Translation}->{'Remark'} = 'Aanmerking';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = '';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Negatieve tijden zijn niet toegestaan.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        '';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'Ongeldig formaat! Voer een tijd in met het formaat HH:MM.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'Ongeldige tijd! Een dag heeft 24 uur.';
    $Self->{Translation}->{'End time must be after start time.'} = '';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        '';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = '';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = '';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = '';
    $Self->{Translation}->{'Add one row'} = '';
    $Self->{Translation}->{'You can only select one checkbox element!'} = '';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = '';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = '';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        '';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = '';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = '';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Overuren (Uren)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Overuren (deze maand)';
    $Self->{Translation}->{'Overtime (total)'} = 'Overuren (totaal)';
    $Self->{Translation}->{'Remaining overtime leave'} = '';
    $Self->{Translation}->{'Vacation (Days)'} = 'Vakantie (dagen)';
    $Self->{Translation}->{'Vacation taken (this month)'} = '';
    $Self->{Translation}->{'Vacation taken (total)'} = '';
    $Self->{Translation}->{'Remaining vacation'} = '';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Ziektedagen (Dagen)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Ziektedagen (deze maand)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Ziektedagen opgenomen (totaal)';
    $Self->{Translation}->{'Previous month'} = 'Vorige maand';
    $Self->{Translation}->{'Next month'} = 'Volgende maand';
    $Self->{Translation}->{'Weekday'} = 'Weekdag';
    $Self->{Translation}->{'Working Hours'} = 'Werkuren';
    $Self->{Translation}->{'Total worked hours'} = 'Totale werkuren';
    $Self->{Translation}->{'User\'s project overview'} = '';
    $Self->{Translation}->{'Hours (monthly)'} = 'Uren (Maandelijks)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Uren (Levensduur)';
    $Self->{Translation}->{'Grand total'} = 'Totaal';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = '';
    $Self->{Translation}->{'Month Navigation'} = 'Maandelijkse Navigatie';
    $Self->{Translation}->{'Go to date'} = 'Ga naar datum';
    $Self->{Translation}->{'User reports'} = '';
    $Self->{Translation}->{'Monthly total'} = '';
    $Self->{Translation}->{'Lifetime total'} = '';
    $Self->{Translation}->{'Overtime leave'} = '';
    $Self->{Translation}->{'Vacation'} = 'Vakantie';
    $Self->{Translation}->{'Sick leave'} = 'Ziektedag';
    $Self->{Translation}->{'Vacation remaining'} = '';
    $Self->{Translation}->{'Project reports'} = '';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = '';
    $Self->{Translation}->{'Go to reporting overview'} = '';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        '';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        '';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = '';
    $Self->{Translation}->{'Add project'} = '';
    $Self->{Translation}->{'Go to settings overview'} = '';
    $Self->{Translation}->{'Add Project'} = '';
    $Self->{Translation}->{'Edit Project Settings'} = '';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        '';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = '';
    $Self->{Translation}->{'Add task'} = 'Taak toevoegen';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = '';
    $Self->{Translation}->{'Time periods can not be deleted.'} = 'Tijdperiodes kunnen niet worden verwijderd.';
    $Self->{Translation}->{'Project List'} = '';
    $Self->{Translation}->{'Task List'} = '';
    $Self->{Translation}->{'Add Task'} = 'Taak toevoegen';
    $Self->{Translation}->{'Edit Task Settings'} = '';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        '';
    $Self->{Translation}->{'User List'} = 'Gebruikerslijst';
    $Self->{Translation}->{'User Settings'} = '';
    $Self->{Translation}->{'User is allowed to see overtimes'} = '';
    $Self->{Translation}->{'Show Overtime'} = 'Toon Overuren';
    $Self->{Translation}->{'User is allowed to create projects'} = '';
    $Self->{Translation}->{'Allow project creation'} = '';
    $Self->{Translation}->{'User is allowed to skip time accounting'} = '';
    $Self->{Translation}->{'Allow time accounting skipping'} = '';
    $Self->{Translation}->{'If this option is selected, time accounting is effectively optional for the user.'} =
        '';
    $Self->{Translation}->{'There will be no warnings about missing entries and no entry enforcement.'} =
        '';
    $Self->{Translation}->{'Time Spans'} = '';
    $Self->{Translation}->{'Period Begin'} = 'Beginperiode';
    $Self->{Translation}->{'Period End'} = 'Eindperiode';
    $Self->{Translation}->{'Days of Vacation'} = 'Vakantiedagen';
    $Self->{Translation}->{'Hours per Week'} = 'Uren per week';
    $Self->{Translation}->{'Authorized Overtime'} = '';
    $Self->{Translation}->{'Start Date'} = 'Begindatum';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Voer een geldige datum in.';
    $Self->{Translation}->{'End Date'} = 'Einddatum';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Eindperiode moet na Beginperiode zijn.';
    $Self->{Translation}->{'Leave Days'} = '';
    $Self->{Translation}->{'Weekly Hours'} = 'Weekuren';
    $Self->{Translation}->{'Overtime'} = 'Overuren';
    $Self->{Translation}->{'No time periods found.'} = 'Geen tijdperiodes gevonden.';
    $Self->{Translation}->{'Add time period'} = 'Voeg tijdperiode toe';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = '';
    $Self->{Translation}->{'View of '} = 'Weergave van';
    $Self->{Translation}->{'Previous day'} = 'Vorige dag';
    $Self->{Translation}->{'Next day'} = 'Volgende dag';
    $Self->{Translation}->{'No data found for this day.'} = 'Geen data gevonden voor deze dag.';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = '';
    $Self->{Translation}->{'Last Projects'} = 'Laatste Projecten';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = '';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = '';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        '';
    $Self->{Translation}->{'Incomplete Working Days'} = 'Incomplete Werkdagen';
    $Self->{Translation}->{'Successful insert!'} = 'Succesvol ingevoerd!';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = 'Fout tijdens invoeren meerdere data!';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = 'Succesvol invoeren van meerdere data!';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = 'Ingevoerde data is goedgekeurd! Data is aangepast naar vandaag.';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        '';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        '';
    $Self->{Translation}->{'Last Selected Projects'} = 'Laatst Geselecteerde Projecten';
    $Self->{Translation}->{'All Projects'} = 'Alle Projecten';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = '';
    $Self->{Translation}->{'Reporting Project'} = '';
    $Self->{Translation}->{'Reporting'} = 'Rapportage';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = '';
    $Self->{Translation}->{'Project added!'} = '';
    $Self->{Translation}->{'Project updated!'} = '';
    $Self->{Translation}->{'Task added!'} = '';
    $Self->{Translation}->{'Task updated!'} = '';
    $Self->{Translation}->{'The UserID is not valid!'} = '';
    $Self->{Translation}->{'Can\'t insert user data!'} = '';
    $Self->{Translation}->{'Unable to add time period!'} = '';
    $Self->{Translation}->{'Setting'} = 'Instelling';
    $Self->{Translation}->{'User updated!'} = '';
    $Self->{Translation}->{'User added!'} = '';
    $Self->{Translation}->{'Add a user to time accounting...'} = '';
    $Self->{Translation}->{'New User'} = 'Nieuwe Gebruiker';
    $Self->{Translation}->{'Period Status'} = 'Periode Status';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = '';

    # Perl Module: Kernel/Output/HTML/Notification/TimeAccounting.pm
    $Self->{Translation}->{'Please insert your working hours!'} = 'Voer uw werkuren in!';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = 'Incomplete Werkdagen';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = 'Kies op zijn minst 1 dag!';
    $Self->{Translation}->{'Mass Entry'} = '';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Kies een reden van absentie!';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = '';
    $Self->{Translation}->{'Confirm insert'} = '';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        '';
    $Self->{Translation}->{'Default name for new actions.'} = 'Standaardnaam voor nieuwe acties.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Standaardnaam voor nieuwe projecten.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Standaardinstelling voor einddatum.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Standaardinstelling voor begindatum.';
    $Self->{Translation}->{'Default setting for description.'} = 'Standaardinstelling voor omschrijving.';
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
    $Self->{Translation}->{'Edit time accounting settings.'} = '';
    $Self->{Translation}->{'Edit time record.'} = '';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = '';
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
    $Self->{Translation}->{'Overview.'} = '';
    $Self->{Translation}->{'Project time reporting.'} = '';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        '';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        '';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        '';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = '';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        '';
    $Self->{Translation}->{'Time Accounting'} = 'Tijd verantwoording';
    $Self->{Translation}->{'Time accounting edit.'} = '';
    $Self->{Translation}->{'Time accounting overview.'} = '';
    $Self->{Translation}->{'Time accounting reporting.'} = '';
    $Self->{Translation}->{'Time accounting settings.'} = '';
    $Self->{Translation}->{'Time accounting view.'} = '';
    $Self->{Translation}->{'Time accounting.'} = '';
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
