# --
# Kernel/Language/zh_TW_Survey.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_TW_Survey;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAASurvey
    $Self->{Translation}->{'- Change Status -'} = '- 更改狀態 -';
    $Self->{Translation}->{'Add New Survey'} = '創建新的調查';
    $Self->{Translation}->{'Survey Edit'} = '編輯調查';
    $Self->{Translation}->{'Survey Edit Questions'} = '編輯調查問題';
    $Self->{Translation}->{'Question Edit'} = '編輯問題';
    $Self->{Translation}->{'Answer Edit'} = '編輯回答';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = '無法設置新的狀態！還未定義問題。';
    $Self->{Translation}->{'Status changed.'} = '狀態已更改。';
    $Self->{Translation}->{'Thank you for your feedback.'} = '感謝你的反饋。';
    $Self->{Translation}->{'The survey is finished.'} = '調查結束。';
    $Self->{Translation}->{'Complete'} = '完整';
    $Self->{Translation}->{'Incomplete'} = '不完整';
    $Self->{Translation}->{'Checkbox (List)'} = '複選框（列表）';
    $Self->{Translation}->{'Radio'} = '單選';
    $Self->{Translation}->{'Radio (List)'} = '單選（列表）';
    $Self->{Translation}->{'Stats Overview'} = '統計概況';
    $Self->{Translation}->{'Survey Description'} = '調查描述';
    $Self->{Translation}->{'Survey Introduction'} = '調查介紹';
    $Self->{Translation}->{'Yes/No'} = '是/否';
    $Self->{Translation}->{'YesNo'} = '是否';
    $Self->{Translation}->{'answered'} = '已回答';
    $Self->{Translation}->{'not answered'} = '未回答';
    $Self->{Translation}->{'Stats Detail'} = '統計詳情';
    $Self->{Translation}->{'You have already answered the survey.'} = '你已經回答了調查。';

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = '創建新的調查';
    $Self->{Translation}->{'Introduction'} = '介紹';
    $Self->{Translation}->{'Internal Description'} = '内部描述';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = '編輯一般信息';
    $Self->{Translation}->{'Survey#'} = '調查#';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = '編輯問題';
    $Self->{Translation}->{'Add Question'} = '添加問題';
    $Self->{Translation}->{'Type the question'} = '問題類型';
    $Self->{Translation}->{'Answer required'} = '需要回答';
    $Self->{Translation}->{'Survey Questions'} = '調查問題';
    $Self->{Translation}->{'Question'} = '問題';
    $Self->{Translation}->{'Answer Required'} = '必須回答';
    $Self->{Translation}->{'No questions saved for this survey.'} = '這個調查没有保存的問題。';
    $Self->{Translation}->{'Edit Question'} = '編輯問題';
    $Self->{Translation}->{'go back to questions'} = '返回問題';
    $Self->{Translation}->{'Possible Answers For'} = '可選的回答';
    $Self->{Translation}->{'Add Answer'} = '添加回答';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        '';
    $Self->{Translation}->{'Go back'} = '返回';
    $Self->{Translation}->{'Edit Answer'} = '編輯回答';
    $Self->{Translation}->{'go back to edit question'} = '返回到編輯問題';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = '上下文設置';
    $Self->{Translation}->{'Max. shown Surveys per page'} = '每頁顯示調查的最大數';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = '通知發送者';
    $Self->{Translation}->{'Notification Subject'} = '通知主題';
    $Self->{Translation}->{'Notification Body'} = '通知正文';
    $Self->{Translation}->{'Changed By'} = '修改人';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = '統計概況';
    $Self->{Translation}->{'Requests Table'} = '請求表';
    $Self->{Translation}->{'Send Time'} = '發送時間';
    $Self->{Translation}->{'Vote Time'} = '投票時間';
    $Self->{Translation}->{'Survey Stat Details'} = '調查統計詳情';
    $Self->{Translation}->{'go back to stats overview'} = '返回統計概況';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = '調查信息';
    $Self->{Translation}->{'Sent requests'} = '已發送的請求';
    $Self->{Translation}->{'Received surveys'} = '已接收的調查';
    $Self->{Translation}->{'Survey Details'} = '調查詳情';
    $Self->{Translation}->{'Survey Results Graph'} = '調查結果圖';
    $Self->{Translation}->{'No stat results.'} = '沒有統計結果。';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = '調查';
    $Self->{Translation}->{'Please answer these questions'} = '請回答這些問題';
    $Self->{Translation}->{'Show my answers'} = '顯示我的回答';
    $Self->{Translation}->{'These are your answers'} = '這些是你的回答';
    $Self->{Translation}->{'Survey Title'} = '調查標題';

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
        '';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        '';
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
        '';
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
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Modul Umfrage-Detailansicht';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = '';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = '';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        '';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        '';
    $Self->{Translation}->{'Zoom Into Statistics Details'} = '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'- No queue selected -'} = '沒有選擇隊列';
    $Self->{Translation}->{'Changed Time'} = '修改時間';
    $Self->{Translation}->{'Created By'} = '創建人';
    $Self->{Translation}->{'Created Time'} = '創建時間';
    $Self->{Translation}->{'General Info'} = '一般信息';
    $Self->{Translation}->{'No queue selected'} = '沒有選擇隊列';
    $Self->{Translation}->{'Please answer the next questions'} = '請回答下一個問題';
    $Self->{Translation}->{'Stats Details'} = '統計詳情';
    $Self->{Translation}->{'This field is required'} = '這個字段是必需的';

}

1;
