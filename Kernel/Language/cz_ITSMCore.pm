# --
# Kernel/Language/cz_ITSMCore.pm - the czech translation of ITSMCore
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2007-2008 Milen Koutev
# Copyright (C) 2010 O2BS.com, s r.o. Jakub Hanus
# --
# $Id: cz_ITSMCore.pm,v 1.18 2010-08-12 22:33:56 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cz_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.18 $) [1];

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
    $Lang->{'This setting controls the name of the application as is shown in the web interface as well as the tabs and title bar of your web browser.'} = '';
    $Lang->{'Determines the way the linked objects are displayed in each zoom mask.'} = '';
    $Lang->{'List of online repositories (for example you also can use other installations as repositoriy by using Key="http://example.com/otrs/public.pl?Action=PublicRepository&File=" and Content="Some Name").'} = '';
    $Lang->{'Frontend module registration for the AgentITSMService object in the agent interface.'} = '';
    $Lang->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} = '';
    $Lang->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} = '';
    $Lang->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} = '';
    $Lang->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} = '';
    $Lang->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} = '';
    $Lang->{'Module to show back link in service menu.'} = '';
    $Lang->{'Module to show print link in service menu.'} = '';
    $Lang->{'Module to show link link in service menu.'} = '';
    $Lang->{'Module to show back link in sla menu.'} = '';
    $Lang->{'Module to show print link in sla menu.'} = '';

    return 1;
}

1;
