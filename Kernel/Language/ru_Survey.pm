# --
# Kernel/Language/ru_Survey.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_Survey;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAASurvey
    $Self->{Translation}->{'- Change Status -'} = '- Изменить состояние -';
    $Self->{Translation}->{'Add New Survey'} = 'Добавить новый опрос';
    $Self->{Translation}->{'Survey Edit'} = 'Редактировать опрос';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Редактировать вопрос в опросе';
    $Self->{Translation}->{'Question Edit'} = 'Редактировать вопрос';
    $Self->{Translation}->{'Answer Edit'} = 'Редактировать ответ';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'Нельзя задать новое состояние! Никакие вопросы не выделены.';
    $Self->{Translation}->{'Status changed.'} = 'Изменить состояние.';
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Спасибо за Ваши ответы.';
    $Self->{Translation}->{'The survey is finished.'} = 'Опрос завершен.';
    $Self->{Translation}->{'Complete'} = 'Завершенный';
    $Self->{Translation}->{'Incomplete'} = 'Незавершенный';
    $Self->{Translation}->{'Checkbox (List)'} = 'Галочки (Список)';
    $Self->{Translation}->{'Radio'} = 'Точки';
    $Self->{Translation}->{'Radio (List)'} = 'Точки (Список)';
    $Self->{Translation}->{'Stats Overview'} = 'Обзор статистики';
    $Self->{Translation}->{'Survey Description'} = 'Описание опроса';
    $Self->{Translation}->{'Survey Introduction'} = 'Знакомство с опросом';
    $Self->{Translation}->{'Yes/No'} = 'Да/Нет';
    $Self->{Translation}->{'YesNo'} = 'Да или Нет';
    $Self->{Translation}->{'answered'} = 'ответили';
    $Self->{Translation}->{'not answered'} = 'не ответили';
    $Self->{Translation}->{'Stats Details'} = 'Подробная статистика';
    $Self->{Translation}->{'You have already answered the survey.'} = 'Вы уже ответили на опрос.';

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Создать новый опрос';
    $Self->{Translation}->{'Introduction'} = 'Описание';
    $Self->{Translation}->{'Internal Description'} = 'Внутреннее описание';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Редактировать общую информацию';
    $Self->{Translation}->{'Survey#'} = 'Опрос №';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Редактировать вопросы';
    $Self->{Translation}->{'Add Question'} = 'Добавть вопрос';
    $Self->{Translation}->{'Type the question'} = 'Вопрос и тип вопроса';
    $Self->{Translation}->{'Answer required'} = 'Требуются ответы';
    $Self->{Translation}->{'Survey Questions'} = 'Вопросы опроса';
    $Self->{Translation}->{'Question'} = 'Вопрос';
    $Self->{Translation}->{'Answer Required'} = 'Требуются Ответы';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Сохраненых вопросов нет.';
    $Self->{Translation}->{'Edit Question'} = 'Редактировать вопрос';
    $Self->{Translation}->{'go back to questions'} = 'назад к вопросам';
    $Self->{Translation}->{'Possible Answers For'} = 'Возможные ответы для';
    $Self->{Translation}->{'Add Answer'} = 'Добавить ответ';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        '';
    $Self->{Translation}->{'Go back'} = 'Назад';
    $Self->{Translation}->{'Edit Answer'} = 'Редактировать ответ';
    $Self->{Translation}->{'go back to edit question'} = 'назад к редактированию вопроса';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Макс. кол-во Опросов на страницу';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = '';
    $Self->{Translation}->{'Notification Subject'} = '';
    $Self->{Translation}->{'Notification Body'} = '';
    $Self->{Translation}->{'Changed By'} = '';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = 'Подробности опроса';
    $Self->{Translation}->{'Requests Table'} = 'Таблица ответов';
    $Self->{Translation}->{'Send Time'} = 'Время отправки';
    $Self->{Translation}->{'Vote Time'} = 'Время ответа';
    $Self->{Translation}->{'Survey Stat Details'} = 'Подробности опроса';
    $Self->{Translation}->{'go back to stats overview'} = 'назад';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Информация по опросу';
    $Self->{Translation}->{'Sent requests'} = 'Отправленные запросы';
    $Self->{Translation}->{'Received surveys'} = 'Полученные опросы';
    $Self->{Translation}->{'Survey Details'} = 'Информаия по опросу';
    $Self->{Translation}->{'Survey Results Graph'} = 'Результаты опроса в графике';
    $Self->{Translation}->{'No stat results.'} = 'Статистики нет.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Опросы';
    $Self->{Translation}->{'Please answer these questions'} = 'Ответьте на эти вопросы:';
    $Self->{Translation}->{'Show my answers'} = 'Показать мои ответы';
    $Self->{Translation}->{'These are your answers'} = 'Ваши ответы';
    $Self->{Translation}->{'Survey Title'} = 'Название опроса';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = '';
    $Self->{Translation}->{'A module to edit survey questions.'} = '';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        '';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        '';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        '';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Отправитель по умолчанию для электронной почты в новом опросе.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Тема по умолчанию для электронной почты в новом опросе.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        '';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        '';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ).'} =
        '';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        '';
    $Self->{Translation}->{'Edit Survey General Information'} = '';
    $Self->{Translation}->{'Edit Survey Questions'} = '';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        'Включите или отключить кнопку "Показать мои ответы", чтобы показать данные определенного результата опроса, когда клиент попытается ответить на опрос во второй раз.';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        '';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = '';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        '';
    $Self->{Translation}->{'Public Survey.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Survey Edit Module.'} = '';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = '';
    $Self->{Translation}->{'Survey Stats Module.'} = '';
    $Self->{Translation}->{'Survey Zoom Module.'} = '';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = '';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = '';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        '';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        '';
    $Self->{Translation}->{'Zoom Into Statistics Details'} = 'Подробная информация по статистике';

    #There was no translation, added
    $Self->{Translation}->{'Survey Error!'} = 'Ошибка опроса!';
    $Self->{Translation}->{'Invalid survey key.'} = 'Неправильный ключ опроса.';
    $Self->{Translation}->{'The inserted survey key is invalid, if you followed a link maybe this is obsolete or broken.'} = 'Вставленный ключ опроса - Неправильный, если Вы прошли по ссылке, то возможно опрос устарел или неправильно указан.';
    $Self->{Translation}->{'Textarea'} = 'Текстовое поле';
    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #


}

1;
