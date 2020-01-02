# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::fr_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = 'Criticité ↔ Impact ↔ Priorité';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        'Gérer la matrice de priorité.';
    $Self->{Translation}->{'Priority allocation'} = 'Attribution de priorité';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Temps minimal entre les incidents';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Criticité';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Informations sur les SLA';
    $Self->{Translation}->{'Last changed'} = 'Dernières modifications';
    $Self->{Translation}->{'Last changed by'} = 'Dernières modifications par';
    $Self->{Translation}->{'Associated Services'} = 'Services associés';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Informations sur le service';
    $Self->{Translation}->{'Current incident state'} = 'État actuel de l\'incident';
    $Self->{Translation}->{'Associated SLAs'} = 'SLA associés';

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = 'Impact';

    # Perl Module: Kernel/Modules/AgentITSMSLAPrint.pm
    $Self->{Translation}->{'No SLAID is given!'} = 'Aucun ID de SLA n\'a été donné !';
    $Self->{Translation}->{'SLAID %s not found in database!'} = 'L\'ID du SLA %s n\'a pas été trouvé dans la base de données !';
    $Self->{Translation}->{'Calendar Default'} = 'Calendrier par défaut';

    # Perl Module: Kernel/Modules/AgentITSMSLAZoom.pm
    $Self->{Translation}->{'operational'} = '';
    $Self->{Translation}->{'warning'} = '';
    $Self->{Translation}->{'incident'} = '';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'No ServiceID is given!'} = 'Aucun ID de service n\'a été donné !';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = 'L\'ID du service %s n\'a pas été trouvé dans la base de données !';
    $Self->{Translation}->{'Current Incident State'} = 'État actuel de l\'incident';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'État de l\'incident';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = 'Opérationnel';
    $Self->{Translation}->{'Incident'} = 'Incident';
    $Self->{Translation}->{'End User Service'} = 'Service utilisateur';
    $Self->{Translation}->{'Front End'} = 'Frontend';
    $Self->{Translation}->{'Back End'} = 'Backend';
    $Self->{Translation}->{'IT Management'} = 'Gestion des technologies de l\'information';
    $Self->{Translation}->{'Reporting'} = 'Rapport';
    $Self->{Translation}->{'IT Operational'} = 'Technologies de l\'information opérationnelles';
    $Self->{Translation}->{'Demonstration'} = 'Démonstration';
    $Self->{Translation}->{'Project'} = 'Projet';
    $Self->{Translation}->{'Underpinning Contract'} = 'Contrat externe';
    $Self->{Translation}->{'Other'} = 'Autre';
    $Self->{Translation}->{'Availability'} = 'Disponibilité';
    $Self->{Translation}->{'Response Time'} = 'Temps de réponse';
    $Self->{Translation}->{'Recovery Time'} = 'Temps de réparation';
    $Self->{Translation}->{'Resolution Rate'} = 'Taux de résolution';
    $Self->{Translation}->{'Transactions'} = 'Transactions';
    $Self->{Translation}->{'Errors'} = 'Erreurs';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = 'Alternatif à';
    $Self->{Translation}->{'Both'} = 'Les deux';
    $Self->{Translation}->{'Connected to'} = 'Lié à';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        '';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
    $Self->{Translation}->{'Depends on'} = 'Dépend de';
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
    $Self->{Translation}->{'ITSM SLA Overview.'} = 'Vue d\'ensemble des SLA';
    $Self->{Translation}->{'ITSM Service Overview.'} = 'Vue d\'ensemble des services';
    $Self->{Translation}->{'Incident State Type'} = 'Type d\'état de l\'incident';
    $Self->{Translation}->{'Includes'} = 'Inclus';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Gestion de la matrice de priorité.';
    $Self->{Translation}->{'Manage the criticality - impact - priority matrix.'} = 'Gérer la matrice de priorité (criticité × impact).';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = '';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = '';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = '';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = '';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = '';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Paramètres des états d\'incident dans la vue des préférences.';
    $Self->{Translation}->{'Part of'} = 'Part de';
    $Self->{Translation}->{'Relevant to'} = 'Correspondant à';
    $Self->{Translation}->{'Required for'} = 'Requis pour';
    $Self->{Translation}->{'SLA Overview'} = 'Vue d\'ensemble des SLA';
    $Self->{Translation}->{'SLA Print.'} = 'Impression des SLA.';
    $Self->{Translation}->{'SLA Zoom.'} = 'Vue détaillée des SLA.';
    $Self->{Translation}->{'Service Overview'} = 'Vue d\'ensemble des services';
    $Self->{Translation}->{'Service Print.'} = 'Impression des services.';
    $Self->{Translation}->{'Service Zoom.'} = 'Vue détaillée des services.';
    $Self->{Translation}->{'Service-Area'} = 'Zone de service';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        '';
    $Self->{Translation}->{'Source'} = '';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMChange" peut être lié avec un objet "Ticket" en utilisant un type de lien "Normal".';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMConfigItem" peut être lié avec un objet "FAQ" en utilisant un type de lien "Normal".';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMConfigItem" peut être lié avec un objet "FAQ" en utilisant un type de lien "ParentEnfant".';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMConfigItem" peut être lié avec un objet "FAQ" en utilisant un type de lien "Correspondant à".';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMConfigItem" peut être lié avec un objet "Service" en utilisant un type de lien "Alternatif à".';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMConfigItem" peut être lié avec un objet "Service" en utilisant un type de lien "Dépend de".';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMConfigItem" peut être lié avec un objet "Service" en utilisant un type de lien "Correspondant à".';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMConfigItem" peut être lié avec un objet "Ticket" en utilisant un type de lien "Alternatif à".';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMConfigItem" peut être lié avec un objet "Ticket" en utilisant un type de lien "Dépends de".';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMConfigItem" peut être lié avec un objet "Ticket" en utilisant un type de lien "Correspondant à".';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMConfigItem" peut être lié avec un objet "ITSMConfigItem" en utilisant un type de lien "Alternatif à".';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMConfigItem" peut être lié avec un objet "ITSMConfigItem" en utilisant un type de lien "Lié à".';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMConfigItem" peut être lié avec un objet "ITSMConfigItem" en utilisant un type de lien "Dépend de".';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMConfigItem" peut être lié avec un objet "ITSMConfigItem" en utilisant un type de lien "Inclus".';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMConfigItem" peut être lié avec un objet "ITSMConfigItem" en utilisant un type de lien "Correspondant à".';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMWorkOrder" peut être lié avec un objet "ITSMConfigItem" en utilisant un type de lien "Dépend de".';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMWorkOrder" peut être lié avec un objet "ITSMConfigItem" en utilisant un type de lien "Normal".';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMWorkOrder" peut être lié avec un objet "Service" en utilisant un type de lien "Dépend de".';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMWorkOrder" peut être lié avec un objet "Service" en utilisant un type de lien "Normal".';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Ce paramétrage défini qu\'un objet "ITSMWorkOrder" peut être lié avec un objet "Ticket" en utilisant un type de lien "Normal".';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Ce paramétrage défini qu\'un objet "Service" peut être lié avec un objet "FAQ" en utilisant un type de lien "Normal".';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Ce paramétrage défini qu\'un objet "Service" peut être lié avec un objet "FAQ" en utilisant un type de lien "ParentEnfant".';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Ce paramétrage défini qu\'un objet "Service" peut être lié avec un objet "FAQ" en utilisant un type de lien "Correspondant à".';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Ce paramétrage défini le type de lien "Alternatif à". Si la source et la cible contiennent la même valeur, le résultat est un lien non-directionnel. Si les valeurs sont différentes, le résultat est un lien directionnel.';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Ce paramétrage défini le type de lien "Correspondant à". Si la source et la cible contiennent la même valeur, le résultat est un lien non-directionnel. Si les valeurs sont différentes, le résultat est un lien directionnel.';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Ce paramétrage défini le type de lien "Dépend de". Si la source et la cible contiennent la même valeur, le résultat est un lien non-directionnel. Si les valeurs sont différentes, le résultat est un lien directionnel.';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Ce paramétrage défini le type de lien "Inclus". Si la source et la cible contiennent la même valeur, le résultat est un lien non-directionnel. Si les valeurs sont différentes, le résultat est un lien directionnel.';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Ce paramétrage défini le type de lien "Correspondant à". Si la source et la cible contiennent la même valeur, le résultat est un lien non-directionnel. Si les valeurs sont différentes, le résultat est un lien directionnel.';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'Largeur des zones de texte.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
