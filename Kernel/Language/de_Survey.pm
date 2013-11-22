# --
# Kernel/Language/de_Survey.pm - translation file
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_Survey;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAASurvey
    $Self->{Translation}->{'- Change Status -'} = '- Status Ändern -';
    $Self->{Translation}->{'Add New Survey'} = 'Neue Umfrage hinzufügen';
    $Self->{Translation}->{'Survey Edit'} = 'Umfrage bearbeiten';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Fragen der Umfrage bearbeiten';
    $Self->{Translation}->{'Question Edit'} = 'Frage bearbeiten';
    $Self->{Translation}->{'Answer Edit'} = 'Antwort bearbeiten';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'Status konnte nicht gesetzt werden! Keine Fragen definiert.';
    $Self->{Translation}->{'Status changed.'} = 'Status geändert.';
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Danke für Ihr Feedback.';
    $Self->{Translation}->{'The survey is finished.'} = 'Die Umfrage ist beendet.';
    $Self->{Translation}->{'Complete'} = 'Vollständig';
    $Self->{Translation}->{'Incomplete'} = 'Unvollständig';
    $Self->{Translation}->{'Checkbox (List)'} = 'Kontrollkästchen (Liste)';
    $Self->{Translation}->{'Radio'} = 'Optionsschalter';
    $Self->{Translation}->{'Radio (List)'} = 'Optionsschalter (Liste)';
    $Self->{Translation}->{'Stats Overview'} = 'Statistik Übersicht';
    $Self->{Translation}->{'Survey Description'} = 'Umfrage Beschreibung';
    $Self->{Translation}->{'Survey Introduction'} = 'Umfrage Einleitung';
    $Self->{Translation}->{'Yes/No'} = 'Ja/Nein';
    $Self->{Translation}->{'YesNo'} = 'JaNein';
    $Self->{Translation}->{'answered'} = 'beantwortet';
    $Self->{Translation}->{'not answered'} = 'nicht beantwortet';
    $Self->{Translation}->{'Stats Detail'} = 'Statistik Detail';
    $Self->{Translation}->{'You have already answered the survey.'} = 'Sie haben die Umfrage schon beantwortet.';

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Neue Umfrage erstellen';
    $Self->{Translation}->{'Introduction'} = 'Einleitungstext';
    $Self->{Translation}->{'Internal Description'} = 'Interne Beschreibung';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Allgemeine Angaben bearbeiten';
    $Self->{Translation}->{'Survey#'} = 'Umfrage#';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Fragen bearbeiten';
    $Self->{Translation}->{'Add Question'} = 'Frage hinzufügen';
    $Self->{Translation}->{'Type the question'} = 'Frage eingeben';
    $Self->{Translation}->{'Answer required'} = 'Antwort erforderlich';
    $Self->{Translation}->{'Survey Questions'} = 'Umfrage-Fragen';
    $Self->{Translation}->{'Question'} = 'Frage';
    $Self->{Translation}->{'Answer Required'} = '';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Für diese Umfrage sind keine Fragen gespeichert.';
    $Self->{Translation}->{'Edit Question'} = 'Frage bearbeiten';
    $Self->{Translation}->{'go back to questions'} = 'Zurück zu den Fragen';
    $Self->{Translation}->{'Possible Answers For'} = 'Mögliche Antworten für';
    $Self->{Translation}->{'Add Answer'} = 'Antwort hinzufügen';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Diese Frage hat nicht mehrere Antworten, ein Texteingabefeld wird hinzugefügt.';
    $Self->{Translation}->{'Go back'} = 'Zurück';
    $Self->{Translation}->{'Edit Answer'} = 'Antwort bearbeiten';
    $Self->{Translation}->{'go back to edit question'} = 'Zurück zum Bearbeiten der Frage';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Kontext-Einstellungen';
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Maximale Anzahl angezeigter Umfragen pro Seite';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Benachrichtigung Absender';
    $Self->{Translation}->{'Notification Subject'} = 'Benachrichtigung Betreff';
    $Self->{Translation}->{'Notification Body'} = 'Benachrichtigung Text';
    $Self->{Translation}->{'Changed By'} = 'Geändert von';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = 'Statistik Übersicht von';
    $Self->{Translation}->{'Requests Table'} = 'Anfragen-Tabelle';
    $Self->{Translation}->{'Send Time'} = 'Sendezeit';
    $Self->{Translation}->{'Vote Time'} = 'Abstimmungszeit';
    $Self->{Translation}->{'Survey Stat Details'} = 'Details Umfragestatistik';
    $Self->{Translation}->{'go back to stats overview'} = 'Zurück zur Übersicht';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Umfrage-Informationen';
    $Self->{Translation}->{'Sent requests'} = 'Gesendete Anfragen';
    $Self->{Translation}->{'Received surveys'} = 'Erhaltene Umfragen';
    $Self->{Translation}->{'Survey Details'} = 'Umfrage-Details';
    $Self->{Translation}->{'Survey Results Graph'} = 'Grafik Umfrageergebnisse';
    $Self->{Translation}->{'No stat results.'} = 'Keine Statistik-Ergebnisse.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Umfrage';
    $Self->{Translation}->{'Please answer these questions'} = 'Bitte beantworten Sie diese Fragen';
    $Self->{Translation}->{'Show my answers'} = 'Zeige meine Antworten';
    $Self->{Translation}->{'These are your answers'} = 'Dies sind Ihre Antworten';
    $Self->{Translation}->{'Survey Title'} = 'Umfrage Titel';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Ein Umfrage-Modul';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Ein Modul, um Umfragen zu bearbeiten';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        'Alle Parameter für das Umfrage-Modul im Agenten-Interface.';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        'Anzahl an Tagen nach dem Versand eines Umfrage Mails in denen kein neues Umfrage Mail an den gleichen Kunden versendet wird. Wählen sie 0 um immer Umfrage Mails zu versenden.';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Voreingestellter Text für Benachrichtigungs-Mails an den Kunden über neue Umfragen.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Voreingestellter Absender für Benachrichtigungs-Mails an den Kunden über neue Umfragen.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Voreingestellter Betreff für Benachrichtigungs-Mails an den Kunden über neue Umfragen.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Definiert ein Übersichts-Modul, dass eine Liste aller Umfragen anzeigt.';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        'Definiert die maximale Anzahl von Umfragen die ein Kunde innerhalb von 30 Tagen zugesandt bekommt. ( 0 steht für kein Maximum, alle Umfrage Mails werden versandt.)';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ).'} =
        'Definiert die Anzahl an Stunden für die ein Ticket geschlossen sein muss um den Versand einer Umfrage auszulösen ( 0 bedeutet, dass Umfrage sofort nach Schließen eines Tickets versandt wird ).';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        'Definiert die  Standardhöhe eines WYSIWYG-Bereichs für die Umfrage-Detailansicht.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        'Definiert die angezeigten Spalten der Umfrage Übersicht. Diese Option hat keine Auswirkung auf die Position der Spalten.';
    $Self->{Translation}->{'Edit Survey General Information'} = '';
    $Self->{Translation}->{'Edit Survey Questions'} = '';
    $Self->{Translation}->{'Enable or disable the send condition check for the service.'} = 'Aktivieren oder deaktivieren der Versandbedingungs-Prüfung für Services.';
    $Self->{Translation}->{'Enable or disable the send condition check for the ticket type.'} = 'Aktivieren oder deaktivieren der Versandbedingungs-Prüfung für Ticket Typen.';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        'Aktivieren oder deaktivieren die ShowVoteData screens im Public Interface, um Abstimmungs-Daten anzuzeigen, wen ein Kunde versucht, ein zweites mal abzustimmen.';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        'Frontend-Modul-Registrierung für die Umfrage-Detailansicht im Agenten-Interface.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        'Frontend-Modul-Registrierung für die öffentliche Umfrage-Übersicht.';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Wenn dieser reguläre Ausdruck zutrifft, wird keine Umfrage an den Kunden gesendet.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Parameter für die Seiten der Umfrage-Übersicht.';
    $Self->{Translation}->{'Public Survey.'} = 'Öffentliche Umfrage.';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Survey Edit Module.'} = '';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Umfrage-Übersicht Limit';
    $Self->{Translation}->{'Survey Stats Module.'} = '';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Modul Umfrage-Detailansicht';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = 'Umfrage-Limit pro Seite in der Umfrage-Übersicht';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = 'Umfragen werden nicht an die konfigurierten E-Mail-Adressen gesendet.';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'Die eindeutige Bezeichnung für eine Umfrage, z. B. Survey# oder MySurvey#. Standard ist Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        'Ticket-Event-Modul, um automatisch Umfrage-E-Mails an Kunden zu senden, wenn ein Ticket geschlossen wird.';
    $Self->{Translation}->{'Zoom Into Statistics Details'} = '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Changed Time'} = 'Änderungs-Zeitpunkt';
    $Self->{Translation}->{'Created By'} = 'Erstellt von';
    $Self->{Translation}->{'Created Time'} = 'Erstell-Zeitpunkt';
    $Self->{Translation}->{'Days starting from the latest customer survey email between no customer survey email is sent, ( 0 means Always send it ) .'} =
        'Anzahl Tage, von der letzten Umfrage-E-Mail an den Kunden, in der keine weitere Umfrage-Email an den Kunden versendet wird (0 bedeutet, dass die E-Mail immer versendet wird).';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days, ( 0 means send immediately after close ).'} =
        'Definiert die maximale Anzahl an Umfragen die ein Kunde pro 30 Tage erhält  ( 0 bedeutet kein Limit, alle Umfrageanfragen werden gesendet ).';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Spalten in der Umfrage-Übersicht. Die Einstellung hat keinen Effekt auf die angezeigte Reihenfolge der Spalten.';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen on public interface to show data of an specific votation when customer tries to answer a survey by second time.'} =
        'Aktivieren oder deaktivieren des ShowVoteData screens im Public Interface, um Abstimmungs-Daten anzuzeigen, wenn ein Kunde versucht ein zweites mal abzustimmen.';
    $Self->{Translation}->{'General Info'} = 'Allgemeine Angaben';
    $Self->{Translation}->{'Please answer the next questions'} = 'Bitte beantworten Sie die folgenden Fragen';
    $Self->{Translation}->{'Stats Details'} = 'Statistik-Details';
    $Self->{Translation}->{'This field is required'} = 'Dieses Feld wird benötigt';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket gets closed.'} =
        'Ticket-Event-Modul, um automatisch Umfrage-E-Mails an Kunden zu senden, when ein Ticket geschlossen wird.';

}

1;
