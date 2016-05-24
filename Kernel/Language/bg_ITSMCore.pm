# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::bg_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = 'Алтернативен на';
    $Self->{Translation}->{'Availability'} = 'Достъпност';
    $Self->{Translation}->{'Back End'} = 'Основна система/Backend';
    $Self->{Translation}->{'Connected to'} = 'Свързан с';
    $Self->{Translation}->{'Current State'} = '';
    $Self->{Translation}->{'Demonstration'} = 'Демонстрация';
    $Self->{Translation}->{'Depends on'} = 'Зависи от';
    $Self->{Translation}->{'End User Service'} = 'Услуги за крайни потребители';
    $Self->{Translation}->{'Errors'} = 'Грешки';
    $Self->{Translation}->{'Front End'} = 'Клиентска система/Frontend';
    $Self->{Translation}->{'IT Management'} = 'Управление на ИТ';
    $Self->{Translation}->{'IT Operational'} = 'ИТ Операции';
    $Self->{Translation}->{'Impact'} = 'Влияние';
    $Self->{Translation}->{'Incident State'} = '';
    $Self->{Translation}->{'Includes'} = 'Включени';
    $Self->{Translation}->{'Other'} = 'Други';
    $Self->{Translation}->{'Part of'} = 'Част от';
    $Self->{Translation}->{'Project'} = 'Проект';
    $Self->{Translation}->{'Recovery Time'} = 'Време за възстановяване';
    $Self->{Translation}->{'Relevant to'} = 'Съответен с';
    $Self->{Translation}->{'Reporting'} = 'Отчетност';
    $Self->{Translation}->{'Required for'} = 'Необходим за';
    $Self->{Translation}->{'Resolution Rate'} = 'Време за разрешаване';
    $Self->{Translation}->{'Response Time'} = 'Време за отговор';
    $Self->{Translation}->{'SLA Overview'} = '';
    $Self->{Translation}->{'Service Overview'} = '';
    $Self->{Translation}->{'Service-Area'} = '';
    $Self->{Translation}->{'Training'} = 'Обучение';
    $Self->{Translation}->{'Transactions'} = 'Сделки/транзакции';
    $Self->{Translation}->{'Underpinning Contract'} = 'Основен договор';
    $Self->{Translation}->{'allocation'} = 'определен';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Критичност<->Влияние<->Приотитет';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        '';
    $Self->{Translation}->{'Priority allocation'} = '';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Минимално време между инцидентите';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Критичност';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = '';
    $Self->{Translation}->{'Last changed'} = 'Последна промяна';
    $Self->{Translation}->{'Last changed by'} = 'Последно променен от';
    $Self->{Translation}->{'Associated Services'} = '';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = '';
    $Self->{Translation}->{'Current incident state'} = '';
    $Self->{Translation}->{'Associated SLAs'} = 'Свързани SLA договори';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'Current Incident State'} = '';

}

1;
