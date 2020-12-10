# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::fi_Survey;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Luo uusi kysely';
    $Self->{Translation}->{'Introduction'} = 'Esittely';
    $Self->{Translation}->{'Survey Introduction'} = 'Kyselyn esittely';
    $Self->{Translation}->{'Notification Body'} = 'Muistutuksen viesti';
    $Self->{Translation}->{'Ticket Types'} = 'Tikettien tyypit';
    $Self->{Translation}->{'Internal Description'} = 'Sisäinen kuvaus';
    $Self->{Translation}->{'Customer conditions'} = '';
    $Self->{Translation}->{'Please choose a Customer property to add a condition.'} = '';
    $Self->{Translation}->{'Public survey key'} = '';
    $Self->{Translation}->{'Example survey'} = '';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Muokkaa tietoja';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Muokkaa kysymyksiä';
    $Self->{Translation}->{'You are here'} = '';
    $Self->{Translation}->{'Survey Questions'} = 'Kyselyn kysymykset';
    $Self->{Translation}->{'Add Question'} = 'Lisää kysymys';
    $Self->{Translation}->{'Type the question'} = 'Syötä kysymys';
    $Self->{Translation}->{'Answer required'} = '';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Kyselyyn ei ole tallennettu kysymyksiä.';
    $Self->{Translation}->{'Question'} = 'Kysymys';
    $Self->{Translation}->{'Answer Required'} = '';
    $Self->{Translation}->{'When you finish to edit the survey questions just close this screen.'} =
        '';
    $Self->{Translation}->{'Close this window'} = '';
    $Self->{Translation}->{'Edit Question'} = 'Muokkaa kysymystä';
    $Self->{Translation}->{'go back to questions'} = 'mene takaisin kysymyksiin';
    $Self->{Translation}->{'Question:'} = '';
    $Self->{Translation}->{'Possible Answers For'} = 'Vastausvaihtoehdot';
    $Self->{Translation}->{'Add Answer'} = 'Lisää vastaus';
    $Self->{Translation}->{'No answers saved for this question.'} = '';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Tässä ei ole useita vastauksia, näytetään tekstialue.';
    $Self->{Translation}->{'Edit Answer'} = 'Muokkaa vastausta';
    $Self->{Translation}->{'go back to edit question'} = 'mene takaisin muokkaamaan kysymystä';
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
    $Self->{Translation}->{'Notification Sender'} = 'Muistutuksen lähettäjä';
    $Self->{Translation}->{'Notification Subject'} = 'Muistutuksen otsikko';
    $Self->{Translation}->{'Changed By'} = 'Muokkaaja';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = 'Tulosten yhteenveto';
    $Self->{Translation}->{'Requests Table'} = '';
    $Self->{Translation}->{'Select all requests'} = '';
    $Self->{Translation}->{'Send Time'} = 'Lähetysaika';
    $Self->{Translation}->{'Vote Time'} = 'Äänestysaika';
    $Self->{Translation}->{'Select this request'} = '';
    $Self->{Translation}->{'See Details'} = '';
    $Self->{Translation}->{'Delete stats'} = '';
    $Self->{Translation}->{'Survey Stat Details'} = 'Kyselyn tulosten yksityiskohdat';
    $Self->{Translation}->{'go back to stats overview'} = 'mene takaisin yhteenvetoon';
    $Self->{Translation}->{'Previous vote'} = '';
    $Self->{Translation}->{'Next vote'} = '';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Kyselyn tiedot';
    $Self->{Translation}->{'Sent requests'} = 'Lähetettyjä kyselyitä';
    $Self->{Translation}->{'Received surveys'} = 'Vastausten määrä';
    $Self->{Translation}->{'Survey Details'} = 'Kyselyn yksityiskohdat';
    $Self->{Translation}->{'Ticket Services'} = '';
    $Self->{Translation}->{'Survey Results Graph'} = 'Tulosten graafit';
    $Self->{Translation}->{'No stat results.'} = 'Ei tuloksia.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Kysely';
    $Self->{Translation}->{'Please answer these questions'} = 'Vastaa seuraaviin kysymyksiin';
    $Self->{Translation}->{'Show my answers'} = 'Näytä vastaukseni';
    $Self->{Translation}->{'These are your answers'} = 'Nämä ovat vastauksesi';
    $Self->{Translation}->{'Survey Title'} = 'Kyselyn otsikko';

    # Perl Module: Kernel/Modules/AgentSurveyAdd.pm
    $Self->{Translation}->{'Add New Survey'} = 'Lisää uusi kysely';

    # Perl Module: Kernel/Modules/AgentSurveyEdit.pm
    $Self->{Translation}->{'You have no permission for this survey!'} = '';
    $Self->{Translation}->{'No SurveyID is given!'} = '';
    $Self->{Translation}->{'Survey Edit'} = 'Muokkaa kyselyä';

    # Perl Module: Kernel/Modules/AgentSurveyEditQuestions.pm
    $Self->{Translation}->{'You have no permission for this survey or question!'} = '';
    $Self->{Translation}->{'You have no permission for this survey, question or answer!'} = '';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Muokkaa kysymyksiä';
    $Self->{Translation}->{'Yes/No'} = 'Kyllä / Ei';
    $Self->{Translation}->{'Radio (List)'} = 'Valitse yksi monesta (Lista)';
    $Self->{Translation}->{'Checkbox (List)'} = 'Valitse yksi tai useampia (Lista)';
    $Self->{Translation}->{'Net Promoter Score'} = '';
    $Self->{Translation}->{'Question Type'} = '';
    $Self->{Translation}->{'Complete'} = 'Valmis';
    $Self->{Translation}->{'Incomplete'} = 'Keskeneräinen';
    $Self->{Translation}->{'Question Edit'} = 'Kysymysten muokkaus';
    $Self->{Translation}->{'Answer Edit'} = 'Vastausten muokkaus';

    # Perl Module: Kernel/Modules/AgentSurveyStats.pm
    $Self->{Translation}->{'Stats Overview'} = 'Tulosten yhteenveto';
    $Self->{Translation}->{'You have no permission for this survey or stats detail!'} = '';
    $Self->{Translation}->{'Stats Detail'} = 'Yksityiskohtaiset tulokset';

    # Perl Module: Kernel/Modules/AgentSurveyZoom.pm
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'Uuden tilan asettaminen ei onnistu! Et ole määrittänyt kysymyksiä!';
    $Self->{Translation}->{'Can\'t set new status! Questions incomplete.'} = '';
    $Self->{Translation}->{'Status changed.'} = 'Tila muutettu.';
    $Self->{Translation}->{'- No queue selected -'} = '';
    $Self->{Translation}->{'- No ticket type selected -'} = '';
    $Self->{Translation}->{'- No ticket service selected -'} = '';
    $Self->{Translation}->{'- Change Status -'} = '- Muuta tilaa -';
    $Self->{Translation}->{'Master'} = '';
    $Self->{Translation}->{'Invalid'} = 'Poistettu käytöstä';
    $Self->{Translation}->{'New Status'} = '';
    $Self->{Translation}->{'Survey Description'} = 'Kyselyn kuvaus';
    $Self->{Translation}->{'answered'} = 'Vastasi';
    $Self->{Translation}->{'not answered'} = 'Ei vastannut';

    # Perl Module: Kernel/Modules/PublicSurvey.pm
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Kiitos palautteestasi.';
    $Self->{Translation}->{'The survey is finished.'} = 'Kysely on valmis.';
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
    $Self->{Translation}->{'You have already answered the survey.'} = 'Olet jo vastannut tähän kyselyyn.';

    # Perl Module: Kernel/System/Stats/Dynamic/SurveyList.pm
    $Self->{Translation}->{'Survey List'} = '';

    # JS File: Survey.Agent.SurveyEditQuestions
    $Self->{Translation}->{'Do you really want to delete this question? ALL associated data will be LOST!'} =
        '';
    $Self->{Translation}->{'Do you really want to delete this answer?'} = '';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Kyselyominaisuus';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Moduuli kyselyiden luontiin';
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
    $Self->{Translation}->{'Defines groups which have a permission to change survey status. Array is empty by default and agents from all groups can change survey status.'} =
        '';
    $Self->{Translation}->{'Defines if survey requests will be only send to real customers.'} =
        '';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        '';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ). Note: delayed survey sending is done by the OTRS Daemon, prior activation of \'Daemon::SchedulerCronTaskManager::Task###SurveyRequestsSend\' setting.'} =
        '';
    $Self->{Translation}->{'Defines the columns for the dropdown list for building send conditions (0 => inactive, 1 => active).'} =
        '';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        '';
    $Self->{Translation}->{'Defines the groups (rw) which can delete survey stats.'} = '';
    $Self->{Translation}->{'Defines the maximum height for Richtext views for SurveyZoom elements.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        '';
    $Self->{Translation}->{'Determines if the statistics module may generate survey lists.'} =
        '';
    $Self->{Translation}->{'Edit survey general information.'} = '';
    $Self->{Translation}->{'Edit survey questions.'} = '';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        '';
    $Self->{Translation}->{'Enable or disable the send condition check for the service.'} = '';
    $Self->{Translation}->{'Enable or disable the send condition check for the ticket type.'} =
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
    $Self->{Translation}->{'Limit.'} = '';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        '';
    $Self->{Translation}->{'Public Survey.'} = '';
    $Self->{Translation}->{'Results older than the configured amount of days will be deleted. Note: delete results done by the OTRS Daemon, prior activation of \'Task###SurveyRequestsDelete\' setting.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Stats Details'} = 'Tulosten yksityiskohdat';
    $Self->{Translation}->{'Survey Add Module.'} = '';
    $Self->{Translation}->{'Survey Edit Module.'} = '';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = '';
    $Self->{Translation}->{'Survey Stats Module.'} = '';
    $Self->{Translation}->{'Survey Zoom Module.'} = '';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small".'} = '';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = '';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        '';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        '';
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
