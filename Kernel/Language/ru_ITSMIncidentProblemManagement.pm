# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ru_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketOverviewMedium
    $Self->{Translation}->{'Criticality'} = 'Критичность';
    $Self->{Translation}->{'Impact'} = 'Степень влияния';

    # JS Template: ServiceIncidentState
    $Self->{Translation}->{'Service Incident State'} = 'Состояние Сервиса';

    # Perl Module: Kernel/Output/HTML/FilterElementPost/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Link ticket'} = 'Связать заявку';
    $Self->{Translation}->{'Change Decision of %s%s%s'} = 'Изменить решение %s%s%s';
    $Self->{Translation}->{'Change ITSM fields of %s%s%s'} = 'Изменить поля ITSM %s%s%s';

    # Perl Module: var/packagesetup/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Review Required'} = 'Необходим просмотр';
    $Self->{Translation}->{'Decision Result'} = 'Результат решения';
    $Self->{Translation}->{'Approved'} = 'Утверждено';
    $Self->{Translation}->{'Postponed'} = 'Отложено';
    $Self->{Translation}->{'Pre-approved'} = 'Предварительно одобрено';
    $Self->{Translation}->{'Rejected'} = 'Отклонено';
    $Self->{Translation}->{'Repair Start Time'} = 'Дата начала работ';
    $Self->{Translation}->{'Recovery Start Time'} = 'Дата восстановления сервиса';
    $Self->{Translation}->{'Decision Date'} = 'Дата решения';
    $Self->{Translation}->{'Due Date'} = 'Дата исполнения';

    # Database XML Definition: ITSMIncidentProblemManagement.sopm
    $Self->{Translation}->{'closed with workaround'} = 'закрыто с обходным решением';

    # SysConfig
    $Self->{Translation}->{'Add a decision!'} = 'Добавить решение';
    $Self->{Translation}->{'Additional ITSM Fields'} = 'Дополнительные ITSM поля';
    $Self->{Translation}->{'Additional ITSM ticket fields.'} = 'Дополнительные ITSM поля заявки.';
    $Self->{Translation}->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} =
        'Разрешает добавить заметку на экране Дополнительные ITSM поля в интерфейсе агента';
    $Self->{Translation}->{'Allows adding notes in the decision screen of the agent interface.'} =
        'Разрешает добавить заметку на экране Решение в интерфейсе агента';
    $Self->{Translation}->{'Allows defining new types for ticket (if ticket type feature is enabled).'} =
        'Позволяет определить новые Типы для заявок (если включено использование Типа).';
    $Self->{Translation}->{'Change the ITSM fields!'} = 'Изменить ITSM поля';
    $Self->{Translation}->{'Decision'} = 'Решение';
    $Self->{Translation}->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Определяет необходимость блокировки заявки на экране Дополнительные ITSM поля в интерфейсе агента (если заявка еще не блокирована, она блокируется и текущий агент автоматически назначается ее владельцем';
    $Self->{Translation}->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Определяет необходимость блокировки заявки на экране Решение в интерфейсе агента (если заявка еще не блокирована, она блокируется и текущий агент автоматически назначается ее владельцем';
    $Self->{Translation}->{'Defines if the service incident state should be shown during service selection in the agent interface.'} =
        'Определяет, показывать ли состояние Сервиса при его выборе в интерфейсе агента';
    $Self->{Translation}->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} =
        'Задает стандартный текст заметки на экране Дополнительные ITSM поля в интерфейсе агента (если необходимо)';
    $Self->{Translation}->{'Defines the default body of a note in the decision screen of the agent interface.'} =
        'Задает стандартный текст заметки на экране Решение в интерфейсе агента (если необходимо)';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Задает следующее состояние заявки по умолчанию после добавления заметки на экране Дополнительные ITSM поля в интерфейсе агента';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Задает следующее состояние заявки по умолчанию после добавления заметки на экране Решение в интерфейсе агента';
    $Self->{Translation}->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} =
        'Задает стандартную тему заметки на экране Дополнительные ITSM поля в интерфейсе агента';
    $Self->{Translation}->{'Defines the default subject of a note in the decision screen of the agent interface.'} =
        'Задает стандартную тему заметки на экране Решение в интерфейсе агента';
    $Self->{Translation}->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} =
        'Задает стандартный приоритет на экране Дополнительные ITSM поля в интерфейсе агента';
    $Self->{Translation}->{'Defines the default ticket priority in the decision screen of the agent interface.'} =
        'Задает стандартный приоритет на экране Решение в интерфейсе агента';
    $Self->{Translation}->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Задает комментарий в истории для действий на экране Дополнительные ITSM поля в интерфейсе агента';
    $Self->{Translation}->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} =
        'Задает комментарий в истории для действий на экране Решение в интерфейсе агента';
    $Self->{Translation}->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Задает тип комментария в истории для действий на экране Дополнительные ITSM поля в интерфейсе агента';
    $Self->{Translation}->{'Defines the history type for the decision screen action, which gets used for ticket history.'} =
        'Задает тип комментария в истории для действий на экране Решение в интерфейсе агента';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Задает следующее состояние заявки после добавления заметки на экране Дополнительные ITSM поля в интерфейсе агента';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Задает следующее состояние заявки после добавления заметки на экране Решение в интерфейсе агента';
    $Self->{Translation}->{'Dynamic fields shown in the additional ITSM field screen of the agent interface.'} =
        'Динамические поля, показанные на дополнительном экране поля ITSM интерфейса агента.';
    $Self->{Translation}->{'Dynamic fields shown in the decision screen of the agent interface.'} =
        'Динамические поля, отображаемые на экране решения интерфейса агента.';
    $Self->{Translation}->{'Dynamic fields shown in the ticket zoom screen of the agent interface.'} =
        'Динамические поля, отображаемые в окне просмотра заявки интерфейса агента.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} =
        'Включает модуль отчетов для формирования отчетов о среднем ITSM ticket first level solution rate.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} =
        'Включает модуль отчетов для формирования отчетов о среднем ITSM ticket solution.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} =
        'Возможность установить новое состояние завки при добавлении заметки на экране Дополнительные ITSM поля в интерфейсе агента.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} =
        'Возможность установить новое состояние завки при добавлении заметки на экране Решение в интерфейсе агента.';
    $Self->{Translation}->{'Modifies the display order of the dynamic field ITSMImpact and other things.'} =
        'Изменяет порядок отображения динамического поля ITSMImpact и другие вещи.';
    $Self->{Translation}->{'Module to dynamically show the service incident state and to calculate the priority.'} =
        'Модуль для динамического отображения состояния сервисного инцидента и вычисления приоритета.';
    $Self->{Translation}->{'Required permissions to use the additional ITSM field screen in the agent interface.'} =
        'Задает требуемые права для использования пункта меню Дополнительные ITSM поля в интерфейсе агента.';
    $Self->{Translation}->{'Required permissions to use the decision screen in the agent interface.'} =
        'Задает требуемые права для использования пункта меню Решение в интерфейсе агента.';
    $Self->{Translation}->{'Service Incident State and Priority Calculation'} = 'Состояние сервисного инцидента и расчет приоритетов';
    $Self->{Translation}->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Позволяет задать Сервис на экране Дополнительные ITSM поля в интерфейсе агента (Ticket::Service должен быть активирован).';
    $Self->{Translation}->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Позволяет задать Сервис на экране Решение в интерфейсе агента (Ticket::Service должен быть активирован).';
    $Self->{Translation}->{'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Задает Сервис при изменении приоритета заявки в интерфейсе агента. (Ticket::Service должен быть включен).';
    $Self->{Translation}->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} =
        'Позволяет задать Владельца заявки на экране Дополнительные ITSM поля в интерфейсе агента.';
    $Self->{Translation}->{'Sets the ticket owner in the decision screen of the agent interface.'} =
        'Позволяет задать Владельца заявки на экране Решение в интерфейсе агента.';
    $Self->{Translation}->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} =
        'Позволяет задать Ответственного за заявку на экране Дополнительные ITSM поля в интерфейсе агента.';
    $Self->{Translation}->{'Sets the ticket responsible in the decision screen of the agent interface.'} =
        'Позволяет задать Ответственного за заявку на экране Решение в интерфейсе агента.';
    $Self->{Translation}->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Позволяет задать Тип заявки на экране Дополнительные ITSM поля в интерфейсе агента (Ticket::Type должен быть активирован).';
    $Self->{Translation}->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Позволяет задать Тип заявки на экране Решение в интерфейсе агента (Ticket::Type должен быть активирован).';
    $Self->{Translation}->{'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Задает Тип заявки при изменении приоритета заявки в интерфейсе агента. (Ticket::Type должен быть активирован).';
    $Self->{Translation}->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} =
        'Показывает ссылку на пункт меню для изменения Решения по заявке в окне подробного просмотра (TicketZoom) в интерфейсе агента.';
    $Self->{Translation}->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} =
        'Показывает ссылку на пункт меню для изменения Дополнительных ITSM полей заявки в окне подробного просмотра (TicketZoom) в интерфейсе агента.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} =
        'Показывает список для выбора всех вовлеченных агентов по этой заявке на экране Дополнительные ITSM поля в интерфейсе агента.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} =
        'Показывает список для выбора всех вовлеченных агентов по этой заявке на экране Решение в интерфейсе агента.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} =
        'Показывает список для выбора всех возможных агентов ( с правами на создание заметок (note) для очереди/заявки ), которых надо информировать об этой заметке на экране Дополнительные ITSM поля в интерфейсе агента.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} =
        'Показывает список для выбора всех возможных агентов ( с правами на создание заметок (note) для очереди/заявки ), которых надо информировать об этой заметке на экране Решение в интерфейсе агента.';
    $Self->{Translation}->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} =
        'Показывает поле выбора приоритета на экране Дополнительные ITSM поля в интерфейсе агента.';
    $Self->{Translation}->{'Shows the ticket priority options in the decision screen of the agent interface.'} =
        'Показывает поле выбора приоритета на экране Решение в интерфейсе агента.';
    $Self->{Translation}->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} =
        'Показывает поле Тема на экране Дополнительные ITSM поля в интерфейсе агента.';
    $Self->{Translation}->{'Shows the title fields in the decision screen of the agent interface.'} =
        'Показывает поле Тема на экране Решение в интерфейсе агента.';
    $Self->{Translation}->{'Ticket decision.'} = 'Решение по заявке.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Service Incident State',
    );

}

1;
