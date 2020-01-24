# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::de_Survey;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Neue Umfrage erstellen';
    $Self->{Translation}->{'Introduction'} = 'Einleitungstext';
    $Self->{Translation}->{'Survey Introduction'} = 'Umfrage Einleitung';
    $Self->{Translation}->{'Notification Body'} = 'Benachrichtigung Text';
    $Self->{Translation}->{'Ticket Types'} = 'Ticket-Typen';
    $Self->{Translation}->{'Internal Description'} = 'Interne Beschreibung';
    $Self->{Translation}->{'Customer conditions'} = 'Kundenbedingungen';
    $Self->{Translation}->{'Please choose a Customer property to add a condition.'} = 'Bitte wählen Sie eine Kundeneigenschaft, um eine Bedingung hinzuzufügen.';
    $Self->{Translation}->{'Public survey key'} = 'Öffentlicher Umfrageschlüssel';
    $Self->{Translation}->{'Example survey'} = 'Beispielumfrage';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Allgemeine Angaben bearbeiten';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Fragen bearbeiten';
    $Self->{Translation}->{'You are here'} = 'Sie sind hier';
    $Self->{Translation}->{'Survey Questions'} = 'Umfrage-Fragen';
    $Self->{Translation}->{'Add Question'} = 'Frage hinzufügen';
    $Self->{Translation}->{'Type the question'} = 'Frage eingeben';
    $Self->{Translation}->{'Answer required'} = 'Antwort erforderlich';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Für diese Umfrage sind keine Fragen gespeichert.';
    $Self->{Translation}->{'Question'} = 'Frage';
    $Self->{Translation}->{'Answer Required'} = 'Antwort erforderlich';
    $Self->{Translation}->{'When you finish to edit the survey questions just close this screen.'} =
        'Nach dem Bearbeiten der Umfrage dieses Fenster einfach schließen.';
    $Self->{Translation}->{'Close this window'} = 'Dieses Fenster schließen';
    $Self->{Translation}->{'Edit Question'} = 'Frage bearbeiten';
    $Self->{Translation}->{'go back to questions'} = 'Zurück zu den Fragen';
    $Self->{Translation}->{'Question:'} = 'Frage:';
    $Self->{Translation}->{'Possible Answers For'} = 'Mögliche Antworten für';
    $Self->{Translation}->{'Add Answer'} = 'Antwort hinzufügen';
    $Self->{Translation}->{'No answers saved for this question.'} = 'Für diese Frage sind keine Antworten gespeichert.';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Diese Frage hat nicht mehrere Antworten, ein Texteingabefeld wird hinzugefügt.';
    $Self->{Translation}->{'Edit Answer'} = 'Antwort bearbeiten';
    $Self->{Translation}->{'go back to edit question'} = 'Zurück zum Bearbeiten der Frage';
    $Self->{Translation}->{'Answer:'} = 'Antwort:';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Survey overview options'} = 'Umfrage-Übersichtsoptionen';
    $Self->{Translation}->{'Searches in the attributes Number, Title, Introduction, Description, NotificationSender, NotificationSubject and NotificationBody, overriding other attributes with the same name.'} =
        'Sucht in den Attributen: Name, Titel, Einleitung, Beschreibung, Benachrichtigungs-Absender, Benachrichtigungs-Betreff und Benachrichtigungs-Text, überschreibt andere Attribute mit dem gleichen Namen.';
    $Self->{Translation}->{'Survey Create Time'} = 'Umfrage-Erstellzeit';
    $Self->{Translation}->{'No restriction'} = 'Keine Beschränkung';
    $Self->{Translation}->{'Only surveys created between'} = 'Nur erstellte Umfragen zwischen';
    $Self->{Translation}->{'Max. shown surveys per page'} = 'Maximale Anzahl angezeigter Umfragen pro Seite';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Benachrichtigungs-Absender';
    $Self->{Translation}->{'Notification Subject'} = 'Benachrichtigungs-Betreff';
    $Self->{Translation}->{'Changed By'} = 'Geändert von';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = 'Statistikübersicht von';
    $Self->{Translation}->{'Requests Table'} = 'Anfragentabelle';
    $Self->{Translation}->{'Select all requests'} = 'Alle Anfragen auswählen';
    $Self->{Translation}->{'Send Time'} = 'Sendezeit';
    $Self->{Translation}->{'Vote Time'} = 'Abstimmungszeit';
    $Self->{Translation}->{'Select this request'} = 'Diese Anfrage auswählen';
    $Self->{Translation}->{'See Details'} = 'Siehe Details';
    $Self->{Translation}->{'Delete stats'} = 'Statistiken löschen';
    $Self->{Translation}->{'Survey Stat Details'} = 'Umfrage-Statistikdetails';
    $Self->{Translation}->{'go back to stats overview'} = 'Zurück zur Übersicht';
    $Self->{Translation}->{'Previous vote'} = 'Vorherige Bewertung';
    $Self->{Translation}->{'Next vote'} = 'Nächste Bewertung';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Umfrageinformationen';
    $Self->{Translation}->{'Sent requests'} = 'Gesendete Anfragen';
    $Self->{Translation}->{'Received surveys'} = 'Erhaltene Umfragen';
    $Self->{Translation}->{'Survey Details'} = 'Umfragedetails';
    $Self->{Translation}->{'Ticket Services'} = 'Ticket-Dienste';
    $Self->{Translation}->{'Survey Results Graph'} = 'Umfrageergebnisse-Graph';
    $Self->{Translation}->{'No stat results.'} = 'Keine Statistikergebnisse.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Umfrage';
    $Self->{Translation}->{'Please answer these questions'} = 'Bitte beantworten Sie diese Fragen';
    $Self->{Translation}->{'Show my answers'} = 'Zeige meine Antworten';
    $Self->{Translation}->{'These are your answers'} = 'Dies sind Ihre Antworten';
    $Self->{Translation}->{'Survey Title'} = 'Umfragetitel';

    # Perl Module: Kernel/Modules/AgentSurveyAdd.pm
    $Self->{Translation}->{'Add New Survey'} = 'Neue Umfrage hinzufügen';

    # Perl Module: Kernel/Modules/AgentSurveyEdit.pm
    $Self->{Translation}->{'You have no permission for this survey!'} = 'Sie haben keine Berechtigung für diese Umfrage!';
    $Self->{Translation}->{'No SurveyID is given!'} = 'Keine SurveyID übermittelt!';
    $Self->{Translation}->{'Survey Edit'} = 'Umfrage bearbeiten';

    # Perl Module: Kernel/Modules/AgentSurveyEditQuestions.pm
    $Self->{Translation}->{'You have no permission for this survey or question!'} = 'Sie haben keine Berechtigung für diese Umfrage oder Frage.';
    $Self->{Translation}->{'You have no permission for this survey, question or answer!'} = 'Sie haben keine Berechtigung für diese Umfrage, Frage oder Antwort.';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Fragen der Umfrage bearbeiten';
    $Self->{Translation}->{'Yes/No'} = 'Ja/Nein';
    $Self->{Translation}->{'Radio (List)'} = 'Optionsfeld (Liste)';
    $Self->{Translation}->{'Checkbox (List)'} = 'Kontrollkästchen (Liste)';
    $Self->{Translation}->{'Net Promoter Score'} = 'Net Promoter Punktzahl';
    $Self->{Translation}->{'Question Type'} = 'Fragetyp';
    $Self->{Translation}->{'Complete'} = 'Vollständig';
    $Self->{Translation}->{'Incomplete'} = 'Unvollständig';
    $Self->{Translation}->{'Question Edit'} = 'Frage bearbeiten';
    $Self->{Translation}->{'Answer Edit'} = 'Antwort bearbeiten';

    # Perl Module: Kernel/Modules/AgentSurveyStats.pm
    $Self->{Translation}->{'Stats Overview'} = 'Statistikübersicht';
    $Self->{Translation}->{'You have no permission for this survey or stats detail!'} = 'Sie haben keine Berechtigung für diese Umfrage- oder Statistikdetails.';
    $Self->{Translation}->{'Stats Detail'} = 'Statistikdetail';

    # Perl Module: Kernel/Modules/AgentSurveyZoom.pm
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'Neuer Status konnte nicht gesetzt werden! Keine Fragen definiert.';
    $Self->{Translation}->{'Can\'t set new status! Questions incomplete.'} = 'Neuer Status konnte nicht gesetzt werden! Fragen nicht komplett.';
    $Self->{Translation}->{'Status changed.'} = 'Status geändert.';
    $Self->{Translation}->{'- No queue selected -'} = '- Keine Queue ausgewählt -';
    $Self->{Translation}->{'- No ticket type selected -'} = '- Kein Ticket-Typ ausgewählt -';
    $Self->{Translation}->{'- No ticket service selected -'} = '- Kein Ticket-Service ausgewählt -';
    $Self->{Translation}->{'- Change Status -'} = '- Status ändern -';
    $Self->{Translation}->{'Master'} = 'Master';
    $Self->{Translation}->{'Invalid'} = 'Ungültig';
    $Self->{Translation}->{'New Status'} = 'Neuer Status';
    $Self->{Translation}->{'Survey Description'} = 'Umfragen-Beschreibung';
    $Self->{Translation}->{'answered'} = 'beantwortet';
    $Self->{Translation}->{'not answered'} = 'nicht beantwortet';

    # Perl Module: Kernel/Modules/PublicSurvey.pm
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Danke für Ihr Feedback.';
    $Self->{Translation}->{'The survey is finished.'} = 'Die Umfrage ist beendet.';
    $Self->{Translation}->{'Survey Message!'} = 'Umfragenachricht!';
    $Self->{Translation}->{'Module not enabled.'} = 'Modul nicht akiviert.';
    $Self->{Translation}->{'This functionality is not enabled, please contact your administrator.'} =
        '';
    $Self->{Translation}->{'Survey Error!'} = 'Umfragefehler!';
    $Self->{Translation}->{'Invalid survey key.'} = '';
    $Self->{Translation}->{'The inserted survey key is invalid, if you followed a link maybe this is obsolete or broken.'} =
        'Der eingegebene Umfrageschlüssel ist ungültig. Wenn Sie einem Link gefolgt sind, ist dieser möglicherweise veraltet oder beschädigt.';
    $Self->{Translation}->{'Survey Vote'} = 'Umfragestimme';
    $Self->{Translation}->{'Survey Vote Data'} = '';
    $Self->{Translation}->{'You have already answered the survey.'} = 'Sie haben die Umfrage schon beantwortet.';

    # Perl Module: Kernel/System/Stats/Dynamic/SurveyList.pm
    $Self->{Translation}->{'Survey List'} = 'Umfragen-Liste';

    # JS File: Survey.Agent.SurveyEditQuestions
    $Self->{Translation}->{'Do you really want to delete this question? ALL associated data will be LOST!'} =
        'Wollen Sie diese Frage wirklich löschen? Alle darin enthaltenen Daten werden GELÖSCHT!';
    $Self->{Translation}->{'Do you really want to delete this answer?'} = 'Wollen Sie diese Frage wirklich löschen?';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Ein Umfrage-Modul.';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Ein Modul, um Umfragen zu bearbeiten';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        'Alle Parameter für das Umfrage-Modul im Agenten-Interface.';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        'Anzahl an Tagen nach dem Versand einer Umfrage-E-Mail in denen keine neue Umfrage-E-Mail an den gleichen Kunden versendet wird. Wählen Sie 0, um immer Umfrage-E-Mails zu versenden.';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Voreingestellter Text für Benachrichtigungs-E-Mails an den Kunden über neue Umfragen.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Voreingestellter Absender für Benachrichtigungs-E-Mails an den Kunden über neue Umfragen.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Voreingestellter Betreff für Benachrichtigungs-E-Mails an den Kunden über neue Umfragen.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Definiert ein Übersichts-Modul, dass eine Liste aller Umfragen anzeigt.';
    $Self->{Translation}->{'Defines groups which have a permission to change survey status. Array is empty by default and agents from all groups can change survey status.'} =
        'Das Array ist standardmäßig leer und Agenten aus allen Gruppen können den Status der Umfrage ändern.';
    $Self->{Translation}->{'Defines if survey requests will be only send to real customers.'} =
        'Definiert, ob Umfrage-Anfragen nur an reale Kunden gesendet werden.';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        'Definiert die maximale Anzahl von Umfragen die ein Kunde innerhalb von 30 Tagen zugesandt bekommt. ( 0 steht für kein Maximum, alle Umfrage-E-Mails werden versandt.)';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ). Note: delayed survey sending is done by the OTRS Daemon, prior activation of \'Daemon::SchedulerCronTaskManager::Task###SurveyRequestsSend\' setting.'} =
        'Definiert die Anzahl an Stunden für die ein Ticket geschlossen sein muss, um den Versand einer Umfrage auszulösen ( 0 bedeutet, sofort nach Schließen eines Tickets senden ). Hinweis: Das Absenden der verzögerten Umfrage wird durch den OTRS Daemon erledigt, vorherige Aktivierung durch die \'Daemon::SchedulerCronTaskManager::Task###SurveyRequestsSend\' Einstellung.';
    $Self->{Translation}->{'Defines the columns for the dropdown list for building send conditions (0 => inactive, 1 => active).'} =
        'Definiert die Spalten für die Dropdown-Liste für die Erstellung von Sendebedingungen (0 => inaktiv, 1 => aktiv).';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        'Definiert die Standardhöhe eines Richtext-Bereichs für die Umfrage-Detailansicht.';
    $Self->{Translation}->{'Defines the groups (rw) which can delete survey stats.'} = 'Definiert die Gruppen (rw), die Umfragestatistiken löschen können.';
    $Self->{Translation}->{'Defines the maximum height for Richtext views for SurveyZoom elements.'} =
        'Definiert die maximale Höhe für Richtext-Ansichten für Elemente der Umfrage-Detailansicht.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        'Definiert die angezeigten Spalten der Umfrage-Übersicht. Diese Option hat keine Auswirkung auf die Position der Spalten.';
    $Self->{Translation}->{'Determines if the statistics module may generate survey lists.'} =
        'Bestimmt, ob das Statistik-Modul Umfragelisten erzeugen kann.';
    $Self->{Translation}->{'Edit survey general information.'} = 'Allgemeine Umfrage-Informationen bearbeiten.';
    $Self->{Translation}->{'Edit survey questions.'} = 'Umfrage-Fragen bearbeiten.';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        'Aktivieren oder deaktivieren die ShowVoteData Anzeigen in der öffentlichen Oberfläche, um Abstimmungsdaten anzuzeigen, wen ein Kunde versucht, ein zweites mal abzustimmen.';
    $Self->{Translation}->{'Enable or disable the send condition check for the service.'} = 'Aktivieren oder Deaktivieren der Prüfung der Versandbedingungen für den Service.';
    $Self->{Translation}->{'Enable or disable the send condition check for the ticket type.'} =
        'Aktivieren oder Deaktivieren der Prüfung der Versandbedingungen für den Ticket-Typ.';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        'Frontend-Modul-Registrierung für das Hinzufügen einer Umfrage im Agenten-Interface.';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        'Frontend-Modul-Registrierung für die Umfragebearbeitung im Agenten-Interface.';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        'Frontend-Modul-Registrierung für die Umfragedetailansicht im Agenten-Interface.';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        'Frontend-Modul-Registrierung für die Umfrage-Detailansicht im Agenten-Interface.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        'Frontend-Modul-Registrierung für die öffentliche Umfrageübersicht.';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Wenn dieser reguläre Ausdruck zutrifft, wird keine Umfrage an den Kunden gesendet.';
    $Self->{Translation}->{'Limit.'} = 'Limit.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Parameter für die Seiten der Umfrageübersicht.';
    $Self->{Translation}->{'Public Survey.'} = 'Öffentliche Umfrage.';
    $Self->{Translation}->{'Results older than the configured amount of days will be deleted. Note: delete results done by the OTRS Daemon, prior activation of \'Task###SurveyRequestsDelete\' setting.'} =
        'Ergebnisse, die älter als die konfigurierte Anzahl von Tagen sind, werden gelöscht. Hinweis: Löschen Sie die Ergebnisse des OTRS-Daemons, bevor Sie die Einstellung \'Task#####SurveyRequestsDelete\' aktivieren.';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        'Zeigt einen Link im Menü der Detailansicht im Agenten-Interface an, der es ermöglicht eine Umfrage zu bearbeiten.';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        'Zeigt einen Link im Menü der Detailansicht im Agenten-Interface an, der es ermöglicht die Fragen einer Umfrage zu bearbeiten.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        'Zeigt einen Link im Menü der Detailansicht im Agenten-Interface an, mit dem zum Umfrage-Zoom zurückgegangen werden kann.';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        'Zeigt einen Link im Menü der Detailansicht im Agenten-Interface an, mit dem die Details einer Umfrage angezeigt werden können.';
    $Self->{Translation}->{'Stats Details'} = 'Statistikdetails';
    $Self->{Translation}->{'Survey Add Module.'} = '"Umfrage hinzufügen"-Modul.';
    $Self->{Translation}->{'Survey Edit Module.'} = '"Umfrage bearbeiten"-Modul.';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Umfrageübersicht "Klein" - Limit';
    $Self->{Translation}->{'Survey Stats Module.'} = 'Umfragestatistik-Modul.';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Umfrage-Detailansicht-Modul.';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small".'} = 'Umfragen-Limit pro Seite in der Umfrageübersicht "Klein".';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = 'Umfragen werden nicht an die konfigurierten E-Mail-Adressen gesendet.';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'Die eindeutige Bezeichnung für eine Umfrage, z. B. Survey# oder MySurvey#. Standard ist Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        'Ticket-Event-Modul, um automatisch Umfrage-E-Mails an Kunden zu senden, wenn ein Ticket geschlossen wird.';
    $Self->{Translation}->{'Trigger delete results (including vote data and requests).'} = 'Auslöser zum Löschen von Ergebnissen (inklusive Abstimmungsdaten und Anfragen).';
    $Self->{Translation}->{'Trigger sending delayed survey requests.'} = 'Auslöser zum Senden von verzögerten Anfragen';
    $Self->{Translation}->{'Zoom into statistics details.'} = 'Statistik-Details erhöhen.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Do you really want to delete this answer?',
    'Do you really want to delete this question? ALL associated data will be LOST!',
    'Settings',
    'Submit',
    );

}

1;
