# --
# Kernel/Language/zh_CN_ITSMCore.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# Copyright (C) 2013 Michael Shi <micshi at 163.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_ITSMCore;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = '可供选择';
    $Self->{Translation}->{'Availability'} = '可用性';
    $Self->{Translation}->{'Back End'} = '后端';
    $Self->{Translation}->{'Connected to'} = '连接';
    $Self->{Translation}->{'Current State'} = '当前状态';
    $Self->{Translation}->{'Demonstration'} = '演示';
    $Self->{Translation}->{'Depends on'} = '依赖';
    $Self->{Translation}->{'End User Service'} = '最终用户服务';
    $Self->{Translation}->{'Errors'} = '错误';
    $Self->{Translation}->{'Front End'} = '前端';
    $Self->{Translation}->{'IT Management'} = 'IT管理';
    $Self->{Translation}->{'IT Operational'} = 'IT运营';
    $Self->{Translation}->{'Impact'} = '影响';
    $Self->{Translation}->{'Incident State'} = '故障状态';
    $Self->{Translation}->{'Includes'} = '包括';
    $Self->{Translation}->{'Other'} = '其它';
    $Self->{Translation}->{'Part of'} = '属于';
    $Self->{Translation}->{'Project'} = '项目';
    $Self->{Translation}->{'Recovery Time'} = '恢复时间';
    $Self->{Translation}->{'Relevant to'} = '相关';
    $Self->{Translation}->{'Reporting'} = '报告';
    $Self->{Translation}->{'Required for'} = '需要';
    $Self->{Translation}->{'Resolution Rate'} = '解决率';
    $Self->{Translation}->{'Response Time'} = '响应时间';
    $Self->{Translation}->{'SLA Overview'} = 'SLA概述';
    $Self->{Translation}->{'Service Overview'} = '服务概述';
    $Self->{Translation}->{'Service-Area'} = '服务区';
    $Self->{Translation}->{'Training'} = '培训';
    $Self->{Translation}->{'Transactions'} = '交易';
    $Self->{Translation}->{'Underpinning Contract'} = '依据合同';
    $Self->{Translation}->{'allocation'} = '分配';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = '重要 <-> 影响 <-> 优先级';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        '"重要 <-> 影响"之间的组合决定优先级';
    $Self->{Translation}->{'Priority allocation'} = '优先级分配';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = '故障间最短时间';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = '重要';

    # Template: AgentITSMCustomerSearch

    # Template: AgentITSMSLA

    # Template: AgentITSMSLAPrint
    $Self->{Translation}->{'SLA-Info'} = '';
    $Self->{Translation}->{'Last changed'} = '上次修改于';
    $Self->{Translation}->{'Last changed by'} = '上次修改人';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'SLA信息';
    $Self->{Translation}->{'Associated Services'} = '关联的服务';

    # Template: AgentITSMService

    # Template: AgentITSMServicePrint
    $Self->{Translation}->{'Service-Info'} = '';
    $Self->{Translation}->{'Current Incident State'} = '当前故障状态';
    $Self->{Translation}->{'Associated SLAs'} = '关联的SLAs';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = '服务信息';
    $Self->{Translation}->{'Current incident state'} = '当前故障状态';

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
    $Self->{Translation}->{'Manage priority matrix.'} = '管理优先级矩阵';
    $Self->{Translation}->{'Module to show back link in service menu.'} = '';
    $Self->{Translation}->{'Module to show back link in sla menu.'} = '';
    $Self->{Translation}->{'Module to show print link in service menu.'} = '';
    $Self->{Translation}->{'Module to show print link in sla menu.'} = '';
    $Self->{Translation}->{'Module to show the link link in service menu.'} = '';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = '';
    $Self->{Translation}->{'Set the type of link to be used to calculate the incident state.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'Width of ITSM textareas.'} = '';

    # Missed Translation Items
    $Self->{Translation}->{'Category <-> Impact <-> Priority'} = '类别 <-> 影响 <-> 优先级';
    $Self->{Translation}->{'Manage the priority result of combinating Category <-> Impact.'} = '"类别 <-> 影响"之间的组合决定优先级';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = '管理CIP矩阵';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
