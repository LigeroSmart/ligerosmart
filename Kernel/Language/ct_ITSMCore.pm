# --
# Kernel/Language/ct_ITSMCore.pm - the catalan translation of ITSMCore
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Sistemes OTIC (ibsalut) - Antonio Linde
# --
# $Id: ct_ITSMCore.pm,v 1.9 2010-08-13 17:38:56 mp Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ct_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'Estat crític';
    $Lang->{'Impact'}                              = 'Impacte';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Estat crític <-> Impacte <-> Prioritat';
    $Lang->{'allocation'}                          = 'assignar';
    $Lang->{'Priority allocation'}                 = '';
    $Lang->{'Relevant to'}                         = 'Relevant per';
    $Lang->{'Includes'}                            = 'Inclou';
    $Lang->{'Part of'}                             = 'Part de';
    $Lang->{'Depends on'}                          = 'Depèn de';
    $Lang->{'Required for'}                        = 'Requerit per';
    $Lang->{'Connected to'}                        = 'Connectat a';
    $Lang->{'Alternative to'}                      = 'Alternativa a';
    $Lang->{'Incident State'}                      = 'Estat de l\'incident';
    $Lang->{'Current Incident State'}              = 'Estat actual de l\'incident';
    $Lang->{'Current State'}                       = 'Estat actual';
    $Lang->{'Service-Area'}                        = 'Servei-Àrea';
    $Lang->{'Minimum Time Between Incidents'}      = 'Temps mínim entre incidents';
    $Lang->{'Service Overview'}                    = 'Visió general del servei';
    $Lang->{'SLA Overview'}                        = 'Visió general de SLA';
    $Lang->{'Associated Services'}                 = 'Serveis associats';
    $Lang->{'Associated SLAs'}                     = 'SLAs associats';
    $Lang->{'Back End'}                            = 'Servidor';
    $Lang->{'Demonstration'}                       = 'Demostració';
    $Lang->{'End User Service'}                    = 'Servei usuari final';
    $Lang->{'Front End'}                           = 'Client';
    $Lang->{'IT Management'}                       = 'Gestió IT';
    $Lang->{'IT Operational'}                      = 'Operació IT';
    $Lang->{'Other'}                               = 'Altres';
    $Lang->{'Project'}                             = 'Projecte';
    $Lang->{'Reporting'}                           = 'Informes';
    $Lang->{'Training'}                            = 'Formació';
    $Lang->{'Underpinning Contract'}               = 'Contracte de suport';
    $Lang->{'Availability'}                        = 'Disponibilitat';
    $Lang->{'Errors'}                              = 'Errors';
    $Lang->{'Other'}                               = 'Altres';
    $Lang->{'Recovery Time'}                       = 'Temps de recuperació';
    $Lang->{'Resolution Rate'}                     = 'Percentatge de resolució';
    $Lang->{'Response Time'}                       = 'Temps de resposta';
    $Lang->{'Transactions'}                        = 'Transaccions';
    $Lang->{'This setting controls the name of the application as is shown in the web interface as well as the tabs and title bar of your web browser.'} = '';
    $Lang->{'Determines the way the linked objects are displayed in each zoom mask.'} = '';
    $Lang->{'List of online repositories (for example you also can use other installations as repositoriy by using Key="http://example.com/otrs/public.pl?Action=PublicRepository&File=" and Content="Some Name").'} = '';
    $Lang->{'Frontend module registration for the AgentITSMService object in the agent interface.'} = '';
    $Lang->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} = '';
    $Lang->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} = '';
    $Lang->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} = '';
    $Lang->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} = '';
    $Lang->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} = '';
    $Lang->{'Module to show back link in service menu.'} = '';
    $Lang->{'Module to show print link in service menu.'} = '';
    $Lang->{'Module to show link link in service menu.'} = '';
    $Lang->{'Module to show back link in sla menu.'} = '';
    $Lang->{'Module to show print link in sla menu.'} = '';
    $Lang->{'If ticket service/SLA feature is enabled, you can define ticket services and SLAs for tickets (e. g. email, desktop, network, ...).'} = '';
    $Lang->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} = '';
    $Lang->{'Set the type of link to be used to calculate the incident state.'} = '';
    $Lang->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} = '';
    $Lang->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} = '';
    $Lang->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} = '';
    $Lang->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} = '';
    $Lang->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} = '';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} ='';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} = '';
    $Lang->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} = '';
    $Lang->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} = '';
    $Lang->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} = '';
    $Lang->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} = '';
    $Lang->{'Width of ITSM textareas.'} = '';
    $Lang->{'Parameters for the incident states in the preference view.'} = '';

    return 1;
}

1;
