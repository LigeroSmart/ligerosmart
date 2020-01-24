# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::mk_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Дали сте сигурни дека сакате да ги избришете времињата за овој ден?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Измени Записи за Време';
    $Self->{Translation}->{'Go to settings'} = 'Оди во подесувања';
    $Self->{Translation}->{'Date Navigation'} = 'Навигација според Датум ';
    $Self->{Translation}->{'Days without entries'} = 'Денови без записи';
    $Self->{Translation}->{'Select all days'} = 'Означи ги сите денови';
    $Self->{Translation}->{'Mass entry'} = 'Масовен внес';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Ве молиме изберете причина за вашето отсуство во означените денови';
    $Self->{Translation}->{'On vacation'} = 'На одмор';
    $Self->{Translation}->{'On sick leave'} = 'Отсутен поради болест';
    $Self->{Translation}->{'On overtime leave'} = 'Прекувремено отсуство';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'Задолжителните полиња се означени со "*".';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Треба да се внесе почетно и крајно време или временски период.';
    $Self->{Translation}->{'Project'} = 'Проект';
    $Self->{Translation}->{'Task'} = 'Задача';
    $Self->{Translation}->{'Remark'} = 'Напомена';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = '';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Негативно време не е дозволено.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Дуплирање на часови не е дозволено. Време на почнување се совпаѓа со друг интервал.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'Невалиден формат! Внесете време со формат ЧЧ:ММ.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '24:00 е дозволено само како крај на времето.';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'Невалиден час! Денот има само 24 часа.';
    $Self->{Translation}->{'End time must be after start time.'} = 'Време на завршување треба да биде по почетното време.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Дуплирање на часови не е дозволено. Време на завршување се совпаѓа со друг интервал.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Невалиден период! Денот има само 24 часа.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Валидниот рок мора да е поголем од нула.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Невалиден период! Негативни периоди не се дозволени.';
    $Self->{Translation}->{'Add one row'} = 'Додади еден ред';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Можете да изберете само еден поле од елемент!';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Дали сте сигурни дека сте работеле додека сте биле на боледување?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Дали сте сигурни дека сте работеле додека сте биле на одмор?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Дали сте сигурни дека сте работеле додека сте биле на прекувремено отсуство ?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Дали сте сигурни дека сте работеле повеќе од 16 часа?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Временско известување за месечен преглед';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Прекувремена работа (Часови)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Прекувремена работа (овој месец)';
    $Self->{Translation}->{'Overtime (total)'} = 'Прекувремена работа (вкупно)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Преостанато прекувремено отсуство ';
    $Self->{Translation}->{'Vacation (Days)'} = 'Одмор (во денови)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Искористен одмор (овој месец)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Искористен одмор (вкупно)';
    $Self->{Translation}->{'Remaining vacation'} = 'Преостанат одмор';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Боледувања (во денови)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Боледување (овој месец)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Боледувања (вкупно)';
    $Self->{Translation}->{'Previous month'} = 'Претходен месец';
    $Self->{Translation}->{'Next month'} = 'Следен месец';
    $Self->{Translation}->{'Weekday'} = 'Ден во седмицата';
    $Self->{Translation}->{'Working Hours'} = 'Работни Часови';
    $Self->{Translation}->{'Total worked hours'} = 'Вкупно одработени часови';
    $Self->{Translation}->{'User\'s project overview'} = 'Преглед на Кориснички Проект';
    $Self->{Translation}->{'Hours (monthly)'} = 'Часови (месечно)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Часови (вкупно)';
    $Self->{Translation}->{'Grand total'} = 'Севкупно';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Известување за Време';
    $Self->{Translation}->{'Month Navigation'} = 'Навигација според Месец';
    $Self->{Translation}->{'Go to date'} = 'Оди до датум';
    $Self->{Translation}->{'User reports'} = 'Кориснички извештаји';
    $Self->{Translation}->{'Monthly total'} = 'Вкупно за Месец';
    $Self->{Translation}->{'Lifetime total'} = 'Севкупно ';
    $Self->{Translation}->{'Overtime leave'} = 'Прекувремено отсуство';
    $Self->{Translation}->{'Vacation'} = 'Oдмор';
    $Self->{Translation}->{'Sick leave'} = 'Боледување';
    $Self->{Translation}->{'Vacation remaining'} = 'преостанат Одмор';
    $Self->{Translation}->{'Project reports'} = 'Извештаји за Проекти';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'извештај за Проектот';
    $Self->{Translation}->{'Go to reporting overview'} = 'Оди во преглед на извештаји';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        'Моментално се прикажани само активните корисници на овој проект. За да го смените ова, ве молиме направете измена во подесувањата:';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'Моментално се прикажани само корисници кои пресметуваат време. За да го смените ова, ве молиме направете измена во подесувањата:';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Измени Подесувања за Пресметување на Време на Проект';
    $Self->{Translation}->{'Add project'} = 'Додади проект';
    $Self->{Translation}->{'Go to settings overview'} = 'Оди во преглед на подесувања';
    $Self->{Translation}->{'Add Project'} = 'Додади Проект';
    $Self->{Translation}->{'Edit Project Settings'} = 'Уреди го Подесувањато на Проектот';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Веќе постои проект со вакво име, ве молиме, изберете друго.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Измени Подесувања за Пресметување на Време';
    $Self->{Translation}->{'Add task'} = 'Додади задача';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = '';
    $Self->{Translation}->{'Time periods can not be deleted.'} = '';
    $Self->{Translation}->{'Project List'} = 'Листа на проекти';
    $Self->{Translation}->{'Task List'} = 'Листа на Задачи';
    $Self->{Translation}->{'Add Task'} = 'Додади Задача';
    $Self->{Translation}->{'Edit Task Settings'} = 'Измени Подесувања за Задачи';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Веќе постои задача со вакво име. Ве молиме изберете друго.';
    $Self->{Translation}->{'User List'} = 'Листа на Корисници';
    $Self->{Translation}->{'User Settings'} = '';
    $Self->{Translation}->{'User is allowed to see overtimes'} = '';
    $Self->{Translation}->{'Show Overtime'} = 'Прикажи Прекувремено';
    $Self->{Translation}->{'User is allowed to create projects'} = '';
    $Self->{Translation}->{'Allow project creation'} = 'Дозволи креирање на проекти';
    $Self->{Translation}->{'User is allowed to skip time accounting'} = '';
    $Self->{Translation}->{'Allow time accounting skipping'} = '';
    $Self->{Translation}->{'If this option is selected, time accounting is effectively optional for the user.'} =
        '';
    $Self->{Translation}->{'There will be no warnings about missing entries and no entry enforcement.'} =
        '';
    $Self->{Translation}->{'Time Spans'} = '';
    $Self->{Translation}->{'Period Begin'} = 'Почеток на Период';
    $Self->{Translation}->{'Period End'} = 'Крај на Период';
    $Self->{Translation}->{'Days of Vacation'} = 'Денови на Одмор';
    $Self->{Translation}->{'Hours per Week'} = 'Часови во Недела';
    $Self->{Translation}->{'Authorized Overtime'} = 'Авторизирано Прекувремено';
    $Self->{Translation}->{'Start Date'} = 'Почеток';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Ве молиме внесете валиден датум.';
    $Self->{Translation}->{'End Date'} = 'Крај';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Крајот мора да биде пред почетокот.';
    $Self->{Translation}->{'Leave Days'} = 'Денови во Отсуство';
    $Self->{Translation}->{'Weekly Hours'} = 'Часови Неделно';
    $Self->{Translation}->{'Overtime'} = 'Прекувремено';
    $Self->{Translation}->{'No time periods found.'} = 'Не се пронајдени записи.';
    $Self->{Translation}->{'Add time period'} = 'Внеси временски период';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Прегледај Временски Записи';
    $Self->{Translation}->{'View of '} = 'Преглед на';
    $Self->{Translation}->{'Previous day'} = 'Претходен ден';
    $Self->{Translation}->{'Next day'} = 'Следен ден';
    $Self->{Translation}->{'No data found for this day.'} = 'Не се пронајдени записи за овој ден.';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = '';
    $Self->{Translation}->{'Last Projects'} = '';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = '';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = '';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        '';
    $Self->{Translation}->{'Incomplete Working Days'} = '';
    $Self->{Translation}->{'Successful insert!'} = 'Успешен внес!';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = 'Грешка при вметнување на повеќе датуми!';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = 'Успешно се внесени податоците за датумите!';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = 'Внесениот датум беше валиден! Датум беше променето до денес.';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        '';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        '';
    $Self->{Translation}->{'Last Selected Projects'} = '';
    $Self->{Translation}->{'All Projects'} = '';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = '';
    $Self->{Translation}->{'Reporting Project'} = '';
    $Self->{Translation}->{'Reporting'} = 'Известувања';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = '';
    $Self->{Translation}->{'Project added!'} = '';
    $Self->{Translation}->{'Project updated!'} = '';
    $Self->{Translation}->{'Task added!'} = '';
    $Self->{Translation}->{'Task updated!'} = '';
    $Self->{Translation}->{'The UserID is not valid!'} = '';
    $Self->{Translation}->{'Can\'t insert user data!'} = '';
    $Self->{Translation}->{'Unable to add time period!'} = '';
    $Self->{Translation}->{'Setting'} = 'Подесување';
    $Self->{Translation}->{'User updated!'} = '';
    $Self->{Translation}->{'User added!'} = '';
    $Self->{Translation}->{'Add a user to time accounting...'} = '';
    $Self->{Translation}->{'New User'} = '';
    $Self->{Translation}->{'Period Status'} = '';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = '';

    # Perl Module: Kernel/Output/HTML/Notification/TimeAccounting.pm
    $Self->{Translation}->{'Please insert your working hours!'} = 'Ве молиме внесете го вашето работното време!';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = '';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = 'Ве молиме изберете барем еден ден!';
    $Self->{Translation}->{'Mass Entry'} = 'Масовен Внес';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Ве молиме изберете ја причина за отсуство!';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Избриши го Внесот со Пресметано Време';
    $Self->{Translation}->{'Confirm insert'} = 'Прифати додавање';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'Модула за интерфејс на Агент за да го гледа бројот на незавршени работни денови за корисник.';
    $Self->{Translation}->{'Default name for new actions.'} = 'Вообичаено име за нови акции.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Вообичаено име за нови проекти.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Вообичаено подесување за краен датум.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Вообичаено подесување за почетен датум.';
    $Self->{Translation}->{'Default setting for description.'} = 'Вообичаено подесување за опис.';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Вообичаено подасување за отсуство.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Вообичаено подасување за прекувремено.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Вообичаено подасување за стандарден број на работни часови во недела.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Вообичаен статус за нови акции.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Вообичаен статус за нови проекти.';
    $Self->{Translation}->{'Default status for new users.'} = 'Вообичаен статус за нови корисници.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        'Дефинира проект за кој е потребно забелешка. Доколку RegExp се софпаѓа со овој проект, тогаш е потребно да внесете забечешка. RegExp користи smx параметар.';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        'Одредува дали модулот за статистика може да генерира информации за пресметка на време.';
    $Self->{Translation}->{'Edit time accounting settings.'} = '';
    $Self->{Translation}->{'Edit time record.'} = '';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'За колку многу денови пред можете да вметнете работни единици.';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        'Ако е овозможено, само корисниците кои ќе додадат работното време на избраните проекти  ќе бидат прикажани.';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        '';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        '';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        '';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        'Ако е овозможено, на корисникот ќе му биде дозволено да „Боледува“, да работи „Прекувремено“ и да зема „Одмор“ повеќе пати одеднаш.';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        'Максимален број на работни денови по што работните единици треба да се вметнат.';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        'Максимален број на работни денови без работни единици ќе влезат, а потоа предупредување ќе бидат прикажани.';
    $Self->{Translation}->{'Overview.'} = '';
    $Self->{Translation}->{'Project time reporting.'} = '';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'Стандардни изрази за ограничување на листа од акции во назначен проект. Клучот содржи стандардни изрази за проект(и), содржината содржи стандардни изрази за акција(и).';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'Стандарден израз за ограничување на листа во проект според корисничките групи. Клучот се содржи од стандардни изрази за проект(и), содржината содржи листа од групи одделени со запирка.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        'Специфицира дали работните часови можат да бидат додадени без време на почеток и крај.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Овој модул присилува внес во Пресметка на време.';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'Овој известувачки модул дава предупредување ако има премногу нецелосни работни дена.';
    $Self->{Translation}->{'Time Accounting'} = 'Менаџмент на Време';
    $Self->{Translation}->{'Time accounting edit.'} = 'Уредување на  менаџмент на Време';
    $Self->{Translation}->{'Time accounting overview.'} = 'Преглед на менаџмент на Време';
    $Self->{Translation}->{'Time accounting reporting.'} = 'Известување за менаџмент на Време';
    $Self->{Translation}->{'Time accounting settings.'} = 'Подесување на  менаџмент на Време';
    $Self->{Translation}->{'Time accounting view.'} = 'Поглед на  менаџмент на Време';
    $Self->{Translation}->{'Time accounting.'} = ' менаџмент на Време';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        'Се користи кога некои акции го смалуваат бројот на работни часови (на пример, доколку половина од времето на патување е платено Key => патување;  Content => 50).';


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
