# --
# Kernel/Language/pl_ITSMCore.pm - the polish translation of ITSMCore
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: pl_ITSMCore.pm,v 1.2 2008-08-13 14:20:12 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::pl_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = '';
    $Lang->{'Impact'}                              = '';
    $Lang->{'Criticality <-> Impact <-> Priority'} = '';
    $Lang->{'allocate'}                            = '';
    $Lang->{'Relevant to'}                         = '';
    $Lang->{'Includes'}                            = 'Zawiera';
    $Lang->{'Part of'}                             = '';
    $Lang->{'Depends on'}                          = 'Zale¿ne od';
    $Lang->{'Required for'}                        = 'Potrzebne do';
    $Lang->{'Connected to'}                        = 'Pod³±czone do';
    $Lang->{'Alternative to'}                      = '';
    $Lang->{'Incident State'}                      = 'Stan zdarzenia';
    $Lang->{'Current Incident State'}              = 'Aktualny stan zdarzenia';
    $Lang->{'Current State'}                       = 'Aktualny stan';
    $Lang->{'Service-Area'}                        = 'Sekcja serwisowa';
    $Lang->{'Minimum Time Between Incidents'}      = 'Minimalny czas miêdzy zdarzeniami';
    $Lang->{'Service Overview'}                    = '';
    $Lang->{'SLA Overview'}                        = '';
    $Lang->{'Associated Services'}                 = 'Po³±czone us³ugi';
    $Lang->{'Associated SLAs'}                     = 'Po³±czone SLA';
    $Lang->{'Back End'}                            = '';
    $Lang->{'Demonstration'}                       = 'Demonstracja';
    $Lang->{'End User Service'}                    = '';
    $Lang->{'Front End'}                           = '';
    $Lang->{'IT Management'}                       = '';
    $Lang->{'IT Operational'}                      = '';
    $Lang->{'Other'}                               = 'Inne';
    $Lang->{'Project'}                             = 'Projekt';
    $Lang->{'Reporting'}                           = 'Raportowanie';
    $Lang->{'Training'}                            = 'Trening';
    $Lang->{'Underpinning Contract'}               = '';
    $Lang->{'Availability'}                        = 'Dostêpno¶æ';
    $Lang->{'Errors'}                              = 'B³êdy';
    $Lang->{'Other'}                               = 'Inne';
    $Lang->{'Recovery Time'}                       = 'Czas odzyskania';
    $Lang->{'Resolution Rate'}                     = 'Czas rozwi±zania';
    $Lang->{'Response Time'}                       = 'Czas odpowiedzi';
    $Lang->{'Transactions'}                        = 'Transakcje';

    return 1;
}

1;
