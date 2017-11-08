# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::bg_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Наистина ли искате да изтриете счетоводството за време в този ден?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Редактиране на времевия запис';
    $Self->{Translation}->{'Go to settings'} = 'Отидете в настройките';
    $Self->{Translation}->{'Date Navigation'} = 'Дата за навигация';
    $Self->{Translation}->{'Days without entries'} = 'Дни без записи';
    $Self->{Translation}->{'Select all days'} = 'Избор на всички дни';
    $Self->{Translation}->{'Mass entry'} = 'Масово въвеждане';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Моля, изберете причината за Вашето отсъствие за избраните дни';
    $Self->{Translation}->{'On vacation'} = 'Ваканция';
    $Self->{Translation}->{'On sick leave'} = 'В отпуск по болест';
    $Self->{Translation}->{'On overtime leave'} = 'При извънреден отпуск';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'Задължителните полета са маркирани с "*".';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Трябва да въведете начално и крайно време или период от време.';
    $Self->{Translation}->{'Project'} = 'Проект';
    $Self->{Translation}->{'Task'} = 'Задача';
    $Self->{Translation}->{'Remark'} = 'Забележка';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = 'Моля, добавете забележка с повече от 8 знака!';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Отрицателните времена не се допускат.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Не се допускат повторни часове. Началното време съвпада с друг интервал.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'Невалиден формат! Моля, въведете час с формат ЧЧ: ММ.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '24:00 е разрешено само като крайно време.';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'Невалидно време! Един ден има 24 часа.';
    $Self->{Translation}->{'End time must be after start time.'} = 'Крайното време трябва да е след началното време.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Не се допускат повторни часове. Крайното време съвпада с друг интервал.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Невалиден период! Един ден има 24 часа.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Валидният период трябва да е по-голям от нула.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Невалиден период! Отрицателните периоди не са разрешени.';
    $Self->{Translation}->{'Add one row'} = 'Добави един ред';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Можете да изберете само един елемент от квадратчето за отметка!';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Сигурни ли сте, че работите, докато сте в отпуск по болест?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Сигурни ли сте, че работите, докато бяхте на почивка?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Сигурни ли сте, че сте работили, докато бяхте на извънреден труд?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Сигурни ли сте, че сте работили повече от 16 часа?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Месечен преглед на времето за отчитане';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Извънреден труд (часове)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Извънрежим (този месец)';
    $Self->{Translation}->{'Overtime (total)'} = 'Извънреден труд (общо)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Оставащ отпуск';
    $Self->{Translation}->{'Vacation (Days)'} = 'Отпуска (дни)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Взета отпуска (този месец)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Взета отпуска (общо)';
    $Self->{Translation}->{'Remaining vacation'} = 'Оставаща отпука';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Отпуск по болест (дни)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Отпуснат е болничен (този месец)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Отпуснат боленичен (общо)';
    $Self->{Translation}->{'Previous month'} = 'Предния месец';
    $Self->{Translation}->{'Next month'} = 'Следващия месец';
    $Self->{Translation}->{'Weekday'} = 'Делничен';
    $Self->{Translation}->{'Working Hours'} = 'Работни часове';
    $Self->{Translation}->{'Total worked hours'} = 'Общо работно време';
    $Self->{Translation}->{'User\'s project overview'} = 'Преглед на проекта на потребителя';
    $Self->{Translation}->{'Hours (monthly)'} = 'Часове (месечно)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Часове (цял живот)';
    $Self->{Translation}->{'Grand total'} = 'Общо';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Отчитане на времето';
    $Self->{Translation}->{'Month Navigation'} = 'Месечна навигация';
    $Self->{Translation}->{'Go to date'} = 'Отидете на датата';
    $Self->{Translation}->{'User reports'} = 'Потребителски отчети';
    $Self->{Translation}->{'Monthly total'} = 'Общо за месеца';
    $Self->{Translation}->{'Lifetime total'} = 'Общо за целия период';
    $Self->{Translation}->{'Overtime leave'} = 'Отпуск за извънреден труд';
    $Self->{Translation}->{'Vacation'} = 'Отпуска';
    $Self->{Translation}->{'Sick leave'} = 'Отпуск по болест';
    $Self->{Translation}->{'Vacation remaining'} = 'Оставаща отпуска';
    $Self->{Translation}->{'Project reports'} = 'Доклади за проекта';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Доклад за проекта';
    $Self->{Translation}->{'Go to reporting overview'} = 'Отворете отчетния преглед';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        'В момента се показват само активни потребители в този проект. За да промените това поведение, моля, актуализирайте настройката:';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'Понастоящем се показват всички потребители, отчитащи времето. За да промените това поведение, моля, актуализирайте настройката:';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Редактиране на настройките на проект за счетоводно време';
    $Self->{Translation}->{'Add project'} = 'Добавяне на проект';
    $Self->{Translation}->{'Go to settings overview'} = 'Отидете в общ преглед на настройките';
    $Self->{Translation}->{'Add Project'} = 'Добавяне на проект';
    $Self->{Translation}->{'Edit Project Settings'} = 'Редактиране на настройките на проекта';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Вече има проект с това име. Моля, изберете друг.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Редактиране на настройките за счетоводно време';
    $Self->{Translation}->{'Add task'} = 'Добавяне на задача';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = '';
    $Self->{Translation}->{'Time periods can not be deleted.'} = 'Периодите не могат да бъдат изтрити.';
    $Self->{Translation}->{'Project List'} = 'Списък на проектите';
    $Self->{Translation}->{'Task List'} = 'Списък на задачите';
    $Self->{Translation}->{'Add Task'} = 'Добавяне на задача';
    $Self->{Translation}->{'Edit Task Settings'} = 'Редактиране на настройките на задачите';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Вече има задача с това име. Моля, изберете друго.';
    $Self->{Translation}->{'User List'} = 'Списък с потребители';
    $Self->{Translation}->{'User Settings'} = '';
    $Self->{Translation}->{'User is allowed to see overtimes'} = '';
    $Self->{Translation}->{'Show Overtime'} = 'Показване на извънреден труд';
    $Self->{Translation}->{'User is allowed to create projects'} = '';
    $Self->{Translation}->{'Allow project creation'} = 'Разрешаване за създаването на проект';
    $Self->{Translation}->{'Time Spans'} = '';
    $Self->{Translation}->{'Period Begin'} = 'Начало';
    $Self->{Translation}->{'Period End'} = 'Край';
    $Self->{Translation}->{'Days of Vacation'} = 'Дни от отпуска';
    $Self->{Translation}->{'Hours per Week'} = 'Часове през седмицата';
    $Self->{Translation}->{'Authorized Overtime'} = 'Оторизиран извънреден труд';
    $Self->{Translation}->{'Start Date'} = 'Дата за начало';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Моля въведете валидна дата';
    $Self->{Translation}->{'End Date'} = 'Дата за край';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Крайният период трябва да бъде след началото на периода.';
    $Self->{Translation}->{'Leave Days'} = 'Оставащи дни';
    $Self->{Translation}->{'Weekly Hours'} = 'Седмични часове';
    $Self->{Translation}->{'Overtime'} = 'Извънредно';
    $Self->{Translation}->{'No time periods found.'} = 'Няма намерени времеви периоди.';
    $Self->{Translation}->{'Add time period'} = 'Добавете период от време';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Преглед на времевия запис';
    $Self->{Translation}->{'View of '} = 'Преглед на';
    $Self->{Translation}->{'Previous day'} = 'Вчера';
    $Self->{Translation}->{'Next day'} = 'Утре';
    $Self->{Translation}->{'No data found for this day.'} = 'Няма данни за този ден.';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = '';
    $Self->{Translation}->{'Last Projects'} = '';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = '';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = '';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        '';
    $Self->{Translation}->{'Incomplete Working Days'} = '';
    $Self->{Translation}->{'Please insert your working hours!'} = '';
    $Self->{Translation}->{'Successful insert!'} = '';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = '';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = '';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = '';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        '';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        '';
    $Self->{Translation}->{'Last Selected Projects'} = '';
    $Self->{Translation}->{'All Projects'} = '';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = '';
    $Self->{Translation}->{'Reporting Project'} = '';
    $Self->{Translation}->{'Reporting'} = 'Отчетност';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = '';
    $Self->{Translation}->{'Project added!'} = '';
    $Self->{Translation}->{'Project updated!'} = '';
    $Self->{Translation}->{'Task added!'} = '';
    $Self->{Translation}->{'Task updated!'} = '';
    $Self->{Translation}->{'The UserID is not valid!'} = '';
    $Self->{Translation}->{'Can\'t insert user data!'} = '';
    $Self->{Translation}->{'Unable to add time period!'} = '';
    $Self->{Translation}->{'Setting'} = 'Настройка';
    $Self->{Translation}->{'User updated!'} = '';
    $Self->{Translation}->{'User added!'} = '';
    $Self->{Translation}->{'Add a user to time accounting...'} = '';
    $Self->{Translation}->{'New User'} = '';
    $Self->{Translation}->{'Period Status'} = '';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = '';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = 'Моля, изберете поне един ден!';
    $Self->{Translation}->{'Mass Entry'} = 'Масово вписване';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Моля, изберете причина за отсъствие!';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Изтриване на времето за вписване в счетоводството';
    $Self->{Translation}->{'Confirm insert'} = 'Потвърдете';

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
    $Self->{Translation}->{'Overview.'} = '';
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
