# --
# Kernel/Language/de_ITSMCore.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ITSMCore;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = 'Alternativ zu';
    $Self->{Translation}->{'Availability'} = 'Verfügbarkeit';
    $Self->{Translation}->{'Back End'} = 'Backend';
    $Self->{Translation}->{'Connected to'} = 'Verbunden mit';
    $Self->{Translation}->{'Current State'} = 'Aktueller Status';
    $Self->{Translation}->{'Demonstration'} = 'Demonstration';
    $Self->{Translation}->{'Depends on'} = 'Hängt ab von';
    $Self->{Translation}->{'End User Service'} = 'Anwender-Service';
    $Self->{Translation}->{'Errors'} = 'Fehler';
    $Self->{Translation}->{'Front End'} = 'Frontend';
    $Self->{Translation}->{'IT Management'} = 'IT Management';
    $Self->{Translation}->{'IT Operational'} = 'IT Betrieb';
    $Self->{Translation}->{'Impact'} = 'Auswirkung';
    $Self->{Translation}->{'Incident State'} = 'Vorfallsstatus';
    $Self->{Translation}->{'Includes'} = 'Beinhaltet';
    $Self->{Translation}->{'Other'} = 'Sonstiges';
    $Self->{Translation}->{'Part of'} = 'Teil von';
    $Self->{Translation}->{'Project'} = 'Projekt';
    $Self->{Translation}->{'Recovery Time'} = 'Wiederherstellungszeit';
    $Self->{Translation}->{'Relevant to'} = 'Relevant für';
    $Self->{Translation}->{'Reporting'} = 'Reporting';
    $Self->{Translation}->{'Required for'} = 'Benötigt für';
    $Self->{Translation}->{'Resolution Rate'} = 'Lösungszeit';
    $Self->{Translation}->{'Response Time'} = 'Reaktionszeit';
    $Self->{Translation}->{'SLA Overview'} = 'SLA Übersicht';
    $Self->{Translation}->{'Service Overview'} = 'Service Übersicht';
    $Self->{Translation}->{'Service-Area'} = 'Service-Bereich';
    $Self->{Translation}->{'Training'} = 'Training';
    $Self->{Translation}->{'Transactions'} = 'Transaktionen';
    $Self->{Translation}->{'Underpinning Contract'} = 'Underpinning Contract';
    $Self->{Translation}->{'allocation'} = 'zuordnen';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Kritikalität <-> Auswirkung <-> Priorität';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        'Verwaltung der Priorität aus der Kombination von Kritikalität <-> Impact.';
    $Self->{Translation}->{'Priority allocation'} = 'Priorität zuordnen';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Mindestzeit zwischen Incidents';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Kritikalität';

    # Template: AgentITSMCustomerSearch

    # Template: AgentITSMSLA

    # Template: AgentITSMSLAPrint
    $Self->{Translation}->{'SLA-Info'} = 'SLA-Info';
    $Self->{Translation}->{'Last changed'} = 'Zuletzt geändert';
    $Self->{Translation}->{'Last changed by'} = 'Zuletzt geändert von';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'SLA-Informationen';
    $Self->{Translation}->{'Associated Services'} = 'Zugehörige Services';

    # Template: AgentITSMService

    # Template: AgentITSMServicePrint
    $Self->{Translation}->{'Service-Info'} = 'Service-Info';
    $Self->{Translation}->{'Current Incident State'} = 'Aktueller Vorfallsstatus';
    $Self->{Translation}->{'Associated SLAs'} = 'Zugehörige SLAs';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Service-Informationen';
    $Self->{Translation}->{'Current incident state'} = 'Aktueller Vorfallstatus';

    # SysConfig
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
    $Self->{Translation}->{'Manage priority matrix.'} = 'Prioritäts-Matrix verwalten';
    $Self->{Translation}->{'Module to show back link in service menu.'} = 'Über dieses Modul wird der Zurück-Link in der Linkleiste der Service-Ansicht angezeigt.';
    $Self->{Translation}->{'Module to show back link in sla menu.'} = 'Über dieses Modul wird der Zurück-Link in der Linkleiste der SLA-Ansicht angezeigt.';
    $Self->{Translation}->{'Module to show print link in service menu.'} = 'Über dieses Modul wird der Drucken-Link in der Linkleiste der Service-Ansicht angezeigt.';
    $Self->{Translation}->{'Module to show print link in sla menu.'} = 'Über dieses Modul wird der Drucken-Link in der Linkleiste der SLA-Ansicht angezeigt.';
    $Self->{Translation}->{'Module to show the link link in service menu.'} = 'Über dieses Modul wird der Link-Link in der Linkleiste der Service-Ansicht angezeigt.';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Parameter fuer den Vorfallsstatus in der Ansicht fuer die Einstellungen.';
    $Self->{Translation}->{'Set the type of link to be used to calculate the incident state.'} =
        'Legt den Linktyp fest, der zur Berechnung des Vorfallstatus verwendet wird.';
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

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
