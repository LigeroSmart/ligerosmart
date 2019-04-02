# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::nb_NO_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = 'Kritikalitet ↔ Omfang ↔ Prioritet';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        'Administrer prioritetsresultat ved å kombinere Kritikalitet ↔ Omfang';
    $Self->{Translation}->{'Priority allocation'} = 'Tildeling av prioritet';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Minimumstid mellom Hendelser';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Kritikalitet';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Informasjon om SLA';
    $Self->{Translation}->{'Last changed'} = 'Sist endret';
    $Self->{Translation}->{'Last changed by'} = 'Sist endret av';
    $Self->{Translation}->{'Associated Services'} = 'Tilknyttede tjenester';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Informasjon om Tjeneste';
    $Self->{Translation}->{'Current incident state'} = 'Tilstand på nåværende hendelse';
    $Self->{Translation}->{'Associated SLAs'} = 'Tilknyttede SLAer';

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = 'Omfang';

    # Perl Module: Kernel/Modules/AgentITSMSLAPrint.pm
    $Self->{Translation}->{'No SLAID is given!'} = '';
    $Self->{Translation}->{'SLAID %s not found in database!'} = '';
    $Self->{Translation}->{'Calendar Default'} = '';

    # Perl Module: Kernel/Modules/AgentITSMSLAZoom.pm
    $Self->{Translation}->{'operational'} = '';
    $Self->{Translation}->{'warning'} = '';
    $Self->{Translation}->{'incident'} = '';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'No ServiceID is given!'} = '';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = '';
    $Self->{Translation}->{'Current Incident State'} = 'Tilstand på nåværende hendelse';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'Hendelsestilstand';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = 'Operativ';
    $Self->{Translation}->{'Incident'} = 'Hendelse';
    $Self->{Translation}->{'End User Service'} = 'Sluttbruker-tjeneste';
    $Self->{Translation}->{'Front End'} = 'Frontend';
    $Self->{Translation}->{'Back End'} = 'Backend';
    $Self->{Translation}->{'IT Management'} = 'IT-ledelse';
    $Self->{Translation}->{'Reporting'} = 'Rapportering';
    $Self->{Translation}->{'IT Operational'} = 'IT-drift';
    $Self->{Translation}->{'Demonstration'} = 'Demonstrasjon';
    $Self->{Translation}->{'Project'} = 'Prosjekt';
    $Self->{Translation}->{'Underpinning Contract'} = 'Underliggende kontrakt';
    $Self->{Translation}->{'Other'} = 'Andre';
    $Self->{Translation}->{'Availability'} = 'Tilgjengelighet';
    $Self->{Translation}->{'Response Time'} = 'Responstid';
    $Self->{Translation}->{'Recovery Time'} = 'Gjenoppretningstid';
    $Self->{Translation}->{'Resolution Rate'} = 'Opprettingsratio';
    $Self->{Translation}->{'Transactions'} = 'Transaksjoner';
    $Self->{Translation}->{'Errors'} = 'Feil';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = 'Alternativ til';
    $Self->{Translation}->{'Both'} = 'Begge';
    $Self->{Translation}->{'Connected to'} = 'Koblet til';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        '';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
    $Self->{Translation}->{'Depends on'} = 'Avhenger av';
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        'Registrering av frontend-modul for konfigurasjon av AdminITSMCIPAllocate i admin-området.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        'Registrering av frontend-modul for AgentITSMSLA-objektet i saksbehandler-delen';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        'Registrering av frontend-modul for AgentITSMSLAPrint-objektet i saksbehandler-delen';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        'Registrering av frontend-modul for AgentITSMSLAZoom-objektet i saksbehandler-delen';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        'Registrering av frontend-modul for AgentITSMService-objektet i saksbehandler-delen';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        'Registrering av frontend-modul for AgentITSMServicePrint-objektet i saksbehandler-delen';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        'Registrering av frontend-modul for AgentITSMServiceZoom-objektet i saksbehandler-delen';
    $Self->{Translation}->{'ITSM SLA Overview.'} = 'SLA-oversikt';
    $Self->{Translation}->{'ITSM Service Overview.'} = 'ITSM-Tjenesteoversikt';
    $Self->{Translation}->{'Incident State Type'} = 'Type hendelsestilstand';
    $Self->{Translation}->{'Includes'} = 'Inkluderer';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Administrér prioritetsmatrise';
    $Self->{Translation}->{'Manage the criticality - impact - priority matrix.'} = '';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'Modul som viser tilbake-lenken i SLA-menyen';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = 'Modul som viser tilbake-lenken i tjenestemenyen';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = 'Modul som viser lenke-lenken i tjeneste-menyen';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'Modul som viser skriv-ut-lenken i SLA-menyen';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = 'Modul som viser skriv-ut-lenken i tjenestemenyen';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Parametre for hendelsestilstander i valgvisningen';
    $Self->{Translation}->{'Part of'} = 'Del av';
    $Self->{Translation}->{'Relevant to'} = 'Relevant for';
    $Self->{Translation}->{'Required for'} = 'Påkrevd for';
    $Self->{Translation}->{'SLA Overview'} = 'SLA-oversikt';
    $Self->{Translation}->{'SLA Print.'} = 'SLA-utskrift';
    $Self->{Translation}->{'SLA Zoom.'} = 'SLA-detaljer.';
    $Self->{Translation}->{'Service Overview'} = 'Tjeneste-oversikt';
    $Self->{Translation}->{'Service Print.'} = 'Tjenesteutskrift';
    $Self->{Translation}->{'Service Zoom.'} = 'Tjenestedetaljer';
    $Self->{Translation}->{'Service-Area'} = 'Tjenesteområde';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        '';
    $Self->{Translation}->{'Source'} = '';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        '';
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
        '';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        '';
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
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'Bredde på ITSM sine tekstområder.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
