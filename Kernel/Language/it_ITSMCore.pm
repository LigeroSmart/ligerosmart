# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::it_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = 'Alternativo a';
    $Self->{Translation}->{'Availability'} = 'Disponibilità';
    $Self->{Translation}->{'Back End'} = 'Motore';
    $Self->{Translation}->{'Connected to'} = 'Connesso a';
    $Self->{Translation}->{'Current State'} = 'Stato attuale';
    $Self->{Translation}->{'Demonstration'} = 'Dimostrazione';
    $Self->{Translation}->{'Depends on'} = 'Depende da';
    $Self->{Translation}->{'End User Service'} = 'Servizio utente finale';
    $Self->{Translation}->{'Errors'} = 'Errori';
    $Self->{Translation}->{'Front End'} = 'Interfaccia';
    $Self->{Translation}->{'IT Management'} = 'IT Management';
    $Self->{Translation}->{'IT Operational'} = 'IT Operational';
    $Self->{Translation}->{'Impact'} = 'Impatto';
    $Self->{Translation}->{'Incident State'} = 'Stato dell\'incidente';
    $Self->{Translation}->{'Includes'} = 'Include';
    $Self->{Translation}->{'Other'} = 'Altro';
    $Self->{Translation}->{'Part of'} = 'Parte di';
    $Self->{Translation}->{'Project'} = 'Progetto';
    $Self->{Translation}->{'Recovery Time'} = 'Tempo di ripristino';
    $Self->{Translation}->{'Relevant to'} = 'Rilevante per';
    $Self->{Translation}->{'Reporting'} = 'Rapporti';
    $Self->{Translation}->{'Required for'} = 'Richiesto per';
    $Self->{Translation}->{'Resolution Rate'} = 'Velocità di risoluzione';
    $Self->{Translation}->{'Response Time'} = 'Tempo di risposta';
    $Self->{Translation}->{'SLA Overview'} = 'Descrizione SLA';
    $Self->{Translation}->{'Service Overview'} = 'Descrizione del servizio';
    $Self->{Translation}->{'Service-Area'} = 'Servizio-Area';
    $Self->{Translation}->{'Training'} = 'Formazione';
    $Self->{Translation}->{'Transactions'} = 'Transazioni';
    $Self->{Translation}->{'Underpinning Contract'} = '';
    $Self->{Translation}->{'allocation'} = 'assegnazione';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Urgenza <-> Impatto <-> Priorità';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        'Gestisce il risultato di priorità della combinazione Criticità <-> Impatto.';
    $Self->{Translation}->{'Priority allocation'} = 'Assegnazione prioritaria';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Tempo minimo tra incidenti';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Urgenza';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Informazioni sulle SLA';
    $Self->{Translation}->{'Last changed'} = 'Ultima modifica';
    $Self->{Translation}->{'Last changed by'} = 'Ultima modifica effettuata da';
    $Self->{Translation}->{'Associated Services'} = 'Servizi associati';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Informazioni sul servizio';
    $Self->{Translation}->{'Current incident state'} = 'Stato attuale dell\'incidente';
    $Self->{Translation}->{'Associated SLAs'} = 'SLA associati';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'Current Incident State'} = 'Stato attuale dell\'Incidente';

}

1;
