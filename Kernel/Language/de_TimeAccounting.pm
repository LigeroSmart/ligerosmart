# --
# Kernel/Language/de_TimeAccounting.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: de_TimeAccounting.pm,v 1.1 2011-01-13 23:03:46 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_TimeAccounting;

use strict;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} = '';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Zeiterfassung bearbeiten';
    $Self->{Translation}->{'Project settings'} = 'Projektkonfiguration';
    $Self->{Translation}->{'Date Navigation'} = 'Auswahl Datum';
    $Self->{Translation}->{'Previous day'} = '';
    $Self->{Translation}->{'Next day'} = 'Nächster Tag';
    $Self->{Translation}->{'Days without entries'} = 'nicht ausgefüllte Tage';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = '';
    $Self->{Translation}->{'You have to insert a start and an end times or a period.'} = '';
    $Self->{Translation}->{'Project'} = 'Projekt';
    $Self->{Translation}->{'Task'} = 'Tätigkeit';
    $Self->{Translation}->{'Remark'} = 'Anmerkung';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = '';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Sie müssen Beginn- und Endezeit oder die Dauer angeben.';
    $Self->{Translation}->{'Negative times are not allowed.'} = '';
    $Self->{Translation}->{'Repetead hours are not allowed. Start time matches another interval.'} = '';
    $Self->{Translation}->{'End time must be after start time.'} = '';
    $Self->{Translation}->{'Repetead hours are not allowed. End time matches another interval.'} = '';
    $Self->{Translation}->{'Period is bigger than the interval between start and end times!'} = '';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = '';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = '';
    $Self->{Translation}->{'Add one row'} = '';
    $Self->{Translation}->{'Total'} = 'Summe';
    $Self->{Translation}->{'On vacation'} = 'im Urlaub';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Sie können nur eine Checkbox markieren!';
    $Self->{Translation}->{'On sick leave'} = 'Erkrankt';
    $Self->{Translation}->{'On overtime leave'} = 'Überstunden';
    $Self->{Translation}->{'Show all items'} = '';
    $Self->{Translation}->{'Delete Time Accounting Entry'} = '';
    $Self->{Translation}->{'Confirm insert'} = '';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = '';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = '';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} = '';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = '';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Monatsübersicht Zeiterfassung';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Überstunden (in Stunden)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Überstunden (dieser Monat)';
    $Self->{Translation}->{'Overtime (total)'} = 'Überstunden (Summe)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Überstunden (verbleibend)';
    $Self->{Translation}->{'Vacation (Days)'} = 'Urlaub (in Tagen)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Urlaubstage (dieser Monat)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Urlaubstage (Summe)';
    $Self->{Translation}->{'Remaining vacation'} = 'Urlaubstage (verbleibend)';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Erkrankt (in Tagen)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Erkrankt (dieser Monat)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Erkrankt (Summe)';
    $Self->{Translation}->{'Previous month'} = '';
    $Self->{Translation}->{'Next month'} = '';
    $Self->{Translation}->{'Weekday'} = '';
    $Self->{Translation}->{'Working Hours'} = 'Arbeitsstunden';
    $Self->{Translation}->{'Total worked hours'} = 'Arbeitsstunden';
    $Self->{Translation}->{'User\'s project overview'} = 'Nutzerberichte';
    $Self->{Translation}->{'Hours (monthly)'} = '';
    $Self->{Translation}->{'Hours (Lifetime)'} = '';
    $Self->{Translation}->{'Grand total'} = 'Summe';

    # Template: AgentTimeAccountingProjectReporting
    $Self->{Translation}->{'Project report'} = '';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Zeitberichte';
    $Self->{Translation}->{'Month Navigation'} = 'Auswahl Datum';
    $Self->{Translation}->{'User reports'} = 'Nutzerberichte';
    $Self->{Translation}->{'Monthly total'} = 'pro Monat';
    $Self->{Translation}->{'Lifetime total'} = 'Summe';
    $Self->{Translation}->{'Overtime leave'} = 'Überstunden';
    $Self->{Translation}->{'Vacation'} = 'Urlaub';
    $Self->{Translation}->{'Sick leave'} = 'Erkrankt';
    $Self->{Translation}->{'LeaveDay Remaining'} = 'Verbleibende Urlaubstage';
    $Self->{Translation}->{'Project reports'} = 'Projektberichte';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Zeiterfassung: Bearbeitung der Projektkonfiguration';
    $Self->{Translation}->{'Add project'} = '';
    $Self->{Translation}->{'Add Project'} = '';
    $Self->{Translation}->{'Edit Project Settings'} = '';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} = '';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Zeiterfassungseinstellungen bearbeiten';
    $Self->{Translation}->{'Add task'} = '';
    $Self->{Translation}->{'New user'} = '';
    $Self->{Translation}->{'Filter for Projects'} = '';
    $Self->{Translation}->{'Filter for Tasks'} = '';
    $Self->{Translation}->{'Filter for Users'} = '';
    $Self->{Translation}->{'Project List'} = '';
    $Self->{Translation}->{'Task List'} = '';
    $Self->{Translation}->{'Add Task'} = '';
    $Self->{Translation}->{'Edit Task Settings'} = '';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} = '';
    $Self->{Translation}->{'User List'} = '';
    $Self->{Translation}->{'New User Settings'} = '';
    $Self->{Translation}->{'Edit User Settings'} = '';
    $Self->{Translation}->{'Comments'} = 'Kommentare';
    $Self->{Translation}->{'Show Overtime'} = 'Überstunden anzeigen';
    $Self->{Translation}->{'Allow project creation'} = 'Projekt erstellen';
    $Self->{Translation}->{'Period Begin'} = 'Datum Beginn';
    $Self->{Translation}->{'Period End'} = 'Datum Ende';
    $Self->{Translation}->{'Days of Vacation'} = 'Urlaubstage';
    $Self->{Translation}->{'Hours per Week'} = 'Wochenstunden';
    $Self->{Translation}->{'Authorized Overtime'} = 'autorisierte Überstunden';
    $Self->{Translation}->{'Period end must be after period begin.'} = '';
    $Self->{Translation}->{'No time periods found.'} = '';
    $Self->{Translation}->{'Add time period'} = 'Neue Nutzereinstellung';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Zeitrekord ansicht';
    $Self->{Translation}->{'View of '} = 'Ansicht von';
    $Self->{Translation}->{'Date navigation'} = 'Auswahl Datum';
    $Self->{Translation}->{'No data found for this day.'} = '';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} = '';
    $Self->{Translation}->{'Default name for new actions.'} = 'Initialer Name einer neuen Tätigkeit in der Zeiterfassung.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Anfangsstatus eines neuen Projekts.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Enddatum für die Eingaben.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Startdatum für die Eingaben.';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Standard Urlaubstage.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Eventuell vorhandener Überstundenübertrag.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Standard Wochenarbeitszeit.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Anfangsstatus einer neuen Tätigkeit.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Anfangsstatus eines neuen Projekts.';
    $Self->{Translation}->{'Default status for new users.'} = 'Anfangsstatus eines neuen Benutzers.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'}
        = 'Innerhalb dieser Konfigurationsoption kann eine RegExp definiert werden, die festlegt, bei welchen Projekten eine Bemerkung eingetragen werden muss (die RegExp arbeitet mit smx-Parametern).';
    $Self->{Translation}->{'Edit time accounting settings'} = 'Zeiterfassungseinstellungen bearbeiten';
    $Self->{Translation}->{'Edit time record'} = 'Zeiterfassung bearbeiten';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Legt fest, bis wann man in ältere Zeiteinträge bearbeiten kann (z. B. 10 Tage zurückliegend).';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to autocompletion fields.'} = '';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} = '';
    $Self->{Translation}->{'Maximum number of working days withouth working units entry after which a warning will be shown.'} = '';
    $Self->{Translation}->{'Project time reporting'} = '';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} = '';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} = '';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} = '';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = '';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'}
        = 'Modul, das den Agent im Notification-Bereich des Agent-Interfaces darüber informiert, wenn schon zu lange keine Stunden mehr eingetragen wurden.';
    $Self->{Translation}->{'Time accounting.'} = 'Zeiterfassung.';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'}
        = 'Hier kann man eingeben, ob für eine bestimmte Tätigkeit, die zu verrechnenden Stunden gekürzt werden. Z. B wenn Reisezeiten nur zur Hälfte vergütet werden (Key =&gt; journey; Content =&gt; 50).';


    $Self->{Translation}->{'Reporting'} = 'Berichtswesen';
    $Self->{Translation}->{'Successful insert!'} = 'Erfolgreich eingefügt!';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = 'Ein Tag hat nur 24 Stunden!';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = 'Kann Arbeitsstunden nicht löschen!';
    $Self->{Translation}->{'Please insert your working hours!'} = 'Bitte tragen Sie Ihre Arbeitszeiten ein!';
    $Self->{Translation}->{'Mon'} = 'Mo';
    $Self->{Translation}->{'Tue'} = 'Di';
    $Self->{Translation}->{'Wed'} = 'Mi';
    $Self->{Translation}->{'Thu'} = 'Do';
    $Self->{Translation}->{'Fri'} = 'Fr';
    $Self->{Translation}->{'Sat'} = 'Sa';
    $Self->{Translation}->{'Sun'} = 'So';
    $Self->{Translation}->{'January'} = 'Januar';
    $Self->{Translation}->{'February'} = 'Februar';
    $Self->{Translation}->{'March'} = 'März';
    $Self->{Translation}->{'April'} = 'April';
    $Self->{Translation}->{'May'} = 'Mai';
    $Self->{Translation}->{'June'} = 'Juni';
    $Self->{Translation}->{'July'} = 'Juli';
    $Self->{Translation}->{'August'} = 'August';
    $Self->{Translation}->{'September'} = 'September';
    $Self->{Translation}->{'October'} = 'Oktober';
    $Self->{Translation}->{'November'} = 'November';
    $Self->{Translation}->{'December'} = 'Dezember';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
