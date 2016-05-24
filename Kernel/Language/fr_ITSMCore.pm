# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = 'Alternative à';
    $Self->{Translation}->{'Availability'} = 'Disponibilité';
    $Self->{Translation}->{'Back End'} = 'Backend';
    $Self->{Translation}->{'Connected to'} = 'Lié à';
    $Self->{Translation}->{'Current State'} = 'Etat actuel';
    $Self->{Translation}->{'Demonstration'} = 'Démonstration';
    $Self->{Translation}->{'Depends on'} = 'Dépend de';
    $Self->{Translation}->{'End User Service'} = 'Service utilisateur';
    $Self->{Translation}->{'Errors'} = 'Erreurs';
    $Self->{Translation}->{'Front End'} = 'Frontend';
    $Self->{Translation}->{'IT Management'} = 'Gestion IT';
    $Self->{Translation}->{'IT Operational'} = 'Opérations IT';
    $Self->{Translation}->{'Impact'} = 'Impact';
    $Self->{Translation}->{'Incident State'} = 'Etat d\'incident';
    $Self->{Translation}->{'Includes'} = 'Inclus';
    $Self->{Translation}->{'Other'} = 'Autre';
    $Self->{Translation}->{'Part of'} = 'Part de';
    $Self->{Translation}->{'Project'} = 'Projet';
    $Self->{Translation}->{'Recovery Time'} = 'Temps de réparation';
    $Self->{Translation}->{'Relevant to'} = 'Correspond à';
    $Self->{Translation}->{'Reporting'} = 'Rapport';
    $Self->{Translation}->{'Required for'} = 'Requis pour';
    $Self->{Translation}->{'Resolution Rate'} = 'Taux de résolution';
    $Self->{Translation}->{'Response Time'} = 'Temps de réponse';
    $Self->{Translation}->{'SLA Overview'} = 'Aperçu des SLA';
    $Self->{Translation}->{'Service Overview'} = 'Aperçu des services';
    $Self->{Translation}->{'Service-Area'} = 'Zone de service';
    $Self->{Translation}->{'Training'} = 'Formation';
    $Self->{Translation}->{'Transactions'} = 'Transactions';
    $Self->{Translation}->{'Underpinning Contract'} = 'Contrat externe';
    $Self->{Translation}->{'allocation'} = 'alloue';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Criticité <-> Impact <-> Priorité';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        'Gestion de la priorité par combinaison Criticité <-> Impact';
    $Self->{Translation}->{'Priority allocation'} = 'Attribution de priorité';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Temps minimal entre les incidents';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Criticité';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Information SLA';
    $Self->{Translation}->{'Last changed'} = 'Dernière modification';
    $Self->{Translation}->{'Last changed by'} = 'Dernière modification par';
    $Self->{Translation}->{'Associated Services'} = 'Services associés';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Information service';
    $Self->{Translation}->{'Current incident state'} = 'Etat actuel de l\'incident';
    $Self->{Translation}->{'Associated SLAs'} = 'SLAs associées';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'Current Incident State'} = 'Etat actuel d\'incident';

}

1;
