# --
# Kernel/Language/pl_Survey.pm - translation file
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# Copyright (C) 2011-2012 Informatyka Boguslawski sp. z o.o. sp.k., http://www.ib.pl/
# --
# $Id: pl_Survey.pm,v 1.9 2012-11-20 19:11:45 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_Survey;

use utf8;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAASurvey
    $Self->{Translation}->{'- Change Status -'} = 'Zmień status';
    $Self->{Translation}->{'Add New Survey'} = 'Dodaj nową ankietę';
    $Self->{Translation}->{'Survey Edit'} = 'Edycja ankiety';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Edycja pytań ankiety';
    $Self->{Translation}->{'Question Edit'} = 'Edycja pytań';
    $Self->{Translation}->{'Answer Edit'} = 'Edycja odpowiedzi';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'Nie można zmienić statusu! Brak zdefiniowanych pytań.';
    $Self->{Translation}->{'Status changed.'} = 'Status zmieniony.';
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
    $Self->{Translation}->{'Stats Detail'} = 'Szczegóły statusu';
    $Self->{Translation}->{'You have already answered the survey.'} = 'Już odpowiedziałeś na tę ankietę.';

    # Template: AgentSurvey
    $Self->{Translation}->{'Create New Survey'} = 'Utwórz nową ankietę';
    $Self->{Translation}->{'Introduction'} = 'Wprowadzenie';
    $Self->{Translation}->{'Internal Description'} = 'Wewnętrzny opis';
    $Self->{Translation}->{'Edit General Info'} = 'Edytuj informacje ogólne';
    $Self->{Translation}->{'General Info'} = 'Informacje ogólne';
    $Self->{Translation}->{'Stats Overview of'} = 'Przegląd statystyki';
    $Self->{Translation}->{'Requests Table'} = 'Tabela żądań';
    $Self->{Translation}->{'Send Time'} = 'Czas wysłania';
    $Self->{Translation}->{'Vote Time'} = 'Czas głosowania';
    $Self->{Translation}->{'Survey Stat Details'} = 'Szczegóły statystyki';
    $Self->{Translation}->{'go back to stats overview'} = 'Wstecz do przeglądu statystyki';
    $Self->{Translation}->{'Go Back'} = 'Wstecz';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Edytuj pytania';
    $Self->{Translation}->{'Add Question'} = 'Dodaj pytanie';
    $Self->{Translation}->{'Type the question'} = 'Wprowadź pytanie';
    $Self->{Translation}->{'Survey Questions'} = 'Pytania ankiety';
    $Self->{Translation}->{'Question'} = 'Pytanie';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Brak pytań zapisanych w tej ankiecie.';
    $Self->{Translation}->{'Edit Question'} = 'Edytuj pytanie';
    $Self->{Translation}->{'go back to questions'} = 'powrót do pytań';
    $Self->{Translation}->{'Possible Answers For'} = 'Możliwe odpowiedzi do';
    $Self->{Translation}->{'Add Answer'} = 'Dodaj odpowiedź';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Nie posiada wielu odpowiedzi, będzie wyświetlane pole tekstowe.';
    $Self->{Translation}->{'Edit Answer'} = 'Edytuj odpowiedź';
    $Self->{Translation}->{'go back to edit question'} = 'powrót do edycji pytania';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Ustawienia kontekstowe';
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Maks. liczba wyświetlanych ankiet na stronę';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Nadawca powiadomienia';
    $Self->{Translation}->{'Notification Subject'} = 'Temat powiadomienia';
    $Self->{Translation}->{'Notification Body'} = 'Treść powiadomienia';
    $Self->{Translation}->{'Changed By'} = 'Zmienione przez';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Informacje o ankiecie';
    $Self->{Translation}->{'Sent requests'} = 'Wysłane żądania';
    $Self->{Translation}->{'Received surveys'} = 'Otrzymane ankiety';
    $Self->{Translation}->{'Stats Details'} = 'Szczegóły statystyk';
    $Self->{Translation}->{'Survey Details'} = 'Szczegóły ankiety';
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
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = '';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Domyślny temat informacji o nowej ankiete.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Defniuje moduł przeglądu wyświetlania list ankiet.';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        'Definiuje maksymalną liczbę ankiet wysyłaniu do Klienta w ciągu 30 dni. (0 oznacza brak ograniczenia, wszystkie żądania będą wysyłane).';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ).'} =
        'Ustala liczbę godzin które muszą minąć od zamknięcia zgłoszenia do wysłania ankiety (0 oznacza bezzwłoczną wysyłkę przy zamykaniu zgłoszenia).';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        'Definiuje domyślną wysokość widoków Richtext dla elementów SurveyZoom.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        'Definiuje widoczne kolumny w przeglądzie ankiet. Ta opcja nie wpływa na pozycję kolumn.';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        'Włącz lub wyłącz ekran ShowVoteData w interfejsie publicznym aby pokazać wyniki ankiety gdy klient próbuje odpowiedzieć na akietę drugi raz.';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        'Moduł frontend rejestrujący podgląd ankiet w panelu agenta.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        'Moduł frontend rejestrujący obiekt PublicSurvey w obszarze publicznym ankiety.';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Gdy to wyrażenie regularne jest spełnione, nie zostanie wysłana żadna ankieta do klienta.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Parametry dla stron (na których pokazywane są ankiety) dla małego przeglądu ankiet.';
    $Self->{Translation}->{'Public Survey.'} = 'Ankieta publiczna.';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Limit "małego" przeglądu ankiet';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Podgląd ankiety.';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = 'Limit ilości ankiet w "małym" przeglądzie';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'Identyfikacja dla ankiety, np. Survey#, MySurvey#. Domyślnie: Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        'Zdarzenie zgłoszenia wysyła automatycznie e-maila z prośbą o wypełnienie ankiety po zamknięciu zgłoszenia.';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Change Status'} = 'Zmień status';
    $Self->{Translation}->{'Changed Time'} = 'Czas zmiany';
    $Self->{Translation}->{'Created By'} = 'Utworzone przez';
    $Self->{Translation}->{'Created Time'} = 'Czas utworzenia';
    $Self->{Translation}->{'Days starting from the latest customer survey email between no customer survey email is sent, ( 0 means Always send it ) .'} =
        'Liczba dni bez wysyłania żądań wypełnienia ankiety do klienta, począwszy od ostatniej takiej wysyłki do tego klienta (0 oznacza wysyłanie za każdym razem).';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the column.'} =
        'Definiuje widoczne kolumny w przeglądzie ankiet. Ta opcja nie wpływa na pozycję kolumn.';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen on public interface to show data of an specific votation when customer tries to answer a survey by second time.'} =
        'Włącz lub wyłącz ekran ShowVoteData w interfejsie publicznym aby pokazać wyniki ankiety gdy klient próbuje odpowiedzieć na akietę drugi raz.';
    $Self->{Translation}->{'Please answer the next questions'} = 'Prosimy, odpowiedz na nastêpne pytania';
    $Self->{Translation}->{'Status changed'} = 'Status zmieniony';
    $Self->{Translation}->{'Survey#'} = 'Ankieta#';
    $Self->{Translation}->{'This field is required'} = 'To pole jest wymagane';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket gets closed.'} =
        'Moduł zdarzeniowy zgłoszenia do automatycznego wysyłania żądań e-mail wypełnienia ankiety do klientów, przy zamknięciu zgłoszenia.';

}

1;
