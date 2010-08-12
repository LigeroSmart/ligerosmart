# --
# Kernel/Language/pl_ITSMCore.pm - the polish translation of ITSMCore
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Maciej Loszajc
# --
# $Id: pl_ITSMCore.pm,v 1.9 2010-08-12 22:58:07 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = '';
    $Lang->{'Impact'}                              = '';
    $Lang->{'Criticality <-> Impact <-> Priority'} = '';
    $Lang->{'allocation'}                          = '';
    $Lang->{'Priority allocation'}                 = '';
    $Lang->{'Relevant to'}                         = '';
    $Lang->{'Includes'}                            = 'Zawiera';
    $Lang->{'Part of'}                             = '';
    $Lang->{'Depends on'}                          = 'Zale¿ne od';
    $Lang->{'Required for'}                        = 'Potrzebne do';
    $Lang->{'Connected to'}                        = 'Pod³±czone do';
    $Lang->{'Alternative to'}                      = '';
    $Lang->{'Incident State'}                      = 'Stan zdarzenia';
    $Lang->{'Current Incident State'}              = 'Aktualny stan zdarzenia';
    $Lang->{'Current State'}                       = 'Aktualny stan';
    $Lang->{'Service-Area'}                        = 'Sekcja serwisowa';
    $Lang->{'Minimum Time Between Incidents'}      = 'Minimalny czas miêdzy zdarzeniami';
    $Lang->{'Service Overview'}                    = '';
    $Lang->{'SLA Overview'}                        = '';
    $Lang->{'Associated Services'}                 = 'Po³±czone us³ugi';
    $Lang->{'Associated SLAs'}                     = 'Po³±czone SLA';
    $Lang->{'Back End'}                            = '';
    $Lang->{'Demonstration'}                       = 'Demonstracja';
    $Lang->{'End User Service'}                    = '';
    $Lang->{'Front End'}                           = '';
    $Lang->{'IT Management'}                       = '';
    $Lang->{'IT Operational'}                      = '';
    $Lang->{'Other'}                               = 'Inne';
    $Lang->{'Project'}                             = 'Projekt';
    $Lang->{'Reporting'}                           = 'Raportowanie';
    $Lang->{'Training'}                            = 'Trening';
    $Lang->{'Underpinning Contract'}               = '';
    $Lang->{'Availability'}                        = 'Dostêpno¶æ';
    $Lang->{'Errors'}                              = 'B³êdy';
    $Lang->{'Other'}                               = 'Inne';
    $Lang->{'Recovery Time'}                       = 'Czas odzyskania';
    $Lang->{'Resolution Rate'}                     = 'Czas rozwi±zania';
    $Lang->{'Response Time'}                       = 'Czas odpowiedzi';
    $Lang->{'Transactions'}                        = 'Transakcje';
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

    return 1;
}

1;
