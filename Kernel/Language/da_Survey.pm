# --
# Kernel/Language/da_Survey.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: da_Survey.pm,v 1.1 2011-01-20 17:20:21 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::da_Survey;

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
    $Self->{Translation}->{'Answer'} = '';

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
    $Self->{Translation}->{'Configure your own log text for PGP.'} = '';
    $Self->{Translation}->{'Custom text for the page shown to customers that have no tickets yet.'} = '';
    $Self->{Translation}->{'Days starting from the latest customer survey email between no customer survey email is sent, ( 0 means Always send it ) .'} = '';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} = '';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} = '';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} = '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} = '';
    $Self->{Translation}->{'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.'} = '';
    $Self->{Translation}->{'Defines the free key field number 1 for articles to add a new article attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 10 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 11 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 12 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 13 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 14 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 15 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 16 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 2 for articles to add a new article attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 2 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 3 for articles to add a new article attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 3 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 4 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 5 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 6 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 7 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 8 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 9 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.'} = '';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the column.'} = '';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} = '';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} = '';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = '';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} = '';
    $Self->{Translation}->{'Public Survey.'} = '';
    $Self->{Translation}->{'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.'} = '';
    $Self->{Translation}->{'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.'} = '';
    $Self->{Translation}->{'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".'} = '';
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
