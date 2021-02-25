# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::zh_TW_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        '';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = '';
    $Self->{Translation}->{'Go to settings'} = '前往設定';
    $Self->{Translation}->{'Date Navigation'} = '';
    $Self->{Translation}->{'Days without entries'} = '';
    $Self->{Translation}->{'Select all days'} = '選取所有日子';
    $Self->{Translation}->{'Mass entry'} = '';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        '';
    $Self->{Translation}->{'On vacation'} = '休假';
    $Self->{Translation}->{'On sick leave'} = '病假';
    $Self->{Translation}->{'On overtime leave'} = '超時工作補假';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = '';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = '';
    $Self->{Translation}->{'Project'} = '項目';
    $Self->{Translation}->{'Task'} = '工作';
    $Self->{Translation}->{'Remark'} = '備註';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = '';
    $Self->{Translation}->{'Negative times are not allowed.'} = '';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        '';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = '';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '24:00 只容許於設定結束時間';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = '無效的時間! 一日只有24小時。';
    $Self->{Translation}->{'End time must be after start time.'} = '結束時間必須在開始時間之後';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        '';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = '';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = '';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = '';
    $Self->{Translation}->{'Add one row'} = '添加一行';
    $Self->{Translation}->{'You can only select one checkbox element!'} = '';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = '';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = '';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        '';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = '';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = '';
    $Self->{Translation}->{'Overtime (Hours)'} = '超時 (小時)';
    $Self->{Translation}->{'Overtime (this month)'} = '超時 (此月)';
    $Self->{Translation}->{'Overtime (total)'} = '超時 (總計)';
    $Self->{Translation}->{'Remaining overtime leave'} = '餘下的超時工作補假';
    $Self->{Translation}->{'Vacation (Days)'} = '休假 (日)';
    $Self->{Translation}->{'Vacation taken (this month)'} = '已提交的休假 (此月)';
    $Self->{Translation}->{'Vacation taken (total)'} = '已提交的休假 (總計)';
    $Self->{Translation}->{'Remaining vacation'} = '餘下的休假';
    $Self->{Translation}->{'Sick Leave (Days)'} = '病假 (日)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = '已放的病假 (此月)';
    $Self->{Translation}->{'Sick leave taken (total)'} = '已放的病假 (總計)';
    $Self->{Translation}->{'Previous month'} = '上月';
    $Self->{Translation}->{'Next month'} = '下月';
    $Self->{Translation}->{'Weekday'} = '平日';
    $Self->{Translation}->{'Working Hours'} = '工作時間';
    $Self->{Translation}->{'Total worked hours'} = '工作時間總計';
    $Self->{Translation}->{'User\'s project overview'} = '';
    $Self->{Translation}->{'Hours (monthly)'} = '小時 (每月)';
    $Self->{Translation}->{'Hours (Lifetime)'} = '';
    $Self->{Translation}->{'Grand total'} = '';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = '';
    $Self->{Translation}->{'Month Navigation'} = '';
    $Self->{Translation}->{'Go to date'} = '前往日期';
    $Self->{Translation}->{'User reports'} = '用戶報告';
    $Self->{Translation}->{'Monthly total'} = '每月總計';
    $Self->{Translation}->{'Lifetime total'} = '';
    $Self->{Translation}->{'Overtime leave'} = '超時工作補假';
    $Self->{Translation}->{'Vacation'} = '休假';
    $Self->{Translation}->{'Sick leave'} = '病假';
    $Self->{Translation}->{'Vacation remaining'} = '';
    $Self->{Translation}->{'Project reports'} = '';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = '';
    $Self->{Translation}->{'Go to reporting overview'} = '';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        '';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        '';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = '';
    $Self->{Translation}->{'Add project'} = '添加項目';
    $Self->{Translation}->{'Go to settings overview'} = '前往設定概況';
    $Self->{Translation}->{'Add Project'} = '添加項目';
    $Self->{Translation}->{'Edit Project Settings'} = '編輯項目設定';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        '';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = '';
    $Self->{Translation}->{'Add task'} = '添加工作';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = '';
    $Self->{Translation}->{'Time periods can not be deleted.'} = '';
    $Self->{Translation}->{'Project List'} = '項目列表';
    $Self->{Translation}->{'Task List'} = '工作列表';
    $Self->{Translation}->{'Add Task'} = '添加工作';
    $Self->{Translation}->{'Edit Task Settings'} = '編輯工作設定';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        '';
    $Self->{Translation}->{'User List'} = '用戶列表';
    $Self->{Translation}->{'User Settings'} = '';
    $Self->{Translation}->{'User is allowed to see overtimes'} = '';
    $Self->{Translation}->{'Show Overtime'} = '';
    $Self->{Translation}->{'User is allowed to create projects'} = '';
    $Self->{Translation}->{'Allow project creation'} = '';
    $Self->{Translation}->{'User is allowed to skip time accounting'} = '';
    $Self->{Translation}->{'Allow time accounting skipping'} = '';
    $Self->{Translation}->{'If this option is selected, time accounting is effectively optional for the user.'} =
        '';
    $Self->{Translation}->{'There will be no warnings about missing entries and no entry enforcement.'} =
        '';
    $Self->{Translation}->{'Time Spans'} = '';
    $Self->{Translation}->{'Period Begin'} = '';
    $Self->{Translation}->{'Period End'} = '';
    $Self->{Translation}->{'Days of Vacation'} = '休假日數';
    $Self->{Translation}->{'Hours per Week'} = '小時/每週';
    $Self->{Translation}->{'Authorized Overtime'} = '';
    $Self->{Translation}->{'Start Date'} = '開始時間';
    $Self->{Translation}->{'Please insert a valid date.'} = '';
    $Self->{Translation}->{'End Date'} = '結束時間';
    $Self->{Translation}->{'Period end must be after period begin.'} = '';
    $Self->{Translation}->{'Leave Days'} = '';
    $Self->{Translation}->{'Weekly Hours'} = '';
    $Self->{Translation}->{'Overtime'} = '超時工作';
    $Self->{Translation}->{'No time periods found.'} = '';
    $Self->{Translation}->{'Add time period'} = '';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = '';
    $Self->{Translation}->{'View of '} = '';
    $Self->{Translation}->{'Previous day'} = '前一天';
    $Self->{Translation}->{'Next day'} = '下一天';
    $Self->{Translation}->{'No data found for this day.'} = '';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = '';
    $Self->{Translation}->{'Last Projects'} = '最後的項目';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = '';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = '';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        '';
    $Self->{Translation}->{'Incomplete Working Days'} = '';
    $Self->{Translation}->{'Successful insert!'} = '';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = '';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = '';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = '';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        '';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        '';
    $Self->{Translation}->{'Last Selected Projects'} = '';
    $Self->{Translation}->{'All Projects'} = '所有項目';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = '';
    $Self->{Translation}->{'Reporting Project'} = '';
    $Self->{Translation}->{'Reporting'} = '報告';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = '';
    $Self->{Translation}->{'Project added!'} = '';
    $Self->{Translation}->{'Project updated!'} = '';
    $Self->{Translation}->{'Task added!'} = '';
    $Self->{Translation}->{'Task updated!'} = '';
    $Self->{Translation}->{'The UserID is not valid!'} = '';
    $Self->{Translation}->{'Can\'t insert user data!'} = '';
    $Self->{Translation}->{'Unable to add time period!'} = '';
    $Self->{Translation}->{'Setting'} = '設置';
    $Self->{Translation}->{'User updated!'} = '';
    $Self->{Translation}->{'User added!'} = '';
    $Self->{Translation}->{'Add a user to time accounting...'} = '';
    $Self->{Translation}->{'New User'} = '新用戶';
    $Self->{Translation}->{'Period Status'} = '';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = '';

    # Perl Module: Kernel/Output/HTML/Notification/TimeAccounting.pm
    $Self->{Translation}->{'Please insert your working hours!'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = '';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = '請選取至少一天!';
    $Self->{Translation}->{'Mass Entry'} = '';
    $Self->{Translation}->{'Please choose a reason for absence!'} = '請選擇缺席原因!';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = '';
    $Self->{Translation}->{'Confirm insert'} = '確認插入';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        '';
    $Self->{Translation}->{'Default name for new actions.'} = '';
    $Self->{Translation}->{'Default name for new projects.'} = '';
    $Self->{Translation}->{'Default setting for date end.'} = '';
    $Self->{Translation}->{'Default setting for date start.'} = '';
    $Self->{Translation}->{'Default setting for description.'} = '';
    $Self->{Translation}->{'Default setting for leave days.'} = '';
    $Self->{Translation}->{'Default setting for overtime.'} = '';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = '';
    $Self->{Translation}->{'Default status for new actions.'} = '';
    $Self->{Translation}->{'Default status for new projects.'} = '';
    $Self->{Translation}->{'Default status for new users.'} = '';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        '';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        '';
    $Self->{Translation}->{'Edit time accounting settings.'} = '';
    $Self->{Translation}->{'Edit time record.'} = '';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = '';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        '';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        '';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        '';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        '';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        '';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        '';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        '';
    $Self->{Translation}->{'Overview.'} = '概況';
    $Self->{Translation}->{'Project time reporting.'} = '';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        '';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        '';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        '';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = '';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        '';
    $Self->{Translation}->{'Time Accounting'} = '';
    $Self->{Translation}->{'Time accounting edit.'} = '';
    $Self->{Translation}->{'Time accounting overview.'} = '';
    $Self->{Translation}->{'Time accounting reporting.'} = '';
    $Self->{Translation}->{'Time accounting settings.'} = '';
    $Self->{Translation}->{'Time accounting view.'} = '';
    $Self->{Translation}->{'Time accounting.'} = '';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        '';


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
