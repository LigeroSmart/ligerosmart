# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::zh_CN_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        '请确认你真的希望删除这一天的工时管理记录？';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = '编辑时间记录';
    $Self->{Translation}->{'Go to settings'} = '进入设置';
    $Self->{Translation}->{'Date Navigation'} = '日期浏览';
    $Self->{Translation}->{'Days without entries'} = '没有记录的工日';
    $Self->{Translation}->{'Select all days'} = '选择所有工日。';
    $Self->{Translation}->{'Mass entry'} = '大量记录';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        '请为所选时间选择缺勤原因。';
    $Self->{Translation}->{'On vacation'} = '休假';
    $Self->{Translation}->{'On sick leave'} = '病假';
    $Self->{Translation}->{'On overtime leave'} = '加班调休';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = '标记"*"的字段为必填。';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = '你需要填写开始和结束时间或者时间段。';
    $Self->{Translation}->{'Project'} = '项目';
    $Self->{Translation}->{'Task'} = '任务';
    $Self->{Translation}->{'Remark'} = '备注';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = '请添加一个超过8个字符的备注！';
    $Self->{Translation}->{'Negative times are not allowed.'} = '时间不允许为负。';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        '不允许重复的工作时间。开始时间已匹配其他存在的时段。';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = '格式无效！请按HH:MM格式输入时间。';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '24:00只允许设置为结束时间。';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = '时间无效！一天只有24小时。';
    $Self->{Translation}->{'End time must be after start time.'} = '结束时间应大于开始时间。';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        '不允许重复的工作时间。结束时间已匹配其他存在的时段。';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = '无效的时段！一天只有24小时。';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = '有效时段时长应大于0。';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = '无效时段！时段时长不允许为负。';
    $Self->{Translation}->{'Add one row'} = '增加一行';
    $Self->{Translation}->{'You can only select one checkbox element!'} = '只能选择一个复选框元素。';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = '你确定你在病假期间仍在工作吗？';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = '你确定你在休假期间仍在工作吗？';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        '你确定你在加班调休期间仍在工作吗？';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = '你确定你工作超过16小时了吗？';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = '工时报告月度概览';
    $Self->{Translation}->{'Overtime (Hours)'} = '加班（小时）';
    $Self->{Translation}->{'Overtime (this month)'} = '加班（本月）';
    $Self->{Translation}->{'Overtime (total)'} = '加班（合计）';
    $Self->{Translation}->{'Remaining overtime leave'} = '剩余的加班调休';
    $Self->{Translation}->{'Vacation (Days)'} = '休假（天）';
    $Self->{Translation}->{'Vacation taken (this month)'} = '已休假（本月）';
    $Self->{Translation}->{'Vacation taken (total)'} = '已休假（合计）';
    $Self->{Translation}->{'Remaining vacation'} = '剩余的假期';
    $Self->{Translation}->{'Sick Leave (Days)'} = '病假（天）';
    $Self->{Translation}->{'Sick leave taken (this month)'} = '已休病假（本月）';
    $Self->{Translation}->{'Sick leave taken (total)'} = '已休病假（合计）';
    $Self->{Translation}->{'Previous month'} = '上一月';
    $Self->{Translation}->{'Next month'} = '下一月';
    $Self->{Translation}->{'Weekday'} = '工作日';
    $Self->{Translation}->{'Working Hours'} = '工作时间';
    $Self->{Translation}->{'Total worked hours'} = '工作时间合计';
    $Self->{Translation}->{'User\'s project overview'} = '用户的项目概览';
    $Self->{Translation}->{'Hours (monthly)'} = '小时（按月）';
    $Self->{Translation}->{'Hours (Lifetime)'} = '小时（自入职计算）';
    $Self->{Translation}->{'Grand total'} = '总计';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = '时间报告';
    $Self->{Translation}->{'Month Navigation'} = '按月浏览';
    $Self->{Translation}->{'Go to date'} = '跳转到日期';
    $Self->{Translation}->{'User reports'} = '用户报告';
    $Self->{Translation}->{'Monthly total'} = '按月合计';
    $Self->{Translation}->{'Lifetime total'} = '自入职计算合计';
    $Self->{Translation}->{'Overtime leave'} = '加班调休';
    $Self->{Translation}->{'Vacation'} = '休假';
    $Self->{Translation}->{'Sick leave'} = '病假';
    $Self->{Translation}->{'Vacation remaining'} = '剩余假期';
    $Self->{Translation}->{'Project reports'} = '项目报告';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = '项目报告';
    $Self->{Translation}->{'Go to reporting overview'} = '进入报告概览';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        '当前仅显示项目中的激活用户。如要调整显示属性，请更新设置：';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        '当前显示所有的工时管理用户。如要调整显示属性，请更新设置：';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = '编辑工时管理项目设置';
    $Self->{Translation}->{'Add project'} = '新建项目';
    $Self->{Translation}->{'Go to settings overview'} = '进入设置概览';
    $Self->{Translation}->{'Add Project'} = '新建项目';
    $Self->{Translation}->{'Edit Project Settings'} = '编辑项目设置';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        '已存在同名的项目，请选择不同的名字。';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = '编辑工时管理设置';
    $Self->{Translation}->{'Add task'} = '添加任务';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = '按项目、任务或用户过滤';
    $Self->{Translation}->{'Time periods can not be deleted.'} = '无法删除工时周期。';
    $Self->{Translation}->{'Project List'} = '项目列表';
    $Self->{Translation}->{'Task List'} = '任务列表';
    $Self->{Translation}->{'Add Task'} = '添加任务';
    $Self->{Translation}->{'Edit Task Settings'} = '编辑任务设置';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        '已存在同名的任务，请选择不同的名字。';
    $Self->{Translation}->{'User List'} = '用户列表';
    $Self->{Translation}->{'User Settings'} = '用户设置';
    $Self->{Translation}->{'User is allowed to see overtimes'} = '允许用户看到加班时间';
    $Self->{Translation}->{'Show Overtime'} = '显示加班';
    $Self->{Translation}->{'User is allowed to create projects'} = '允许用户创建项目';
    $Self->{Translation}->{'Allow project creation'} = '允许创建项目';
    $Self->{Translation}->{'User is allowed to skip time accounting'} = '允许用户跳过工时管理';
    $Self->{Translation}->{'Allow time accounting skipping'} = '允许跳过工时管理';
    $Self->{Translation}->{'If this option is selected, time accounting is effectively optional for the user.'} =
        '如果选择此选项，则工时管理对用户来说实际上是可选的。';
    $Self->{Translation}->{'There will be no warnings about missing entries and no entry enforcement.'} =
        '没有关于缺少条目的警告，也没有进入强制执行的警告。';
    $Self->{Translation}->{'Time Spans'} = '时间跨度';
    $Self->{Translation}->{'Period Begin'} = '时段开始';
    $Self->{Translation}->{'Period End'} = '时段结束';
    $Self->{Translation}->{'Days of Vacation'} = '休假天数';
    $Self->{Translation}->{'Hours per Week'} = '每周小时数';
    $Self->{Translation}->{'Authorized Overtime'} = '批准的加班';
    $Self->{Translation}->{'Start Date'} = '开始日期';
    $Self->{Translation}->{'Please insert a valid date.'} = '请插入有效日期。';
    $Self->{Translation}->{'End Date'} = '结束日期';
    $Self->{Translation}->{'Period end must be after period begin.'} = '时段结束时间应大于时段开始时间。';
    $Self->{Translation}->{'Leave Days'} = '缺勤天数';
    $Self->{Translation}->{'Weekly Hours'} = '每周工作小时数';
    $Self->{Translation}->{'Overtime'} = '加班';
    $Self->{Translation}->{'No time periods found.'} = '没有找到时段。';
    $Self->{Translation}->{'Add time period'} = '增加时段';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = '查看工时记录';
    $Self->{Translation}->{'View of '} = '展示';
    $Self->{Translation}->{'Previous day'} = '前一天';
    $Self->{Translation}->{'Next day'} = '后一天';
    $Self->{Translation}->{'No data found for this day.'} = '没有找到这一天的数据。';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = '无法插入工作单位！';
    $Self->{Translation}->{'Last Projects'} = '最近的项目';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = '无法保存设置，因为一天只有24小时！';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = '无法删除工作单位！';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        '这个日期不受限制，但是你还没有插入这一天，所以你获得了一个（！）机会来插入';
    $Self->{Translation}->{'Incomplete Working Days'} = '不完整的工作日';
    $Self->{Translation}->{'Successful insert!'} = '插入成功！';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = '插入多个时间时出现错误！';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = '成功插入记录。';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = '输入时间无效！日期改为当前日期。';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        '没有配置时间段，或指定的日期不在定义的时间段内。';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        '请联系工时管理员更新您的时间段！';
    $Self->{Translation}->{'Last Selected Projects'} = '最后被选中的项目';
    $Self->{Translation}->{'All Projects'} = '所有项目';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = '项目报告：需要项目ID';
    $Self->{Translation}->{'Reporting Project'} = '项目报告';
    $Self->{Translation}->{'Reporting'} = '报告';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = '无法更新用户设置！';
    $Self->{Translation}->{'Project added!'} = '项目已添加！';
    $Self->{Translation}->{'Project updated!'} = '项目已更新！';
    $Self->{Translation}->{'Task added!'} = '任务已添加！';
    $Self->{Translation}->{'Task updated!'} = '任务已更新！';
    $Self->{Translation}->{'The UserID is not valid!'} = 'UserID无效！';
    $Self->{Translation}->{'Can\'t insert user data!'} = '无法插入用户数据！';
    $Self->{Translation}->{'Unable to add time period!'} = '无法添加时间段！';
    $Self->{Translation}->{'Setting'} = '设置';
    $Self->{Translation}->{'User updated!'} = '用户已更新！';
    $Self->{Translation}->{'User added!'} = '用户已添加！';
    $Self->{Translation}->{'Add a user to time accounting...'} = '添加一个用户到工时管理...';
    $Self->{Translation}->{'New User'} = '添加用户';
    $Self->{Translation}->{'Period Status'} = '时段状态';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = '视图：需要%s！';

    # Perl Module: Kernel/Output/HTML/Notification/TimeAccounting.pm
    $Self->{Translation}->{'Please insert your working hours!'} = '请插入工作时间';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = '不完整的工作日';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = '请至少选择一天！';
    $Self->{Translation}->{'Mass Entry'} = '大量记录';
    $Self->{Translation}->{'Please choose a reason for absence!'} = '请选择缺席原因！';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = '删除工时管理记录';
    $Self->{Translation}->{'Confirm insert'} = '确认插入';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        '服务人员界面通知模块，显示用户不完整的工作日数据。';
    $Self->{Translation}->{'Default name for new actions.'} = '新活动的默认名称。';
    $Self->{Translation}->{'Default name for new projects.'} = '新项目的默认名称。';
    $Self->{Translation}->{'Default setting for date end.'} = '结束日期的默认设置。';
    $Self->{Translation}->{'Default setting for date start.'} = '开始日期的默认设置。';
    $Self->{Translation}->{'Default setting for description.'} = '描述的默认设置。';
    $Self->{Translation}->{'Default setting for leave days.'} = '休假日的默认设置。';
    $Self->{Translation}->{'Default setting for overtime.'} = '加班的默认设置。';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = '周标准工作时间的默认设置。';
    $Self->{Translation}->{'Default status for new actions.'} = '新活动的默认状态。';
    $Self->{Translation}->{'Default status for new projects.'} = '新项目的默认状态。';
    $Self->{Translation}->{'Default status for new users.'} = '新用户的默认状态。';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        '指定备注必填的项目。如果RegExp匹配项目，你也需要添加备注。RegExp使用smx参数。';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        '确定统计模块是否要生成工时管理信息。';
    $Self->{Translation}->{'Edit time accounting settings.'} = '编辑工时管理设置。';
    $Self->{Translation}->{'Edit time record.'} = '编辑工时记录。';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = '你可以插入多久以前的工作数据。';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        '如果启用，则仅显示在选定项目中有工时数据的用户。';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        '如果启用，则编辑视图中的下拉列表元素将会修改为自动完成字段。';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        '如果启用，则可以使用之前项目的过滤器（用于替代最后和全部项目列表）。仅在TimeAccounting::EnableAutoCompletion启用时，可以启用该参数。';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        '如果启用，则如果存在之前的项目，则之前项目过滤器将被默认激活。仅在EnableAutoCompletion和TimeAccounting::UseFilter启用时，可以启用该参数。';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        '如果启用，则用户可以一次在多个日期中输入“休假”，“病假”，"加班调休"。';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        '工作数据添加后允许的最大工日。';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        '没有工作数据记录的工作日的最大数量（如果超过，则会显示警告）。';
    $Self->{Translation}->{'Overview.'} = '概览。';
    $Self->{Translation}->{'Project time reporting.'} = '项目工时报告。';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        '选定项目的限制活动清单使用的正则表达式。键包含了项目（Projects）的正则表达式，值包含了活动（Action）的正则表达式。';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        '用户组的限制项目清单使用的正则表达式。Key包含了项目（Projects）的正则表达式，Content包含了逗号分隔的组清单。';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        '指定在没有开始和结束时间的情况下是否可以插入工时数据。';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = '本模块功能插入到工时管理中。';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        '如有有太多不完整的工日，该通知模块会发出告警。';
    $Self->{Translation}->{'Time Accounting'} = '工时管理';
    $Self->{Translation}->{'Time accounting edit.'} = '工时管理编辑。';
    $Self->{Translation}->{'Time accounting overview.'} = '工时管理概览。';
    $Self->{Translation}->{'Time accounting reporting.'} = '工时管理报告。';
    $Self->{Translation}->{'Time accounting settings.'} = '工时管理设置。';
    $Self->{Translation}->{'Time accounting view.'} = '工时管理查看。';
    $Self->{Translation}->{'Time accounting.'} = '工时管理。';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        '在一些活动减少工作小时数的时候使用（如：只花费了一半的差旅时间，则Key=>差旅；Content=>50）。';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Confirm insert',
    'Delete Time Accounting Entry',
    'Mass Entry',
    'No',
    'Please choose a reason for absence!',
    'Please choose at least one day!',
    'Submit',
    'Yes',
    );

}

1;
