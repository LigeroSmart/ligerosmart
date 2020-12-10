# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pl_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = 'Krytyczność ↔ Wpływ ↔ Priorytet';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        'Zarządzaj wynikowym priorytetem z kombinacji Krytyczność ↔ Wpływ';
    $Self->{Translation}->{'Priority allocation'} = 'Alokacja priorytetu';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Minimalny czas między zdarzeniami';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Krytyczność';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Informacje SLA';
    $Self->{Translation}->{'Last changed'} = 'Ostatnia zmiana';
    $Self->{Translation}->{'Last changed by'} = 'Ostatnio zmienione przez';
    $Self->{Translation}->{'Associated Services'} = 'Połączone usługi';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Informacje o usłudze';
    $Self->{Translation}->{'Current incident state'} = 'Aktualny stan incydentu';
    $Self->{Translation}->{'Associated SLAs'} = 'Połączone SLA';

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = 'Wpływ';

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
    $Self->{Translation}->{'Current Incident State'} = 'Aktualny stan incydentu';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'Stan zdarzenia';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = 'Operacyjny';
    $Self->{Translation}->{'Incident'} = 'Zdarzenie';
    $Self->{Translation}->{'End User Service'} = 'Usługa Użytkownika Końcowego';
    $Self->{Translation}->{'Front End'} = 'Frontend';
    $Self->{Translation}->{'Back End'} = 'Zaplecze';
    $Self->{Translation}->{'IT Management'} = 'IT zarządzanie';
    $Self->{Translation}->{'Reporting'} = 'Raportowanie';
    $Self->{Translation}->{'IT Operational'} = 'IT operacyjne';
    $Self->{Translation}->{'Demonstration'} = 'Demonstracja';
    $Self->{Translation}->{'Project'} = 'Projekt';
    $Self->{Translation}->{'Underpinning Contract'} = 'Podstawy Umowy';
    $Self->{Translation}->{'Other'} = 'Inne';
    $Self->{Translation}->{'Availability'} = 'Dostępność';
    $Self->{Translation}->{'Response Time'} = 'Czas odpowiedzi';
    $Self->{Translation}->{'Recovery Time'} = 'Czas odzyskania';
    $Self->{Translation}->{'Resolution Rate'} = 'Czas rozwiązania';
    $Self->{Translation}->{'Transactions'} = 'Transakcje';
    $Self->{Translation}->{'Errors'} = 'Błędy';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = 'Alternatywa dla';
    $Self->{Translation}->{'Both'} = '';
    $Self->{Translation}->{'Connected to'} = 'Połączone z';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        '';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
    $Self->{Translation}->{'Depends on'} = 'Zależne od';
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
    $Self->{Translation}->{'Includes'} = 'Zawiera';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Zarządzaj macierzą priorytetów.';
    $Self->{Translation}->{'Manage the criticality - impact - priority matrix.'} = '';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'Moduł pokazywania linku powrotu w menu SLA.';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = 'Moduł pokazywania linku powrotu w menu serwisowym.';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = 'Moduł pokazywania linku w menu serwisowym.';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'Moduł pokazywania linku drukowania w menu SLA.';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = 'Moduł pokazywania linku drukowania w menu serwisowym.';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Parametry dla stanów zdarzeń w widoku preferencji.';
    $Self->{Translation}->{'Part of'} = 'Część';
    $Self->{Translation}->{'Relevant to'} = 'Odpowiednie do';
    $Self->{Translation}->{'Required for'} = 'Potrzebne do';
    $Self->{Translation}->{'SLA Overview'} = 'Przegląd SLA';
    $Self->{Translation}->{'SLA Print.'} = '';
    $Self->{Translation}->{'SLA Zoom.'} = '';
    $Self->{Translation}->{'Service Overview'} = 'Przegląd usług';
    $Self->{Translation}->{'Service Print.'} = '';
    $Self->{Translation}->{'Service Zoom.'} = '';
    $Self->{Translation}->{'Service-Area'} = 'Sekcja serwisowa';
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
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'Szerokość obszarów tekstowych ITSM.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
