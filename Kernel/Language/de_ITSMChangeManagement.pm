# --
# Kernel/Language/de_ITSMChangeManagement.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ITSMChangeManagement;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAITSMChangeManagement
    $Self->{Translation}->{'ITSMChange'} = 'Change';
    $Self->{Translation}->{'ITSMChanges'} = 'Changes';
    $Self->{Translation}->{'ITSM Changes'} = 'Changes';
    $Self->{Translation}->{'workorder'} = 'Workorder';
    $Self->{Translation}->{'A change must have a title!'} = 'Ein Change benötigt einen Titel!';
    $Self->{Translation}->{'A condition must have a name!'} = 'Eine Bedingung benötigt einen Namen!';
    $Self->{Translation}->{'A template must have a name!'} = 'Eine Vorlage benötigt einen Namen!';
    $Self->{Translation}->{'A workorder must have a title!'} = 'Eine Workorder benötigt einen Titel!';
    $Self->{Translation}->{'ActionExecute::successfully'} = 'erfolgreich';
    $Self->{Translation}->{'ActionExecute::unsuccessfully'} = 'nicht erfolgreich';
    $Self->{Translation}->{'Add CAB Template'} = 'Eine CAB-Vorlage hinzufügen';
    $Self->{Translation}->{'Add Workorder'} = 'Workorder hinzufügen';
    $Self->{Translation}->{'Add a workorder to the change'} = 'Füge eine Workorder zu diesem Change hinzu';
    $Self->{Translation}->{'Add new condition and action pair'} = 'Füge ein neues Bedingungs- und Aktions-Paar hinzu';
    $Self->{Translation}->{'Agent interface module to show the ChangeManager overview icon.'} =
        'Modul zum Anzeigen des ChangeManager-Übersichts-Icons.';
    $Self->{Translation}->{'Agent interface module to show the MyCAB overview icon.'} = 'Modul zum Anzeigen des MyCAB-Übersichts-Icons.';
    $Self->{Translation}->{'Agent interface module to show the MyChanges overview icon.'} = 'Modul zum Anzeigen des MyChanges-Übersichts-Icons.';
    $Self->{Translation}->{'Agent interface module to show the MyWorkOrders overview icon.'} =
        'Modul zum Anzeigen des MyWorkOrders-Übersichts-Icons.';
    $Self->{Translation}->{'CABAgents'} = 'CAB Agents';
    $Self->{Translation}->{'CABCustomers'} = 'CAB Kunden';
    $Self->{Translation}->{'Change Overview'} = 'Change Übersicht';
    $Self->{Translation}->{'Change Schedule'} = 'Change Schedule';
    $Self->{Translation}->{'Change involved persons of the change'} = 'Bearbeite beteiligte Personen dieses Changes';
    $Self->{Translation}->{'ChangeHistory::ActionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ActionAddID'} = 'Neue Action (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ActionDelete'} = 'Action (ID=%s) gelöscht';
    $Self->{Translation}->{'ChangeHistory::ActionDeleteAll'} = 'Alle Aktionen von Bedingung (ID=%s) gelöscht';
    $Self->{Translation}->{'ChangeHistory::ActionExecute'} = 'Aktion (ID=%s) ausgeführt: %s';
    $Self->{Translation}->{'ChangeHistory::ActionUpdate'} = '%s (Action ID=%s): Neu: %s <- Alt: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeActualEndTimeReached'} = 'Change (ID=%s) wurde beendet.';
    $Self->{Translation}->{'ChangeHistory::ChangeActualStartTimeReached'} = 'Change (ID=%s) hat begonnen.';
    $Self->{Translation}->{'ChangeHistory::ChangeAdd'} = 'Neuer Change (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentAdd'} = 'Neuer Anhang: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentDelete'} = 'Anhang gelöscht: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABDelete'} = 'CAB gelöscht %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABUpdate'} = '%s: Neu: %s <- Alt: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkAdd'} = 'Link zu %s (ID=%s) hinzugefügt';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkDelete'} = 'Link zu %s (ID=%s) gelöscht';
    $Self->{Translation}->{'ChangeHistory::ChangeNotificationSent'} = 'Benachrichtigung an %s geschickt (Event: %s)';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedEndTimeReached'} = 'Change (ID=%s) hat geplante Endzeit erreicht.';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedStartTimeReached'} = 'Change (ID=%s) hat geplante Startzeit erreicht.';
    $Self->{Translation}->{'ChangeHistory::ChangeRequestedTimeReached'} = 'Change (ID=%s) hat gewünschte Endzeit erreicht.';
    $Self->{Translation}->{'ChangeHistory::ChangeUpdate'} = '%s: Neu: %s <- Alt: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAddID'} = 'Neue Bedingung (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ConditionDelete'} = 'Bedingung (ID=%s) gelöscht';
    $Self->{Translation}->{'ChangeHistory::ConditionDeleteAll'} = 'Alle Bedingungen von Change (ID=%s) gelöscht';
    $Self->{Translation}->{'ChangeHistory::ConditionUpdate'} = '%s (Bedingung ID=%s): Neu: %s <- Alt: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAddID'} = 'Neue Expression (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ExpressionDelete'} = 'Expression (ID=%s) gelöscht';
    $Self->{Translation}->{'ChangeHistory::ExpressionDeleteAll'} = 'Alle logischen Ausdrücke von Bedingung (ID=%s) gelöscht';
    $Self->{Translation}->{'ChangeHistory::ExpressionUpdate'} = '%s (Expression ID=%s): Neu: %s <- Alt: %s';
    $Self->{Translation}->{'ChangeNumber'} = 'Change Nummer';
    $Self->{Translation}->{'Condition Edit'} = 'Bedingung bearbeiten';
    $Self->{Translation}->{'Create Change'} = 'Change erstellen';
    $Self->{Translation}->{'Create Change (from template)'} = 'Change aus Template erstellen';
    $Self->{Translation}->{'Create a change from this ticket!'} = 'Einen Change aus diesem Ticket erstellen!';
    $Self->{Translation}->{'Create a change (from template) from this ticket!'} = 'Einen Change (aus einem Template) aus diesem Ticket erstellen!';
    $Self->{Translation}->{'Delete Workorder'} = 'Diese Workorder löschen';
    $Self->{Translation}->{'Edit the change'} = 'Diesen Change bearbeiten';
    $Self->{Translation}->{'Edit the conditions of the change'} = 'Bearbeite die Bedingungen dieses Changes';
    $Self->{Translation}->{'Edit the workorder'} = 'Diese Workorder bearbeiten';
    $Self->{Translation}->{'Expression'} = 'Logischer Ausdruck';
    $Self->{Translation}->{'Full-Text Search in Change and Workorder'} = 'Volltextsuche in Change und Workorder';
    $Self->{Translation}->{'ITSMCondition'} = 'Bedingung';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'Workorder';
    $Self->{Translation}->{'Link another object to the change'} = 'Verknüpfe ein anderes Objekt mit diesem Change';
    $Self->{Translation}->{'Link another object to the workorder'} = 'Verknüpfe ein anderes Objekt mit dieser Workorder';
    $Self->{Translation}->{'Move all workorders in time'} = 'Verschiebe alle Workorders um eine neue zeitliche Differenz';
    $Self->{Translation}->{'My CABs'} = 'Meine CABs';
    $Self->{Translation}->{'My Changes'} = 'Meine Changes';
    $Self->{Translation}->{'My Workorders'} = 'Meine Workorders';
    $Self->{Translation}->{'No XXX settings'} = 'Keine \'%s\' Auswahl';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'PIR (Post Implementation Review)';
    $Self->{Translation}->{'PSA (Projected Service Availability)'} = 'PSA (Projected Service Availability)';
    $Self->{Translation}->{'Please select first a catalog class!'} = 'Bitte wählen Sie zuerst eine Katalog Klasse aus!';
    $Self->{Translation}->{'Print the change'} = 'Diesen Change drucken';
    $Self->{Translation}->{'Print the workorder'} = 'Diese Workorder drucken';
    $Self->{Translation}->{'RequestedTime'} = 'Wunschtermin';
    $Self->{Translation}->{'Save Change CAB as Template'} = 'Speichere Change-CAB als Vorlage';
    $Self->{Translation}->{'Save change as a template'} = 'Speichere diesen Change als Vorlage';
    $Self->{Translation}->{'Save workorder as a template'} = 'Speichere diese Workorder als Vorlage';
    $Self->{Translation}->{'Search Changes'} = 'Suche Changes';
    $Self->{Translation}->{'Set the agent for the workorder'} = 'Einen Agenten für diese Workorder auswählen';
    $Self->{Translation}->{'Take Workorder'} = 'Workorder übernehmen';
    $Self->{Translation}->{'Take the workorder'} = 'Diese Workorder übernehmen';
    $Self->{Translation}->{'Template Overview'} = 'Vorlagen-Übersicht';
    $Self->{Translation}->{'The planned end time is invalid!'} = 'Die geplante Endzeit ist ungültig!';
    $Self->{Translation}->{'The planned start time is invalid!'} = 'Die geplante Startzeit ist ungültig!';
    $Self->{Translation}->{'The planned time is invalid!'} = 'Der geplante Zeitraum ist ungültig!';
    $Self->{Translation}->{'The requested time is invalid!'} = 'Die angegebene Zeit ist ungültig!';
    $Self->{Translation}->{'New (from template)'} = 'Neu (von Template)';
    $Self->{Translation}->{'Add from template'} = 'Von Template hinzufügen';
    $Self->{Translation}->{'Add Workorder (from template)'} = 'Workorder hinzufügen (von Template)';
    $Self->{Translation}->{'Add a workorder (from template) to the change'} = 'Füge eine Workorder (von Template) zu diesem Change hinzu';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReached'} = 'Workorder (ID=%s) wurde beendet.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'} =
        'Workorder (ID=%s) wurde beendet.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReached'} = 'Workorder (ID=%s) hat begonnen.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'} =
        'Workorder (ID=%s) hat begonnen.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAdd'} = 'Neue Workorder (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'} = 'Neue Workorder (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAdd'} = 'Neuer Anhang für Workorder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'} = '(ID=%s) Neuer Anhang für Workorder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Anhang von Workorder gelöscht: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Anhang von Workorder gelöscht: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAdd'} = 'Neuer Report-Anhang für Workorder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID'} =
        '(ID=%s) Neuer Report-Anhang für Workorder: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDelete'} = 'Report-Anhang von Workorder gelöscht: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID'} =
        '(ID=%s) Report-Anhang von Workorder gelöscht: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDelete'} = 'Workorder (ID=%s) gelöscht';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'} = 'Workorder (ID=%s) gelöscht';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAdd'} = 'Link zu %s (ID=%s) hinzugefügt';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'} = '(ID=%s) Link zu %s (ID=%s) hinzugefügt';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'Link to %s (ID=%s) gelöscht';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'} = '(ID=%s) Link to %s (ID=%s) gelöscht';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'Benachrichtigung an %s geschickt (Event: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '(ID=%s) Benachrichtigung an %s geschickt (Event: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'} = 'Workorder (ID=%s) hat geplante Endzeit erreicht.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'} =
        'Workorder (ID=%s) hat geplante Endzeit erreicht.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'} = 'Workorder (ID=%s) hat geplante Startzeit erreicht.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} =
        'Workorder (ID=%s) hat geplante Startzeit erreicht.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdate'} = '%s: Neu: %s <- Alt: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'} = '(ID=%s) %s: Neu: %s <- Alt: %s';
    $Self->{Translation}->{'WorkOrderNumber'} = 'Workorder Nummer';
    $Self->{Translation}->{'accepted'} = 'Accepted';
    $Self->{Translation}->{'any'} = 'beliebige';
    $Self->{Translation}->{'approval'} = 'Genehmigung';
    $Self->{Translation}->{'approved'} = 'Approved';
    $Self->{Translation}->{'backout'} = 'Backout Plan';
    $Self->{Translation}->{'begins with'} = 'beginnt mit';
    $Self->{Translation}->{'canceled'} = 'Canceled';
    $Self->{Translation}->{'contains'} = 'enthält';
    $Self->{Translation}->{'created'} = 'Created';
    $Self->{Translation}->{'decision'} = 'Entscheidung';
    $Self->{Translation}->{'ends with'} = 'endet mit';
    $Self->{Translation}->{'failed'} = 'Failed';
    $Self->{Translation}->{'in progress'} = 'In Progress';
    $Self->{Translation}->{'is'} = 'ist';
    $Self->{Translation}->{'is after'} = 'ist nach';
    $Self->{Translation}->{'is before'} = 'ist vor';
    $Self->{Translation}->{'is empty'} = 'ist leer';
    $Self->{Translation}->{'is greater than'} = 'ist grösser als';
    $Self->{Translation}->{'is less than'} = 'ist kleiner als';
    $Self->{Translation}->{'is not'} = 'ist nicht';
    $Self->{Translation}->{'is not empty'} = 'ist nicht leer';
    $Self->{Translation}->{'not contains'} = 'enthält nicht';
    $Self->{Translation}->{'pending approval'} = 'Pending Approval';
    $Self->{Translation}->{'pending pir'} = 'Pending PIR';
    $Self->{Translation}->{'pir'} = 'PIR (Post Implementation Review)';
    $Self->{Translation}->{'ready'} = 'Ready';
    $Self->{Translation}->{'rejected'} = 'Rejected';
    $Self->{Translation}->{'requested'} = 'Requested';
    $Self->{Translation}->{'retracted'} = 'Retracted';
    $Self->{Translation}->{'set'} = 'setze';
    $Self->{Translation}->{'successful'} = 'Successful';

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category <-> Impact <-> Priority'} = 'Kategorie <-> Auswirkung <-> Priorität';
    $Self->{Translation}->{'Manage the priority result of combinating Category <-> Impact.'} =
        'Verwaltung der Priorität aus der Kombination von Kategorie <-> Impact.';
    $Self->{Translation}->{'Priority allocation'} = 'Priorität zuordnen';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'ITSM ChangeManagement Benachrichtigungs-Verwaltung';
    $Self->{Translation}->{'Add Notification Rule'} = 'Benachrichtigungs-Regel';
    $Self->{Translation}->{'Attribute'} = '';
    $Self->{Translation}->{'Rule'} = 'Regel';
    $Self->{Translation}->{'Recipients'} = '';
    $Self->{Translation}->{'A notification should have a name!'} = 'Eine Benachrichtigung benötigt einen Namen!';
    $Self->{Translation}->{'Name is required.'} = 'Name ist erforderlich.';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'Admin State Machine';
    $Self->{Translation}->{'Select a catalog class!'} = 'Wählen Sie eine Katalog-Klasse aus!';
    $Self->{Translation}->{'A catalog class is required!'} = 'Eine Katalog-Klasse ist erforderlich!';
    $Self->{Translation}->{'Add a state transition'} = 'Hinzufügen eines Status-Übergangs';
    $Self->{Translation}->{'Catalog Class'} = 'Katalog-Klasse';
    $Self->{Translation}->{'Object Name'} = 'Objekt-Name';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Übersicht über Status-Übergänge für';
    $Self->{Translation}->{'Delete this state transition'} = '';
    $Self->{Translation}->{'Add a new state transition for'} = 'Hinzufügen eines neuen Status-Übergangs für';
    $Self->{Translation}->{'Please select a state!'} = 'Bitte wählen Sie einen Status!';
    $Self->{Translation}->{'Please select a next state!'} = 'Bitte wählen sie den Folge-Status!';
    $Self->{Translation}->{'Edit a state transition for'} = 'Bearbeiten eines Status-Übergangs für';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Wollen Sie diesen Status-Übergang wirklich löschen?';
    $Self->{Translation}->{'from'} = 'von';

    # Template: AgentITSMCABMemberSearch

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'Change hinzufügen';
    $Self->{Translation}->{'ITSM Change'} = 'Change';
    $Self->{Translation}->{'Justification'} = 'Begründung';
    $Self->{Translation}->{'Input invalid.'} = 'Ungültige Eingabe.';
    $Self->{Translation}->{'Impact'} = 'Auswirkung';
    $Self->{Translation}->{'Requested Date'} = 'Wunschtermin';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'Change-Vorlage auswählen';
    $Self->{Translation}->{'Time type'} = 'Zeit-Typ';
    $Self->{Translation}->{'Invalid time type.'} = 'Ungültiger Zeit-Typ.';
    $Self->{Translation}->{'New time'} = 'Neue Zeit';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'Diesen Change als Vorlage speichern';
    $Self->{Translation}->{'go to involved persons screen'} = 'gehe zum Screen "Beteiligte Personen"';
    $Self->{Translation}->{'This field is required'} = 'Dieses Feld ist erforderlich';
    $Self->{Translation}->{'Invalid Name'} = 'Ungültiger Name';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Bedingungen und Aktionen';
    $Self->{Translation}->{'Delete Condition'} = 'Bedingung löschen';
    $Self->{Translation}->{'Add new condition'} = 'Bedingung hinzufügen';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = 'Ein gültiger Name ist erforderlich.';
    $Self->{Translation}->{'A a valid name is needed.'} = 'Ein gültiger Name ist erforderlich.';
    $Self->{Translation}->{'Matching'} = 'Übereinstimmung';
    $Self->{Translation}->{'Any expression (OR)'} = 'Beliebiger logischer Ausdruck (ODER)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Alle logischen Ausdrücke (UND)';
    $Self->{Translation}->{'Expressions'} = 'Logische Ausdrücke';
    $Self->{Translation}->{'Selector'} = 'Selektor';
    $Self->{Translation}->{'Operator'} = 'Operator';
    $Self->{Translation}->{'Delete Expression'} = '';
    $Self->{Translation}->{'No Expressions found.'} = 'Keinen logischen Ausdruck gefunden.';
    $Self->{Translation}->{'Add new expression'} = 'Füge einen neuen logischen Ausdruck hinzu';
    $Self->{Translation}->{'Delete Action'} = '';
    $Self->{Translation}->{'No Actions found.'} = 'Keine Aktionen gefunden.';
    $Self->{Translation}->{'Add new action'} = 'Füge eine neue Aktion hinzu';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = 'Möchten Sie diesen Change wirklich löschen?';

    # Template: AgentITSMChangeEdit

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'Workorder'} = 'Workorder';
    $Self->{Translation}->{'Show details'} = 'Details anzeigen';
    $Self->{Translation}->{'Show workorder'} = 'Workorder anzeigen';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of'} = 'Detailierte Historien-Informationen von';
    $Self->{Translation}->{'Modified'} = '';
    $Self->{Translation}->{'Old Value'} = 'Alter Wert';
    $Self->{Translation}->{'New Value'} = 'Neuer Wert';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Involved Persons'} = 'Beteiligte Personen';
    $Self->{Translation}->{'ChangeManager'} = 'Change-Manager';
    $Self->{Translation}->{'User invalid.'} = 'Ungültiger Benutzer';
    $Self->{Translation}->{'ChangeBuilder'} = 'Change-Builder';
    $Self->{Translation}->{'Change Advisory Board'} = 'Change-Advisory-Board';
    $Self->{Translation}->{'CAB Template'} = 'CAB-Vorlage';
    $Self->{Translation}->{'Apply Template'} = 'Vorlage anwenden';
    $Self->{Translation}->{'NewTemplate'} = 'Neue Vorlage';
    $Self->{Translation}->{'Save this CAB as template'} = 'Dieses CAB als Vorlage speichern';
    $Self->{Translation}->{'Add to CAB'} = 'Zum CAB hinzufügen';
    $Self->{Translation}->{'Invalid User'} = 'Ungültiger Benutzer';
    $Self->{Translation}->{'Current CAB'} = 'Aktuelles CAB';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Kontext-Einstellungen';
    $Self->{Translation}->{'Changes per page'} = 'Changes pro Seite';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'WorkOrderTitle'} = 'Workorder-Titel';
    $Self->{Translation}->{'ChangeTitle'} = 'Change-Titel';
    $Self->{Translation}->{'WorkOrderAgent'} = 'Workorder-Agent';
    $Self->{Translation}->{'Workorders'} = 'Workorder';
    $Self->{Translation}->{'ChangeState'} = 'Change-Status';
    $Self->{Translation}->{'WorkOrderState'} = 'Workorder-Status';
    $Self->{Translation}->{'WorkOrderType'} = 'Workorder-Typ';
    $Self->{Translation}->{'Requested Time'} = 'Wunschtermin';
    $Self->{Translation}->{'PlannedStartTime'} = 'Geplanter Start';
    $Self->{Translation}->{'PlannedEndTime'} = 'Geplantes Ende';
    $Self->{Translation}->{'ActualStartTime'} = 'Tatsächlicher Start';
    $Self->{Translation}->{'ActualEndTime'} = 'Tatsächliches Ende';

    # Template: AgentITSMChangePrint
    $Self->{Translation}->{'ITSM Workorder'} = 'Workorder';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = 'Möchten Sie diesen Change wirklich zurücksetzen?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(z. B. 10*5155 or 105658*)';
    $Self->{Translation}->{'CABAgent'} = 'CAB Agent';
    $Self->{Translation}->{'e.g.'} = 'z. B.';
    $Self->{Translation}->{'CABCustomer'} = 'CAB Kunde';
    $Self->{Translation}->{'Instruction'} = 'Anweisung';
    $Self->{Translation}->{'Report'} = 'Bericht';
    $Self->{Translation}->{'Change Category'} = 'Change-Kategorie';
    $Self->{Translation}->{'(before/after)'} = '(vor/nach)';
    $Self->{Translation}->{'(between)'} = '(zwischen)';
    $Self->{Translation}->{'Run Search'} = '';

    # Template: AgentITSMChangeSearchResultPrint
    $Self->{Translation}->{'WorkOrders'} = 'Workorder';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Speichere Change als Vorlage';
    $Self->{Translation}->{'A template should have a name!'} = 'Eine Vorlage benötigt einen Namen!';
    $Self->{Translation}->{'The template name is required.'} = 'Der Vorlagen-Name ist erforderlich.';
    $Self->{Translation}->{'Reset States'} = 'Setze Status zurück';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Verschiebe Zeitfenster';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'Change-Informationen';
    $Self->{Translation}->{'PlannedEffort'} = 'Geplanter Aufwand';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Change Initiator(s)';
    $Self->{Translation}->{'Change Manager'} = 'Change-Manager';
    $Self->{Translation}->{'Change Builder'} = 'Change-Builder';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Zuletzt geändert';
    $Self->{Translation}->{'Last changed by'} = 'Zuletzt geändert von';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Download Attachment'} = 'Anhang herunterladen';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = 'Möchten Sie diese Vorlage wirklich löschen?';

    # Template: AgentITSMTemplateEdit

    # Template: AgentITSMTemplateOverviewNavBar

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = 'Template-ID';
    $Self->{Translation}->{'CreateBy'} = 'Erstellt von';
    $Self->{Translation}->{'CreateTime'} = 'Erstellt';
    $Self->{Translation}->{'ChangeBy'} = 'Geändert von';
    $Self->{Translation}->{'ChangeTime'} = 'Geändert';
    $Self->{Translation}->{'Delete: '} = 'Löschen: ';
    $Self->{Translation}->{'Delete Template'} = 'Vorlage Löschen';

    # Template: AgentITSMUserSearch

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = 'Workorder hinzufügen zu';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Ungültiger Workorder-Typ';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'Der geplante Start muss vor dem geplanten Ende liegen!';
    $Self->{Translation}->{'Invalid format.'} = 'Ungültiges Format.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Workorder-Vorlage auswählen';

    # Template: AgentITSMWorkOrderAgent

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Möchten Sie diese Workorder wirklich löschen?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Sie können diese Workorder nicht löschen. Sie wird in mindestens einer Bedingung verwendet!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Diese Workorder findet Verwendung in den folgenden Bedingung(en)';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = 'Nachfolgende Workorders entsprechend verschieben';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        'Wenn die gepplante Endzeit einer Workorder geändert wird, dann werden die nachfolgenden Workorders entsprechend verschoben';

    # Template: AgentITSMWorkOrderHistory

    # Template: AgentITSMWorkOrderHistoryZoom

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'Die tatsächliche Startzeit muss vor der tatsächlichen Endzeit liegen!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'Die tatsächliche Startzeit muss angegeben wreden, wenn eine tatsächliche Endzeit angegeben wurde!';
    $Self->{Translation}->{'Existing attachments'} = '';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Aktueller Agent';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Wollen sie diese Workorder wirklich übernehmen?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Speichere Workorder als Vorlage';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Workorder-Informationen';

    # Template: CustomerITSMChangeOverview

    # Template: ITSMChange

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        '';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        'Eine Liste von Workorder-States bei denen die ActualStartTime einer Workorder gesetzt wird, wenn diese vorher nicht gesetzt war.';
    $Self->{Translation}->{'Admin of notification rules.'} = '';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = '';
    $Self->{Translation}->{'Admin of the state machine.'} = '';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        '';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        '';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        '';
    $Self->{Translation}->{'Agent interface notification module to see the number of work orders.'} =
        '';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        '';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        '';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = '';
    $Self->{Translation}->{'Change free text options shown in the change add of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Change free text options shown in the change edit of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Change free text options shown in the change search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small"'} = '';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = '';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        'Konfiguration wie häufig Benachrichtungen verschickt werden wenn die geplante Startzeit oder andere Zeiten erreicht wurden bzw. schon vorbei sind.';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        'Standard-Typ für eine Workorder. Dieser Eintrag muss in der General Catalog Klasse \'ITSM::ChangeManagement::WorkOrder::Type\' existieren.';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = 'Definieren eines Signals für einen Workorder-Status.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        'Definiert das Übersichtsmodul um die Small-Ansicht einer Change-Liste anzuzeigen.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        'Definiert das Übersichtsmodul um die Small-Ansicht einer Template-Liste anzuzeigen.';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = '';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = '';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = 'Soll die gebuchte Zeit angezeigt werden.';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = 'Wenn der tatsächliche Start- und Endzeitpunkt gesetzt werden soll.';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        '';
    $Self->{Translation}->{'Defines if the change state can be set in AgentITSMChangeEdit.'} =
        'Definiert ob der Change-Status in AgentITSMChangeEdit gesetzt werden kann.';
    $Self->{Translation}->{'Defines if the planned effort should be shown.'} = 'Soll der geplante Aufwand angezeigt werden.';
    $Self->{Translation}->{'Defines if the requested date should be print by customer.'} = '';
    $Self->{Translation}->{'Defines if the requested date should be searched by customer.'} =
        'Soll der Wunschtermin des Kunden gesucht werden können.';
    $Self->{Translation}->{'Defines if the requested date should be set by customer.'} = '';
    $Self->{Translation}->{'Defines if the requested date should be shown by customer.'} = 'Soll der Wunschtermin des Kunden angezeigt werden.';
    $Self->{Translation}->{'Defines if the workorder state should be shown.'} = 'Soll der Status der Workorder angezeigt werden.';
    $Self->{Translation}->{'Defines if the workorder title should be shown.'} = 'Soll der Titel der Workorder angezeigt werden.';
    $Self->{Translation}->{'Defines shown graph attributes.'} = 'Definiert Attribute für die Anzeige des Graphen.';
    $Self->{Translation}->{'Defines that only changes containing Workorders linked with services, which the customer user has permission to use will be shown. Any other changes will not be displayed.'} =
        'Definiert das nur Changes angezeigt werden, die Workorders enthalten, die mit Services verlinkt sind, für die der Kunden-Benutzer eine Berechtigung hat. Andere Changes werden nicht angezeigt.';
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change PSA overview.'} =
        'Definiert die Change-States die als Filter in der Change PSA-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change Schedule overview.'} =
        'Definiert die Change-States die als Filter in der Change Schedule-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyCAB overview.'} =
        'Definiert die Change-States die als Filter in der MyCAB-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyChanges overview.'} =
        'Definiert die Change-States die als Filter in der MyChanges-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change manager overview.'} =
        'Definiert die Change-States die als Filter in der Change-Manager-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change overview.'} =
        'Definiert die Change-States die als Filter in der Change-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the customer change schedule overview.'} =
        'Definiert die Change-States die als Filter in der Kunden-Ansicht "Change Schedule" verwendet werden.';
    $Self->{Translation}->{'Defines the default selection of the free key field number 1 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 1 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 10 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 10 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 11 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 11 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 12 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 12 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 13 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 13 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 14 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 14 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 15 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 15 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 16 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 16 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 17 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 17 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 18 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 18 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 19 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 19 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 2 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 2 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 20 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 20 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 21 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 21 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 22 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 22 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 23 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 23 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 24 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 24 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 25 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 25 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 26 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 26 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 27 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 27 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 28 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 28 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 29 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 29 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 3 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 3 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 30 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 30 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 31 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 31 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 32 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 32 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 33 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 33 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 34 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 34 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 35 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 35 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 36 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 36 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 37 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 37 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 38 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 38 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 39 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 39 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 4 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 4 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 40 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 40 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 41 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 41 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 42 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 42 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 43 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 43 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 44 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 44 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 45 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 45 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 46 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 46 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 47 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 47 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 48 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 48 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 49 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 49 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 5 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 5 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 50 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 50 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 6 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 6 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 7 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 7 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 8 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 8 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 9 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 9 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 1 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 1 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 10 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 10 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 11 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 11 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 12 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 12 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 13 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 13 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 14 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 14 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 15 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 15 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 16 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 16 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 17 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 17 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 18 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 18 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 19 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 19 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 2 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 2 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 20 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 20 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 21 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 21 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 22 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 22 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 23 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 23 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 24 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 24 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 25 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 25 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 26 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 26 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 27 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 27 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 28 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 28 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 29 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 29 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 3 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 3 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 30 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 30 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 31 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 31 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 32 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 32 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 33 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 33 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 34 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 34 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 35 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 35 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 36 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 36 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 37 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 37 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 38 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 38 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 39 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 39 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 4 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 4 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 40 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 40 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 41 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 41 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 42 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 42 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 43 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 43 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 44 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 44 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 45 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 45 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 46 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 46 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 47 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 47 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 48 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 48 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 49 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 49 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 5 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 5 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 50 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 50 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 6 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 6 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 7 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 7 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 8 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 8 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 9 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 9 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria in the change PSA overview.'} =
        'Standard Sortierung der Changes in der Change PSA-Übersicht.';
    $Self->{Translation}->{'Defines the default sort criteria in the change manager overview.'} =
        'Standard Sortierung der Changes in der Change-Manager-Übersicht.';
    $Self->{Translation}->{'Defines the default sort criteria in the change overview.'} = 'Standard Sortierung der Changes in der Change-Übersicht.';
    $Self->{Translation}->{'Defines the default sort criteria in the change schedule overview.'} =
        'Standard Sortierung der Changes in der Change Schedule-Übersicht.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyCAB overview.'} =
        'Standard Sortierung der Changes in der MyCAB-Übersicht.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyChanges overview.'} =
        'Standard Sortierung der Changes in der MyChanges-Übersicht.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyWorkorders overview.'} =
        'Standard Sortierung der Changes in der MyWorkorders-Übersicht.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the PIR overview.'} =
        'Standard Sortierung der Changes in der PIR-Übersicht.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the customer change schedule overview.'} =
        'Standard Sortierung der Changes in der Kunden-Ansicht "Change Schedule".';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the template overview.'} =
        'Standard Sortierung der Templates in der Template-Übersicht.';
    $Self->{Translation}->{'Defines the default sort order in the MyCAB overview.'} = 'Standard Reihenfolge der Changes in der MyCAB-Übersicht.';
    $Self->{Translation}->{'Defines the default sort order in the MyChanges overview.'} = 'Standard Reihenfolge der Changes in der MyChanges-Übersicht.';
    $Self->{Translation}->{'Defines the default sort order in the MyWorkorders overview.'} =
        'Standard Reihenfolge der Workorders in der MyWorkorders-Übersicht.';
    $Self->{Translation}->{'Defines the default sort order in the PIR overview.'} = 'Standard Reihenfolge der Changes in der PIR-Übersicht.';
    $Self->{Translation}->{'Defines the default sort order in the change PSA overview.'} = 'Standard Reihenfolge der Changes in der Change PSA-Übersicht.';
    $Self->{Translation}->{'Defines the default sort order in the change manager overview.'} =
        'Standard Reihenfolge der Changes in der Change-Manager-Übersicht.';
    $Self->{Translation}->{'Defines the default sort order in the change overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the change schedule overview.'} =
        'Standard Reihenfolge der Changes in der Change Schedule-Übersicht.';
    $Self->{Translation}->{'Defines the default sort order in the customer change schedule overview.'} =
        'Standard Reihenfolge der Changes in der Kunden-Ansicht "Change Schedule".';
    $Self->{Translation}->{'Defines the default sort order in the template overview.'} = 'Standard Reihenfolge der Templates in der Template-Übersicht.';
    $Self->{Translation}->{'Defines the default value for the category of a change.'} = 'Der Standard-Wert für die Kategorie eines Changes.';
    $Self->{Translation}->{'Defines the default value for the impact of a change.'} = 'Der Standard-Wert für die Auswirkung eines Changes.';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for change attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Definiert den Feld-Typ für CompareValue Felder für Change-Attribute in AgentITSMChangeConditionEdit. Gültige Werte sind Selection, Text und Date. Wenn kein Typ definiert ist, dann wird das feld nicht angezeigt.';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for workorder attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Definiert den Feld-Typ für CompareValue Felder für Workorder-Attribute in AgentITSMChangeConditionEdit. Gültige Werte sind Selection, Text und Date. Wenn kein Typ definiert ist, dann wird das feld nicht angezeigt.';

    $Self->{Translation}->{'Screen after creating a workorder'}
        = 'Ansicht nach Workorder-Erstellung';
    $Self->{Translation}->{'Show this screen after I created a new workorder'}
        = 'Diese Ansicht nach dem Erstellen einer Workorder anzeigen';
    $Self->{Translation}->{'Duplicate name:'}
        = 'Doppelter Name:';
    $Self->{Translation}->{'This name is already used by another condition.'}
        = 'Dieser Name wird bereits von einer anderen Bedingung verwendet.';

    $Self->{Translation}->{'Defines the free key field number 1 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 1 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 10 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 10 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 11 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 11 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 12 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 12 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 13 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 13 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 14 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 14 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 15 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 15 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 16 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 16 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 17 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 17 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 18 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 18 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 19 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 19 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 2 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 2 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 20 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 20 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 21 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 21 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 22 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 22 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 23 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 23 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 24 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 24 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 25 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 25 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 26 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 26 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 27 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 27 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 28 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 28 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 29 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 29 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 3 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 3 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 30 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 30 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 31 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 31 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 32 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 32 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 33 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 33 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 34 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 34 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 35 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 35 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 36 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 36 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 37 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 37 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 38 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 38 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 39 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 39 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 4 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 4 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 40 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 40 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 41 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 41 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 42 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 42 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 43 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 43 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 44 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 44 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 45 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 45 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 46 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 46 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 47 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 47 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 48 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 48 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 49 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 49 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 5 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 5 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 50 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 50 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 6 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 6 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 7 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 7 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 8 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 8 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 9 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 9 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 1 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 1 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 10 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 10 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 11 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 11 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 12 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 13 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 13 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 14 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 14 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 15 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 15 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 16 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 16 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 17 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 17 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 18 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 18 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 19 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 19 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 2 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 2 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 20 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 20 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 21 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 21 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 22 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 22 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 23 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 23 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 24 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 24 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 25 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 25 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 26 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 26 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 27 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 27 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 28 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 28 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 29 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 29 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 3 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 3 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 30 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 30 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 31 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 31 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 32 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 32 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 33 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 33 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 34 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 34 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 35 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 35 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 36 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 36 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 37 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 37 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 38 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 38 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 39 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 39 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 4 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 4 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 40 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 40 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 41 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 41 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 42 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 42 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 43 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 43 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 44 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 44 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 45 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 45 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 46 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 46 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 47 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 47 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 48 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 48 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 49 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 49 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 5 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 5 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 50 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 50 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 6 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 6 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 7 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 7 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 8 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 8 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 9 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 9 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 1 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 1 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 10 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 10 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 11 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 11 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 12 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 12 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 13 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 13 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 14 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 14 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 15 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 15 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 16 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 16 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 17 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 17 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 18 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 18 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 19 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 19 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 2 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 2 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 20 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 20 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 21 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 21 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 22 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 22 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 23 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 23 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 24 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 24 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 25 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 25 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 26 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 26 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 27 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 27 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 28 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 28 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 29 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 29 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 3 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 3 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 30 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 30 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 31 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 31 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 32 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 32 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 33 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 33 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 34 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 34 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 35 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 35 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 36 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 36 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 37 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 37 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 38 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 38 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 39 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 39 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 4 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 4 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 40 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 40 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 41 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 41 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 42 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 42 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 43 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 43 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 44 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 44 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 45 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 45 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 46 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 46 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 47 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 47 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 48 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 48 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 49 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 49 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 5 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 5 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 50 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 50 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 6 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 6 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 7 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 7 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 8 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 8 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 9 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 9 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the maximum number of change freetext fields.'} = 'Definition der maximalen Anzahl von FreiTextFeldern für Changes.';
    $Self->{Translation}->{'Defines the maximum number of workorder freetext fields.'} = 'Definition der maximalen Anzahl von FreiTextFeldern für Workorders.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for change objects in AgentITSMChangeConditionEdit.'} =
        'Definiert die Objekt-Attribute die für Change-Objekte in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for workorder objects in AgentITSMChangeConditionEdit.'} =
        'Definiert die Objekt-Attribute die für Workorder-Objekte in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute AccountedTime in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut AccountedTime in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualEndTime in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut ActualEndTime in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualStartTime in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut ActualStartTime in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute CategoryID in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut CategoryID in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeBuilderID in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut ChangeBuilderID in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeFreeKey in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut ChangeFreeKey in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeFreeText in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut ChangeFreeText in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeManagerID in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut ChangeManagerID in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeStateID in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut ChangeStateID in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeTitle in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut ChangeTitle in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ImpactID in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut ImpactID in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEffort in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut PlannedEffort in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEndTime in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut PlannedEndTime in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedStartTime in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut PlannedStartTime in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PriorityID in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut PriorityID in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute RequestedTime in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut RequestedTime in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderAgentID in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut WorkOrderAgentID in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderFreeKey in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut WorkOrderFreeKey in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderFreeText in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut WorkOrderFreeText in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderNumber in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut WorkOrderNumber in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderStateID in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut WorkOrderStateID in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTitle in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut WorkOrderTitle in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTypeID in AgentITSMChangeConditionEdit.'} =
        'Definiert die Operatoren die für das Attribut WorkOrderTypeID in AgentITSMChangeConditionEdit ausgewählt werden können.';
    $Self->{Translation}->{'Defines the period (in years), in which start and end times can be selected.'} =
        '';
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the Change PSA overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der Change PSA-Übersicht. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the Change Schedule overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der Change Schedule-Übersicht. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the MyCAB overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der MyCAB-Übersicht. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the MyChanges overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der MyChanges-Übersicht. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the MyWorkorders overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der MyWorkorders-Übersicht. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the PIR overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der PIR-Übersicht. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the change manager overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der Change-Manager-Übersicht. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the change overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der Change-Übersicht. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the change search. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten im Suchergebniss. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the customer change schedule overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der Kunden-Ansicht "Change Schedule". Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the template overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der Template-Übersicht. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the signals for each ITSMChange state.'} = 'Definieren eines Signals für einen ITSMChange-Status.';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        'Definiert die TemplateTypen die als Filter in der Template-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        'Definiert die Workorder-States die als Filter in der MyWorkorders-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        'Definiert die Workorder-States die als Filter in der PIR-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        'Definiert die Workorder-Typen die für die PIR-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = 'Wenn Benachrichtigungen versendet werden sollen.';
    $Self->{Translation}->{'Determines if an agent can exchange the X-axis of a stat if he generates one.'} =
        'Wenn diese Option aktiviert wird, hat der Agent die Möglichkeit beim Generieren einer Statistik die beiden Achsen zu vertauschen.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes done for config item classes.'} =
        'Hier können Sie festlegen, ob das Statistik-Modul auch allgemeine Statistiken über die Anzahl der durchgeführten Changes nach CI-Klasse generieren darf.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding change state updates within a timeperiod.'} =
        'Hier können Sie festlegen, ob das Statistik-Modul auch allgemeine Statistiken über Changes bzgl. Status-Updates innerhalb einer Zeitperiode generieren darf.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding the relation between changes and incident tickets.'} =
        'Hier können Sie festlegen, ob das Statistik-Modul auch allgemeine Statistiken über Changes bzgl. dem Zusammenhang zwischen Changes und Vorfalls-Tickets generieren darf.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes.'} =
        'Hier können Sie festlegen, ob das Statistik-Modul auch allgemeine Statistiken über Changes generieren darf.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about the number of Rfc tickets a requester created.'} =
        'Hier können Sie festlegen, ob das Statistik-Modul auch allgemeine Statistiken über die Anzahl von RfC-Tickets, die von Benutzern erzeugt wurden, generieren darf.';
    $Self->{Translation}->{'Event list to be displayed on GUI to trigger generic interface invokers.'} =
        '';
    $Self->{Translation}->{'ITSM event module deletes the history of changes.'} = 'ITSM Event Modul löscht die Historie von Changes.';
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = 'ITSM Event Modul zum Aufräumen von Conditions.';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = '';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        'ITSM Event Modul zum Überprüfen von Conditions und zum Ausführen von Actions.';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = 'ITSM Event Modul zum Senden von Benachrichtigungen.';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = 'ITSM Event Modul aktualisiert die Historie von Changes.';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = 'ITSM Event Modul, das die Workorder Nummern neu berechnet.';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        'ITSM Event Modul, das die ActualStart und ActualEnd Zeiten von Workorders setzt.';
    $Self->{Translation}->{'ITSM event module updates the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module updates the history of conditions.'} = 'ITSM Event Modul aktualisiert die Historie von Conditions.';
    $Self->{Translation}->{'ITSM event module updates the history of workorders.'} = 'ITSM Event Modul aktualisiert die Historie von Workorders.';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notications are sent (every X hours).'} =
        'Wenn die Häufigkeit auf \'regularly\' eingestellt ist, können Sie hier einstellen, nach wievielen Stunden eine erneute Erinnerung verschickt werden soll.';
    $Self->{Translation}->{'Logfile for the ITSM change counter. This file is used for creating the change numbers.'} =
        'Pfad und Verzeichnis zur Logdatei für den ITSM Change-Counter. Diese Datei hilft bei der Erzeugung von Change-Nummern.';
    $Self->{Translation}->{'Module to check the CAB members.'} = 'Modul zum Überprüfen des Agenten im CAB.';
    $Self->{Translation}->{'Module to check the agent.'} = 'Modul zum Überprüfen des Agenten.';
    $Self->{Translation}->{'Module to check the change builder.'} = 'Modul zum Überprüfen des Change Builders.';
    $Self->{Translation}->{'Module to check the change manager.'} = 'Modul zum Überprüfen des Change Managers.';
    $Self->{Translation}->{'Module to check the workorder agent.'} = 'Modul zum Überprüfen des Workorder-Agenten.';
    $Self->{Translation}->{'Module to check whether no workorder agent is set.'} = 'Modul zum Überprüfen ob es keinen Agenten für die Workorder gibt.';
    $Self->{Translation}->{'Module to check whether the agent is contained in the configured list.'} =
        'Modul zum Überprüfen ob der Agent in der konfigurierten Liste enthalten ist.';
    $Self->{Translation}->{'Module to show a link to create a change from this ticket. The ticket will be automatically linked with the new change.'} =
        'Mit diesem Modul wird ein Link im Menü der Ticketansicht angezeigt, mit dem ein Change erstellt werden kann. Das Ticket wird automatisch mit dem neu erstellten Change verlinkt.';
    $Self->{Translation}->{'Notification (ITSM Change Management)'} = 'Benachrichtigung (ITSM Change Management)';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        'Nur die Mitglieder dieser Gruppen haben die Erlaubnis die Ticket-Typen zu verwenden, die in "ITSMChange::AddChangeLinkTicketTypes" definiert sind, wenn das Feature "Ticket::Acl::Module###200-Ticket::Acl::Module" aktiviert ist.';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        '';
    $Self->{Translation}->{'Presents a link in the menu to show the involved persons in a change, in the zoom view of such change in the agent interface.'} =
        '';
    $Self->{Translation}->{'Required privileges in order for an agent to take a workorder.'} =
        'Benötigtes Recht zum Übernehmen einer Workorder.';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = '';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = 'Benötigtes Recht zum Löschen einer Workorder.';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = 'Benötigtes Recht zum Ändern des Agenten einer Workorder.';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = 'Benötigtes Recht um eine Vorlage aus einem Change zu erstellen.';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        'Benötigtes Recht um eine Vorlage aus einem CAB eines Change zu erstellen.';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = 'Benötigtes Recht um eine Vorlage aus einer Workorder zu erstellen.';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = '';
    $Self->{Translation}->{'Required privileges to create changes.'} = 'Benötigtes Recht zum Erstellen von Changes.';
    $Self->{Translation}->{'Required privileges to delete a template.'} = 'Benötigtes Recht zum Löschen einer Vorlage.';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to delete changes.'} = '';
    $Self->{Translation}->{'Required privileges to edit a template.'} = 'Benötigtes Recht zum Ändern einer Vorlage.';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = 'Benötigtes Recht zum Ändern einer Workorder.';
    $Self->{Translation}->{'Required privileges to edit changes.'} = 'Benötigtes Recht zum Bearbeiten von Changes.';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = 'Benötigtes Recht zum Bearbeiten der Condition von Changes.';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        'Benötigtes Recht zum Ändern der beteiligten Personen.';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = 'Benötigtes Recht zum zeitlichen Verschieben von Changes.';
    $Self->{Translation}->{'Required privileges to print a change.'} = '';
    $Self->{Translation}->{'Required privileges to reset changes.'} = '';
    $Self->{Translation}->{'Required privileges to view a workorder.'} = 'Benötigtes Recht zum Betrachten einer Workorder.';
    $Self->{Translation}->{'Required privileges to view changes.'} = 'Benötigtes Recht zum Ansehen von Changes.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is a CAB member.'} =
        'Benötigtes Recht zum Einsehen der Liste der Changes bei denen der Benutzer Mitglied des CABs ist.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is the change manager.'} =
        'Benötigtes Recht zum Einsehen der Liste der Changes bei denen der Benutzer change manager ist.';
    $Self->{Translation}->{'Required privileges to view overview over all templates.'} = 'Benötigtes Recht zum Einsehen der Liste von Vorlagen.';
    $Self->{Translation}->{'Required privileges to view the conditions of changes.'} = 'Benötigtes Recht zum Betrachten der Conditions von Changes.';
    $Self->{Translation}->{'Required privileges to view the history of a change.'} = 'Benötigtes Recht zum Einsehen der Historie eines Change.';
    $Self->{Translation}->{'Required privileges to view the history of a workorder.'} = 'Benötigtes Recht zum Betrachten der Historie einer Workorder.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a change.'} = 'Benötigtes Recht zum Einsehen der Historiendetails eines Changes.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a workorder.'} =
        'Benötigtes Recht zum Betrachten der Historiendetails einer Workorder.';
    $Self->{Translation}->{'Required privileges to view the list of Change Schedule.'} = 'Benötigtes Recht zum Einsehen der Change Schedule-Übersicht.';
    $Self->{Translation}->{'Required privileges to view the list of change PSA.'} = 'Benötigtes Recht zum Einsehen der Change PSA-Übersicht.';
    $Self->{Translation}->{'Required privileges to view the list of changes with an upcoming PIR (Post Implementation Review).'} =
        'Benötigtes Recht zum Einsehen der Liste von Changes mit einem anstehenden PIR (Post Implementation Review).';
    $Self->{Translation}->{'Required privileges to view the list of own changes.'} = 'Benötigtes Recht zum Einsehen der Liste der eigenen Changes.';
    $Self->{Translation}->{'Required privileges to view the list of own workorders.'} = 'Benötigtes Recht zum Einsehen der Liste von eigenen Workorders.';
    $Self->{Translation}->{'Required privileges to write a report for the workorder.'} = 'Benötigtes Recht zum Verfassen eines Berichtes für eine Workorder.';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        '';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        '';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = 'Konfiguration für die State Machine für Changes.';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = 'Konfiguration für die State Machine für Workorders.';
    $Self->{Translation}->{'Shows a checkbox in the AgentITSMWorkOrderEdit screen that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the work order agent, in the zoom view of such work order of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a work order as a template in the zoom view of the work order, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workd order, in the zoom view of such work order of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a work order with another object in the zoom view of such work order of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows moving the time slot of a change in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows taking a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the conditions of a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to add a work order in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to delete a work order in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the work order zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        '';
    $Self->{Translation}->{'State Machine'} = '';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        'Change-Identifikator, z. B. Change#, MeinChange#. Als Standard wird Change# verwendet.';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        'Workorder-Identifikator, z. B. Workorder#, MeineWorkorder#. Als Standard wird Workorder# verwendet.';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        '';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        'Typen der Tickets, in denen im Ticket-Zoom ein Link angezeigt wird, um einen Change zu erstellen.';
    $Self->{Translation}->{'Workorder free text options shown in the change search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Workorder free text options shown in the workorder add of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Workorder free text options shown in the workorder edit of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Workorder free text options shown in the workorder report of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Adapts the width of the autocomplete drop down to the length of the longest option.'} =
        'Passe die Breite des Autocomplete-DropDowns an die längste Option an.';
    $Self->{Translation}->{'CAB Agent'} = 'CAB Agent';
    $Self->{Translation}->{'CAB Customer'} = 'CAB Kunde';
    $Self->{Translation}->{'Cache time in minutes for the change management.'} = 'Cache-Zeit in Minuten für das Change Management.';
    $Self->{Translation}->{'Change Description'} = 'Change Beschreibung';
    $Self->{Translation}->{'Change Impact'} = 'Change Auswirkung';
    $Self->{Translation}->{'Change Justification'} = 'Change Begründung';
    $Self->{Translation}->{'Change Number'} = 'Change Nummer';
    $Self->{Translation}->{'Change Priority'} = 'Change Priorität';
    $Self->{Translation}->{'Change State'} = 'Change-Status';
    $Self->{Translation}->{'Change Title'} = 'Change-Titel';
    $Self->{Translation}->{'Created By'} = 'Erstellt von';
    $Self->{Translation}->{'Delete Change'} = 'Diesen Change löschen';
    $Self->{Translation}->{'Enables or disables TypeAhead for the autocomplete feature.'} = 'Aktivieren oder deaktivieren von TypeAhead in der Autocomplete-Funktionalität.';
    $Self->{Translation}->{'Enables or disables the autocomplete feature for the customer search in the ITSM agent interface.'} =
        'Aktivieren oder deaktivieren der Autocomplete-Funktionalität für die Kunden-Suche im ITSM-Agenteninterface.';
    $Self->{Translation}->{'Enables or disables the autocomplete feature for the user search in the ITSM agent interface.'} =
        'Aktivieren oder deaktivieren der Autocomplete-Funktionalität für die User-Suche im ITSM-Agenteninterface.';
    $Self->{Translation}->{'Reset change and its workorders'} = 'Change und dessen Workorders zurücksetzen';
    $Self->{Translation}->{'Search Agent'} = 'Agenten Suchen';
    $Self->{Translation}->{'Selects the change number generator module. With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        'Auswahl des Moduls zur Generierung der Changenummern. "Date" generiert die Changenummer aus Datum und dem Counter, es wird das Format "Jahr.Monat.Tag.Counter" verwendet, z. B. 2010062400001, 2010062400002. "DateChecksum" erzeugt die Changenummer aus dem Datum, der SystemID, dem Counter und einer Checksumme. Es wird das Format "Jahr.Monat.Tag.SystemID.Counter.CheckSumme" verwendet, z. B. 2010062410000017, 2010062410000026.';
    $Self->{Translation}->{'Sets the maximal number of search results for the autocomplete feature.'} =
        'Maximale Zahl der Suchergebnisse in der Autocomplete-Funktionalität.';
    $Self->{Translation}->{'Work Order Title'} = 'Workorder-Titel';
    $Self->{Translation}->{'WorkOrder Agent'} = 'Workorder-Agent';
    $Self->{Translation}->{'WorkOrder Instruction'} = 'Workorder Anweisung';
    $Self->{Translation}->{'WorkOrder Report'} = 'Workorder Bericht';
    $Self->{Translation}->{'WorkOrder State'} = 'Workorder-Status';
    $Self->{Translation}->{'WorkOrder Type'} = 'Workorder-Typ';

}

1;
