# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

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
    $Self->{Translation}->{'Change Overview'} = 'Änderungsübersicht';
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
    $Self->{Translation}->{'Create a change from this ticket!'} = 'Einen Change aus diesem Ticket erstellen!';
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
    $Self->{Translation}->{'Template Overview'} = 'Vorlagenübersicht';
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
    $Self->{Translation}->{'Rule'} = 'Regel';
    $Self->{Translation}->{'A notification should have a name!'} = 'Eine Benachrichtigung benötigt einen Namen!';
    $Self->{Translation}->{'Name is required.'} = 'Name ist erforderlich.';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'Admin State Machine';
    $Self->{Translation}->{'Select a catalog class!'} = 'Wählen Sie eine Katalog-Klasse aus!';
    $Self->{Translation}->{'A catalog class is required!'} = 'Eine Katalog-Klasse ist erforderlich!';
    $Self->{Translation}->{'Add a state transition'} = 'Hinzufügen eines Status-Übergangs';
    $Self->{Translation}->{'Catalog Class'} = 'Katalog-Klasse';
    $Self->{Translation}->{'Object Name'} = 'Objekt-Name';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Übersicht über Statusübergänge für';
    $Self->{Translation}->{'Delete this state transition'} = 'Löschen dieses Status-Übergangs';
    $Self->{Translation}->{'Add a new state transition for'} = 'Hinzufügen eines neuen Status-Übergangs für';
    $Self->{Translation}->{'Please select a state!'} = 'Bitte wählen Sie einen Status!';
    $Self->{Translation}->{'Please select a next state!'} = 'Bitte wählen sie den Folge-Status!';
    $Self->{Translation}->{'Edit a state transition for'} = 'Bearbeiten eines Status-Übergangs für';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Wollen Sie diesen Status-Übergang wirklich löschen?';
    $Self->{Translation}->{'from'} = 'von';
    $Self->{Translation}->{'to'} = 'bis';

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
    $Self->{Translation}->{'Invalid Name'} = 'Ungültiger Name';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Bedingungen und Aktionen';
    $Self->{Translation}->{'Delete Condition'} = 'Bedingung löschen';
    $Self->{Translation}->{'Add new condition'} = 'Bedingung hinzufügen';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = 'Ein gültiger Name ist erforderlich.';
    $Self->{Translation}->{'A valid name is needed.'} = '';
    $Self->{Translation}->{'Duplicate name:'} = 'Doppelter Name:';
    $Self->{Translation}->{'This name is already used by another condition.'} = 'Dieser Name wird bereits von einer anderen Bedingung verwendet.';
    $Self->{Translation}->{'Matching'} = 'Übereinstimmung';
    $Self->{Translation}->{'Any expression (OR)'} = 'Beliebiger logischer Ausdruck (ODER)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Alle logischen Ausdrücke (UND)';
    $Self->{Translation}->{'Expressions'} = 'Logische Ausdrücke';
    $Self->{Translation}->{'Selector'} = 'Selektor';
    $Self->{Translation}->{'Operator'} = 'Operator';
    $Self->{Translation}->{'Delete Expression'} = 'Ausdruck löschen';
    $Self->{Translation}->{'No Expressions found.'} = 'Keinen logischen Ausdruck gefunden.';
    $Self->{Translation}->{'Add new expression'} = 'Füge einen neuen logischen Ausdruck hinzu';
    $Self->{Translation}->{'Delete Action'} = 'Aktion löschen';
    $Self->{Translation}->{'No Actions found.'} = 'Keine Aktionen gefunden.';
    $Self->{Translation}->{'Add new action'} = 'Füge eine neue Aktion hinzu';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = 'Möchten Sie diesen Change wirklich löschen?';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of'} = 'Änderungsverlauf von';
    $Self->{Translation}->{'Workorder'} = 'Workorder';
    $Self->{Translation}->{'Show details'} = 'Details anzeigen';
    $Self->{Translation}->{'Show workorder'} = 'Workorder anzeigen';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of'} = 'Detailierte Historien-Informationen von';
    $Self->{Translation}->{'Modified'} = 'Modifiziert';
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

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = 'Möchten Sie diesen Change wirklich zurücksetzen?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(z. B. 10*5155 or 105658*)';
    $Self->{Translation}->{'CABAgent'} = 'CAB Agent';
    $Self->{Translation}->{'e.g.'} = 'z. B.';
    $Self->{Translation}->{'CABCustomer'} = 'CAB Kunde';
    $Self->{Translation}->{'ITSM Workorder'} = 'Workorder';
    $Self->{Translation}->{'Instruction'} = 'Anweisung';
    $Self->{Translation}->{'Report'} = 'Bericht';
    $Self->{Translation}->{'Change Category'} = 'Change-Kategorie';
    $Self->{Translation}->{'(before/after)'} = '(vor/nach)';
    $Self->{Translation}->{'(between)'} = '(zwischen)';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Speichere Change als Vorlage';
    $Self->{Translation}->{'A template should have a name!'} = 'Eine Vorlage benötigt einen Namen!';
    $Self->{Translation}->{'The template name is required.'} = 'Der Vorlagen-Name ist erforderlich.';
    $Self->{Translation}->{'Reset States'} = 'Setze Status zurück';
    $Self->{Translation}->{'Overwrite original template'} = 'Original-Template überschreiben';
    $Self->{Translation}->{'Delete original change'} = 'Original-Change löschen';

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
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Um die Links im folgenden Beitrag zu öffnen, kann es notwendig sein Strg oder Shift zu drücken, während auf den Link geklickt wird (abhängig vom verwendeten Browser und Betriebssystem).';
    $Self->{Translation}->{'Download Attachment'} = 'Anhang herunterladen';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = 'Möchten Sie diese Vorlage wirklich löschen?';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = 'CAB-Template bearbeiten';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        'Dieses wird einen neuen Change aus diesem Template erstellen, Sie können diesen editieren und speichern.';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        'Der neue Change wird automatisch gelöscht, nachdem dieser als Template gespeichert wurde.';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        'Dieses wird eine neue Workorder aus diesem Template erstellen, Sie können diese editieren und speichern.';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        'Ein temporärer Change wird erstellt, der die Workorder enthält.';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        'Der temporäre Change und die neue Workorder wird automatisch gelöscht, nachdem die Workorder als Template gespeichert wurde.';
    $Self->{Translation}->{'Do you want to proceed?'} = 'Möchten Sie fortfahren?';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = 'Template-ID';
    $Self->{Translation}->{'Edit Content'} = 'Inhalt bearbeiten';
    $Self->{Translation}->{'CreateBy'} = 'Erstellt von';
    $Self->{Translation}->{'CreateTime'} = 'Erstellt';
    $Self->{Translation}->{'ChangeBy'} = 'Geändert von';
    $Self->{Translation}->{'ChangeTime'} = 'Geändert';
    $Self->{Translation}->{'Edit Template Content'} = 'Vorlageninhalt bearbeiten';
    $Self->{Translation}->{'Delete Template'} = 'Vorlage Löschen';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = 'Workorder hinzufügen zu';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Ungültiger Workorder-Typ';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'Der geplante Start muss vor dem geplanten Ende liegen!';
    $Self->{Translation}->{'Invalid format.'} = 'Ungültiges Format.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Workorder-Vorlage auswählen';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Möchten Sie diese Workorder wirklich löschen?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Sie können diese Workorder nicht löschen. Sie wird in mindestens einer Bedingung verwendet!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Diese Workorder findet Verwendung in den folgenden Bedingung(en)';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = 'Nachfolgende Workorders entsprechend verschieben';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        'Wenn die gepplante Endzeit einer Workorder geändert wird, dann werden die nachfolgenden Workorders entsprechend verschoben';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'Die tatsächliche Startzeit muss vor der tatsächlichen Endzeit liegen!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'Die tatsächliche Startzeit muss angegeben wreden, wenn eine tatsächliche Endzeit angegeben wurde!';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Aktueller Agent';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Wollen sie diese Workorder wirklich übernehmen?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Speichere Workorder als Vorlage';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = 'Löschen der Original-Workorder (und der umgebenden Changes)';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Workorder-Informationen';

    # Perl Module: Kernel/Modules/AdminITSMChangeNotification.pm
    $Self->{Translation}->{'Unknown notification %s!'} = '';
    $Self->{Translation}->{'There was an error creating the notification.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChange.pm
    $Self->{Translation}->{'Overview: ITSM Changes'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeAdd.pm
    $Self->{Translation}->{'Ticket with TicketID %s does not exist!'} = '';
    $Self->{Translation}->{'Missing sysconfig option "ITSMChange::AddChangeLinkTicketTypes"!'} =
        '';
    $Self->{Translation}->{'Was not able to add change!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeAddFromTemplate.pm
    $Self->{Translation}->{'Was not able to create change from template!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeCABTemplate.pm
    $Self->{Translation}->{'No ChangeID is given!'} = '';
    $Self->{Translation}->{'No change found for changeID %s.'} = '';
    $Self->{Translation}->{'The CAB of change "%s" could not be serialized.'} = '';
    $Self->{Translation}->{'Could not add the template.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeCondition.pm
    $Self->{Translation}->{'Change "%s" not found in database!'} = '';
    $Self->{Translation}->{'Could not delete ConditionID %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeConditionEdit.pm
    $Self->{Translation}->{'No %s is given!'} = '';
    $Self->{Translation}->{'Could not create new condition!'} = '';
    $Self->{Translation}->{'Could not update ConditionID %s!'} = '';
    $Self->{Translation}->{'Could not update ExpressionID %s!'} = '';
    $Self->{Translation}->{'Could not add new Expression!'} = '';
    $Self->{Translation}->{'Could not update ActionID %s!'} = '';
    $Self->{Translation}->{'Could not add new Action!'} = '';
    $Self->{Translation}->{'Could not delete ExpressionID %s!'} = '';
    $Self->{Translation}->{'Could not delete ActionID %s!'} = '';
    $Self->{Translation}->{'Error: Unknown field type "%s"!'} = '';
    $Self->{Translation}->{'ConditionID %s does not belong to the given ChangeID %s!'} = '';
    $Self->{Translation}->{'Please contact the administrator.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeDelete.pm
    $Self->{Translation}->{'Change "%s" does not have an allowed change state to be deleted!'} =
        '';
    $Self->{Translation}->{'Was not able to delete the changeID %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeEdit.pm
    $Self->{Translation}->{'Was not able to update Change!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ChangeID is given!'} = '';
    $Self->{Translation}->{'Change "%s" not found in the database!'} = '';
    $Self->{Translation}->{'Unknown type "%s" encountered!'} = '';
    $Self->{Translation}->{'Change History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistoryZoom.pm
    $Self->{Translation}->{'Can\'t show history zoom, no HistoryEntryID is given!'} = '';
    $Self->{Translation}->{'HistoryEntry "%s" not found in database!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeInvolvedPersons.pm
    $Self->{Translation}->{'Was not able to update Change CAB for Change %s!'} = '';
    $Self->{Translation}->{'Was not able to update Change %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeManager.pm
    $Self->{Translation}->{'Overview: ChangeManager'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyCAB.pm
    $Self->{Translation}->{'Overview: My CAB'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyChanges.pm
    $Self->{Translation}->{'Overview: My Changes'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyWorkOrders.pm
    $Self->{Translation}->{'Overview: My Workorders'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePIR.pm
    $Self->{Translation}->{'Overview: PIR'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePSA.pm
    $Self->{Translation}->{'Overview: PSA'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePrint.pm
    $Self->{Translation}->{'WorkOrder "%s" not found in database!'} = '';
    $Self->{Translation}->{'Can\'t create output, as the workorder is not attached to a change!'} =
        '';
    $Self->{Translation}->{'Can\'t create output, as no ChangeID is given!'} = '';
    $Self->{Translation}->{'unknown change title'} = '';
    $Self->{Translation}->{'unknown workorder title'} = '';
    $Self->{Translation}->{'ITSM Workorder Overview (%s)'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeReset.pm
    $Self->{Translation}->{'Was not able to reset WorkOrder %s of Change %s!'} = '';
    $Self->{Translation}->{'Was not able to reset Change %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSchedule.pm
    $Self->{Translation}->{'Overview: Change Schedule'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSearch.pm
    $Self->{Translation}->{'Change Search'} = '';
    $Self->{Translation}->{'WorkOrders'} = 'Workorder';
    $Self->{Translation}->{'Change Search Result'} = '';
    $Self->{Translation}->{'Change Number'} = '';
    $Self->{Translation}->{'Change Title'} = '';
    $Self->{Translation}->{'Work Order Title'} = '';
    $Self->{Translation}->{'CAB Agent'} = '';
    $Self->{Translation}->{'CAB Customer'} = '';
    $Self->{Translation}->{'Change Description'} = 'Änderungsbeschreibung';
    $Self->{Translation}->{'Change Justification'} = '';
    $Self->{Translation}->{'WorkOrder Instruction'} = '';
    $Self->{Translation}->{'WorkOrder Report'} = '';
    $Self->{Translation}->{'Change Priority'} = 'Änderungspriorität';
    $Self->{Translation}->{'Change Impact'} = '';
    $Self->{Translation}->{'Change State'} = 'Änderungsstatus';
    $Self->{Translation}->{'Created By'} = '';
    $Self->{Translation}->{'WorkOrder State'} = '';
    $Self->{Translation}->{'WorkOrder Type'} = '';
    $Self->{Translation}->{'WorkOrder Agent'} = '';
    $Self->{Translation}->{'Planned Start Time'} = 'Geplante Startzeit';
    $Self->{Translation}->{'Planned End Time'} = 'Geplante Endzeit';
    $Self->{Translation}->{'Actual Start Time'} = 'Tatsächliche Startzeit';
    $Self->{Translation}->{'Actual End Time'} = 'Tatsächliche Endzeit';
    $Self->{Translation}->{'Change Time'} = '';
    $Self->{Translation}->{'before'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeTemplate.pm
    $Self->{Translation}->{'The change "%s" could not be serialized.'} = '';
    $Self->{Translation}->{'Could not update the template "%s".'} = '';
    $Self->{Translation}->{'Could not delete change "%s".'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeTimeSlot.pm
    $Self->{Translation}->{'The change can\'t be moved, as it has no workorders.'} = '';
    $Self->{Translation}->{'Add a workorder first.'} = '';
    $Self->{Translation}->{'Can\'t move a change which already has started!'} = '';
    $Self->{Translation}->{'Please move the individual workorders instead.'} = '';
    $Self->{Translation}->{'The current %s could not be determined.'} = '';
    $Self->{Translation}->{'The %s of all workorders has to be defined.'} = '';
    $Self->{Translation}->{'Was not able to move time slot for workorder #%s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateDelete.pm
    $Self->{Translation}->{'You need %s permission!'} = '';
    $Self->{Translation}->{'No TemplateID is given!'} = '';
    $Self->{Translation}->{'Template "%s" not found in database!'} = '';
    $Self->{Translation}->{'Was not able to delete the template %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEdit.pm
    $Self->{Translation}->{'Was not able to update Template %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditCAB.pm
    $Self->{Translation}->{'Was not able to update Template "%s"!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditContent.pm
    $Self->{Translation}->{'Was not able to create change!'} = '';
    $Self->{Translation}->{'Was not able to create workorder from template!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateOverview.pm
    $Self->{Translation}->{'Overview: Template'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAdd.pm
    $Self->{Translation}->{'You need %s permissions on the change!'} = '';
    $Self->{Translation}->{'Was not able to add workorder!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAgent.pm
    $Self->{Translation}->{'No WorkOrderID is given!'} = '';
    $Self->{Translation}->{'Was not able to set the workorder agent of the workorder "%s" to empty!'} =
        '';
    $Self->{Translation}->{'Was not able to update the workorder "%s"!'} = '';
    $Self->{Translation}->{'Could not find Change for WorkOrder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderDelete.pm
    $Self->{Translation}->{'Was not able to delete the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderEdit.pm
    $Self->{Translation}->{'Was not able to update WorkOrder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no WorkOrderID is given!'} = '';
    $Self->{Translation}->{'WorkOrder "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrderHistory::'} = '';
    $Self->{Translation}->{'WorkOrder History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistoryZoom.pm
    $Self->{Translation}->{'History entry "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrder History Zoom'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTake.pm
    $Self->{Translation}->{'Was not able to take the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTemplate.pm
    $Self->{Translation}->{'The workorder "%s" could not be serialized.'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyWorkOrders.pm
    $Self->{Translation}->{'My Work Orders'} = 'Meine Arbeitsaufträge';

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        '';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        '';
    $Self->{Translation}->{'Add a change from template.'} = '';
    $Self->{Translation}->{'Add a change.'} = '';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = '';
    $Self->{Translation}->{'Admin of the state machine.'} = '';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        '';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        '';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        '';
    $Self->{Translation}->{'Agent interface notification module to see the number of workorders.'} =
        '';
    $Self->{Translation}->{'CAB Member Search'} = '';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        '';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        '';
    $Self->{Translation}->{'Change CAB Templates'} = '';
    $Self->{Translation}->{'Change History.'} = '';
    $Self->{Translation}->{'Change Involved Persons.'} = '';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = '';
    $Self->{Translation}->{'Change Overview.'} = '';
    $Self->{Translation}->{'Change Print.'} = '';
    $Self->{Translation}->{'Change Schedule.'} = '';
    $Self->{Translation}->{'Change Zoom.'} = '';
    $Self->{Translation}->{'Change and WorkOrder templates edited by this user.'} = '';
    $Self->{Translation}->{'Change area.'} = '';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small"'} = '';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = '';
    $Self->{Translation}->{'Condition Overview'} = '';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        '';
    $Self->{Translation}->{'Create a change (from template) from this ticket!'} = '';
    $Self->{Translation}->{'Create and manage ITSM Change Management notifications.'} = '';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        '';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        '';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = '';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = '';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = '';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = '';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        '';
    $Self->{Translation}->{'Defines if the change state can be set in AgentITSMChangeEdit.'} =
        '';
    $Self->{Translation}->{'Defines if the planned effort should be shown.'} = '';
    $Self->{Translation}->{'Defines if the requested date should be print by customer.'} = '';
    $Self->{Translation}->{'Defines if the requested date should be searched by customer.'} =
        '';
    $Self->{Translation}->{'Defines if the requested date should be set by customer.'} = '';
    $Self->{Translation}->{'Defines if the requested date should be shown by customer.'} = '';
    $Self->{Translation}->{'Defines if the workorder state should be shown.'} = '';
    $Self->{Translation}->{'Defines if the workorder title should be shown.'} = '';
    $Self->{Translation}->{'Defines shown graph attributes.'} = '';
    $Self->{Translation}->{'Defines that only changes containing Workorders linked with services, which the customer user has permission to use will be shown. Any other changes will not be displayed.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change PSA overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change Schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyCAB overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyChanges overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change manager overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the customer change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default change title for a dummy change which is needed to edit a workorder template.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria in the change PSA overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria in the change manager overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria in the change overview.'} = '';
    $Self->{Translation}->{'Defines the default sort criteria in the change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyCAB overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyChanges overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyWorkorders overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the PIR overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the customer change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the template overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the MyCAB overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the MyChanges overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the MyWorkorders overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the PIR overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the change PSA overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the change manager overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the change overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the customer change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the template overview.'} = '';
    $Self->{Translation}->{'Defines the default value for the category of a change.'} = '';
    $Self->{Translation}->{'Defines the default value for the impact of a change.'} = '';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for change attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        '';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for workorder attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        '';
    $Self->{Translation}->{'Defines the object attributes that are selectable for change objects in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the object attributes that are selectable for workorder objects in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute AccountedTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualEndTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualStartTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute CategoryID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeBuilderID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeManagerID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeStateID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeTitle in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute DynamicField in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ImpactID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEffort in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEndTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedStartTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PriorityID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute RequestedTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderAgentID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderNumber in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderStateID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTitle in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTypeID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the period (in years), in which start and end times can be selected.'} =
        '';
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom. To show workorder dynamic fields in the tooltip, they must be specified like DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, etc.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the Change PSA overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the Change Schedule overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the MyCAB overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the MyChanges overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the MyWorkorders overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the PIR overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the change manager overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the change overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the change search. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the customer change schedule overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the template overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the signals for each ITSMChange state.'} = '';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        '';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        '';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        '';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        '';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = '';
    $Self->{Translation}->{'Delete Change'} = '';
    $Self->{Translation}->{'Delete a change.'} = '';
    $Self->{Translation}->{'Details of a change history entry.'} = '';
    $Self->{Translation}->{'Determines if an agent can exchange the X-axis of a stat if he generates one.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes done for config item classes.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding change state updates within a timeperiod.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding the relation between changes and incident tickets.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about the number of Rfc tickets a requester created.'} =
        '';
    $Self->{Translation}->{'Dynamic fields (for changes and workorders) shown in the change print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change add screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change edit screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder add screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder edit screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder report screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'DynamicField event module to handle the update of conditions if dynamic fields are added, updated or deleted.'} =
        '';
    $Self->{Translation}->{'Edit a change.'} = '';
    $Self->{Translation}->{'Forward schedule of changes. Overview over approved changes.'} =
        '';
    $Self->{Translation}->{'History Zoom'} = '';
    $Self->{Translation}->{'ITSM Change CAB Templates.'} = '';
    $Self->{Translation}->{'ITSM Change Condition Edit.'} = '';
    $Self->{Translation}->{'ITSM Change Condition Overview.'} = '';
    $Self->{Translation}->{'ITSM Change Management Notifications'} = '';
    $Self->{Translation}->{'ITSM Change Manager Overview.'} = '';
    $Self->{Translation}->{'ITSM Change PIR Overview.'} = '';
    $Self->{Translation}->{'ITSM Change notification rules'} = '';
    $Self->{Translation}->{'ITSM MyCAB Overview.'} = '';
    $Self->{Translation}->{'ITSM MyChanges Overview.'} = '';
    $Self->{Translation}->{'ITSM MyWorkorders Overview.'} = '';
    $Self->{Translation}->{'ITSM Template Delete.'} = '';
    $Self->{Translation}->{'ITSM Template Edit CAB.'} = '';
    $Self->{Translation}->{'ITSM Template Edit Content.'} = '';
    $Self->{Translation}->{'ITSM Template Edit.'} = '';
    $Self->{Translation}->{'ITSM Template Overview.'} = '';
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = '';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = '';
    $Self->{Translation}->{'ITSM event module that deletes the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        '';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = '';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module that updates the history of conditions.'} = '';
    $Self->{Translation}->{'ITSM event module that updates the history of workorders.'} = '';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = '';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        '';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notifications are sent (every X hours).'} =
        '';
    $Self->{Translation}->{'Logfile for the ITSM change counter. This file is used for creating the change numbers.'} =
        '';
    $Self->{Translation}->{'Lookup of CAB members for autocompletion.'} = '';
    $Self->{Translation}->{'Lookup of agents, used for autocompletion.'} = '';
    $Self->{Translation}->{'Module to check if WorkOrderAdd or WorkOrderAddFromTemplate should be permitted.'} =
        '';
    $Self->{Translation}->{'Module to check the CAB members.'} = '';
    $Self->{Translation}->{'Module to check the agent.'} = '';
    $Self->{Translation}->{'Module to check the change builder.'} = '';
    $Self->{Translation}->{'Module to check the change manager.'} = '';
    $Self->{Translation}->{'Module to check the workorder agent.'} = '';
    $Self->{Translation}->{'Module to check whether no workorder agent is set.'} = '';
    $Self->{Translation}->{'Module to check whether the agent is contained in the configured list.'} =
        '';
    $Self->{Translation}->{'Module to show a link to create a change from this ticket. The ticket will be automatically linked with the new change.'} =
        '';
    $Self->{Translation}->{'Move Time Slot.'} = '';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        '';
    $Self->{Translation}->{'Overview over all Changes.'} = '';
    $Self->{Translation}->{'PSA'} = '';
    $Self->{Translation}->{'Parameters for the UserCreateWorkOrderNextMask object in the preference view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        '';
    $Self->{Translation}->{'Presents a link in the menu to show the involved persons in a change, in the zoom view of such change in the agent interface.'} =
        '';
    $Self->{Translation}->{'Projected Service Availability (PSA)'} = '';
    $Self->{Translation}->{'Projected Service Availability (PSA) of changes. Overview of approved changes and their services.'} =
        '';
    $Self->{Translation}->{'Required privileges in order for an agent to take a workorder.'} =
        '';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = '';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = '';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = '';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        '';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = '';
    $Self->{Translation}->{'Required privileges to create changes.'} = '';
    $Self->{Translation}->{'Required privileges to delete a template.'} = '';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to delete changes.'} = '';
    $Self->{Translation}->{'Required privileges to edit a template.'} = '';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to edit changes.'} = '';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = '';
    $Self->{Translation}->{'Required privileges to edit the content of a template.'} = '';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        '';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = '';
    $Self->{Translation}->{'Required privileges to print a change.'} = '';
    $Self->{Translation}->{'Required privileges to reset changes.'} = '';
    $Self->{Translation}->{'Required privileges to view a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to view changes.'} = '';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is a CAB member.'} =
        '';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is the change manager.'} =
        '';
    $Self->{Translation}->{'Required privileges to view overview over all templates.'} = '';
    $Self->{Translation}->{'Required privileges to view the conditions of changes.'} = '';
    $Self->{Translation}->{'Required privileges to view the history of a change.'} = '';
    $Self->{Translation}->{'Required privileges to view the history of a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to view the history zoom of a change.'} = '';
    $Self->{Translation}->{'Required privileges to view the history zoom of a workorder.'} =
        '';
    $Self->{Translation}->{'Required privileges to view the list of Change Schedule.'} = '';
    $Self->{Translation}->{'Required privileges to view the list of change PSA.'} = '';
    $Self->{Translation}->{'Required privileges to view the list of changes with an upcoming PIR (Post Implementation Review).'} =
        '';
    $Self->{Translation}->{'Required privileges to view the list of own changes.'} = '';
    $Self->{Translation}->{'Required privileges to view the list of own workorders.'} = '';
    $Self->{Translation}->{'Required privileges to write a report for the workorder.'} = '';
    $Self->{Translation}->{'Reset a change and its workorders.'} = '';
    $Self->{Translation}->{'Reset change and its workorders'} = '';
    $Self->{Translation}->{'Run task to check if specific times have been reached in changes and workorders.'} =
        '';
    $Self->{Translation}->{'Screen after creating a workorder'} = '';
    $Self->{Translation}->{'Search Changes.'} = '';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        '';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in AgentITSMChangeZoom and AgentITSMWorkOrderZoom.'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in AgentITSMChangeZoom and AgentITSMWorkOrderZoom.'} =
        '';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        '';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = '';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = '';
    $Self->{Translation}->{'Show this screen after I created a new workorder'} = '';
    $Self->{Translation}->{'Shows a checkbox in the AgentITSMWorkOrderEdit screen that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the workorder agent, in the zoom view of such workorder of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a workorder as a template in the zoom view of the workorder, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workorder, in the zoom view of such workorder of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a workorder with another object in the zoom view of such workorder of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows moving the time slot of a change in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows taking a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the conditions of a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to add a workorder in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to delete a workorder in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the workorder zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        '';
    $Self->{Translation}->{'State Machine'} = '';
    $Self->{Translation}->{'Stores change and workorder ids and their corresponding template id, while a user is editing a template.'} =
        '';
    $Self->{Translation}->{'Take Workorder.'} = '';
    $Self->{Translation}->{'Template.'} = '';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        '';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        '';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        '';
    $Self->{Translation}->{'Time Slot'} = '';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        '';
    $Self->{Translation}->{'User Search'} = '';
    $Self->{Translation}->{'Workorder Add (from template).'} = '';
    $Self->{Translation}->{'Workorder Add.'} = '';
    $Self->{Translation}->{'Workorder Agent.'} = '';
    $Self->{Translation}->{'Workorder Delete.'} = '';
    $Self->{Translation}->{'Workorder Edit.'} = '';
    $Self->{Translation}->{'Workorder History Zoom.'} = '';
    $Self->{Translation}->{'Workorder History.'} = '';
    $Self->{Translation}->{'Workorder Report.'} = '';
    $Self->{Translation}->{'Workorder Zoom.'} = '';
    $Self->{Translation}->{'once'} = '';
    $Self->{Translation}->{'regularly'} = '';

}

1;
