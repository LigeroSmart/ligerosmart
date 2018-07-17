# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = 'Kritikalität ↔ Auswirkung ↔ Priorität';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        'Verwaltung der Priorität aus der Kombination von Kritikalität ↔ Impact.';
    $Self->{Translation}->{'Priority allocation'} = 'Priorität zuordnen';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Mindestzeit zwischen Incidents';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Kritikalität';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'SLA-Informationen';
    $Self->{Translation}->{'Last changed'} = 'Zuletzt geändert';
    $Self->{Translation}->{'Last changed by'} = 'Zuletzt geändert von';
    $Self->{Translation}->{'Associated Services'} = 'Zugehörige Services';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Service-Informationen';
    $Self->{Translation}->{'Current incident state'} = 'Aktueller Vorfallstatus';
    $Self->{Translation}->{'Associated SLAs'} = 'Zugehörige SLAs';

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = 'Auswirkung';

    # Perl Module: Kernel/Modules/AgentITSMSLAPrint.pm
    $Self->{Translation}->{'No SLAID is given!'} = 'Keine SLAID vorhanden!';
    $Self->{Translation}->{'SLAID %s not found in database!'} = 'SLAID "%s" in der Datenbank nicht gefunden! ';
    $Self->{Translation}->{'Calendar Default'} = '';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'No ServiceID is given!'} = 'Keine ServiceID vorhanden!';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = 'ServiceID "%s" in der Datenbank nicht gefunden!';
    $Self->{Translation}->{'Current Incident State'} = 'Aktueller Vorfallsstatus';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'Vorfallsstatus';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = 'Operativ';
    $Self->{Translation}->{'Incident'} = 'Vorfall';
    $Self->{Translation}->{'End User Service'} = 'Anwender-Service';
    $Self->{Translation}->{'Front End'} = 'Frontend';
    $Self->{Translation}->{'Back End'} = 'Backend';
    $Self->{Translation}->{'IT Management'} = 'IT Management';
    $Self->{Translation}->{'Reporting'} = 'Reporting';
    $Self->{Translation}->{'IT Operational'} = 'IT Betrieb';
    $Self->{Translation}->{'Demonstration'} = 'Demonstration';
    $Self->{Translation}->{'Project'} = 'Projekt';
    $Self->{Translation}->{'Underpinning Contract'} = 'Underpinning Contract';
    $Self->{Translation}->{'Other'} = 'Sonstiges';
    $Self->{Translation}->{'Availability'} = 'Verfügbarkeit';
    $Self->{Translation}->{'Response Time'} = 'Reaktionszeit';
    $Self->{Translation}->{'Recovery Time'} = 'Wiederherstellungszeit';
    $Self->{Translation}->{'Resolution Rate'} = 'Lösungszeit';
    $Self->{Translation}->{'Transactions'} = 'Transaktionen';
    $Self->{Translation}->{'Errors'} = 'Fehler';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = 'Alternativ zu';
    $Self->{Translation}->{'Both'} = 'Beide';
    $Self->{Translation}->{'Connected to'} = 'Verbunden mit';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        '';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'Definiert welche Spalten im Widget "Verknüpfte Services" angezeigt werden (LinkObject::ViewMode = "complex"). Hinweis: Es sind nur Serviceeigenschaften als Default-Spalten erlaubt. Mögliche Werte: 0 = Deaktiviert, 1 = Verfügbar, 2 = Standartmäßig aktiviert.';
    $Self->{Translation}->{'Depends on'} = 'Hängt ab von';
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        'Frontendmodul-Registration der AdminITSMCIPAllocate Konfiguration im Admin-Bereich.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        'Frontendmodul-Registration des AgentITSMSLA-Objekts im Agent-Interface.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        'Frontendmodul-Registration des AgentITSMSLAPrint-Objekts im Agent-Interface.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        'Frontendmodul-Registration des AgentITSMSLAZoom-Objekts im Agent-Interface.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        'Frontendmodul-Registration des AgentITSMService-Objekts im Agent-Interface.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        'Frontendmodul-Registration des AgentITSMServicePrint-Objekts im Agent-Interface.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        'Frontendmodul-Registration des AgentITSMServiceZoom-Objekts im Agent-Interface.';
    $Self->{Translation}->{'ITSM SLA Overview.'} = 'ITSM SLA-Übersicht.';
    $Self->{Translation}->{'ITSM Service Overview.'} = 'ITSM-Dienstübersicht.';
    $Self->{Translation}->{'Incident State Type'} = 'Vorfallstatus-Typ';
    $Self->{Translation}->{'Includes'} = 'Beinhaltet';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Prioritäts-Matrix verwalten';
    $Self->{Translation}->{'Manage the criticality - impact - priority matrix.'} = '';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'Über dieses Modul wird der Zurück-Link in der Linkleiste der SLA-Ansicht angezeigt.';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = 'Über dieses Modul wird der Zurück-Link in der Linkleiste der Service-Ansicht angezeigt.';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = 'Über dieses Modul wird der Link-Link in der Linkleiste der Service-Ansicht angezeigt.';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'Über dieses Modul wird der Drucken-Link in der Linkleiste der SLA-Ansicht angezeigt.';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = 'Über dieses Modul wird der Drucken-Link in der Linkleiste der Service-Ansicht angezeigt.';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Parameter fuer den Vorfallsstatus in der Ansicht fuer die Einstellungen.';
    $Self->{Translation}->{'Part of'} = 'Teil von';
    $Self->{Translation}->{'Relevant to'} = 'Relevant für';
    $Self->{Translation}->{'Required for'} = 'Benötigt für';
    $Self->{Translation}->{'SLA Overview'} = 'SLA-Übersicht';
    $Self->{Translation}->{'SLA Print.'} = 'SLA-Druck.';
    $Self->{Translation}->{'SLA Zoom.'} = 'SLA Zoom.';
    $Self->{Translation}->{'Service Overview'} = 'Dienstübersicht';
    $Self->{Translation}->{'Service Print.'} = 'Dienst Drucken.';
    $Self->{Translation}->{'Service Zoom.'} = 'Dienst Zoom.';
    $Self->{Translation}->{'Service-Area'} = 'Service-Bereich';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        '';
    $Self->{Translation}->{'Source'} = '';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Definiert, dass ein \'ITSMChange\'-Objekt mit dem Linktyp \'Normal\' mit \'Ticket\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Definiert, dass ein \'ITSMConfigItem\'-Objekt mit dem Linktyp \'Normal\' mit \'FAQ\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Definiert, dass ein \'ITSMConfigItem\'-Objekt mit dem Linktyp \'ParentChild\' mit \'FAQ\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Definiert, dass ein \'ITSMConfigItem\'-Objekt mit dem Linktyp \'RelevantTo\' mit \'FAQ\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        'Definiert, dass ein \'ITSMConfigItem\'-Objekt mit dem Linktyp \'AlternativeTo\' mit \'Service\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Definiert, dass ein \'ITSMConfigItem\'-Objekt mit dem Linktyp \'DependsOn\' mit \'Service\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        'Definiert, dass ein \'ITSMConfigItem\'-Objekt mit dem Linktyp \'RelevantTo\' mit \'Service\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        'Definiert, dass ein \'ITSMConfigItem\'-Objekt mit dem Linktyp \'AlternativeTo\' mit \'Ticket\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        'Definiert, dass ein \'ITSMConfigItem\'-Objekt mit dem Linktyp \'DependsOn\' mit \'Ticket\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        'Definiert, dass ein \'ITSMConfigItem\'-Objekt mit dem Linktyp \'RelevantTo\' mit \'Ticket\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        'Definiert, dass ein \'ITSMConfigItem\'-Objekt mit dem Linktyp \'AlternativeTo\' mit anderen \'ITSMConfigItem\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        'Definiert, dass ein \'ITSMConfigItem\'-Objekt mit dem Linktyp \'ConnectedTo\' mit anderen \'ITSMConfigItem\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Definiert, dass ein \'ITSMConfigItem\'-Objekt mit dem Linktyp \'DependsOn\' mit anderen \'ITSMConfigItem\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        'Definiert, dass ein \'ITSMConfigItem\'-Objekt mit dem Linktyp \'Includes\' mit anderen \'ITSMConfigItem\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        'Definiert, dass ein \'ITSMConfigItem\'-Objekt mit dem Linktyp \'RelevantTo\' mit anderen \'ITSMConfigItem\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Definiert, dass ein \'ITSMWorkOrder\'-Objekt mit dem Linktyp \'DependsOn\' mit \'ITSMConfigItem\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        'Definiert, dass ein \'ITSMWorkOrder\'-Objekt mit dem Linktyp \'Normal\' mit \'ITSMConfigItem\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Definiert, dass ein \'ITSMWorkOrder\'-Objekt mit dem Linktyp \'DependsOn\' mit \'Service\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        'Definiert, dass ein \'ITSMWorkOrder\'-Objekt mit dem Linktyp \'Normal\' mit \'Service\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Definiert, dass ein \'ITSMWorkOrder\'-Objekt mit dem Linktyp \'Normal\' mit \'Ticket\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Definiert, dass ein \'Service\'-Objekt mit dem Linktyp \'Normal\' mit \'FAQ\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Definiert, dass ein \'Service\'-Objekt mit dem Linktyp \'ParentChild\' mit \'FAQ\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Definiert, dass ein \'Service\'-Objekt mit dem Linktyp \'RelevantTo\' mit \'FAQ\'-Objekten verlinkt werden kann.';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Definiert den Linktyp \'AlternativeTo\'. Wird als SourceName und TargetName der gleiche Inhalt angegeben, entsteht ein ungerichteter Linktyp. Wird als SourceName und TargetName verschiedener Inhalt angegeben, entsteht ein gerichteter Linktyp.';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Definiert den Linktyp \'ConnectedTo\'. Wird als SourceName und TargetName der gleiche Inhalt angegeben, entsteht ein ungerichteter Linktyp. Wird als SourceName und TargetName verschiedener Inhalt angegeben, entsteht ein gerichteter Linktyp.';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Definiert den Linktyp \'DependsOn\'. Wird als SourceName und TargetName der gleiche Inhalt angegeben, entsteht ein ungerichteter Linktyp. Wird als SourceName und TargetName verschiedener Inhalt angegeben, entsteht ein gerichteter Linktyp.';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Definiert den Linktyp \'Includes\'. Wird als SourceName und TargetName der gleiche Inhalt angegeben, entsteht ein ungerichteter Linktyp. Wird als SourceName und TargetName verschiedener Inhalt angegeben, entsteht ein gerichteter Linktyp.';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Definiert den Linktyp \'RelevantTo\'. Wird als SourceName und TargetName der gleiche Inhalt angegeben, entsteht ein ungerichteter Linktyp. Wird als SourceName und TargetName verschiedener Inhalt angegeben, entsteht ein gerichteter Linktyp.';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'Anzahl der Zeichen pro Zeile in ITSM-TextAreas.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
