# --
# Kernel/Language/ru_ITSMCore.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# Copyright (C) 2013 Yuriy Kolesnikov <ynkolesnikov at gmail.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_ITSMCore;

use strict;
use warnings;

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

    # Template: AgentITSMCustomerSearch

    # Template: AgentITSMSLA

    # Template: AgentITSMSLAPrint
    $Self->{Translation}->{'SLA-Info'} = 'Информация об SLA';
    $Self->{Translation}->{'Last changed'} = 'Дата изменения';
    $Self->{Translation}->{'Last changed by'} = 'Кем изменено';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Информация об SLA';
    $Self->{Translation}->{'Associated Services'} = 'Связанные сервисы';

    # Template: AgentITSMService

    # Template: AgentITSMServicePrint
    $Self->{Translation}->{'Service-Info'} = 'Информация о Сервисе';
    $Self->{Translation}->{'Current Incident State'} = 'Текущее состояние инцидента';
    $Self->{Translation}->{'Associated SLAs'} = 'Связанные SLA';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Информация о Сервисе';
    $Self->{Translation}->{'Current incident state'} = 'Текущее состояние инцидента';

    # SysConfig
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
    $Self->{Translation}->{'Manage priority matrix.'} = 'Управление матрицей приоритетов';
    $Self->{Translation}->{'Module to show back link in service menu.'} = 'Показать кнопку "назад" в меню Сервис';
    $Self->{Translation}->{'Module to show back link in sla menu.'} = 'Показать кнопку "назад" в меню SLA';
    $Self->{Translation}->{'Module to show print link in service menu.'} = 'Показать кнопку "Печать" в меню Сервис';
    $Self->{Translation}->{'Module to show print link in sla menu.'} = 'Показать кнопку "Печать" в меню SLA';
    $Self->{Translation}->{'Module to show the link link in service menu.'} = 'Показать кнопку Связать/Link в меню Сервис';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Параметры для состояния инцидента в preference view.';
    $Self->{Translation}->{'Set the type of link to be used to calculate the incident state.'} =
        'Установить тип связи для определения состояния инцидента';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Определяет, что \'ITSMChange\' объект может быть связан с объектами \'Ticket\' используя тип связи \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Определяет, что \'ITSMConfigItem\' объект может быть связан с объектами \'FAQ\' используя тип связи \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Определяет, что \'ITSMConfigItem\' объект может быть связан с объектами \'FAQ\' используя тип связи \'ParentChild\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Определяет, что \'ITSMConfigItem\' объект может быть связан с объектами \'FAQ\' используя тип связи \'RelevantTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        'Определяет, что \'ITSMConfigItem\' объект может быть связан с объектами \'Service\' используя тип связи \'AlternativeTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Определяет, что \'ITSMConfigItem\' объект может быть связан с объектами \'Service\' используя тип связи \'DependsOn\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        'Определяет, что \'ITSMConfigItem\' объект может быть связан с объектами \'Service\' используя тип связи \'RelevantTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        'Определяет, что \'ITSMConfigItem\' объект может быть связан с объектами \'Ticket\' используя тип связи \'AlternativeTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        'Определяет, что \'ITSMConfigItem\' объект может быть связан с объектами \'Ticket\' используя тип связи \'DependsOn\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        'Определяет, что \'ITSMConfigItem\' объект может быть связан с объектами \'Ticket\' используя тип связи \'RelevantTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        'Определяет, что \'ITSMConfigItem\' объект может быть связан с объектами \'ITSMConfigItem\' используя тип связи \'AlternativeTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        'Определяет, что \'ITSMConfigItem\' объект может быть связан с объектами \'ITSMConfigItem\' используя тип связи \'ConnectedTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Определяет, что \'ITSMConfigItem\' объект может быть связан с объектами \'ITSMConfigItem\' используя тип связи \'DependsOn\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        'Определяет, что \'ITSMConfigItem\' объект может быть связан с объектами \'ITSMConfigItem\' используя тип связи \'Includes\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        'Определяет, что \'ITSMConfigItem\' объект может быть связан с объектами \'ITSMConfigItem\' используя тип связи \'RelevantTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Определяет, что \'ITSMWorkOrder\ объект может быть связан с объектами \'ITSMConfigItem\' используя тип связи \'DependsOn\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        'Определяет, что \'ITSMWorkOrder\ объект может быть связан с объектами \'ITSMConfigItem\' используя тип связи \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Определяет, что \'ITSMWorkOrder\ объект может быть связан с объектами \'Service\ используя тип связи \'DependsOn\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        'Определяет, что \'ITSMWorkOrder\ объект может быть связан с объектами \'Service\ используя тип связи \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Определяет, что \'ITSMWorkOrder\ объект может быть связан с объектами \'Ticket\' используя тип связи \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Определяет, что \'Service\' объект может быть связан с объектами \'FAQ\' используя тип связи \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Определяет, что \'Service\' объект может быть связан с объектами \'FAQ\' используя тип связи \'ParentChild\'';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Определяет, что \'Service\' объект может быть связан с объектами \'FAQ\' используя тип связи \'RelevantTo\'';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Определяет тип связи \'AlternativeTo\'. Если исходное имя и имя цели имеют одинаковое значение, результирующая связь - ненаправленная, иначе это направленная связь';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Определяет тип связи \'ConnectedTo\'. Если исходное имя и имя цели имеют одинаковое значение, результирующая связь - ненаправленная, иначе это направленная связь';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Определяет тип связи \'DependsOn\'. Если исходное имя и имя цели имеют одинаковое значение, результирующая связь - ненаправленная, иначе это направленная связь';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Определяет тип связи \'Includes\'. Если исходное имя и имя цели имеют одинаковое значение, результирующая связь - ненаправленная, иначе это направленная связь';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Определяет тип связи \'RelevantTo\'. Если исходное имя и имя цели имеют одинаковое значение, результирующая связь - ненаправленная, иначе это направленная связь';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'Ширина ITSM поля типа textarea';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
