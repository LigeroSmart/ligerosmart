# --
# Kernel/Language/de_ITSMService.pm - the german translation of ITSMService
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: de_ITSMService.pm,v 1.1 2008-06-21 12:45:18 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::de_ITSMService;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Current State'}                  = 'Aktueller Status';
    $Lang->{'Service-Area'}                   = 'Service-Bereich';
    $Lang->{'Minimum Time Between Incidents'} = 'Mindestzeit zwischen Incidents';
    $Lang->{'Associated SLAs'}                = 'Zugehörige SLAs';
    $Lang->{'Back End'}                       = 'Backend';
    $Lang->{'Demonstration'}                  = 'Demonstration';
    $Lang->{'End User Service'}               = 'Anwender-Service';
    $Lang->{'Front End'}                      = 'Frontend';
    $Lang->{'IT Management'}                  = 'IT Management';
    $Lang->{'IT Operational'}                 = 'IT Betrieb';
    $Lang->{'Other'}                          = 'Sonstiges';
    $Lang->{'Project'}                        = 'Projekt';
    $Lang->{'Reporting'}                      = 'Reporting';
    $Lang->{'Training'}                       = 'Training';
    $Lang->{'Underpinning Contract'}          = 'Underpinning Contract';
    $Lang->{'Availability'}                   = 'Verfügbarkeit';
    $Lang->{'Errors'}                         = 'Fehler';
    $Lang->{'Other'}                          = 'Sonstiges';
    $Lang->{'Recovery Time'}                  = 'Wiederherstellungszeit';
    $Lang->{'Resolution Rate'}                = 'Lösungszeit';
    $Lang->{'Response Time'}                  = 'Reaktionszeit';
    $Lang->{'Transactions'}                   = 'Transaktionen';

    return 1;
}

1;
