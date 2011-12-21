# --
# Kernel/Language/pl_Survey.pm - translation file
# 2011-11: OTRS 3 adaptation by Informatyka Boguslawski sp. z o.o. sp.k., http://www.ib.pl/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_Survey;

use strict;

sub Data {
    my $Self = shift;

    # Template: AgentSurvey
    $Self->{Translation}->{'Create New Survey'} = 'Utwórz now± ankietê';
    $Self->{Translation}->{'Introduction'} = 'Wprowadzenie';
    $Self->{Translation}->{'Internal Description'} = 'Wewnêtrzny opis';
    $Self->{Translation}->{'Survey Edit'} = 'Edycja ankiety';
    $Self->{Translation}->{'General Info'} = 'Informacje ogólne';
    $Self->{Translation}->{'Stats Overview'} = 'Statystyka';
    $Self->{Translation}->{'Requests Table'} = 'Tabela ¿±dañ';
    $Self->{Translation}->{'Send Time'} = 'Czas wys³ania';
    $Self->{Translation}->{'Vote Time'} = 'Czas g³osowania';
    $Self->{Translation}->{'Details'} = 'Szczegó³y';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Brak pytañ zapisanych w tej ankiecie.';
    $Self->{Translation}->{'Survey Stat Details'} = 'Szczegó³y statystyki';
    $Self->{Translation}->{'go back to stats overview'} = 'Wstecz do przegl±du statystyki';
    $Self->{Translation}->{'Go Back'} = 'Wstecz';
    $Self->{Translation}->{'Change Status'} = 'Zmieñ status';
    $Self->{Translation}->{'Status changed'} = 'Status zmieniony';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Survey Edit Questions'} = 'Edycja pytañ ankiety';
    $Self->{Translation}->{'Add Question'} = 'Dodaj pytanie';
    $Self->{Translation}->{'Type the question'} = 'Wprowad¼ pytanie';
    $Self->{Translation}->{'Survey Questions'} = 'Pytania ankiety';
    $Self->{Translation}->{'Question'} = 'Pytanie';
    $Self->{Translation}->{'Edit Question'} = 'Edytuj pytanie';
    $Self->{Translation}->{'go back to questions'} = 'powrót do pytañ';
    $Self->{Translation}->{'Possible Answers For'} = 'Mo¿liwe odpowiedzi do';
    $Self->{Translation}->{'Add Answer'} = 'Dodaj odpowied¼';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} = 'Nie posiada wielu odpowiedzi, bêdzie wy¶wietlane pole tekstowe.';
    $Self->{Translation}->{'Edit Answer'} = 'Edytuj odpowied¼';
    $Self->{Translation}->{'go back to edit question'} = 'powrót do edycji pytania';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Ustawienia kontekstowe';
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Maks. liczba wy¶wietlanych ankiet na stronê';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Nadawca powiadomienia';
    $Self->{Translation}->{'Notification Subject'} = 'Temat powiadomienia';
    $Self->{Translation}->{'Notification Body'} = 'Tre¶æ powiadomienia';
    $Self->{Translation}->{'Created Time'} = 'Czas utworzenia';
    $Self->{Translation}->{'Created By'} = 'Utworzone przez';
    $Self->{Translation}->{'Changed Time'} = 'Czas zmiany';
    $Self->{Translation}->{'Changed By'} = 'Zmienione przez';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Informacje o ankiecie';
    $Self->{Translation}->{'Sent requests'} = 'Wys³ane ¿±dania';
    $Self->{Translation}->{'Received surveys'} = 'Otrzymane ankiety';
    $Self->{Translation}->{'Edit General Info'} = 'Edytuj informacje ogólne';
    $Self->{Translation}->{'Edit Questions'} = 'Edytuj pytania';
    $Self->{Translation}->{'Stats Details'} = 'Szczegó³y statystyk';
    $Self->{Translation}->{'Survey Details'} = 'Szczegó³y ankiety';
    $Self->{Translation}->{'Survey Results Graph'} = 'Wykres wyników ankiety';
    $Self->{Translation}->{'No stat results.'} = 'Brak wyników ankiety.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Ankieta';
    $Self->{Translation}->{'Please answer the next questions'} = 'Prosimy, odpowiedz na nastêpne pytania';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Modu³ ankiet.';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Ein Modul, um Umfragen zu bearbeiten';
    $Self->{Translation}->{'Days starting from the latest customer survey email between no customer survey email is sent, ( 0 means Always send it ) .'} = 'Anzahl Tage, von der letzten Umfrage-E-Mail an den Kunden, in der keine weitere Umfrage-Email an den Kunden versendet wird (0 bedeutet, dass die E-Mail immer versendet wird).';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} = 'Voreingestellter Text für Benachrichtigungs-Mails an den Kunden über neue Umfragen.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} = 'Voreingestellter Absender für Benachrichtigungs-Mails an den Kunden über neue Umfragen.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} = 'Voreingestellter Betreff für Benachrichtigungs-Mails an den Kunden über neue Umfragen.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} = 'Definiert ein Übersichts-Modul, dass eine Liste aller Umfragen anzeigt.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the column.'} = 'Definiert die angezeigten Spalten in der Umfrage-Übersicht. Die Einstellung hat keinen Effekt auf die angezeigte Reihenfolge der Spalten.';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} = 'Frontend-Modul-Registrierung für die Umfrage-Detailansicht im Agenten-Interface.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} = 'Frontend-Modul-Registrierung für die öffentliche Umfrage-Übersicht.';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Wenn dieser reguläre Ausdruck zutrifft, wird keine Umfrage an den Kunden gesendet.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} = 'Parameter für die Seiten der Umfrage-Übersicht.';
    $Self->{Translation}->{'Public Survey.'} = 'Öffentliche Umfrage.';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Umfrage-Übersicht Limit';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Modul Umfrage-Detailansicht';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = 'Umfrage-Limit pro Seite in der Umfrage-Übersicht';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} = 'Die eindeutige Bezeichnung für eine Umfrage, z. B. Survey# oder MySurvey#. Standard ist Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket gets closed.'} = 'Ticket-Event-Modul, um automatisch Umfrage-E-Mails an Kunden zu senden, when ein Ticket geschlossen wird.';

    $Self->{Translation}->{'Survey Introduction'} = 'Wstêp ankiety';
    $Self->{Translation}->{'Survey Description'} = 'Opis ankiety';
    $Self->{Translation}->{'This field is required'} = 'To pole jest wymagane';
    $Self->{Translation}->{'Complete'} = 'Kompletne';
    $Self->{Translation}->{'Incomplete'} = 'Niekompletne';
    $Self->{Translation}->{'Survey#'} = 'Ankieta#';
    $Self->{Translation}->{'Default value'} = 'Domy¶lna warto¶æ';

    $Self->{Translation}->{'Enable or disable the ShowVoteData screen on public interface to show data of an specific votation when customer tries to answer a survey by second time.'} =
        'Aktivieren oder deaktivieren des ShowVoteData screens im Public Interface, um Abstimmungs-Daten anzuzeigen, wenn ein Kunde versucht ein zweites mal abzustimmen.';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} = 'Alle Parameter für das Umfrage-Modul im Agenten-Interface.';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} = 'Definiert die  Standardhöhe eines WYSIWYG-Bereichs für die Umfrage-Detailansicht.';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
