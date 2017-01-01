# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_Survey;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAASurvey
    $Self->{Translation}->{'- Change Status -'} = '- Zmień stan -';
    $Self->{Translation}->{'Add New Survey'} = 'Dodaj nową ankietę';
    $Self->{Translation}->{'Survey Edit'} = 'Edycja ankiety';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Edycja pytań ankiety';
    $Self->{Translation}->{'Question Edit'} = 'Edycja pytań';
    $Self->{Translation}->{'Answer Edit'} = 'Edycja odpowiedzi';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'Nie można zmienić stanu! Brak zdefiniowanych pytań.';
    $Self->{Translation}->{'Status changed.'} = 'Zmieniono stan.';
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Dziękujęmy za wypełnienie ankiety.';
    $Self->{Translation}->{'The survey is finished.'} = 'Ankieta zakończona.';
    $Self->{Translation}->{'Complete'} = 'Kompletne';
    $Self->{Translation}->{'Incomplete'} = 'Niekompletne';
    $Self->{Translation}->{'Checkbox (List)'} = '';
    $Self->{Translation}->{'Radio'} = '';
    $Self->{Translation}->{'Radio (List)'} = '';
    $Self->{Translation}->{'Stats Overview'} = 'Statystyka';
    $Self->{Translation}->{'Survey Description'} = 'Opis ankiety';
    $Self->{Translation}->{'Survey Introduction'} = 'Wstęp ankiety';
    $Self->{Translation}->{'Yes/No'} = 'Tak/Nie';
    $Self->{Translation}->{'YesNo'} = 'TakNie';
    $Self->{Translation}->{'answered'} = 'odpowiedziano';
    $Self->{Translation}->{'not answered'} = 'nie odpowiedziano';
    $Self->{Translation}->{'Stats Detail'} = 'Szczegóły stanu';
    $Self->{Translation}->{'Stats Details'} = '';
    $Self->{Translation}->{'You have already answered the survey.'} = 'Już odpowiedziałeś na tę ankietę.';
    $Self->{Translation}->{'Survey#'} = 'Ankieta#';
    $Self->{Translation}->{'- No queue selected -'} = '';
    $Self->{Translation}->{'Master'} = '';
    $Self->{Translation}->{'New Status'} = 'Nowy stan';
    $Self->{Translation}->{'Question Type'} = '';

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Utwórz nową ankietę';
    $Self->{Translation}->{'Introduction'} = 'Wprowadzenie';
    $Self->{Translation}->{'Internal Description'} = 'Wewnętrzny opis';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Edytuj informacje ogólne';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Edytuj pytania';
    $Self->{Translation}->{'Survey Questions'} = 'Pytania ankiety';
    $Self->{Translation}->{'Add Question'} = 'Dodaj pytanie';
    $Self->{Translation}->{'Type the question'} = 'Wprowadź pytanie';
    $Self->{Translation}->{'Answer required'} = '';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Brak pytań zapisanych w tej ankiecie.';
    $Self->{Translation}->{'Question'} = 'Pytanie';
    $Self->{Translation}->{'Answer Required'} = '';
    $Self->{Translation}->{'When you finish to edit the survey questions just close this screen.'} =
        '';
    $Self->{Translation}->{'Do you really want to delete this question? ALL associated data will be LOST!'} =
        '';
    $Self->{Translation}->{'Edit Question'} = 'Edytuj pytanie';
    $Self->{Translation}->{'go back to questions'} = 'powrót do pytań';
    $Self->{Translation}->{'Question:'} = '';
    $Self->{Translation}->{'Possible Answers For'} = 'Możliwe odpowiedzi do';
    $Self->{Translation}->{'Add Answer'} = 'Dodaj odpowiedź';
    $Self->{Translation}->{'No answers saved for this question.'} = '';
    $Self->{Translation}->{'Do you really want to delete this answer?'} = '';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Nie posiada wielu odpowiedzi, będzie wyświetlane pole tekstowe.';
    $Self->{Translation}->{'Edit Answer'} = 'Edytuj odpowiedź';
    $Self->{Translation}->{'go back to edit question'} = 'powrót do edycji pytania';
    $Self->{Translation}->{'Answer:'} = '';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Max. shown surveys per page'} = '';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Nadawca powiadomienia';
    $Self->{Translation}->{'Notification Subject'} = 'Temat powiadomienia';
    $Self->{Translation}->{'Notification Body'} = 'Treść powiadomienia';
    $Self->{Translation}->{'Changed By'} = 'Zmienione przez';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = 'Przegląd statystyki';
    $Self->{Translation}->{'Requests Table'} = 'Tabela żądań';
    $Self->{Translation}->{'Send Time'} = 'Czas wysłania';
    $Self->{Translation}->{'Vote Time'} = 'Czas głosowania';
    $Self->{Translation}->{'See Details'} = '';
    $Self->{Translation}->{'Survey Stat Details'} = 'Szczegóły statystyki';
    $Self->{Translation}->{'go back to stats overview'} = 'Wstecz do przeglądu statystyki';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Informacje o ankiecie';
    $Self->{Translation}->{'Sent requests'} = 'Wysłane żądania';
    $Self->{Translation}->{'Received surveys'} = 'Otrzymane ankiety';
    $Self->{Translation}->{'Survey Details'} = 'Szczegóły ankiety';
    $Self->{Translation}->{'Ticket Services'} = '';
    $Self->{Translation}->{'Survey Results Graph'} = 'Wykres wyników ankiety';
    $Self->{Translation}->{'No stat results.'} = 'Brak wyników ankiety.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Ankieta';
    $Self->{Translation}->{'Please answer these questions'} = 'Proszę odpowiedzieć na te pytania';
    $Self->{Translation}->{'Show my answers'} = 'Pokaż moje odpowiedzi';
    $Self->{Translation}->{'These are your answers'} = 'Oto Twoje odpowiedzi';
    $Self->{Translation}->{'Survey Title'} = 'Tytuł ankiety';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Moduł ankiet.';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Moduł do edycji pytań ankiet';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        'Wszystkie parametry dla ankiet w interfejsie agenta.';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        'Liczba dni po których nastąpi wysłanie żądania wypełnienia ankiety. Wprowadzenie "0" spowoduje wysłanie e-maila zawsze.';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Domyślna budowa informacji dl użytkownika odnośnie nowej ankiety.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Domyślny nadawca informacji o nowej ankiecie.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Domyślny temat informacji o nowej ankiete.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Defniuje moduł przeglądu wyświetlania list ankiet.';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        'Definiuje maksymalną liczbę ankiet wysyłaniu do Klienta w ciągu 30 dni. (0 oznacza brak ograniczenia, wszystkie żądania będą wysyłane).';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ). Note: delayed survey sending is done by the OTRS Daemon, prior activation of \'Daemon::SchedulerCronTaskManager::Task###SurveyRequestsSend\' setting.'} =
        '';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        'Definiuje domyślną wysokość widoków Richtext dla elementów SurveyZoom.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        'Definiuje widoczne kolumny w przeglądzie ankiet. Ta opcja nie wpływa na pozycję kolumn.';
    $Self->{Translation}->{'Edit Survey General Information'} = '';
    $Self->{Translation}->{'Edit Survey Questions'} = '';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        'Włącz lub wyłącz ekran ShowVoteData w interfejsie publicznym aby pokazać wyniki ankiety gdy klient próbuje odpowiedzieć na akietę drugi raz.';
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
        'Moduł frontend rejestrujący podgląd ankiet w panelu agenta.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        'Moduł frontend rejestrujący obiekt PublicSurvey w obszarze publicznym ankiety.';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Gdy to wyrażenie regularne jest spełnione, nie zostanie wysłana żadna ankieta do klienta.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Parametry dla stron (na których pokazywane są ankiety) dla małego przeglądu ankiet.';
    $Self->{Translation}->{'Public Survey.'} = 'Ankieta publiczna.';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Survey Add Module.'} = '';
    $Self->{Translation}->{'Survey Edit Module.'} = '';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Limit "małego" przeglądu ankiet';
    $Self->{Translation}->{'Survey Stats Module.'} = '';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Podgląd ankiety.';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = 'Limit ilości ankiet w "małym" przeglądzie';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = '';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'Identyfikacja dla ankiety, np. Survey#, MySurvey#. Domyślnie: Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        'Zdarzenie zgłoszenia wysyła automatycznie e-maila z prośbą o wypełnienie ankiety po zamknięciu zgłoszenia.';
    $Self->{Translation}->{'Trigger sending delayed survey requests.'} = '';
    $Self->{Translation}->{'Zoom Into Statistics Details'} = '';

}

1;
