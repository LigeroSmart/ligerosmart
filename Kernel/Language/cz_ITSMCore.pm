# --
# Kernel/Language/cz_ITSMCore.pm - the czech translation of ITSMCore
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# Copyright (C) 2007-2008 Milen Koutev
# --
# $Id: cz_ITSMCore.pm,v 1.13 2009-07-20 12:21:17 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cz_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'Kritiènost';
    $Lang->{'Impact'}                              = 'Vliv';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Kritiènost<->Vliv<->Priorita';
    $Lang->{'allocate'}                            = 'Urèen';
    $Lang->{'Relevant to'}                         = 'Relevantní';
    $Lang->{'Includes'}                            = 'zahrnuté';
    $Lang->{'Part of'}                             = 'èást';
    $Lang->{'Depends on'}                          = 'Zale¾í';
    $Lang->{'Required for'}                        = ' Po¾adovaný';
    $Lang->{'Connected to'}                        = 'Spojen s';
    $Lang->{'Alternative to'}                      = 'Alternativní';
    $Lang->{'Incident State'}                      = '';
    $Lang->{'Current Incident State'}              = '';
    $Lang->{'Current State'}                       = '';
    $Lang->{'Service-Area'}                        = '';
    $Lang->{'Minimum Time Between Incidents'}      = 'Minimální èas mezi incidenty';
    $Lang->{'Service Overview'}                    = '';
    $Lang->{'SLA Overview'}                        = '';
    $Lang->{'Associated Services'}                 = '';
    $Lang->{'Associated SLAs'}                     = 'Pøidru¾ené SLA smliuvy';
    $Lang->{'Back End'}                            = 'Základní schéma/BackEnd';
    $Lang->{'Demonstration'}                       = 'Demonstrace';
    $Lang->{'End User Service'}                    = 'Slu¾by koncových u¾ivatelù';
    $Lang->{'Front End'}                           = 'Zákaznický systém/FrontEnd';
    $Lang->{'IT Management'}                       = 'Øízení IT';
    $Lang->{'IT Operational'}                      = 'IT Operace';
    $Lang->{'Other'}                               = 'Dal¹í';
    $Lang->{'Project'}                             = 'Projekt';
    $Lang->{'Reporting'}                           = 'Zpravodajství';
    $Lang->{'Training'}                            = '©kolení';
    $Lang->{'Underpinning Contract'}               = 'Základní smlouva';
    $Lang->{'Availability'}                        = 'Dostupnost';
    $Lang->{'Errors'}                              = 'Chyby';
    $Lang->{'Other'}                               = 'Dal¹í';
    $Lang->{'Recovery Time'}                       = 'Doba obnovení';
    $Lang->{'Resolution Rate'}                     = 'Doba øe¹ení';
    $Lang->{'Response Time'}                       = 'Doba odpovìdi';
    $Lang->{'Transactions'}                        = 'Obchody/transakce';

    return 1;
}

1;
