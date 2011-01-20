# --
# Kernel/Language/fr_Survey.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: fr_Survey.pm,v 1.1 2011-01-20 17:20:21 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr_Survey;

use strict;

sub Data {
    my $Self = shift;

    # Template: AgentSurvey
    $Self->{Translation}->{'Create New Survey'} = '';
    $Self->{Translation}->{'Introduction'} = '';
    $Self->{Translation}->{'Internal Description'} = '';
    $Self->{Translation}->{'Survey Edit'} = '';
    $Self->{Translation}->{'General Info'} = '';
    $Self->{Translation}->{'Stats Overview'} = '';
    $Self->{Translation}->{'Requests Table'} = '';
    $Self->{Translation}->{'Send Time'} = '';
    $Self->{Translation}->{'Vote Time'} = '';
    $Self->{Translation}->{'Details'} = '';
    $Self->{Translation}->{'No questions saved for this survey.'} = '';
    $Self->{Translation}->{'Survey Stat Details'} = '';
    $Self->{Translation}->{'go back to stats overview'} = '';
    $Self->{Translation}->{'Go Back'} = '';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Survey Edit Questions'} = '';
    $Self->{Translation}->{'Add Question'} = '';
    $Self->{Translation}->{'Type the question'} = '';
    $Self->{Translation}->{'Survey Questions'} = '';
    $Self->{Translation}->{'Question'} = '';
    $Self->{Translation}->{'Edit Question'} = '';
    $Self->{Translation}->{'go back to questions'} = '';
    $Self->{Translation}->{'Possible Answers For'} = '';
    $Self->{Translation}->{'Add Answer'} = '';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} = '';
    $Self->{Translation}->{'Edit Answer'} = '';
    $Self->{Translation}->{'go back to edit question'} = '';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = '';
    $Self->{Translation}->{'Max. shown Surveys per page'} = '';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = '';
    $Self->{Translation}->{'Notification Subject'} = '';
    $Self->{Translation}->{'Notification Body'} = '';
    $Self->{Translation}->{'Created Time'} = '';
    $Self->{Translation}->{'Created By'} = '';
    $Self->{Translation}->{'Changed Time'} = '';
    $Self->{Translation}->{'Changed By'} = '';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = '';
    $Self->{Translation}->{'Sent requests'} = '';
    $Self->{Translation}->{'Received surveys'} = '';
    $Self->{Translation}->{'Edit General Info'} = '';
    $Self->{Translation}->{'Edit Questions'} = '';
    $Self->{Translation}->{'Stats Details'} = '';
    $Self->{Translation}->{'Survey Details'} = '';
    $Self->{Translation}->{'Survey Results Graph'} = '';
    $Self->{Translation}->{'No stat results.'} = '';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = '';
    $Self->{Translation}->{'Please answer the next questions'} = '';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = '';
    $Self->{Translation}->{'A module to edit survey questions.'} = '';
    $Self->{Translation}->{'Days starting from the latest customer survey email between no customer survey email is sent, ( 0 means Always send it ) .'} = '';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} = '';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} = '';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} = '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} = '';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the column.'} = '';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} = '';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} = '';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = '';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} = '';
    $Self->{Translation}->{'Public Survey.'} = '';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = '';
    $Self->{Translation}->{'Survey Zoom Module.'} = '';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = '';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} = '';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket gets closed.'} = '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
