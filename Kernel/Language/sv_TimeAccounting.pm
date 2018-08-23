# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sv_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        '';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = '';
    $Self->{Translation}->{'Go to settings'} = 'Gå till inställningar';
    $Self->{Translation}->{'Date Navigation'} = 'Datum-navigering';
    $Self->{Translation}->{'Days without entries'} = '';
    $Self->{Translation}->{'Select all days'} = 'Välj alla dagar';
    $Self->{Translation}->{'Mass entry'} = '';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        '';
    $Self->{Translation}->{'On vacation'} = 'På semester';
    $Self->{Translation}->{'On sick leave'} = 'Sjukledig';
    $Self->{Translation}->{'On overtime leave'} = '';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = '';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = '';
    $Self->{Translation}->{'Project'} = 'Projekt';
    $Self->{Translation}->{'Task'} = 'Uppdrag';
    $Self->{Translation}->{'Remark'} = 'Anmärk';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = '';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Negativa tider är inte tillåtna.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        '';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'Ogiltigt format! Vänligen fyll i en tid med formatet HH:MM.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'Ogiltig tid! Ett dygn har bara 24 timmar.';
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
    $Self->{Translation}->{'Overtime (Hours)'} = 'Övertid (Timmar)';
    $Self->{Translation}->{'Overtime (this month)'} = '';
    $Self->{Translation}->{'Overtime (total)'} = '';
    $Self->{Translation}->{'Remaining overtime leave'} = '';
    $Self->{Translation}->{'Vacation (Days)'} = 'Semester (Dagar)';
    $Self->{Translation}->{'Vacation taken (this month)'} = '';
    $Self->{Translation}->{'Vacation taken (total)'} = '';
    $Self->{Translation}->{'Remaining vacation'} = '';
    $Self->{Translation}->{'Sick Leave (Days)'} = '';
    $Self->{Translation}->{'Sick leave taken (this month)'} = '';
    $Self->{Translation}->{'Sick leave taken (total)'} = '';
    $Self->{Translation}->{'Previous month'} = '';
    $Self->{Translation}->{'Next month'} = '';
    $Self->{Translation}->{'Weekday'} = '';
    $Self->{Translation}->{'Working Hours'} = '';
    $Self->{Translation}->{'Total worked hours'} = '';
    $Self->{Translation}->{'User\'s project overview'} = '';
    $Self->{Translation}->{'Hours (monthly)'} = '';
    $Self->{Translation}->{'Hours (Lifetime)'} = '';
    $Self->{Translation}->{'Grand total'} = '';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = '';
    $Self->{Translation}->{'Month Navigation'} = '';
    $Self->{Translation}->{'Go to date'} = '';
    $Self->{Translation}->{'User reports'} = '';
    $Self->{Translation}->{'Monthly total'} = '';
    $Self->{Translation}->{'Lifetime total'} = '';
    $Self->{Translation}->{'Overtime leave'} = '';
    $Self->{Translation}->{'Vacation'} = '';
    $Self->{Translation}->{'Sick leave'} = '';
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
    $Self->{Translation}->{'Add task'} = '';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = '';
    $Self->{Translation}->{'Time periods can not be deleted.'} = '';
    $Self->{Translation}->{'Project List'} = '';
    $Self->{Translation}->{'Task List'} = '';
    $Self->{Translation}->{'Add Task'} = '';
    $Self->{Translation}->{'Edit Task Settings'} = '';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        '';
    $Self->{Translation}->{'User List'} = '';
    $Self->{Translation}->{'User Settings'} = '';
    $Self->{Translation}->{'User is allowed to see overtimes'} = '';
    $Self->{Translation}->{'Show Overtime'} = '';
    $Self->{Translation}->{'User is allowed to create projects'} = '';
    $Self->{Translation}->{'Allow project creation'} = '';
    $Self->{Translation}->{'User is allowed to skip time accounting'} = '';
    $Self->{Translation}->{'Allow time accounting skipping'} = '';
    $Self->{Translation}->{'If this option is selected, time accounting is effectively optional for the user.'} =
        '';
    $Self->{Translation}->{'There will be no warnings about missing entries and no entry enforcement.'} =
        '';
    $Self->{Translation}->{'Time Spans'} = '';
    $Self->{Translation}->{'Period Begin'} = '';
    $Self->{Translation}->{'Period End'} = '';
    $Self->{Translation}->{'Days of Vacation'} = '';
    $Self->{Translation}->{'Hours per Week'} = '';
    $Self->{Translation}->{'Authorized Overtime'} = '';
    $Self->{Translation}->{'Start Date'} = '';
    $Self->{Translation}->{'Please insert a valid date.'} = '';
    $Self->{Translation}->{'End Date'} = '';
    $Self->{Translation}->{'Period end must be after period begin.'} = '';
    $Self->{Translation}->{'Leave Days'} = '';
    $Self->{Translation}->{'Weekly Hours'} = '';
    $Self->{Translation}->{'Overtime'} = '';
    $Self->{Translation}->{'No time periods found.'} = '';
    $Self->{Translation}->{'Add time period'} = '';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = '';
    $Self->{Translation}->{'View of '} = '';
    $Self->{Translation}->{'Previous day'} = 'Föregående dag';
    $Self->{Translation}->{'Next day'} = 'Nästkommande dag';
    $Self->{Translation}->{'No data found for this day.'} = '';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = '';
    $Self->{Translation}->{'Last Projects'} = '';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = '';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = '';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        '';
    $Self->{Translation}->{'Incomplete Working Days'} = '';
    $Self->{Translation}->{'Please insert your working hours!'} = 'Var vänlig fyll i dina arbetstimmar!';
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
    $Self->{Translation}->{'Reporting'} = 'Rapportering';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = '';
    $Self->{Translation}->{'Project added!'} = '';
    $Self->{Translation}->{'Project updated!'} = '';
    $Self->{Translation}->{'Task added!'} = '';
    $Self->{Translation}->{'Task updated!'} = '';
    $Self->{Translation}->{'The UserID is not valid!'} = '';
    $Self->{Translation}->{'Can\'t insert user data!'} = '';
    $Self->{Translation}->{'Unable to add time period!'} = '';
    $Self->{Translation}->{'Setting'} = 'Inställning';
    $Self->{Translation}->{'User updated!'} = '';
    $Self->{Translation}->{'User added!'} = '';
    $Self->{Translation}->{'Add a user to time accounting...'} = '';
    $Self->{Translation}->{'New User'} = '';
    $Self->{Translation}->{'Period Status'} = '';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = '';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = 'Vänligen välj åtminstone en dag!';
    $Self->{Translation}->{'Mass Entry'} = '';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Vänligen välj en anledning för frånvaro!';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = '';
    $Self->{Translation}->{'Confirm insert'} = '';

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
    $Self->{Translation}->{'Time Accounting'} = '';
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
