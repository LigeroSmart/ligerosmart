# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ru_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Вы действительно желаете удалить учтенные затраты времени для этого дня?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Редактировать запись времени';
    $Self->{Translation}->{'Go to settings'} = 'Перейти к настройкам';
    $Self->{Translation}->{'Date Navigation'} = 'Навигация по времени';
    $Self->{Translation}->{'Days without entries'} = 'Дни без записей';
    $Self->{Translation}->{'Select all days'} = 'Выбрать все дни';
    $Self->{Translation}->{'Mass entry'} = 'Массовый ввод';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Выберите причину вашего отсутствия в выбранные дни';
    $Self->{Translation}->{'On vacation'} = 'В отпуске';
    $Self->{Translation}->{'On sick leave'} = 'По болезни';
    $Self->{Translation}->{'On overtime leave'} = 'В отгуле за переработку';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'Обязательные поля помечены "*".';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Необходимо заполнить время начала и окончания или период времени.';
    $Self->{Translation}->{'Project'} = 'Планирование';
    $Self->{Translation}->{'Task'} = 'Задача';
    $Self->{Translation}->{'Remark'} = 'Примечание';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = 'Примечание должно быть не менее 8 символов.';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Отрицательное значение недопустимо.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Не допускается повторение. Время начала соответствует другому интервалу.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'Неверный формат! Введите время в формате HH:MM.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = 'Только 24:00 разрешено в качестве времени окончания.';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'Неверное время! В сутках только 24 часа.';
    $Self->{Translation}->{'End time must be after start time.'} = 'Время окончания должно быть позже времени начала.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Не допускается повторение. Время окончания соответствует другому интервалу.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Неверный период! В сутках только 24 часа.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Правильный период должен быть больше нуля.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Неверный период! Отрицательное значение не допускается.';
    $Self->{Translation}->{'Add one row'} = 'Добавить одну строку';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'У вас есть возможность выбрать только один элемент!';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Вы действительно работали в период болезни?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Вы действительно работали в период отпуска?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Вы действительно работали в период отгулов?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Вы действительно работали более 16 часов?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Месячный отчет о затраченном времени';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Переработка (часы)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Переработка (этого месяца)';
    $Self->{Translation}->{'Overtime (total)'} = 'Переработка (всего)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Оставшееся время отгула';
    $Self->{Translation}->{'Vacation (Days)'} = 'Отпуск (дни)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Использованные дни отпуска (в этом месяце)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Использованные дни отпуска (всего)';
    $Self->{Translation}->{'Remaining vacation'} = 'Оставшиеся дни отпуска';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Болезнь (дни)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Отсутствовал по болезни (в этом месяце)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Отсутствовал по болезни (всего)';
    $Self->{Translation}->{'Previous month'} = 'Предыдущий месяц';
    $Self->{Translation}->{'Next month'} = 'Следующий месяц';
    $Self->{Translation}->{'Weekday'} = 'Неделя';
    $Self->{Translation}->{'Working Hours'} = 'Рабочие часы';
    $Self->{Translation}->{'Total worked hours'} = 'Всего отработанных часов';
    $Self->{Translation}->{'User\'s project overview'} = 'Обзор данных по планированию для пользователя';
    $Self->{Translation}->{'Hours (monthly)'} = 'Часы (ежемесячно)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Часы (за весь срок наблюдения)';
    $Self->{Translation}->{'Grand total'} = 'Всего';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Отчет о времени';
    $Self->{Translation}->{'Month Navigation'} = 'Навигация по месяцам';
    $Self->{Translation}->{'Go to date'} = 'Перейти к дате';
    $Self->{Translation}->{'User reports'} = 'Отчет о пользователе';
    $Self->{Translation}->{'Monthly total'} = 'Итого за месяц';
    $Self->{Translation}->{'Lifetime total'} = 'Итого за все время';
    $Self->{Translation}->{'Overtime leave'} = 'Отгулы за переработку';
    $Self->{Translation}->{'Vacation'} = 'Отпуск';
    $Self->{Translation}->{'Sick leave'} = 'Отсутствие по болезни';
    $Self->{Translation}->{'Vacation remaining'} = 'Осталось дней отпуска';
    $Self->{Translation}->{'Project reports'} = 'Отчеты по планированию';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Отчет по планированию';
    $Self->{Translation}->{'Go to reporting overview'} = 'Перейти к обзору отчетов';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        'В настоящее время показаны только активные пользователи в этом проекте. Чтобы изменить это, пожалуйста, обновите настройки:';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'В настоящее время показаны все пользователи в этом проекте. Чтобы изменить, пожалуйста, обновите настройки:';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Редактировать настройки учета затраченного времени по проекту';
    $Self->{Translation}->{'Add project'} = 'Добавить планирование';
    $Self->{Translation}->{'Go to settings overview'} = 'Перейти к обзору настроек';
    $Self->{Translation}->{'Add Project'} = 'Добавить планирование';
    $Self->{Translation}->{'Edit Project Settings'} = 'Редактировать настройки планирования';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Уже есть проект с таким наименованием. Выберите другое.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Редактировать настройки учета затраченного времени';
    $Self->{Translation}->{'Add task'} = 'Добавить задачу';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = 'Фильтр для проектов, задач или пользователей';
    $Self->{Translation}->{'Time periods can not be deleted.'} = 'Периоды времени не могут быть удалены.';
    $Self->{Translation}->{'Project List'} = 'Список проектов';
    $Self->{Translation}->{'Task List'} = 'Список задач';
    $Self->{Translation}->{'Add Task'} = 'Добавить задачу';
    $Self->{Translation}->{'Edit Task Settings'} = 'Редактировать настройки задачи';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Уже есть задача с таким именем, Выберите другое.';
    $Self->{Translation}->{'User List'} = 'Список пользователей';
    $Self->{Translation}->{'User Settings'} = 'Пользовательские настройки';
    $Self->{Translation}->{'User is allowed to see overtimes'} = 'Пользователю разрешено просматривать время';
    $Self->{Translation}->{'Show Overtime'} = 'Показать переработку';
    $Self->{Translation}->{'User is allowed to create projects'} = 'Пользователю разрешено создавать проекты';
    $Self->{Translation}->{'Allow project creation'} = 'Разрешить создание проектов';
    $Self->{Translation}->{'User is allowed to skip time accounting'} = '';
    $Self->{Translation}->{'Allow time accounting skipping'} = '';
    $Self->{Translation}->{'If this option is selected, time accounting is effectively optional for the user.'} =
        '';
    $Self->{Translation}->{'There will be no warnings about missing entries and no entry enforcement.'} =
        '';
    $Self->{Translation}->{'Time Spans'} = 'Промежутки времени';
    $Self->{Translation}->{'Period Begin'} = 'Начало периода';
    $Self->{Translation}->{'Period End'} = 'Конец периода';
    $Self->{Translation}->{'Days of Vacation'} = 'Дни отпуска';
    $Self->{Translation}->{'Hours per Week'} = 'Часов в неделе';
    $Self->{Translation}->{'Authorized Overtime'} = 'Разрешенная переработка';
    $Self->{Translation}->{'Start Date'} = 'Дата начала';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Введите правильную дату.';
    $Self->{Translation}->{'End Date'} = 'Дата окончания';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Время окончания периода должно быть позже времени его начала.';
    $Self->{Translation}->{'Leave Days'} = 'Осталось, дней';
    $Self->{Translation}->{'Weekly Hours'} = 'Часов в неделю';
    $Self->{Translation}->{'Overtime'} = 'Переработка/Сверхурочные';
    $Self->{Translation}->{'No time periods found.'} = 'Не заданы периоды времени.';
    $Self->{Translation}->{'Add time period'} = 'Добавить перид времени';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Посмотреть запись времени';
    $Self->{Translation}->{'View of '} = 'Просмотр';
    $Self->{Translation}->{'Previous day'} = 'Предыдущий день';
    $Self->{Translation}->{'Next day'} = 'Следующий день';
    $Self->{Translation}->{'No data found for this day.'} = 'Для этого дня данные не найдены.';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = 'Не удалось добавить рабочие единицы!';
    $Self->{Translation}->{'Last Projects'} = 'Последние проекты.';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = 'Не удалось сохранить настройки, так как в сутках 24 часа!';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = 'Не удалось удалить рабочие единицы!';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        'Эта дата вне диапазона, но вы еще не установили этот день, так что вам дается один(!) шанс для ее установки';
    $Self->{Translation}->{'Incomplete Working Days'} = 'Неполные рабочие дни';
    $Self->{Translation}->{'Successful insert!'} = 'Данные занесены успешно!';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = 'Ошибка при вводе нескольких дат!';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = 'Данные для разных дат введены успешно!';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = 'Введенная дата неверна! Заменена на текущую!';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        'Не настроен временной период, или указанная дата находится за пределами определенных временных периодов.';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        'Пожалуйста, свяжитесь с администратором временного учета, чтобы обновить ваши временные периоды!';
    $Self->{Translation}->{'Last Selected Projects'} = 'Последние выбранные проекты';
    $Self->{Translation}->{'All Projects'} = 'Все проекты';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = 'ReportingProject: Требуется ProjectID';
    $Self->{Translation}->{'Reporting Project'} = 'Проект составления отчетов';
    $Self->{Translation}->{'Reporting'} = 'Составление отчетов';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = 'Не удалось обновить настройки пользователя!';
    $Self->{Translation}->{'Project added!'} = 'Добавлено планирование!';
    $Self->{Translation}->{'Project updated!'} = 'Планирование обновлено!';
    $Self->{Translation}->{'Task added!'} = 'Задача добавлена!';
    $Self->{Translation}->{'Task updated!'} = 'Задача обновлена!';
    $Self->{Translation}->{'The UserID is not valid!'} = 'Неверный UserID!';
    $Self->{Translation}->{'Can\'t insert user data!'} = 'Не удалось вставить данные пользователя!';
    $Self->{Translation}->{'Unable to add time period!'} = 'Не удалось добавить перид времени!';
    $Self->{Translation}->{'Setting'} = 'Параметр';
    $Self->{Translation}->{'User updated!'} = 'Пользователь обновлен!';
    $Self->{Translation}->{'User added!'} = 'Пользователь добавлен!';
    $Self->{Translation}->{'Add a user to time accounting...'} = 'Добавить пользователя в учет времени ...';
    $Self->{Translation}->{'New User'} = 'Новый пользователь';
    $Self->{Translation}->{'Period Status'} = 'Статус периода';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = 'View: Требуется  %s!';

    # Perl Module: Kernel/Output/HTML/Notification/TimeAccounting.pm
    $Self->{Translation}->{'Please insert your working hours!'} = 'Введите Ваши рабочие часы!';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = 'Неполные рабочие дни';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = 'Выберите хотя бы один день!';
    $Self->{Translation}->{'Mass Entry'} = 'Массовый ввод';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Выберите причину отсутствия!';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Удалить запись затраченного времени';
    $Self->{Translation}->{'Confirm insert'} = 'Подтвердите вставку';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'Модуль уведомлений, для отображения количества незавершенных рабочих дней пользователя в интерфейсе агента';
    $Self->{Translation}->{'Default name for new actions.'} = 'Имена по умолчанию для новых действий.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Название нового проекта по-умолчанию.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Значение по умолчанию для даты окончания.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Значение по умолчанию для даты начала.';
    $Self->{Translation}->{'Default setting for description.'} = 'Значение по умолчанию для описания.';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Значение по умолчанию для оставшихся дней.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Значение по умолчанию для переработки.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Значение по умолчанию для стандартных рабочих часов.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Значение по умолчанию статуса новых действий.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Значение по умолчанию для статуса новых проектов.';
    $Self->{Translation}->{'Default status for new users.'} = 'Значение по умолчанию для статуса новых пользователей.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        'Задает проекты для которых требуется занесение замечаний. Если RegExp верно для проекта, вы должны добавить замечания тоже. Для RegExp используйте параметр smx.';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        'Задает, может ли модуль отчетов генерировать информацию по учету затраченного времени.';
    $Self->{Translation}->{'Edit time accounting settings.'} = 'Редактировать настройки учета затраченного времени.';
    $Self->{Translation}->{'Edit time record.'} = 'Редактировать запись времени.';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Для какого количества прошедших дней вы можете внести данные о времени.';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        'Если включено, отображаются только пользователи, которые заносили затраты времени в выбранный проект.';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        'Если включено, выпадающие поля списка на экране редактирования преобразуются в модернизированные поля автозавершения.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        'Если включено, то фильтр для предыдущих проектов может быть использован вместо двух списков (последних и всех проектов). Это доступно только если параметр TimeAccounting::EnableAutoCompletion активирован.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        'Если включено, то фильтр для предыдущих проектов включен по умолчанию при наличие предыдущих проектов. Это доступно только если параметры EnableAutoCompletion и TimeAccounting::UseFilter активированы.';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        'Если включено, пользователю разрешено вводить значения "Осталось в отпске", "Осталось дней по болезни" и "Осталось переработки" по несколько дат сразу.';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        'Макс. количество рабочих дней, после которых рабочие единицы должны быть занесены.';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        'Максимально количество рабочих дней, после которого выдается предупреждение о том, что данные не вводились.';
    $Self->{Translation}->{'Overview.'} = 'Обзор';
    $Self->{Translation}->{'Project time reporting.'} = 'Отчет о времени по проекту';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'Регулярные выражения для составления списка действий в соответствии с выбранным проектом. Ключ должен содержать регулярное выражение для проекта(ов), Содержание - регулярные выражения для действия(й).';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'Регулярные выражения для составления списка действий в зависимости от групп пользователей. Ключ должен содержать регулярное выражение для проекта(ов), Содержание - список групп, разделенных запятой.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        'Задает, можно ли заносить рабочие часы без указания времени начала и окончания.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Этот модуль ускоряет ввод данных в TimeAccounting.';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'Модуль уведомлений, для отображения количества незавершенных рабочих дней пользователя.';
    $Self->{Translation}->{'Time Accounting'} = 'Учет затраченного времени';
    $Self->{Translation}->{'Time accounting edit.'} = 'Редактирование затрат времени.';
    $Self->{Translation}->{'Time accounting overview.'} = 'Обзор затрат времени.';
    $Self->{Translation}->{'Time accounting reporting.'} = 'Отчеты о затртах времени.';
    $Self->{Translation}->{'Time accounting settings.'} = 'Настройки учета затраченного времени.';
    $Self->{Translation}->{'Time accounting view.'} = 'Просмотр затрат времени.';
    $Self->{Translation}->{'Time accounting.'} = 'Учет затраченного времени';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        'Для использования, если некоторые действия уменьшают рабочие часы (например, если только половина времени в пути оплачивается - Key => traveling; Content => 50).';


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
