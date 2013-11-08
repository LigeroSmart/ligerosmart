# --
# Kernel/Language/zh_CN_Survey.pm - translation file
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_Survey;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAASurvey
    $Self->{Translation}->{'- Change Status -'} = '- 更改状态 -';
    $Self->{Translation}->{'Add New Survey'} = '创建新的调查';
    $Self->{Translation}->{'Survey Edit'} = '编辑调查';
    $Self->{Translation}->{'Survey Edit Questions'} = '编辑调查问题';
    $Self->{Translation}->{'Question Edit'} = '编辑问题';
    $Self->{Translation}->{'Answer Edit'} = '编辑回答';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = '无法设置新的状态！还未定义问题。';
    $Self->{Translation}->{'Status changed.'} = '状态已更改。';
    $Self->{Translation}->{'Thank you for your feedback.'} = '感谢你的反馈。';
    $Self->{Translation}->{'The survey is finished.'} = '调查结束。';
    $Self->{Translation}->{'Complete'} = '完整';
    $Self->{Translation}->{'Incomplete'} = '不完整';
    $Self->{Translation}->{'Checkbox (List)'} = '复选框（列表）';
    $Self->{Translation}->{'Radio'} = '单选';
    $Self->{Translation}->{'Radio (List)'} = '单选（列表）';
    $Self->{Translation}->{'Stats Overview'} = '统计概况';
    $Self->{Translation}->{'Survey Description'} = '调查描述';
    $Self->{Translation}->{'Survey Introduction'} = '调查介绍';
    $Self->{Translation}->{'Yes/No'} = '是/否';
    $Self->{Translation}->{'YesNo'} = '是否';
    $Self->{Translation}->{'answered'} = '已回答';
    $Self->{Translation}->{'not answered'} = '未回答';
    $Self->{Translation}->{'Stats Detail'} = '统计详情';
    $Self->{Translation}->{'You have already answered the survey.'} = '你已经回答了调查。';

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = '创建新的调查';
    $Self->{Translation}->{'Introduction'} = '介绍';
    $Self->{Translation}->{'Internal Description'} = '内部描述';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = '编辑一般信息';
    $Self->{Translation}->{'Survey#'} = '调查#';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = '编辑问题';
    $Self->{Translation}->{'Add Question'} = '添加问题';
    $Self->{Translation}->{'Type the question'} = '问题类型';
    $Self->{Translation}->{'Answer required'} = '需要回答';
    $Self->{Translation}->{'Survey Questions'} = '调查问题';
    $Self->{Translation}->{'Question'} = '问题';
    $Self->{Translation}->{'Answer Required'} = '';
    $Self->{Translation}->{'No questions saved for this survey.'} = '这个调查没有保存的问题。';
    $Self->{Translation}->{'Edit Question'} = '编辑问题';
    $Self->{Translation}->{'go back to questions'} = '返回问题';
    $Self->{Translation}->{'Possible Answers For'} = '可选的回答';
    $Self->{Translation}->{'Add Answer'} = '添加回答';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        '';
    $Self->{Translation}->{'Go back'} = '返回';
    $Self->{Translation}->{'Edit Answer'} = '编辑回答';
    $Self->{Translation}->{'go back to edit question'} = '返回到编辑问题';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = '上下文设置';
    $Self->{Translation}->{'Max. shown Surveys per page'} = '每页显示调查的最达个数';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = '通知发送者';
    $Self->{Translation}->{'Notification Subject'} = '通知主题';
    $Self->{Translation}->{'Notification Body'} = '通知正文';
    $Self->{Translation}->{'Changed By'} = '修改人';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = '统计概况';
    $Self->{Translation}->{'Requests Table'} = '请求表';
    $Self->{Translation}->{'Send Time'} = '发送时间';
    $Self->{Translation}->{'Vote Time'} = '投票时间';
    $Self->{Translation}->{'Survey Stat Details'} = '调查统计详情';
    $Self->{Translation}->{'go back to stats overview'} = '返回统计概况';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = '调查信息';
    $Self->{Translation}->{'Sent requests'} = '己发送的请求';
    $Self->{Translation}->{'Received surveys'} = '已接收的调查';
    $Self->{Translation}->{'Survey Details'} = '调查详情';
    $Self->{Translation}->{'Survey Results Graph'} = '调查结果图';
    $Self->{Translation}->{'No stat results.'} = '没有统计结果。';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = '调查';
    $Self->{Translation}->{'Please answer these questions'} = '请回答这些问题';
    $Self->{Translation}->{'Show my answers'} = '显示我的回答';
    $Self->{Translation}->{'These are your answers'} = '这些是你的回答';
    $Self->{Translation}->{'Survey Title'} = '调查标题';

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
    $Self->{Translation}->{'- No queue selected -'} = '没有选择队列';
    $Self->{Translation}->{'Changed Time'} = '修改时间';
    $Self->{Translation}->{'Created By'} = '创建人';
    $Self->{Translation}->{'Created Time'} = '创建时间';
    $Self->{Translation}->{'General Info'} = '一般信息';
    $Self->{Translation}->{'No queue selected'} = '没有选择队列';
    $Self->{Translation}->{'Please answer the next questions'} = '请回答下一个问题';
    $Self->{Translation}->{'Stats Details'} = '统计详情';
    $Self->{Translation}->{'This field is required'} = '这个字段是必需的';

}

1;
