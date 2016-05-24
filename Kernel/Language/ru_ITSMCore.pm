# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = 'Замена для';
    $Self->{Translation}->{'Availability'} = 'Доступность';
    $Self->{Translation}->{'Back End'} = 'Серверная часть';
    $Self->{Translation}->{'Connected to'} = 'Связан с';
    $Self->{Translation}->{'Current State'} = 'Текущее состояние';
    $Self->{Translation}->{'Demonstration'} = 'Демонстрация';
    $Self->{Translation}->{'Depends on'} = 'Зависит от';
    $Self->{Translation}->{'End User Service'} = 'Конечный сервис пользователя';
    $Self->{Translation}->{'Errors'} = 'Ошибки';
    $Self->{Translation}->{'Front End'} = 'Интерфейсная часть';
    $Self->{Translation}->{'IT Management'} = 'Управление ИТ';
    $Self->{Translation}->{'IT Operational'} = 'Эксплуатация ИТ';
    $Self->{Translation}->{'Impact'} = 'Влияние';
    $Self->{Translation}->{'Incident State'} = 'Состояние инцидента';
    $Self->{Translation}->{'Includes'} = 'Включает';
    $Self->{Translation}->{'Other'} = 'Другое';
    $Self->{Translation}->{'Part of'} = 'Часть от';
    $Self->{Translation}->{'Project'} = 'Планирование';
    $Self->{Translation}->{'Recovery Time'} = 'Время восстановления';
    $Self->{Translation}->{'Relevant to'} = 'Относится к';
    $Self->{Translation}->{'Reporting'} = 'Составление отчетов';
    $Self->{Translation}->{'Required for'} = 'Требуется для';
    $Self->{Translation}->{'Resolution Rate'} = 'Относительная скорость решения';
    $Self->{Translation}->{'Response Time'} = 'Время реакции';
    $Self->{Translation}->{'SLA Overview'} = 'Список SLA';
    $Self->{Translation}->{'Service Overview'} = 'Список сервисов';
    $Self->{Translation}->{'Service-Area'} = 'Обзор сервисов';
    $Self->{Translation}->{'Training'} = 'Обучение';
    $Self->{Translation}->{'Transactions'} = 'Финансовые операции';
    $Self->{Translation}->{'Underpinning Contract'} = 'Контракт поддержки';
    $Self->{Translation}->{'allocation'} = 'Назначение приоритетов ';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Критичность <-> Влияние <-> Приоритет';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        'Изменение таблицы расчета приоритета в зависимости от комбинации Критичность <-> Влияние.';
    $Self->{Translation}->{'Priority allocation'} = 'Назначение приоритета';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Минимальное время между инцидентами';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Критичность';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Информация об SLA';
    $Self->{Translation}->{'Last changed'} = 'Дата изменения';
    $Self->{Translation}->{'Last changed by'} = 'Кем изменено';
    $Self->{Translation}->{'Associated Services'} = 'Связанные сервисы';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Информация о Сервисе';
    $Self->{Translation}->{'Current incident state'} = 'Текущее состояние инцидента';
    $Self->{Translation}->{'Associated SLAs'} = 'Связанные SLA';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'Current Incident State'} = 'Текущее состояние инцидента';

}

1;
