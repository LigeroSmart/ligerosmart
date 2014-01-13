# --
# Kernel/Language/zh_TW_ITSMChangeManagement.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# Copyright (C) 2013 Michael Shi <micshi at 163.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_TW_ITSMChangeManagement;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAITSMChangeManagement
    $Self->{Translation}->{'ITSMChange'} = '變更';
    $Self->{Translation}->{'ITSMChanges'} = '變更';
    $Self->{Translation}->{'ITSM Changes'} = '變更';
    $Self->{Translation}->{'workorder'} = '工作指令';
    $Self->{Translation}->{'A change must have a title!'} = '變更必須有標題!';
    $Self->{Translation}->{'A condition must have a name!'} = '條件必須有名稱!';
    $Self->{Translation}->{'A template must have a name!'} = '模板必須有名稱!';
    $Self->{Translation}->{'A workorder must have a title!'} = '工作指令必須有標題!';
    $Self->{Translation}->{'ActionExecute::successfully'} = '';
    $Self->{Translation}->{'ActionExecute::unsuccessfully'} = '';
    $Self->{Translation}->{'Add CAB Template'} = '添加CAB模板';
    $Self->{Translation}->{'Add Workorder'} = '添加工作指令';
    $Self->{Translation}->{'Add a workorder to the change'} = '添加變更工作指令';
    $Self->{Translation}->{'Add new condition and action pair'} = '添加新的條件和操作';
    $Self->{Translation}->{'Agent interface module to show the ChangeManager overview icon.'} = '';
    $Self->{Translation}->{'Agent interface module to show the MyCAB overview icon.'} = '';
    $Self->{Translation}->{'Agent interface module to show the MyChanges overview icon.'} = '';
    $Self->{Translation}->{'Agent interface module to show the MyWorkOrders overview icon.'} = '';
    $Self->{Translation}->{'CABAgents'} = 'CAB服務人員';
    $Self->{Translation}->{'CABCustomers'} = 'CAB用户';
    $Self->{Translation}->{'Change Overview'} = '變更概況';
    $Self->{Translation}->{'Change Schedule'} = '變更計劃';
    $Self->{Translation}->{'Change involved persons of the change'} = '更換變更涉及的相關人員';
    $Self->{Translation}->{'ChangeHistory::ActionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ActionAddID'} = 'New Action (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ActionDelete'} = 'Action (ID=%s) deleted';
    $Self->{Translation}->{'ChangeHistory::ActionDeleteAll'} = 'All Actions of Condition (ID=%s) deleted';
    $Self->{Translation}->{'ChangeHistory::ActionExecute'} = 'Action (ID=%s) executed: %s';
    $Self->{Translation}->{'ChangeHistory::ActionUpdate'} = '%s (Action ID=%s): New: %s <- Old: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeActualEndTimeReached'} = 'Change (ID=%s) reached actual end time.';
    $Self->{Translation}->{'ChangeHistory::ChangeActualStartTimeReached'} = 'Change (ID=%s) reached actual start time.';
    $Self->{Translation}->{'ChangeHistory::ChangeAdd'} = 'New Change (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentAdd'} = 'New Attachment: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentDelete'} = 'Deleted Attachment %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABDelete'} = 'CAB Deleted %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABUpdate'} = '%s: New: %s <- Old: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkAdd'} = 'Link to %s (ID=%s) added';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkDelete'} = 'Link to %s (ID=%s) deleted';
    $Self->{Translation}->{'ChangeHistory::ChangeNotificationSent'} = 'Notification sent to %s (Event: %s)';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedEndTimeReached'} = 'Change (ID=%s) reached planned end time.';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedStartTimeReached'} = 'Change (ID=%s) reached planned start time.';
    $Self->{Translation}->{'ChangeHistory::ChangeRequestedTimeReached'} = 'Change (ID=%s) reached requested time.';
    $Self->{Translation}->{'ChangeHistory::ChangeUpdate'} = '%s: New: %s <- Old: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAddID'} = 'New Condition (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ConditionDelete'} = 'Condition (ID=%s) deleted';
    $Self->{Translation}->{'ChangeHistory::ConditionDeleteAll'} = 'All Conditions of Change (ID=%s) deleted';
    $Self->{Translation}->{'ChangeHistory::ConditionUpdate'} = '%s (Condition ID=%s): New: %s <- Old: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAddID'} = 'New Expression (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ExpressionDelete'} = 'Expression (ID=%s) deleted';
    $Self->{Translation}->{'ChangeHistory::ExpressionDeleteAll'} = 'All Expressions of Condition (ID=%s) deleted';
    $Self->{Translation}->{'ChangeHistory::ExpressionUpdate'} = '%s (Expression ID=%s): New: %s <- Old: %s';
    $Self->{Translation}->{'ChangeNumber'} = '變更編號';
    $Self->{Translation}->{'Condition Edit'} = '删除';
    $Self->{Translation}->{'Create Change'} = '創建變更';
    $Self->{Translation}->{'Create a change from this ticket!'} = '從工單中創建變更！';
    $Self->{Translation}->{'Delete Workorder'} = '删除工作指令';
    $Self->{Translation}->{'Edit the change'} = '編輯變更';
    $Self->{Translation}->{'Edit the conditions of the change'} = '編輯變更條件';
    $Self->{Translation}->{'Edit the workorder'} = '編輯工作指令';
    $Self->{Translation}->{'Expression'} = '表達式';
    $Self->{Translation}->{'Full-Text Search in Change and Workorder'} = '在變更和工作指令中進行全文搜索';
    $Self->{Translation}->{'ITSMCondition'} = '條件';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'ITSM工作指令';
    $Self->{Translation}->{'Link another object to the change'} = '連接另一個對象至變更';
    $Self->{Translation}->{'Link another object to the workorder'} = '連接另一個對象至工作指令';
    $Self->{Translation}->{'Move all workorders in time'} = '適時移動所有工作指令';
    $Self->{Translation}->{'My CABs'} = '我的CAB';
    $Self->{Translation}->{'My Changes'} = '我的變更';
    $Self->{Translation}->{'My Workorders'} = '我的工作指令';
    $Self->{Translation}->{'No XXX settings'} = '沒有\'%s\'設置';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'PIR (實施後審查)';
    $Self->{Translation}->{'PSA (Projected Service Availability)'} = 'PSA (計劃服務可用性)';
    $Self->{Translation}->{'Projected Service Availability (PSA)'} = 'PSA (計劃服務可用性)';
    $Self->{Translation}->{'Please select first a catalog class!'} = '請先選擇目錄類';
    $Self->{Translation}->{'Print the change'} = '打印變更';
    $Self->{Translation}->{'Print the workorder'} = '打印工作指令';
    $Self->{Translation}->{'RequestedTime'} = '請求時間';
    $Self->{Translation}->{'Save Change CAB as Template'} = '保存變更CAB至模板';
    $Self->{Translation}->{'Save change as a template'} = '保存變更至模板';
    $Self->{Translation}->{'Save workorder as a template'} = '保存工作指令至模板';
    $Self->{Translation}->{'Search Changes'} = '搜索變更';
    $Self->{Translation}->{'Set the agent for the workorder'} = '為工作指令指派服務人員';
    $Self->{Translation}->{'Take Workorder'} = '接手工作指令';
    $Self->{Translation}->{'Take the workorder'} = '接手這個工作指令';
    $Self->{Translation}->{'Template Overview'} = '模板概況';
    $Self->{Translation}->{'The planned end time is invalid!'} = '計劃結束時間無效';
    $Self->{Translation}->{'The planned start time is invalid!'} = '計劃開始時間無效';
    $Self->{Translation}->{'The planned time is invalid!'} = '計劃時間無效';
    $Self->{Translation}->{'The requested time is invalid!'} = '請求時間無效';
    $Self->{Translation}->{'New (from template)'} = '創建新變更(通過模板)';
    $Self->{Translation}->{'Add from template'} = 'Von Template hinzufügen';
    $Self->{Translation}->{'Add Workorder (from template)'} = '添加工作指令（通過模板）';
    $Self->{Translation}->{'Add a workorder (from template) to the change'} = '在變更中添加工作指令（通過模板）';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReached'} = 'Workorder (ID=%s) reached actual end time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'} = 'Workorder (ID=%s) reached actual end time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReached'} = 'Workorder (ID=%s) reached actual start time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'} = 'Workorder (ID=%s) reached actual start time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAdd'} = 'New Workorder (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'} = 'New Workorder (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAdd'} = 'New Attachment for WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'} = '(ID=%s) New Attachment for WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Deleted Attachment from WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Deleted Attachment from WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAdd'} = 'New Report Attachment for WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID'} = '(ID=%s) New Report Attachment for WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDelete'} = 'Deleted Report Attachment from WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Deleted Report Attachment from WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDelete'} = 'Workorder (ID=%s) deleted';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'} = 'Workorder (ID=%s) deleted';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAdd'} = 'WorkOrderHistory::WorkOrderLinkAdd';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'} = '(ID=%s) Link to %s (ID=%s) added';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'Link to %s (ID=%s) deleted';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'} = '(ID=%s) Link to %s (ID=%s) gelöscht';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'Notification sent to %s (Event: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '(ID=%s) Notification sent to %s (Event: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'} = 'Workorder (ID=%s) reached planned end time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'} = 'Workorder (ID=%s) reached planned end time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'} = 'Workorder (ID=%s) reached planned start time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} = 'Workorder (ID=%s) reached planned start time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdate'} = '%s: New: %s <- Old: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'} = '(ID=%s) %s: New: %s <- Old: %s';
    $Self->{Translation}->{'WorkOrderNumber'} = '工作指令';
    $Self->{Translation}->{'accepted'} = '接受';
    $Self->{Translation}->{'any'} = '';
    $Self->{Translation}->{'approval'} = '審批';
    $Self->{Translation}->{'approved'} = '通過審批';
    $Self->{Translation}->{'backout'} = '退回';
    $Self->{Translation}->{'begins with'} = '';
    $Self->{Translation}->{'canceled'} = '取消';
    $Self->{Translation}->{'contains'} = '';
    $Self->{Translation}->{'created'} = '創建於';
    $Self->{Translation}->{'decision'} = '決定';
    $Self->{Translation}->{'ends with'} = '';
    $Self->{Translation}->{'failed'} = '失敗';
    $Self->{Translation}->{'in progress'} = '處理中';
    $Self->{Translation}->{'is'} = '是';
    $Self->{Translation}->{'is after'} = '...之後';
    $Self->{Translation}->{'is before'} = '...之前';
    $Self->{Translation}->{'is empty'} = '空白';
    $Self->{Translation}->{'is greater than'} = '大於...';
    $Self->{Translation}->{'is less than'} = '小於...';
    $Self->{Translation}->{'is not'} = '不是';
    $Self->{Translation}->{'is not empty'} = '非空白';
    $Self->{Translation}->{'not contains'} = 'does not contain';
    $Self->{Translation}->{'pending approval'} = '待審批';
    $Self->{Translation}->{'pending pir'} = '等待實施後審查';
    $Self->{Translation}->{'pir'} = 'PIR (實施後審查)';
    $Self->{Translation}->{'ready'} = '準備開始';
    $Self->{Translation}->{'rejected'} = '被拒絕';
    $Self->{Translation}->{'requested'} = '請求';
    $Self->{Translation}->{'retracted'} = '撤回';
    $Self->{Translation}->{'set'} = '設置';
    $Self->{Translation}->{'successful'} = '成功';

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category <-> Impact <-> Priority'} = '類别 <-> 影響 <-> 優先級';
    $Self->{Translation}->{'Manage the priority result of combinating Category <-> Impact.'} =
        '"類别 <-> 影響"之間的組合決定優先级。';
    $Self->{Translation}->{'Priority allocation'} = '優先级分配';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = '管理變更通知';
    $Self->{Translation}->{'Add Notification Rule'} = '添加通知規則';
    $Self->{Translation}->{'Attribute'} = '屬性';
    $Self->{Translation}->{'Rule'} = '規則';
    $Self->{Translation}->{'Recipients'} = '接收人';
    $Self->{Translation}->{'A notification should have a name!'} = '通知必須有名稱！';
    $Self->{Translation}->{'Name is required.'} = '名稱是必需的。';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = '管理狀態機';
    $Self->{Translation}->{'Select a catalog class!'} = '選擇目錄類';
    $Self->{Translation}->{'A catalog class is required!'} = '目錄類是必需的！';
    $Self->{Translation}->{'Add a state transition'} = '添加一個狀態轉換';
    $Self->{Translation}->{'Catalog Class'} = '目錄類';
    $Self->{Translation}->{'Object Name'} = '對象名稱';
    $Self->{Translation}->{'Overview over state transitions for'} = '狀態轉換概況';
    $Self->{Translation}->{'Delete this state transition'} = '删除這個狀態轉換';
    $Self->{Translation}->{'Add a new state transition for'} = '添加一個新的轉換狀態';
    $Self->{Translation}->{'Please select a state!'} = '請選擇一個狀態！';
    $Self->{Translation}->{'Please select a next state!'} = '請選擇下一步狀態';
    $Self->{Translation}->{'Edit a state transition for'} = '編輯轉換狀態';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = '你確定要删除這個狀態轉換嗎?';
    $Self->{Translation}->{'from'} = '';

    # Template: AgentITSMCABMemberSearch

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = '創建變更';
    $Self->{Translation}->{'ITSM Change'} = '變更';
    $Self->{Translation}->{'Justification'} = '理由';
    $Self->{Translation}->{'Input invalid.'} = '輸入無效。';
    $Self->{Translation}->{'Impact'} = '影響';
    $Self->{Translation}->{'Requested Date'} = '請求日期';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = '選擇變更模板';
    $Self->{Translation}->{'Time type'} = '時間類型';
    $Self->{Translation}->{'Invalid time type.'} = '無效的時間類型。';
    $Self->{Translation}->{'New time'} = '新的時間';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = '保存變更CAB至模板';
    $Self->{Translation}->{'go to involved persons screen'} = '轉向相關人員窗口';
    $Self->{Translation}->{'This field is required'} = '這個字段是必需的';
    $Self->{Translation}->{'Invalid Name'} = '無效的名稱';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = '條件和操作';
    $Self->{Translation}->{'Delete Condition'} = '删除條件';
    $Self->{Translation}->{'Add new condition'} = '添加新的條件';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = '需要一個有效的名稱';
    $Self->{Translation}->{'A a valid name is needed.'} = '需要一個有效的名稱。';
    $Self->{Translation}->{'Matching'} = '匹配';
    $Self->{Translation}->{'Any expression (OR)'} = '任意表達式(或)';
    $Self->{Translation}->{'All expressions (AND)'} = '所有表達式(與)';
    $Self->{Translation}->{'Expressions'} = '表達式';
    $Self->{Translation}->{'Selector'} = '選擇器';
    $Self->{Translation}->{'Operator'} = '操作符';
    $Self->{Translation}->{'Delete Expression'} = '删除表達式';
    $Self->{Translation}->{'No Expressions found.'} = '沒有找到表達式';
    $Self->{Translation}->{'Add new expression'} = '添加新的表達式';
    $Self->{Translation}->{'Delete Action'} = '删除操作';
    $Self->{Translation}->{'No Actions found.'} = '沒有找到操作';
    $Self->{Translation}->{'Add new action'} = '添加新的操作';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = '你確定要删除這個變更嗎?';

    # Template: AgentITSMChangeEdit

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'Workorder'} = '工作指令';
    $Self->{Translation}->{'Show details'} = '顯示詳情';
    $Self->{Translation}->{'Show workorder'} = '顯示工作指令';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of'} = '詳細歷史信息';
    $Self->{Translation}->{'Modified'} = '修改';
    $Self->{Translation}->{'Old Value'} = '舊值';
    $Self->{Translation}->{'New Value'} = '新值';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Involved Persons'} = '相關人員';
    $Self->{Translation}->{'ChangeManager'} = '變更經理';
    $Self->{Translation}->{'User invalid.'} = '用户無效。';
    $Self->{Translation}->{'ChangeBuilder'} = '變更創建人';
    $Self->{Translation}->{'Change Advisory Board'} = '變更審批委員會';
    $Self->{Translation}->{'CAB Template'} = 'CAB模板';
    $Self->{Translation}->{'Apply Template'} = '應用模板';
    $Self->{Translation}->{'NewTemplate'} = '新模板';
    $Self->{Translation}->{'Save this CAB as template'} = '保存這個CAB至模板';
    $Self->{Translation}->{'Add to CAB'} = '添加至CAB';
    $Self->{Translation}->{'Invalid User'} = '無效的用户';
    $Self->{Translation}->{'Current CAB'} = '當前CAB';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = '上下文設置';
    $Self->{Translation}->{'Changes per page'} = '每頁顯示的變更個數';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'WorkOrderTitle'} = '工作指令標题';
    $Self->{Translation}->{'ChangeTitle'} = '變更標题';
    $Self->{Translation}->{'WorkOrderAgent'} = '工作指令服務人員';
    $Self->{Translation}->{'Workorders'} = '工作指令';
    $Self->{Translation}->{'ChangeState'} = '變更狀態';
    $Self->{Translation}->{'WorkOrderState'} = '工作指令狀態';
    $Self->{Translation}->{'WorkOrderType'} = '工作指令類型';
    $Self->{Translation}->{'Requested Time'} = '請求時間';
    $Self->{Translation}->{'PlannedStartTime'} = '計劃開始時間';
    $Self->{Translation}->{'PlannedEndTime'} = '計劃結束時間';
    $Self->{Translation}->{'ActualStartTime'} = '實際開始時間';
    $Self->{Translation}->{'ActualEndTime'} = '實際結束時間';

    # Template: AgentITSMChangePrint
    $Self->{Translation}->{'ITSM Workorder'} = '工作指令';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = '你確定要删除這個變更嗎？';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '';
    $Self->{Translation}->{'CABAgent'} = 'CAB服務人員';
    $Self->{Translation}->{'e.g.'} = '';
    $Self->{Translation}->{'CABCustomer'} = 'CAB用户';
    $Self->{Translation}->{'Instruction'} = '指示';
    $Self->{Translation}->{'Report'} = '報告';
    $Self->{Translation}->{'Change Category'} = '變更類别';
    $Self->{Translation}->{'Run Search'} = '搜索';

    # Template: AgentITSMChangeSearchResultPrint
    $Self->{Translation}->{'WorkOrders'} = '工作指令';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = '保存變更至模板';
    $Self->{Translation}->{'A template should have a name!'} = '模板應有名稱!';
    $Self->{Translation}->{'The template name is required.'} = '模板名稱是必需的。';
    $Self->{Translation}->{'Reset States'} = '重置狀態';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = '修改時間計劃';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = '變更信息';
    $Self->{Translation}->{'PlannedEffort'} = '計劃工作量';
    $Self->{Translation}->{'Change Initiator(s)'} = '變更發起人';
    $Self->{Translation}->{'Change Manager'} = '變更經理';
    $Self->{Translation}->{'Change Builder'} = '變更創建人';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = '上次修改';
    $Self->{Translation}->{'Last changed by'} = '上次修改人';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Download Attachment'} = '下載附件';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = '你確定要删除這個模板嗎？';

    # Template: AgentITSMTemplateEdit

    # Template: AgentITSMTemplateOverviewNavBar

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = '模板編號';
    $Self->{Translation}->{'CreateBy'} = '創建人';
    $Self->{Translation}->{'CreateTime'} = '創建時間';
    $Self->{Translation}->{'ChangeBy'} = '修改人';
    $Self->{Translation}->{'ChangeTime'} = '修改時間';
    $Self->{Translation}->{'Delete: '} = '刪除';
    $Self->{Translation}->{'Delete Template'} = '刪除模板';

    # Template: AgentITSMUserSearch

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = '將工作指令添加至';
    $Self->{Translation}->{'Invalid workorder type.'} = '無效的工作指令類型';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = '計劃開始時間必須在計劃結束時間之前!';
    $Self->{Translation}->{'Invalid format.'} = '無效的格式.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = '選擇工作指令模板';

    # Template: AgentITSMWorkOrderAgent

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = '你確定要刪除這個工作指令嗎?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} = '你無法刪除這個工作單。至少有一個條件用到了它!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = '此工作指令出現在下列條件中';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = '相應的移動工作指令';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        '如果該工作指令的計劃結束時間改變了，所有後續工作指令的計劃開始時間將相應的改變';

    # Template: AgentITSMWorkOrderHistory

    # Template: AgentITSMWorkOrderHistoryZoom

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = '實際開始時間必須在實際結束時間之前!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} = '設置實際結束時間後必須設置實際開始時間!';
    $Self->{Translation}->{'Existing attachments'} = '現有的附件';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = '當前的服務人員';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = '你確定要刪除這個工作指令嗎?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = '保存工作指令至模板';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = '工作指令信息';

    # Template: CustomerITSMChangeOverview

    # Template: ITSMChange

    # SysConfig
    $Self->{Translation}->{'Admin of notification rules.'} = '通知規則管理';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = '管理CIP矩陣';
    $Self->{Translation}->{'Admin of the state machine.'} = '管理狀態機';
    $Self->{Translation}->{'Screen after creating a workorder'}
        = '創建工作指令後的視圖';
    $Self->{Translation}->{'Show this screen after I created a new workorder'}
        = '創建工作指令後顯示的頁面';
    $Self->{Translation}->{'Duplicate name:'}
        = '重複的名稱：';
    $Self->{Translation}->{'This name is already used by another condition.'}
        = '另一個條件已被使用過該名稱。';
    $Self->{Translation}->{'Notification (ITSM Change Management)'} = '通知 (變更管理)';
        $Self->{Translation}->{'State Machine'} = '狀態機';


    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Adapts the width of the autocomplete drop down to the length of the longest option.'} =
        '';
    $Self->{Translation}->{'CAB Agent'} = 'CAB服務人員';
    $Self->{Translation}->{'CAB Customer'} = 'CAB用户';
    $Self->{Translation}->{'Cache time in minutes for the change management.'} = '變更管理緩存時間（分鐘）。';
    $Self->{Translation}->{'Change Description'} = '變更描述';
    $Self->{Translation}->{'Change Impact'} = '變更影響';
    $Self->{Translation}->{'Change Justification'} = '變更理由';
    $Self->{Translation}->{'Change Number'} = '變更編號';
    $Self->{Translation}->{'Change Priority'} = '變更優先級';
    $Self->{Translation}->{'Change State'} = '變更狀態';
    $Self->{Translation}->{'Change Title'} = '變更標題';
    $Self->{Translation}->{'Created By'} = '創建人';
    $Self->{Translation}->{'Delete Change'} = '刪除變更';
    $Self->{Translation}->{'Reset change and its workorders'} = '重置變更和相應的工作指令';
    $Self->{Translation}->{'Search Agent'} = '搜索服務人員';
    $Self->{Translation}->{'Work Order Title'} = '工作指令標題';
    $Self->{Translation}->{'WorkOrder Agent'} = '工作指令服務人員';

    $Self->{Translation}->{'WorkOrder Instruction'} = '工作指令指示';
    $Self->{Translation}->{'WorkOrder Report'} = '工作指令報告';
    $Self->{Translation}->{'WorkOrder State'} = '工作指令狀態';

    #Missed Translation Item
    $Self->{Translation}->{'Schedule'} = '計劃';
    $Self->{Translation}->{'Projected Service Availability'} = '計劃服務可用性';
    $Self->{Translation}->{'ChangeInitiators'} = '變更發起人';
    $Self->{Translation}->{'GroupITSMChange'} = '組ITSM變更';
    $Self->{Translation}->{'GroupITSMChangeBuilder'} = '組ITSM變更創建人';
    $Self->{Translation}->{'GroupITSMChangeManager'} = '組ITSM變更經理';
    $Self->{Translation}->{'OldChangeBuilder'} = '舊變更創建人';
    $Self->{Translation}->{'OldChangeManager'} = '舊變更經理';
    $Self->{Translation}->{'OldWorkOrderAgent'} = '舊工單指令服務人員';
    $Self->{Translation}->{'WorkOrderAgents'} = '所有工作指令服務人員';
}

1;
