# --
# Kernel/Language/pl_Survey.pm - translation file
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: pl_Survey.pm,v 1.3 2012-02-22 10:59:11 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_Survey;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAASurvey
    $Self->{Translation}->{'- Change Status -'} = '';
    $Self->{Translation}->{'Add New Survey'} = '';
    $Self->{Translation}->{'Survey Edit'} = 'Edycja ankiety';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Edycja pytañ ankiety';
    $Self->{Translation}->{'Question Edit'} = '';
    $Self->{Translation}->{'Answer Edit'} = '';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = '';
    $Self->{Translation}->{'Status changed.'} = '';
    $Self->{Translation}->{'Thank you for your feedback.'} = '';
    $Self->{Translation}->{'The survey is finished.'} = '';
    $Self->{Translation}->{'Complete'} = 'Kompletne';
    $Self->{Translation}->{'Incomplete'} = 'Niekompletne';
    $Self->{Translation}->{'Checkbox (List)'} = '';
    $Self->{Translation}->{'Radio'} = '';
    $Self->{Translation}->{'Radio (List)'} = '';
    $Self->{Translation}->{'Stats Overview'} = 'Statystyka';
    $Self->{Translation}->{'Survey Description'} = 'Opis ankiety';
    $Self->{Translation}->{'Survey Introduction'} = 'Wstêp ankiety';
    $Self->{Translation}->{'Yes/No'} = '';
    $Self->{Translation}->{'YesNo'} = '';
    $Self->{Translation}->{'answered'} = '';
    $Self->{Translation}->{'not answered'} = '';
    $Self->{Translation}->{'Stats Detail'} = '';
    $Self->{Translation}->{'You have already answered the survey.'} = '';

    # Template: AgentSurvey
    $Self->{Translation}->{'Create New Survey'} = 'Utwórz now± ankietê';
    $Self->{Translation}->{'Introduction'} = 'Wprowadzenie';
    $Self->{Translation}->{'Internal Description'} = 'Wewnêtrzny opis';
    $Self->{Translation}->{'Edit General Info'} = 'Edytuj informacje ogólne';
    $Self->{Translation}->{'General Info'} = 'Informacje ogólne';
    $Self->{Translation}->{'Stats Overview of'} = '';
    $Self->{Translation}->{'Requests Table'} = 'Tabela ¿±dañ';
    $Self->{Translation}->{'Send Time'} = 'Czas wys³ania';
    $Self->{Translation}->{'Vote Time'} = 'Czas g³osowania';
    $Self->{Translation}->{'Survey Stat Details'} = 'Szczegó³y statystyki';
    $Self->{Translation}->{'go back to stats overview'} = 'Wstecz do przegl±du statystyki';
    $Self->{Translation}->{'Go Back'} = 'Wstecz';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Edytuj pytania';
    $Self->{Translation}->{'Add Question'} = 'Dodaj pytanie';
    $Self->{Translation}->{'Type the question'} = 'WprowadŒ pytanie';
    $Self->{Translation}->{'Survey Questions'} = 'Pytania ankiety';
    $Self->{Translation}->{'Question'} = 'Pytanie';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Brak pytañ zapisanych w tej ankiecie.';
    $Self->{Translation}->{'Edit Question'} = 'Edytuj pytanie';
    $Self->{Translation}->{'go back to questions'} = 'powrót do pytañ';
    $Self->{Translation}->{'Possible Answers For'} = 'Mo¿liwe odpowiedzi do';
    $Self->{Translation}->{'Add Answer'} = 'Dodaj odpowiedŒ';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Nie posiada wielu odpowiedzi, bêdzie wy¶wietlane pole tekstowe.';
    $Self->{Translation}->{'Edit Answer'} = 'Edytuj odpowiedŒ';
    $Self->{Translation}->{'go back to edit question'} = 'powrót do edycji pytania';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Ustawienia kontekstowe';
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Maks. liczba wy¶wietlanych ankiet na stronê';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Nadawca powiadomienia';
    $Self->{Translation}->{'Notification Subject'} = 'Temat powiadomienia';
    $Self->{Translation}->{'Notification Body'} = 'Tre¶æ powiadomienia';
    $Self->{Translation}->{'Changed By'} = 'Zmienione przez';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Informacje o ankiecie';
    $Self->{Translation}->{'Sent requests'} = 'Wys³ane ¿±dania';
    $Self->{Translation}->{'Received surveys'} = 'Otrzymane ankiety';
    $Self->{Translation}->{'Stats Details'} = 'Szczegó³y statystyk';
    $Self->{Translation}->{'Survey Details'} = 'Szczegó³y ankiety';
    $Self->{Translation}->{'Survey Results Graph'} = 'Wykres wyników ankiety';
    $Self->{Translation}->{'No stat results.'} = 'Brak wyników ankiety.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Ankieta';
    $Self->{Translation}->{'Please answer these questions'} = '';
    $Self->{Translation}->{'Show my answers'} = '';
    $Self->{Translation}->{'These are your answers'} = '';
    $Self->{Translation}->{'Survey Title'} = '';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Modu³ ankiet.';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Ein Modul, um Umfragen zu bearbeiten';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        'Alle Parameter für das Umfrage-Modul im Agenten-Interface.';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        '';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Voreingestellter Text für Benachrichtigungs-Mails an den Kunden über neue Umfragen.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Voreingestellter Absender für Benachrichtigungs-Mails an den Kunden über neue Umfragen.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Voreingestellter Betreff für Benachrichtigungs-Mails an den Kunden über neue Umfragen.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Definiert ein Übersichts-Modul, dass eine Liste aller Umfragen anzeigt.';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        '';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ).'} =
        '';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        'Definiert die  Standardhöhe eines WYSIWYG-Bereichs für die Umfrage-Detailansicht.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        '';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        'Frontend-Modul-Registrierung für die Umfrage-Detailansicht im Agenten-Interface.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        'Frontend-Modul-Registrierung für die öffentliche Umfrage-Übersicht.';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Wenn dieser reguläre Ausdruck zutrifft, wird keine Umfrage an den Kunden gesendet.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Parameter für die Seiten der Umfrage-Übersicht.';
    $Self->{Translation}->{'Public Survey.'} = 'Öffentliche Umfrage.';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Umfrage-Übersicht Limit';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Modul Umfrage-Detailansicht';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = 'Umfrage-Limit pro Seite in der Umfrage-Übersicht';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'Die eindeutige Bezeichnung für eine Umfrage, z. B. Survey# oder MySurvey#. Standard ist Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Change Status'} = 'Zmieñ status';
    $Self->{Translation}->{'Changed Time'} = 'Czas zmiany';
    $Self->{Translation}->{'Created By'} = 'Utworzone przez';
    $Self->{Translation}->{'Created Time'} = 'Czas utworzenia';
    $Self->{Translation}->{'Days starting from the latest customer survey email between no customer survey email is sent, ( 0 means Always send it ) .'} =
        'Anzahl Tage, von der letzten Umfrage-E-Mail an den Kunden, in der keine weitere Umfrage-Email an den Kunden versendet wird (0 bedeutet, dass die E-Mail immer versendet wird).';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Spalten in der Umfrage-Übersicht. Die Einstellung hat keinen Effekt auf die angezeigte Reihenfolge der Spalten.';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen on public interface to show data of an specific votation when customer tries to answer a survey by second time.'} =
        'Aktivieren oder deaktivieren des ShowVoteData screens im Public Interface, um Abstimmungs-Daten anzuzeigen, wenn ein Kunde versucht ein zweites mal abzustimmen.';
    $Self->{Translation}->{'Please answer the next questions'} = 'Prosimy, odpowiedz na nastêpne pytania';
    $Self->{Translation}->{'Status changed'} = 'Status zmieniony';
    $Self->{Translation}->{'Survey#'} = 'Ankieta#';
    $Self->{Translation}->{'This field is required'} = 'To pole jest wymagane';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket gets closed.'} =
        'Ticket-Event-Modul, um automatisch Umfrage-E-Mails an Kunden zu senden, when ein Ticket geschlossen wird.';

}

1;
