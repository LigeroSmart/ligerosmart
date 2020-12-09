# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::mk_Survey;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Креирај нова анкета';
    $Self->{Translation}->{'Introduction'} = 'Вовед';
    $Self->{Translation}->{'Survey Introduction'} = 'Вовед во анкета';
    $Self->{Translation}->{'Notification Body'} = 'Известување за Содржина';
    $Self->{Translation}->{'Ticket Types'} = 'Тип на Тикети';
    $Self->{Translation}->{'Internal Description'} = 'Внатрешен Опис';
    $Self->{Translation}->{'Customer conditions'} = '';
    $Self->{Translation}->{'Please choose a Customer property to add a condition.'} = '';
    $Self->{Translation}->{'Public survey key'} = '';
    $Self->{Translation}->{'Example survey'} = '';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Уреди ги Општите информации';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Уреди ги Прашања';
    $Self->{Translation}->{'You are here'} = '';
    $Self->{Translation}->{'Survey Questions'} = 'Прашања од Анкета';
    $Self->{Translation}->{'Add Question'} = 'Додади прашање';
    $Self->{Translation}->{'Type the question'} = 'Внесете го прашањето';
    $Self->{Translation}->{'Answer required'} = ' Потребни одговори';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Нема зачувани прашања за оваа анкета.';
    $Self->{Translation}->{'Question'} = 'Прашање';
    $Self->{Translation}->{'Answer Required'} = 'Задолжителен Одговор ';
    $Self->{Translation}->{'When you finish to edit the survey questions just close this screen.'} =
        '';
    $Self->{Translation}->{'Close this window'} = '';
    $Self->{Translation}->{'Edit Question'} = 'Уреди ги Прашањета';
    $Self->{Translation}->{'go back to questions'} = 'врати ме на прашања';
    $Self->{Translation}->{'Question:'} = '';
    $Self->{Translation}->{'Possible Answers For'} = 'Можни одговори за';
    $Self->{Translation}->{'Add Answer'} = 'Додади Одговор';
    $Self->{Translation}->{'No answers saved for this question.'} = 'За ова прашање не е зачуван одговор.';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Ова нема повеќе одговори, полето за текст ќе биде прикажан.';
    $Self->{Translation}->{'Edit Answer'} = 'Уреди го Одговорот';
    $Self->{Translation}->{'go back to edit question'} = 'врати се на уредување на прашања';
    $Self->{Translation}->{'Answer:'} = '';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Survey overview options'} = '';
    $Self->{Translation}->{'Searches in the attributes Number, Title, Introduction, Description, NotificationSender, NotificationSubject and NotificationBody, overriding other attributes with the same name.'} =
        '';
    $Self->{Translation}->{'Survey Create Time'} = '';
    $Self->{Translation}->{'No restriction'} = '';
    $Self->{Translation}->{'Only surveys created between'} = '';
    $Self->{Translation}->{'Max. shown surveys per page'} = '';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Испрати известување';
    $Self->{Translation}->{'Notification Subject'} = 'Известување за Предмет';
    $Self->{Translation}->{'Changed By'} = 'Променето од';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = 'Преглед на Статистика за';
    $Self->{Translation}->{'Requests Table'} = 'барањата за Табела';
    $Self->{Translation}->{'Select all requests'} = '';
    $Self->{Translation}->{'Send Time'} = 'Испрати Време';
    $Self->{Translation}->{'Vote Time'} = 'Време за гласање';
    $Self->{Translation}->{'Select this request'} = '';
    $Self->{Translation}->{'See Details'} = 'Види Детали';
    $Self->{Translation}->{'Delete stats'} = '';
    $Self->{Translation}->{'Survey Stat Details'} = ' Детали за статистика на Анкета';
    $Self->{Translation}->{'go back to stats overview'} = 'врати ме на преглед на статистика ';
    $Self->{Translation}->{'Previous vote'} = '';
    $Self->{Translation}->{'Next vote'} = '';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'информации за анкета';
    $Self->{Translation}->{'Sent requests'} = 'Испратени барања';
    $Self->{Translation}->{'Received surveys'} = 'Добиени анкети';
    $Self->{Translation}->{'Survey Details'} = 'Детали за анкета';
    $Self->{Translation}->{'Ticket Services'} = 'Услуги за тикет';
    $Self->{Translation}->{'Survey Results Graph'} = 'Графикон за Резултатите од истражувањето';
    $Self->{Translation}->{'No stat results.'} = 'Нема статистички резултати.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Анкета';
    $Self->{Translation}->{'Please answer these questions'} = '';
    $Self->{Translation}->{'Show my answers'} = '';
    $Self->{Translation}->{'These are your answers'} = 'Овие се ваши одговори';
    $Self->{Translation}->{'Survey Title'} = '';

    # Perl Module: Kernel/Modules/AgentSurveyAdd.pm
    $Self->{Translation}->{'Add New Survey'} = 'Додади Новa Анкета';

    # Perl Module: Kernel/Modules/AgentSurveyEdit.pm
    $Self->{Translation}->{'You have no permission for this survey!'} = '';
    $Self->{Translation}->{'No SurveyID is given!'} = '';
    $Self->{Translation}->{'Survey Edit'} = 'Уреди ја анкетата';

    # Perl Module: Kernel/Modules/AgentSurveyEditQuestions.pm
    $Self->{Translation}->{'You have no permission for this survey or question!'} = '';
    $Self->{Translation}->{'You have no permission for this survey, question or answer!'} = '';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Уреди ги прашањата за анкетата';
    $Self->{Translation}->{'Yes/No'} = 'Да/Не';
    $Self->{Translation}->{'Radio (List)'} = 'Листа од копчиња';
    $Self->{Translation}->{'Checkbox (List)'} = 'Обележувач (Листа)';
    $Self->{Translation}->{'Net Promoter Score'} = '';
    $Self->{Translation}->{'Question Type'} = 'Тип на прашање';
    $Self->{Translation}->{'Complete'} = 'Комплетно';
    $Self->{Translation}->{'Incomplete'} = 'Некомплетно';
    $Self->{Translation}->{'Question Edit'} = 'Уреди ги прашањета';
    $Self->{Translation}->{'Answer Edit'} = 'Уреди ги одговорите';

    # Perl Module: Kernel/Modules/AgentSurveyStats.pm
    $Self->{Translation}->{'Stats Overview'} = 'Преглед на Статистика';
    $Self->{Translation}->{'You have no permission for this survey or stats detail!'} = '';
    $Self->{Translation}->{'Stats Detail'} = 'Детаљ од Статистиката';

    # Perl Module: Kernel/Modules/AgentSurveyZoom.pm
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'Не може да постави нов статус! Нема дефинирани прашања.';
    $Self->{Translation}->{'Can\'t set new status! Questions incomplete.'} = '';
    $Self->{Translation}->{'Status changed.'} = 'Статусот е променет.';
    $Self->{Translation}->{'- No queue selected -'} = '-Не е избран ред-';
    $Self->{Translation}->{'- No ticket type selected -'} = '';
    $Self->{Translation}->{'- No ticket service selected -'} = '';
    $Self->{Translation}->{'- Change Status -'} = '- Промена на статусот -';
    $Self->{Translation}->{'Master'} = '';
    $Self->{Translation}->{'Invalid'} = 'Невалидно';
    $Self->{Translation}->{'New Status'} = 'Нов Статус';
    $Self->{Translation}->{'Survey Description'} = 'Опис на анкета';
    $Self->{Translation}->{'answered'} = 'одговорено';
    $Self->{Translation}->{'not answered'} = 'не одговорено';

    # Perl Module: Kernel/Modules/PublicSurvey.pm
    $Self->{Translation}->{'Thank you for your feedback.'} = '';
    $Self->{Translation}->{'The survey is finished.'} = 'Анкетата е завршена.';
    $Self->{Translation}->{'Survey Message!'} = '';
    $Self->{Translation}->{'Module not enabled.'} = '';
    $Self->{Translation}->{'This functionality is not enabled, please contact your administrator.'} =
        '';
    $Self->{Translation}->{'Survey Error!'} = '';
    $Self->{Translation}->{'Invalid survey key.'} = '';
    $Self->{Translation}->{'The inserted survey key is invalid, if you followed a link maybe this is obsolete or broken.'} =
        '';
    $Self->{Translation}->{'Survey Vote'} = '';
    $Self->{Translation}->{'Survey Vote Data'} = '';
    $Self->{Translation}->{'You have already answered the survey.'} = 'Веќе ја одговоривте анкетата.';

    # Perl Module: Kernel/System/Stats/Dynamic/SurveyList.pm
    $Self->{Translation}->{'Survey List'} = '';

    # JS File: Survey.Agent.SurveyEditQuestions
    $Self->{Translation}->{'Do you really want to delete this question? ALL associated data will be LOST!'} =
        'Дали навистина сакате да го избришете ова прашање? Сите поврзани податоци ќе бидат ИЗГУБЕНИ!';
    $Self->{Translation}->{'Do you really want to delete this answer?'} = 'Дали навистина сакате да го избришете овој одговор?';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Модул за Анкета';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Модул за уредување на анкетни прашања';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        'Сите параметри за објектот на Анкетата во интерфејсот на агентот.';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        'Количина на денови по праќање на анкетниот e-mail во кој не се пратени ниту една иста анкета на ист корисник. Со одбирање на 0 секогаш ќе бидат пратени анкетни e-mail-ови.';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Стандардна содржина на е-пошта за известување на клиентите за новата анкета.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Стандарден испраќач на е-пошта за известување на клиентите за новата анкета.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Стандарден предмет на е-пошта за известување на клиентите за новата анкета.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Дефинирање на модул за преглед за да се прикаже мал поглед на анкетата листа.';
    $Self->{Translation}->{'Defines groups which have a permission to change survey status. Array is empty by default and agents from all groups can change survey status.'} =
        '';
    $Self->{Translation}->{'Defines if survey requests will be only send to real customers.'} =
        '';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        'Дефинира максимален износ на анкети кои се испратени на клиентите по 30 дена. (0 значи без максимум, сите барања ќе бидат испратени).';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ). Note: delayed survey sending is done by the OTRS Daemon, prior activation of \'Daemon::SchedulerCronTaskManager::Task###SurveyRequestsSend\' setting.'} =
        '';
    $Self->{Translation}->{'Defines the columns for the dropdown list for building send conditions (0 => inactive, 1 => active).'} =
        '';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        'Ја дефинира стандардната височина на Richtext прегледот за SurveyZoom елементите.';
    $Self->{Translation}->{'Defines the groups (rw) which can delete survey stats.'} = '';
    $Self->{Translation}->{'Defines the maximum height for Richtext views for SurveyZoom elements.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        'Дефинира прикажани колони во прегледот на анкети. Оваа опција нема ефект врз позицијата на колоните.';
    $Self->{Translation}->{'Determines if the statistics module may generate survey lists.'} =
        '';
    $Self->{Translation}->{'Edit survey general information.'} = '';
    $Self->{Translation}->{'Edit survey questions.'} = '';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        '';
    $Self->{Translation}->{'Enable or disable the send condition check for the service.'} = 'Вклучете или исклучете ја проверката на состојбата за испраќање на услуга.';
    $Self->{Translation}->{'Enable or disable the send condition check for the ticket type.'} =
        'Вклучете или исклучете ја проверката на состојбата за испраќање на типот на тикетот.';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        'Регистрација на модул за додавање на анкети во интерфејсот на агентот.';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        'Регистрација на модул за измена на анкети во интерфејсот на агентот.';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        'Регистрација на модул за анкетни записи во интерфејсот на агентот.';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        'Регистрација на модул за детално анкетирање во интерфејсот на агентот.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        '';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Ако овој израз се совпаѓа, анкета нема да биде испратена на клиентот.';
    $Self->{Translation}->{'Limit.'} = '';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Параметри за страници (во кој се прикажуваат анкетите) на мала преглед на анкета.';
    $Self->{Translation}->{'Public Survey.'} = '';
    $Self->{Translation}->{'Results older than the configured amount of days will be deleted. Note: delete results done by the OTRS Daemon, prior activation of \'Task###SurveyRequestsDelete\' setting.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        'Прикажува линк во менито за уредување на анкети во деталниот поглед во интерфејсот на агентот.';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        'Прикажува во менито линкот за уредување на анкетни прашања во детален поглед во интерфејсот на агент.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        'Прикажува во менито линкот за враќање во детален поглед во интерфејсот на агент.';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        'Прикажува во менито линкот за детален приказ на статиситики во детален поглед во интерфејсот на агент';
    $Self->{Translation}->{'Stats Details'} = 'Детали од Статистиката';
    $Self->{Translation}->{'Survey Add Module.'} = '';
    $Self->{Translation}->{'Survey Edit Module.'} = 'Модул за Уредување на Анкета.';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Ограничување на Преглед на Анкета - "Малку"';
    $Self->{Translation}->{'Survey Stats Module.'} = 'Модул за Статистика на Анкета.';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Модул за Детален приказ на Анкета.';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small".'} = '';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = 'Анкети нема да биде испратени до конфигурирани е-пошти.';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'Идентификатор за анкетата, на пример: Survey#, MySurvey#. Стандардно е Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        'Модула на Тикет за автоматско праќање на анкетни e-mail барања до клиентите ако тикетот е затворен.';
    $Self->{Translation}->{'Trigger delete results (including vote data and requests).'} = '';
    $Self->{Translation}->{'Trigger sending delayed survey requests.'} = '';
    $Self->{Translation}->{'Zoom into statistics details.'} = '';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Do you really want to delete this answer?',
    'Do you really want to delete this question? ALL associated data will be LOST!',
    'Settings',
    'Submit',
    );

}

1;
