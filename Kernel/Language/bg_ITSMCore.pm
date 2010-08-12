# --
# Kernel/Language/bg_ITSMCore.pm - the bulgarian translation of ITSMCore
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2007-2008 Milen Koutev
# --
# $Id: bg_ITSMCore.pm,v 1.17 2010-08-12 22:33:56 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::bg_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.17 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'Критичност';
    $Lang->{'Impact'}                              = 'Влияние';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Критичност<->Влияние<->Приотитет';
    $Lang->{'allocation'}                          = 'определен';
    $Lang->{'Priority allocation'}                 = '';
    $Lang->{'Relevant to'}                         = 'Съответен с';
    $Lang->{'Includes'}                            = 'Включени';
    $Lang->{'Part of'}                             = 'Част от';
    $Lang->{'Depends on'}                          = 'Зависи от';
    $Lang->{'Required for'}                        = 'Необходим за';
    $Lang->{'Connected to'}                        = 'Свързан с';
    $Lang->{'Alternative to'}                      = 'Алтернативен на';
    $Lang->{'Incident State'}                      = '';
    $Lang->{'Current Incident State'}              = '';
    $Lang->{'Current State'}                       = '';
    $Lang->{'Service-Area'}                        = '';
    $Lang->{'Minimum Time Between Incidents'}      = 'Минимално време между инцидентите';
    $Lang->{'Service Overview'}                    = '';
    $Lang->{'SLA Overview'}                        = '';
    $Lang->{'Associated Services'}                 = '';
    $Lang->{'Associated SLAs'}                     = 'Свързани SLA договори';
    $Lang->{'Back End'}                            = 'Основна система/BackEnd';
    $Lang->{'Demonstration'}                       = 'Демонстрация';
    $Lang->{'End User Service'}                    = 'Услуги за крайни потребители';
    $Lang->{'Front End'}                           = 'Клиентска система/FrontEnd';
    $Lang->{'IT Management'}                       = 'Управление на ИТ';
    $Lang->{'IT Operational'}                      = 'ИТ Операции';
    $Lang->{'Other'}                               = 'Други';
    $Lang->{'Project'}                             = 'Проект';
    $Lang->{'Reporting'}                           = 'Отчетност';
    $Lang->{'Training'}                            = 'Обучение';
    $Lang->{'Underpinning Contract'}               = 'Основен договор';
    $Lang->{'Availability'}                        = 'Достъпност';
    $Lang->{'Errors'}                              = 'Грешки';
    $Lang->{'Other'}                               = 'Други';
    $Lang->{'Recovery Time'}                       = 'Време за възстановяване';
    $Lang->{'Resolution Rate'}                     = 'Време за разрешаване';
    $Lang->{'Response Time'}                       = 'Време за отговор';
    $Lang->{'Transactions'}                        = 'Сделки/транзакции';
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
