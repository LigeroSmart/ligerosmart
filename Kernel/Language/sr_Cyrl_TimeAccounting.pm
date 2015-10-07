# --
# Kernel/Language/sr_Cyrl_TimeAccounting.pm - translation file
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::sr_Cyrl_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAATimeAccounting
    $Self->{Translation}->{'Time Accounting'} = 'Обрачунавање времена';
    $Self->{Translation}->{'Show valid projects'} = 'Прикажи валидне пројекте';
    $Self->{Translation}->{'Show all projects'} = 'Прикажи све пројекте';
    $Self->{Translation}->{'TimeAccounting'} = 'Обрачунавање времена';
    $Self->{Translation}->{'Reporting'} = 'Извештавање';
    $Self->{Translation}->{'Please insert your working hours!'} = 'Молимо Вас унесите ваше радне сате!';
    $Self->{Translation}->{'Successful insert!'} = 'Додавање успешно!';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = 'Грешка при уносу више датума!';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = 'Успешно убачени уноси за више датума!';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = 'Унети датум је неважећи. Датум је промењен на данашњи!';

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Да ли заиста желите да обришете обрачун времена за овај дан?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Измени временски запис';
    $Self->{Translation}->{'Go to settings'} = 'Иди у подешавања';
    $Self->{Translation}->{'Date Navigation'} = 'Датумска навигација';
    $Self->{Translation}->{'Previous day'} = 'Претходни дан';
    $Self->{Translation}->{'Next day'} = 'Следећи дан';
    $Self->{Translation}->{'Go to this date'} = 'Иди на овај дан';
    $Self->{Translation}->{'Days without entries'} = 'Дани без уноса';
    $Self->{Translation}->{'Select all days'} = 'Селектуј све дане';
    $Self->{Translation}->{'Mass entry'} = 'Масовни унос';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Молимо Вас изаберите разлог вашег одсуства за селектоване дане';
    $Self->{Translation}->{'On vacation'} = 'На одмору';
    $Self->{Translation}->{'On sick leave'} = 'На боловању';
    $Self->{Translation}->{'On overtime leave'} = 'Слободни дан';
    $Self->{Translation}->{'Please choose at least one day!'} = 'Молимо Вас изаберите бар један дан!';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Молимо Вас изаберите разлог вашег одсуства';
    $Self->{Translation}->{'Mass Entry'} = 'Масовни унос';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'Обавезна поља су означена са "*".';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Морате унети време почетка и завршетка или временски период.';
    $Self->{Translation}->{'Project'} = 'Пројекат';
    $Self->{Translation}->{'Task'} = 'Задатак';
    $Self->{Translation}->{'Remark'} = 'Напомена';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!.'} = 'Напомена треба да садржи више од 8 карактера!';
    $Self->{Translation}->{'Start Time'} = 'Време почетка';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Негативна времена нису дозвољена.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Понављање сати није дозвољено. Време почетка се поклапа са другим интервалом.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'Неисправан формат! Молимо да унесете време у формату HH:MM.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '24:00 је дозвољено само као време завршетка.';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'Неисправно време! Дан има само 24 сата.';
    $Self->{Translation}->{'End Time'} = 'Време завршетка';
    $Self->{Translation}->{'End time must be after start time.'} = 'Време завршетка мора бити након почетка.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Понављање сати није дозвољено. Време завршетка се поклапа са другим интервалом.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Неисправан период! Дан има само 24 сата!';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Исправан период мора бити већи од нуле.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Неисправан период! Негативан период није дозвољен.';
    $Self->{Translation}->{'Add one row'} = 'Додај један ред';
    $Self->{Translation}->{'Total'} = 'Укупно';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Можете изабрати само једно поље за потврду.';
    $Self->{Translation}->{'Show all items'} = 'Прикажи све ставке';
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Обриши ставку обрачуна времена';
    $Self->{Translation}->{'Confirm insert'} = 'Потврди унос';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Да ли сте сигурни да сте радили док сте били на боловању?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Да ли сте сигурни да сте радили док сте били на одмору?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Да ли сте сигурни да сте радили док сте били на слободним данима?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Да ли сте сигурни да сте радили више од 16 сати?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Преглед месечног обрачуна времена';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Прековремено (Сати)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Прековремено (овај месец)';
    $Self->{Translation}->{'Overtime (total)'} = 'Прековремено (укупно)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Преостали слободни дани';
    $Self->{Translation}->{'Vacation (Days)'} = 'Одмор (Дани)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Искоришћен одмор (овај месец)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Искоришћен одмор (укупно)';
    $Self->{Translation}->{'Remaining vacation'} = 'Преостао одмор';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Боловање (Дани)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Боловање (овај месец)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Боловање (укупно)';
    $Self->{Translation}->{'Previous month'} = 'Претходни месец';
    $Self->{Translation}->{'Next month'} = 'Следећи месец';
    $Self->{Translation}->{'Weekday'} = 'Викенд';
    $Self->{Translation}->{'Working Hours'} = 'Радни Сати';
    $Self->{Translation}->{'Total worked hours'} = 'Укупно радних сати';
    $Self->{Translation}->{'User\'s project overview'} = 'Преглед корисничког пројекта';
    $Self->{Translation}->{'Hours (monthly)'} = 'Сати (месечно)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Сати (укупно)';
    $Self->{Translation}->{'Grand total'} = 'Укупан збир';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Извештавање о времену';
    $Self->{Translation}->{'Month Navigation'} = 'Навигација по месецима';
    $Self->{Translation}->{'Go to date'} = 'Иди на дан';
    $Self->{Translation}->{'User reports'} = 'Кориснички извештаји';
    $Self->{Translation}->{'Monthly total'} = 'Месечни збир';
    $Self->{Translation}->{'Lifetime total'} = 'Свега до сада';
    $Self->{Translation}->{'Overtime leave'} = 'Слободни дани';
    $Self->{Translation}->{'Vacation'} = 'Одмор';
    $Self->{Translation}->{'Sick leave'} = 'Боловање';
    $Self->{Translation}->{'Vacation remaining'} = 'Преостао одмор';
    $Self->{Translation}->{'Project reports'} = 'Извештај о пројектима';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Извештај о пројекту';
    $Self->{Translation}->{'Go to reporting overview'} = 'Иди на преглед извештавања';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        'Тренутно су приказани само активни корисници у овом пројекту. За промену оваквог понашања, молимо Вас ажурирајте подешавања:';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'Тренутно су приказани сви корисници обрачуна времена. За промену оваквог понашања, молимо ажурирајте подешавања:';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Измени подешавања Пројекта обрачунавања времена';
    $Self->{Translation}->{'Add project'} = 'Додај пројекат';
    $Self->{Translation}->{'Go to settings overview'} = 'Иди на преглед подешавања';
    $Self->{Translation}->{'Add Project'} = 'Додај Пројекат';
    $Self->{Translation}->{'Edit Project Settings'} = 'Ажурирај Пројектна Подешавања';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Већ постоји пројекат са тим именом. Молимо вас, изаберите неко друго.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Измени подешавања обрачунавања времена';
    $Self->{Translation}->{'Add task'} = 'Додај задатак';
    $Self->{Translation}->{'New user'} = 'Нови корисник';
    $Self->{Translation}->{'Filter for Projects'} = 'Филтрирај по пројекту';
    $Self->{Translation}->{'Filter for Tasks'} = 'Филтрирај по задатку';
    $Self->{Translation}->{'Filter for Users'} = 'Филтрирај по кориснику';
    $Self->{Translation}->{'Project List'} = 'Листа Пројеката';
    $Self->{Translation}->{'Task List'} = 'Листа Задатака';
    $Self->{Translation}->{'Add Task'} = 'Додај Задатак';
    $Self->{Translation}->{'Edit Task Settings'} = 'Измени подешавања задатка';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Већ постоји задатак са тим именом. Молимо вас, изаберите неко друго.';
    $Self->{Translation}->{'User List'} = 'Листа Корисника';
    $Self->{Translation}->{'New User Settings'} = 'Нова корисничка подешавања';
    $Self->{Translation}->{'Edit User Settings'} = 'Измени корисничка подешавања';
    $Self->{Translation}->{'Comments'} = 'Коментари';
    $Self->{Translation}->{'Show Overtime'} = 'Прикажи Прековремено';
    $Self->{Translation}->{'Allow project creation'} = 'Дозволи креирање пројекта';
    $Self->{Translation}->{'Period Begin'} = 'Почетак периода';
    $Self->{Translation}->{'Period End'} = 'Крај периода';
    $Self->{Translation}->{'Days of Vacation'} = 'Дани одмора';
    $Self->{Translation}->{'Hours per Week'} = 'Сати по недељи';
    $Self->{Translation}->{'Authorized Overtime'} = 'Дозвољено прековремено';
    $Self->{Translation}->{'Start Date'} = 'Датум почетка';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Молимо да оунесете важећи датум.';
    $Self->{Translation}->{'End Date'} = 'Датум завршетка';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Крај периода мора бити после почетка периода.';
    $Self->{Translation}->{'Leave Days'} = 'Дани одмора';
    $Self->{Translation}->{'Weekly Hours'} = 'Седмични сати';
    $Self->{Translation}->{'Overtime'} = 'Прековремено';
    $Self->{Translation}->{'No time periods found.'} = 'Нису пронађени временски периоди.';
    $Self->{Translation}->{'Add time period'} = 'Додај временски период';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Преглед временског записа';
    $Self->{Translation}->{'View of '} = 'Преглед';
    $Self->{Translation}->{'No data found for this day.'} = 'Нема података за овај дан.';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'Модул за обавештавање у интерфејсу оператера који приказује број некомплетних радних дана за корисника.';
    $Self->{Translation}->{'Default name for new actions.'} = 'Подразумевано име нових акција.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Подразумевано име нових пројеката';
    $Self->{Translation}->{'Default setting for date end.'} = 'Подразумевано подешавање за датум завршетка.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Подразумевано подешавање за датум почетка.';
    $Self->{Translation}->{'Default setting for description.'} = 'Подразумевано подешавање за опис.';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Подразумевано подешавање за дане одмора.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Подразумевано подешавање за прековремени рад.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Подразумевано подешавање за стандардну радну недељу.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Подразумевани статус за нове акције.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Подразумевани статус за нове пројекте.';
    $Self->{Translation}->{'Default status for new users.'} = 'Подразумевани статус нових корисника.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        'Одређује пројекте за које је напомена обавезна. Ако се „RegExp” поклопи на пројекту, морате текође унети напомену. „RegExp” користи „smx” параметар.';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        'Одређује да ли статистички модул може генерисати информације о обрачуну времена.';
    $Self->{Translation}->{'Edit time accounting settings'} = 'Измени подешавања обрачунавања времена';
    $Self->{Translation}->{'Edit time record'} = 'Измени временски запис';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'За колико дана уназад можете унети радне јединице.';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        'Ако је активирано, приказани су само корисници који су додали радно време у изабрани пројекат.';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to autocompletion fields.'} =
        'Ако је активирано, падајући елементи на екрану за измену се мењају у самодовршавајућа поља.';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        'Ако је активирано, кориснику је дозвољено да унесе „на одмору”, „на боловању” и „на слободним данима” на више датума одједном.';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        'Максимални број радних дана после ког треба додати радне јединице.';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        'Максимални број радних дана без уноса радних јединица после ког ће бити приказано упозорење.';
    $Self->{Translation}->{'Project time reporting'} = 'Извештавање времену о пројекта';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'Регуларни изрази за ограничавање листе акција према изабраним пројектима. Кључ садржи регуларни израз за пројект(е), у садржају је регуларни израз за акцију(е).';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'Регуларни изрази за ограничавање листе акција према изабраним корисничким групама. Кључ садржи регуларни израз за пројект(е), у садржају је регуларни израз за групе.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        'Одређује да ли радни сати могу да се унесу без времена почетка и завршетка.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Овај модул намеће инос у обрачун времена.';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'Овај модул за обавештавање даје упозорење ако има превише некомплетних радних дана.';
    $Self->{Translation}->{'Time accounting edit.'} = 'Измене обрачунавања времена';
    $Self->{Translation}->{'Time accounting overview.'} = 'Преглед обрачунавања времена';
    $Self->{Translation}->{'Time accounting reporting.'} = 'Извештаји обрачунавања времена';
    $Self->{Translation}->{'Time accounting settings.'} = 'Подешавања обрачунавања времена';
    $Self->{Translation}->{'Time accounting view.'} = 'Преглед обрачунавања времена';
    $Self->{Translation}->{'Time accounting.'} = 'Обрачунавање времена';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        'За употребу ако неке акције смањују радне сате (на пример, ако се плаћа само пола времена путовања Кључ => путовање; Садржај => 50).';

}

1;
