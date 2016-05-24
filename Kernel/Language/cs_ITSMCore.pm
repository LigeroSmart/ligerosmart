# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cs_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = 'Alternativní k';
    $Self->{Translation}->{'Availability'} = 'Dostupnost';
    $Self->{Translation}->{'Back End'} = 'Základní rozhraní/Backend';
    $Self->{Translation}->{'Connected to'} = 'Spojen s';
    $Self->{Translation}->{'Current State'} = 'Současný Stav';
    $Self->{Translation}->{'Demonstration'} = 'Ukázka';
    $Self->{Translation}->{'Depends on'} = 'Závisí na';
    $Self->{Translation}->{'End User Service'} = 'Služby koncovým uživatelům';
    $Self->{Translation}->{'Errors'} = 'Chyby';
    $Self->{Translation}->{'Front End'} = 'Zákaznické rozhraní/Frontend';
    $Self->{Translation}->{'IT Management'} = 'Řízení IT';
    $Self->{Translation}->{'IT Operational'} = 'IT Operace';
    $Self->{Translation}->{'Impact'} = 'Vliv';
    $Self->{Translation}->{'Incident State'} = 'Stav Incidentu';
    $Self->{Translation}->{'Includes'} = 'Zahrnuje';
    $Self->{Translation}->{'Other'} = 'Další';
    $Self->{Translation}->{'Part of'} = 'Část z';
    $Self->{Translation}->{'Project'} = 'Projekt';
    $Self->{Translation}->{'Recovery Time'} = 'Čas obnovy';
    $Self->{Translation}->{'Relevant to'} = 'Relevantní k';
    $Self->{Translation}->{'Reporting'} = 'Reporting';
    $Self->{Translation}->{'Required for'} = 'Požadovaný pro';
    $Self->{Translation}->{'Resolution Rate'} = 'Čas řešeni';
    $Self->{Translation}->{'Response Time'} = 'Čas odpovědi';
    $Self->{Translation}->{'SLA Overview'} = 'SLA Přehled';
    $Self->{Translation}->{'Service Overview'} = 'Přehled Služby';
    $Self->{Translation}->{'Service-Area'} = 'Prostor Údržby';
    $Self->{Translation}->{'Training'} = 'Školení';
    $Self->{Translation}->{'Transactions'} = 'Transakce';
    $Self->{Translation}->{'Underpinning Contract'} = 'Základní smlouva';
    $Self->{Translation}->{'allocation'} = 'přidělit';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Kritičnost<->Vliv<->Priorita';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        '';
    $Self->{Translation}->{'Priority allocation'} = 'Alokace priorit';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Minimální čas mezi incidenty';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Kritičnost';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'SLA Informace';
    $Self->{Translation}->{'Last changed'} = 'Naposledy změněn';
    $Self->{Translation}->{'Last changed by'} = 'Naposledy změnil';
    $Self->{Translation}->{'Associated Services'} = 'Přiřazené Služby';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = '';
    $Self->{Translation}->{'Current incident state'} = '';
    $Self->{Translation}->{'Associated SLAs'} = 'Přiřazené SLA smlouvy';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'Current Incident State'} = 'Současný Stav Incidentu';

}

1;
