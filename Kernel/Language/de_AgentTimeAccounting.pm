# --
# Kernel/Language/de_AgentTimeAccounting.pm - the de language for AgentTimeAccounting
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: de_AgentTimeAccounting.pm,v 1.42 2009-01-21 11:09:27 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::de_AgentTimeAccounting;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    $Self->{Translation} = {
        %{ $Self->{Translation} },

        # Template: AgentTimeAccounting
        'Setting'          => 'Konfiguration',
        'Project settings' => 'Projektkonfigurationen',

        'Next day'                                 => 'N�chster Tag',
        'One day back'                             => 'Einen Tag zur�ck',
        'Date'                                     => 'Datum',
        'Comments'                                 => 'Kommentare',
        'until'                                    => 'bis',
        'Total hours worked'                       => 'Arbeitsstunden',
        'Working Hours'                            => 'Arbeitsstunden',
        'Hours per week'                           => 'Wochenstunden',
        'this month'                               => 'dieser Monat',
        'Overtime (Hours)'                         => '�berstunden (in Stunden)',
        'Overtime (total)'                         => '�berstunden (dieser Monat)',
        'Overtime (this month)'                    => '�berstunden (Summe)',
        'Remaining overtime leave'                 => '�berstunden (verbleibend)',
        'Vacation'                                 => 'Urlaub',
        'Vacation (Days)'                          => 'Urlaub (in Tagen)',
        'Vacation taken (this month)'              => 'Urlaubstage (dieser Monat)',
        'Vacation taken (total)'                   => 'Urlaubstage (Summe)',
        'Remaining vacation'                       => 'Urlaubstage (verbleibend)',
        'Sick leave taken (this month)'            => 'Erkrankt (dieser Monat)',
        'Sick leave taken (total)'                 => 'Erkrankt (Summe)',
        'TimeAccounting'                           => 'Zeiterfassung',
        'Time reporting monthly overview'          => 'Monats�bersicht Zeiterfassung',
        'Edit time record'                         => 'Zeiterfassung bearbeiten',
        'Edit time accounting settings'            => 'Zeiterfassungseinstellungen bearbeiten',
        'User reports'                             => 'Nutzerberichte',
        'User\'s project overview'                 => 'Nutzerberichte',
        'Project report'                           => 'Projektbericht',
        'Project reports'                          => 'Projektberichte',
        'Time reporting'                           => 'Zeitberichte',
        'LeaveDay Remaining'                       => 'Verbleibende Urlaubstage',
        'Monthly total'                            => 'pro Monat',
        'View time record'                         => 'Zeitrekord ansicht',
        'View of '                                 => 'Ansicht von',
        'Monthly'                                  => 'pro Monat',
        'Hours'                                    => 'Stunden',
        'Date navigation'                          => 'Auswahl Datum',
        'Month navigation'                         => 'Auswahl Datum',
        'Days without entries'                     => 'nicht ausgef�llte Tage',
        'Project'                                  => 'Projekt',
        'Projects'                                 => 'Projekte',
        'Grand total'                              => 'Summe',
        'Lifetime'                                 => 'Summe',
        'Lifetime total'                           => 'Summe',
        'Reporting'                                => 'Berichtswesen',
        'Task settings'                            => 'T�tigkeitseinstellungen',
        'User settings'                            => 'Nutzereinstellungen',
        'Show Overtime'                            => '�berstunden anzeigen',
        'Allow project creation'                   => 'Projekt erstellen',
        'Add time period'                          => 'Neue Nutzereinstellung',
        'Remark'                                   => 'Anmerkung',
        'Start'                                    => 'Beginn',
        'End'                                      => 'Ende',
        'Period begin'                             => 'Datum Beginn',
        'Period end'                               => 'Datum Ende',
        'Period'                                   => 'Dauer',
        'Days of vacation'                         => 'Urlaubstage',
        'On vacation'                              => 'im Urlaub',
        'Sick day'                                 => 'Erkrankt',
        'Sick leave (Days)'                        => 'Erkrankt (in Tagen)',
        'Sick leave'                               => 'Erkrankt',
        'On sick leave'                            => 'Erkrankt',
        'Task'                                     => 'T�tigkeit',
        'Authorized overtime'                      => 'autorisierte �berstunden',
        'On overtime leave'                        => '�berstunden',
        'Overtime leave'                           => '�berstunden',
        'Total'                                    => 'Summe',
        'Overview of '                             => '�bersicht - ',
        'TimeAccounting of'                        => 'Zeiterfassung vom',
        'Successful insert!'                       => 'Erfolgreich eingef�gt!',
        'Do you really want to delete this Object' => 'Wollen Sie diesen Eintrag wirklich l�schen',
        'Can\'t insert Working Units!'             => 'Kann die Arbeitsstunden nicht einf�gen!',
        'Can\'t save settings, because of missing task!' =>
            'Nicht speicherbar - T�tigkeit fehlt!',
        'Can\'t save settings, because of missing project!' =>
            'Nicht speicherbar - Projektangabe fehlt!',
        'Can\'t save settings, because the Period is bigger than the interval between Starttime and Endtime!'
            => 'Nicht speicherbar - Dauer ist gr��er als der Zeitraum zwischen Beginn und Ende!',
        'Can\'t save settings, because Starttime is older than Endtime!' =>
            'Nicht speicherbar - Beginn liegt nach Ende!',
        'Can\'t save settings, because of missing period!' =>
            'Nicht speicherbar - Dauer (ergibt sich aus Start- und Endzeit) ist nicht angegeben!',
        'Can\'t save settings, because Period is not given given!' =>
            'Nicht speicherbar - Dauer (ergibt sich aus Start- und Endzeit) ist nicht angegeben!',
        'Are you sure, that you worked while you were on sick leave?' =>
            'Sie waren krank und haben gearbeitet? Wir brauchen mehr solche Mitarbeiter.',
        'Are you sure, that you worked while you were on vacation?' =>
            'Sie hatten Urlaub und haben gearbeitet? Wir brauchen mehr solche Mitarbeiter.',
        'Are you sure, that you worked while you were on overtime leave?' =>
            'Haben Sie w�hrend der �berstunden auch gearbeitet?',
        'Can\'t save settings, because a day has only 24 hours!' => 'Ein Tag hat nur 24 Stunden!',
        'Can\'t delete Working Units!'      => 'Kann Arbeitsstunden nicht l�schen!',
        'Please insert your working hours!' => 'Bitte tragen Sie Ihre Arbeitszeiten ein!',
        'You have to insert a start and an end time or a period' =>
            'Sie m�ssen Beginn- und Endezeit oder die Dauer angeben.',
        'You can only select one checkbox element!' => 'Sie k�nnen nur eine Checkbox markieren!',
        'Edit time accounting project settings' =>
            'Zeiterfassung: Bearbeitung der Projektkonfiguration',
        'Project settings' => 'Projektkonfiguration',
        'If you select "Miscellaneous (misc)" the task, please explain this in the remarks field' =>
            'Wenn Sie als T�tigkeit Sonstiges ausw�hlen, geben Sie bitte eine Beschreibung um Feld Anmerkung an.',
        'Please add a remark with more than 8 characters!' =>
            'Bitte geben Sie eine Anmerkung ein die l�nger als 8 Zeichen ist!',

# FIXME actually the following should be included in file de.pm, however they're not so I put'em here...
        'Mon'      => 'Mo',
        'Tue'      => 'Di',
        'Wed'      => 'Mi',
        'Thu'      => 'Do',
        'Fri'      => 'Fr',
        'Sat'      => 'Sa',
        'Sun'      => 'So',
        'January'  => 'Januar',
        'February' => 'Februar',
        'March'    => 'M�rz',
        'May'      => 'Mai',
        'June'     => 'Juni',
        'July'     => 'Juli',
        'October'  => 'Oktober',
        'December' => 'Dezember',
    };
    return 1;
}

1;
