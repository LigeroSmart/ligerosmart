# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ru_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = 'Критичность ↔ Влияние ↔ Приоритет';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        'Изменение таблицы расчета приоритета в зависимости от комбинации Критичность ↔ Влияние.';
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

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = 'Влияние';

    # Perl Module: Kernel/Modules/AgentITSMSLAPrint.pm
    $Self->{Translation}->{'No SLAID is given!'} = 'SLAID не назначен!';
    $Self->{Translation}->{'SLAID %s not found in database!'} = 'SLAID %s не найден в базе!';
    $Self->{Translation}->{'Calendar Default'} = 'Календарь по умолчанию';

    # Perl Module: Kernel/Modules/AgentITSMSLAZoom.pm
    $Self->{Translation}->{'operational'} = '';
    $Self->{Translation}->{'warning'} = '';
    $Self->{Translation}->{'incident'} = '';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'No ServiceID is given!'} = 'ServiceID не назначен!';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = 'ServiceID %s не найден в базе!';
    $Self->{Translation}->{'Current Incident State'} = 'Текущее состояние инцидента';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'Состояние инцидента';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = 'В эксплуатации';
    $Self->{Translation}->{'Incident'} = 'Инцидент';
    $Self->{Translation}->{'End User Service'} = 'Конечный сервис пользователя';
    $Self->{Translation}->{'Front End'} = 'Интерфейсная часть';
    $Self->{Translation}->{'Back End'} = 'Серверная часть';
    $Self->{Translation}->{'IT Management'} = 'Управление ИТ';
    $Self->{Translation}->{'Reporting'} = 'Составление отчетов';
    $Self->{Translation}->{'IT Operational'} = 'Эксплуатация ИТ';
    $Self->{Translation}->{'Demonstration'} = 'Демонстрация';
    $Self->{Translation}->{'Project'} = 'Планирование';
    $Self->{Translation}->{'Underpinning Contract'} = 'Контракт поддержки';
    $Self->{Translation}->{'Other'} = 'Другое';
    $Self->{Translation}->{'Availability'} = 'Доступность';
    $Self->{Translation}->{'Response Time'} = 'Время реакции';
    $Self->{Translation}->{'Recovery Time'} = 'Время восстановления';
    $Self->{Translation}->{'Resolution Rate'} = 'Относительная скорость решения';
    $Self->{Translation}->{'Transactions'} = 'Финансовые операции';
    $Self->{Translation}->{'Errors'} = 'Ошибки';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = 'Замена для';
    $Self->{Translation}->{'Both'} = 'Оба';
    $Self->{Translation}->{'Connected to'} = 'Связан с';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'Задает Действия/Actions когда кнопка настройки доступна в связанном виджете (LinkObject::ViewMode = "complex"). Обратите внимание, что эти Действия/Actions должны иметь зарегистрированные JS или CSS файлы: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js и Core.Agent.LinkObject.js.';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'Определить, какие столбцы отображаются в связанном виджете служб (LinkObject::ViewMode = "complex"). Примечание: Только сервисные атрибуты разрешены для DefaultColumns. Возможные настройки: 0 = Отключено, 1 = Включено, 2 = Включено по умолчанию.';
    $Self->{Translation}->{'Depends on'} = 'Зависит от';
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        'Frontend module registration для параметров AdminITSMCIPAllocate в панели администратора.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        'Frontend module registration для объекта AgentITSMSLA в панели администратора.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        'Frontend module registration для объекта AgentITSMSLAPrint в панели администратора.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        'Frontend module registration для объекта AgentITSMSLAZoom в панели администратора.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        'Frontend module registration для объекта AgentITSMService в панели администратора.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        'Frontend module registration для объекта AgentITSMServicePrint в панели администратора.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        'Frontend module registration для объекта AgentITSMServiceZoom в панели администратора.';
    $Self->{Translation}->{'ITSM SLA Overview.'} = 'Обзор ITSM SLA';
    $Self->{Translation}->{'ITSM Service Overview.'} = 'Обзор ITSM сервисов.';
    $Self->{Translation}->{'Incident State Type'} = 'Тип состояния инцидента';
    $Self->{Translation}->{'Includes'} = 'Включает';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Управление матрицей приоритетов';
    $Self->{Translation}->{'Manage the criticality - impact - priority matrix.'} = '';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'Показать кнопку "назад" в меню SLA';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = 'Показать кнопку "назад" в меню Сервис';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = 'Показать кнопку Связать/Link в меню Сервис';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'Показать кнопку "Печать" в меню SLA';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = 'Показать кнопку "Печать" в меню Сервис';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Параметры для состояния инцидента в preference view.';
    $Self->{Translation}->{'Part of'} = 'Часть от';
    $Self->{Translation}->{'Relevant to'} = 'Относится к';
    $Self->{Translation}->{'Required for'} = 'Требуется для';
    $Self->{Translation}->{'SLA Overview'} = 'Список SLA';
    $Self->{Translation}->{'SLA Print.'} = 'Печать SLA.';
    $Self->{Translation}->{'SLA Zoom.'} = 'Подробности SLA.';
    $Self->{Translation}->{'Service Overview'} = 'Список сервисов';
    $Self->{Translation}->{'Service Print.'} = 'Печать сервиса.';
    $Self->{Translation}->{'Service Zoom.'} = 'Подробности сервиса.';
    $Self->{Translation}->{'Service-Area'} = 'Обзор сервисов';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        'Задает тип и направление связи для использования при вычислении состояния инцидента. Ключ это имя типа связи (как это задано в LinkObject::Type), а Значение это направление IncidentLinkType на основании которого вычисляется состояние инцидента. Например, если IncidentLinkType установлен в \'Зависит от/Depends on\', и Направление - \'Источник\', то только связи \'Зависит от\' будут использоваться (а не противоположная \'Необходимо для/Required for\') для вычисления состояния инцидента. Вы можете добавить другие дополнительные типы связи и направления по своему желанию, например,  \'Включает/Includes\' с направлением \'Цель/Target\'. допускаются все типы связи, заданные параметром LinkObject::Type и направления могут быть \'Источник/Source\', \'Цель/Target\', или \'Оба/Both\'. ВАЖНО: ПОСЛЕ ИЗМЕНЕНИЯ ЗНАЧЕНИЙ ЭТОГО ПАРАМЕТРА НЕОБХОДИМО ВЫПОЛНИТЬ СКРИПТ bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate ДЛЯ ПЕРЕРАСЧЕТА ВСЕХ СОСТОЯНИЙ ИНЦИДЕНТА НА ОСНОВЕ НОВЫХ ЗНАЧЕНИЙ!';
    $Self->{Translation}->{'Source'} = '';
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


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
