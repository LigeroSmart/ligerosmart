# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sr_Cyrl_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category ↔ Impact ↔ Priority'} = 'Категорија ↔ утицај ↔ приоритет';
    $Self->{Translation}->{'Manage the priority result of combinating Category ↔ Impact.'} =
        'Управљање резултатом приоритета комбинацијом категорија ↔ утицај.';
    $Self->{Translation}->{'Priority allocation'} = 'Расподела приоритета';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'Управљање обавештењима у ITSM управљању променама';
    $Self->{Translation}->{'Add Notification Rule'} = 'Додај правило обавештавања';
    $Self->{Translation}->{'Edit Notification Rule'} = 'Уреди правило обавештавања';
    $Self->{Translation}->{'A notification should have a name!'} = 'Обавештење треба да има име!';
    $Self->{Translation}->{'Name is required.'} = 'Име је обавезно.';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'Администарција машине стања';
    $Self->{Translation}->{'Select a catalog class!'} = 'Избор класе каталога!';
    $Self->{Translation}->{'A catalog class is required!'} = 'Класа каталога је обавезна!';
    $Self->{Translation}->{'Add a state transition'} = 'Додај транзицију статуса';
    $Self->{Translation}->{'Catalog Class'} = 'Класа';
    $Self->{Translation}->{'Object Name'} = 'Назив објекта';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Преглед преко транзиције статуса за';
    $Self->{Translation}->{'Delete this state transition'} = 'Обриши ову транзицију статуса';
    $Self->{Translation}->{'Add a new state transition for'} = 'Додај нову транзицију статуса за';
    $Self->{Translation}->{'Please select a state!'} = 'Молимо да одаберете стање!';
    $Self->{Translation}->{'Please select a next state!'} = 'Молимо да одаберете следеће стање!';
    $Self->{Translation}->{'Edit a state transition for'} = 'Уреди транзицију статуса за';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Да ли заиста желите да обришете ову транзицију статуса?';

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'Додај промену';
    $Self->{Translation}->{'ITSM Change'} = 'ITSM промена';
    $Self->{Translation}->{'Justification'} = 'Оправдање';
    $Self->{Translation}->{'Input invalid.'} = 'Неисправан унос.';
    $Self->{Translation}->{'Impact'} = 'Утицај';
    $Self->{Translation}->{'Requested Date'} = 'Тражени датум';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'Изабери шаблон промене';
    $Self->{Translation}->{'Time type'} = 'Тип времена';
    $Self->{Translation}->{'Invalid time type.'} = 'Неисправан тип времена.';
    $Self->{Translation}->{'New time'} = 'Ново време';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'Сачувај промену CAB као шаблон';
    $Self->{Translation}->{'go to involved persons screen'} = 'иди на екран укључених особа';
    $Self->{Translation}->{'Invalid Name'} = 'Погрешно име';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Услови и акције';
    $Self->{Translation}->{'Delete Condition'} = 'Услов брисања';
    $Self->{Translation}->{'Add new condition'} = 'Додај нови услов';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Edit Condition'} = 'Уреди услов';
    $Self->{Translation}->{'Need a valid name.'} = 'Потребно је исправно име.';
    $Self->{Translation}->{'A valid name is needed.'} = 'Неопходно је важеће име.';
    $Self->{Translation}->{'Duplicate name:'} = 'Дупликат имена:';
    $Self->{Translation}->{'This name is already used by another condition.'} = 'ово име је већ употребљено за други услов.';
    $Self->{Translation}->{'Matching'} = 'Подударање';
    $Self->{Translation}->{'Any expression (OR)'} = 'Сваки израз (OR)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Сви изрази (AND)';
    $Self->{Translation}->{'Expressions'} = 'Изрази';
    $Self->{Translation}->{'Selector'} = 'Бирач';
    $Self->{Translation}->{'Operator'} = 'Оператор';
    $Self->{Translation}->{'Delete Expression'} = 'Обриши израз';
    $Self->{Translation}->{'No Expressions found.'} = 'Није пронађен ниједан израз.';
    $Self->{Translation}->{'Add new expression'} = 'Додај нов израз';
    $Self->{Translation}->{'Delete Action'} = 'Обриши акцију';
    $Self->{Translation}->{'No Actions found.'} = 'Није пронађена ниједна акција.';
    $Self->{Translation}->{'Add new action'} = 'Додај нову акцију';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = 'Да ли заиста желите да избришете ову промену?';

    # Template: AgentITSMChangeEdit
    $Self->{Translation}->{'Edit %s%s'} = 'Уреди %s%s';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of %s%s'} = 'Историјат од %s%s';
    $Self->{Translation}->{'History Content'} = 'Садржај историјата';
    $Self->{Translation}->{'Workorder'} = 'Радни налог';
    $Self->{Translation}->{'Createtime'} = 'Време креирања';
    $Self->{Translation}->{'Show details'} = 'Прикажи детаље';
    $Self->{Translation}->{'Show workorder'} = 'Прикажи радни налог';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of %s'} = 'Детаљни историјат за %s';
    $Self->{Translation}->{'Modified'} = 'Промењено';
    $Self->{Translation}->{'Old Value'} = 'Стара вредност';
    $Self->{Translation}->{'New Value'} = 'Нова вредност';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Edit Involved Persons of %s%s'} = 'Уреди укључене особе за %s%s';
    $Self->{Translation}->{'Involved Persons'} = 'Укључене особе';
    $Self->{Translation}->{'ChangeManager'} = 'Управљач променама';
    $Self->{Translation}->{'User invalid.'} = 'Неисправан корисник.';
    $Self->{Translation}->{'ChangeBuilder'} = 'Градитељ промене';
    $Self->{Translation}->{'Change Advisory Board'} = 'Саветодавни одбор за промене';
    $Self->{Translation}->{'CAB Template'} = 'CAB шаблон';
    $Self->{Translation}->{'Apply Template'} = 'Примени шаблон';
    $Self->{Translation}->{'NewTemplate'} = 'Нови шаблон';
    $Self->{Translation}->{'Save this CAB as template'} = 'Сачувај ово као CAB шаблон';
    $Self->{Translation}->{'Add to CAB'} = 'Додај у CAB';
    $Self->{Translation}->{'Invalid User'} = 'Погрешан корисник';
    $Self->{Translation}->{'Current CAB'} = 'Актуелни CAB';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Подешавање контекста';
    $Self->{Translation}->{'Changes per page'} = 'Промена по страни';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'Workorder Title'} = 'Наслов радног налога';
    $Self->{Translation}->{'Change Title'} = 'Наслов промене';
    $Self->{Translation}->{'Workorder Agent'} = 'Оператер за радни налог';
    $Self->{Translation}->{'Change Builder'} = 'Градитељ промене';
    $Self->{Translation}->{'Change Manager'} = 'Управљање променама';
    $Self->{Translation}->{'Workorders'} = 'Радни налози';
    $Self->{Translation}->{'Change State'} = 'Стање промене';
    $Self->{Translation}->{'Workorder State'} = 'Стање радног налога';
    $Self->{Translation}->{'Workorder Type'} = 'Тип радног налога';
    $Self->{Translation}->{'Requested Time'} = 'Тражено време';
    $Self->{Translation}->{'Planned Start Time'} = 'Планирано време почетка';
    $Self->{Translation}->{'Planned End Time'} = 'Планирано време завршетка';
    $Self->{Translation}->{'Actual Start Time'} = 'Стварно време почетка';
    $Self->{Translation}->{'Actual End Time'} = 'Стварно време завршетка';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = 'Да ли заиста желите да поништите ову промену?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(нпр 10*5155 или 105658*)';
    $Self->{Translation}->{'CAB Agent'} = 'Оператер CAB';
    $Self->{Translation}->{'e.g.'} = 'нпр.';
    $Self->{Translation}->{'CAB Customer'} = 'CAB клијент';
    $Self->{Translation}->{'ITSM Workorder Instruction'} = 'Упутство ITSM радног налога';
    $Self->{Translation}->{'ITSM Workorder Report'} = 'Извештај ITSM радног налога';
    $Self->{Translation}->{'ITSM Change Priority'} = 'Приоритет ITSM промене';
    $Self->{Translation}->{'ITSM Change Impact'} = 'Утицај ITSM промене';
    $Self->{Translation}->{'Change Category'} = 'Категорија промене';
    $Self->{Translation}->{'(before/after)'} = '(пре/после)';
    $Self->{Translation}->{'(between)'} = '(између)';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Сачувај промену као шаблон';
    $Self->{Translation}->{'A template should have a name!'} = 'Шаблон треба да има име!';
    $Self->{Translation}->{'The template name is required.'} = 'Име шаблона је обавезно.';
    $Self->{Translation}->{'Reset States'} = 'Поништи стања';
    $Self->{Translation}->{'Overwrite original template'} = 'Препиши преко оригиналног шаблона';
    $Self->{Translation}->{'Delete original change'} = 'Обриши оригиналну промену';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Помери временски термин';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'Информација о промени';
    $Self->{Translation}->{'Planned Effort'} = 'Планирани напор';
    $Self->{Translation}->{'Accounted Time'} = 'Обрачунато време';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Иницијатор(и) промене';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Задњи пут промењено';
    $Self->{Translation}->{'Last changed by'} = 'Променио';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Да бисте отворили везе у следећим блоковима описа, можда ћете требати да притиснете "Ctrl" или "Cmd" или "Shift" тастер док истовремено кликнете на везу (зависи од вашег оперативног система и претраживача).';
    $Self->{Translation}->{'Download Attachment'} = 'Преузми прилог';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = 'Уреди CAB шаблон';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        'Ово ће креирати нову промену од овог шаблона, па је можете изменити и сачувати.';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        'Нова промена ће аутоматски бити обрисана, кад буде сачувана као шаблон.';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        'Ово ће креирати нов радни налог од овог шаблона, па га можете изменити и сачувати.';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        'Биће креирана привремена промена која садржи радни налог.';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        'Привремана промена и нови радни налог ће аутоматски бити обрисани, кад радни налог буде сачуван као шаблон.';
    $Self->{Translation}->{'Do you want to proceed?'} = 'Да ли желите да наставите?';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'Template ID'} = 'ID шаблона';
    $Self->{Translation}->{'Edit Content'} = 'Уреди садржај';
    $Self->{Translation}->{'Create by'} = 'Креирао';
    $Self->{Translation}->{'Change by'} = 'Изменио';
    $Self->{Translation}->{'Change Time'} = 'Време промене';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to %s%s'} = 'Додај радни налог у %s%s';
    $Self->{Translation}->{'Instruction'} = 'Инструкција';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Неисправан тип радног налога.';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'Планирано време почетка мора бити пре планираног времена завршетка!';
    $Self->{Translation}->{'Invalid format.'} = 'Неисправан формат.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Изабери шаблон радног налога';

    # Template: AgentITSMWorkOrderAgent
    $Self->{Translation}->{'Edit Workorder Agent of %s%s'} = 'Уреди корисника радног налога за %s%s';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Да ли заиста желите да избришете овај радни налог?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Не можете обрисати овај радни налог. Употребљен је у бар једном услову';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Овај радни налог је употребљен у следећим условима';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Edit %s%s-%s'} = 'Уреди %s%s-%s';
    $Self->{Translation}->{'Move following workorders accordingly'} = 'Померите адекватно следеће радне налоге';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        'Планирано време завршетка овог радног налога је промењено, планирана времена почетка свих наредних радних налога ће бити адекватно усклађена';

    # Template: AgentITSMWorkOrderHistory
    $Self->{Translation}->{'History of %s%s-%s'} = 'Историјат за %s%s-%s';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'Edit Report of %s%s-%s'} = 'Уреди извештај за %s%s-%s';
    $Self->{Translation}->{'Report'} = 'Извештај';
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'Актуелно време почетка мора бити пре актуелног времена завршетка!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'Актуелно време почетка мора бити подешено када је подешено и актуелно време завршетка!';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Актуелни оператер';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Да ли заиста желите да преузмете овај радни налог?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Сачувај радни налог као шаблон';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = 'Обриши оригинални радни налог (и промену у којој је)';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Информација о радном налогу';

    # Perl Module: Kernel/Modules/AdminITSMChangeNotification.pm
    $Self->{Translation}->{'Notification Added!'} = 'Додато обавештење!';
    $Self->{Translation}->{'Unknown notification %s!'} = 'Непознато обавештење %s!';
    $Self->{Translation}->{'There was an error creating the notification.'} = 'Дошло је до грешке приликом креирања обавештења.';

    # Perl Module: Kernel/Modules/AdminITSMStateMachine.pm
    $Self->{Translation}->{'State Transition Updated!'} = 'Ажурирано транзиционо стање!';
    $Self->{Translation}->{'State Transition Added!'} = 'Додато транзиционо стање!';

    # Perl Module: Kernel/Modules/AgentITSMChange.pm
    $Self->{Translation}->{'Overview: ITSM Changes'} = 'Преглед: ITSM промене';

    # Perl Module: Kernel/Modules/AgentITSMChangeAdd.pm
    $Self->{Translation}->{'Ticket with TicketID %s does not exist!'} = 'Тикет са TicketID %s не постоји!';
    $Self->{Translation}->{'Missing sysconfig option "ITSMChange::AddChangeLinkTicketTypes"!'} =
        'Недостаје опција системске конфигурације "ITSMChange::AddChangeLinkTicketTypes"!';
    $Self->{Translation}->{'Was not able to add change!'} = 'Није било могуће додати промену!';

    # Perl Module: Kernel/Modules/AgentITSMChangeAddFromTemplate.pm
    $Self->{Translation}->{'Was not able to create change from template!'} = 'Није било могуће креирати промену из шаблона!';

    # Perl Module: Kernel/Modules/AgentITSMChangeCABTemplate.pm
    $Self->{Translation}->{'No ChangeID is given!'} = 'Није дат ChangeID!';
    $Self->{Translation}->{'No change found for changeID %s.'} = 'Није пронађена промена за ChangeID %s.';
    $Self->{Translation}->{'The CAB of change "%s" could not be serialized.'} = 'CAB промене %s се не може серијализовати.';
    $Self->{Translation}->{'Could not add the template.'} = 'Није могуће додати шаблон.';

    # Perl Module: Kernel/Modules/AgentITSMChangeCondition.pm
    $Self->{Translation}->{'Change "%s" not found in database!'} = 'Промена "%s" није нађена у бази података!';
    $Self->{Translation}->{'Could not delete ConditionID %s!'} = 'Није могуће обрисати ConditionID %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeConditionEdit.pm
    $Self->{Translation}->{'No %s is given!'} = 'Није дат %s!';
    $Self->{Translation}->{'Could not create new condition!'} = 'Није могуће креирати нови услов!';
    $Self->{Translation}->{'Could not update ConditionID %s!'} = 'Није могуће ажурирати ConditionID %s!';
    $Self->{Translation}->{'Could not update ExpressionID %s!'} = 'Није могуће ажурирати ExpressionID %s!';
    $Self->{Translation}->{'Could not add new Expression!'} = 'Није могуће додати нови Expression!';
    $Self->{Translation}->{'Could not update ActionID %s!'} = 'Није могуће ажурирати ActionID %s!';
    $Self->{Translation}->{'Could not add new Action!'} = 'Није могуће додати нови Action!';
    $Self->{Translation}->{'Could not delete ExpressionID %s!'} = 'Није могуће обрисати ExpressionID %s!';
    $Self->{Translation}->{'Could not delete ActionID %s!'} = 'Није могуће обрисати ActionID %s!';
    $Self->{Translation}->{'Error: Unknown field type "%s"!'} = 'Грешка: Непознат тип поља "%s"!';
    $Self->{Translation}->{'ConditionID %s does not belong to the given ChangeID %s!'} = 'ConditionID %s не припада датом ChangeID %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeDelete.pm
    $Self->{Translation}->{'Change "%s" does not have an allowed change state to be deleted!'} =
        'Промена "%s" није у дозвољеном стању да би била обрисана!';
    $Self->{Translation}->{'Was not able to delete the changeID %s!'} = 'Није било могуће обрисати ChangeID %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeEdit.pm
    $Self->{Translation}->{'Was not able to update Change!'} = 'Није било могуће ажурирати промену!';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ChangeID is given!'} = 'Не може се приказати историјат, јер није дат ChangeID!';
    $Self->{Translation}->{'Change "%s" not found in the database!'} = 'Промена "%s" није нађена у бази података!';
    $Self->{Translation}->{'Unknown type "%s" encountered!'} = 'Непознат тип "%s"!';
    $Self->{Translation}->{'Change History'} = 'Историјат промене';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistoryZoom.pm
    $Self->{Translation}->{'Can\'t show history zoom, no HistoryEntryID is given!'} = 'Не могу се приказати детаљи историјата јер није дат HistoryEntryID!';
    $Self->{Translation}->{'HistoryEntry "%s" not found in database!'} = 'Ставка историјата "%s" није нађена у бази података!';

    # Perl Module: Kernel/Modules/AgentITSMChangeInvolvedPersons.pm
    $Self->{Translation}->{'Was not able to update Change CAB for Change %s!'} = 'Није било могуће ажурирати CAB промен за промену %s!';
    $Self->{Translation}->{'Was not able to update Change %s!'} = 'Није било могуће ажурирати промену %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeManager.pm
    $Self->{Translation}->{'Overview: ChangeManager'} = 'Преглед: Управљач променама';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyCAB.pm
    $Self->{Translation}->{'Overview: My CAB'} = 'Преглед: Мој CAB';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyChanges.pm
    $Self->{Translation}->{'Overview: My Changes'} = 'Преглед: Моје промене';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyWorkOrders.pm
    $Self->{Translation}->{'Overview: My Workorders'} = 'Преглед: Моји радни налози';

    # Perl Module: Kernel/Modules/AgentITSMChangePIR.pm
    $Self->{Translation}->{'Overview: PIR'} = 'Преглед: PIR';

    # Perl Module: Kernel/Modules/AgentITSMChangePSA.pm
    $Self->{Translation}->{'Overview: PSA'} = 'Преглед: PSA';

    # Perl Module: Kernel/Modules/AgentITSMChangePrint.pm
    $Self->{Translation}->{'WorkOrder "%s" not found in database!'} = 'Радни налог "%s" није нађен у бази података!';
    $Self->{Translation}->{'Can\'t create output, as the workorder is not attached to a change!'} =
        'Не може се крирати излаз јер радни налог није придодат промени!';
    $Self->{Translation}->{'Can\'t create output, as no ChangeID is given!'} = 'Не може се крирати излаз јер није дат ChangeID!';
    $Self->{Translation}->{'unknown change title'} = 'непознат наслов промене';
    $Self->{Translation}->{'ITSM Workorder'} = 'ITSM радни налог';
    $Self->{Translation}->{'WorkOrderNumber'} = 'Број радног налога';
    $Self->{Translation}->{'WorkOrderTitle'} = 'Радни налог - наслов';
    $Self->{Translation}->{'unknown workorder title'} = 'непознат наслов радног налога';
    $Self->{Translation}->{'ChangeState'} = 'Промена - статус';
    $Self->{Translation}->{'PlannedEffort'} = 'Планирани напор';
    $Self->{Translation}->{'CAB Agents'} = 'Оператери CAB';
    $Self->{Translation}->{'CAB Customers'} = 'CAB клијенти';
    $Self->{Translation}->{'RequestedTime'} = 'Тражено време';
    $Self->{Translation}->{'PlannedStartTime'} = 'Планирано време почетка';
    $Self->{Translation}->{'PlannedEndTime'} = 'Планирано време завршетка';
    $Self->{Translation}->{'ActualStartTime'} = 'Стварно време почетка';
    $Self->{Translation}->{'ActualEndTime'} = 'Стварно време завршетка';
    $Self->{Translation}->{'ChangeTime'} = 'Време промене';
    $Self->{Translation}->{'ChangeNumber'} = 'Број промене';
    $Self->{Translation}->{'WorkOrderState'} = 'Радни налог - статус';
    $Self->{Translation}->{'WorkOrderType'} = 'Радни налог - тип';
    $Self->{Translation}->{'WorkOrderAgent'} = 'Радни налог - оператер';
    $Self->{Translation}->{'ITSM Workorder Overview (%s)'} = 'Преглед ITSM радног налога (%s)';

    # Perl Module: Kernel/Modules/AgentITSMChangeReset.pm
    $Self->{Translation}->{'Was not able to reset WorkOrder %s of Change %s!'} = 'Није било могуће поништити радни налог %s за промену %s!';
    $Self->{Translation}->{'Was not able to reset Change %s!'} = 'Није било могуће поништити промену %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeSchedule.pm
    $Self->{Translation}->{'Overview: Change Schedule'} = 'Преглед: Планер промена';

    # Perl Module: Kernel/Modules/AgentITSMChangeSearch.pm
    $Self->{Translation}->{'Change Search'} = 'Претрага промена';
    $Self->{Translation}->{'ChangeTitle'} = 'Промена - наслов';
    $Self->{Translation}->{'WorkOrders'} = 'Радни налози';
    $Self->{Translation}->{'Change Search Result'} = 'Резултат претраге промена';
    $Self->{Translation}->{'Change Number'} = 'Број промене';
    $Self->{Translation}->{'Work Order Title'} = 'Наслов радног налога';
    $Self->{Translation}->{'Change Description'} = 'Опис промене';
    $Self->{Translation}->{'Change Justification'} = 'Оправданост промене';
    $Self->{Translation}->{'WorkOrder Instruction'} = 'Упутсво за радни налог';
    $Self->{Translation}->{'WorkOrder Report'} = 'Извештај радног налога';
    $Self->{Translation}->{'Change Priority'} = 'Приоритет промене';
    $Self->{Translation}->{'Change Impact'} = 'Утицај промене';
    $Self->{Translation}->{'Created By'} = 'Креирао';
    $Self->{Translation}->{'WorkOrder State'} = 'Стање радног налога';
    $Self->{Translation}->{'WorkOrder Type'} = 'Тип радног налога';
    $Self->{Translation}->{'WorkOrder Agent'} = 'Оператер за радни налог';
    $Self->{Translation}->{'before'} = 'пре';

    # Perl Module: Kernel/Modules/AgentITSMChangeTemplate.pm
    $Self->{Translation}->{'The change "%s" could not be serialized.'} = 'Промена %s се не може серијализовати.';
    $Self->{Translation}->{'Could not update the template "%s".'} = 'Није могуће ажурирати шаблон "%s".';
    $Self->{Translation}->{'Could not delete change "%s".'} = 'Није могуће обрисати промену "%s".';

    # Perl Module: Kernel/Modules/AgentITSMChangeTimeSlot.pm
    $Self->{Translation}->{'The change can\'t be moved, as it has no workorders.'} = 'Промена се не може померити јер нема радне налоге.';
    $Self->{Translation}->{'Add a workorder first.'} = 'Прво додај радни налог.';
    $Self->{Translation}->{'Can\'t move a change which already has started!'} = 'Промена која је већ покренута се не може померати!';
    $Self->{Translation}->{'Please move the individual workorders instead.'} = 'Молимо да уместо тога померите поједине радне налоге.';
    $Self->{Translation}->{'The current %s could not be determined.'} = 'Актуелна %s се не може одредити.';
    $Self->{Translation}->{'The %s of all workorders has to be defined.'} = '%s свих радних налога треба да буде дефинисан.';
    $Self->{Translation}->{'Was not able to move time slot for workorder #%s!'} = 'Није било могуће преместити термин за радни налог #%s!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateDelete.pm
    $Self->{Translation}->{'You need %s permission!'} = 'Потребна вам је %s дозвола!';
    $Self->{Translation}->{'No TemplateID is given!'} = 'Није дат TemplateID!';
    $Self->{Translation}->{'Template "%s" not found in database!'} = 'Шаблон "%s" није нађен у бази података!';
    $Self->{Translation}->{'Was not able to delete the template %s!'} = 'Није било могуће обрисати шаблон %s!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEdit.pm
    $Self->{Translation}->{'Was not able to update Template %s!'} = 'Није било могуће ажурирати шаблон %s!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditCAB.pm
    $Self->{Translation}->{'Was not able to update Template "%s"!'} = 'Није било могуће ажурирати шаблон "%s"!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditContent.pm
    $Self->{Translation}->{'Was not able to create change!'} = 'Није било могуће креирати промену!';
    $Self->{Translation}->{'Was not able to create workorder from template!'} = 'Није било могуће креирати радни налог из промене!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateOverview.pm
    $Self->{Translation}->{'Overview: Template'} = 'Преглед: Шаблон';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAdd.pm
    $Self->{Translation}->{'You need %s permissions on the change!'} = 'Потребне су вам %s дозволе за промену!';
    $Self->{Translation}->{'Was not able to add workorder!'} = 'Није било могуће додати радни налог!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAgent.pm
    $Self->{Translation}->{'No WorkOrderID is given!'} = 'Није дат WorkOrderID!';
    $Self->{Translation}->{'Was not able to set the workorder agent of the workorder "%s" to empty!'} =
        'Није било могуће подесити радни налог "%s" без оператера!';
    $Self->{Translation}->{'Was not able to update the workorder "%s"!'} = 'Није било могуће ажурирати радни налог "%s"!';
    $Self->{Translation}->{'Could not find Change for WorkOrder %s!'} = 'Није могуће пронаћи промену за радни налог %s!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderDelete.pm
    $Self->{Translation}->{'Was not able to delete the workorder %s!'} = 'Није било могуће обрисати радни налог %s!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderEdit.pm
    $Self->{Translation}->{'Was not able to update WorkOrder %s!'} = 'Није било могуће ажурирати радни налог %s!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no WorkOrderID is given!'} = 'Не може се приказати историјат јер није дат WorkOrderID!';
    $Self->{Translation}->{'WorkOrder "%s" not found in the database!'} = 'Радни налог "%s" није нађен у бази података!';
    $Self->{Translation}->{'WorkOrder History'} = 'Историјат радног налога';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistoryZoom.pm
    $Self->{Translation}->{'History entry "%s" not found in the database!'} = 'Ставка историјата "%s" није нађена у бази података!';
    $Self->{Translation}->{'WorkOrder History Zoom'} = 'Детаљи историјата радног налога';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTake.pm
    $Self->{Translation}->{'Was not able to take the workorder %s!'} = 'Није било могуће преузети радни налог %s!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTemplate.pm
    $Self->{Translation}->{'The workorder "%s" could not be serialized.'} = 'Радни налог "%s" се не може серијализовати.';

    # Perl Module: Kernel/Output/HTML/Layout/ITSMChange.pm
    $Self->{Translation}->{'Need config option %s!'} = 'Потребна конфигурациона опција %s!';
    $Self->{Translation}->{'Config option %s needs to be a HASH ref!'} = 'Конфигурациона опција %s мора бити HASH референца!';
    $Self->{Translation}->{'No config option found for the view "%s"!'} = 'Није пронађена конфигурациона ставка за преглед "%s"!';
    $Self->{Translation}->{'Title: %s | Type: %s'} = 'Наслов: %s | Тип: %s';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyCAB.pm
    $Self->{Translation}->{'My CABs'} = 'Моји CAB';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyChanges.pm
    $Self->{Translation}->{'My Changes'} = 'Моје промене';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyWorkOrders.pm
    $Self->{Translation}->{'My Work Orders'} = 'Моји радни налози';

    # Perl Module: Kernel/System/ITSMChange/History.pm
    $Self->{Translation}->{'%s: %s'} = '%s: %s';
    $Self->{Translation}->{'New Action (ID=%s)'} = 'Нова акција (ID=%s)';
    $Self->{Translation}->{'Action (ID=%s) deleted'} = 'Обрисана акција (ID=%s)';
    $Self->{Translation}->{'All Actions of Condition (ID=%s) deleted'} = 'Обрисане све акције услова (ID=%s)';
    $Self->{Translation}->{'Action (ID=%s) executed: %s'} = 'Извршена акција (ID=%s): %s';
    $Self->{Translation}->{'%s (Action ID=%s): (new=%s, old=%s)'} = '%s (акција ID=%s): (ново=%s, старо=%s)';
    $Self->{Translation}->{'Change (ID=%s) reached actual end time.'} = 'Промена (ID=%s) је достигла стварно време завршетка.';
    $Self->{Translation}->{'Change (ID=%s) reached actual start time.'} = 'Промена (ID=%s) је достигла стварно време почетка.';
    $Self->{Translation}->{'New Change (ID=%s)'} = 'Нова промена (ID=%s)';
    $Self->{Translation}->{'New Attachment: %s'} = 'Нов прилог: %s';
    $Self->{Translation}->{'Deleted Attachment %s'} = 'Обрисан прилог %s';
    $Self->{Translation}->{'CAB Deleted %s'} = 'Обрисан CAB %s';
    $Self->{Translation}->{'%s: (new=%s, old=%s)'} = '%s: (ново=%s, старо=%s)';
    $Self->{Translation}->{'Link to %s (ID=%s) added'} = 'Повезано са %s (ID=%s)';
    $Self->{Translation}->{'Link to %s (ID=%s) deleted'} = 'Обрисана веза са %s (ID=%s)';
    $Self->{Translation}->{'Notification sent to %s (Event: %s)'} = 'Послато обавештење %s (догађај: %s)';
    $Self->{Translation}->{'Change (ID=%s) reached planned end time.'} = 'Промена (ID=%s) је достигла планирано време завршетка.';
    $Self->{Translation}->{'Change (ID=%s) reached planned start time.'} = 'Промена (ID=%s) је достигла планирано време почетка.';
    $Self->{Translation}->{'Change (ID=%s) reached requested time.'} = 'Промена (ID=%s) је достигла тражено време.';
    $Self->{Translation}->{'New Condition (ID=%s)'} = 'Нов услов (ID=%s)';
    $Self->{Translation}->{'Condition (ID=%s) deleted'} = 'Обрисан услов (ID=%s)';
    $Self->{Translation}->{'All Conditions of Change (ID=%s) deleted'} = 'Обрисани сви услови промене (ID=%s)';
    $Self->{Translation}->{'%s (Condition ID=%s): (new=%s, old=%s)'} = '%s (услов ID=%s): (ново=%s, старо=%s)';
    $Self->{Translation}->{'New Expression (ID=%s)'} = 'Нов израз (ID=%s)';
    $Self->{Translation}->{'Expression (ID=%s) deleted'} = 'Обрисан израз (ID=%s)';
    $Self->{Translation}->{'All Expressions of Condition (ID=%s) deleted'} = 'Обрисани сви изрази услова (ID=%s)';
    $Self->{Translation}->{'%s (Expression ID=%s): (new=%s, old=%s)'} = '%s (израз ID=%s): (ново=%s, старо=%s)';
    $Self->{Translation}->{'Workorder (ID=%s) reached actual end time.'} = 'Радни налог (ID=%s) је достигао стварно време завршетка.';
    $Self->{Translation}->{'Workorder (ID=%s) reached actual start time.'} = 'Радни налог (ID=%s) је достигао стварно време почетка.';
    $Self->{Translation}->{'New Workorder (ID=%s)'} = 'Нови радни налог (ID=%s)';
    $Self->{Translation}->{'New Attachment for WorkOrder: %s'} = 'Нов прилог за радни налог: %s';
    $Self->{Translation}->{'(ID=%s) New Attachment for WorkOrder: %s'} = '(ID=%s) Нов прилог за радни налог: %s';
    $Self->{Translation}->{'Deleted Attachment from WorkOrder: %s'} = 'Обрисан прилог за радни налог: %s';
    $Self->{Translation}->{'(ID=%s) Deleted Attachment from WorkOrder: %s'} = '(ID=%s) Обрисан прилог за радни налог: %s';
    $Self->{Translation}->{'New Report Attachment for WorkOrder: %s'} = 'Нов прилог извештаја за радни налог: %s';
    $Self->{Translation}->{'(ID=%s) New Report Attachment for WorkOrder: %s'} = '(ID=%s) Нов прилог извештаја за радни налог: %s';
    $Self->{Translation}->{'Deleted Report Attachment from WorkOrder: %s'} = 'Обрисан прилог извештаја за радни налог: %s';
    $Self->{Translation}->{'(ID=%s) Deleted Report Attachment from WorkOrder: %s'} = '(ID=%s) Обрисан прилог извештаја за радни налог: %s';
    $Self->{Translation}->{'Workorder (ID=%s) deleted'} = 'Обрисан радни налог (ID=%s)';
    $Self->{Translation}->{'(ID=%s) Link to %s (ID=%s) added'} = '(ID=%s) Повезано са %s (ID=%s)';
    $Self->{Translation}->{'(ID=%s) Link to %s (ID=%s) deleted'} = '(ID=%s) Обрисана веза са %s (ID=%s)';
    $Self->{Translation}->{'(ID=%s) Notification sent to %s (Event: %s)'} = '(ID=%s) Послато обавештење %s (догађај: %s)';
    $Self->{Translation}->{'Workorder (ID=%s) reached planned end time.'} = 'Радни налог (ID=%s) је достигао планирано време завршетка.';
    $Self->{Translation}->{'Workorder (ID=%s) reached planned start time.'} = 'Радни налог (ID=%s) је достигао планирано време почетка.';
    $Self->{Translation}->{'(ID=%s) %s: (new=%s, old=%s)'} = '(ID=%s) %s: (ново=%s, старо=%s)';

    # Perl Module: Kernel/System/ITSMChange/ITSMCondition/Object/ITSMWorkOrder.pm
    $Self->{Translation}->{'all'} = 'sve';
    $Self->{Translation}->{'any'} = 'сваки';

    # Perl Module: Kernel/System/ITSMChange/Notification.pm
    $Self->{Translation}->{'Previous Change Builder'} = 'Претходни градитељ промене';
    $Self->{Translation}->{'Previous Change Manager'} = 'Претходни управних промене';
    $Self->{Translation}->{'Workorder Agents'} = 'Оператери радног налога';
    $Self->{Translation}->{'Previous Workorder Agent'} = 'Претходни оператер радног налога';
    $Self->{Translation}->{'Change Initiators'} = 'Иницијатори промене';
    $Self->{Translation}->{'Group ITSMChange'} = 'Група ITSMChange';
    $Self->{Translation}->{'Group ITSMChangeBuilder'} = 'Група ITSMChangeBuilder';
    $Self->{Translation}->{'Group ITSMChangeManager'} = 'Група ITSMChangeManager';

    # Database XML Definition: ITSMChangeManagement.sopm
    $Self->{Translation}->{'requested'} = 'захтевано';
    $Self->{Translation}->{'pending approval'} = 'одобрење на чекању';
    $Self->{Translation}->{'rejected'} = 'одбијено';
    $Self->{Translation}->{'approved'} = 'одобрено';
    $Self->{Translation}->{'in progress'} = 'у току';
    $Self->{Translation}->{'pending pir'} = 'PIR на чекању';
    $Self->{Translation}->{'successful'} = 'успешно';
    $Self->{Translation}->{'failed'} = 'неуспешно';
    $Self->{Translation}->{'canceled'} = 'отказано';
    $Self->{Translation}->{'retracted'} = 'повучено';
    $Self->{Translation}->{'created'} = 'креирано';
    $Self->{Translation}->{'accepted'} = 'прихваћено';
    $Self->{Translation}->{'ready'} = 'спремно';
    $Self->{Translation}->{'approval'} = 'одобрење';
    $Self->{Translation}->{'workorder'} = 'радни налог';
    $Self->{Translation}->{'backout'} = 'одустанак';
    $Self->{Translation}->{'decision'} = 'одлука';
    $Self->{Translation}->{'pir'} = 'PIR';
    $Self->{Translation}->{'ChangeStateID'} = 'ChangeStateID';
    $Self->{Translation}->{'CategoryID'} = 'ИД Категорије';
    $Self->{Translation}->{'ImpactID'} = 'ИД утицаја';
    $Self->{Translation}->{'PriorityID'} = 'ИД приоритета';
    $Self->{Translation}->{'ChangeManagerID'} = 'ChangeManagerID';
    $Self->{Translation}->{'ChangeBuilderID'} = 'ChangeBuilderID';
    $Self->{Translation}->{'WorkOrderStateID'} = 'WorkOrderStateID';
    $Self->{Translation}->{'WorkOrderTypeID'} = 'WorkOrderTypeID';
    $Self->{Translation}->{'WorkOrderAgentID'} = 'WorkOrderAgentID';
    $Self->{Translation}->{'is'} = 'је';
    $Self->{Translation}->{'is not'} = 'није';
    $Self->{Translation}->{'is empty'} = 'је празно';
    $Self->{Translation}->{'is not empty'} = 'није празно';
    $Self->{Translation}->{'is greater than'} = 'је веће од';
    $Self->{Translation}->{'is less than'} = 'је мање од';
    $Self->{Translation}->{'is before'} = 'је пре';
    $Self->{Translation}->{'is after'} = 'је после';
    $Self->{Translation}->{'contains'} = 'садржи';
    $Self->{Translation}->{'not contains'} = 'не садржи';
    $Self->{Translation}->{'begins with'} = 'почиње са';
    $Self->{Translation}->{'ends with'} = 'завршава са';
    $Self->{Translation}->{'set'} = 'подеси';

    # JS File: ITSM.Agent.ChangeManagement.Condition
    $Self->{Translation}->{'Do you really want to delete this expression?'} = 'Да ли стварно желите да обришете овај израз?';
    $Self->{Translation}->{'Do you really want to delete this action?'} = 'Да ли стварно желите да обришете ову акцију?';
    $Self->{Translation}->{'Do you really want to delete this condition?'} = 'Да ли заиста желите да обришете овај услов?';

    # JS File: ITSM.Agent.ChangeManagement.ConfirmDialog
    $Self->{Translation}->{'Ok'} = 'У реду';

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        'Листа оператера који имају дозволу преузимања радних налога. Кључ је корисничко име. Садржај је 0 или 1.';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        'Листа статуса радног налога, при којима ће актуелно време почетка радног налога, бити постављено ако је празно у овом моменту. ';
    $Self->{Translation}->{'Actual end time'} = 'Стварно време завршетка';
    $Self->{Translation}->{'Actual start time'} = 'Стварно време почетка';
    $Self->{Translation}->{'Add Workorder'} = 'Додај радни налог';
    $Self->{Translation}->{'Add Workorder (from Template)'} = 'Додај радни налог (од шаблона)';
    $Self->{Translation}->{'Add a change from template.'} = 'Додај промену из шаблона.';
    $Self->{Translation}->{'Add a change.'} = 'Додај промену.';
    $Self->{Translation}->{'Add a workorder (from template) to the change.'} = 'Додај радни налог промени (од шаблона).';
    $Self->{Translation}->{'Add a workorder to the change.'} = 'Додај радни налог промени.';
    $Self->{Translation}->{'Add from template'} = 'Додај из шаблона';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = 'Администрација CIP матрице.';
    $Self->{Translation}->{'Admin of the state machine.'} = 'Администрација машине стања';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        'Модул интерфејса оператера за обавештавање, преглед броја Саветодавних Одбора за Промене.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        'Модул интерфејса оператера за обавештавање, преглед броја промена којима управља корисник.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        'Модул интерфејса оператера за обавештавање, преглед броја промена.';
    $Self->{Translation}->{'Agent interface notification module to see the number of workorders.'} =
        'Модул обавештавања у интерфејсу оператера за приказ броја радних налога.';
    $Self->{Translation}->{'CAB Member Search'} = 'Претрага чланова CAB';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        'Време кеширања у минутама за алатне траке управљача променама. Подразумевано 3 сата (180 минута).';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        'Време кеширања у минутима за управљање променама. Подразумевано: 5 дана (7200 минута).';
    $Self->{Translation}->{'Change CAB Templates'} = 'Шаблони промена CAB';
    $Self->{Translation}->{'Change History.'} = 'Историјат промене.';
    $Self->{Translation}->{'Change Involved Persons.'} = 'Особе укључене у промену.';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = 'Ограничење прегледа промена малог формата';
    $Self->{Translation}->{'Change Overview.'} = 'Преглед промене.';
    $Self->{Translation}->{'Change Print.'} = 'Штампа промене.';
    $Self->{Translation}->{'Change Schedule'} = 'Планер промена';
    $Self->{Translation}->{'Change Schedule.'} = 'Планер промена.';
    $Self->{Translation}->{'Change Settings'} = 'Промени подешавања';
    $Self->{Translation}->{'Change Zoom'} = 'Детаљи промене.';
    $Self->{Translation}->{'Change Zoom.'} = 'Детаљи промене.';
    $Self->{Translation}->{'Change and Workorder Templates'} = 'Измени шаблоне радног налога';
    $Self->{Translation}->{'Change and workorder templates edited by this user.'} = 'Шаблони промена и радних налога које је мењао овај корисник.';
    $Self->{Translation}->{'Change area.'} = 'Простор промене.';
    $Self->{Translation}->{'Change involved persons of the change.'} = 'Измени особе укључене у ову промену.';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small".'} = 'Ограничење броја промена по страници за преглед малог формата.';
    $Self->{Translation}->{'Change number'} = 'Број промене';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = 'Позадински модул претраге за промене у интерфејсу оператера';
    $Self->{Translation}->{'Change state'} = 'Стање промене';
    $Self->{Translation}->{'Change time'} = 'Време промене';
    $Self->{Translation}->{'Change title'} = 'Наслов промене';
    $Self->{Translation}->{'Condition Edit'} = 'Уреди услов';
    $Self->{Translation}->{'Condition Overview'} = 'Преглед услова';
    $Self->{Translation}->{'Configure which screen should be shown after a new workorder has been created.'} =
        'Конфигурише који екран би требало приказати након креирања новог радног налога.';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        'Дефинише колико често се шаљу обавештења када су планирана времена почетка или друге временске вредности достигнута/прошла.';
    $Self->{Translation}->{'Create Change'} = 'Направи промену';
    $Self->{Translation}->{'Create Change (from Template)'} = 'Направи промену (од шаблона)';
    $Self->{Translation}->{'Create a change (from template) from this ticket.'} = 'Направи промену (од шаблона) из овог тикета.';
    $Self->{Translation}->{'Create a change from this ticket.'} = 'Направи промену из овог тикета.';
    $Self->{Translation}->{'Create and manage ITSM Change Management notifications.'} = 'Креирање и управљање обавештењима ITSM управљањем променама.';
    $Self->{Translation}->{'Create and manage change notifications.'} = 'Креирање и управљање обавештењима о промени.';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        'Подразумевени тип радног налога. Овај унос мора да постоји у класи општег каталога \'ITSM::ChangeManagement::WorkOrder::Type\'.';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'Дефинише акције где је дугме поставки доступно у повезаном графичком елементу објекта (LinkObject::ViewMode = "complex"). Молимо да имате на уму да ове Акције морају да буду регистроване у следећим JS и CSS датотекама: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js и Core.Agent.LinkObject.js.';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = 'Дефинише сигнале за сваки статус радног налога.';
    $Self->{Translation}->{'Define which columns are shown in the linked Changes widget (LinkObject::ViewMode = "complex"). Note: Only Change attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'Дефинише које колоне су приказане у повезаном графичком елементу промена (LinkObject::ViewMode = "complex"). Напомена: Само атрибути промене су дозвољени за подразумеване колоне. Могуће поставке: 0 = онемогућено, 1 = доступно, 2 = подразумевано активирано.';
    $Self->{Translation}->{'Define which columns are shown in the linked Workorder widget (LinkObject::ViewMode = "complex"). Note: Only Workorder attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'Дефинише које колоне су приказане у повезаном графичком елементу Радног налога (LinkObject::ViewMode = "complex"). Напомена: Само атрибути радног налога су дозвољени за подразумеване колоне. Могуће поставке: 0 = онемогућено, 1 = доступно, 2 = подразумевано активирано.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        'Одређује модул прегледа за мали приказ листе промена. ';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        'Одређује модул прегледа за мали приказ листе шаблона. ';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = 'Дефинише да ли јемогуће штампање обрачунатог времена.';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = 'Одређује да ли ће бити могуће штампање планираних напора.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        'Одређује да ли доступне (као што је одређено у машини стања) промене и статуси треба да буду дозвољени ако је промена у закључаном статусу.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        'Одређује да ли доступни (као што је одређено у машини стања) радни налози и статуси треба да буду дозвољени ако је радни налог у закључаном статусу.';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = 'Дефинише да ли обрачунато време треба да буде приказано.';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = 'Дефинише да ли актуелна времена почетка и завршетка треба да се подесе.';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        'Одређује да ли функције претраге промена и претраге радних налога могу да користе пресликану базу података.';
    $Self->{Translation}->{'Defines if the change state can be set in the change edit screen of the agent interface.'} =
        'Дефинише да ли стање промене може бити постављену у екрану измена у интерфејсу оператера.';
    $Self->{Translation}->{'Defines if the planned effort should be shown.'} = 'Одређује да ли планирани напор треба да буде приказан.';
    $Self->{Translation}->{'Defines if the requested date should be print by customer.'} = 'Дефинише да ли клијент треба да штампа тражени датум.';
    $Self->{Translation}->{'Defines if the requested date should be searched by customer.'} =
        'Дефинише да ли клијент може да претражује тражени датум.';
    $Self->{Translation}->{'Defines if the requested date should be set by customer.'} = 'Дефинише да ли клијент може да подеси тражени датум.';
    $Self->{Translation}->{'Defines if the requested date should be shown by customer.'} = 'Дефинише да ли клијент може да прикаже тражени датум.';
    $Self->{Translation}->{'Defines if the workorder state should be shown.'} = 'Дефинише да ли ће статус радног налога бити приказан.';
    $Self->{Translation}->{'Defines if the workorder title should be shown.'} = 'Дефинише да ли ће наслов радног налога бити приказан.';
    $Self->{Translation}->{'Defines shown graph attributes.'} = 'Дефинише атрибуте приказаног графикона.';
    $Self->{Translation}->{'Defines that only changes containing Workorders linked with services, which the customer user has permission to use will be shown. Any other changes will not be displayed.'} =
        'Дефинише да ће бити приказане само промене које садрже радне налоге повезане са сервисима, за које клијент корисник има дозволу употребе. Све друге промене неће бити приказане.';
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = 'Дефинише стања промена која је дозвољено да се обришу.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change PSA overview.'} =
        'Дефинише статусе промена који ће бити кориштени као филтери у ПДС прегледу промена.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change Schedule overview.'} =
        'Одређује статусе промена које ће бити кориштене као филтери у прегледу планера промена.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyCAB overview.'} =
        'Дефинише статусе промена који ће бити кориштени као филтери у прегледу мојих промена.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyChanges overview.'} =
        'Одређује статусе промена које ће бити кориштене као филтери у прегледу мојих промена.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change manager overview.'} =
        'Одређује статусе промена које ће бити кориштене као филтери у прегледу управљача променама.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change overview.'} =
        'Одређује статусе промена које ће бити кориштене као филтери у прегледу промена.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the customer change schedule overview.'} =
        'Одређује статусе промена које ће бити кориштене као филтери у прегледу клијентског планера промена.';
    $Self->{Translation}->{'Defines the default change title for a dummy change which is needed to edit a workorder template.'} =
        'Одређује подразумевани наслов празне промене која је потребна за измену шаблона радног налога.';
    $Self->{Translation}->{'Defines the default sort criteria in the change PSA overview.'} =
        'Дефинише подразумевани критеријум сортирања у PSA прегледу промена.';
    $Self->{Translation}->{'Defines the default sort criteria in the change manager overview.'} =
        'Одређује подразумеване услове сортирања у прегледу управљача променама.';
    $Self->{Translation}->{'Defines the default sort criteria in the change overview.'} = 'Дефинише подразумевани критеријум сортирања у прегледу промена.';
    $Self->{Translation}->{'Defines the default sort criteria in the change schedule overview.'} =
        'Дефинише подразумевани критеријум сортирања у прегледу планера промена.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyCAB overview.'} =
        'Дефинише подразумевани критеријум сортирања у прегледу промена мојих CAB.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyChanges overview.'} =
        'Одређује подразумеване услове сортирања промена у прегледу мојих промена.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyWorkorders overview.'} =
        'Одређује подразумеване услове сортирања промена у прегледу мојих радних налога.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the PIR overview.'} =
        'Дефинише подразумевани критеријум сортирања у прегледу PIR промена.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the customer change schedule overview.'} =
        'Одређује подразумеване услове сортирања промена у прегледу клијентског планера промена.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the template overview.'} =
        'Дефинише подразумевани критеријум сортирања промена у прегледу шаблона.';
    $Self->{Translation}->{'Defines the default sort order in the MyCAB overview.'} = 'Дефинише подразумевани критеријум сортирања у прегледу мојих CAB.';
    $Self->{Translation}->{'Defines the default sort order in the MyChanges overview.'} = 'Одређује подразумеване услове сортирања у прегледу мојих промена.';
    $Self->{Translation}->{'Defines the default sort order in the MyWorkorders overview.'} =
        'Одређује подразумеване услове сортирања у прегледу мојих радних налога.';
    $Self->{Translation}->{'Defines the default sort order in the PIR overview.'} = 'Дефинише подразумевани критеријум сортирања у прегледу PIR.';
    $Self->{Translation}->{'Defines the default sort order in the change PSA overview.'} = 'Дефинише подразумевани критеријум сортирања у прегледу PSA промена.';
    $Self->{Translation}->{'Defines the default sort order in the change manager overview.'} =
        'Одређује подразумеване услове сортирања у прегледу управљача променама.';
    $Self->{Translation}->{'Defines the default sort order in the change overview.'} = 'Дефинише подразумевани редослед у прегледу промена.';
    $Self->{Translation}->{'Defines the default sort order in the change schedule overview.'} =
        'Дефинише подразумевани редослед у прегледу планера промена.';
    $Self->{Translation}->{'Defines the default sort order in the customer change schedule overview.'} =
        'Одређује подразумеване услове сортирања у прегледу клијентског планера промена.';
    $Self->{Translation}->{'Defines the default sort order in the template overview.'} = 'Дефинише подразумевани редослед у прегледу шаблона.';
    $Self->{Translation}->{'Defines the default value for the category of a change.'} = 'Дефинише подразумевану вредност за категорију промене.';
    $Self->{Translation}->{'Defines the default value for the impact of a change.'} = 'Дефинише подразумевану вредност за утицај промене.';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for change attributes used in the change condition edit screen of the agent interface. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Дефинише тип поља за CompareValue атрибуте промена у екрану измена услова промена у интерфејсу оператера. Исправне вредности су Selection, Text и Date. Уколико тип није дефинисан, поље неће бити приказано.';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for workorder attributes used in the change condition edit screen of the agent interface. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Дефинише тип поља за CompareValue атрибуте радних налога у екрану измена услова промена у интерфејсу оператера. Исправне вредности су Selection, Text и Date. Уколико тип није дефинисан, поље неће бити приказано.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for change objects in the change condition edit screen of the agent interface.'} =
        'Одређује које атрибуте објекта је могуће изабрати за објекат промене у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for workorder objects in the change condition edit screen of the agent interface.'} =
        'Одређује које атрибуте објекта је могуће изабрати за објекат радног налога у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute AccountedTime in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут AccountedTime у екрану измена услова промена у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualEndTime in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут ActualEndTime у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualStartTime in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут ActualStartTime у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute CategoryID in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут CategoryID у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeBuilderID in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут ChangeBuilderID у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeManagerID in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут ChangeManagerID у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeStateID in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут ChangeStateID у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeTitle in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут ChangeTitle у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute DynamicField in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут DynamicField у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ImpactID in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут ImpactID у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEffort in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут PlannedEffort у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEndTime in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут PlannedEndTime у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedStartTime in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут PlannedStartTime у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PriorityID in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут PriorityID у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute RequestedTime in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут RequestedTime у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderAgentID in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут WorkOrderAgentID у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderNumber in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут WorkOrderNumber у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderStateID in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут WorkOrderStateID у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTitle in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут WorkOrderTitle у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTypeID in the change condition edit screen of the agent interface.'} =
        'Одређује које операторе је могуће изабрати за атрибут WorkOrderTypeID у екрану измена услова промене у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the period (in years), in which start and end times can be selected.'} =
        'Одређује период (у годинама), унутар ког је могуће изабрати времена почетка и завршетка.';
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom. To show workorder dynamic fields in the tooltip, they must be specified like DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, etc.'} =
        'Дефинише приказане атрибуте у порукама на графику радних налога у детаљном екрану промена. За приказ динамичких поља радних налога у порукама, морају бити дефинисани као DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, итд.';
    $Self->{Translation}->{'Defines the shown columns in the Change PSA overview. This option has no effect on the position of the column.'} =
        'Одређује колоне приказане у прегледу PSA промена. Ова опција нема утицај на позиције колона.';
    $Self->{Translation}->{'Defines the shown columns in the Change Schedule overview. This option has no effect on the position of the column.'} =
        'Одређује колоне приказане у прегледу планера промена. Ова опција нема утицај на позиције колона.';
    $Self->{Translation}->{'Defines the shown columns in the MyCAB overview. This option has no effect on the position of the column.'} =
        'Одређује колоне приказане у прегледу мојих CAB. Ова опција нема утицај на позиције колона.';
    $Self->{Translation}->{'Defines the shown columns in the MyChanges overview. This option has no effect on the position of the column.'} =
        'Одређује колоне приказане у прегледу мојих промена. Ова опција нема утицај на позиције колона.';
    $Self->{Translation}->{'Defines the shown columns in the MyWorkorders overview. This option has no effect on the position of the column.'} =
        'Одређује колоне приказане у прегледу мојих радних налога. Ова опција нема утицај на позиције колона.';
    $Self->{Translation}->{'Defines the shown columns in the PIR overview. This option has no effect on the position of the column.'} =
        'Дефинише приказане колоне у прегледу PIR. Ова опције нема утицај на позиције колона.';
    $Self->{Translation}->{'Defines the shown columns in the change manager overview. This option has no effect on the position of the column.'} =
        'Одређује приказане колоне у прегледу управљача променама. Ова опције нема утицај на позиције колона.';
    $Self->{Translation}->{'Defines the shown columns in the change overview. This option has no effect on the position of the column.'} =
        'Одређује приказане колоне у прегледу промена. Ова опције нема утицај на позиције колона.';
    $Self->{Translation}->{'Defines the shown columns in the change search. This option has no effect on the position of the column.'} =
        'Одређује приказане колоне у претрази промена. Ова опције нема утицај на позиције колона.';
    $Self->{Translation}->{'Defines the shown columns in the customer change schedule overview. This option has no effect on the position of the column.'} =
        'Одређује приказане колоне у прегледу клијентског планера промена. Ова опције нема утицај на позиције колона.';
    $Self->{Translation}->{'Defines the shown columns in the template overview. This option has no effect on the position of the column.'} =
        'Одређује приказане колоне у прегледу шаблона. Ова опције нема утицај на позиције колона.';
    $Self->{Translation}->{'Defines the signals for each ITSM change state.'} = 'Одређује сигнале за сваки статус ITSM промене.';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        'Одређује типове шаблона који ће бити кориштени као филтери у прегледу шаблона.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        'Одређује статусе радних налога који ће бити кориштени као филтери у прегледу мојих радних налога.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        'Одређује статусе радних налога који ће се користити као филтери у прегледу PIR.';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        'Одређује типове радних налога који ће се користити за приказ PIR прегледа.';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = 'Одређује да ли ће обавештења бити послата.';
    $Self->{Translation}->{'Delete a change.'} = 'Обриши промену.';
    $Self->{Translation}->{'Delete the change.'} = 'Обриши промену.';
    $Self->{Translation}->{'Delete the workorder.'} = 'Обриши радни налог.';
    $Self->{Translation}->{'Details of a change history entry.'} = 'Детаљи ставке историјата промене.';
    $Self->{Translation}->{'Determines if an agent can exchange the X-axis of a stat if he generates one.'} =
        'Утврђује да ли оператер може да замени X осу статистике ако је генерише';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes done for config item classes.'} =
        'Утврђује да ли заједнички модул статистике може да генерише статистику промена урађених за конфигурационе ставке класа.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding change state updates within a timeperiod.'} =
        'Утврђује да ли заједнички модул статистике може да генерише статистику промена према ажурирању промена стања у временском периоду.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding the relation between changes and incident tickets.'} =
        'Утврђује да ли заједнички модул статистике може да генерише статистику промена према вези између промена и тикета инцидената.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes.'} =
        'Утврђује да ли заједнички модул статистике може да генерише статистику о променама.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about the number of Rfc tickets a requester created.'} =
        'Утврђује да ли заједнички модул статистике може да генерише статистику о броју Rfc тикета које је креирао тражилац.';
    $Self->{Translation}->{'Dynamic fields (for changes and workorders) shown in the change print screen of the agent interface.'} =
        'Динамичка поља (за промене и радне налоге) приказана у екрану штампе промене у интерфејсу оператера.';
    $Self->{Translation}->{'Dynamic fields shown in the change add screen of the agent interface.'} =
        'Динамичка поља приказана у екрану додавања промене у интерфејсу оператера.';
    $Self->{Translation}->{'Dynamic fields shown in the change edit screen of the agent interface.'} =
        'Динамичка поља приказана у екрану измене промене у интерфејсу оператера.';
    $Self->{Translation}->{'Dynamic fields shown in the change search screen of the agent interface.'} =
        'Динамичка поља приказана у екрану претраге промена у интерфејсу оператера.';
    $Self->{Translation}->{'Dynamic fields shown in the change zoom screen of the agent interface.'} =
        'Динамичка поља приказана у детаљном прегледу промене у интерфејсу оператера.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder add screen of the agent interface.'} =
        'Динамичка поља приказана у екрану додавања радног налога у интерфејсу оператера.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder edit screen of the agent interface.'} =
        'Динамичка поља приказана у екрану измене радног налога у интерфејсу оператера.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder report screen of the agent interface.'} =
        'Динамичка поља приказана у екрану извештаја радног налога у интерфејсу оператера.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder zoom screen of the agent interface.'} =
        'Динамичка поља приказана у детаљном прегледу радног налога у интерфејсу оператера.';
    $Self->{Translation}->{'DynamicField event module to handle the update of conditions if dynamic fields are added, updated or deleted.'} =
        'Модул догађаја динамичких поља за баратање са ажурирањем услова ако се динамичка поља додају, ажурирају или бришу.';
    $Self->{Translation}->{'Edit a change.'} = 'Уреди промену.';
    $Self->{Translation}->{'Edit the change.'} = 'Уреди промену.';
    $Self->{Translation}->{'Edit the conditions of the change.'} = 'Уреди услове за промену.';
    $Self->{Translation}->{'Edit the workorder.'} = 'Уреди радни налог.';
    $Self->{Translation}->{'Enables the minimal change counter size (if "Date" was selected as ITSMChange::NumberGenerator).'} =
        'Активира минималну величину бројача промена (ако је изабран датум за ITSMChange::NumberGenerator).';
    $Self->{Translation}->{'Forward schedule of changes. Overview over approved changes.'} =
        'Проследи распоред промена. Преглед одобрених промена.';
    $Self->{Translation}->{'History Zoom'} = 'Детаљи историјата';
    $Self->{Translation}->{'ITSM Change CAB Templates.'} = 'ITSM шаблони промена CAB';
    $Self->{Translation}->{'ITSM Change Condition Edit.'} = 'ITSM уређивање услова промене.';
    $Self->{Translation}->{'ITSM Change Condition Overview.'} = 'ITSM преглед услова промене.';
    $Self->{Translation}->{'ITSM Change Manager Overview.'} = 'ITSM преглед промена.';
    $Self->{Translation}->{'ITSM Change Notifications'} = 'Обавештења o ITSM променама';
    $Self->{Translation}->{'ITSM Change PIR Overview.'} = 'ITSM преглед PIR промена.';
    $Self->{Translation}->{'ITSM Change notification rules'} = 'ITSM правила обавештавања о промени.';
    $Self->{Translation}->{'ITSM Changes'} = 'ITSM промене';
    $Self->{Translation}->{'ITSM MyCAB Overview.'} = 'ITSM преглед мојих CAB.';
    $Self->{Translation}->{'ITSM MyChanges Overview.'} = 'ITSM преглед мојих промена.';
    $Self->{Translation}->{'ITSM MyWorkorders Overview.'} = 'ITSM преглед мојих радних налога.';
    $Self->{Translation}->{'ITSM Template Delete.'} = 'ITSM брисање шаблона.';
    $Self->{Translation}->{'ITSM Template Edit CAB.'} = 'ITSM уређивање CAB шаблона.';
    $Self->{Translation}->{'ITSM Template Edit Content.'} = 'ITSM садржај уређивања шаблона.';
    $Self->{Translation}->{'ITSM Template Edit.'} = 'ITSM уређивање шаблона.';
    $Self->{Translation}->{'ITSM Template Overview.'} = 'Преглед ITSM шаблона.';
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = 'ITSM модул догађаја који чисти услове.';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = 'ITSM модул догађаја који брише кеш алатне траке.';
    $Self->{Translation}->{'ITSM event module that deletes the history of changes.'} = 'ITSM модул догађаја који брише историјат промена.';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        'ITSM модул догађаја који упарује услове и извршава акције.';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = 'ITSM модул догађаја који шаље обавештења.';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = 'ITSM модул догађаја који ажурира историјат промена.';
    $Self->{Translation}->{'ITSM event module that updates the history of conditions.'} = 'ITSM модул догађаја ажурира историјат услова.';
    $Self->{Translation}->{'ITSM event module that updates the history of workorders.'} = 'ITSM модул догађаја ажурира историјат радних налога.';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = 'ITSM модул догађаја који прерачунава бројеве радних налога.';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        'ITSM модул догађаја који подешава актуелна времена почетка и завршетка радних налога.';
    $Self->{Translation}->{'ITSMChange'} = 'ITSM промена';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'ITSM радни налог';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notifications are sent (every X hours).'} =
        'Ако је учесталост \'редовно\', можете подесити колико често се шаљу обавештења (на сваких X сати).';
    $Self->{Translation}->{'Link another object to the change.'} = 'Повежи други објекат са променом.';
    $Self->{Translation}->{'Link another object to the workorder.'} = 'Повежи други објекат са радним налогом.';
    $Self->{Translation}->{'List of all change events to be displayed in the GUI.'} = 'Листа свих догађаја на променама која ће бити приказана у графичком интерфејсу.';
    $Self->{Translation}->{'List of all workorder events to be displayed in the GUI.'} = 'Листа свих догађаја на радним налозима која ће бити приказана у графичком интерфејсу.';
    $Self->{Translation}->{'Lookup of CAB members for autocompletion.'} = 'Потражи чланове CAB ради аутоматског довршавања.';
    $Self->{Translation}->{'Lookup of agents, used for autocompletion.'} = 'Потражи оператере, употребљене за аутоматско довршавање.';
    $Self->{Translation}->{'Manage ITSM Change Management state machine.'} = 'Уређивање машине стања ITSM управљања променама.';
    $Self->{Translation}->{'Manage the category ↔ impact ↔ priority matrix.'} = 'Управљање матрицом Категорија - Утицај - Приоритет.';
    $Self->{Translation}->{'Module to check if WorkOrderAdd or WorkOrderAddFromTemplate should be permitted.'} =
        'Модул за проверу да ли додавање радног налога или додавање радног налога из шаблона треба да буде дозвољено.';
    $Self->{Translation}->{'Module to check the CAB members.'} = 'Модул за проверу чланова CAB.';
    $Self->{Translation}->{'Module to check the agent.'} = 'Модул за проверу оператера.';
    $Self->{Translation}->{'Module to check the change builder.'} = 'Модул за проверу градитеља промена.';
    $Self->{Translation}->{'Module to check the change manager.'} = 'Модул за проверу управљача променама.';
    $Self->{Translation}->{'Module to check the workorder agent.'} = 'Модул за проверу оператера радног налога.';
    $Self->{Translation}->{'Module to check whether no workorder agent is set.'} = 'Модул за проверу да ли је одређен оператер за радни налог.';
    $Self->{Translation}->{'Module to check whether the agent is contained in the configured list.'} =
        'Модул за проверу да ли се оператер налази у конфигурисаној листи.';
    $Self->{Translation}->{'Module to show a link to create a change from this ticket. The ticket will be automatically linked with the new change.'} =
        'Модул за приказ везе за креирање промене из овог тикета. Тикет ће аутоматски бити повезан са новом променом.';
    $Self->{Translation}->{'Move Time Slot.'} = 'Помери временски термин.';
    $Self->{Translation}->{'Move all workorders in time.'} = 'Помери све радне налоге у времену.';
    $Self->{Translation}->{'New (from template)'} = 'Ново (од шаблона)';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        'Само корисници ових група имаће дозволу за коришћење типова тикета дефинисаних у "ITSMChange::AddChangeLinkTicketTypes" уколико је функција "Ticket::Acl::Module###200-Ticket::Acl::Module" омогућена.';
    $Self->{Translation}->{'Other Settings'} = 'Друга подешавања';
    $Self->{Translation}->{'Overview over all Changes.'} = 'Преглед свих промена.';
    $Self->{Translation}->{'PIR'} = 'PIR';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'PIR (рецензија после спровођења)';
    $Self->{Translation}->{'PSA'} = 'PSA';
    $Self->{Translation}->{'Parameters for the UserCreateWorkOrderNextMask object in the preference view of the agent interface.'} =
        'Параметри за UserCreateWorkOrderNextMask објекат у приказу подешавања у интерфејсу оператера.';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        'Параметри страница (на којима су промене видљиве) смањеног прегледа тикета.';
    $Self->{Translation}->{'Performs the configured action for each event (as an Invoker) for each configured Webservice.'} =
        'Извршава подешену акцију за сваки догађај (као позивалац) за сваки конфигурисан веб сервис.';
    $Self->{Translation}->{'Planned end time'} = 'Планирано време завршетка';
    $Self->{Translation}->{'Planned start time'} = 'Планирано време почетка';
    $Self->{Translation}->{'Print the change.'} = 'Одштампај промену.';
    $Self->{Translation}->{'Print the workorder.'} = 'Одштампај радни налог.';
    $Self->{Translation}->{'Projected Service Availability'} = 'Пројектована доступност сервиса';
    $Self->{Translation}->{'Projected Service Availability (PSA)'} = 'Пројектована доступност сервиса (PSA)';
    $Self->{Translation}->{'Projected Service Availability (PSA) of changes. Overview of approved changes and their services.'} =
        'Пројектована доступност сервиса (PSA) промена. Преглед одобрених промена и љихових сервиса.';
    $Self->{Translation}->{'Requested time'} = 'Тражено време';
    $Self->{Translation}->{'Required privileges in order for an agent to take a workorder.'} =
        'Потребна права за додавање редоследа рада.';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = 'Потребна права за приступ прегледу свих промена.';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = 'Потребна права за додавање радних налога.';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = 'Потребна права за измену оператера радног налога.';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = 'Потребна права за креирање шаблона од промене.';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        'Потребна права за креирање шаблона од промене CAB.';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = 'Потребна права за креирање шаблона од радног налога.';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = 'Потребна права за креирање промена од шаблона.';
    $Self->{Translation}->{'Required privileges to create changes.'} = 'Потребна права за креирање промена.';
    $Self->{Translation}->{'Required privileges to delete a template.'} = 'Потребна права за брисање шаблона.';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = 'Потребна права за брисање радног налога.';
    $Self->{Translation}->{'Required privileges to delete changes.'} = 'Потребна права за брисање промена.';
    $Self->{Translation}->{'Required privileges to edit a template.'} = 'Потребна права за уређење шаблона.';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = 'Потребна права за уређење радног налога.';
    $Self->{Translation}->{'Required privileges to edit changes.'} = 'Потребна права за уређење промена.';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = 'Потребна права за уређење услова за промене.';
    $Self->{Translation}->{'Required privileges to edit the content of a template.'} = 'Потребна права за уређење садржаја шаблона.';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        'Потребна права за уређење особа укључених у промену.';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = 'Потребна права за померање промена у времену.';
    $Self->{Translation}->{'Required privileges to print a change.'} = 'Потребна права за штампу промене.';
    $Self->{Translation}->{'Required privileges to reset changes.'} = 'Потребна права за поништење промена.';
    $Self->{Translation}->{'Required privileges to view a workorder.'} = 'Потребна права за приказ радног налога.';
    $Self->{Translation}->{'Required privileges to view changes.'} = 'Потребна права за приказ промена.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is a CAB member.'} =
        'Потребна права за приказ листе промена где је корисник члан CAB.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is the change manager.'} =
        'Потребна права за приказ листе промена где корисник управља променом.';
    $Self->{Translation}->{'Required privileges to view overview over all templates.'} = 'Потребна права за приказ прегледа свих шаблона.';
    $Self->{Translation}->{'Required privileges to view the conditions of changes.'} = 'Потребна права за приказ услова за промене.';
    $Self->{Translation}->{'Required privileges to view the history of a change.'} = 'Потребна права за приказ историјата промене.';
    $Self->{Translation}->{'Required privileges to view the history of a workorder.'} = 'Потребна права за приказ историјата радног налога.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a change.'} = 'Потребна права за детаљан приказ историјата промене.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a workorder.'} =
        'Потребна права за детаљан приказ историјата радног налога';
    $Self->{Translation}->{'Required privileges to view the list of Change Schedule.'} = 'Потребна права за приказ листе Планера промена.';
    $Self->{Translation}->{'Required privileges to view the list of change PSA.'} = 'Потребна права за приказ листе промена PSA.';
    $Self->{Translation}->{'Required privileges to view the list of changes with an upcoming PIR (Post Implementation Review).'} =
        'Потребна права за приказ листе промена са предстојећим PIR (рецензија после спровођења).';
    $Self->{Translation}->{'Required privileges to view the list of own changes.'} = 'Потребна права за приказ листе сопствених промена.';
    $Self->{Translation}->{'Required privileges to view the list of own workorders.'} = 'Потребна права за приказ листе сопствених радних налога.';
    $Self->{Translation}->{'Required privileges to write a report for the workorder.'} = 'Потребна права за писње извештаја за радни налог.';
    $Self->{Translation}->{'Reset a change and its workorders.'} = 'Ресет промене и њених радних налога.';
    $Self->{Translation}->{'Reset change and its workorders.'} = 'Ресет промене и њених радних налога.';
    $Self->{Translation}->{'Run task to check if specific times have been reached in changes and workorders.'} =
        'Покрени задатак ради провере да ли су у променама и радним налозима достигнута одређена времена.';
    $Self->{Translation}->{'Save change as a template.'} = 'Сачувај промену као шаблон.';
    $Self->{Translation}->{'Save workorder as a template.'} = 'Сачувај радни налог као шаблон.';
    $Self->{Translation}->{'Schedule'} = 'Распоред';
    $Self->{Translation}->{'Screen after creating a workorder'} = 'Екран после креирања радног налога';
    $Self->{Translation}->{'Search Changes'} = 'Претражи промене';
    $Self->{Translation}->{'Search Changes.'} = 'Претражи промене.';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        'Бира модул за генерисање броја промена. "AutoIncrement" увећава број промена, SystemID и бројач се користе у SystemID.бројач формату (нпр. 100118, 100119). Са "Date" бројеви промена ће бити генерисани преко тренутног датума и бројача. Формат ће изгледати као година.месец.дан.бројач (нпр. 2010062400001, 2010062400002). Са "DateChecksum" бројач ће бити додат као контролни збир низу сачињеном од датума и SystemID. Контролни збир ће се смењивати на дневном нивоу. Формат изгледа овако: година.месец.дан.SystemID.бројач.контролни_збир, нпр. 2010062410000017, 2002070110101535.';
    $Self->{Translation}->{'Set the agent for the workorder.'} = 'Одреди оператера за радни налог.';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        'Дефинише подразумевану висину реда (у пикселима) HTML поља у екрану детаља промене и радног налога у интерфејсу оператера.';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        'Дефинише максималну висину реда (у пикселима) HTML поља у екрану детаља промене и радног налога у интерфејсу оператера.';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        'Подешава минималну величину бројача промена (ако је изабран "AutoIncrement" за ITSMChange::NumberGenerator). Подразумевано је 5, што значи да бројач почиње од 10000.';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = 'Подеси машину стања за промене.';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = 'Подеси машину стања за радне налоге.';
    $Self->{Translation}->{'Shows a checkbox in the workorder edit screen of the agent interface that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        'Приказује поље за потврду у екрану измена радног налога у интерфејсу оператера које дефинише да ли ће следећи радни налози такође бити премештени уколико је радни налог измењен и планирано време завршетка промењено.';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the workorder agent, in the zoom view of the workorder of the agent interface.'} =
        'У менију приказује везу која омогућава измену оператера радног налога, у детаљном приказу тог налога у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        'У менију приказује везу која омогућава дефинисање промене као шаблона на детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a workorder as a template in the zoom view of the workorder, in the agent interface.'} =
        'У менију приказује везу која омогућава дефинисање радног налога као шаблона на детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workorder, in the zoom view of the workorder of the agent interface.'} =
        'У менију приказује везу која омогућава измену извештаја радног налога, у детаљном приказу тог налога у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        'У менију приказује везу која омогућаваповезивање промене са другим објектом на детаљном приказу промене у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a workorder with another object in the zoom view of the workorder of the agent interface.'} =
        'У менију приказује везу која омогућава повезивање радног налога са другим објектом у детаљном приказу тог налога у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu that allows moving the time slot of a change in its zoom view of the agent interface.'} =
        'У менију приказује везу која омогућава померање временског термина промене на детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu that allows taking a workorder in the its zoom view of the agent interface.'} =
        'У менију приказује везу која омогућава преузимање радног налога на детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to access the conditions of a change in the its zoom view of the agent interface.'} =
        'У менију приказује везу која омогућава приступ условима промене на детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a change in the its zoom view of the agent interface.'} =
        'У менију приказује везу која омогућава приступ историјату промене на детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a workorder in the its zoom view of the agent interface.'} =
        'У менију приказује везу за приступ историјату радног налога на детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to add a workorder in the change zoom view of the agent interface.'} =
        'У менију приказује везу за додавање радног налога на детаљном приказу промене у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        'У менију приказује везу за брисање промене на детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to delete a workorder in its zoom view of the agent interface.'} =
        'У менију приказује везу за брисање радног налога на детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        'У менију приказује везу за измену промене на детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to edit a workorder in the its zoom view of the agent interface.'} =
        'У менију приказује везу за измену радног налога на детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        'У менију приказује везу за повратак на детаљни приказ промене у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the workorder zoom view of the agent interface.'} =
        'У менију приказује везу за повратак на детаљни приказ радног налога у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        'У менију приказује везу за штампање промене на детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to print a workorder in the its zoom view of the agent interface.'} =
        'У менију приказује везу за штампање радног налога на детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        'У менију приказује везу за поништавање промене и припадајућих радних налога на детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to show the involved persons in a change, in the zoom view of the change in the agent interface.'} =
        'У менију приказује везу која омогућава приказ особа укључених у промену у детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        'Приказује историјат тикета (обрнут редослед) у интерфејсу оператера.';
    $Self->{Translation}->{'State Machine'} = 'Машина стања';
    $Self->{Translation}->{'Stores change and workorder ids and their corresponding template id, while a user is editing a template.'} =
        'Чува идентификације промена и радних налога и припадајуће идентификације шаблона, за време док корисник уређује шаблон.';
    $Self->{Translation}->{'Take Workorder'} = 'Преузми радни налог';
    $Self->{Translation}->{'Take Workorder.'} = 'Преузми радни налог.';
    $Self->{Translation}->{'Take the workorder.'} = 'Преузми радни налог.';
    $Self->{Translation}->{'Template Overview'} = 'Преглед шаблона';
    $Self->{Translation}->{'Template type'} = 'Тип шаблона';
    $Self->{Translation}->{'Template.'} = 'Шаблон.';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        'Идентификатор за промену, нпр. Change#, MyChange#. Подразумевано је Change#.';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        'Идентификатор за радни налог, нпр. Workorder#, MyWorkorder#. Подразумевано је Workorder#.';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        'Овај ACL модул ограничава могућност коришћења типова тикета који су дефинисани у подешавању \'ITSMChange::AddChangeLinkTicketTypes\', и то корисницима група дефинисаним у "ITSMChange::RestrictTicketTypes::Groups". Како овај ACL може да се сукоби са другим ACL-овима који се исто односе на тип тикета, подешавање је подразумевано искључено и треба га активирати само уколико је неопходно.';
    $Self->{Translation}->{'Time Slot'} = 'Временски термин';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        'Типови тикета, код којих ће у детаљном приказу бити видљива веза за додавање промене.';
    $Self->{Translation}->{'User Search'} = 'Претрага корисника';
    $Self->{Translation}->{'Workorder Add (from template).'} = 'Додај радни налог (из шаблона)';
    $Self->{Translation}->{'Workorder Add.'} = 'Додај радни налог.';
    $Self->{Translation}->{'Workorder Agent.'} = 'Оператер за радни налог.';
    $Self->{Translation}->{'Workorder Delete.'} = 'Брисање радног налога.';
    $Self->{Translation}->{'Workorder Edit.'} = 'Уређење радног налога.';
    $Self->{Translation}->{'Workorder History Zoom.'} = 'Детаљи историјата радног налога.';
    $Self->{Translation}->{'Workorder History.'} = 'Историјат радног налога.';
    $Self->{Translation}->{'Workorder Report.'} = 'Извештај радног налога.';
    $Self->{Translation}->{'Workorder Zoom'} = 'Детаљи радног налога';
    $Self->{Translation}->{'Workorder Zoom.'} = 'Детаљи радног налога.';
    $Self->{Translation}->{'once'} = 'једном';
    $Self->{Translation}->{'regularly'} = 'редовно';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Do you really want to delete this action?',
    'Do you really want to delete this condition?',
    'Do you really want to delete this expression?',
    'Do you really want to delete this notification language?',
    'Do you really want to delete this notification?',
    'No',
    'Ok',
    'Please enter at least one search value or * to find anything.',
    'Settings',
    'Submit',
    'Yes',
    );

}

1;
