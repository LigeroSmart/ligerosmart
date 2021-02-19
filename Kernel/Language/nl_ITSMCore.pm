# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::nl_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = 'Urgentie ↔ Impact ↔ Prioriteit';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        'Beheer het prioriteitsresultaat van het combineren van Urgentie ↔ Impact.';
    $Self->{Translation}->{'Priority allocation'} = 'Prioriteitstoewijzing';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Minimale Tijd Tussen Incidenten';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Urgentie';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'SLA-informatie';
    $Self->{Translation}->{'Last changed'} = 'Laatst gewijzigd';
    $Self->{Translation}->{'Last changed by'} = 'Laatst gewijzigd door';
    $Self->{Translation}->{'Associated Services'} = 'Bijbehorende Services';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Service-informatie';
    $Self->{Translation}->{'Current incident state'} = 'Huidige incidentstatus';
    $Self->{Translation}->{'Associated SLAs'} = 'Bijbehorende SLA\'s';

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = 'Impact';

    # Perl Module: Kernel/Modules/AgentITSMSLAPrint.pm
    $Self->{Translation}->{'No SLAID is given!'} = 'Er wordt geen SLAID gegeven!';
    $Self->{Translation}->{'SLAID %s not found in database!'} = 'SLAID %s niet gevonden in database!';
    $Self->{Translation}->{'Calendar Default'} = 'Kalender Standaard';

    # Perl Module: Kernel/Modules/AgentITSMSLAZoom.pm
    $Self->{Translation}->{'operational'} = 'operationeel';
    $Self->{Translation}->{'warning'} = 'waarschuwing';
    $Self->{Translation}->{'incident'} = 'incident';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'No ServiceID is given!'} = 'Er wordt geen ServiceID gegeven!';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = 'ServiceID %s niet gevonden in database!';
    $Self->{Translation}->{'Current Incident State'} = 'Huidige Incidentstatus';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'Incidentstatus';

    # Database XML / SOPM Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = 'Operationeel';
    $Self->{Translation}->{'Incident'} = 'Incident';
    $Self->{Translation}->{'End User Service'} = 'Eindgebruiker Service';
    $Self->{Translation}->{'Front End'} = 'Frontend';
    $Self->{Translation}->{'Back End'} = 'Backend';
    $Self->{Translation}->{'IT Management'} = 'IT Management';
    $Self->{Translation}->{'Reporting'} = 'Rapportage';
    $Self->{Translation}->{'IT Operational'} = 'IT Operationeel';
    $Self->{Translation}->{'Demonstration'} = 'Demonstratie';
    $Self->{Translation}->{'Project'} = 'Project';
    $Self->{Translation}->{'Underpinning Contract'} = 'Onderliggend contract';
    $Self->{Translation}->{'Other'} = 'Anders';
    $Self->{Translation}->{'Availability'} = 'Beschikbaarheid';
    $Self->{Translation}->{'Response Time'} = 'Reactietijd';
    $Self->{Translation}->{'Recovery Time'} = 'Hersteltijd';
    $Self->{Translation}->{'Resolution Rate'} = 'Oplospercentage';
    $Self->{Translation}->{'Transactions'} = 'Transacties';
    $Self->{Translation}->{'Errors'} = 'Fouten';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = 'Alternatief voor';
    $Self->{Translation}->{'Both'} = 'Beide';
    $Self->{Translation}->{'Connected to'} = 'Verbonden met';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'Definieer acties waarbij een instellingenknop beschikbaar is in de widget voor gekoppelde objecten (LinkObject::ViewMode = "complex"). Houd er rekening mee dat deze acties de volgende JS- en CSS-bestanden moeten hebben geregistreerd: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js en Core.Agent .LinkObject.js.';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'Definieer welke kolommen worden weergegeven in de widget gekoppelde Services (LinkObject::ViewMode = "complex"). Opmerking: alleen servicekenmerken zijn toegestaan voor DefaultColumns. Mogelijke instellingen: 0 = Uitgeschakeld, 1 = Beschikbaar, 2 = Standaard ingeschakeld.';
    $Self->{Translation}->{'Depends on'} = 'Afhankelijk van';
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        'Frontend module registratie voor de AdminITSMCIPAllocate configuratie in het admin gebied.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        'Frontend module registratie voor het AgentITSMSLA-object in de agentinterface.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        'Frontend module registratie voor het AgentITSMSLAPrint-object in de agentinterface.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        'Frontend module registratie voor het AgentITSMSLAZoom-object in de agentinterface.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        'Frontend module registratie voor het AgentITSMService-object in de agentinterface.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        'Frontend module registratie voor het AgentITSMServicePrint-object in de agentinterface.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        'Frontend module registratie voor het AgentITSMServiceZoom-object in de agentinterface.';
    $Self->{Translation}->{'ITSM SLA Overview.'} = 'ITSM SLA Overzicht.';
    $Self->{Translation}->{'ITSM Service Overview.'} = 'ITSM Service Overzicht.';
    $Self->{Translation}->{'Incident State Type'} = 'Incidentstatustype';
    $Self->{Translation}->{'Includes'} = 'Omvat';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Beheer prioriteitsmatrix.';
    $Self->{Translation}->{'Manage the criticality - impact - priority matrix.'} = 'Beheer de urgentie - impact - prioriteitsmatrix.';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'Module om het menu-item Terug in het SLA-menu weer te geven.';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = 'Module om het menu-item Terug in het servicemenu weer te geven.';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = 'Module om het menu-item Koppel in het servicemenu weer te geven.';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'Module om het menu-item Afdrukken in het SLA-menu weer te geven.';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = 'Module om het menu-item Afdrukken in het servicemenu weer te geven.';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Parameters voor de incidentstatussen in de voorkeursweergave.';
    $Self->{Translation}->{'Part of'} = 'Deel van';
    $Self->{Translation}->{'Relevant to'} = 'Relevant voor';
    $Self->{Translation}->{'Required for'} = 'Vereist voor';
    $Self->{Translation}->{'SLA Overview'} = 'SLA Overzicht';
    $Self->{Translation}->{'SLA Print.'} = 'SLA Afdrukken.';
    $Self->{Translation}->{'SLA Zoom.'} = 'SLA Zoom.';
    $Self->{Translation}->{'Service Overview'} = 'Service Overzicht';
    $Self->{Translation}->{'Service Print.'} = 'Service Afdrukken.';
    $Self->{Translation}->{'Service Zoom.'} = 'Service Zoom.';
    $Self->{Translation}->{'Service-Area'} = 'Service-Gebied';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        'Stel het type en de richting in van de koppelingen die moeten worden gebruikt om de incidentstatus te berekenen. De sleutel is de naam van het koppeltype (zoals gedefinieerd in LinkObject::Type) en de waarde is de richting van het IncidentLinkType die moet worden gevolgd om de incidentstatus te berekenen. Als het IncidentLinkType bijvoorbeeld is ingesteld op \'AfhankelijkVan\' en de richting \'Bron\' is, worden alleen de koppelingen \'Afhankelijk van\' gevolgd (en niet de tegenovergestelde link \'Vereist voor\') om de incidentstatus te berekenen. je kunt desgewenst meer koppelingstypen en richtingen toevoegen, bijv. \'Omvat\' met de richting \'Doel\'. Alle koppelingstypen die zijn gedefinieerd in de sysconfig-opties LinkObject::Type zijn mogelijk en de richting kan \'Bron\', \'Doel\' of \'Beide\' zijn. BELANGRIJK: NA WIJZIGING VAN DEZE SYSTEEMCONFIGURATIE-OPTIE MOET HET CONSOLE-COMMANDO bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate WORDEN UITGEVOERD ZODAT ALLE INCIDENT-STATUSSEN WORDEN HERBERKEND OP BASIS VAN DE NIEUWE INSTELLINGEN!';
    $Self->{Translation}->{'Source'} = 'Bron';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMChange\' kan worden gekoppeld aan \'Ticket\'-objecten met behulp van het koppeltype \'Normaal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMConfigItem\' kan worden gekoppeld aan \'FAQ\'-objecten met behulp van het koppeltype \'Normaal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMConfigItem\' kan worden gekoppeld aan \'FAQ\'-objecten met het koppeltype \'OuderKind\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Deze instelling definieert dat een \'ITSMConfigItem\'-object kan worden gekoppeld aan \'FAQ\'-objecten met behulp van het koppeltype \'RelevantVoor\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMConfigItem\' kan worden gekoppeld aan \'Service\'-objecten met behulp van het linktype \'AlternatiefVoor\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMConfigItem\' kan worden gekoppeld aan \'Service\'-objecten met behulp van het koppelingstype\' AfhankelijkVan\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMConfigItem\' kan worden gekoppeld aan \'Service\'-objecten met behulp van het linktype \'RelevantVoor\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMConfigItem\' kan worden gekoppeld aan \'Ticket\'-objecten met behulp van het linktype \'AlternatiefVoor\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMConfigItem\' kan worden gekoppeld aan \'Ticket\'-objecten met behulp van het koppelingstype \'AfhankelijkVan\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMConfigItem\' kan worden gekoppeld aan \'Ticket\'-objecten met behulp van het linktype \'RelevantVoor \'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMConfigItem\' kan worden gekoppeld aan andere objecten \'ITSMConfigItem\' met behulp van het linktype \'AlternatiefVoor\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMConfigItem\' kan worden gekoppeld aan andere objecten \'ITSMConfigItem\' met behulp van het linktype \'VerbondenAan\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMConfigItem\' kan worden gekoppeld aan andere objecten \'ITSMConfigItem\' met behulp van het koppelingstype \'AfhankelijkVan\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMConfigItem\' kan worden gekoppeld aan andere objecten \'ITSMConfigItem\' met behulp van het koppelingstype \'Omvat\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMConfigItem\' kan worden gekoppeld aan andere objecten \'ITSMConfigItem\' met behulp van het linktype \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMWorkOrder\' kan worden gekoppeld aan objecten \'ITSMConfigItem\' met behulp van het koppelingstype \'DependsOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMWorkOrder\' kan worden gekoppeld aan \'ITSMConfigItem\'-objecten met behulp van het linktype \'Normaal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMWorkOrder\' kan worden gekoppeld aan \'Service\'-objecten met behulp van het koppelingstype \'DependsOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMWorkOrder\' kan worden gekoppeld aan \'Service\'-objecten met behulp van het koppelingstype \'Normaal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Deze instelling definieert dat een object \'ITSMWorkOrder\' kan worden gekoppeld aan \'Ticket\'-objecten met behulp van het linktype \'Normaal\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Deze instelling definieert dat een object \'Service\' kan worden gekoppeld aan \'FAQ\'-objecten met behulp van het linktype \'Normaal\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Deze instelling definieert dat een object \'Service\' kan worden gekoppeld aan \'FAQ\'-objecten met behulp van het koppelingstype \'ParentChild\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Deze instelling definieert dat een object \'Service\' kan worden gekoppeld aan \'FAQ\'-objecten met behulp van het linktype \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Deze instelling definieert het linktype \'AlternativeTo\'. Als de bronnaam en de doelnaam dezelfde waarde bevatten, is de resulterende link niet-directioneel. Als de waarden verschillen, is de resulterende link een directionele link.';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Deze instelling definieert het linktype \'ConnectedTo\'. Als de bronnaam en de doelnaam dezelfde waarde bevatten, is de resulterende link niet-directioneel. Als de waarden verschillen, is de resulterende link een directionele link.';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Deze instelling definieert het linktype \'DependsOn\'. Als de bronnaam en de doelnaam dezelfde waarde bevatten, is de resulterende link niet-directioneel. Als de waarden verschillen, is de resulterende link een directionele link.';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Deze instelling definieert het linktype \'Inclusief\'. Als de bronnaam en de doelnaam dezelfde waarde bevatten, is de resulterende link niet-directioneel. Als de waarden verschillen, is de resulterende link een directionele link.';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Deze instelling definieert het linktype \'RelevantTo\'. Als de bronnaam en de doelnaam dezelfde waarde bevatten, is de resulterende link niet-directioneel. Als de waarden verschillen, is de resulterende link een directionele link.';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'Breedte van ITSM-tekstgebieden.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
