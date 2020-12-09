# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::zh_CN_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = '紧急度 ↔ 影响 ↔ 优先级';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        '管理"紧急度 ↔ 影响"组合的优先级结果。';
    $Self->{Translation}->{'Priority allocation'} = '优先级分配';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = '故障间最短时间';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = '紧急度';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'SLA信息';
    $Self->{Translation}->{'Last changed'} = '上次修改于';
    $Self->{Translation}->{'Last changed by'} = '上次修改人';
    $Self->{Translation}->{'Associated Services'} = '关联的服务';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = '服务信息';
    $Self->{Translation}->{'Current incident state'} = '当前故障状态';
    $Self->{Translation}->{'Associated SLAs'} = '关联的SLA';

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = '影响';

    # Perl Module: Kernel/Modules/AgentITSMSLAPrint.pm
    $Self->{Translation}->{'No SLAID is given!'} = '没有指定SLA ID！';
    $Self->{Translation}->{'SLAID %s not found in database!'} = '数据库中找不到SLAID %s！';
    $Self->{Translation}->{'Calendar Default'} = '默认日历';

    # Perl Module: Kernel/Modules/AgentITSMSLAZoom.pm
    $Self->{Translation}->{'operational'} = '正常';
    $Self->{Translation}->{'warning'} = '警告';
    $Self->{Translation}->{'incident'} = '故障';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'No ServiceID is given!'} = '没有指定ServiceID ！';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = '数据库中找不到ServiceID %s！';
    $Self->{Translation}->{'Current Incident State'} = '当前故障状态';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = '故障状态';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = '正常';
    $Self->{Translation}->{'Incident'} = '故障';
    $Self->{Translation}->{'End User Service'} = '最终用户服务';
    $Self->{Translation}->{'Front End'} = '前端';
    $Self->{Translation}->{'Back End'} = '后端';
    $Self->{Translation}->{'IT Management'} = 'IT管理';
    $Self->{Translation}->{'Reporting'} = '报告';
    $Self->{Translation}->{'IT Operational'} = 'IT运营';
    $Self->{Translation}->{'Demonstration'} = '演示';
    $Self->{Translation}->{'Project'} = '项目';
    $Self->{Translation}->{'Underpinning Contract'} = '支持合同';
    $Self->{Translation}->{'Other'} = '其它';
    $Self->{Translation}->{'Availability'} = '可用性';
    $Self->{Translation}->{'Response Time'} = '响应时间';
    $Self->{Translation}->{'Recovery Time'} = '恢复时间';
    $Self->{Translation}->{'Resolution Rate'} = '解决率';
    $Self->{Translation}->{'Transactions'} = '交易';
    $Self->{Translation}->{'Errors'} = '错误';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = '替代';
    $Self->{Translation}->{'Both'} = '兼具';
    $Self->{Translation}->{'Connected to'} = '连接到';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        '定义链接对象小部件(LinkObject::ViewMode = \"complex\")设置按钮中的操作。请注意，这些操作必须已经在以下JS和CSS文件中注册：Core.AllocationList.css、Core.UI.AllocationList.js、 Core.UI.Table.Sort.js、Core.Agent.TableFilters.js和Core.Agent.LinkObject.js。';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '定义链接的服务小部件(LinkObject::ViewMode = "complex")要显示的列。注意：只有服务属性才能作为默认列，可用的设置值为：0 = 禁用，1 = 可用， 2 = 默认启用。';
    $Self->{Translation}->{'Depends on'} = '依赖';
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        '为系统管理区中的 AdminITSMCIPAllocate 配置注册前端模块。';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        '为服务人员界面中的 AgentITSMSLA 对象注册前端模块。';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        '为服务人员界面中的 AgentITSMSLAPrint 对象注册前端模块。';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        '为服务人员界面中的 AgentITSMSLAZoom 对象注册前端模块。';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        '为服务人员界面中的 AgentITSMService 对象注册前端模块。';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        '为服务人员界面中的 AgentITSMServicePrint 对象注册前端模块。';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        '为服务人员界面中的 AgentITSMServiceZoom 对象注册前端模块。';
    $Self->{Translation}->{'ITSM SLA Overview.'} = 'ITSM SLA概览';
    $Self->{Translation}->{'ITSM Service Overview.'} = 'ITSM服务概览';
    $Self->{Translation}->{'Incident State Type'} = '故障状态类型';
    $Self->{Translation}->{'Includes'} = '包括';
    $Self->{Translation}->{'Manage priority matrix.'} = '管理优先级矩阵。';
    $Self->{Translation}->{'Manage the criticality - impact - priority matrix.'} = '管理 紧急度-影响-优先级 矩阵';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'SLA菜单中显示“后退”菜单项的模块。';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = '服务菜单中显示“后退”菜单项的模块。';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = '服务菜单中显示“链接”菜单项的模块。';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'SLA菜单中显示“打印”菜单项的模块。';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = '服务菜单中显示“打印”菜单项的模块。';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = '选项视图中用于表示故障状态的参数。';
    $Self->{Translation}->{'Part of'} = '属于';
    $Self->{Translation}->{'Relevant to'} = '关联';
    $Self->{Translation}->{'Required for'} = '被...需要';
    $Self->{Translation}->{'SLA Overview'} = 'SLA概览';
    $Self->{Translation}->{'SLA Print.'} = 'SLA打印。';
    $Self->{Translation}->{'SLA Zoom.'} = 'SLA详情。';
    $Self->{Translation}->{'Service Overview'} = '服务概览';
    $Self->{Translation}->{'Service Print.'} = '服务打印。';
    $Self->{Translation}->{'Service Zoom.'} = '服务详情。';
    $Self->{Translation}->{'Service-Area'} = '服务区';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        '设置链接的类型和方向以便计算故障状态。键是链接类型的名称（在LinkObject::Type中定义），值是IncidentLinkType（故障链接类型）的方向以计算故障状态。示例：如果IncidentLinkType（故障链接类型）设为“DependsOn（依赖）”，方向是Source（源），只有“依赖”链接（而不是链接类型为“被...需要”的链接）才用来计算故障状态。可以根据需要添加更多的链接类型和方向，如方向为“目标”的“Includes（包含）”链接。所有在系统配置选项的LinkObject::Type中定义的链接类型都可以使用，方向只可以是“Source（源）”、“Target（目标）”或“Both（源和目标都是）”。重要：在更改了系统配置选项后，你需要运行脚本bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate，才能按新的设置重新计算故障状态。';
    $Self->{Translation}->{'Source'} = '源';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        '这个设置定义了一个“ITSMChange（变更）”对象能够以链接类型“普通”链接到工单。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        '这个设置定义了一个ITSMConfigItem（配置项）对象能够以链接类型“普通”链接到FAQ知识库。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '这个设置定义了一个ITSMConfigItem（配置项）对象能够以链接类型“父子”链接到FAQ知识库。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        '这个设置定义了一个ITSMConfigItem（配置项）对象能够以链接类型“关联”链接到FAQ知识库。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        '这个设置定义了一个ITSMConfigItem（配置项）对象能够以链接类型“备选”链接到FAQ知识库。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        '这个设置定义了一个ITSMConfigItem（配置项）对象能够以链接类型“依赖”链接到“服务”。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        '这个设置定义了一个ITSMConfigItem（配置项）对象能够以链接类型“关联”链接到“服务”。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        '这个设置定义了一个ITSMConfigItem（配置项）对象能够以链接类型“备选”链接到“服务”。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        '这个设置定义了一个ITSMConfigItem（配置项）对象能够以链接类型“依赖”链接到“服务”。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        '这个设置定义了一个ITSMConfigItem（配置项）对象能够以链接类型“关联”链接到工单。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        '这个设置定义了一个ITSMConfigItem（配置项）对象能够以链接类型“备选”链接到另一配置项。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        '这个设置定义了一个ITSMConfigItem（配置项）对象能够以链接类型“连接到”链接到另一配置项。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        '这个设置定义了一个ITSMConfigItem（配置项）对象能够以链接类型“依赖”链接到另一配置项。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        '这个设置定义了一个ITSMConfigItem（配置项）对象能够以链接类型“包含”链接到另一配置项。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        '这个设置定义了一个ITSMConfigItem（配置项）对象能够以链接类型“关联”链接到另一配置项。';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        '这个设置定义了一个ITSMWorkOrder（工作指令）对象能够以链接类型“依赖”链接到配置项。';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        '这个设置定义了一个ITSMWorkOrder（工作指令）对象能够以链接类型“普通”链接到配置项。';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        '这个设置定义了一个ITSMWorkOrder（工作指令）对象能够以链接类型“依赖”链接到“服务”。';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        '这个设置定义了一个ITSMWorkOrder（工作指令）对象能够以链接类型“普通”链接到“服务”。';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        '这个设置定义了一个ITSMWorkOrder（工作指令）对象能够以链接类型“普通”链接到工单。';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        '这个设置定义了一个“服务”对象能够以链接类型“普通”链接到FAQ知识库。';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '这个设置定义了一个“服务”对象能够以链接类型“父子”链接到FAQ知识库。';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        '这个设置定义了一个“服务”对象能够以链接类型“关联”链接到FAQ知识库。';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '这个设置定义了链接类型“替代”。如果源和目标名称相同，则产生的链接是无方向性的链接。如果源和目标的值不同，则产生的链接是方向性的链接。';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '这个设置定义了链接类型“连接到”。如果源和目标名称相同，则产生的链接是无方向性的链接。如果源和目标的值不同，则产生的链接是方向性的链接。';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '这个设置定义了链接类型“依赖”。如果源和目标名称相同，则产生的链接是无方向性的链接。如果源和目标的值不同，则产生的链接是方向性的链接。';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '这个设置定义了链接类型“包含”。如果源和目标名称相同，则产生的链接是无方向性的链接。如果源和目标的值不同，则产生的链接是方向性的链接。';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '这个设置定义了链接类型“关联”。如果源和目标名称相同，则产生的链接是无方向性的链接。如果源和目标的值不同，则产生的链接是方向性的链接。';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'ITSM模块中文本输入区域的宽度。';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
