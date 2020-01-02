# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::zh_CN_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketOverviewMedium
    $Self->{Translation}->{'Criticality'} = '紧急度';
    $Self->{Translation}->{'Impact'} = '影响度';

    # JS Template: ServiceIncidentState
    $Self->{Translation}->{'Service Incident State'} = '服务故障状态';

    # Perl Module: Kernel/Output/HTML/FilterElementPost/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Link ticket'} = '链接工单';
    $Self->{Translation}->{'Change Decision of %s%s%s'} = '工单 %s%s%s的变更决定';
    $Self->{Translation}->{'Change ITSM fields of %s%s%s'} = '修改%s%s%s的ITSM字段';

    # Perl Module: var/packagesetup/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Review Required'} = '需要复审';
    $Self->{Translation}->{'Decision Result'} = '决定结果';
    $Self->{Translation}->{'Approved'} = '通过审批';
    $Self->{Translation}->{'Postponed'} = '推迟';
    $Self->{Translation}->{'Pre-approved'} = '预先批准';
    $Self->{Translation}->{'Rejected'} = '驳回';
    $Self->{Translation}->{'Repair Start Time'} = '修复开始时间';
    $Self->{Translation}->{'Recovery Start Time'} = '恢复开始时间';
    $Self->{Translation}->{'Decision Date'} = '决定日期';
    $Self->{Translation}->{'Due Date'} = '到期日';

    # Database XML Definition: ITSMIncidentProblemManagement.sopm
    $Self->{Translation}->{'closed with workaround'} = '通过权变措施关闭';

    # SysConfig
    $Self->{Translation}->{'Add a decision!'} = '添加决定!';
    $Self->{Translation}->{'Additional ITSM Fields'} = '额外的ITSM字段';
    $Self->{Translation}->{'Additional ITSM ticket fields.'} = '额外的ITSM工单字段。';
    $Self->{Translation}->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} =
        '服务人员界面额外的ITSM字段窗口允许添加备注。';
    $Self->{Translation}->{'Allows adding notes in the decision screen of the agent interface.'} =
        '服务人员界面决定窗口允许添加备注。';
    $Self->{Translation}->{'Allows defining new types for ticket (if ticket type feature is enabled).'} =
        '允许定义新的工单类型（如果启用了工单类型功能）。';
    $Self->{Translation}->{'Change the ITSM fields!'} = '修改ITSM字段!';
    $Self->{Translation}->{'Decision'} = '决定';
    $Self->{Translation}->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        '定义服务人员界面在工单额外的ITSM字段窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。';
    $Self->{Translation}->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        '定义服务人员界面在工单决定窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。';
    $Self->{Translation}->{'Defines if the service incident state should be shown during service selection in the agent interface.'} =
        '定义服务人员界面在选择服务期间是否显示服务故障状态。';
    $Self->{Translation}->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} =
        '定义服务人员界面在工单额外的ITSM字段窗口备注的默认正文内容。';
    $Self->{Translation}->{'Defines the default body of a note in the decision screen of the agent interface.'} =
        '定义服务人员界面在工单决定窗口备注的默认正文内容。';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        '定义服务人员界面在工单额外的ITSM字段窗口添加备注后的默认下一个工单状态。';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        '定义服务人员界面在工单决定窗口添加备注后的默认下一个工单状态。';
    $Self->{Translation}->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} =
        '定义服务人员界面在工单额外的ITSM字段窗口工单备注的默认主题。';
    $Self->{Translation}->{'Defines the default subject of a note in the decision screen of the agent interface.'} =
        '定义服务人员界面在工单决定窗口工单备注的默认主题。';
    $Self->{Translation}->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} =
        '定义服务人员界面在工单额外的ITSM字段窗口默认的工单优先级。';
    $Self->{Translation}->{'Defines the default ticket priority in the decision screen of the agent interface.'} =
        '定义服务人员界面在工单决定窗口默认的工单优先级。';
    $Self->{Translation}->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} =
        '定义工单额外的ITSM字段窗口操作的历史注释，用于工单历史。';
    $Self->{Translation}->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} =
        '定义工单决定窗口操作的历史注释，用于工单历史。';
    $Self->{Translation}->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} =
        '定义工单额外的ITSM字段窗口操作的历史类型，用于工单历史。';
    $Self->{Translation}->{'Defines the history type for the decision screen action, which gets used for ticket history.'} =
        '定义工单决定窗口操作的历史类型，用于工单历史。';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        '定义服务人员界面在工单额外的ITSM字段窗口添加备注后的下一个工单状态。';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        '定义服务人员界面在工单决定窗口添加备注后的下一个工单状态。';
    $Self->{Translation}->{'Dynamic fields shown in the additional ITSM field screen of the agent interface.'} =
        '在服务人员界面的附加ITSM字段窗口中显示的动态字段。';
    $Self->{Translation}->{'Dynamic fields shown in the decision screen of the agent interface.'} =
        '服务人员界面决定窗口中显示的动态字段。';
    $Self->{Translation}->{'Dynamic fields shown in the ticket zoom screen of the agent interface.'} =
        '服务人员界面工单详情窗口中显示的动态字段。';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} =
        '使统计模块能够生成ITSM工单一线平均解决率的统计数据。';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} =
        '使统计模块能够生成ITSM工单平均解决率的统计数据。';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} =
        '在服务人员界面额外的ITSM字段窗口，如果服务人员添加了一个备注，设置工单的状态。';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} =
        '在服务人员界面工单决定窗口，如果服务人员添加了一个备注，设置工单的状态。';
    $Self->{Translation}->{'Modifies the display order of the dynamic field ITSMImpact and other things.'} =
        '修改ITSM影响度等动态字段的显示顺序。';
    $Self->{Translation}->{'Module to dynamically show the service incident state and to calculate the priority.'} =
        '动态显示服务故障状态并计算优先级的模块。';
    $Self->{Translation}->{'Required permissions to use the additional ITSM field screen in the agent interface.'} =
        '服务人员界面使用工单额外的ITSM字段窗口需要的权限。';
    $Self->{Translation}->{'Required permissions to use the decision screen in the agent interface.'} =
        '服务人员界面使用工单决定窗口需要的权限。';
    $Self->{Translation}->{'Service Incident State and Priority Calculation'} = '服务故障状态和优先级计算';
    $Self->{Translation}->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} =
        '设置服务人员界面工单额外的ITSM字段窗口的服务（工单::服务需要被激活）。';
    $Self->{Translation}->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} =
        '设置服务人员界面工单决定窗口的服务（工单::服务需要被激活）。';
    $Self->{Translation}->{'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        '设置服务人员界面工单优先级屏幕的服务（需要激活工单::服务）。';
    $Self->{Translation}->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} =
        '设置服务人员界面工单额外的ITSM字段窗口的工单所有者。';
    $Self->{Translation}->{'Sets the ticket owner in the decision screen of the agent interface.'} =
        '设置服务人员界面工单决定窗口的工单所有者。';
    $Self->{Translation}->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} =
        '设置服务人员界面工单额外的ITSM字段窗口的工单负责人。';
    $Self->{Translation}->{'Sets the ticket responsible in the decision screen of the agent interface.'} =
        '设置服务人员界面工单决定窗口的工单负责人。';
    $Self->{Translation}->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} =
        '设置服务人员界面工单额外的ITSM字段窗口的工单类型（工单::类型需要被激活）。';
    $Self->{Translation}->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} =
        '设置服务人员界面工单决定窗口的工单类型（工单::类型需要被激活）。';
    $Self->{Translation}->{'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        '设置服务人员界面工单优先级屏幕的工单类型（需要激活工单::类型）。';
    $Self->{Translation}->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} =
        '服务人员界面工单详情视图，在菜单中显示一个变更工单决定的链接。';
    $Self->{Translation}->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} =
        '服务人员界面工单详情视图，在菜单中显示一个修改工单额外的ITSM字段的链接。';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} =
        '在服务人员界面工单额外的ITSM字段窗口，显示这个工单涉及的所有服务人员列表。';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} =
        '在服务人员界面工单决定窗口，显示这个工单涉及的所有服务人员列表。';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} =
        '在服务人员界面工单额外的ITSM字段窗口，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表用于确定谁将收到关于这个备注的通知。';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} =
        '在服务人员界面工单决定窗口，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表用于确定谁将收到关于这个备注的通知。';
    $Self->{Translation}->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} =
        '在服务人员界面工单额外的ITSM字段窗口是否显示工单优先级的选项。';
    $Self->{Translation}->{'Shows the ticket priority options in the decision screen of the agent interface.'} =
        '在服务人员界面工单决定窗口是否显示工单优先级的选项。';
    $Self->{Translation}->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} =
        '在服务人员界面工单额外的ITSM字段窗口显示工单标题字段。';
    $Self->{Translation}->{'Shows the title fields in the decision screen of the agent interface.'} =
        '在服务人员界面工单决定窗口显示工单标题字段。';
    $Self->{Translation}->{'Ticket decision.'} = '工单决定。';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Service Incident State',
    );

}

1;
