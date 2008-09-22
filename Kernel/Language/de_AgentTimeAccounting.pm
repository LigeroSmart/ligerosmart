# --
# Kernel/Language/de_AgentTimeAccounting.pm - the de language for AgentTimeAccounting
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: de_AgentTimeAccounting.pm,v 1.18 2008-09-22 19:40:10 shb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::de_AgentTimeAccounting;

use strict;
use warnings;

sub Data {
    my ($Self) = @_;

    $Self->{Translation} = {
        %{ $Self->{Translation} },

        # Template: AgentTimeAccounting
        'Setting'        => 'Konfiguration',
        'Project settings' => 'Projektkonfigurationen',

        #new translations...
        'Date'                                     => 'Datum',
        'Comments'                                 => 'Kommentare',
        'until'                                    => 'bis',
        'WorkingHours'                             => 'Arbeitsstunden',
        'Working Hours'                            => 'Arbeitsstunden',
        'Hours per week'                           => 'Wochenstunden',
        'this month'                               => 'dieser Monat',
        'Overtime total'                           => 'Summe Überstunden',
        'Leave Days'                               => 'Tage abwesend',
        'LeaveDay this month'                      => 'Urlaubstage (dieser Monat)',
        'LeaveDayTotal'                            => 'Urlaubstage (Summe)',
        'LeaveDay remaining'                       => 'Urlaubstage (verbleibend)',
        'Diseased this month'                      => 'Erkrankt (dieser Monat)',
        'DiseasedTotal'                            => 'Erkrankt (Summe)',
        'TimeAccounting'                           => 'Zeiterfassung',
        'Time Accounting Overview per Month'       => 'Monatsübersicht Zeiterfassung',
        'Edit Time Accounting'                     => 'Zeiterfassung bearbeiten',
        'Edit time accounting preferences'         => 'Zeiterfassungseinstellungen bearbeiten',
        'User Reporting'                           => 'Nutzerberichte',
        'Project Reporting'                        => 'Projektberichte',
        'Time Preporting'                          => 'Zeitberichte',
        'LeaveDay Remaining'                       => 'Verbleibende Urlaubstage',
        'per Month'                                => 'pro Monat',
        'Hours'                                    => 'Stunden',
        'Time selection'                           => 'Auswahl Datum',
        'Incomplete Days'                          => 'nicht ausgefüllte Tage',
        'Project'                                  => 'Projekt',
        'Projects'                                 => 'Projekte',
        'Total'                                    => 'Summe',
        'Reporting'                                => 'Berichtswesen',
        'Task settings'                            => 'Aktionseinstellungen',
        'User settings'                            => 'Nutzereinstellungen',
        'Show Overtime'                            => 'Überstunden anzeigen',
        'Allow project creation'                   => 'Projekt erstellen',
        'Add time period'                          => 'Neue Nutzereinstellung',
        'Remark'                                   => 'Anmerkung',
        'Starttime'                                => 'Beginn',
        'Endtime'                                  => 'Ende',
        'Period begin'                             => 'Datum Beginn',
        'Period end'                               => 'Datum Ende',
        'Period'                                   => 'Dauer',
        'Days of vacation'                         => 'Urlaubstage',
        'On vacation'                              => 'im Urlaub',
        'LeaveDay'                                 => 'Urlaub',
        'Diseased'                                 => 'Erkrankt',
        'Task'                                     => 'Tätigkeit',
        'Overtime'                                 => 'Überstunden',
        'Total'                                    => 'Summe',
        'Overview of '                             => 'Übersicht - ',
        'TimeAccounting of'                        => 'Zeiterfassung vom',
        'Successful insert!'                       => 'Erfolgreich eingefügt!',
        'Do you really want to delete this Object' => 'Wollen Sie diesen Eintrag wirklich löschen',
        'Can\'t insert Working Units!'             => 'Kann Arbeitsstunden nicht einfügen!',
        'Can\'t save settings, because of missing Action!' => 'Nicht speicherbar - Aktion fehlt!',
        'Can\'t save settings, because of missing Project!' =>
            'Nicht speicherbar - Projektangabe fehlt!',
        'Can\'t save settings, because the Period is bigger than the interval between Starttime and Endtime!'
            => 'Nicht speicherbar - Dauer ist größer als der Zeitraum zwischen Beginn und Ende!',
        'Can\'t save settings, because Starttime is older than Endtime!' =>
            'Nicht speicherbar - Beginn liegt nach Ende!',
        'Can\'t save settings, because of missing period!' =>
            'Nicht speicherbar - Dauer (ergibt sich aus Start- und Endzeit) ist nicht angegeben!',
        'Can\'t save settings, because Period is not given given!' =>
            'Nicht speicherbar - Dauer (ergibt sich aus Start- und Endzeit) ist nicht angegeben!',
        'Are you sure, that you worked while you are Diseased?' =>
            'Sie waren krank und haben gearbeitet? Wir brauchen mehr solche Mitarbeiter.',
        'Are you sure, that you worked while you have a leave day?' =>
            'Sie hatten Urlaub und haben gearbeitet? Wir brauchen mehr solche Mitarbeiter.',
        'Are you sure, that you worked while you have overtime?' =>
            'Haben Sie während der Überstunden auch gearbeitet?',
        'Can\'t save settings, because a day has only 24 hours!' => 'Ein Tag hat nur 24 Stunden!',
        'Can\'t delete Working Units!'      => 'Kann Arbeitsstunden nicht löschen!',
        'Please insert your working hours!' => 'Bitte tragen Sie Ihre Arbeitszeiten ein!',
        'You have to insert Start- and Endtime or a Period' =>
            'Sie müssen Beginn- und Endezeit angeben.',
        'You can only select one checkbox element!' => 'Sie können nur eine Checkbox markieren!',
        'Edit time accounting project preferences' =>
            'Zeiterfassung: Bearbeitung der Projektkonfiguration',
        'Project Setting' => 'Projektkonfiguration',
        ''                => '',
        'If you use action misc, please give an explanation in the field remark' =>
            'Wenn Sie Aktion Sonstiges auswählen, geben Sie eine Beschreibung um Feld Anmerkung an.',

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
        'March'    => 'März',
        'May'      => 'Mai',
        'June'     => 'Juni',
        'July'     => 'Juli',
        'October'  => 'Oktober',
        'December' => 'Dezember',
    };
    return 1;
}

1;
