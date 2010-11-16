# --
# Kernel/Language/de_AgentTimeAccounting.pm - the de language for AgentTimeAccounting
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: de_AgentTimeAccounting.pm,v 1.45 2010-11-16 21:37:02 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_AgentTimeAccounting;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.45 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Setting'} = 'Konfiguration';
    $Lang->{'Project settings'} = 'Projektkonfigurationen';
    $Lang->{'Next day'} = 'Nächster Tag';
    $Lang->{'One day back'} = 'Einen Tag zurück';
    $Lang->{'Date'} = 'Datum';
    $Lang->{'Comments'} = 'Kommentare';
    $Lang->{'until'} = 'bis';
    $Lang->{'Total hours worked'} = 'Arbeitsstunden';
    $Lang->{'Working Hours'} = 'Arbeitsstunden';
    $Lang->{'Hours per week'} = 'Wochenstunden';
    $Lang->{'this month'} = 'dieser Monat';
    $Lang->{'Overtime (Hours)'} = 'Überstunden (in Stunden)';
    $Lang->{'Overtime (total)'} = 'Überstunden (dieser Monat)';
    $Lang->{'Overtime (this month)'} = 'Überstunden (Summe)';
    $Lang->{'Remaining overtime leave'} = 'Überstunden (verbleibend)';
    $Lang->{'Vacation'} = 'Urlaub';
    $Lang->{'Vacation (Days)'} = 'Urlaub (in Tagen)';
    $Lang->{'Vacation taken (this month)'} = 'Urlaubstage (dieser Monat)';
    $Lang->{'Vacation taken (total)'} = 'Urlaubstage (Summe)';
    $Lang->{'Remaining vacation'} = 'Urlaubstage (verbleibend)';
    $Lang->{'Sick leave taken (this month)'} = 'Erkrankt (dieser Monat)';
    $Lang->{'Sick leave taken (total)'} = 'Erkrankt (Summe)';
    $Lang->{'TimeAccounting'} = 'Zeiterfassung';
    $Lang->{'Time accounting.'} = 'Zeiterfassung.';
    $Lang->{'Time reporting monthly overview'} = 'Monatsübersicht Zeiterfassung';
    $Lang->{'Edit time record'} = 'Zeiterfassung bearbeiten';
    $Lang->{'Edit time accounting settings'} = 'Zeiterfassungseinstellungen bearbeiten';
    $Lang->{'User reports'} = 'Nutzerberichte';
    $Lang->{'User\'s project overview'} = 'Nutzerberichte';
    $Lang->{'Project report'} = 'Projektbericht';
    $Lang->{'Project reports'} = 'Projektberichte';
    $Lang->{'Time reporting'} = 'Zeitberichte';
    $Lang->{'LeaveDay Remaining'} = 'Verbleibende Urlaubstage';
    $Lang->{'Monthly total'} = 'pro Monat';
    $Lang->{'View time record'} = 'Zeitrekord ansicht';
    $Lang->{'View of'} = 'Ansicht von';
    $Lang->{'Monthly'} = 'pro Monat';
    $Lang->{'Hours'} = 'Stunden';
    $Lang->{'Date navigation'} = 'Auswahl Datum';
    $Lang->{'Month navigation'} = 'Auswahl Datum';
    $Lang->{'Days without entries'} = 'nicht ausgefüllte Tage';
    $Lang->{'Project'} = 'Projekt';
    $Lang->{'Projects'} = 'Projekte';
    $Lang->{'Grand total'} = 'Summe';
    $Lang->{'Lifetime'} = 'Summe';
    $Lang->{'Lifetime total'} = 'Summe';
    $Lang->{'Reporting'} = 'Berichtswesen';
    $Lang->{'Task settings'} = 'Tätigkeitseinstellungen';
    $Lang->{'User settings'} = 'Nutzereinstellungen';
    $Lang->{'Show Overtime'} = 'Überstunden anzeigen';
    $Lang->{'Allow project creation'} = 'Projekt erstellen';
    $Lang->{'Add time period'} = 'Neue Nutzereinstellung';
    $Lang->{'Remark'} = 'Anmerkung';
    $Lang->{'Start'} = 'Beginn';
    $Lang->{'End'} = 'Ende';
    $Lang->{'Period begin'} = 'Datum Beginn';
    $Lang->{'Period end'} = 'Datum Ende';
    $Lang->{'Period'} = 'Dauer';
    $Lang->{'Days of vacation'} = 'Urlaubstage';
    $Lang->{'On vacation'} = 'im Urlaub';
    $Lang->{'Sick day'} = 'Erkrankt';
    $Lang->{'Sick leave (Days)'} = 'Erkrankt (in Tagen)';
    $Lang->{'Sick leave'} = 'Erkrankt';
    $Lang->{'On sick leave'} = 'Erkrankt';
    $Lang->{'Task'} = 'Tätigkeit';
    $Lang->{'Authorized overtime'} = 'autorisierte Überstunden';
    $Lang->{'On overtime leave'} = 'Überstunden';
    $Lang->{'Overtime leave'} = 'Überstunden';
    $Lang->{'Total'} = 'Summe';
    $Lang->{'Overview of '} = 'Übersicht - ';
    $Lang->{'TimeAccounting of'} = 'Zeiterfassung vom';
    $Lang->{'Successful insert!'} = 'Erfolgreich eingefügt!';
    $Lang->{'More input fields'} = 'Weitere Eingabefelder';
    $Lang->{'Do you really want to delete this Object'} = 'Wollen Sie diesen Eintrag wirklich löschen';
    $Lang->{'Can\'t insert Working Units!'} = 'Kann die Arbeitsstunden nicht einfügen!';
    $Lang->{'Can\'t save settings, because of missing task!'} = 'Nicht speicherbar - Tätigkeit fehlt!';
    $Lang->{'Can\'t save settings, because of missing project!'} = 'Nicht speicherbar - Projektangabe fehlt!';
    $Lang->{'Can\'t save settings, because the Period is bigger than the interval between Starttime and Endtime!'} = 'Nicht speicherbar - Dauer ist größer als der Zeitraum zwischen Beginn und Ende!';
    $Lang->{'Can\'t save settings, because Starttime is older than Endtime!'} = 'Nicht speicherbar - Beginn liegt nach Ende!';
    $Lang->{'Can\'t save settings, because of missing period!'} = 'Nicht speicherbar - Dauer (ergibt sich aus Start- und Endzeit) ist nicht angegeben!';
    $Lang->{'Can\'t save settings, because Period is not given!'} = 'Nicht speicherbar - Dauer (ergibt sich aus Start- und Endzeit) ist nicht angegeben!';
    $Lang->{'Are you sure, that you worked while you were on sick leave?'} = 'Sie waren krank und haben gearbeitet? Wir brauchen mehr solche Mitarbeiter.';
    $Lang->{'Are you sure, that you worked while you were on vacation?'} = 'Sie hatten Urlaub und haben gearbeitet? Wir brauchen mehr solche Mitarbeiter.';
    $Lang->{'Are you sure, that you worked while you were on overtime leave?'} = 'Haben Sie während der Überstunden auch gearbeitet?';
    $Lang->{'Can\'t save settings, because a day has only 24 hours!'} = 'Ein Tag hat nur 24 Stunden!';
    $Lang->{'Can\'t delete Working Units!'} = 'Kann Arbeitsstunden nicht löschen!';
    $Lang->{'Please insert your working hours!'} = 'Bitte tragen Sie Ihre Arbeitszeiten ein!';
    $Lang->{'You have to insert a start and an end time or a period'} = 'Sie müssen Beginn- und Endezeit oder die Dauer angeben.';
    $Lang->{'You can only select one checkbox element!'} = 'Sie können nur eine Checkbox markieren!';
    $Lang->{'Edit time accounting project settings'} = 'Zeiterfassung: Bearbeitung der Projektkonfiguration';
    $Lang->{'Project settings'} = 'Projektkonfiguration';
    $Lang->{'If you select "Miscellaneous (misc)" the task, please explain this in the remarks field'} = 'Wenn Sie als Tätigkeit Sonstiges auswählen, geben Sie bitte eine Beschreibung um Feld Anmerkung an.';
    $Lang->{'Please add a remark with more than 8 characters!'} = 'Bitte geben Sie eine Anmerkung ein die länger als 8 Zeichen ist!';
    $Lang->{'Mon'} = 'Mo';
    $Lang->{'Tue'} = 'Di';
    $Lang->{'Wed'} = 'Mi';
    $Lang->{'Thu'} = 'Do';
    $Lang->{'Fri'} = 'Fr';
    $Lang->{'Sat'} = 'Sa';
    $Lang->{'Sun'} = 'So';
    $Lang->{'January'} = 'Januar';
    $Lang->{'February'} = 'Februar';
    $Lang->{'March'} = 'März';
    $Lang->{'April'} = 'April';
    $Lang->{'May'} = 'Mai';
    $Lang->{'June'} = 'Juni';
    $Lang->{'July'} = 'Juli';
    $Lang->{'August'} = 'August';
    $Lang->{'September'} = 'September';
    $Lang->{'October'} = 'Oktober';
    $Lang->{'November'} = 'November';
    $Lang->{'December'} = 'Dezember';
    $Lang->{'Frontend module registration for the agent interface.'} = '';
    $Lang->{'Overview'} = '';
    $Lang->{'Project time reporting'} = '';
    $Lang->{'Default name for new projects.'} = 'Initialer Projektname beim Erstellen eines neuen Projekts in der Zeiterfassung.';
    $Lang->{'Default status for new projects.'} = 'Anfangsstatus eines neuen Projekts.';
    $Lang->{'Default name for new actions.'} = 'Initialer Name einer neuen Tätigkeit in der Zeiterfassung.';
    $Lang->{'Default status for new actions.'} = 'Anfangsstatus einer neuen Tätigkeit.';
    $Lang->{'Default setting for the standard weekly hours.'} = 'Standard Wochenarbeitszeit.';
    $Lang->{'Default setting for leave days.'} = 'Standard Urlaubstage.';
    $Lang->{'Default setting for overtime.'} = 'Eventuell vorhandener Überstundenübertrag.';
    $Lang->{'Default setting for date start.'} = 'Startdatum für die Eingaben.';
    $Lang->{'Default setting for date end.'} = 'Enddatum für die Eingaben.';
    $Lang->{'Default status for new users.'} = 'Anfangsstatus eines neuen Benutzers.';
    $Lang->{'Maximum number of working days after which the working units have to be inserted'} = 'Legt fest, nach wievielen Werktagen spätestens die Arbeitsstunden eingetragen werden müssen.';
    $Lang->{'Maximum number of working days withouth working units entry after which a warning will be shown.'} = 'Zeigt eine Warnung, wenn zuviele Arbeitstage nicht eingetragen wurden.';
    $Lang->{'This notification module gives a warning if there are too many incomplete working days.'}
        = 'Modul, das den Agent im Notification-Bereich des Agent-Interfaces darüber informiert, wenn schon zu lange keine Stunden mehr eingetragen wurden.';
    $Lang->{'For how many days ago you can insert working units.'} = 'Legt fest, bis wann man in ältere Zeiteinträge bearbeiten kann (z. B. 10 Tage zurückliegend).';
    $Lang->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key =&gt; traveling; Content =&gt; 50).'} =
        'Hier kann man eingeben, ob für eine bestimmte Tätigkeit, die zu verrechnenden Stunden gekürzt werden. Z. B wenn Reisezeiten nur zur Hälfte vergütet werden (Key =&gt; journey; Content =&gt; 50).';
    $Lang->{'Specifies if working hours can be inserted without start and end times.'} = 'Legt fest, ob man Arbeitsstunden auch ohne Anfangs- und Endzeit eingeben kann.';
    $Lang->{'This module forces inserts in TimeAccounting.'} = 'Mit Hilfe dieses Moduls können Einträge in die Zeiterfassung erzwungen werden, in dem beim Einloggen das Portal geblockt wird und nur das Zeiterfassungsfenster erscheint.';
    $Lang->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'}
        = 'Innerhalb dieser Konfigurationsoption kann eine RegExp definiert werden, die festlegt, bei welchen Projekten eine Bemerkung eingetragen werden muss (die RegExp arbeitet mit smx-Parametern).';
    $Lang->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'}
        = 'Reguläre Ausdrücke zur Einschränkung der Projektliste abhängig von Gruppenzuordnung des Benutzers. Schlüssel enthält RegExp für Projekt(e), Inhalt enthält kommaseparierte Liste von Gruppen.';
    $Lang->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'}
        = 'Reguläre Ausdrücke zur Einschränkung der Tätigkeitenliste abhängig vom gewählten Projekt. Schlüssel enthält RegExp für Projekt, Inhalt enthält RegExp für Tätigkeit(en).';

    return 1;
}

1;
