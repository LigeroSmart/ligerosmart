# --
# Kernel/Language/cz_ITSMCore.pm - the czech translation of ITSMCore
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2007-2008 Milen Koutev
# Copyright (C) 2010 O2BS.com, s r.o. Jakub Hanus
# --
# $Id: cz_ITSMCore.pm,v 1.16 2010-06-01 19:25:22 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cz_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.16 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'Kritiènost';
    $Lang->{'Impact'}                              = 'Vliv';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Kritiènost<->Vliv<->Priorita';
    $Lang->{'Priority allocation'}                 = '';
    $Lang->{'allocation'}                          = 'pøidìlit';
    $Lang->{'Relevant to'}                         = 'Relevantní k';
    $Lang->{'Includes'}                            = 'Zahrnuje';
    $Lang->{'Part of'}                             = 'Èást z';
    $Lang->{'Depends on'}                          = 'Zale¾í na';
    $Lang->{'Required for'}                        = 'Po¾adovaný pro';
    $Lang->{'Connected to'}                        = 'Spojen s';
    $Lang->{'Alternative to'}                      = 'Alternativní k';
    $Lang->{'Incident State'}                      = 'Stav Incidentu';
    $Lang->{'Current Incident State'}              = 'Souèasný Stav Incidentu';
    $Lang->{'Current State'}                       = 'Souèasný Stav';
    $Lang->{'Service-Area'}                        = 'Prostor Údr¾by';
    $Lang->{'Minimum Time Between Incidents'}      = 'Minimální èas mezi incidenty';
    $Lang->{'Service Overview'}                    = 'Pøehled Slu¾by';
    $Lang->{'SLA Overview'}                        = 'SLA Pøehled';
    $Lang->{'Associated Services'}                 = 'Pøiøazené Slu¾by';
    $Lang->{'Associated SLAs'}                     = 'Pøiøazené SLA smlouvy';
    $Lang->{'Back End'}                            = 'Základní rozhraní/BackEnd';
    $Lang->{'Demonstration'}                       = 'Ukázka';
    $Lang->{'End User Service'}                    = 'Slu¾by koncovým u¾ivatelùm';
    $Lang->{'Front End'}                           = 'Zákaznické rozhraní/FrontEnd';
    $Lang->{'IT Management'}                       = 'Øízení IT';
    $Lang->{'IT Operational'}                      = 'IT Operace';
    $Lang->{'Other'}                               = 'Dal¹í';
    $Lang->{'Project'}                             = 'Projekt';
    $Lang->{'Reporting'}                           = 'Reporting';
    $Lang->{'Training'}                            = '©kolení';
    $Lang->{'Underpinning Contract'}               = 'Základní smlouva';
    $Lang->{'Availability'}                        = 'Dostupnost';
    $Lang->{'Errors'}                              = 'Chyby';
    $Lang->{'Other'}                               = 'Dal¹í';
    $Lang->{'Recovery Time'}                       = 'Èas Obnovy';
    $Lang->{'Resolution Rate'}                     = 'Èas Øe¹ení';
    $Lang->{'Response Time'}                       = 'Èas Odpovìdi';
    $Lang->{'Transactions'}                        = 'Transakce';

    return 1;
}

1;
