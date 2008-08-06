# --
# Kernel/Language/de_ITSMCore.pm - the german translation of ITSMCore
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: de_ITSMCore.pm,v 1.14 2008-08-06 07:16:58 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::de_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'Kritikalität';
    $Lang->{'Impact'}                              = 'Auswirkung';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Kritikalität <-> Auswirkung <-> Priorität';
    $Lang->{'allocate'}                            = 'zuordnen';
    $Lang->{'Relevant to'}                         = 'Relevant für';
    $Lang->{'Includes'}                            = 'Beinhaltet';
    $Lang->{'Part of'}                             = 'Teil von';
    $Lang->{'Depends on'}                          = 'Hängt ab von';
    $Lang->{'Required for'}                        = 'Benötigt für';
    $Lang->{'Connected to'}                        = 'Verbunden mit';
    $Lang->{'Alternative to'}                      = 'Alternativ zu';
    $Lang->{'Incident State'}                      = 'Vorfallsstatus';
    $Lang->{'Current Incident State'}              = 'Aktueller Vorfallsstatus';
    $Lang->{'Current State'}                       = 'Aktueller Status';
    $Lang->{'Service-Area'}                        = 'Service-Bereich';
    $Lang->{'Minimum Time Between Incidents'}      = 'Mindestzeit zwischen Incidents';
    $Lang->{'Service Overview'}                    = 'Service Übersicht';
    $Lang->{'SLA Overview'}                        = 'SLA Übersicht';
    $Lang->{'Associated Services'}                 = 'Zugehörige Services';
    $Lang->{'Associated SLAs'}                     = 'Zugehörige SLAs';
    $Lang->{'Back End'}                            = 'Backend';
    $Lang->{'Demonstration'}                       = 'Demonstration';
    $Lang->{'End User Service'}                    = 'Anwender-Service';
    $Lang->{'Front End'}                           = 'Frontend';
    $Lang->{'IT Management'}                       = 'IT Management';
    $Lang->{'IT Operational'}                      = 'IT Betrieb';
    $Lang->{'Other'}                               = 'Sonstiges';
    $Lang->{'Project'}                             = 'Projekt';
    $Lang->{'Reporting'}                           = 'Reporting';
    $Lang->{'Training'}                            = 'Training';
    $Lang->{'Underpinning Contract'}               = 'Underpinning Contract';
    $Lang->{'Availability'}                        = 'Verfügbarkeit';
    $Lang->{'Errors'}                              = 'Fehler';
    $Lang->{'Other'}                               = 'Sonstiges';
    $Lang->{'Recovery Time'}                       = 'Wiederherstellungszeit';
    $Lang->{'Resolution Rate'}                     = 'Lösungszeit';
    $Lang->{'Response Time'}                       = 'Reaktionszeit';
    $Lang->{'Transactions'}                        = 'Transaktionen';

    return 1;
}

1;
