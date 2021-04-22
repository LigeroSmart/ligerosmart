# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::nl_Survey;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Nieuwe enquête maken';
    $Self->{Translation}->{'Introduction'} = 'Introductie';
    $Self->{Translation}->{'Survey Introduction'} = 'Enquête introductie';
    $Self->{Translation}->{'Notification Body'} = 'Meldingtekst';
    $Self->{Translation}->{'Ticket Types'} = 'Tickettypen';
    $Self->{Translation}->{'Internal Description'} = 'Interne beschrijving';
    $Self->{Translation}->{'Customer conditions'} = 'Klant voorwaarden';
    $Self->{Translation}->{'Please choose a Customer property to add a condition.'} = 'Kies een klanteigenschap om een voorwaarde toe te voegen.';
    $Self->{Translation}->{'Public survey key'} = 'Openbare enquêtesleutel';
    $Self->{Translation}->{'Example survey'} = 'Voorbeeld enquête';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Algemene info bewerken';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Vragen bewerken';
    $Self->{Translation}->{'You are here'} = 'Je bevindt je hier';
    $Self->{Translation}->{'Survey Questions'} = 'Enquêtevragen';
    $Self->{Translation}->{'Add Question'} = 'Vraag toevoegen';
    $Self->{Translation}->{'Type the question'} = 'Typ de vraag';
    $Self->{Translation}->{'Answer required'} = 'Antwoord vereist';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Geen vragen opgeslagen voor deze enquête.';
    $Self->{Translation}->{'Question'} = 'Vraag';
    $Self->{Translation}->{'Answer Required'} = 'Antwoord vereist';
    $Self->{Translation}->{'When you finish to edit the survey questions just close this screen.'} =
        'Sluit dit scherm als je klaar bent met het bewerken van de vragen.';
    $Self->{Translation}->{'Close this window'} = 'Sluit dit venster';
    $Self->{Translation}->{'Edit Question'} = 'Vraag bewerken';
    $Self->{Translation}->{'go back to questions'} = 'ga terug naar vragen';
    $Self->{Translation}->{'Question:'} = 'Vraag:';
    $Self->{Translation}->{'Possible Answers For'} = 'Mogelijke antwoorden voor';
    $Self->{Translation}->{'Add Answer'} = 'Antwoord toevoegen';
    $Self->{Translation}->{'No answers saved for this question.'} = 'Geen antwoorden opgeslagen voor deze vraag.';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Dit heeft geen verschillende antwoorden, er wordt een tekstgebied weergegeven.';
    $Self->{Translation}->{'Edit Answer'} = 'Antwoord bewerken';
    $Self->{Translation}->{'go back to edit question'} = 'ga terug om de vraag te bewerken';
    $Self->{Translation}->{'Answer:'} = 'Antwoord:';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Survey overview options'} = 'Enquête overzichtopties';
    $Self->{Translation}->{'Searches in the attributes Number, Title, Introduction, Description, NotificationSender, NotificationSubject and NotificationBody, overriding other attributes with the same name.'} =
        'Zoekt in de attributen Nummer, Titel, Inleiding, Beschrijving, NotificationSender, NotificationSubject en NotificationBody, waarbij andere attributen met dezelfde naam worden vervangen.';
    $Self->{Translation}->{'Survey Create Time'} = 'Enquête maaktijd';
    $Self->{Translation}->{'No restriction'} = 'Geen beperkingen';
    $Self->{Translation}->{'Only surveys created between'} = 'Alleen enquêtes gemaakt tussen';
    $Self->{Translation}->{'Max. shown surveys per page'} = 'Max. weergegeven enquêtes per pagina';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Afzender van melding';
    $Self->{Translation}->{'Notification Subject'} = 'Meldingonderwerp';
    $Self->{Translation}->{'Changed By'} = 'Gewijzigd door';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = 'Statistieken overzicht van';
    $Self->{Translation}->{'Requests Table'} = 'Verzoeken tabel';
    $Self->{Translation}->{'Select all requests'} = 'Selecteer alle verzoeken';
    $Self->{Translation}->{'Send Time'} = 'Verzend tijd';
    $Self->{Translation}->{'Vote Time'} = 'Stem tijd';
    $Self->{Translation}->{'Select this request'} = 'Selecteer deze aanvraag';
    $Self->{Translation}->{'See Details'} = 'Zie Details';
    $Self->{Translation}->{'Delete stats'} = 'Statistieken verwijderen';
    $Self->{Translation}->{'Survey Stat Details'} = 'Enquêtestatistiekdetails';
    $Self->{Translation}->{'go back to stats overview'} = 'ga terug naar het statistiekenoverzicht';
    $Self->{Translation}->{'Previous vote'} = 'Vorige stem';
    $Self->{Translation}->{'Next vote'} = 'Volgende stem';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Enquête informatie';
    $Self->{Translation}->{'Sent requests'} = 'Verzonden verzoeken';
    $Self->{Translation}->{'Received surveys'} = 'Ontvangen enquêtes';
    $Self->{Translation}->{'Survey Details'} = 'Enquête details';
    $Self->{Translation}->{'Ticket Services'} = 'Ticket Services';
    $Self->{Translation}->{'Survey Results Graph'} = 'Enquête resultaten grafiek';
    $Self->{Translation}->{'No stat results.'} = 'Geen statistische resultaten.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Enquête';
    $Self->{Translation}->{'Please answer these questions'} = 'Beantwoord deze vragen';
    $Self->{Translation}->{'Show my answers'} = 'Mijn antwoorden weergeven';
    $Self->{Translation}->{'These are your answers'} = 'Dit zijn jouw antwoorden';
    $Self->{Translation}->{'Survey Title'} = 'Enquêtetitel';

    # Perl Module: Kernel/Modules/AgentSurveyAdd.pm
    $Self->{Translation}->{'Add New Survey'} = 'Nieuwe enquête toevoegen';

    # Perl Module: Kernel/Modules/AgentSurveyEdit.pm
    $Self->{Translation}->{'You have no permission for this survey!'} = 'Je hebt geen toestemming voor deze enquête!';
    $Self->{Translation}->{'No SurveyID is given!'} = 'Er wordt geen SurveyID gegeven!';
    $Self->{Translation}->{'Survey Edit'} = 'Enquête bewerken';

    # Perl Module: Kernel/Modules/AgentSurveyEditQuestions.pm
    $Self->{Translation}->{'You have no permission for this survey or question!'} = 'Je hebt geen toestemming voor deze enquête of vraag!';
    $Self->{Translation}->{'You have no permission for this survey, question or answer!'} = 'Je hebt geen toestemming voor deze enquête, vraag of antwoord!';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Enquête vragen bewerken';
    $Self->{Translation}->{'Yes/No'} = 'Ja/Nee';
    $Self->{Translation}->{'Radio (List)'} = 'Keuzerondje (lijst)';
    $Self->{Translation}->{'Checkbox (List)'} = 'Checkbox (lijst)';
    $Self->{Translation}->{'Net Promoter Score'} = 'Net Promoter Score';
    $Self->{Translation}->{'Question Type'} = 'Vraag type';
    $Self->{Translation}->{'Complete'} = 'Volledig';
    $Self->{Translation}->{'Incomplete'} = 'Onvolledig';
    $Self->{Translation}->{'Question Edit'} = 'Vraag bewerken';
    $Self->{Translation}->{'Answer Edit'} = 'Antwoord bewerken';

    # Perl Module: Kernel/Modules/AgentSurveyStats.pm
    $Self->{Translation}->{'Stats Overview'} = 'Statistieken overzicht';
    $Self->{Translation}->{'You have no permission for this survey or stats detail!'} = 'Je hebt geen toestemming voor deze enquête of statistieken!';
    $Self->{Translation}->{'Stats Detail'} = 'Statistieken Detail';

    # Perl Module: Kernel/Modules/AgentSurveyZoom.pm
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'Kan geen nieuwe status instellen! Geen vragen gedefinieerd.';
    $Self->{Translation}->{'Can\'t set new status! Questions incomplete.'} = 'Kan geen nieuwe status instellen! Vragen onvolledig.';
    $Self->{Translation}->{'Status changed.'} = 'Status gewijzigd.';
    $Self->{Translation}->{'- No queue selected -'} = '- Geen wachtrij geselecteerd -';
    $Self->{Translation}->{'- No ticket type selected -'} = '- Geen tickettype geselecteerd -';
    $Self->{Translation}->{'- No ticket service selected -'} = '- Geen ticketservice geselecteerd -';
    $Self->{Translation}->{'- Change Status -'} = '- Status wijzigen -';
    $Self->{Translation}->{'Master'} = 'Master';
    $Self->{Translation}->{'Invalid'} = 'Ongeldig';
    $Self->{Translation}->{'New Status'} = 'Nieuwe Status';
    $Self->{Translation}->{'Survey Description'} = 'Enquête beschrijving';
    $Self->{Translation}->{'answered'} = 'beantwoord';
    $Self->{Translation}->{'not answered'} = 'niet beantwoord';

    # Perl Module: Kernel/Modules/PublicSurvey.pm
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Bedankt voor uw feedback.';
    $Self->{Translation}->{'The survey is finished.'} = 'De enquête is voltooid.';
    $Self->{Translation}->{'Survey Message!'} = 'Enquête bericht!';
    $Self->{Translation}->{'Module not enabled.'} = 'Module niet ingeschakeld.';
    $Self->{Translation}->{'This functionality is not enabled, please contact your administrator.'} =
        'Deze functionaliteit is niet ingeschakeld, neem contact op met je beheerder.';
    $Self->{Translation}->{'Survey Error!'} = 'Enquête fout!';
    $Self->{Translation}->{'Invalid survey key.'} = 'Ongeldige enquêtesleutel.';
    $Self->{Translation}->{'The inserted survey key is invalid, if you followed a link maybe this is obsolete or broken.'} =
        'De ingevoegde enquêtesleutel is ongeldig. Als u een link hebt gevolgd, is deze mogelijk verouderd of defect.';
    $Self->{Translation}->{'Survey Vote'} = 'Enquête stemmen';
    $Self->{Translation}->{'Survey Vote Data'} = 'Enquête stemgegevens';
    $Self->{Translation}->{'You have already answered the survey.'} = 'U hebt de enquête al beantwoord.';

    # Perl Module: Kernel/System/Stats/Dynamic/SurveyList.pm
    $Self->{Translation}->{'Survey List'} = 'Enquête lijst';

    # JS File: Survey.Agent.SurveyEditQuestions
    $Self->{Translation}->{'Do you really want to delete this question? ALL associated data will be LOST!'} =
        'Wil je deze vraag echt verwijderen? ALLE bijbehorende gegevens gaan VERLOREN!';
    $Self->{Translation}->{'Do you really want to delete this answer?'} = 'Wil je dit antwoord echt verwijderen?';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Een enquête module.';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Een module om enquêtevragen te bewerken.';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        'Alle parameters voor het enquête-object in de agentinterface.';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        'Aantal dagen na verzending van een enquêtemail waarin geen nieuwe enquêteaanvragen naar dezelfde klant worden verzonden. Door 0 te selecteren wordt de enquêtemail altijd verzonden.';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Standaardtekst voor de e-mailmelding aan klanten over nieuwe enquête.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Standaardafzender voor de e-mailmelding aan klanten over nieuwe enquête.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Standaardonderwerp voor de e-mailmelding aan klanten over nieuwe enquête.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Definieert een overzichtsmodule om de kleine weergave van een overzichtslijst weer te geven.';
    $Self->{Translation}->{'Defines groups which have a permission to change survey status. Array is empty by default and agents from all groups can change survey status.'} =
        'Definieert groepen die toestemming hebben om de enquêtestatus te wijzigen. Array is standaard leeg en agenten uit alle groepen kunnen de enquêtestatus wijzigen.';
    $Self->{Translation}->{'Defines if survey requests will be only send to real customers.'} =
        'Bepaalt of enquêteverzoeken alleen naar echte klanten worden verzonden.';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        'Bepaalt het maximale aantal enquêtes dat per 30 dagen naar een klant wordt verzonden. (0 betekent geen maximum, alle enquêteaanvragen worden verzonden).';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ). Note: delayed survey sending is done by the OTRS Daemon, prior activation of \'Daemon::SchedulerCronTaskManager::Task###SurveyRequestsSend\' setting.'} =
        'Bepaalt het aantal uren dat een ticket moet zijn gesloten om een enquête te verzenden (0 betekent verzenden direct na sluiting). Opmerking: het vertraagd verzenden van enquêtes wordt gedaan door de OTRS Daemon, voorafgaande activering van de instelling \'Daemon::SchedulerCronTaskManager::Task###SurveyRequestsSend\'.';
    $Self->{Translation}->{'Defines the columns for the dropdown list for building send conditions (0 => inactive, 1 => active).'} =
        'Definieert de kolommen voor de vervolgkeuzelijst voor het bouwen van verzendvoorwaarden (0 => inactief, 1 => actief).';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        'Definieert de standaardhoogte voor Richtext-weergaven voor EnquêteZoom-elementen.';
    $Self->{Translation}->{'Defines the groups (rw) which can delete survey stats.'} = 'Definieert de groepen (rw) die enquêtestatistieken kunnen verwijderen.';
    $Self->{Translation}->{'Defines the maximum height for Richtext views for SurveyZoom elements.'} =
        'Bepaalt de maximale hoogte voor Richtext-weergaven voor EnquêteZoom-elementen.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        'Definieert de weergegeven kolommen in het overzicht van de enquête. Deze optie heeft geen effect op de positie van de kolommen.';
    $Self->{Translation}->{'Determines if the statistics module may generate survey lists.'} =
        'Bepaalt of de statistische module enquêtelijsten kan genereren.';
    $Self->{Translation}->{'Edit survey general information.'} = 'Algemene enquête informatie bewerken.';
    $Self->{Translation}->{'Edit survey questions.'} = 'Bewerk enquêtevragen.';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        'Schakel het ShowVoteData-scherm in de openbare interface in of uit om gegevens van een specifiek enquêteresultaat te tonen wanneer de klant een tweede enquête probeert te beantwoorden.';
    $Self->{Translation}->{'Enable or disable the send condition check for the service.'} = 'Schakel de verzendvoorwaardecontrole voor de service in of uit.';
    $Self->{Translation}->{'Enable or disable the send condition check for the ticket type.'} =
        'Schakel de verzendvoorwaardecontrole voor het tickettype in of uit.';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        'Frontend module registratie voor enquête toevoegen in de agentinterface.';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        'Frontend module registratie voor enquête bewerking in de agentinterface.';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        'Frontend module registratie voor enquêtestatistieken in de agentinterface.';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        'Frontend module registratie voor enquêtezoom in de agentinterface.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        'Frontend module registratie voor het PublicSurvey-object in het openbare enquêtegebied.';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Als deze regex overeenkomt, wordt er geen klant enquête verzonden.';
    $Self->{Translation}->{'Limit.'} = 'Beperk.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Parameters voor de pagina\'s (waarin de enquêtes worden getoond) van het kleine enquête overzicht.';
    $Self->{Translation}->{'Public Survey.'} = 'Openbare enquête.';
    $Self->{Translation}->{'Results older than the configured amount of days will be deleted. Note: delete results done by the OTRS Daemon, prior activation of \'Task###SurveyRequestsDelete\' setting.'} =
        'Resultaten ouder dan het geconfigureerde aantal dagen worden verwijderd. Opmerking: resultaten verwijderen wordt gedaan door de OTRS Daemon, voorafgaande activering van de instelling \'Taak###SurveyRequestsDelete\'.';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        'Toont een link in het menu om een enquête te bewerken in de zoomweergave van de agentinterface.';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        'Toont een link in het menu om enquêtevragen te bewerken in de zoomweergave van de agentinterface.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        'Toont een link in het menu om terug te gaan naar de enquêtezoomweergave van de agentinterface.';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        'Toont een link in het menu om in de zoomweergave van de agentinterface in te zoomen op de details van de enquêtestatistieken.';
    $Self->{Translation}->{'Stats Details'} = 'Statistieken details';
    $Self->{Translation}->{'Survey Add Module.'} = 'Module enquête toevoegen.';
    $Self->{Translation}->{'Survey Edit Module.'} = 'Module enquête bewerken.';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Enquête overzicht "Klein" limiet';
    $Self->{Translation}->{'Survey Stats Module.'} = 'Module Enquêtestatistieken.';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Module enquêtezoom.';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small".'} = 'Enquêtelimiet per pagina voor Enquêteoverzicht "Klein".';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = 'Enquêtes worden niet verzonden naar de geconfigureerde e-mailadressen.';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'De identificatie voor een enquête, b.v. Enquête#, MijnEnquête#. De standaardwaarde is Enquête#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        'Ticket gebeurtenismodule om klanten automatisch enquêtemailverzoeken te sturen als een ticket is gesloten.';
    $Self->{Translation}->{'Trigger delete results (including vote data and requests).'} = 'Resultaten verwijderen activeren (inclusief stemgegevens en verzoeken).';
    $Self->{Translation}->{'Trigger sending delayed survey requests.'} = 'Activeer het verzenden van vertraagde enquêteaanvragen.';
    $Self->{Translation}->{'Zoom into statistics details.'} = 'Zoom in op statistische details.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Do you really want to delete this answer?',
    'Do you really want to delete this question? ALL associated data will be LOST!',
    'Settings',
    'Submit',
    );

}

1;
