# --
# Kernel/Language/de_Survey.pm - translation file
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: de_Survey.pm,v 1.9 2012-01-21 20:56:31 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_Survey;

use strict;

sub Data {
    my $Self = shift;

    # Template: AgentSurvey
    $Self->{Translation}->{'Create New Survey'} = 'Neue Umfrage erstellen';
    $Self->{Translation}->{'Introduction'} = 'Einleitungstext';
    $Self->{Translation}->{'Internal Description'} = 'Interne Beschreibung';
    $Self->{Translation}->{'Survey Edit'} = 'Umfrage bearbeiten';
    $Self->{Translation}->{'General Info'} = 'Allgemeine Angaben';
    $Self->{Translation}->{'Stats Overview'} = 'Statistik-Übersicht';
    $Self->{Translation}->{'Requests Table'} = 'Anfragen-Tabelle';
    $Self->{Translation}->{'Send Time'} = 'Sendezeit';
    $Self->{Translation}->{'Vote Time'} = 'Abstimmungszeit';
    $Self->{Translation}->{'Details'} = 'Details';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Für diese Umfrage sind keine Fragen gespeichert.';
    $Self->{Translation}->{'Survey Stat Details'} = 'Details Umfragestatistik';
    $Self->{Translation}->{'go back to stats overview'} = 'Zurück zur Übersicht';
    $Self->{Translation}->{'Go Back'} = 'Zurück';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Survey Edit Questions'} = 'Fragen bearbeiten';
    $Self->{Translation}->{'Add Question'} = 'Frage hinzufügen';
    $Self->{Translation}->{'Type the question'} = 'Frage eingeben';
    $Self->{Translation}->{'Survey Questions'} = 'Umfrage-Fragen';
    $Self->{Translation}->{'Question'} = 'Frage';
    $Self->{Translation}->{'Edit Question'} = 'Frage bearbeiten';
    $Self->{Translation}->{'go back to questions'} = 'Zurück zu den Fragen';
    $Self->{Translation}->{'Possible Answers For'} = 'Mögliche Antworten für';
    $Self->{Translation}->{'Add Answer'} = 'Antwort hinzufügen';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} = 'Diese Frage hat nicht mehrere Antworten, ein Texteingabefeld wird hinzugefügt.';
    $Self->{Translation}->{'Edit Answer'} = 'Antwort bearbeiten';
    $Self->{Translation}->{'go back to edit question'} = 'Zurück zum Bearbeiten der Frage';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Kontext-Einstellungen';
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Maximale Anzahl angezeigter Umfragen pro Seite';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Benachrichtigung Absender';
    $Self->{Translation}->{'Notification Subject'} = 'Benachrichtigung Betreff';
    $Self->{Translation}->{'Notification Body'} = 'Benachrichtigung Text';
    $Self->{Translation}->{'Created Time'} = 'Erstell-Zeitpunkt';
    $Self->{Translation}->{'Created By'} = 'Erstellt von';
    $Self->{Translation}->{'Changed Time'} = 'Änderungs-Zeitpunkt';
    $Self->{Translation}->{'Changed By'} = 'Geändert von';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Umfrage-Informationen';
    $Self->{Translation}->{'Sent requests'} = 'Gesendete Anfragen';
    $Self->{Translation}->{'Received surveys'} = 'Erhaltene Umfragen';
    $Self->{Translation}->{'Edit General Info'} = 'Allgemeine Angaben bearbeiten';
    $Self->{Translation}->{'Edit Questions'} = 'Fragen bearbeiten';
    $Self->{Translation}->{'Stats Details'} = 'Statistik-Details';
    $Self->{Translation}->{'Survey Details'} = 'Umfrage-Details';
    $Self->{Translation}->{'Survey Results Graph'} = 'Grafik Umfrageergebnisse';
    $Self->{Translation}->{'No stat results.'} = 'Keine Statistik-Ergebnisse.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Umfrage';
    $Self->{Translation}->{'Please answer the next questions'} = 'Bitte beantworten Sie die folgenden Fragen';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Ein Umfrage-Modul';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Ein Modul, um Umfragen zu bearbeiten';
    $Self->{Translation}->{'Days starting from the latest customer survey email between no customer survey email is sent, ( 0 means Always send it ) .'} = 'Anzahl Tage, von der letzten Umfrage-E-Mail an den Kunden, in der keine weitere Umfrage-Email an den Kunden versendet wird (0 bedeutet, dass die E-Mail immer versendet wird).';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} = 'Voreingestellter Text für Benachrichtigungs-Mails an den Kunden über neue Umfragen.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} = 'Voreingestellter Absender für Benachrichtigungs-Mails an den Kunden über neue Umfragen.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} = 'Voreingestellter Betreff für Benachrichtigungs-Mails an den Kunden über neue Umfragen.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} = 'Definiert ein Übersichts-Modul, dass eine Liste aller Umfragen anzeigt.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the column.'} = 'Definiert die angezeigten Spalten in der Umfrage-Übersicht. Die Einstellung hat keinen Effekt auf die angezeigte Reihenfolge der Spalten.';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} = 'Alle Parameter des Befragungs-Objekts im Agent-Interface.';
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
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ).'} = 'Definiert die Anzahl an Stunden für die ein Ticket geschlossen sein muss um den Versand einer Umfrage auszulösen ( 0 bedeutet, dass Umfrage sofort nach Schließen eines Tickets versandt wird ).';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days, ( 0 means send immediately after close ).'} = 'Definiert die maximale Anzahl an Umfragen die ein Kunde pro 30 Tage erhält  ( 0 bedeutet kein Limit, alle Umfrageanfragen werden gesendet ).';

    $Self->{Translation}->{'Survey Introduction'} = 'Umfrage-Einleitung';
    $Self->{Translation}->{'Survey Description'} = 'Umfrage-Beschreibung';
    $Self->{Translation}->{'This field is required'} = 'Dieses Feld wird benötigt';
    $Self->{Translation}->{'Complete'} = 'Vollständig';
    $Self->{Translation}->{'Incomplete'} = 'Unvollständig';
    $Self->{Translation}->{'Survey#'} = 'Umfrage#';
    $Self->{Translation}->{'Default value'} = 'Standardwert';

    $Self->{Translation}->{'Enable or disable the ShowVoteData screen on public interface to show data of an specific votation when customer tries to answer a survey by second time.'} =
        'Aktivieren oder deaktivieren des ShowVoteData screens im Public Interface, um Abstimmungs-Daten anzuzeigen, wenn ein Kunde versucht ein zweites mal abzustimmen.';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} = 'Alle Parameter für das Umfrage-Modul im Agenten-Interface.';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} = 'Definiert die  Standardhöhe eines WYSIWYG-Bereichs für die Umfrage-Detailansicht.';

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
    $Self->{Translation}->{'Checkbox'} = 'Kontrollkästchen';
    $Self->{Translation}->{'Checkbox (List)'} = 'Kontrollkästchen (Liste)';
    $Self->{Translation}->{'Radio'} = 'Optionsschalter';
    $Self->{Translation}->{'Radio (List)'} = 'Optionsschalter (Liste)';
    $Self->{Translation}->{'Stats Overview'} = 'Statistik Übersicht';
    $Self->{Translation}->{'Survey Description'} = 'Umfrage Beschreibung';
    $Self->{Translation}->{'Survey Introduction'} = 'Umfrage Einleitung';
    $Self->{Translation}->{'Textarea'} = 'Textbereich';
    $Self->{Translation}->{'Yes/No'} = 'Ja/Nein';
    $Self->{Translation}->{'YesNo'} = 'JaNein';
    $Self->{Translation}->{'answered'} = 'beantwortet';
    $Self->{Translation}->{'not answered'} = 'nicht beantwortet';
    $Self->{Translation}->{'Stats Detail'} = 'Statistik Detail';
    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
