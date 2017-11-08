# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Möchten Sie wirklich die Zeiterfassung für den aktuellen Tag löschen?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Zeitabrechnung bearbeiten';
    $Self->{Translation}->{'Go to settings'} = 'Gehe zu Einstellungen';
    $Self->{Translation}->{'Date Navigation'} = 'Datumsnavigation';
    $Self->{Translation}->{'Days without entries'} = 'Nicht ausgefüllte Tage';
    $Self->{Translation}->{'Select all days'} = 'Alle Tage auswählen';
    $Self->{Translation}->{'Mass entry'} = 'Masseneintrag';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Bitte wählen Sie den Grund für Ihre Abwesenheit für die ausgewählten Tage';
    $Self->{Translation}->{'On vacation'} = 'im Urlaub';
    $Self->{Translation}->{'On sick leave'} = 'Erkrankt';
    $Self->{Translation}->{'On overtime leave'} = 'Überstunden';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'Felder, die ausgefüllt werden müssen, sind mit einem Stern "*" gekennzeichnet.';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Sie müssen eine Start- und Endzeit oder eine Zeitspanne angeben.';
    $Self->{Translation}->{'Project'} = 'Projekt';
    $Self->{Translation}->{'Task'} = 'Tätigkeit';
    $Self->{Translation}->{'Remark'} = 'Anmerkung';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = 'Bitte geben Sie eine Anmerkung von mehr als 8 Zeichen Länge ein!';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Negative Angaben sind nicht erlaubt.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Diese Startzeit wurde bereits in einem anderen Eintrag angegeben.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'Ungültiges Format! Bitte geben Sie eine Zeit im Format HH:MM ein.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = 'Nur 24:00 ist als Endzeit erlaubt.';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'Ungültige Zeit! Ein Tag hat nur 24 Stunden';
    $Self->{Translation}->{'End time must be after start time.'} = 'Die Endzeit muss nach der Startzeit sein.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Diese Endzeit wurde bereits in einem anderen Eintrag angegeben.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Ungültige Angabe. Ein Tag hat nur 24 Stunden.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Eine gültige Zeitdauer muss größer als Null sein.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Ungültige Angabe. Negative Zeitspannen sind nicht möglich.';
    $Self->{Translation}->{'Add one row'} = 'Eine Zeile hinzufügen';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Sie können nur eine Checkbox markieren!';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Sind Sie sicher, dass Sie gearbeitet haben, obwohl Sie erkrankt sind?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Sind Sie sicher, dass Sie gearbeitet haben, obwohl Sie im Urlaub sind?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Sind Sie sicher, dass Sie gearbeitet haben, obwohl Sie Überstunden genommen haben?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Sind Sie sicher, dass Sie mehr als 16 Stunden gearbeitet haben?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Monatsübersicht Zeitberichterstattung';
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
    $Self->{Translation}->{'Previous month'} = 'Vorheriger Monat';
    $Self->{Translation}->{'Next month'} = 'Nächster Monat';
    $Self->{Translation}->{'Weekday'} = 'Wochentag';
    $Self->{Translation}->{'Working Hours'} = 'Arbeitsstunden';
    $Self->{Translation}->{'Total worked hours'} = 'Arbeitsstunden (gesamt)';
    $Self->{Translation}->{'User\'s project overview'} = 'Projektübersicht des Benutzers';
    $Self->{Translation}->{'Hours (monthly)'} = 'Stunden (im Monat)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Stunden (gesamt)';
    $Self->{Translation}->{'Grand total'} = 'Summe';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Zeitberichterstattung';
    $Self->{Translation}->{'Month Navigation'} = 'Datumsauswahl';
    $Self->{Translation}->{'Go to date'} = 'Gehe zu Datum';
    $Self->{Translation}->{'User reports'} = 'Nutzerberichte';
    $Self->{Translation}->{'Monthly total'} = 'pro Monat';
    $Self->{Translation}->{'Lifetime total'} = 'Summe';
    $Self->{Translation}->{'Overtime leave'} = 'Überstunden';
    $Self->{Translation}->{'Vacation'} = 'Urlaub';
    $Self->{Translation}->{'Sick leave'} = 'Erkrankt';
    $Self->{Translation}->{'Vacation remaining'} = 'Verbleibende Urlaubstage';
    $Self->{Translation}->{'Project reports'} = 'Projektberichte';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Projektübersicht';
    $Self->{Translation}->{'Go to reporting overview'} = 'Zur Berichterstattungsübersicht gehen';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        'Derzeit werden in diesem Projekt nur aktive Benutzer angezeigt. Um diese Einstellung zu ändern, bearbeiten Sie bitte:';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'Derzeit werden alle zeiterfassenden Benutzer angezeigt. Um diese Einstellung zu ändern, bearbeiten Sie bitte:';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Zeitabrechnung-Projekteinstellungen bearbeiten';
    $Self->{Translation}->{'Add project'} = 'Projekt hinzufügen';
    $Self->{Translation}->{'Go to settings overview'} = 'Zur Einstellungsübersicht gehen';
    $Self->{Translation}->{'Add Project'} = 'Projekt hinzufügen';
    $Self->{Translation}->{'Edit Project Settings'} = 'Projekteinstellungen bearbeiten';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Ein Projekt mit gleichem Namen existiert bereits. Bitte wählen Sie einen anderen Namen.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Zeitabrechnungseinstellungen bearbeiten';
    $Self->{Translation}->{'Add task'} = 'Tätigkeit hinzufügen';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = 'Filter für Projekte, Aufgaben oder Benutzer';
    $Self->{Translation}->{'Time periods can not be deleted.'} = 'Zeitfenster können nicht gelöscht werden.';
    $Self->{Translation}->{'Project List'} = 'Projektliste';
    $Self->{Translation}->{'Task List'} = 'Tätigkeitsliste';
    $Self->{Translation}->{'Add Task'} = 'Tätigkeit hinzufügen';
    $Self->{Translation}->{'Edit Task Settings'} = 'Tätigkeitseinstellungen bearbeiten';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Eine Tätigkeit mit gleichem Namen existiert bereits. Bitte wählen Sie einen anderen Namen.';
    $Self->{Translation}->{'User List'} = 'Benutzerliste';
    $Self->{Translation}->{'User Settings'} = 'Benutzereinstellungen';
    $Self->{Translation}->{'User is allowed to see overtimes'} = 'Benutzer ist berechtigt Überstunden zu sehen';
    $Self->{Translation}->{'Show Overtime'} = 'Überstunden anzeigen';
    $Self->{Translation}->{'User is allowed to create projects'} = 'Benutzer ist berechtigt Projekte zu erstellen';
    $Self->{Translation}->{'Allow project creation'} = 'Projekt erstellen';
    $Self->{Translation}->{'Time Spans'} = 'Zeitspannen';
    $Self->{Translation}->{'Period Begin'} = 'Datum Beginn';
    $Self->{Translation}->{'Period End'} = 'Datum Ende';
    $Self->{Translation}->{'Days of Vacation'} = 'Urlaubstage';
    $Self->{Translation}->{'Hours per Week'} = 'Wochenstunden';
    $Self->{Translation}->{'Authorized Overtime'} = 'Autorisierte Überstunden';
    $Self->{Translation}->{'Start Date'} = 'Startdatum';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Bitte geben Sie ein gültiges Datum ein.';
    $Self->{Translation}->{'End Date'} = 'Enddatum';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Das Ende der Zeitspanne muss nach dem Anfang sein.';
    $Self->{Translation}->{'Leave Days'} = 'Urlaubstage';
    $Self->{Translation}->{'Weekly Hours'} = 'Wöchentliche Stunden';
    $Self->{Translation}->{'Overtime'} = 'Überstunden';
    $Self->{Translation}->{'No time periods found.'} = 'Keine Zeitspanne gefunden.';
    $Self->{Translation}->{'Add time period'} = 'Zeitspanne hinzufügen';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Datensatz anzeigen';
    $Self->{Translation}->{'View of '} = 'Ansicht von';
    $Self->{Translation}->{'Previous day'} = 'Vorheriger Tag';
    $Self->{Translation}->{'Next day'} = 'Nächster Tag';
    $Self->{Translation}->{'No data found for this day.'} = 'Kein Eintrag für diesen Tag gefunden.';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = 'Kann Arbeitseinheiten nicht einfügen!';
    $Self->{Translation}->{'Last Projects'} = 'Letzte Projekte';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = 'Ungültige Angabe. Ein Tag hat nur 24 Stunden.';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = 'Kann Arbeitseinheiten nicht löschen!';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        'Dieses Datum ist außerhalb des Grenzwertes, aber Sie haben diesen Tag bis jetzt noch nicht eingefügt, also bekommen Sie dafür eine(!) Chance.';
    $Self->{Translation}->{'Incomplete Working Days'} = 'Unvollständige Arbeitstage';
    $Self->{Translation}->{'Please insert your working hours!'} = 'Bitte die Arbeitsstunden eintragen!';
    $Self->{Translation}->{'Successful insert!'} = 'Eingaben gespeichert!';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = 'Fehler bei der Eingabe für mehrere Tage!';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = 'Daten für mehrere Tage erfolgreich erfasst!';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = 'Eingegebenes Datum ungültig! Datum wurde auf \'heute\' geändert.';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        'Es ist keine Zeitperiode konfiguriert, oder das angegebene Datum liegt außerhalb der konfigurierten Zeitperioden.';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        'Bitte kontaktieren Sie ihren Zeiterfassungs-Administrator, um die Zeitperioden zu aktualisieren.';
    $Self->{Translation}->{'Last Selected Projects'} = 'Zuletzt ausgewählte Projekte';
    $Self->{Translation}->{'All Projects'} = 'Alle Projekte';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = 'Berichtsprojekt: Benötige ProjectID';
    $Self->{Translation}->{'Reporting Project'} = 'Berichtsprojekt';
    $Self->{Translation}->{'Reporting'} = 'Berichterstattung';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = 'Benutzereinstellungen können nicht aktualisiert werden!';
    $Self->{Translation}->{'Project added!'} = 'Projekt hinzugefügt!';
    $Self->{Translation}->{'Project updated!'} = 'Projekt aktualisiert';
    $Self->{Translation}->{'Task added!'} = 'Aufgabe hinzugefügt!';
    $Self->{Translation}->{'Task updated!'} = 'Aufgabe aktualisiert!';
    $Self->{Translation}->{'The UserID is not valid!'} = 'Die UserID ist ungültig!';
    $Self->{Translation}->{'Can\'t insert user data!'} = 'Kann Benutzerdaten nicht einfügen!';
    $Self->{Translation}->{'Unable to add time period!'} = 'Kann Zeitperiode nicht hinzufügen!';
    $Self->{Translation}->{'Setting'} = 'Einstellung';
    $Self->{Translation}->{'User updated!'} = 'Benutzer aktualisiert!';
    $Self->{Translation}->{'User added!'} = 'Benutzer hinzugefügt!';
    $Self->{Translation}->{'Add a user to time accounting...'} = 'Einen Benutzer zur Zeitabrechnung hinzufügen';
    $Self->{Translation}->{'New User'} = 'Neuer Benutzer';
    $Self->{Translation}->{'Period Status'} = 'Status des Zeitraums';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = 'Ansicht: Benötige %s!';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = 'Unvollständige Arbeitstage';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = 'Bitte wählen Sie mindestens einen Tag!';
    $Self->{Translation}->{'Mass Entry'} = 'Masseneintrag';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Bitte wählen Sie einen Grund für die Abwesenheit aus!';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Eintrag löschen';
    $Self->{Translation}->{'Confirm insert'} = 'Eingabe bestätigen';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'Modul zum Anzeigen der Anzahl der unvollständigen Arbeitstage des Benutzers.';
    $Self->{Translation}->{'Default name for new actions.'} = 'Standardname für neue Tätigkeiten.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Anfangsstatus eines neuen Projekts.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Standardeinstellung für Enddatum.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Standardeinstellung für Startdatum.';
    $Self->{Translation}->{'Default setting for description.'} = 'Standardeinstellung für Beschreibungen.';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Standardeinstellung für Urlaubstage.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Eventuell vorhandener Überstundenübertrag.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Standard Wochenarbeitszeit.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Anfangsstatus einer neuen Tätigkeit.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Anfangsstatus eines neuen Projekts.';
    $Self->{Translation}->{'Default status for new users.'} = 'Anfangsstatus eines neuen Benutzers.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        'Innerhalb dieser Konfigurationsoption kann eine RegExp definiert werden, die festlegt, bei welchen Projekten eine Bemerkung eingetragen werden muss (die RegExp arbeitet mit smx-Parametern).';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        'Bestimmt, ob das Statistik-Modul Informationen zur Zeitabrechnung generieren kann.';
    $Self->{Translation}->{'Edit time accounting settings.'} = 'Zeiterfassungs-Einstellungen bearbeiten.';
    $Self->{Translation}->{'Edit time record.'} = 'Zeit-Datensatz bearbeiten.';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Legt fest, bis wann man in ältere Zeiteinträge bearbeiten kann (z. B. 10 Tage zurückliegend).';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        'Wenn aktiviert, werden nur User angezeigt die Arbeitszeiten zu dem gewählten Projekt hinzugefügt haben.';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        'Wenn aktiviert werden die Dropdown-Felder im der Editier-Oberfläche in der neuen Form als Feld mit Auto-Vervollständigen angezeigt.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        'Der Filter bei vorherigen Projekten kann bei Aktivierung genutzt werden, anstelle das zwei Projekt Listen (letzte und alle) genutzt werden. Es kann allerdings nur genutzt werden wenn TimeAccounting::EnableAutoCompletion aktiviert ist.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        'Bei Aktivierung ist der Filter der vorherigen Projekte standardmässig aktiv falls vorherige Projekte vorhanden sind. Er kann nur genutzt werden wenn EnableAutoCompletion und  TimeAccounting::UseFilter aktiviert sind.';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        'Wenn aktiviert,  können Benutzer "im Urlaub", "Erkrankt" und "Überstunden" an mehreren Tagen auf einmal setzen.';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        'Maximale Anzahl von Arbeitstagen, nach der die Arbeitszeit eingetragen werden muss.';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        'Maximale Anzahl von Arbeitstagen ohne Arbeitszeiteinträge nach denen eine Warnung angezeigt wird.';
    $Self->{Translation}->{'Overview.'} = 'Übersicht.';
    $Self->{Translation}->{'Project time reporting.'} = 'Projekt-Zeit-Reporting.';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'Regulärer Ausdruck, um die Liste der Tätigkeiten bezüglich des ausgewählten Projekts einzuschränken. Der Schlüssel enthält einen Regulären Ausdruck für Projekte, der Wert einen Regulären Ausdruck für die Tätigkeiten.';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'Regulärer Ausdruck, um die Liste der Projekte bezüglich des aktiven Benutzers einzuschränken. Der Schlüssel enthält einen Regulären Ausdruck für Projekte, der Wert enthält eine komma-separierte Liste von Benutzergruppen.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        'Gibt an, ob Arbeitsstunden ohne Start- und Endzeit eingegeben werden können.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Dieses Modul zwingt zur Eingabe von Stunden.';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'Modul, dass den Agent im Notification-Bereich des Agent-Interfaces darüber informiert, wenn schon zu lange keine Stunden mehr eingetragen wurden.';
    $Self->{Translation}->{'Time Accounting'} = 'Zeitabrechnung';
    $Self->{Translation}->{'Time accounting edit.'} = 'Zeitabrechnung Bearbeitung.';
    $Self->{Translation}->{'Time accounting overview.'} = 'Zeitabrechnungsübersicht.';
    $Self->{Translation}->{'Time accounting reporting.'} = 'Zeitabrechnung Berichterstattung.';
    $Self->{Translation}->{'Time accounting settings.'} = 'Zeitabrechnung Einstellungen.';
    $Self->{Translation}->{'Time accounting view.'} = 'Zeitabrechnung Ansicht.';
    $Self->{Translation}->{'Time accounting.'} = 'Zeitabrechnung';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        'Hier kann man eingeben, ob für eine bestimmte Tätigkeit, die zu verrechnenden Stunden gekürzt werden. Z. B wenn Reisezeiten nur zur Hälfte vergütet werden (Key =&gt; journey; Content =&gt; 50).';


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
