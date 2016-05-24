# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMChangeManagement
    $Self->{Translation}->{'ITSMChange'} = 'Изменение';
    $Self->{Translation}->{'ITSMChanges'} = 'Изменения';
    $Self->{Translation}->{'ITSM Changes'} = 'Изменения';
    $Self->{Translation}->{'workorder'} = 'Задача';
    $Self->{Translation}->{'A change must have a title!'} = 'Изменение должно иметь название';
    $Self->{Translation}->{'A condition must have a name!'} = 'Условие должно иметь имя';
    $Self->{Translation}->{'A template must have a name!'} = 'Шаблон должен иметь имя';
    $Self->{Translation}->{'A workorder must have a title!'} = 'Задача должна иметь название';
    $Self->{Translation}->{'Add CAB Template'} = 'Добавить шаблон для CAB';
    $Self->{Translation}->{'Add Workorder'} = 'Добавить задачу';
    $Self->{Translation}->{'Add a workorder to the change'} = 'Добавить задачу к изменению';
    $Self->{Translation}->{'Add new condition and action pair'} = 'Добавить новую пару условие-действие';
    $Self->{Translation}->{'Agent interface module to show the ChangeManager overview icon.'} =
        'Модуль интерфейса агента отображающий иконку обзора ChangeManager';
    $Self->{Translation}->{'Agent interface module to show the MyCAB overview icon.'} = 'Модуль интерфейса агента отображающий иконку обзора Мои CAB';
    $Self->{Translation}->{'Agent interface module to show the MyChanges overview icon.'} = 'Модуль интерфейса агента отображающий иконку обзора Мои изменения';
    $Self->{Translation}->{'Agent interface module to show the MyWorkOrders overview icon.'} =
        'Модуль интерфейса агента отображающий иконку обзора Мои задачи';
    $Self->{Translation}->{'CABAgents'} = 'агенты в CAB';
    $Self->{Translation}->{'CABCustomers'} = 'клиенты в CAB';
    $Self->{Translation}->{'Change Overview'} = 'Обзор изменений';
    $Self->{Translation}->{'Change Schedule'} = 'Планировщик изменений';
    $Self->{Translation}->{'Change involved persons of the change'} = 'Изменить список вовлеченных участников изменения';
    $Self->{Translation}->{'ChangeHistory::ActionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ActionAddID'} = 'Новое действие (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ActionDelete'} = 'Действие (ID=%s) удалено';
    $Self->{Translation}->{'ChangeHistory::ActionDeleteAll'} = 'Все действия и условия (ID=%s) удалены';
    $Self->{Translation}->{'ChangeHistory::ActionExecute'} = 'Действие (ID=%s) выполняется: %s';
    $Self->{Translation}->{'ChangeHistory::ActionUpdate'} = '%s (Действие ID=%s): Новое: %s <- Старое: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeActualEndTimeReached'} = 'Изменение (ID=%s) достигло фактического времени окончания.';
    $Self->{Translation}->{'ChangeHistory::ChangeActualStartTimeReached'} = 'Изменение (ID=%s) достигло фактического времени начала.';
    $Self->{Translation}->{'ChangeHistory::ChangeAdd'} = 'Новое изменение (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentAdd'} = 'Новое вложение: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentDelete'} = 'Удаленные вложения %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABDelete'} = 'CAB удален %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABUpdate'} = 'CAB %s: Новый: %s <- Старый: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkAdd'} = 'Связь %s (ID=%s) добавлена';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkDelete'} = 'Связь для %s (ID=%s) удалена';
    $Self->{Translation}->{'ChangeHistory::ChangeNotificationSent'} = 'Уведомление отправлено %s (Событие: %s)';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedEndTimeReached'} = 'Изменение (ID=%s) достигло запланированного времени окончания.';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedStartTimeReached'} = 'Изменение (ID=%s) достигло запланированного времени начала.';
    $Self->{Translation}->{'ChangeHistory::ChangeRequestedTimeReached'} = 'Изменение (ID=%s) достигло заданного срока.';
    $Self->{Translation}->{'ChangeHistory::ChangeUpdate'} = '%s: Новое: %s <- Старое: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAddID'} = 'Новое условие (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ConditionDelete'} = 'Условие (ID=%s) удалено';
    $Self->{Translation}->{'ChangeHistory::ConditionDeleteAll'} = 'Все условия изменения (ID=%s) удалены';
    $Self->{Translation}->{'ChangeHistory::ConditionUpdate'} = '%s (Условие ID=%s): Новое: %s <- Старое: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAddID'} = 'Новое выражение (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ExpressionDelete'} = 'Выражение (ID=%s) удалено';
    $Self->{Translation}->{'ChangeHistory::ExpressionDeleteAll'} = 'Все выражения условия (ID=%s) удалены';
    $Self->{Translation}->{'ChangeHistory::ExpressionUpdate'} = '%s (Выражение ID=%s): Новое: %s <- Старое: %s';
    $Self->{Translation}->{'ChangeNumber'} = 'Номер изменения';
    $Self->{Translation}->{'Condition Edit'} = 'Редактировать условие';
    $Self->{Translation}->{'Create Change'} = 'Создать изменение';
    $Self->{Translation}->{'Create a change from this ticket!'} = 'Создать изменение из этой заявки!';
    $Self->{Translation}->{'Delete Workorder'} = 'Удалить задачу';
    $Self->{Translation}->{'Edit the change'} = 'Редактировать изменение';
    $Self->{Translation}->{'Edit the conditions of the change'} = 'Редактировать условия изменения';
    $Self->{Translation}->{'Edit the workorder'} = 'Редактировать задачу';
    $Self->{Translation}->{'Expression'} = 'Выражение';
    $Self->{Translation}->{'Full-Text Search in Change and Workorder'} = 'Полнотекстовый поиск в изменении и задаче';
    $Self->{Translation}->{'ITSMCondition'} = 'Условие';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'Задача';
    $Self->{Translation}->{'Link another object to the change'} = 'Связать другой объект с изменением';
    $Self->{Translation}->{'Link another object to the workorder'} = 'Связать другой объект с задачей';
    $Self->{Translation}->{'Move all workorders in time'} = 'Переместить все задачи во времени';
    $Self->{Translation}->{'My CABs'} = 'Мои CAB';
    $Self->{Translation}->{'My Changes'} = 'Мои изменения';
    $Self->{Translation}->{'My Workorders'} = 'Мои задачи';
    $Self->{Translation}->{'No XXX settings'} = 'Нет \'%s\' параметров';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'PIR (Post Implementation Review/Анализ после выполнения)';
    $Self->{Translation}->{'PSA (Projected Service Availability)'} = 'PSA (Projected Service Availability/Проектируемая доступность сервиса)';
    $Self->{Translation}->{'Please select first a catalog class!'} = 'Пожалуйста, сначала выберите класс каталога';
    $Self->{Translation}->{'Print the change'} = 'Печать изменения';
    $Self->{Translation}->{'Print the workorder'} = 'Печать задачи';
    $Self->{Translation}->{'RequestedTime'} = 'Запрошенное время';
    $Self->{Translation}->{'Save Change CAB as Template'} = 'Сохранить состав CAB для изменения как шаблон';
    $Self->{Translation}->{'Save change as a template'} = 'Сохранить изменение как шаблон';
    $Self->{Translation}->{'Save workorder as a template'} = 'Сохранить задачу как шаблон';
    $Self->{Translation}->{'Search Changes'} = 'Поиск изменений';
    $Self->{Translation}->{'Set the agent for the workorder'} = 'Назначит агента для задачи';
    $Self->{Translation}->{'Take Workorder'} = 'Взять задачу';
    $Self->{Translation}->{'Take the workorder'} = 'Взять задачу';
    $Self->{Translation}->{'Template Overview'} = 'Обзор шаблонов';
    $Self->{Translation}->{'The planned end time is invalid!'} = 'Запланированное время окончания неверно!';
    $Self->{Translation}->{'The planned start time is invalid!'} = 'Запланированное время начала неверно!';
    $Self->{Translation}->{'The planned time is invalid!'} = 'Планоый срок неверен!';
    $Self->{Translation}->{'The requested time is invalid!'} = 'Запрашиваемое время неверно!';
    $Self->{Translation}->{'New (from template)'} = 'Новое(ая) из шаблона';
    $Self->{Translation}->{'Add from template'} = 'Добавить, используя шаблон';
    $Self->{Translation}->{'Add Workorder (from template)'} = 'Добавить задачу ( используя шаблон)';
    $Self->{Translation}->{'Add a workorder (from template) to the change'} = 'Добавить задачу к изменению (используя шаблон)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReached'} = 'Задача (ID=%s) достигла фактического времени окончания.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'} =
        'Задача (ID=%s) достигла фактического времени окончания.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReached'} = 'Задача (ID=%s) достигла фактического времени начала.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'} =
        'Задача (ID=%s) достигла фактического времени начала.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAdd'} = 'Новая задача (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'} = 'Новая задача (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAdd'} = 'Новое вложение для задачи: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'} = '(ID=%s) Новое вложение из задачи: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Удаленное вложение для задачи: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Удаленное вложение из задачи: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAdd'} = 'Новый вложенный отчет для задачи: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID'} =
        '(ID=%s) Новый вложенный отчет для задачи: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDelete'} = 'Удаленный вложенный отчет из задачи: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID'} =
        '(ID=%s) Удаленный вложенный отчет из задачи: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDelete'} = 'Задача (ID=%s) удалена';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'} = 'Задача (ID=%s) удалена';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAdd'} = 'Связь для %s (ID=%s) добавлена';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'} = '(ID=%s) Связь для %s (ID=%s) добавлена';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'Связь для %s (ID=%s) удалена';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'} = '(ID=%s) Связь для %s (ID=%s) удалена';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'Уведомление отправлено %s (Событие: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '(ID=%s) Уведомление отправлено %s (Событие: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'} = 'Задача (ID=%s) достигла запланированного времени окончания.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'} =
        'достигла запланированного времени окончания.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'} = 'Задача (ID=%s) достигла запланированного времени начала';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} =
        'Задача (ID=%s) достигла запланированного времени начала.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdate'} = '%s: Новая: %s <- Старая: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'} = '(ID=%s) %s: Новая: %s <- Старая: %s';
    $Self->{Translation}->{'WorkOrderNumber'} = 'Номер задачи';
    $Self->{Translation}->{'accepted'} = 'Принято';
    $Self->{Translation}->{'any'} = 'любой(ая)';
    $Self->{Translation}->{'approval'} = 'Утверждение';
    $Self->{Translation}->{'approved'} = 'Утверждено';
    $Self->{Translation}->{'backout'} = 'План отката';
    $Self->{Translation}->{'begins with'} = 'начать с';
    $Self->{Translation}->{'canceled'} = 'отменено';
    $Self->{Translation}->{'contains'} = 'содержит';
    $Self->{Translation}->{'created'} = 'создано(а)';
    $Self->{Translation}->{'decision'} = 'решение';
    $Self->{Translation}->{'ends with'} = 'окончить с';
    $Self->{Translation}->{'failed'} = 'не удалось';
    $Self->{Translation}->{'in progress'} = 'в работе';
    $Self->{Translation}->{'is'} = 'Является';
    $Self->{Translation}->{'is after'} = 'после';
    $Self->{Translation}->{'is before'} = 'до';
    $Self->{Translation}->{'is empty'} = 'пусто';
    $Self->{Translation}->{'is greater than'} = 'больше чем';
    $Self->{Translation}->{'is less than'} = 'меньше чем';
    $Self->{Translation}->{'is not'} = 'не';
    $Self->{Translation}->{'is not empty'} = 'не пусто';
    $Self->{Translation}->{'not contains'} = 'не содержит';
    $Self->{Translation}->{'pending approval'} = 'отложенное утверждение';
    $Self->{Translation}->{'pending pir'} = 'ожидает одобрения PIR';
    $Self->{Translation}->{'pir'} = 'PIR (Post Implementation Review/анализ по окончании)';
    $Self->{Translation}->{'ready'} = 'готово';
    $Self->{Translation}->{'rejected'} = 'отвергнуто';
    $Self->{Translation}->{'requested'} = 'запрошено';
    $Self->{Translation}->{'retracted'} = 'отказано';
    $Self->{Translation}->{'set'} = 'установлено';
    $Self->{Translation}->{'successful'} = 'успешно';

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category <-> Impact <-> Priority'} = 'Категория <-> Влияние <-> Приоритет';
    $Self->{Translation}->{'Manage the priority result of combinating Category <-> Impact.'} =
        'Управление приоритетом на основе комбинации Категория <-> Влияние';
    $Self->{Translation}->{'Priority allocation'} = 'Назначение приоритета';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'Управление уведомлениями в ITSM ChangeManagement';
    $Self->{Translation}->{'Add Notification Rule'} = 'Добавить правило уведомления';
    $Self->{Translation}->{'Rule'} = 'Правило';
    $Self->{Translation}->{'A notification should have a name!'} = 'Уведомление должно иметь имя';
    $Self->{Translation}->{'Name is required.'} = 'Требуется имя';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'Управление Машиной состояний';
    $Self->{Translation}->{'Select a catalog class!'} = 'Выберите класс каталога!';
    $Self->{Translation}->{'A catalog class is required!'} = 'Класс каталога обязателен!';
    $Self->{Translation}->{'Add a state transition'} = 'Добавить состояние перехода';
    $Self->{Translation}->{'Catalog Class'} = 'Класс каталога';
    $Self->{Translation}->{'Object Name'} = 'Имя объекта';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Обзор состояний перехода для';
    $Self->{Translation}->{'Delete this state transition'} = 'Удалить это состояние перехода';
    $Self->{Translation}->{'Add a new state transition for'} = 'Добавить новое состояние перехода для';
    $Self->{Translation}->{'Please select a state!'} = 'Выберите состояние!';
    $Self->{Translation}->{'Please select a next state!'} = 'Выберите следующее состояние!';
    $Self->{Translation}->{'Edit a state transition for'} = 'Редактировать состояние перехода для';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Вы действительно хототе удалить состояние перехода';
    $Self->{Translation}->{'from'} = 'из';
    $Self->{Translation}->{'to'} = 'по';

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'Добавить изменение';
    $Self->{Translation}->{'ITSM Change'} = 'Изменение';
    $Self->{Translation}->{'Justification'} = 'Обоснование';
    $Self->{Translation}->{'Input invalid.'} = 'Неверные данные';
    $Self->{Translation}->{'Impact'} = 'Влияние';
    $Self->{Translation}->{'Requested Date'} = 'Запрошенное время';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'Выбрать шаблон для изменения';
    $Self->{Translation}->{'Time type'} = 'Тип времени';
    $Self->{Translation}->{'Invalid time type.'} = 'неверный тип времени.';
    $Self->{Translation}->{'New time'} = 'новое время';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'Сохратиь состав CAB как шаблон';
    $Self->{Translation}->{'go to involved persons screen'} = 'перейти к экрану вовлеченных специалистов';
    $Self->{Translation}->{'Invalid Name'} = 'Неверное имя';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Условия и Действия';
    $Self->{Translation}->{'Delete Condition'} = 'Удалить условие';
    $Self->{Translation}->{'Add new condition'} = 'Добавить новое условие';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = 'Требуется правильное имя';
    $Self->{Translation}->{'A valid name is needed.'} = '';
    $Self->{Translation}->{'Duplicate name:'} = 'Уже используемое имя:';
    $Self->{Translation}->{'This name is already used by another condition.'} = 'Это имя уже сипользуется в другом условии.';
    $Self->{Translation}->{'Matching'} = 'Сопоставление';
    $Self->{Translation}->{'Any expression (OR)'} = 'Любое выражение (OR)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Все выражения (AND)';
    $Self->{Translation}->{'Expressions'} = 'Выражения';
    $Self->{Translation}->{'Selector'} = 'Переключатель';
    $Self->{Translation}->{'Operator'} = 'Оператор';
    $Self->{Translation}->{'Delete Expression'} = 'Удалить выражение';
    $Self->{Translation}->{'No Expressions found.'} = 'Выражение не задано.';
    $Self->{Translation}->{'Add new expression'} = 'Добавитьновое выражение';
    $Self->{Translation}->{'Delete Action'} = 'Удалить действие';
    $Self->{Translation}->{'No Actions found.'} = 'Действий не задано.';
    $Self->{Translation}->{'Add new action'} = 'Добавить новое действие';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = 'Вы действительно желаете удалить это изменение?';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of'} = 'История для';
    $Self->{Translation}->{'Workorder'} = 'Задача';
    $Self->{Translation}->{'Show details'} = 'Показать подробно';
    $Self->{Translation}->{'Show workorder'} = 'Показать задачу';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of'} = 'Детальная информация истории для';
    $Self->{Translation}->{'Modified'} = 'Изменено';
    $Self->{Translation}->{'Old Value'} = 'Старое значение';
    $Self->{Translation}->{'New Value'} = 'Новое значение';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Involved Persons'} = 'Вовлеченные сотрудники';
    $Self->{Translation}->{'ChangeManager'} = 'Менеджер изменений';
    $Self->{Translation}->{'User invalid.'} = 'Неверный исполнитель';
    $Self->{Translation}->{'ChangeBuilder'} = 'Составитель изменения';
    $Self->{Translation}->{'Change Advisory Board'} = 'CAB - Комитет по изменения';
    $Self->{Translation}->{'CAB Template'} = 'Шаблон для CAB';
    $Self->{Translation}->{'Apply Template'} = 'Применить шаблон';
    $Self->{Translation}->{'NewTemplate'} = 'Новый шаблон';
    $Self->{Translation}->{'Save this CAB as template'} = 'Сохранить состав CAB как шаблон';
    $Self->{Translation}->{'Add to CAB'} = 'Добавить к CAB';
    $Self->{Translation}->{'Invalid User'} = 'Неверный сотрудник';
    $Self->{Translation}->{'Current CAB'} = 'Текущий CAB';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Параметры контекста';
    $Self->{Translation}->{'Changes per page'} = 'Изменений на страницу';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'WorkOrderTitle'} = 'Заголовок задачи';
    $Self->{Translation}->{'ChangeTitle'} = 'Заголовок изменения';
    $Self->{Translation}->{'WorkOrderAgent'} = 'Агент для задачи';
    $Self->{Translation}->{'Workorders'} = 'Задачи';
    $Self->{Translation}->{'ChangeState'} = 'Состояние изменения';
    $Self->{Translation}->{'WorkOrderState'} = 'Состояние задачи';
    $Self->{Translation}->{'WorkOrderType'} = 'Тип задачи';
    $Self->{Translation}->{'Requested Time'} = 'Запрошенное время';
    $Self->{Translation}->{'PlannedStartTime'} = 'Запланированное время начала';
    $Self->{Translation}->{'PlannedEndTime'} = 'Запланированное время окончания';
    $Self->{Translation}->{'ActualStartTime'} = 'Фактическое время начала';
    $Self->{Translation}->{'ActualEndTime'} = 'Фактическое время окончания';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = 'Вы действительно желаете очистить это изменение?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(т.е. 10*5155 или 105658*)';
    $Self->{Translation}->{'CABAgent'} = 'CAB агент';
    $Self->{Translation}->{'e.g.'} = 'т.е.';
    $Self->{Translation}->{'CABCustomer'} = 'CAB клиент';
    $Self->{Translation}->{'ITSM Workorder'} = 'Задача';
    $Self->{Translation}->{'Instruction'} = 'Инструкция';
    $Self->{Translation}->{'Report'} = 'Отчет';
    $Self->{Translation}->{'Change Category'} = 'Изменить категорию';
    $Self->{Translation}->{'(before/after)'} = 'до/после';
    $Self->{Translation}->{'(between)'} = 'между';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Сохранить изменение как шаблон';
    $Self->{Translation}->{'A template should have a name!'} = 'Надо присвоить имя шаблону!';
    $Self->{Translation}->{'The template name is required.'} = 'Требуется имя шаблона.';
    $Self->{Translation}->{'Reset States'} = 'Очистить состояния';
    $Self->{Translation}->{'Overwrite original template'} = 'Перезаписать исходный шаблон';
    $Self->{Translation}->{'Delete original change'} = 'Удалить исходное изменение';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Сместить диапазон времени';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'Информация об изменении';
    $Self->{Translation}->{'PlannedEffort'} = 'Планируемые ресурсы???';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Инициатор изменения';
    $Self->{Translation}->{'Change Manager'} = 'Менеджер изменения';
    $Self->{Translation}->{'Change Builder'} = 'Составитель изменения';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Дата последнего изменеия';
    $Self->{Translation}->{'Last changed by'} = 'Последний изменил';
    $Self->{Translation}->{'Ok'} = 'О.К.';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Для открытия ссылки в следующем сообщении/заметке необходимо нажать и удерживать клавишу Ctrl или Cmd или Shift и кликнуть по ссылке (зависит от вашего браузера и ОС).';
    $Self->{Translation}->{'Download Attachment'} = 'Загрузить вложение';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = 'Ва действительно желаете удалить этот шаблон';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = 'Редактировать шаблон CAB';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        'Будет создано новое изменение из этого шаблона и вы сможете его редактировать и сохранить.';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        'Новое изменение будет автоматически удалено после его сохранения в качестве шаблона.';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        'Будет создана новая задача из этого шаблона и вы сможете его редактировать и сохранить.';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        'Будет создано временное изменение, содержащее задачу.';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        'Временное изменение и новая задача будет автоматически удалены после сохранения задачи в качестве шаблона.';
    $Self->{Translation}->{'Do you want to proceed?'} = 'Желаете продолжить?';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = 'ID шаблона';
    $Self->{Translation}->{'Edit Content'} = 'Редактировать содержание';
    $Self->{Translation}->{'CreateBy'} = 'Кем создан';
    $Self->{Translation}->{'CreateTime'} = 'Создан';
    $Self->{Translation}->{'ChangeBy'} = 'Кем изменен';
    $Self->{Translation}->{'ChangeTime'} = 'Изменен';
    $Self->{Translation}->{'Edit Template Content'} = 'Редактировать содержание шаблона';
    $Self->{Translation}->{'Delete Template'} = 'Удалить шаблон';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = 'Добавить задачу к';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Неправильный тип задачи.';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'Время начала должно предшествовать времени окончания!';
    $Self->{Translation}->{'Invalid format.'} = 'Неверный формат';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Выбрать шаблон для задачи';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Вы действительно желаете удалить эту задачу?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Вы не можете удалить эту задачу. Она используется как минимум в одном условии!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Эта задача используется в следующих условиях';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = 'Переместить/сдвинуть следующие задачи соответственно';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        'Если запланированное время окончания задачи будет изменено, запланированное время начала всех последующих задач будет соответственно изменено';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'Время начала должно предшествовать времени окончания!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'Фактическое время начала должно быть задано, если задано время фактического окончания!';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Текущий агент';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Вы действительно хотите взять эту задачу?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Сохранить задачу как шаблон';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = 'Удалить исходную задачу  (и окружающее изменение)';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Информация о задаче';

    # Perl Module: Kernel/Modules/AdminITSMChangeNotification.pm
    $Self->{Translation}->{'Unknown notification %s!'} = '';
    $Self->{Translation}->{'There was an error creating the notification.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChange.pm
    $Self->{Translation}->{'Overview: ITSM Changes'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeAdd.pm
    $Self->{Translation}->{'Ticket with TicketID %s does not exist!'} = '';
    $Self->{Translation}->{'Missing sysconfig option "ITSMChange::AddChangeLinkTicketTypes"!'} =
        '';
    $Self->{Translation}->{'Was not able to add change!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeAddFromTemplate.pm
    $Self->{Translation}->{'Was not able to create change from template!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeCABTemplate.pm
    $Self->{Translation}->{'No ChangeID is given!'} = '';
    $Self->{Translation}->{'No change found for changeID %s.'} = '';
    $Self->{Translation}->{'The CAB of change "%s" could not be serialized.'} = '';
    $Self->{Translation}->{'Could not add the template.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeCondition.pm
    $Self->{Translation}->{'Change "%s" not found in database!'} = '';
    $Self->{Translation}->{'Could not delete ConditionID %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeConditionEdit.pm
    $Self->{Translation}->{'No %s is given!'} = '';
    $Self->{Translation}->{'Could not create new condition!'} = '';
    $Self->{Translation}->{'Could not update ConditionID %s!'} = '';
    $Self->{Translation}->{'Could not update ExpressionID %s!'} = '';
    $Self->{Translation}->{'Could not add new Expression!'} = '';
    $Self->{Translation}->{'Could not update ActionID %s!'} = '';
    $Self->{Translation}->{'Could not add new Action!'} = '';
    $Self->{Translation}->{'Could not delete ExpressionID %s!'} = '';
    $Self->{Translation}->{'Could not delete ActionID %s!'} = '';
    $Self->{Translation}->{'Error: Unknown field type "%s"!'} = '';
    $Self->{Translation}->{'ConditionID %s does not belong to the given ChangeID %s!'} = '';
    $Self->{Translation}->{'Please contact the administrator.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeDelete.pm
    $Self->{Translation}->{'Change "%s" does not have an allowed change state to be deleted!'} =
        '';
    $Self->{Translation}->{'Was not able to delete the changeID %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeEdit.pm
    $Self->{Translation}->{'Was not able to update Change!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ChangeID is given!'} = '';
    $Self->{Translation}->{'Change "%s" not found in the database!'} = '';
    $Self->{Translation}->{'Unknown type "%s" encountered!'} = '';
    $Self->{Translation}->{'Change History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistoryZoom.pm
    $Self->{Translation}->{'Can\'t show history zoom, no HistoryEntryID is given!'} = '';
    $Self->{Translation}->{'HistoryEntry "%s" not found in database!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeInvolvedPersons.pm
    $Self->{Translation}->{'Was not able to update Change CAB for Change %s!'} = '';
    $Self->{Translation}->{'Was not able to update Change %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeManager.pm
    $Self->{Translation}->{'Overview: ChangeManager'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyCAB.pm
    $Self->{Translation}->{'Overview: My CAB'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyChanges.pm
    $Self->{Translation}->{'Overview: My Changes'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyWorkOrders.pm
    $Self->{Translation}->{'Overview: My Workorders'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePIR.pm
    $Self->{Translation}->{'Overview: PIR'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePSA.pm
    $Self->{Translation}->{'Overview: PSA'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePrint.pm
    $Self->{Translation}->{'WorkOrder "%s" not found in database!'} = '';
    $Self->{Translation}->{'Can\'t create output, as the workorder is not attached to a change!'} =
        '';
    $Self->{Translation}->{'Can\'t create output, as no ChangeID is given!'} = '';
    $Self->{Translation}->{'unknown change title'} = '';
    $Self->{Translation}->{'unknown workorder title'} = '';
    $Self->{Translation}->{'ITSM Workorder Overview (%s)'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeReset.pm
    $Self->{Translation}->{'Was not able to reset WorkOrder %s of Change %s!'} = '';
    $Self->{Translation}->{'Was not able to reset Change %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSchedule.pm
    $Self->{Translation}->{'Overview: Change Schedule'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSearch.pm
    $Self->{Translation}->{'Change Search'} = '';
    $Self->{Translation}->{'WorkOrders'} = 'Задачи';
    $Self->{Translation}->{'Change Search Result'} = '';
    $Self->{Translation}->{'Change Number'} = '';
    $Self->{Translation}->{'Change Title'} = '';
    $Self->{Translation}->{'Work Order Title'} = '';
    $Self->{Translation}->{'CAB Agent'} = '';
    $Self->{Translation}->{'CAB Customer'} = '';
    $Self->{Translation}->{'Change Description'} = '';
    $Self->{Translation}->{'Change Justification'} = '';
    $Self->{Translation}->{'WorkOrder Instruction'} = '';
    $Self->{Translation}->{'WorkOrder Report'} = '';
    $Self->{Translation}->{'Change Priority'} = '';
    $Self->{Translation}->{'Change Impact'} = '';
    $Self->{Translation}->{'Change State'} = '';
    $Self->{Translation}->{'Created By'} = '';
    $Self->{Translation}->{'WorkOrder State'} = '';
    $Self->{Translation}->{'WorkOrder Type'} = '';
    $Self->{Translation}->{'WorkOrder Agent'} = '';
    $Self->{Translation}->{'Planned Start Time'} = '';
    $Self->{Translation}->{'Planned End Time'} = '';
    $Self->{Translation}->{'Actual Start Time'} = '';
    $Self->{Translation}->{'Actual End Time'} = '';
    $Self->{Translation}->{'Change Time'} = '';
    $Self->{Translation}->{'before'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeTemplate.pm
    $Self->{Translation}->{'The change "%s" could not be serialized.'} = '';
    $Self->{Translation}->{'Could not update the template "%s".'} = '';
    $Self->{Translation}->{'Could not delete change "%s".'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeTimeSlot.pm
    $Self->{Translation}->{'The change can\'t be moved, as it has no workorders.'} = '';
    $Self->{Translation}->{'Add a workorder first.'} = '';
    $Self->{Translation}->{'Can\'t move a change which already has started!'} = '';
    $Self->{Translation}->{'Please move the individual workorders instead.'} = '';
    $Self->{Translation}->{'The current %s could not be determined.'} = '';
    $Self->{Translation}->{'The %s of all workorders has to be defined.'} = '';
    $Self->{Translation}->{'Was not able to move time slot for workorder #%s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateDelete.pm
    $Self->{Translation}->{'You need %s permission!'} = '';
    $Self->{Translation}->{'No TemplateID is given!'} = '';
    $Self->{Translation}->{'Template "%s" not found in database!'} = '';
    $Self->{Translation}->{'Was not able to delete the template %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEdit.pm
    $Self->{Translation}->{'Was not able to update Template %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditCAB.pm
    $Self->{Translation}->{'Was not able to update Template "%s"!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditContent.pm
    $Self->{Translation}->{'Was not able to create change!'} = '';
    $Self->{Translation}->{'Was not able to create workorder from template!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateOverview.pm
    $Self->{Translation}->{'Overview: Template'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAdd.pm
    $Self->{Translation}->{'You need %s permissions on the change!'} = '';
    $Self->{Translation}->{'Was not able to add workorder!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAgent.pm
    $Self->{Translation}->{'No WorkOrderID is given!'} = '';
    $Self->{Translation}->{'Was not able to set the workorder agent of the workorder "%s" to empty!'} =
        '';
    $Self->{Translation}->{'Was not able to update the workorder "%s"!'} = '';
    $Self->{Translation}->{'Could not find Change for WorkOrder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderDelete.pm
    $Self->{Translation}->{'Was not able to delete the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderEdit.pm
    $Self->{Translation}->{'Was not able to update WorkOrder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no WorkOrderID is given!'} = '';
    $Self->{Translation}->{'WorkOrder "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrderHistory::'} = '';
    $Self->{Translation}->{'WorkOrder History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistoryZoom.pm
    $Self->{Translation}->{'History entry "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrder History Zoom'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTake.pm
    $Self->{Translation}->{'Was not able to take the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTemplate.pm
    $Self->{Translation}->{'The workorder "%s" could not be serialized.'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyWorkOrders.pm
    $Self->{Translation}->{'My Work Orders'} = 'Мои Задачи';

}

1;
