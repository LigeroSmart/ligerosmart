# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMChangeManagement
    $Self->{Translation}->{'ITSMChange'} = '变更';
    $Self->{Translation}->{'ITSMChanges'} = '变更';
    $Self->{Translation}->{'ITSM Changes'} = '变更';
    $Self->{Translation}->{'workorder'} = '工作指令';
    $Self->{Translation}->{'A change must have a title!'} = '变更必须有标题!';
    $Self->{Translation}->{'A condition must have a name!'} = '条件必须有名称!';
    $Self->{Translation}->{'A template must have a name!'} = '模板必须有名称!';
    $Self->{Translation}->{'A workorder must have a title!'} = '工作指令必须有标题!';
    $Self->{Translation}->{'ActionExecute::successfully'} = '';
    $Self->{Translation}->{'ActionExecute::unsuccessfully'} = '';
    $Self->{Translation}->{'Add CAB Template'} = '添加CAB模板';
    $Self->{Translation}->{'Add Workorder'} = '添加工作指令';
    $Self->{Translation}->{'Add a workorder to the change'} = '添加变更工作指令';
    $Self->{Translation}->{'Add new condition and action pair'} = '添加新的条件和操作';
    $Self->{Translation}->{'Agent interface module to show the ChangeManager overview icon.'} =
        '';
    $Self->{Translation}->{'Agent interface module to show the MyCAB overview icon.'} = '';
    $Self->{Translation}->{'Agent interface module to show the MyChanges overview icon.'} = '';
    $Self->{Translation}->{'Agent interface module to show the MyWorkOrders overview icon.'} =
        '';
    $Self->{Translation}->{'CABAgents'} = 'CAB服务人员';
    $Self->{Translation}->{'CABCustomers'} = 'CAB用户';
    $Self->{Translation}->{'Change Overview'} = '变更概况';
    $Self->{Translation}->{'Change Schedule'} = '变更计划';
    $Self->{Translation}->{'Change involved persons of the change'} = '更换变更涉及的相关人员';
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
    $Self->{Translation}->{'ChangeNumber'} = '变更编号';
    $Self->{Translation}->{'Condition Edit'} = '删除';
    $Self->{Translation}->{'Create Change'} = '创建变更';
    $Self->{Translation}->{'Create a change from this ticket!'} = '从工单中创建变更！';
    $Self->{Translation}->{'Delete Workorder'} = '删除工作指令';
    $Self->{Translation}->{'Edit the change'} = '编辑变更';
    $Self->{Translation}->{'Edit the conditions of the change'} = '编辑变更条件';
    $Self->{Translation}->{'Edit the workorder'} = '编辑工作指令';
    $Self->{Translation}->{'Expression'} = '表达式';
    $Self->{Translation}->{'Full-Text Search in Change and Workorder'} = '在变更和工作指令中进行全文搜索';
    $Self->{Translation}->{'ITSMCondition'} = '条件';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'ITSM工作指令';
    $Self->{Translation}->{'Link another object to the change'} = '连接另一个对象至变更';
    $Self->{Translation}->{'Link another object to the workorder'} = '连接另一个对象至工作指令';
    $Self->{Translation}->{'Move all workorders in time'} = '适时移动所有工作指令';
    $Self->{Translation}->{'My CABs'} = '我的CAB';
    $Self->{Translation}->{'My Changes'} = '我的变更';
    $Self->{Translation}->{'My Workorders'} = '我的工作指令';
    $Self->{Translation}->{'No XXX settings'} = '没有\'%s\'设置';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'PIR (实施后审查)';
    $Self->{Translation}->{'PSA (Projected Service Availability)'} = 'PSA (计划服务可用性)';
    $Self->{Translation}->{'Please select first a catalog class!'} = '请先选择目录类';
    $Self->{Translation}->{'Print the change'} = '打印变更';
    $Self->{Translation}->{'Print the workorder'} = '打印工作指令';
    $Self->{Translation}->{'RequestedTime'} = '请求时间';
    $Self->{Translation}->{'Save Change CAB as Template'} = '保存变更CAB至模板';
    $Self->{Translation}->{'Save change as a template'} = '保存变更至模板';
    $Self->{Translation}->{'Save workorder as a template'} = '保存工作指令至模板';
    $Self->{Translation}->{'Search Changes'} = '搜索变更';
    $Self->{Translation}->{'Set the agent for the workorder'} = '为工作指令指派服务人员';
    $Self->{Translation}->{'Take Workorder'} = '接手工作指令';
    $Self->{Translation}->{'Take the workorder'} = '接手这个工作指令';
    $Self->{Translation}->{'Template Overview'} = '模板概况';
    $Self->{Translation}->{'The planned end time is invalid!'} = '计划结束时间无效';
    $Self->{Translation}->{'The planned start time is invalid!'} = '计划开始时间无效';
    $Self->{Translation}->{'The planned time is invalid!'} = '计划时间无效';
    $Self->{Translation}->{'The requested time is invalid!'} = '请求时间无效';
    $Self->{Translation}->{'New (from template)'} = '创建新变更(通过模板)';
    $Self->{Translation}->{'Add from template'} = 'Von Template hinzufügen';
    $Self->{Translation}->{'Add Workorder (from template)'} = '添加工作指令（通过模板）';
    $Self->{Translation}->{'Add a workorder (from template) to the change'} = '在变更中添加工作指令（通过模板）';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReached'} = 'Workorder (ID=%s) reached actual end time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'} =
        'Workorder (ID=%s) reached actual end time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReached'} = 'Workorder (ID=%s) reached actual start time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'} =
        'Workorder (ID=%s) reached actual start time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAdd'} = 'New Workorder (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'} = 'New Workorder (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAdd'} = 'New Attachment for WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'} = '(ID=%s) New Attachment for WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Deleted Attachment from WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Deleted Attachment from WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAdd'} = 'New Report Attachment for WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID'} =
        '(ID=%s) New Report Attachment for WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDelete'} = 'Deleted Report Attachment from WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID'} =
        '(ID=%s) Deleted Report Attachment from WorkOrder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDelete'} = 'Workorder (ID=%s) deleted';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'} = 'Workorder (ID=%s) deleted';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAdd'} = 'WorkOrderHistory::WorkOrderLinkAdd';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'} = '(ID=%s) Link to %s (ID=%s) added';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'Link to %s (ID=%s) deleted';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'} = '(ID=%s) Link to %s (ID=%s) gelöscht';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'Notification sent to %s (Event: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '(ID=%s) Notification sent to %s (Event: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'} = 'Workorder (ID=%s) reached planned end time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'} =
        'Workorder (ID=%s) reached planned end time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'} = 'Workorder (ID=%s) reached planned start time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} =
        'Workorder (ID=%s) reached planned start time.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdate'} = '%s: New: %s <- Old: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'} = '(ID=%s) %s: New: %s <- Old: %s';
    $Self->{Translation}->{'WorkOrderNumber'} = '工作指令';
    $Self->{Translation}->{'accepted'} = '接受';
    $Self->{Translation}->{'any'} = '';
    $Self->{Translation}->{'approval'} = '审批';
    $Self->{Translation}->{'approved'} = '通过审批';
    $Self->{Translation}->{'backout'} = '回退';
    $Self->{Translation}->{'begins with'} = '';
    $Self->{Translation}->{'canceled'} = '取消';
    $Self->{Translation}->{'contains'} = '';
    $Self->{Translation}->{'created'} = '创建于';
    $Self->{Translation}->{'decision'} = '决定';
    $Self->{Translation}->{'ends with'} = '';
    $Self->{Translation}->{'failed'} = '失败';
    $Self->{Translation}->{'in progress'} = '处理中';
    $Self->{Translation}->{'is'} = '';
    $Self->{Translation}->{'is after'} = '';
    $Self->{Translation}->{'is before'} = '';
    $Self->{Translation}->{'is empty'} = '';
    $Self->{Translation}->{'is greater than'} = '';
    $Self->{Translation}->{'is less than'} = '';
    $Self->{Translation}->{'is not'} = '';
    $Self->{Translation}->{'is not empty'} = '';
    $Self->{Translation}->{'not contains'} = 'does not contain';
    $Self->{Translation}->{'pending approval'} = '待审批';
    $Self->{Translation}->{'pending pir'} = '等待实施后审查';
    $Self->{Translation}->{'pir'} = 'PIR (实施后审查)';
    $Self->{Translation}->{'ready'} = '准备开始';
    $Self->{Translation}->{'rejected'} = '被拒绝';
    $Self->{Translation}->{'requested'} = '请求';
    $Self->{Translation}->{'retracted'} = '撤回';
    $Self->{Translation}->{'set'} = '设置';
    $Self->{Translation}->{'successful'} = '成功';

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category <-> Impact <-> Priority'} = '类别 <-> 影响 <-> 优先级';
    $Self->{Translation}->{'Manage the priority result of combinating Category <-> Impact.'} =
        '"类别 <-> 影响"之间的组合决定优先级。';
    $Self->{Translation}->{'Priority allocation'} = '优先级分配';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = '管理变更通知';
    $Self->{Translation}->{'Add Notification Rule'} = '添加通知规则';
    $Self->{Translation}->{'Rule'} = '规则';
    $Self->{Translation}->{'Recipients'} = '接收人';
    $Self->{Translation}->{'A notification should have a name!'} = '通知必须有名称！';
    $Self->{Translation}->{'Name is required.'} = '名称是必需的。';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = '管理状态机';
    $Self->{Translation}->{'Select a catalog class!'} = '选择目录类';
    $Self->{Translation}->{'A catalog class is required!'} = '目录类是必需的！';
    $Self->{Translation}->{'Add a state transition'} = '添加一个状态转换';
    $Self->{Translation}->{'Catalog Class'} = '目录类';
    $Self->{Translation}->{'Object Name'} = '对象名称';
    $Self->{Translation}->{'Overview over state transitions for'} = '状态转换概况';
    $Self->{Translation}->{'Delete this state transition'} = '删除这个状态转换';
    $Self->{Translation}->{'Add a new state transition for'} = '添加一个新的转换状态';
    $Self->{Translation}->{'Please select a state!'} = '请选择一个状态！';
    $Self->{Translation}->{'Please select a next state!'} = '请选择下一步状态';
    $Self->{Translation}->{'Edit a state transition for'} = '编辑转换状态';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = '你确定要删除这个状态转换吗?';
    $Self->{Translation}->{'from'} = '';

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = '创建变更';
    $Self->{Translation}->{'ITSM Change'} = '变更';
    $Self->{Translation}->{'Justification'} = '理由';
    $Self->{Translation}->{'Input invalid.'} = '输入无效。';
    $Self->{Translation}->{'Impact'} = '影响';
    $Self->{Translation}->{'Requested Date'} = '请求日期';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = '选择变更模板';
    $Self->{Translation}->{'Time type'} = '时间类型';
    $Self->{Translation}->{'Invalid time type.'} = '无效的时间类型。';
    $Self->{Translation}->{'New time'} = '新的时间';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = '保存变更CAB至模板';
    $Self->{Translation}->{'go to involved persons screen'} = '转向相关人员窗口';
    $Self->{Translation}->{'This field is required'} = '这个字段是必需的';
    $Self->{Translation}->{'Invalid Name'} = '无效的名称';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = '条件和操作';
    $Self->{Translation}->{'Delete Condition'} = '删除条件';
    $Self->{Translation}->{'Add new condition'} = '添加新的条件';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = '需要一个有效的名称';
    $Self->{Translation}->{'A a valid name is needed.'} = '需要一个有效的名称。';
    $Self->{Translation}->{'Duplicate name:'} = '重复的名称：';
    $Self->{Translation}->{'This name is already used by another condition.'} = '另一个条件已被使用过该名称。';
    $Self->{Translation}->{'Matching'} = '匹配';
    $Self->{Translation}->{'Any expression (OR)'} = '任意表达式(或)';
    $Self->{Translation}->{'All expressions (AND)'} = '所有表达式(与)';
    $Self->{Translation}->{'Expressions'} = '表达式';
    $Self->{Translation}->{'Selector'} = '选择器';
    $Self->{Translation}->{'Operator'} = '操作符';
    $Self->{Translation}->{'Delete Expression'} = '删除表达式';
    $Self->{Translation}->{'No Expressions found.'} = '没有找到表达式';
    $Self->{Translation}->{'Add new expression'} = '添加新的表达式';
    $Self->{Translation}->{'Delete Action'} = '删除操作';
    $Self->{Translation}->{'No Actions found.'} = '没有找到操作';
    $Self->{Translation}->{'Add new action'} = '添加新的操作';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = '你确定要删除这个变更吗?';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'Workorder'} = '工作指令';
    $Self->{Translation}->{'Show details'} = '显示详情';
    $Self->{Translation}->{'Show workorder'} = '显示工作指令';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of'} = '详细历史信息';
    $Self->{Translation}->{'Modified'} = '修改';
    $Self->{Translation}->{'Old Value'} = '旧值';
    $Self->{Translation}->{'New Value'} = '新值';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Involved Persons'} = '相关人员';
    $Self->{Translation}->{'ChangeManager'} = '变更经理';
    $Self->{Translation}->{'User invalid.'} = '用户无效。';
    $Self->{Translation}->{'ChangeBuilder'} = '变更创建人';
    $Self->{Translation}->{'Change Advisory Board'} = '变更审批委员会';
    $Self->{Translation}->{'CAB Template'} = 'CAB模板';
    $Self->{Translation}->{'Apply Template'} = '应用模板';
    $Self->{Translation}->{'NewTemplate'} = '新模板';
    $Self->{Translation}->{'Save this CAB as template'} = '保存这个CAB至模板';
    $Self->{Translation}->{'Add to CAB'} = '添加至CAB';
    $Self->{Translation}->{'Invalid User'} = '无效的用户';
    $Self->{Translation}->{'Current CAB'} = '当前CAB';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = '上下文设置';
    $Self->{Translation}->{'Changes per page'} = '每页显示的变更个数';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'WorkOrderTitle'} = '工作指令标题';
    $Self->{Translation}->{'ChangeTitle'} = '变更标题';
    $Self->{Translation}->{'WorkOrderAgent'} = '工作指令服务人员';
    $Self->{Translation}->{'Workorders'} = '工作指令';
    $Self->{Translation}->{'ChangeState'} = '变更状态';
    $Self->{Translation}->{'WorkOrderState'} = '工作指令状态';
    $Self->{Translation}->{'WorkOrderType'} = '工作指令类型';
    $Self->{Translation}->{'Requested Time'} = '请求时间';
    $Self->{Translation}->{'PlannedStartTime'} = '计划开始时间';
    $Self->{Translation}->{'PlannedEndTime'} = '计划结束时间';
    $Self->{Translation}->{'ActualStartTime'} = '实际开始时间';
    $Self->{Translation}->{'ActualEndTime'} = '实际结束时间';

    # Template: AgentITSMChangePrint
    $Self->{Translation}->{'ITSM Workorder'} = '工作指令';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = '你确定要删除这个变更吗？';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '';
    $Self->{Translation}->{'CABAgent'} = 'CAB服务人员';
    $Self->{Translation}->{'e.g.'} = '';
    $Self->{Translation}->{'CABCustomer'} = 'CAB用户';
    $Self->{Translation}->{'Instruction'} = '指示';
    $Self->{Translation}->{'Report'} = '报告';
    $Self->{Translation}->{'Change Category'} = '变更类别';
    $Self->{Translation}->{'(before/after)'} = '';
    $Self->{Translation}->{'(between)'} = '';

    # Template: AgentITSMChangeSearchResultPrint
    $Self->{Translation}->{'WorkOrders'} = '工作指令';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = '保存变更至模板';
    $Self->{Translation}->{'A template should have a name!'} = '模板应有名称!';
    $Self->{Translation}->{'The template name is required.'} = '模板名称是必需的。';
    $Self->{Translation}->{'Reset States'} = '重置状态';
    $Self->{Translation}->{'Overwrite original template'} = '';
    $Self->{Translation}->{'Delete original change'} = '';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = '修改时间计划';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = '变更信息';
    $Self->{Translation}->{'PlannedEffort'} = '计划工作量';
    $Self->{Translation}->{'Change Initiator(s)'} = '变更发起人';
    $Self->{Translation}->{'Change Manager'} = '变更经理';
    $Self->{Translation}->{'Change Builder'} = '变更创建人';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = '上次修改';
    $Self->{Translation}->{'Last changed by'} = '上次修改人';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        '';
    $Self->{Translation}->{'Download Attachment'} = '下载附件';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = '你确定要删除这个模板吗？';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = '';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        '';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        '';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        '';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        '';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        '';
    $Self->{Translation}->{'Do you want to proceed?'} = '';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = '模板编号';
    $Self->{Translation}->{'Edit Content'} = '';
    $Self->{Translation}->{'CreateBy'} = '创建人';
    $Self->{Translation}->{'CreateTime'} = '创建时间';
    $Self->{Translation}->{'ChangeBy'} = '修改人';
    $Self->{Translation}->{'ChangeTime'} = '修改时间';
    $Self->{Translation}->{'Edit Template Content'} = '';
    $Self->{Translation}->{'Delete Template'} = '删除模板';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = '将工作指令添加至';
    $Self->{Translation}->{'Invalid workorder type.'} = '无效的工作指令类型';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = '计划开始时间必须在计划结束时间之前!';
    $Self->{Translation}->{'Invalid format.'} = '无效的格式.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = '选择工作指令模板';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = '你确定要删除这个工作指令吗?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        '你无法删除这个工作单。至少有一个条件用到了它!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = '此工作指令出现在下列条件中';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = '相应的移动工作指令';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        '如果该工作指令的计划结束时间改变了，所有后续工作指令的计划开始时间将相应的改变';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = '实际开始时间必须在实际结束时间之前!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        '设置实际结束时间后必须设置实际开始时间!';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = '当前的服务人员';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = '你确定要删除这个工作指令吗?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = '保存工作指令至模板';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = '';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = '工作指令信息';

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        '';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        '';
    $Self->{Translation}->{'Admin of notification rules.'} = '通知规则管理';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = '管理CIP矩阵';
    $Self->{Translation}->{'Admin of the state machine.'} = '管理状态机';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        '';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        '';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        '';
    $Self->{Translation}->{'Agent interface notification module to see the number of work orders.'} =
        '';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        '';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        '';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = '';
    $Self->{Translation}->{'Change and WorkOrder templates edited by this user.'} = '';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small"'} = '';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = '';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        '';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        '';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        '';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = '';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = '';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = '';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = '';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        '';
    $Self->{Translation}->{'Defines if the change state can be set in AgentITSMChangeEdit.'} =
        '';
    $Self->{Translation}->{'Defines if the planned effort should be shown.'} = '';
    $Self->{Translation}->{'Defines if the requested date should be print by customer.'} = '';
    $Self->{Translation}->{'Defines if the requested date should be searched by customer.'} =
        '';
    $Self->{Translation}->{'Defines if the requested date should be set by customer.'} = '';
    $Self->{Translation}->{'Defines if the requested date should be shown by customer.'} = '';
    $Self->{Translation}->{'Defines if the workorder state should be shown.'} = '';
    $Self->{Translation}->{'Defines if the workorder title should be shown.'} = '';
    $Self->{Translation}->{'Defines shown graph attributes.'} = '';
    $Self->{Translation}->{'Defines that only changes containing Workorders linked with services, which the customer user has permission to use will be shown. Any other changes will not be displayed.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change PSA overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change Schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyCAB overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyChanges overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change manager overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the customer change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default change title for a dummy change which is needed to edit a workorder template.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria in the change PSA overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria in the change manager overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria in the change overview.'} = '';
    $Self->{Translation}->{'Defines the default sort criteria in the change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyCAB overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyChanges overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyWorkorders overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the PIR overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the customer change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the template overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the MyCAB overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the MyChanges overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the MyWorkorders overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the PIR overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the change PSA overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the change manager overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the change overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the customer change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the template overview.'} = '';
    $Self->{Translation}->{'Defines the default value for the category of a change.'} = '';
    $Self->{Translation}->{'Defines the default value for the impact of a change.'} = '';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for change attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        '';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for workorder attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        '';
    $Self->{Translation}->{'Defines the object attributes that are selectable for change objects in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the object attributes that are selectable for workorder objects in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute AccountedTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualEndTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualStartTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute CategoryID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeBuilderID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeManagerID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeStateID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeTitle in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute DynamicField in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ImpactID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEffort in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEndTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedStartTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PriorityID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute RequestedTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderAgentID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderNumber in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderStateID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTitle in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTypeID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the period (in years), in which start and end times can be selected.'} =
        '';
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom. To show workorder dynamic fields in the tooltip, they must be specified like DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, etc.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the Change PSA overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the Change Schedule overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the MyCAB overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the MyChanges overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the MyWorkorders overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the PIR overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the change manager overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the change overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the change search. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the customer change schedule overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the template overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the signals for each ITSMChange state.'} = '';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        '';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        '';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        '';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        '';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = '';
    $Self->{Translation}->{'Determines if an agent can exchange the X-axis of a stat if he generates one.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes done for config item classes.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding change state updates within a timeperiod.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding the relation between changes and incident tickets.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about the number of Rfc tickets a requester created.'} =
        '';
    $Self->{Translation}->{'Dynamic fields (for changes and workorders) shown in the change print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change add screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change edit screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder add screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder edit screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder report screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'DynamicField event module to handle the update of conditions if dynamic fields are added, updated or deleted.'} =
        '';
    $Self->{Translation}->{'ITSM event module deletes the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = '';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = '';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        '';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = '';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = '';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        '';
    $Self->{Translation}->{'ITSM event module updates the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module updates the history of conditions.'} = '';
    $Self->{Translation}->{'ITSM event module updates the history of workorders.'} = '';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notications are sent (every X hours).'} =
        '';
    $Self->{Translation}->{'Logfile for the ITSM change counter. This file is used for creating the change numbers.'} =
        '';
    $Self->{Translation}->{'Module to check if WorkOrderAdd or WorkOrderAddFromTemplate should be permitted.'} =
        '';
    $Self->{Translation}->{'Module to check the CAB members.'} = '';
    $Self->{Translation}->{'Module to check the agent.'} = '';
    $Self->{Translation}->{'Module to check the change builder.'} = '';
    $Self->{Translation}->{'Module to check the change manager.'} = '';
    $Self->{Translation}->{'Module to check the workorder agent.'} = '';
    $Self->{Translation}->{'Module to check whether no workorder agent is set.'} = '';
    $Self->{Translation}->{'Module to check whether the agent is contained in the configured list.'} =
        '';
    $Self->{Translation}->{'Module to show a link to create a change from this ticket. The ticket will be automatically linked with the new change.'} =
        '';
    $Self->{Translation}->{'Notification (ITSM Change Management)'} = '通知 (变更管理)';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        '';
    $Self->{Translation}->{'Parameters for the UserCreateWorkOrderNextMask object in the preference view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        '';
    $Self->{Translation}->{'Presents a link in the menu to show the involved persons in a change, in the zoom view of such change in the agent interface.'} =
        '';
    $Self->{Translation}->{'Required privileges in order for an agent to take a workorder.'} =
        '';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = '';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = '';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = '';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        '';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = '';
    $Self->{Translation}->{'Required privileges to create changes.'} = '';
    $Self->{Translation}->{'Required privileges to delete a template.'} = '';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to delete changes.'} = '';
    $Self->{Translation}->{'Required privileges to edit a template.'} = '';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to edit changes.'} = '';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = '';
    $Self->{Translation}->{'Required privileges to edit the content of a template.'} = '';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        '';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = '';
    $Self->{Translation}->{'Required privileges to print a change.'} = '';
    $Self->{Translation}->{'Required privileges to reset changes.'} = '';
    $Self->{Translation}->{'Required privileges to view a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to view changes.'} = '';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is a CAB member.'} =
        '';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is the change manager.'} =
        '';
    $Self->{Translation}->{'Required privileges to view overview over all templates.'} = '';
    $Self->{Translation}->{'Required privileges to view the conditions of changes.'} = '';
    $Self->{Translation}->{'Required privileges to view the history of a change.'} = '';
    $Self->{Translation}->{'Required privileges to view the history of a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to view the history zoom of a change.'} = '';
    $Self->{Translation}->{'Required privileges to view the history zoom of a workorder.'} =
        '';
    $Self->{Translation}->{'Required privileges to view the list of Change Schedule.'} = '';
    $Self->{Translation}->{'Required privileges to view the list of change PSA.'} = '';
    $Self->{Translation}->{'Required privileges to view the list of changes with an upcoming PIR (Post Implementation Review).'} =
        '';
    $Self->{Translation}->{'Required privileges to view the list of own changes.'} = '';
    $Self->{Translation}->{'Required privileges to view the list of own workorders.'} = '';
    $Self->{Translation}->{'Required privileges to write a report for the workorder.'} = '';
    $Self->{Translation}->{'Screen after creating a workorder'} = '创建工作指令后的视图';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        '';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in AgentITSMChangeZoom and AgentITSMWorkOrderZoom.'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in AgentITSMChangeZoom and AgentITSMWorkOrderZoom.'} =
        '';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        '';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = '';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = '';
    $Self->{Translation}->{'Show this screen after I created a new workorder'} = '创建工作指令后显示的页面';
    $Self->{Translation}->{'Shows a checkbox in the AgentITSMWorkOrderEdit screen that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the work order agent, in the zoom view of such work order of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a work order as a template in the zoom view of the work order, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workd order, in the zoom view of such work order of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a work order with another object in the zoom view of such work order of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows moving the time slot of a change in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows taking a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the conditions of a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to add a work order in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to delete a work order in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the work order zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        '';
    $Self->{Translation}->{'State Machine'} = '状态机';
    $Self->{Translation}->{'Stores change and workorder ids and their corresponding template id, while a user is editing a template.'} =
        '';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        '';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        '';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        '';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        '';

}

1;
