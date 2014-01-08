# --
# Kernel/Language/zh_CN_ITSMChangeManagement.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# Copyright (C) 2013 Michael Shi <micshi at 163.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_ITSMChangeManagement;

use strict;
use warnings;

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
    $Self->{Translation}->{'Agent interface module to show the ChangeManager overview icon.'} = '';
    $Self->{Translation}->{'Agent interface module to show the MyCAB overview icon.'} = '';
    $Self->{Translation}->{'Agent interface module to show the MyChanges overview icon.'} = '';
    $Self->{Translation}->{'Agent interface module to show the MyWorkOrders overview icon.'} = '';
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
    $Self->{Translation}->{'Projected Service Availability (PSA)'} = 'PSA (计划服务可用性)';
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
    $Self->{Translation}->{'Attribute'} = '属性';
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

    # Template: AgentITSMCABMemberSearch

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

    # Template: AgentITSMChangeEdit

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
    $Self->{Translation}->{'Run Search'} = '搜索';

    # Template: AgentITSMChangeSearchResultPrint
    $Self->{Translation}->{'WorkOrders'} = '工作指令';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = '保存变更至模板';
    $Self->{Translation}->{'A template should have a name!'} = '模板应有名称!';
    $Self->{Translation}->{'The template name is required.'} = '模板名称是必需的。';
    $Self->{Translation}->{'Reset States'} = '重置状态';

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
    $Self->{Translation}->{'Download Attachment'} = '下载附件';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = '你确定要删除这个模板吗？';

    # Template: AgentITSMTemplateEdit

    # Template: AgentITSMTemplateOverviewNavBar

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = '模板编号';
    $Self->{Translation}->{'CreateBy'} = '创建人';
    $Self->{Translation}->{'CreateTime'} = '创建时间';
    $Self->{Translation}->{'ChangeBy'} = '修改人';
    $Self->{Translation}->{'ChangeTime'} = '修改时间';
    $Self->{Translation}->{'Delete: '} = '删除';
    $Self->{Translation}->{'Delete Template'} = '删除模板';

    # Template: AgentITSMUserSearch

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = '将工作指令添加至';
    $Self->{Translation}->{'Invalid workorder type.'} = '无效的工作指令类型';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = '计划开始时间必须在计划结束时间之前!';
    $Self->{Translation}->{'Invalid format.'} = '无效的格式.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = '选择工作指令模板';

    # Template: AgentITSMWorkOrderAgent

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = '你确定要删除这个工作指令吗?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} = '你无法删除这个工作单。至少有一个条件用到了它!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = '此工作指令出现在下列条件中';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = '相应的移动工作指令';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        '如果该工作指令的计划结束时间改变了，所有后续工作指令的计划开始时间将相应的改变';

    # Template: AgentITSMWorkOrderHistory

    # Template: AgentITSMWorkOrderHistoryZoom

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = '实际开始时间必须在实际结束时间之前!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} = '设置实际结束时间后必须设置实际开始时间!';
    $Self->{Translation}->{'Existing attachments'} = '现有的附件';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = '当前的服务人员';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = '你确定要删除这个工作指令吗?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = '保存工作指令至模板';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = '工作指令信息';

    # Template: CustomerITSMChangeOverview

    # Template: ITSMChange

    # SysConfig
    $Self->{Translation}->{'Admin of notification rules.'} = '通知规则管理';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = '管理CIP矩阵';
    $Self->{Translation}->{'Admin of the state machine.'} = '管理状态机';
    $Self->{Translation}->{'Screen after creating a workorder'}
        = '创建工作指令后的视图';
    $Self->{Translation}->{'Show this screen after I created a new workorder'}
        = '创建工作指令后显示的页面';
    $Self->{Translation}->{'Duplicate name:'}
        = '重复的名称：';
    $Self->{Translation}->{'This name is already used by another condition.'}
        = '另一个条件已被使用过该名称。';
    $Self->{Translation}->{'Notification (ITSM Change Management)'} = '通知 (变更管理)';
        $Self->{Translation}->{'State Machine'} = '状态机';


    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Adapts the width of the autocomplete drop down to the length of the longest option.'} =
        '';
    $Self->{Translation}->{'CAB Agent'} = 'CAB服务人员';
    $Self->{Translation}->{'CAB Customer'} = 'CAB用户';
    $Self->{Translation}->{'Cache time in minutes for the change management.'} = '变更管理缓存时间（分钟）。';
    $Self->{Translation}->{'Change Description'} = '变更描述';
    $Self->{Translation}->{'Change Impact'} = '变更影响';
    $Self->{Translation}->{'Change Justification'} = '变更理由';
    $Self->{Translation}->{'Change Number'} = '变更编号';
    $Self->{Translation}->{'Change Priority'} = '变更优先级';
    $Self->{Translation}->{'Change State'} = '变更状态';
    $Self->{Translation}->{'Change Title'} = '变更标题';
    $Self->{Translation}->{'Created By'} = '创建人';
    $Self->{Translation}->{'Delete Change'} = '删除变更';
    $Self->{Translation}->{'Reset change and its workorders'} = '重置变更和相应的工作指令';
    $Self->{Translation}->{'Search Agent'} = '搜索服务人员';
    $Self->{Translation}->{'Work Order Title'} = '工作指令标题';
    $Self->{Translation}->{'WorkOrder Agent'} = '工作指令服务人员';

    $Self->{Translation}->{'WorkOrder Instruction'} = '工作指令指示';
    $Self->{Translation}->{'WorkOrder Report'} = '工作指令报告';
    $Self->{Translation}->{'WorkOrder State'} = '工作指令状态';

    #Missed Translation Item
    $Self->{Translation}->{'Schedule'} = '计划';
    $Self->{Translation}->{'Projected Service Availability'} = '计划服务可用性';
    $Self->{Translation}->{'ChangeInitiators'} = '变更发起人';
    $Self->{Translation}->{'GroupITSMChange'} = '组ITSM变更';
    $Self->{Translation}->{'GroupITSMChangeBuilder'} = '组ITSM变更创建人';
    $Self->{Translation}->{'GroupITSMChangeManager'} = '组ITSM变更经理';
    $Self->{Translation}->{'OldChangeBuilder'} = '旧变更创建人';
    $Self->{Translation}->{'OldChangeManager'} = '旧变更经理';
    $Self->{Translation}->{'OldWorkOrderAgent'} = '旧工单指令服务人员';
    $Self->{Translation}->{'WorkOrderAgents'} = '所有工作指令服务人员';
}

1;
