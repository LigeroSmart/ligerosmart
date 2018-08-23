# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::zh_CN_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminDynamicFieldMasterSlave
    $Self->{Translation}->{'Field'} = '字段';

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Manage Master/Slave status for %s%s%s'} = '管理%s%s%s的 主/从 状态';

    # Perl Module: Kernel/Modules/AgentTicketMasterSlave.pm
    $Self->{Translation}->{'New Master Ticket'} = '新建主工单';
    $Self->{Translation}->{'Unset Master Ticket'} = '主工单转为普通工单';
    $Self->{Translation}->{'Unset Slave Ticket'} = '从工单转为普通工单';
    $Self->{Translation}->{'Slave of %s%s%s: %s'} = '%s%s%s的从工单：%s';

    # Perl Module: Kernel/Output/HTML/TicketBulk/MasterSlave.pm
    $Self->{Translation}->{'Unset Master Tickets'} = '取消主工单设置';
    $Self->{Translation}->{'Unset Slave Tickets'} = '取消从工单设置';

    # Perl Module: Kernel/System/DynamicField/Driver/MasterSlave.pm
    $Self->{Translation}->{'Master'} = '主';
    $Self->{Translation}->{'Slave of %s%s%s'} = '%s%s%s的从工单';
    $Self->{Translation}->{'Master Ticket'} = '主工单';

    # SysConfig
    $Self->{Translation}->{'All master tickets'} = '所有的主工单';
    $Self->{Translation}->{'All slave tickets'} = '所有的从工单';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '服务人员界面主/从工单详情窗口允许添加备注。';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = '修改工单主/从状态。';
    $Self->{Translation}->{'Defines dynamic field name for master ticket feature.'} = '定义主工单功能的动态字段名称。';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        '定义服务人员界面在工单主从设置窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '定义服务人员界面在工单主从设置窗口添加备注后的默认下一个工单状态。';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '定义服务人员界面在工单主从设置窗口添加备注后工单的默认优先级。';
    $Self->{Translation}->{'Defines the default type of the note in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '定义服务人员界面在工单主从设置窗口添加备注后工单的默认备注类型。';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        '定义工单主从设置窗口操作的历史注释，以用于服务人员界面的工单历史。';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        '定义工单主从设置窗口操作的历史类型，以用于服务人员界面的工单历史。';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '定义服务人员界面在工单主从设置窗口添加备注后的下一个工单状态。';
    $Self->{Translation}->{'Enables the advanced MasterSlave part of the feature.'} = '启用主从功能的高级模式。';
    $Self->{Translation}->{'Enables the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'} =
        '启用高级主从模式下从工单随主工单到一个新的主工单的功能。';
    $Self->{Translation}->{'Enables the feature to change the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        '启用本功能后，可修改一个工单在高级主从模式下的主从状态。';
    $Self->{Translation}->{'Enables the feature to forward articles from type \'forward\' of a master ticket to the customers of the slave tickets. By default (disabled) it will not forward articles from type \'forward\' to the slave tickets.'} =
        '启用本功能后，将“转发”类型的主工单信件转发到从工单的客户。默认（已禁用）不转发“转发”类型的信件到从工单。';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after change of the MasterSlave state in the advanced MasterSlave mode.'} =
        '启用本功能后，在高级主从模式下修改主从状态后保持父子链接。';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after unset of the MasterSlave state in the advanced MasterSlave mode.'} =
        '启用本功能后，在高级主从模式下取消主从状态后保持父子链接。';
    $Self->{Translation}->{'Enables the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        '启用本功能后，可取消一个工单在高级主从模式下的主从状态。';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '服务人员界面主/从工单详情窗口，如果服务人员添加了备注，设置工单的状态。';
    $Self->{Translation}->{'Master / Slave'} = '主/从';
    $Self->{Translation}->{'Master Tickets'} = '主工单';
    $Self->{Translation}->{'MasterSlave'} = '主从';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = '工单批量操作功能的主从工单批量设置模块';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        '定义服务人员界面仪表板主工单概览后端的参数。“Limit（限制）定义默认显示的条目数；“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）；“Default（默认）”代表这个插件是默认启用还是需要用户手动启用；“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        '定义服务人员界面仪表板从工单概览后端的参数。“Limit（限制）定义默认显示的条目数；“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）；“Default（默认）”代表这个插件是默认启用还是需要用户手动启用；“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。';
    $Self->{Translation}->{'Registration of the ticket event module.'} = '注册到工单事件模块。';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '服务人员界面使用主从工单详情窗口必需的权限。';
    $Self->{Translation}->{'Sets if Master / Slave field must be selected by the agent.'} = '设置服务人员是否必须选择主从字段。';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '设置服务人员界面主从工单详情窗口添加备注的的默认正文文本。';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '设置服务人员界面主从工单详情窗口添加备注的的默认主题。';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '设置服务人员界面主从工单详情窗口工单的负责人。';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        '设置服务人员界面主从工单详情窗口工单的服务（需要激活工单::服务）。';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '设置服务人员界面主从工单详情窗口工单的所有者。';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        '设置服务人员界面主从工单详情窗口设置工单的类型（需要激活工单::类型）。';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        '在服务人员界面工单详情视图中，为修改主从工单状态菜单显示一个链接。';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '在服务人员界面主从工单详情窗口，显示这个工单相关的所有服务人员列表。';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '在服务人员界面主从工单详情窗口，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表，用于确定谁将收到关于这个备注的通知。';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '在服务人员界面主从工单详情窗口是否显示工单优先级的选项。';
    $Self->{Translation}->{'Shows the title field in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '在服务人员界面主从工单详情窗口显示工单标题字段。';
    $Self->{Translation}->{'Slave Tickets'} = '从工单';
    $Self->{Translation}->{'Specifies the different article types where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        '指定使用从工单的客户真实姓名替换主工单的真空姓名的信件类型。';
    $Self->{Translation}->{'Specifies the different note types that will be used in the system.'} =
        '指定将在系统中使用的不同备注类型。';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        '这个模块用来激活新建邮件/电话工单窗口的主从字段。';
    $Self->{Translation}->{'Ticket MasterSlave.'} = '主从工单。';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
