# --
# Kernel/Language/ct_ITSMCore.pm - the catalan translation of ITSMCore
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Sistemes OTIC (ibsalut) - Antonio Linde
# --
# $Id: ct_ITSMCore.pm,v 1.7 2010-08-12 22:33:56 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ct_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

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

    return 1;
}

1;
