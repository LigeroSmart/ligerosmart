# --
# Kernel/Language/de_ITSMChangeManagement.pm - the german translation of ITSMChangeManagement
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: de_ITSMChangeManagement.pm,v 1.74 2010-05-18 13:54:31 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ITSMChangeManagement;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.74 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    # misc
    $Lang->{'A change must have a title!'}          = 'Ein Change benötigt einen Titel!';
    $Lang->{'Template Name'}                        = 'Vorlagen-Name';
    $Lang->{'Templates'}                            = 'Vorlagen';
    $Lang->{'A workorder must have a title!'}       = 'Eine Workorder benötigt einen Titel!';
    $Lang->{'Clear'}                                = 'Lösche';
    $Lang->{'Create a change from this ticket!'}    = 'Einen Change aus diesem Ticket erstellen!';
    $Lang->{'Create Change'}                        = 'Change erstellen';
    $Lang->{'e.g.'}                                 = 'z. B.';
    $Lang->{'Save Change as template'}              = 'Speichere Change als Vorlage';
    $Lang->{'Save Workorder as template'}           = 'Speichere Workorder als Vorlage';
    $Lang->{'Save Change CAB as template'}          = 'Speichere Change CAB als Vorlage';
    $Lang->{'New time'}                             = 'Neue Zeit';
    $Lang->{'Requested (by customer) Date'}         = 'Wunschtermin (des Kunden)';
    $Lang->{'The planned end time is invalid!'}     = 'Die geplante Endzeit ist ungültig!';
    $Lang->{'The planned start time is invalid!'}   = 'Die geplante Startzeit ist ungültig!';
    $Lang->{'The planned start time must be before the planned end time!'}
        = 'Der geplante Start muss vor dem geplanten Ende liegen!';
    $Lang->{'The requested time is invalid!'}       = 'Die angegebene Zeit ist ungültig!';
    $Lang->{'Time type'}                            = 'Zeit-Typ';
    $Lang->{'Do you really want to delete this template?'} = 'Möchten Sie diese Vorlage wirklich löschen?';
    $Lang->{'Change Advisory Board'}                = 'Change Advisory Board';
    $Lang->{'CAB'}                                  = 'CAB';

    # ITSM ChangeManagement icons
    $Lang->{'My Changes'}                           = 'Meine Changes';
    $Lang->{'My Workorders'}                        = 'Meine Workorders';
    $Lang->{'PIR (Post Implementation Review)'}     = 'PIR (Post Implementation Review)';
    $Lang->{'PSA (Projected Service Availability)'} = 'PSA (Projected Service Availability)';
    $Lang->{'My CABs'}                              = 'Meine CABs';
    $Lang->{'Change Overview'}                      = 'Change Übersicht';
    $Lang->{'Template Overview'}                    = 'Vorlagen-Übersicht';
    $Lang->{'Search Changes'}                       = 'Suche Changes';

    # Change menu
    $Lang->{'ITSM Change'}                           = 'Change';
    $Lang->{'ITSM Workorder'}                        = 'Workorder';
    $Lang->{'Schedule'}                              = 'Schedule';
    $Lang->{'Involved Persons'}                      = 'Beteiligte Personen';
    $Lang->{'Add Workorder'}                         = 'Workorder hinzufügen';
    $Lang->{'Template'}                              = 'Vorlage';
    $Lang->{'Move Time Slot'}                        = 'Verschiebe Timeslot';
    $Lang->{'Print the change'}                      = 'Diesen Change drucken';
    $Lang->{'Edit the change'}                       = 'Diesen Change bearbeiten';
    $Lang->{'Change involved persons of the change'} = 'Bearbeite beteiligte Personen dieses Changes';
    $Lang->{'Add a workorder to the change'}         = 'Füge eine Workorder zu diesem Change hinzu';
    $Lang->{'Edit the conditions of the change'}     = 'Bearbeite die Bedingungen dieses Changes';
    $Lang->{'Link another object to the change'}     = 'Verknüpfe ein anderes Objekt mit diesem Change';
    $Lang->{'Save change as a template'}             = 'Speichere diesen Change als Vorlage';
    $Lang->{'Move all workorders in time'}           = 'Verschiebe alle Workorders um eine neue zeitliche Differenz';
    $Lang->{'Current CAB'}                           = 'Aktuelles CAB';
    $Lang->{'Add to CAB'}                            = 'Zum CAB hinzufügen';
    $Lang->{'Add CAB Template'}                      = 'Eine CAB-Vorlage hinzufügen';
    $Lang->{'Add Workorder to'}                      = 'Workorder hinzufügen zu';
    $Lang->{'Select Workorder Template'}             = 'Workorder-Vorlage auswählen';
    $Lang->{'Select Change Template'}                = 'Change-Vorlage auswählen';
    $Lang->{'The planned time is invalid!'}          = 'Der geplante Zeitraum ist ungültig!';

    # Workorder menu
    $Lang->{'Workorder'}                            = 'Workorder';
    $Lang->{'Save workorder as a template'}         = 'Speichere diese Workorder als Vorlage';
    $Lang->{'Link another object to the workorder'} = 'Verknüpfe ein anderes Objekt mit dieser Workorder';
    $Lang->{'Delete Workorder'}                     = 'Diese Workorder löschen';
    $Lang->{'Edit the workorder'}                   = 'Diese Workorder bearbeiten';
    $Lang->{'Print the workorder'}                  = 'Diese Workorder drucken';
    $Lang->{'Set the agent for the workorder'}      = 'Einen Agenten für diese Workorder auswählen';

    # Template menu
    $Lang->{'A template must have a name!'} = 'Eine Vorlage benötigt einen Namen!';

    # Change attributes as returned from ChangeGet(), or taken by ChangeUpdate()
    $Lang->{'AccountedTime'}    = 'Benötigte Zeit';
    $Lang->{'ActualEndTime'}    = 'Tatsächliches Ende';
    $Lang->{'ActualStartTime'}  = 'Tatsächlicher Start';
    $Lang->{'CABAgent'}         = 'CAB Agent';
    $Lang->{'CABAgents'}        = 'CAB Agents';
    $Lang->{'CABCustomer'}      = 'CAB Kunde';
    $Lang->{'CABCustomers'}     = 'CAB Kunden';
    $Lang->{'Category'}         = 'Kategorie';
    $Lang->{'ChangeBuilder'}    = 'Change Builder';
    $Lang->{'ChangeBy'}         = 'Geändert von';
    $Lang->{'ChangeManager'}    = 'Change Manager';
    $Lang->{'ChangeNumber'}     = 'Change Nummer';
    $Lang->{'ChangeTime'}       = 'Geändert';
    $Lang->{'ChangeState'}      = 'Change Status';
    $Lang->{'ChangeTitle'}      = 'Change Titel';
    $Lang->{'CreateBy'}         = 'Erstellt von';
    $Lang->{'CreateTime'}       = 'Erstellt';
    $Lang->{'Description'}      = 'Beschreibung';
    $Lang->{'Impact'}           = 'Auswirkung';
    $Lang->{'Justification'}    = 'Begründung';
    $Lang->{'PlannedEffort'}    = 'Geplanter Aufwand';
    $Lang->{'PlannedEndTime'}   = 'Geplantes Ende';
    $Lang->{'PlannedStartTime'} = 'Geplanter Start';
    $Lang->{'Priority'}         = 'Priorität';
    $Lang->{'RequestedTime'}    = 'Wunschtermin';

    # Workorder attributes as returned from WorkOrderGet(), or taken by WorkOrderUpdate()
    $Lang->{'Instruction'}      = 'Anweisung';
    $Lang->{'Report'}           = 'Bericht';
    $Lang->{'WorkOrderAgent'}   = 'Workorder Agent';
    $Lang->{'WorkOrderNumber'}  = 'Workorder Nummer';
    $Lang->{'WorkOrderState'}   = 'Workorder Status';
    $Lang->{'WorkOrderTitle'}   = 'Workorder Titel';
    $Lang->{'WorkOrderType'}    = 'Workorder Typ';

    # Change history
    $Lang->{'ChangeHistory::ChangeAdd'}              = 'Neuer Change (ID=%s)';
    $Lang->{'ChangeHistory::ChangeUpdate'}           = '%s: Neu: %s -> Alt: %s';
    $Lang->{'ChangeHistory::ChangeLinkAdd'}          = 'Link zu %s (ID=%s) hinzugefügt';
    $Lang->{'ChangeHistory::ChangeLinkDelete'}       = 'Link zu %s (ID=%s) gelöscht';
    $Lang->{'ChangeHistory::ChangeCABUpdate'}        = '%s: Neu: %s -> Alt: %s';
    $Lang->{'ChangeHistory::ChangeCABDelete'}        = 'CAB gelöscht %s';
    $Lang->{'ChangeHistory::ChangeAttachmentAdd'}    = 'Neuer Anhang: %s';
    $Lang->{'ChangeHistory::ChangeAttachmentDelete'} = 'Anhang gelöscht: %s';
    $Lang->{'ChangeHistory::ChangeNotificationSent'} = 'Benachrichtigung an %s geschickt (Event: %s)';

    # workorder history
    $Lang->{'WorkOrderHistory::WorkOrderAdd'}              = 'Neue Workorder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdate'}           = '%s: Neu: %s -> Alt: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAdd'}          = 'Link zu %s (ID=%s) hinzugefügt';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDelete'}       = 'Link to %s (ID=%s) gelöscht';
    $Lang->{'WorkOrderHistory::WorkOrderDelete'}           = 'Workorder (ID=%s) gelöscht';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAdd'}    = 'Neuer Anhang für Workorder: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Anhang von Workorder gelöscht: %s';
    $Lang->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'Benachrichtigung an %s geschickt (Event: %s)';

    # long workorder history
    $Lang->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'}              = 'Neue Workorder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'}           = '(ID=%s) %s: Neu: %s -> Alt: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'}          = '(ID=%s) Link zu %s (ID=%s) hinzugefügt';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'}       = '(ID=%s) Link to %s (ID=%s) gelöscht';
    $Lang->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'}           = 'Workorder (ID=%s) gelöscht';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'}    = '(ID=%s) Neuer Anhang für Workorder: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Anhang von Workorder gelöscht: %s';
    $Lang->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '(ID=%s) Benachrichtigung an %s geschickt (Event: %s)';

    # condition history
    $Lang->{'ChangeHistory::ConditionAdd'}       = '%s: %s';
    $Lang->{'ChangeHistory::ConditionAddID'}     = 'Neue Bedingung (ID=%s)';
    $Lang->{'ChangeHistory::ConditionUpdate'}    = '%s (Bedingung ID=%s): Neu: %s -> Old: %s';
    $Lang->{'ChangeHistory::ConditionDelete'}    = 'Bedingung (ID=%s) gelöscht';
    $Lang->{'ChangeHistory::ConditionDeleteAll'} = 'Alle Bedingungen von Change (ID=%s) gelöscht';

    # expression history
    $Lang->{'ChangeHistory::ExpressionAdd'}       = '%s: %s';
    $Lang->{'ChangeHistory::ExpressionAddID'}     = 'Neue Expression (ID=%s)';
    $Lang->{'ChangeHistory::ExpressionUpdate'}    = '%s (Expression ID=%s): Neu: %s -> Old: %s';
    $Lang->{'ChangeHistory::ExpressionDelete'}    = 'Expression (ID=%s) gelöscht';
    $Lang->{'ChangeHistory::ExpressionDeleteAll'} = 'Alle logischen Ausdrücke von Bedingung (ID=%s) gelöscht';

    # action history
    $Lang->{'ChangeHistory::ActionAdd'}       = '%s: %s';
    $Lang->{'ChangeHistory::ActionAddID'}     = 'Neue Action (ID=%s)';
    $Lang->{'ChangeHistory::ActionUpdate'}    = '%s (Action ID=%s): Neu: %s -> Old: %s';
    $Lang->{'ChangeHistory::ActionDelete'}    = 'Action (ID=%s) gelöscht';
    $Lang->{'ChangeHistory::ActionDeleteAll'} = 'Alle Aktionen von Bedingung (ID=%s) gelöscht';
    $Lang->{'ChangeHistory::ActionExecute'}   = 'Aktion (ID=%s) ausgeführt: %s';
    $Lang->{'ActionExecute::successfully'}    = 'erfolgreich';
    $Lang->{'ActionExecute::unsuccessfully'}  = 'nicht erfolgreich';

    # history for time events
    $Lang->{'ChangeHistory::ChangePlannedStartTimeReached'}                      = 'Change (ID=%s) hat geplante Startzeit erreicht.';
    $Lang->{'ChangeHistory::ChangePlannedEndTimeReached'}                        = 'Change (ID=%s) hat geplante Endzeit erreicht.';
    $Lang->{'ChangeHistory::ChangeActualStartTimeReached'}                       = 'Change (ID=%s) hat begonnen.';
    $Lang->{'ChangeHistory::ChangeActualEndTimeReached'}                         = 'Change (ID=%s) wurde beendet.';
    $Lang->{'ChangeHistory::ChangeRequestedTimeReached'}                         = 'Change (ID=%s) hat gewünschte Endzeit erreicht.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'}                = 'Workorder (ID=%s) hat geplante Startzeit erreicht.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'}                  = 'Workorder (ID=%s) hat geplante Endzeit erreicht.';
    $Lang->{'WorkOrderHistory::WorkOrderActualStartTimeReached'}                 = 'Workorder (ID=%s) hat begonnen.';
    $Lang->{'WorkOrderHistory::WorkOrderActualEndTimeReached'}                   = 'Workorder (ID=%s) wurde beendet.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} = 'Workorder (ID=%s) hat geplante Startzeit erreicht.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'}   = 'Workorder (ID=%s) hat geplante Endzeit erreicht.';
    $Lang->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'}  = 'Workorder (ID=%s) hat begonnen.';
    $Lang->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'}    = 'Workorder (ID=%s) wurde beendet.';

    # change states
    $Lang->{'requested'}        = 'Requested';
    $Lang->{'pending approval'} = 'Pending Approval';
    $Lang->{'pending pir'}      = 'Pending PIR';
    $Lang->{'rejected'}         = 'Rejected';
    $Lang->{'approved'}         = 'Approved';
    $Lang->{'in progress'}      = 'In Progress';
    $Lang->{'successful'}       = 'Successful';
    $Lang->{'failed'}           = 'Failed';
    $Lang->{'canceled'}         = 'Canceled';
    $Lang->{'retracted'}        = 'Retracted';

    # workorder states
    $Lang->{'created'}     = 'Created';
    $Lang->{'accepted'}    = 'Accepted';
    $Lang->{'ready'}       = 'Ready';
    $Lang->{'in progress'} = 'In Progress';
    $Lang->{'closed'}      = 'Closed';
    $Lang->{'canceled'}    = 'Canceled';

    # Admin Interface
    $Lang->{'Category <-> Impact <-> Priority'}      = 'Kategorie <-> Auswirkung <-> Priorität';
    $Lang->{'Notification (ITSM Change Management)'} = 'Benachrichtigung (ITSM Change Management)';

    # Admin StateMachine
    $Lang->{'Add a state transition'}               = 'Hinzufügen eines Status-Übergangs';
    $Lang->{'Add a new state transition for'}       = 'Hinzufügen eines neuen Status-Übergangs für';
    $Lang->{'Edit a state transition for'}          = 'Bearbeiten eines Status-Übergangs für';
    $Lang->{'Overview over state transitions for'}  = 'Übersicht über Status-Übergänge für';
    $Lang->{'Object Name'}                          = 'Objekt Name';
    $Lang->{'Please select first a catalog class!'} = 'Bitte wählen Sie zuerst eine Katalog Klasse aus!';

    # workorder types
    $Lang->{'approval'}  = 'Genehmigung';
    $Lang->{'decision'}  = 'Entscheidung';
    $Lang->{'workorder'} = 'Workorder';
    $Lang->{'backout'}   = 'Backout Plan';
    $Lang->{'pir'}       = 'PIR (Post Implementation Review)';

    # objects that can be used in condition expressions and actions
    $Lang->{'ITSMChange'}    = 'Change';
    $Lang->{'ITSMWorkOrder'} = 'Workorder';
    $Lang->{'ITSMCondition'} = 'Bedingung';

    # Overviews
    $Lang->{'Change Schedule'} = 'Change Schedule';

    # Workorder delete
    $Lang->{'Do you really want to delete this workorder?'} = 'Möchten Sie diese Workorder wirklich löschen?';
    $Lang->{'You can not delete this Workorder. It is used in at least one Condition!'} = 'Sie können diese Workorder nicht löschen. Sie wird in mindestens einer Bedingung verwendet!';
    $Lang->{'This Workorder is used in the following Condition(s)'} = 'Diese Workorder findet Verwendung in den folgenden Bedingung(en)';

    # Take workorder
    $Lang->{'Imperative::Take Workorder'}                 = 'Übernehmen von Workorder';
    $Lang->{'Take Workorder'}                             = 'Workorder übernehmen';
    $Lang->{'Take the workorder'}                         = 'Diese Workorder übernehmen';
    $Lang->{'Current Agent'}                              = 'Aktueller Agent';
    $Lang->{'Do you really want to take this workorder?'} = 'Wollen sie diese Workorder wirklich übernehmen?';

    # Condition Overview and Edit
    $Lang->{'Condition'}                                = 'Bedingung';
    $Lang->{'Conditions'}                               = 'Bedingungen';
    $Lang->{'Expression'}                               = 'Logischer Ausdruck';
    $Lang->{'Expressions'}                              = 'Logische Ausdrücke';
    $Lang->{'Action'}                                   = 'Aktion';
    $Lang->{'Actions'}                                  = 'Aktionen';
    $Lang->{'Matching'}                                 = 'Übereinstimmung';
    $Lang->{'Conditions and Actions'}                   = 'Bedingungen und Aktionen';
    $Lang->{'Add new condition and action pair'}        = 'Füge ein neues Bedingungs- und Aktions-Paar hinzu';
    $Lang->{'A condition must have a name!'}            = 'Eine Bedingung benötigt einen Namen!';
    $Lang->{'Condition Edit'}                           = 'Bedingung bearbeiten';
    $Lang->{'Add new expression'}                       = 'Füge einen neuen logischen Ausdruck hinzu';
    $Lang->{'Add new action'}                           = 'Füge eine neue Aktion hinzu';
    $Lang->{'Any expression'}                           = 'Beliebiger logischer Ausdruck';
    $Lang->{'All expressions'}                          = 'Alle logischen Ausdrücke';
    $Lang->{'any'}                                      = 'beliebige';
    $Lang->{'all'}                                      = 'alle';
    $Lang->{'is'}                                       = 'ist';
    $Lang->{'is not'}                                   = 'ist nicht';
    $Lang->{'is empty'}                                 = 'ist leer';
    $Lang->{'is not empty'}                             = 'ist nicht leer';
    $Lang->{'is greater than'}                          = 'ist grösser als';
    $Lang->{'is less than'}                             = 'ist kleiner als';
    $Lang->{'is before'}                                = 'ist vor';
    $Lang->{'is after'}                                 = 'ist nach';
    $Lang->{'contains'}                                 = 'enthält';
    $Lang->{'not contains'}                             = 'enthält nicht';
    $Lang->{'begins with'}                              = 'beginnt mit';
    $Lang->{'ends with'}                                = 'endet mit';
    $Lang->{'set'}                                      = 'setze';
    $Lang->{'lock'}                                     = 'sperre';

    # Change Zoom
    $Lang->{'Change Initiator(s)'} = 'Change Initiator(s)';

    # AgentITSMChangePrint
    $Lang->{'Linked Objects'} = 'Verknüpfte Objekte';
    $Lang->{'Full-Text Search in Change and Workorder'} =
        'Volltextsuche in Change und Workorder';

    # AgentITSMChangeSearch
    $Lang->{'No XXX settings'} = "Keine '%s' Auswahl";

    return 1;
}

1;
