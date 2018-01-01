# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = 'Urgenza ↔ Impatto ↔ Priorità';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        'Gestisce il risultato di priorità della combinazione Criticità ↔ Impatto.';
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

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = 'Impatto';

    # Perl Module: Kernel/Modules/AgentITSMSLAPrint.pm
    $Self->{Translation}->{'No SLAID is given!'} = '';
    $Self->{Translation}->{'SLAID %s not found in database!'} = '';
    $Self->{Translation}->{'Calendar Default'} = '';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'No ServiceID is given!'} = '';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = '';
    $Self->{Translation}->{'Current Incident State'} = 'Stato attuale dell\'Incidente';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'Stato dell\'incidente';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = 'Operativo';
    $Self->{Translation}->{'Incident'} = 'Incidente';
    $Self->{Translation}->{'End User Service'} = 'Servizio utente finale';
    $Self->{Translation}->{'Front End'} = 'Interfaccia';
    $Self->{Translation}->{'Back End'} = 'Motore';
    $Self->{Translation}->{'IT Management'} = 'IT Management';
    $Self->{Translation}->{'Reporting'} = 'Rapporti';
    $Self->{Translation}->{'IT Operational'} = 'IT Operational';
    $Self->{Translation}->{'Demonstration'} = 'Dimostrazione';
    $Self->{Translation}->{'Project'} = 'Progetto';
    $Self->{Translation}->{'Underpinning Contract'} = '';
    $Self->{Translation}->{'Other'} = 'Altro';
    $Self->{Translation}->{'Availability'} = 'Disponibilità';
    $Self->{Translation}->{'Response Time'} = 'Tempo di risposta';
    $Self->{Translation}->{'Recovery Time'} = 'Tempo di ripristino';
    $Self->{Translation}->{'Resolution Rate'} = 'Velocità di risoluzione';
    $Self->{Translation}->{'Transactions'} = 'Transazioni';
    $Self->{Translation}->{'Errors'} = 'Errori';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = 'Alternativo a';
    $Self->{Translation}->{'Both'} = 'Entrambi';
    $Self->{Translation}->{'Connected to'} = 'Connesso a';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        '';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
    $Self->{Translation}->{'Depends on'} = 'Depende da';
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        '';
    $Self->{Translation}->{'ITSM SLA Overview.'} = '';
    $Self->{Translation}->{'ITSM Service Overview.'} = '';
    $Self->{Translation}->{'Incident State Type'} = '';
    $Self->{Translation}->{'Incident State Type.'} = '';
    $Self->{Translation}->{'Includes'} = 'Include';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Gestione della matrice delle priorità.';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'Modulo per mostrare il collegamento indietro nel menu sla.';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = 'Modulo per mostrare il collegamento indietro nel menu di servizio.';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = 'Modulo per mostrare il collegamento collega nel menu di servizio.';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'Modulo per mostrare il collegamento stampa nel menu sla.';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = 'Modulo per mostrare il collegamento stampa nel menu di servizio.';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Parametri per gli stati dell\'incidente nella vista delle preferenze.';
    $Self->{Translation}->{'Part of'} = 'Parte di';
    $Self->{Translation}->{'Relevant to'} = 'Rilevante per';
    $Self->{Translation}->{'Required for'} = 'Richiesto per';
    $Self->{Translation}->{'SLA Overview'} = 'Descrizione SLA';
    $Self->{Translation}->{'SLA Print.'} = '';
    $Self->{Translation}->{'SLA Zoom.'} = '';
    $Self->{Translation}->{'Service Overview'} = 'Descrizione del servizio';
    $Self->{Translation}->{'Service Print.'} = '';
    $Self->{Translation}->{'Service Zoom.'} = '';
    $Self->{Translation}->{'Service-Area'} = 'Servizio-Area';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Questa impostazione stabilisce che un oggetto \'ITSMChange\' può essere collegato con oggetti \'Ticket\' usando il tipo di collegamento \'Normale\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Questa impostazione stabilisce che un oggetto \'ITSMConfigItem\' può essere collegato con oggetti \'FAQ\' usando il tipo di collegamento \'Normale\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Questa impostazione stabilisce che un oggetto \'ITSMConfigItem\' può essere collegato con oggetti \'FAQ\' usando il tipo di collegamento \'PadreFiglio\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Questa impostazione definisce che un oggetto \'ITSMConfigItem\' può essere collegato con oggetti \'FAQ\' usando il tipo di collegamento \'ImportantePer\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        'Questa impostazione definisce che un oggetto \'ITSMConfigItem\' può essere collegato con oggetti \'Servizio\' usando il tipo di collegamento \'AlternativoA\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Questa impostazione definisce che un oggetto \'ITSMConfigItem\' può essere collegato con oggetti \'Servizio\' usando il tipo di collegamento \'DipendeDa\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        'Questa impostazione definisce che un oggetto \'ITSMConfigItem\' può essere collegato con oggetti \'Servizio\' usando il tipo di collegamento \'ImportantePer\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        'Questa impostazione definisce che un oggetto \'ITSMConfigItem\' può essere collegato con oggetti \'Ticket\' usando il tipo di collegamento \'AlternativoA\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        'Questa impostazione definisce che un oggetto \'ITSMConfigItem\' può essere collegato con oggetti \'Ticket\' usando il tipo di collegamento \'DipendeDa\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        'Questa impostazione definisce che un oggetto \'ITSMConfigItem\' può essere collegato con oggetti \'Ticket\' usando il tipo di collegamento \'ImportantePer\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Questa impostazione definisce che un oggetto \'Servizio\' può essere collegato con oggetti \'FAQ\' usando il tipo di collegamento \'Normale\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Questa impostazione definisce che un oggetto \'Servizio\' può essere collegato con oggetti \'FAQ\' usando il tipo di collegamento \'ImportantePer\'.';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'Larghezza dei campi di testo di ITSM';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
