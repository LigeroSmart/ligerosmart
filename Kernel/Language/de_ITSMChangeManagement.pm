# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::de_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category ↔ Impact ↔ Priority'} = 'Kategorie ↔ Auswirkung ↔ Priorität';
    $Self->{Translation}->{'Manage the priority result of combinating Category ↔ Impact.'} =
        'Verwalten Sie das Prioritätsergebnis der Kombination von Kategorie ↔ Auswirkung.';
    $Self->{Translation}->{'Priority allocation'} = 'Priorität zuordnen';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'ITSM ChangeManagement Benachrichtigungs-Verwaltung';
    $Self->{Translation}->{'Add Notification Rule'} = 'Benachrichtigungs-Regel hinzufügen';
    $Self->{Translation}->{'Edit Notification Rule'} = 'Benachrichtigungs-Regel bearbeiten';
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
    $Self->{Translation}->{'Delete this state transition'} = 'Diesen Status-Übergang löschen';
    $Self->{Translation}->{'Add a new state transition for'} = 'Neuen Status-Übergang hinzufügen für';
    $Self->{Translation}->{'Please select a state!'} = 'Bitte wählen Sie einen Status!';
    $Self->{Translation}->{'Please select a next state!'} = 'Bitte wählen sie den Folge-Status!';
    $Self->{Translation}->{'Edit a state transition for'} = 'Einen Status-Übergang bearbeiten für';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Wollen Sie diesen Status-Übergang wirklich löschen?';

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'Change hinzufügen';
    $Self->{Translation}->{'ITSM Change'} = 'ITSM Change';
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
    $Self->{Translation}->{'Save Change CAB as template'} = 'Diesen Change-CAB als Vorlage speichern';
    $Self->{Translation}->{'go to involved persons screen'} = 'zur Ansicht "Beteiligte Personen" gehen';
    $Self->{Translation}->{'Invalid Name'} = 'Ungültiger Name';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Bedingungen und Aktionen';
    $Self->{Translation}->{'Delete Condition'} = 'Bedingung löschen';
    $Self->{Translation}->{'Add new condition'} = 'Bedingung hinzufügen';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Edit Condition'} = 'Bedingung bearbeiten';
    $Self->{Translation}->{'Need a valid name.'} = 'Ein gültiger Name ist erforderlich.';
    $Self->{Translation}->{'A valid name is needed.'} = 'Ein gültiger Name ist erforderlich.';
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
    $Self->{Translation}->{'Add new expression'} = 'Neuen logischen Ausdruck hinzufügen';
    $Self->{Translation}->{'Delete Action'} = 'Aktion löschen';
    $Self->{Translation}->{'No Actions found.'} = 'Keine Aktionen gefunden.';
    $Self->{Translation}->{'Add new action'} = 'Neue Aktion hinzufügen';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = 'Möchten Sie diesen Change wirklich löschen?';

    # Template: AgentITSMChangeEdit
    $Self->{Translation}->{'Edit %s%s'} = 'Bearbeiten %s%s';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of %s%s'} = 'Historie von %s%s';
    $Self->{Translation}->{'History Content'} = 'Änderungsverlauf';
    $Self->{Translation}->{'Workorder'} = 'Arbeitsauftrag';
    $Self->{Translation}->{'Createtime'} = 'Erstellt am';
    $Self->{Translation}->{'Show details'} = 'Details anzeigen';
    $Self->{Translation}->{'Show workorder'} = 'Arbeitsauftrag anzeigen';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of %s'} = 'Detaillierte Historie-Informationen von %s';
    $Self->{Translation}->{'Modified'} = 'Modifiziert';
    $Self->{Translation}->{'Old Value'} = 'Alter Wert';
    $Self->{Translation}->{'New Value'} = 'Neuer Wert';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Edit Involved Persons of %s%s'} = 'Beteiligte Personen von %s%s bearbeiten';
    $Self->{Translation}->{'Involved Persons'} = 'Beteiligte Personen';
    $Self->{Translation}->{'ChangeManager'} = 'Change-Manager';
    $Self->{Translation}->{'User invalid.'} = 'Ungültiger Benutzer';
    $Self->{Translation}->{'ChangeBuilder'} = 'ChangeBuilder';
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
    $Self->{Translation}->{'Workorder Title'} = 'Arbeitsauftrags-Titel';
    $Self->{Translation}->{'Change Title'} = 'Change-Titel';
    $Self->{Translation}->{'Workorder Agent'} = 'Arbeitsauftrags-Agent';
    $Self->{Translation}->{'Change Builder'} = 'Change-Builder';
    $Self->{Translation}->{'Change Manager'} = 'Change-Manager';
    $Self->{Translation}->{'Workorders'} = 'Arbeitsaufträge';
    $Self->{Translation}->{'Change State'} = 'Change-Status';
    $Self->{Translation}->{'Workorder State'} = 'Arbeitsauftrags-Status';
    $Self->{Translation}->{'Workorder Type'} = 'Arbeitsauftrags-Typ';
    $Self->{Translation}->{'Requested Time'} = 'Wunschtermin';
    $Self->{Translation}->{'Planned Start Time'} = 'Geplante Startzeit';
    $Self->{Translation}->{'Planned End Time'} = 'Geplante Endzeit';
    $Self->{Translation}->{'Actual Start Time'} = 'Tatsächliche Startzeit';
    $Self->{Translation}->{'Actual End Time'} = 'Tatsächliche Endzeit';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = 'Möchten Sie diesen Change wirklich zurücksetzen?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(z. B. 10*5155 or 105658*)';
    $Self->{Translation}->{'CAB Agent'} = 'CAB-Agent';
    $Self->{Translation}->{'e.g.'} = 'z. B.';
    $Self->{Translation}->{'CAB Customer'} = 'CAB-Kunde';
    $Self->{Translation}->{'ITSM Workorder Instruction'} = 'ITSM Arbeitsauftrags-Anweisung';
    $Self->{Translation}->{'ITSM Workorder Report'} = 'ITSM Arbeitsauftrags-Bericht';
    $Self->{Translation}->{'ITSM Change Priority'} = 'ITSM Change-Priorität';
    $Self->{Translation}->{'ITSM Change Impact'} = 'ITSM Change-Auswirkung';
    $Self->{Translation}->{'Change Category'} = 'ITSM Change-Kategorie';
    $Self->{Translation}->{'(before/after)'} = '(vor/nach)';
    $Self->{Translation}->{'(between)'} = '(zwischen)';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Change als Vorlage speichern';
    $Self->{Translation}->{'A template should have a name!'} = 'Eine Vorlage benötigt einen Namen!';
    $Self->{Translation}->{'The template name is required.'} = 'Der Vorlagen-Name ist erforderlich.';
    $Self->{Translation}->{'Reset States'} = 'Setze Status zurück';
    $Self->{Translation}->{'Overwrite original template'} = 'Originalvorlage überschreiben';
    $Self->{Translation}->{'Delete original change'} = 'Original-Change löschen';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Zeitfenster verschieben';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'Change-Informationen';
    $Self->{Translation}->{'Planned Effort'} = 'Geplanter Aufwand';
    $Self->{Translation}->{'Accounted Time'} = 'Gebuchte Zeit';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Charge-Initiator(en)';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Zuletzt geändert';
    $Self->{Translation}->{'Last changed by'} = 'Zuletzt geändert von';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Um die Links im folgenden Beitrag zu öffnen, kann es notwendig sein Strg oder Shift zu drücken, während auf den Link geklickt wird (abhängig vom verwendeten Browser und Betriebssystem).';
    $Self->{Translation}->{'Download Attachment'} = 'Anhang herunterladen';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = 'CAB-Vorlage bearbeiten';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        'Dies erstellt einen neuen Change aus dieser Vorlage, die Sie bearbeiten und speichern können.';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        'Der neue Change wird automatisch gelöscht, nachdem dieser als Vorlage gespeichert wurde.';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        'Dieses wird einen neuen Arbeitsauftrag aus dieser Vorlage erstellen, Sie können diese bearbeiten und speichern.';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        'Es wird ein temporärer Change erstellt, der den Arbeitsauftrag enthält.';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        'Der temporäre Change und der neue Arbeitsauftrag werden automatisch gelöscht, nachdem der Arbeitsauftrag als Vorlage gespeichert wurde.';
    $Self->{Translation}->{'Do you want to proceed?'} = 'Möchten Sie fortfahren?';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'Template ID'} = 'Vorlagen-ID';
    $Self->{Translation}->{'Edit Content'} = 'Inhalt bearbeiten';
    $Self->{Translation}->{'Create by'} = 'Erstellt von';
    $Self->{Translation}->{'Change by'} = 'Geändert von';
    $Self->{Translation}->{'Change Time'} = 'Zeit ändern';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to %s%s'} = 'Arbeitsauftrag zu %s%s hinzufügen';
    $Self->{Translation}->{'Instruction'} = 'Anweisung';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Ungültiger Arbeitsauftrags-Typ';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'Die geplante Startzeit muss vor der geplanten Endzeit liegen!';
    $Self->{Translation}->{'Invalid format.'} = 'Ungültiges Format.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Arbeitsauftrags-Vorlage auswählen';

    # Template: AgentITSMWorkOrderAgent
    $Self->{Translation}->{'Edit Workorder Agent of %s%s'} = 'Arbeitsauftrags-Agent von %s%s bearbeiten';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Möchten Sie diesen Arbeitsauftrag wirklich löschen?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Sie können diesen Arbeitsauftrag nicht löschen. Er wird in mindestens einer Bedingung verwendet!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Dieser Arbeitsauftrag findet Verwendung in den folgenden Bedingung(en)';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Edit %s%s-%s'} = 'Bearbeiten %s%s-%s';
    $Self->{Translation}->{'Move following workorders accordingly'} = 'Nachfolgende Arbeitsaufträge entsprechend verschieben';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        'Wenn die geplante Endzeit eines Arbeitsauftrags geändert wird, dann werden die nachfolgenden Arbeitsaufträge entsprechend verschoben';

    # Template: AgentITSMWorkOrderHistory
    $Self->{Translation}->{'History of %s%s-%s'} = 'Historie von %s%s-%s';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'Edit Report of %s%s-%s'} = 'Bericht von %s%s-%s bearbeiten';
    $Self->{Translation}->{'Report'} = 'Bericht';
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'Die tatsächliche Startzeit muss vor der tatsächlichen Endzeit liegen!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'Die tatsächliche Startzeit muss angegeben wreden, wenn eine tatsächliche Endzeit angegeben wurde!';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Aktueller Agent';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Wollen sie diesen Arbeitsauftrag wirklich übernehmen?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Arbeitsauftrag als Vorlage speichern';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = 'Original-Arbeitsauftrag (und den umgebenden Change) löschen';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Arbeitsauftrags-Informationen';

    # Perl Module: Kernel/Modules/AdminITSMChangeNotification.pm
    $Self->{Translation}->{'Notification Added!'} = 'Benachrichtigung hinzugefügt!';
    $Self->{Translation}->{'Unknown notification %s!'} = 'Unbekannte Benachrichtigung %s!';
    $Self->{Translation}->{'There was an error creating the notification.'} = 'Beim Erstellen der Benachrichtigung ist ein Fehler aufgetreten.';

    # Perl Module: Kernel/Modules/AdminITSMStateMachine.pm
    $Self->{Translation}->{'State Transition Updated!'} = 'Status-Übergang aktualisiert!';
    $Self->{Translation}->{'State Transition Added!'} = 'Status-Übergang hinzugefügt!';

    # Perl Module: Kernel/Modules/AgentITSMChange.pm
    $Self->{Translation}->{'Overview: ITSM Changes'} = 'Übersicht: ITSM Changes';

    # Perl Module: Kernel/Modules/AgentITSMChangeAdd.pm
    $Self->{Translation}->{'Ticket with TicketID %s does not exist!'} = 'Ticket mit Ticket-Nummer %s ist nicht vorhanden!';
    $Self->{Translation}->{'Missing sysconfig option "ITSMChange::AddChangeLinkTicketTypes"!'} =
        'Fehlende Systemkonfigurations-Option "ITSMChange::AddChangeLinkTicketTypes"!';
    $Self->{Translation}->{'Was not able to add change!'} = 'Konnte Change nicht hinzufügen!';

    # Perl Module: Kernel/Modules/AgentITSMChangeAddFromTemplate.pm
    $Self->{Translation}->{'Was not able to create change from template!'} = 'Konnte keinen Change aus Vorlage erstellen!';

    # Perl Module: Kernel/Modules/AgentITSMChangeCABTemplate.pm
    $Self->{Translation}->{'No ChangeID is given!'} = 'Keine Change-ID übermittelt!';
    $Self->{Translation}->{'No change found for changeID %s.'} = 'Kein Change für Change-ID %s gefunden.';
    $Self->{Translation}->{'The CAB of change "%s" could not be serialized.'} = 'Das CAB von Change "%s" konnte nicht serialisiert werden.';
    $Self->{Translation}->{'Could not add the template.'} = 'Vorlage konnte nicht hinzugefügt werden.';

    # Perl Module: Kernel/Modules/AgentITSMChangeCondition.pm
    $Self->{Translation}->{'Change "%s" not found in database!'} = 'Änderung "%s" in der Datenbank nicht gefunden!';
    $Self->{Translation}->{'Could not delete ConditionID %s!'} = 'Konnte Bedingungs-ID %s nicht löschen!';

    # Perl Module: Kernel/Modules/AgentITSMChangeConditionEdit.pm
    $Self->{Translation}->{'No %s is given!'} = 'Kein(e) %s übermittelt!';
    $Self->{Translation}->{'Could not create new condition!'} = 'Konnte keine neue Bedingung erstellen!';
    $Self->{Translation}->{'Could not update ConditionID %s!'} = 'Konnte Bedingungs-ID %s nicht aktualisieren!';
    $Self->{Translation}->{'Could not update ExpressionID %s!'} = 'Konnte Ausdrucks-ID %s nicht updaten!';
    $Self->{Translation}->{'Could not add new Expression!'} = 'Neuer Ausdruck konnte nicht hinzugefügt werden!';
    $Self->{Translation}->{'Could not update ActionID %s!'} = 'Konnte Aktions-ID nicht aktualisieren!';
    $Self->{Translation}->{'Could not add new Action!'} = 'Neue Aktion konnte nicht hinzugefügt werden!';
    $Self->{Translation}->{'Could not delete ExpressionID %s!'} = 'Konnte Ausdrucks-ID %s nicht löschen!';
    $Self->{Translation}->{'Could not delete ActionID %s!'} = 'Konnte Aktions-ID %s nicht löschen!';
    $Self->{Translation}->{'Error: Unknown field type "%s"!'} = 'Fehler: Unbekannter Feldtyp "%s"!';
    $Self->{Translation}->{'ConditionID %s does not belong to the given ChangeID %s!'} = 'Bedingungs-ID %s gehört nicht zur angegebenen Change-ID %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeDelete.pm
    $Self->{Translation}->{'Change "%s" does not have an allowed change state to be deleted!'} =
        'Change "%s" hat keinen erlaubten Change-Status zum Löschen!';
    $Self->{Translation}->{'Was not able to delete the changeID %s!'} = 'Es war nicht möglich, die Change-ID %s zu löschen!';

    # Perl Module: Kernel/Modules/AgentITSMChangeEdit.pm
    $Self->{Translation}->{'Was not able to update Change!'} = 'Es war nicht möglich, den Change zu aktualisieren!';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ChangeID is given!'} = 'Kann History nicht anzeigen, keine Change-ID übermittelt!';
    $Self->{Translation}->{'Change "%s" not found in the database!'} = 'Change "%s" in der Datenbank nicht gefunden!';
    $Self->{Translation}->{'Unknown type "%s" encountered!'} = 'Unbekannter Typ "%s" gefunden!';
    $Self->{Translation}->{'Change History'} = 'Change-Historie';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistoryZoom.pm
    $Self->{Translation}->{'Can\'t show history zoom, no HistoryEntryID is given!'} = 'Konnte Historien-Details nicht anzeigen, weil keine Historien-Eintrags-ID übermittelt wurde.';
    $Self->{Translation}->{'HistoryEntry "%s" not found in database!'} = 'Historien-Eintrag "%s" in Datenbank nicht gefunden!';

    # Perl Module: Kernel/Modules/AgentITSMChangeInvolvedPersons.pm
    $Self->{Translation}->{'Was not able to update Change CAB for Change %s!'} = 'Konnte Change-CAB für Change %s nicht aktualisieren!';
    $Self->{Translation}->{'Was not able to update Change %s!'} = 'Konnte Change %s nicht aktualisieren!';

    # Perl Module: Kernel/Modules/AgentITSMChangeManager.pm
    $Self->{Translation}->{'Overview: ChangeManager'} = 'Übersicht: Change-Manager';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyCAB.pm
    $Self->{Translation}->{'Overview: My CAB'} = 'Übersicht: Meine CABs';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyChanges.pm
    $Self->{Translation}->{'Overview: My Changes'} = 'Übersicht: Meine Changes';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyWorkOrders.pm
    $Self->{Translation}->{'Overview: My Workorders'} = 'Übersicht: Meine Arbeitsaufträge';

    # Perl Module: Kernel/Modules/AgentITSMChangePIR.pm
    $Self->{Translation}->{'Overview: PIR'} = 'Übersicht: PIR';

    # Perl Module: Kernel/Modules/AgentITSMChangePSA.pm
    $Self->{Translation}->{'Overview: PSA'} = 'Übersicht: PSA';

    # Perl Module: Kernel/Modules/AgentITSMChangePrint.pm
    $Self->{Translation}->{'WorkOrder "%s" not found in database!'} = 'Arbeitsauftrag "%s" in Datenbank nicht gefunden!';
    $Self->{Translation}->{'Can\'t create output, as the workorder is not attached to a change!'} =
        'Konnte keine Ausgabe erstellen, weil der Arbeitsauftrag nicht an den Change angehangen wurde!';
    $Self->{Translation}->{'Can\'t create output, as no ChangeID is given!'} = 'Konnte keine Ausgabe erstellen, weil keine Change-ID übermittelt wurde!';
    $Self->{Translation}->{'unknown change title'} = 'unbekannter Change-Titel';
    $Self->{Translation}->{'ITSM Workorder'} = 'ITSM Arbeitsauftrag';
    $Self->{Translation}->{'WorkOrderNumber'} = 'Arbeitsauftrag-Nummer';
    $Self->{Translation}->{'WorkOrderTitle'} = 'Arbeitsauftrags-Titel';
    $Self->{Translation}->{'unknown workorder title'} = 'unbekannter Arbeitsauftrags-Titel';
    $Self->{Translation}->{'ChangeState'} = 'Change-Status';
    $Self->{Translation}->{'PlannedEffort'} = 'Geplanter Aufwand';
    $Self->{Translation}->{'CAB Agents'} = 'CAB-Agenten';
    $Self->{Translation}->{'CAB Customers'} = 'CAB-Kunden';
    $Self->{Translation}->{'RequestedTime'} = 'Wunschtermin';
    $Self->{Translation}->{'PlannedStartTime'} = 'Geplanter Start';
    $Self->{Translation}->{'PlannedEndTime'} = 'Geplantes Ende';
    $Self->{Translation}->{'ActualStartTime'} = 'Tatsächlicher Start';
    $Self->{Translation}->{'ActualEndTime'} = 'Tatsächliches Ende';
    $Self->{Translation}->{'ChangeTime'} = 'Change-Zeit';
    $Self->{Translation}->{'ChangeNumber'} = 'Change-Nummer';
    $Self->{Translation}->{'WorkOrderState'} = 'Arbeitsauftrag-Status';
    $Self->{Translation}->{'WorkOrderType'} = 'Arbeitsauftrag-Typ';
    $Self->{Translation}->{'WorkOrderAgent'} = 'Arbeitsauftrag-Agent';
    $Self->{Translation}->{'ITSM Workorder Overview (%s)'} = 'ITSM Arbeitsauftrag-Übersicht (%s)';

    # Perl Module: Kernel/Modules/AgentITSMChangeReset.pm
    $Self->{Translation}->{'Was not able to reset WorkOrder %s of Change %s!'} = 'Konnte Arbeitsauftrag %s von Change %s nicht zurücksetzen!';
    $Self->{Translation}->{'Was not able to reset Change %s!'} = 'Konnte Change %s nicht zurücksetzen!';

    # Perl Module: Kernel/Modules/AgentITSMChangeSchedule.pm
    $Self->{Translation}->{'Overview: Change Schedule'} = 'Übersicht: Change-Zeitplan';

    # Perl Module: Kernel/Modules/AgentITSMChangeSearch.pm
    $Self->{Translation}->{'Change Search'} = 'Change-Suche';
    $Self->{Translation}->{'ChangeTitle'} = 'Change-Titel';
    $Self->{Translation}->{'WorkOrders'} = 'Arbeitsauftrag';
    $Self->{Translation}->{'Change Search Result'} = 'Change-Suchergebnisse';
    $Self->{Translation}->{'Change Number'} = 'Change-Nummer';
    $Self->{Translation}->{'Work Order Title'} = 'Arbeitsauftrag-Titel';
    $Self->{Translation}->{'Change Description'} = 'Change-Beschreibung';
    $Self->{Translation}->{'Change Justification'} = 'Change-Begründung';
    $Self->{Translation}->{'WorkOrder Instruction'} = 'Arbeitsauftrags-Anweisungen';
    $Self->{Translation}->{'WorkOrder Report'} = 'Arbeitsauftrags-Bericht';
    $Self->{Translation}->{'Change Priority'} = 'Change-Priorität';
    $Self->{Translation}->{'Change Impact'} = 'Change-Auswirkungen';
    $Self->{Translation}->{'Created By'} = 'Erstellt von';
    $Self->{Translation}->{'WorkOrder State'} = 'Arbeitsauftrags-Status';
    $Self->{Translation}->{'WorkOrder Type'} = 'Arbeitsauftrags-Typ';
    $Self->{Translation}->{'WorkOrder Agent'} = 'Arbeitsauftrags-Agent';
    $Self->{Translation}->{'before'} = 'vor';

    # Perl Module: Kernel/Modules/AgentITSMChangeTemplate.pm
    $Self->{Translation}->{'The change "%s" could not be serialized.'} = 'Der Change "%s" konnte nicht serialisiert werden.';
    $Self->{Translation}->{'Could not update the template "%s".'} = 'Konnte Vorlage "%s" nicht aktualisieren!';
    $Self->{Translation}->{'Could not delete change "%s".'} = 'Konnte Change "%s" nicht löschen.';

    # Perl Module: Kernel/Modules/AgentITSMChangeTimeSlot.pm
    $Self->{Translation}->{'The change can\'t be moved, as it has no workorders.'} = 'Der Change kann nicht verschoben werden, weil er keine Arbeitsaufträge hat.';
    $Self->{Translation}->{'Add a workorder first.'} = 'Fügen Sie zuerst einen Arbeitsauftrag hinzu.';
    $Self->{Translation}->{'Can\'t move a change which already has started!'} = 'Kann einen Change nicht verschieben, der bereits gestartet wurde!';
    $Self->{Translation}->{'Please move the individual workorders instead.'} = 'Bitte verschieben Sie stattdessen die einzelnen Arbeitsaufträge.';
    $Self->{Translation}->{'The current %s could not be determined.'} = 'Der derzeitige %s konnte nicht bestimmt werden.';
    $Self->{Translation}->{'The %s of all workorders has to be defined.'} = 'Der %s aller Arbeitsaufträge muss definiert werden.';
    $Self->{Translation}->{'Was not able to move time slot for workorder #%s!'} = 'Der Termin für den Arbeitsauftrag # %s konnte nicht verschoben werden!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateDelete.pm
    $Self->{Translation}->{'You need %s permission!'} = 'Sie benötigen die %s Berechtigung!';
    $Self->{Translation}->{'No TemplateID is given!'} = 'Keine Vorlagen-ID übermittelt!';
    $Self->{Translation}->{'Template "%s" not found in database!'} = 'Vorlage "%s" in Datenbank nicht gefunden!';
    $Self->{Translation}->{'Was not able to delete the template %s!'} = 'Konnte die Vorlage %s nicht löschen!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEdit.pm
    $Self->{Translation}->{'Was not able to update Template %s!'} = 'Konnte die Vorlage %s nicht aktualisieren!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditCAB.pm
    $Self->{Translation}->{'Was not able to update Template "%s"!'} = 'Konnte die Vorlage "%s "nicht aktualisieren!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditContent.pm
    $Self->{Translation}->{'Was not able to create change!'} = 'Konnte Change nicht erstellen!';
    $Self->{Translation}->{'Was not able to create workorder from template!'} = 'Konnte Arbeitsauftrag aus Vorlage nicht erstellen!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateOverview.pm
    $Self->{Translation}->{'Overview: Template'} = 'Übersicht: Vorlagen';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAdd.pm
    $Self->{Translation}->{'You need %s permissions on the change!'} = 'Sie benötigen %s Berechtigungen für den Change!';
    $Self->{Translation}->{'Was not able to add workorder!'} = 'Es war nicht möglich, den Arbeitsauftrag hinzuzufügen!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAgent.pm
    $Self->{Translation}->{'No WorkOrderID is given!'} = 'Keine Arbeitsauftrags-ID übermittelt!';
    $Self->{Translation}->{'Was not able to set the workorder agent of the workorder "%s" to empty!'} =
        'Konnte den Arbeitsauftrags-Agent von Arbeitsauftrag "%s" nicht auf leer setzen!';
    $Self->{Translation}->{'Was not able to update the workorder "%s"!'} = 'Konnte Arbeitsauftrag "%s" nicht aktualisieren!';
    $Self->{Translation}->{'Could not find Change for WorkOrder %s!'} = 'Konnte Change für Arbeitsauftrag %s nicht finden!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderDelete.pm
    $Self->{Translation}->{'Was not able to delete the workorder %s!'} = 'Konnte Arbeitsauftrag %s nicht löschen!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderEdit.pm
    $Self->{Translation}->{'Was not able to update WorkOrder %s!'} = 'Konnte Arbeitsauftrag %s nicht aktualisieren!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no WorkOrderID is given!'} = 'Kann Historie nicht anzeigen, weil keine Arbeitsauftrags-ID übermittelt wurde!';
    $Self->{Translation}->{'WorkOrder "%s" not found in the database!'} = 'Arbeitsauftrag "%s" in Datenbank nicht gefunden!';
    $Self->{Translation}->{'WorkOrder History'} = 'Arbeitsauftrags-Historie';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistoryZoom.pm
    $Self->{Translation}->{'History entry "%s" not found in the database!'} = 'Historien-Eintrag "%s" in Datenbank nicht gefunden!';
    $Self->{Translation}->{'WorkOrder History Zoom'} = 'Arbeitsauftrag-Historiendetails';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTake.pm
    $Self->{Translation}->{'Was not able to take the workorder %s!'} = 'Konnte Arbeitsauftrag %s nicht nehmen!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTemplate.pm
    $Self->{Translation}->{'The workorder "%s" could not be serialized.'} = 'Der Arbeitsauftrag "%s" konnte nicht serialisiert werden!';

    # Perl Module: Kernel/Output/HTML/Layout/ITSMChange.pm
    $Self->{Translation}->{'Need config option %s!'} = 'Benötige Systemkonfigurations-Option %s!';
    $Self->{Translation}->{'Config option %s needs to be a HASH ref!'} = 'Systemkonfigurations-Option %s muss eine Hash-Referenz sein!';
    $Self->{Translation}->{'No config option found for the view "%s"!'} = 'Keine Konfigurationsoption für die Ansicht "%s" gefunden!';
    $Self->{Translation}->{'Title: %s | Type: %s'} = 'Titel: %s | Typ: %s';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyCAB.pm
    $Self->{Translation}->{'My CABs'} = 'Meine CABs';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyChanges.pm
    $Self->{Translation}->{'My Changes'} = 'Meine Changes';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyWorkOrders.pm
    $Self->{Translation}->{'My Work Orders'} = 'Meine Arbeitsaufträge';

    # Perl Module: Kernel/System/ITSMChange/History.pm
    $Self->{Translation}->{'%s: %s'} = '%s: %s';
    $Self->{Translation}->{'New Action (ID=%s)'} = 'Neue Aktion (ID=%s)';
    $Self->{Translation}->{'Action (ID=%s) deleted'} = 'Aktion (ID=%s) gelöscht.';
    $Self->{Translation}->{'All Actions of Condition (ID=%s) deleted'} = 'Alle Aktionen der Bedingung (ID=%s) gelöscht.';
    $Self->{Translation}->{'Action (ID=%s) executed: %s'} = 'Aktion (ID=%s) ausgeführt: %s';
    $Self->{Translation}->{'%s (Action ID=%s): (new=%s, old=%s)'} = '%s (Aktions-ID=%s): (neu=%s, alt=%s)';
    $Self->{Translation}->{'Change (ID=%s) reached actual end time.'} = 'Change (ID=%s) hat die tatsächliche Endzeit erreicht.';
    $Self->{Translation}->{'Change (ID=%s) reached actual start time.'} = 'Change (ID=%s) hat die tatsächliche Startzeit erreicht.';
    $Self->{Translation}->{'New Change (ID=%s)'} = 'Neuer Change (ID=%s)';
    $Self->{Translation}->{'New Attachment: %s'} = 'Neuer Anhang: %s';
    $Self->{Translation}->{'Deleted Attachment %s'} = 'Gelöschter Anhang %s';
    $Self->{Translation}->{'CAB Deleted %s'} = 'CAB gelöscht %s';
    $Self->{Translation}->{'%s: (new=%s, old=%s)'} = '%s: (neu=%s, alt=%s)';
    $Self->{Translation}->{'Link to %s (ID=%s) added'} = 'Verknüpfung zu %s (ID=%s) hinzugefügt';
    $Self->{Translation}->{'Link to %s (ID=%s) deleted'} = 'Verknüpfung zu %s (ID=%s) gelöscht';
    $Self->{Translation}->{'Notification sent to %s (Event: %s)'} = 'Benachrichtigung an %s gesendet (Ereignis %s)';
    $Self->{Translation}->{'Change (ID=%s) reached planned end time.'} = 'Change (ID=%s) hat die geplante Endzeit erreicht.';
    $Self->{Translation}->{'Change (ID=%s) reached planned start time.'} = 'Change (ID=%s) hat die geplante Startzeit erreicht.';
    $Self->{Translation}->{'Change (ID=%s) reached requested time.'} = 'Change (ID=%s) hat die gewünschte Zeit erreicht.';
    $Self->{Translation}->{'New Condition (ID=%s)'} = 'Neue Bedingung (ID=%s)';
    $Self->{Translation}->{'Condition (ID=%s) deleted'} = 'Bedingung (ID=%s) gelöscht';
    $Self->{Translation}->{'All Conditions of Change (ID=%s) deleted'} = 'Alle Bedingungen des Changes (ID=%s) gelöscht';
    $Self->{Translation}->{'%s (Condition ID=%s): (new=%s, old=%s)'} = '%s (Bedingungs-ID=%s): (neu=%s, alt=%s)';
    $Self->{Translation}->{'New Expression (ID=%s)'} = 'Neuer logischer Ausdruck (ID=%s)';
    $Self->{Translation}->{'Expression (ID=%s) deleted'} = 'Logischer Ausdruck (ID=%s) gelöscht';
    $Self->{Translation}->{'All Expressions of Condition (ID=%s) deleted'} = 'Alle logischen Ausdrücke der Bedingung (ID=%s) gelöscht';
    $Self->{Translation}->{'%s (Expression ID=%s): (new=%s, old=%s)'} = '%s (Ausdrucks-ID=%s): (neu=%s, alt=%s)';
    $Self->{Translation}->{'Workorder (ID=%s) reached actual end time.'} = 'Arbeitsauftrag (ID=%s) hat die tatsächliche Endzeit erreicht.';
    $Self->{Translation}->{'Workorder (ID=%s) reached actual start time.'} = 'Arbeitsauftrag (ID=) hat die tatsächliche Startzeit erreicht.';
    $Self->{Translation}->{'New Workorder (ID=%s)'} = 'Neuer Arbeitsauftrag (ID=%s)';
    $Self->{Translation}->{'New Attachment for WorkOrder: %s'} = 'Neuer Anhang für Arbeitsauftrag: %s';
    $Self->{Translation}->{'(ID=%s) New Attachment for WorkOrder: %s'} = '(ID=%s) Neuer Anhang für Arbeitsauftrag: %s';
    $Self->{Translation}->{'Deleted Attachment from WorkOrder: %s'} = 'Anlage aus Arbeitsauftrag gelöscht: %s';
    $Self->{Translation}->{'(ID=%s) Deleted Attachment from WorkOrder: %s'} = '(ID=%s) Anlage aus Arbeitsauftrag gelöscht: %s';
    $Self->{Translation}->{'New Report Attachment for WorkOrder: %s'} = 'Neuer Berichts-Anhang für Arbeitsauftrag %s';
    $Self->{Translation}->{'(ID=%s) New Report Attachment for WorkOrder: %s'} = '(ID=%s) Neuer Berichts-Anhang für Arbeitsauftrag: %s';
    $Self->{Translation}->{'Deleted Report Attachment from WorkOrder: %s'} = 'Gelöschter Berichts-Anhang von Arbeitsauftrag: %s';
    $Self->{Translation}->{'(ID=%s) Deleted Report Attachment from WorkOrder: %s'} = '(ID=%s) Gelöschter Berichts-Anhang für Arbeitsauftrag: %s';
    $Self->{Translation}->{'Workorder (ID=%s) deleted'} = 'Arbeitsauftrag (ID=%s) gelöscht';
    $Self->{Translation}->{'(ID=%s) Link to %s (ID=%s) added'} = '(ID=%s) Verknüpfen zu %s (ID=%s) hinzugefügt';
    $Self->{Translation}->{'(ID=%s) Link to %s (ID=%s) deleted'} = '(ID=%s) Verknüpfen zu %s (ID=%s) gelöscht';
    $Self->{Translation}->{'(ID=%s) Notification sent to %s (Event: %s)'} = '(ID=%s) Benachrichtigung an %s gesendet (Ereignis %s)';
    $Self->{Translation}->{'Workorder (ID=%s) reached planned end time.'} = 'Arbeitsauftrag (ID=%s) hat die geplante Endzeit erreicht.';
    $Self->{Translation}->{'Workorder (ID=%s) reached planned start time.'} = 'Arbeitsauftrag (ID=%s) hat die geplante Startzeit erreicht.';
    $Self->{Translation}->{'(ID=%s) %s: (new=%s, old=%s)'} = '(ID=%s) %s: (neu=%s, alt=%s)';

    # Perl Module: Kernel/System/ITSMChange/ITSMCondition/Object/ITSMWorkOrder.pm
    $Self->{Translation}->{'all'} = 'alle';
    $Self->{Translation}->{'any'} = 'beliebige';

    # Perl Module: Kernel/System/ITSMChange/Notification.pm
    $Self->{Translation}->{'Previous Change Builder'} = 'Vorheriger Change-Builder';
    $Self->{Translation}->{'Previous Change Manager'} = 'Vorheriger Change-Manager';
    $Self->{Translation}->{'Workorder Agents'} = 'Arbeitsauftrags-Agenten';
    $Self->{Translation}->{'Previous Workorder Agent'} = 'Vorheriger Arbeitsauftrags-Agent';
    $Self->{Translation}->{'Change Initiators'} = 'Change-Initiatoren';
    $Self->{Translation}->{'Group ITSMChange'} = 'Gruppe ITSMChange';
    $Self->{Translation}->{'Group ITSMChangeBuilder'} = 'Gruppe ITSMChangeBuilder';
    $Self->{Translation}->{'Group ITSMChangeManager'} = 'Gruppe ITSMChangeManager';

    # Database XML Definition: ITSMChangeManagement.sopm
    $Self->{Translation}->{'requested'} = 'Angefragt';
    $Self->{Translation}->{'pending approval'} = 'Ausstehende Genehmigung';
    $Self->{Translation}->{'rejected'} = 'Zurückgewiesen';
    $Self->{Translation}->{'approved'} = 'Genehmigt';
    $Self->{Translation}->{'in progress'} = 'In Bearbeitung';
    $Self->{Translation}->{'pending pir'} = 'Wartender PIR';
    $Self->{Translation}->{'successful'} = 'Erfolgreich';
    $Self->{Translation}->{'failed'} = 'Fehlgeschlagen';
    $Self->{Translation}->{'canceled'} = 'Abgebrochen';
    $Self->{Translation}->{'retracted'} = 'Zurückgezogen';
    $Self->{Translation}->{'created'} = 'Erstellt';
    $Self->{Translation}->{'accepted'} = 'Angenommen';
    $Self->{Translation}->{'ready'} = 'Fertig';
    $Self->{Translation}->{'approval'} = 'Genehmigung';
    $Self->{Translation}->{'workorder'} = 'Arbeitsauftrag';
    $Self->{Translation}->{'backout'} = 'Backout-Plan';
    $Self->{Translation}->{'decision'} = 'Entscheidung';
    $Self->{Translation}->{'pir'} = 'PIR (Post Implementation Review)';
    $Self->{Translation}->{'ChangeStateID'} = 'Change-Status-ID';
    $Self->{Translation}->{'CategoryID'} = 'Kategorie-ID';
    $Self->{Translation}->{'ImpactID'} = 'Auswirkungs-ID';
    $Self->{Translation}->{'PriorityID'} = 'Prioritäts-ID';
    $Self->{Translation}->{'ChangeManagerID'} = 'Change-Manager-ID';
    $Self->{Translation}->{'ChangeBuilderID'} = 'ChangeBuilderID';
    $Self->{Translation}->{'WorkOrderStateID'} = 'Arbeitsauftrags-Status-ID';
    $Self->{Translation}->{'WorkOrderTypeID'} = 'Arbeitsauftrags-Typ-ID';
    $Self->{Translation}->{'WorkOrderAgentID'} = 'Arbeitsauftrags-Agent-ID';
    $Self->{Translation}->{'is'} = 'ist';
    $Self->{Translation}->{'is not'} = 'ist nicht';
    $Self->{Translation}->{'is empty'} = 'ist leer';
    $Self->{Translation}->{'is not empty'} = 'ist nicht leer';
    $Self->{Translation}->{'is greater than'} = 'ist grösser als';
    $Self->{Translation}->{'is less than'} = 'ist kleiner als';
    $Self->{Translation}->{'is before'} = 'ist vor';
    $Self->{Translation}->{'is after'} = 'ist nach';
    $Self->{Translation}->{'contains'} = 'enthält';
    $Self->{Translation}->{'not contains'} = 'enthält nicht';
    $Self->{Translation}->{'begins with'} = 'beginnt mit';
    $Self->{Translation}->{'ends with'} = 'endet mit';
    $Self->{Translation}->{'set'} = 'setze';

    # JS File: ITSM.Agent.ChangeManagement.Condition
    $Self->{Translation}->{'Do you really want to delete this expression?'} = 'Wollen Sie diesen logischen Ausdruck wirklich löschen?';
    $Self->{Translation}->{'Do you really want to delete this action?'} = 'Wollen Sie diese Aktion wirklich löschen?';
    $Self->{Translation}->{'Do you really want to delete this condition?'} = 'Wollen Sie diese Bedingung wirklich löschen?';

    # JS File: ITSM.Agent.ChangeManagement.ConfirmDialog
    $Self->{Translation}->{'Ok'} = 'Ok';

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        'Eine Liste der Agenten, die Berechtigungen haben, Arbeitsaufträge zu übernehmen haben. "Schlüssel" ist der Anmeldename. "Inhalt" ist 0 oder 1';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        'Eine Liste von Arbeitsauftrags-Status, bei denen die tatsächliche Startzeit eines Arbeitsauftrags festgelegt wird, wenn diese vorher nicht festgelegt war.';
    $Self->{Translation}->{'Actual end time'} = 'Tatsächliche Endzeit';
    $Self->{Translation}->{'Actual start time'} = 'Tatsächliche Startzeit';
    $Self->{Translation}->{'Add Workorder'} = 'Arbeitsauftrag hinzufügen';
    $Self->{Translation}->{'Add Workorder (from Template)'} = 'Arbeitsauftrag hinzufügen (aus Vorlage)';
    $Self->{Translation}->{'Add a change from template.'} = 'Fügt einen Change aus einer Vorlage hinzu.';
    $Self->{Translation}->{'Add a change.'} = 'Fügt einen Change hinzu.';
    $Self->{Translation}->{'Add a workorder (from template) to the change.'} = 'Fügt einen Arbeitsauftrag (aus einer Vorlage) zum Change hinzu.';
    $Self->{Translation}->{'Add a workorder to the change.'} = 'Fügt einen Arbeitsauftrag zum Change hinzu.';
    $Self->{Translation}->{'Add from template'} = 'Aus Vorlage hinzufügen';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = 'Admin der CIP-Matrix.';
    $Self->{Translation}->{'Admin of the state machine.'} = 'Admin der State Machine';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        'Benachrichtigung-Modul für das Agenten-Interface um die Zahl der Change-Advisory-Boards anzuzeigen.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        'Benachrichtigung-Modul für das Agenten-Interface, um die Zahl der Changes anzuzeigen die vom Benutzer verwaltet werden.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        'Benachrichtigung-Modul für das Agenten-Interface, um die Zahl der Changes anzuzeigen.';
    $Self->{Translation}->{'Agent interface notification module to see the number of workorders.'} =
        'Benachrichtigung-Modul für das Agenten-Interface, um die Anzahl der Arbeitsaufträge anzuzeigen.';
    $Self->{Translation}->{'CAB Member Search'} = 'CAB-Mitgliedersuche';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        'Cache-Zeit in Minuten für die Change Management Werkzeugleiste. Standard: 3 Stunden (180 Minuten)';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        'Cache-Zeit in Minuten für das Change-Management. Standard: 5 Tage (7200 Minuten).';
    $Self->{Translation}->{'Change CAB Templates'} = 'Change-CAB Vorlagen';
    $Self->{Translation}->{'Change History.'} = 'Change-Historie.';
    $Self->{Translation}->{'Change Involved Persons.'} = 'Change-Beteiligte Personen';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = 'Change-Übersicht Limit für Ansicht "Klein"';
    $Self->{Translation}->{'Change Overview.'} = 'Change-Übersicht.';
    $Self->{Translation}->{'Change Print.'} = 'Change-Ausdruck.';
    $Self->{Translation}->{'Change Schedule'} = 'Change-Zeitplan';
    $Self->{Translation}->{'Change Schedule.'} = '';
    $Self->{Translation}->{'Change Settings'} = 'Change-Einstellungen';
    $Self->{Translation}->{'Change Zoom'} = 'Change-Detailansicht';
    $Self->{Translation}->{'Change Zoom.'} = 'Change-Detailansicht.';
    $Self->{Translation}->{'Change and Workorder Templates'} = 'Change- und Arbeitsautrags-Vorlagen';
    $Self->{Translation}->{'Change and workorder templates edited by this user.'} = 'Change- und Arbeitsauftrags-Vorlagen, die von diesem Benutzer geändert wurden.';
    $Self->{Translation}->{'Change area.'} = 'Change-Bereich.';
    $Self->{Translation}->{'Change involved persons of the change.'} = 'Die beteiligten Personen des Change ändern.';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small".'} = 'Anzeigelimit pro Seite für die Change-Übersicht "Klein".';
    $Self->{Translation}->{'Change number'} = 'Change-Nummer';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = 'Such-Backend-Router für die Change-Suche in der Agenten-Ansicht.';
    $Self->{Translation}->{'Change state'} = 'Change-Status';
    $Self->{Translation}->{'Change time'} = 'Change-Zeit';
    $Self->{Translation}->{'Change title'} = 'Change-Titel';
    $Self->{Translation}->{'Condition Edit'} = 'Bedingung bearbeiten';
    $Self->{Translation}->{'Condition Overview'} = 'Bedingungen-Übersicht';
    $Self->{Translation}->{'Configure which screen should be shown after a new workorder has been created.'} =
        'Konfigurieren Sie, welche Ansicht angezeigt werden soll, nachdem ein neuer Arbeitsauftrag erstellt wurde.';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        'Konfiguriert, wie häufig Benachrichtigungen verschickt werden wenn die geplante Startzeit oder andere Zeiten erreicht wurden bzw. schon vorbei sind.';
    $Self->{Translation}->{'Create Change'} = 'Change erstellen';
    $Self->{Translation}->{'Create Change (from Template)'} = 'Change erstellen (aus Vorlage)';
    $Self->{Translation}->{'Create a change (from template) from this ticket.'} = 'Einen Change (aus Vorlage) aus diesem Ticket erstellen.';
    $Self->{Translation}->{'Create a change from this ticket.'} = 'Einen Change aus diesem Ticket erstellen.';
    $Self->{Translation}->{'Create and manage ITSM Change Management notifications.'} = 'ITSM Change-Benachrichtigungen erstellen und verwalten';
    $Self->{Translation}->{'Create and manage change notifications.'} = 'Change-Benachrichtigungen erstellen und verwalten.';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        'Standardtyp für einen Arbeitsauftrag. Dieser Eintrag muss in der General Katalog-Klasse \'ITSM::ChangeManagement::WorkOrder::Type\' existieren.';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'Definieren Sie Actions, in denen im Verknüpfte-Objekte-Widget ein Einstellungen-Knopf verfügbar sein soll (LinkObject::ViewMode = "complex"). Bitte beachten Sie, dass für diese Actions die folgenden JS- und CSS-Dateien registriert sein müssen:  Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js und Core.Agent.LinkObject.js.';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = 'Definieren eines Signals für einen Arbeitsauftragsstatus.';
    $Self->{Translation}->{'Define which columns are shown in the linked Changes widget (LinkObject::ViewMode = "complex"). Note: Only Change attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'Definiert, welche Spalten im Widget "Verknüpfte Objekte" (LinkObject::ViewMode = "complex"). Bitte beachten: Es sind nur Change-Attribute für die Standardspalten erlaubt. Mögliche Einstellungen: 0 = Deaktiviert, 1 = Verfügbar, 2 = Standardmäßig aktiviert.';
    $Self->{Translation}->{'Define which columns are shown in the linked Workorder widget (LinkObject::ViewMode = "complex"). Note: Only Workorder attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'Definiert, welche Spalten im Widget "Verknüpfte Arbeitsaufträge" (LinkObject::ViewMode = "complex"). Bitte beachten: Es sind nur Change-Attribute für die Standardspalten erlaubt. Mögliche Einstellungen: 0 = Deaktiviert, 1 = Verfügbar, 2 = Standardmäßig aktiviert.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        'Definiert das Übersichtsmodul um die "Klein"-Ansicht einer Change-Liste anzuzeigen.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        'Definiert das Übersichtsmodul um die "Klein"-Ansicht einer Vorlagenliste anzuzeigen.';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = 'Definiert, ob die erfasste Zeit ausgedruckt werden kann.';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = 'Definiert, ob der "geplante Aufwand" ausgedruckt werden kann.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        'Definiert, ob erreichbare (wie von der State Machine definiert) Change-Endzustände erlaubt sein sollen, wenn sich ein Change im Status "Gesperrt" befindet.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        'Definiert, ob nachfolgende Endzustände für einen Arbeitsauftrag (wie in der State Machine definiert) auch dann erlaubt sind, wenn sich Ihre Arbeitsaufträge im Status "Gesperrt" befinden.';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = 'Definiert, ob die gebuchte Zeit angezeigt werden soll.';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = 'Definiert, ob die tatsächliche Start- und Endzeit gesetzt werden soll.';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        'Definiert, ob die Suchfunktionen für Changes und Arbeitsaufträge die MirrorDB benutzen kann.';
    $Self->{Translation}->{'Defines if the change state can be set in the change edit screen of the agent interface.'} =
        'Definiert, ob der Change-Status in der Bearbeitungs-Ansicht eines Changes im Agenten-Interface gesetzt werden kann.';
    $Self->{Translation}->{'Defines if the planned effort should be shown.'} = 'Definiert, ob "geplanter Aufwand" angezeigt werden soll.';
    $Self->{Translation}->{'Defines if the requested date should be print by customer.'} = 'Definiert ob das Anfragedatum für den Kunden gedruckt werden soll.';
    $Self->{Translation}->{'Defines if the requested date should be searched by customer.'} =
        'Soll der Wunschtermin des Kunden gesucht werden können.';
    $Self->{Translation}->{'Defines if the requested date should be set by customer.'} = 'Definiert ob das Anfragedatum vom Kunden ausgefüllt werden soll.';
    $Self->{Translation}->{'Defines if the requested date should be shown by customer.'} = 'Definiert, ob der Wunschtermin vom Kunden angezeigt werden kann.';
    $Self->{Translation}->{'Defines if the workorder state should be shown.'} = 'Definiert, ob der Arbeitsauftrags-Status angezeigt werden soll.';
    $Self->{Translation}->{'Defines if the workorder title should be shown.'} = 'Definiert, ob der Arbeitsauftrags-Titel angezeigt werden soll.';
    $Self->{Translation}->{'Defines shown graph attributes.'} = 'Definiert Attribute für die Anzeige des Graphen.';
    $Self->{Translation}->{'Defines that only changes containing Workorders linked with services, which the customer user has permission to use will be shown. Any other changes will not be displayed.'} =
        'Definiert, dass nur Änderungen angezeigt werden, die Arbeitsaufträge enthalten, die mit Diensten verlinkt sind, für die der Kunden-Benutzer eine Berechtigung hat. Andere Änderungen werden nicht angezeigt.';
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = 'Definiert die Change-Status, die gelöscht werden dürfen.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change PSA overview.'} =
        'Definiert die Change-Status, die als Filter in der Change PSA-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change Schedule overview.'} =
        'Definiert die Change-Status, die als Filter in der ChangeZeitplan-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyCAB overview.'} =
        'Definiert die Change-Status, die als Filter in der Übersicht "Meine CABs" verwendet werden.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyChanges overview.'} =
        'Definiert die Change-Status, die als Filter in der Übersicht "Meine Changes" verwendet werden.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change manager overview.'} =
        'Definiert die Change-Status die als Filter in der Change-Manager-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change overview.'} =
        'Definiert die Change-Status die als Filter in der Change-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the customer change schedule overview.'} =
        'Definiert die Change-States die als Filter in der Kunden-Ansicht "Change Schedule" verwendet werden.';
    $Self->{Translation}->{'Defines the default change title for a dummy change which is needed to edit a workorder template.'} =
        'Definiert den Standardtitel für einen Dummy-Change, der benötigt wird, um eine Arbeitsauftrags-Vorlage zu bearbeiten.';
    $Self->{Translation}->{'Defines the default sort criteria in the change PSA overview.'} =
        'Definiert die Standard Sortierung der Changes in der Change PSA-Übersicht.';
    $Self->{Translation}->{'Defines the default sort criteria in the change manager overview.'} =
        'Definiert die Standardsortierung der Changes in der Change-Manager-Übersicht.';
    $Self->{Translation}->{'Defines the default sort criteria in the change overview.'} = 'Definiert die Standard Sortierung der Changes in der Change-Übersicht.';
    $Self->{Translation}->{'Defines the default sort criteria in the change schedule overview.'} =
        'Definiert die Standard Sortierung der Changes in der Change-Zeitplan-Übersicht.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyCAB overview.'} =
        'Definiert die Standard-Sortierkriterien der Changes in der Übersicht "Meine CABs".';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyChanges overview.'} =
        'Definiert die Standard-Sortierkriterien der Changes in der Übersicht "Meine Changes".';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyWorkorders overview.'} =
        'Definiert die Standard-Sortierkriterien der Changes in der Übersicht "Meine Arbeitsaufträge".';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the PIR overview.'} =
        'Definiert die Standard-Sortierkriterien der Changes in der "PIR"-Übersicht.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the customer change schedule overview.'} =
        'Standard Sortierung der Changes in der Kunden-Ansicht "Change Schedule".';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the template overview.'} =
        'Definiert die Standard-Sortierkriterien der Vorlagen in der Vorlagenübersicht.';
    $Self->{Translation}->{'Defines the default sort order in the MyCAB overview.'} = 'Definiert die Standard-Reihenfolge der Sortierung der Changes in der Übersicht "Meine CABs".';
    $Self->{Translation}->{'Defines the default sort order in the MyChanges overview.'} = 'Definiert die Standard-Reihenfolge der Sortierung der Changes in der Übersicht "Meine Changes".';
    $Self->{Translation}->{'Defines the default sort order in the MyWorkorders overview.'} =
        'Definiert die Standard-Reihenfolge der Sortierung der Arbeitsaufträge in der Übersicht "Meine Arbeitsaufträge".';
    $Self->{Translation}->{'Defines the default sort order in the PIR overview.'} = 'Definiert die Standard-Reihenfolge der Sortierung der Changes in der "PIR"-Übersicht.';
    $Self->{Translation}->{'Defines the default sort order in the change PSA overview.'} = 'Definiert die Standard-Reihenfolge der Sortierung der Changes in der Change PSA-Übersicht.';
    $Self->{Translation}->{'Defines the default sort order in the change manager overview.'} =
        'Definiert die Standard-Reihenfolge der Sortierung der Changes in der Change-Manager-Übersicht.';
    $Self->{Translation}->{'Defines the default sort order in the change overview.'} = 'Definiert die Standard-Reihenfolge der Sortierung in der Change-Übersicht.';
    $Self->{Translation}->{'Defines the default sort order in the change schedule overview.'} =
        'Definiert die Standard-Reihenfolge der Sortierung der Changes in der Change-Zeitplan-Übersicht.';
    $Self->{Translation}->{'Defines the default sort order in the customer change schedule overview.'} =
        'Standard Reihenfolge der Changes in der Kunden-Ansicht "Change Schedule".';
    $Self->{Translation}->{'Defines the default sort order in the template overview.'} = 'Definiert die Standard-Reihenfolge der Sortierung der Vorlagen in der Vorlagenübersicht.';
    $Self->{Translation}->{'Defines the default value for the category of a change.'} = 'Definiert den Standardwert für die Kategorie eines Changes.';
    $Self->{Translation}->{'Defines the default value for the impact of a change.'} = 'Definiert den Standardwert für die Auswirkung eines Changes.';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for change attributes used in the change condition edit screen of the agent interface. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Definiert den Feld-Typ für "Werte vergleichen"-Felder für Change-Attribute, die in der Bearbeitungsansicht für Bedingungen des Changes im Agenten-Interface genutzt werden. Gültige Werte sind "Selection", "Text" und "Date". Wenn kein Typ definiert ist, dann wird das Feld nicht angezeigt.';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for workorder attributes used in the change condition edit screen of the agent interface. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Definiert den Feld-Typ für "CompareValue"-Felder für Arbeitsauftrags-Attribute, die in der Bearbeitungsansicht für Bedingungen des Changes im Ageten-Interface genutzt werden. Gültige Werte sind Selection, Text und Date. Wenn kein Typ definiert ist, dann wird das Feld nicht angezeigt.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for change objects in the change condition edit screen of the agent interface.'} =
        'Definiert die Objekt-Attribute, die für Change-Objekte in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for workorder objects in the change condition edit screen of the agent interface.'} =
        'Definiert die Objekt-Attribute, die für Arbeitsauftrags-Objekte in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute AccountedTime in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "Gebuchte Zeit" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualEndTime in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "Tatsächliche Endzeit" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualStartTime in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "Tatsächliche Startzeit" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute CategoryID in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "Kategorie-ID" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeBuilderID in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "ChangeBuilderID" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeManagerID in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "ChangeManagerID" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeStateID in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "ChangeStateID" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeTitle in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "ChangeTitle" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute DynamicField in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "DynamicField" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ImpactID in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "ImpactID" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEffort in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "PlannedEffort" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEndTime in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "PlannedEndTime" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedStartTime in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "PlannedStartTime" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PriorityID in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "PriorityID" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute RequestedTime in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "RequestedTime" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderAgentID in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "WorkOrderAgentID" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderNumber in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "WorkOrderNumber" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderStateID in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "WorkOrderStateID" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTitle in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "WorkOrderTitle" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTypeID in the change condition edit screen of the agent interface.'} =
        'Definiert die Operatoren die für das Attribut "WorkOrderTypeID" in der Bearbeitungsansicht für Change-Bedingungen im Agenten-Interface ausgewählt werden können.';
    $Self->{Translation}->{'Defines the period (in years), in which start and end times can be selected.'} =
        'Definiert den Zeitraum (in Jahren) in dem Start- und Endzeiten gewählt werden können.';
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom. To show workorder dynamic fields in the tooltip, they must be specified like DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, etc.'} =
        'Definiert die in der Kurzinfo angezeigten Attribute eines Arbeitsauftrags-Graphen in der Change-Detailansicht. Um Dynamische Felder des Arbeitsauftrags anzuzeigen, müssen diese als DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, etc. angegeben werden.';
    $Self->{Translation}->{'Defines the shown columns in the Change PSA overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der Change PSA-Übersicht. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the Change Schedule overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der Change-Zeitplan-Übersicht. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the MyCAB overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der Übersicht "Meine CABs". Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the MyChanges overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der Übersicht "Meine Changes". Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the MyWorkorders overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der Übersicht "Meine Arbeitsaufträge". Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the PIR overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der "PIR"-Übersicht. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the change manager overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der Change-Manager-Übersicht. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the change overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der Change-Übersicht. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the change search. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten im Suchergebnis. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the customer change schedule overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der Kunden-Ansicht "Change Schedule". Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the shown columns in the template overview. This option has no effect on the position of the column.'} =
        'Definiert die angezeigten Tabellenspalten in der Vorlagenübersicht. Diese Option hat keinen Effekt auf die Position der Spalten.';
    $Self->{Translation}->{'Defines the signals for each ITSM change state.'} = 'Definiert das Signal für einen ITSM Change-Status.';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        'Definiert die Vorlagen-Typen, die als Filter in der Vorlagenübersicht verwendet werden.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        'Definiert die Arbeitsauftrags-Status die als Filter in der Übersicht "Meine Arbeitsaufträge" verwendet werden.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        'Definiert die Arbeitsauftrags-Status die als Filter in der "PIR"-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        'Definiert die Arbeitsauftrags-Typen, die als Filter in der "PIR"-Übersicht verwendet werden.';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = 'Definiert, ob Benachrichtigungen versendet werden sollen.';
    $Self->{Translation}->{'Delete a change.'} = 'Einen Change löschen.';
    $Self->{Translation}->{'Delete the change.'} = 'Den Change löschen.';
    $Self->{Translation}->{'Delete the workorder.'} = 'Den Arbeitsauftrag löschen.';
    $Self->{Translation}->{'Details of a change history entry.'} = 'Details eines Change-Historien-Eintrags.';
    $Self->{Translation}->{'Determines if an agent can exchange the X-axis of a stat if he generates one.'} =
        'Wenn diese Option aktiviert wird, hat der Agent die Möglichkeit beim Generieren einer Statistik die beiden Achsen zu vertauschen.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes done for config item classes.'} =
        'Hier können Sie festlegen, ob das Statistik-Modul auch allgemeine Statistiken über die Anzahl der durchgeführten Changes nach CI-Klasse generieren darf.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding change state updates within a timeperiod.'} =
        'Hier können Sie festlegen, ob das Statistik-Modul auch allgemeine Statistiken über Changes bzgl. Statusaktualisierungen innerhalb einer Zeitperiode generieren darf.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding the relation between changes and incident tickets.'} =
        'Hier können Sie festlegen, ob das Statistik-Modul auch allgemeine Statistiken über Changes bzgl. dem Zusammenhang zwischen Changes und Vorfalls-Tickets generieren darf.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes.'} =
        'Hier können Sie festlegen, ob das Statistik-Modul auch allgemeine Statistiken über Changes generieren darf.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about the number of Rfc tickets a requester created.'} =
        'Hier können Sie festlegen, ob das Statistik-Modul auch allgemeine Statistiken über die Anzahl von RfC-Tickets, die von Benutzern erzeugt wurden, generieren darf.';
    $Self->{Translation}->{'Dynamic fields (for changes and workorders) shown in the change print screen of the agent interface.'} =
        'Dynamische Felder (für Changes und Arbeitsaufträge), die in der Ansicht "Change drucken" im Agenten-Interface angezeigt werden.';
    $Self->{Translation}->{'Dynamic fields shown in the change add screen of the agent interface.'} =
        'Dynamische Felder, die in der Ansicht "Change hinzufügen" im Agenten-Interface angezeigt werden.';
    $Self->{Translation}->{'Dynamic fields shown in the change edit screen of the agent interface.'} =
        'Dynamische Felder, die in der Ansicht "Change bearbeiten" im Agenten-Interface angezeigt werden.';
    $Self->{Translation}->{'Dynamic fields shown in the change search screen of the agent interface.'} =
        'Dynamische Felder, die in der Ansicht "Change suchen" im Agenten-Interface angezeigt werden.';
    $Self->{Translation}->{'Dynamic fields shown in the change zoom screen of the agent interface.'} =
        'Dynamische Felder, die in der Detailansicht eines Changes im Agenten-Interface angezeigt werden.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder add screen of the agent interface.'} =
        'Dynamische Felder, die in der Ansicht "Arbeitsauftrag hinzufügen" im Agenten-Interface angezeigt werden.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder edit screen of the agent interface.'} =
        'Dynamische Felder, die in der Ansicht "Arbeitsauftrag bearbeiten" im Agenten-Interface angezeigt werden.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder report screen of the agent interface.'} =
        'Dynamische Felder, die in der Ansicht "Arbeitsauftrags-Bericht" im Agenten-Interface angezeigt werden.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder zoom screen of the agent interface.'} =
        'Dynamische Felder, die in der Detailansicht eines Arbeitsauftrags im Agenten-Interface angezeigt werden.';
    $Self->{Translation}->{'DynamicField event module to handle the update of conditions if dynamic fields are added, updated or deleted.'} =
        'Ereignismodul für Dynamische Felder zur Behandlung der Bedingungen wenn Dynamische Felder hinzugefügt, geändert oder gelöscht werden.';
    $Self->{Translation}->{'Edit a change.'} = 'Einen Change bearbeiten.';
    $Self->{Translation}->{'Edit the change.'} = 'Den Change bearbeiten.';
    $Self->{Translation}->{'Edit the conditions of the change.'} = 'Die Bedingungen des Changes bearbeiten.';
    $Self->{Translation}->{'Edit the workorder.'} = 'Den Arbeitsauftrag bearbeiten.';
    $Self->{Translation}->{'Enables the minimal change counter size (if "Date" was selected as ITSMChange::NumberGenerator).'} =
        'Aktiviert die Minimalgröße für Change-Zähler (wenn "Datum" als ITSMChange::NumberGenerator ausgewählt ist).';
    $Self->{Translation}->{'Forward schedule of changes. Overview over approved changes.'} =
        'Zeitplan für Changes. Übersicht über genehmigte Changes.';
    $Self->{Translation}->{'History Zoom'} = 'Historiendetails';
    $Self->{Translation}->{'ITSM Change CAB Templates.'} = 'ITSM Change-CAB Vorlagen';
    $Self->{Translation}->{'ITSM Change Condition Edit.'} = 'ITSM Change-Bedingungen bearbeiten.';
    $Self->{Translation}->{'ITSM Change Condition Overview.'} = 'ITSM Change-Bedingungs-Übersicht';
    $Self->{Translation}->{'ITSM Change Manager Overview.'} = 'ITSM Change-Manager-Übersicht';
    $Self->{Translation}->{'ITSM Change Notifications'} = 'ITSM Change-Benachrichtigungen';
    $Self->{Translation}->{'ITSM Change PIR Overview.'} = 'ITSM Change PIR-Übersicht';
    $Self->{Translation}->{'ITSM Change notification rules'} = 'ITSM Change Benachrichtigungs-Regeln';
    $Self->{Translation}->{'ITSM Changes'} = 'ITSM Changes';
    $Self->{Translation}->{'ITSM MyCAB Overview.'} = 'ITSM Meine CABs-Übersicht';
    $Self->{Translation}->{'ITSM MyChanges Overview.'} = 'ITSM "Meine Changes"-Übersicht';
    $Self->{Translation}->{'ITSM MyWorkorders Overview.'} = 'ITSM "Meine Arbeitsaufträge"-Übersicht';
    $Self->{Translation}->{'ITSM Template Delete.'} = 'ITSM Vorlage löschen.';
    $Self->{Translation}->{'ITSM Template Edit CAB.'} = 'ITSM Vorlage CAB bearbeiten.';
    $Self->{Translation}->{'ITSM Template Edit Content.'} = 'ITSM Vorlage Inhalt bearbeiten.';
    $Self->{Translation}->{'ITSM Template Edit.'} = 'ITSM Vorlage bearbeiten.';
    $Self->{Translation}->{'ITSM Template Overview.'} = 'ITSM Vorlagen-Übersicht';
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = 'ITSM-Ereignismodul zum Aufräumen von Bedingungen.';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = 'ITSM-Ereignismodul, das den Cache für eine Werkzeugleiste löscht.';
    $Self->{Translation}->{'ITSM event module that deletes the history of changes.'} = 'ITSM-Ereignismodul, das die Historie von Changes löscht.';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        'ITSM-Ereignismodul zum Überprüfen von Bedingungen und zum Ausführen von Aktionen.';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = 'ITSM Ereignismodul zum Senden von Benachrichtigungen.';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = 'ITSM-Ereignismodul, das die Historie von Changes aktualisiert.';
    $Self->{Translation}->{'ITSM event module that updates the history of conditions.'} = 'ITSM-Ereignismodul, dass die Historie von Bedingungen aktualisiert.';
    $Self->{Translation}->{'ITSM event module that updates the history of workorders.'} = 'ITSM-Ereignismodul, dass die Historie von Arbeitsaufträgen aktualisiert.';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = 'ITSM-Ereignismodul, das die Nummern von Arbeitsaufträgen neu berechnet.';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        'ITSM-Ereignismodul, das die tatsächliche Startzeiten und die tatsächliche Endzeiten von Arbeitsaufträgen setzt.';
    $Self->{Translation}->{'ITSMChange'} = 'ITSM Change';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'ITSM Arbeitsauftrag';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notifications are sent (every X hours).'} =
        'Wenn die Häufigkeit auf \'reglmäßig\' eingestellt ist, können Sie hier einstellen, wie oft die Benachrichtigung versendet werden (Aller X-Stunden).';
    $Self->{Translation}->{'Link another object to the change.'} = 'Ein anderes Objekt mit dem Change verknüpfen.';
    $Self->{Translation}->{'Link another object to the workorder.'} = 'Ein anderes Objekt mit dem Arbeitsauftrag verknüpfen.';
    $Self->{Translation}->{'List of all change events to be displayed in the GUI.'} = 'Liste aller Change-Ereignisse, die in der grafischen Benutzeroberfläche angezeigt werden sollen.';
    $Self->{Translation}->{'List of all workorder events to be displayed in the GUI.'} = 'Liste aller Arbeitsauftrags-Ereignisse, die in der grafischen Benutzeroberfläche angezeigt werden sollen.';
    $Self->{Translation}->{'Lookup of CAB members for autocompletion.'} = 'Nachschlagen von CAB-Mitgliedern zur automatischen Vervollständigung.';
    $Self->{Translation}->{'Lookup of agents, used for autocompletion.'} = 'Nachschlagen von Agenten zur automatischen Vervollständigung.';
    $Self->{Translation}->{'Manage ITSM Change Management state machine.'} = 'ITSM Change Management State Machine';
    $Self->{Translation}->{'Manage the category ↔ impact ↔ priority matrix.'} = 'Die Kategorie ↔ Auswirkung ↔ Priorität - Matrix verwalten.';
    $Self->{Translation}->{'Module to check if WorkOrderAdd or WorkOrderAddFromTemplate should be permitted.'} =
        'Modul zur Überprüfung ob das Hinzufügen von Arbeitsaufträgen oder Hinzufügen von Arbeitsaufträgen aus Vorlagen erlaubt ist.';
    $Self->{Translation}->{'Module to check the CAB members.'} = 'Modul zum Überprüfen der CAB-Mitglieder.';
    $Self->{Translation}->{'Module to check the agent.'} = 'Modul zum Überprüfen des Agenten.';
    $Self->{Translation}->{'Module to check the change builder.'} = 'Modul zum Überprüfen des Change-Builders.';
    $Self->{Translation}->{'Module to check the change manager.'} = 'Modul zum Überprüfen des Change-Managers.';
    $Self->{Translation}->{'Module to check the workorder agent.'} = 'Modul zum Überprüfen des Arbeitsauftrags-Agenten.';
    $Self->{Translation}->{'Module to check whether no workorder agent is set.'} = 'Modul zum Überprüfen, ob es keinen Agenten für den Arbeitsauftrag gibt.';
    $Self->{Translation}->{'Module to check whether the agent is contained in the configured list.'} =
        'Modul zum Überprüfen, ob der Agent in der konfigurierten Liste enthalten ist.';
    $Self->{Translation}->{'Module to show a link to create a change from this ticket. The ticket will be automatically linked with the new change.'} =
        'Mit diesem Modul wird ein Link im Menü der Ticketansicht angezeigt, mit dem ein Change erstellt werden kann. Das Ticket wird automatisch mit dem neu erstellten Change verlinkt.';
    $Self->{Translation}->{'Move Time Slot.'} = 'Zeitfenster verschieben.';
    $Self->{Translation}->{'Move all workorders in time.'} = 'Alle Arbeitsaufträge rechtzeitig verschieben.';
    $Self->{Translation}->{'New (from template)'} = 'Neu (aus Vorlage)';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        'Nur die Mitglieder dieser Gruppen haben die Berechtigung, die Ticket-Typen zu verwenden, die in "ITSMChange::AddChangeLinkTicketTypes" definiert sind, wenn das Feature "Ticket::Acl::Module###200-Ticket::Acl::Module" aktiviert ist.';
    $Self->{Translation}->{'Other Settings'} = 'Andere Einstellungen';
    $Self->{Translation}->{'Overview over all Changes.'} = 'Übersicht über alle Changes.';
    $Self->{Translation}->{'PIR'} = 'PIR';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'PIR (Post Implementation Review)';
    $Self->{Translation}->{'PSA'} = 'PSA';
    $Self->{Translation}->{'Parameters for the UserCreateWorkOrderNextMask object in the preference view of the agent interface.'} =
        'Parameter für das "UserCreateWorkOrderNextMask"-Objekt in den Benutzereinstellungen des Agenten-Interface.';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        'Parameter für die Change Übersichts-Anzeige in der Anzeige-Variante "S".';
    $Self->{Translation}->{'Performs the configured action for each event (as an Invoker) for each configured Webservice.'} =
        'Führt die konfigurierte Aktion für jedes Ereignis für jeden konfigurierten Webservice aus (als Invoker).';
    $Self->{Translation}->{'Planned end time'} = 'Geplante Endzeit';
    $Self->{Translation}->{'Planned start time'} = 'Geplante Startzeit';
    $Self->{Translation}->{'Print the change.'} = 'Change ausdrucken.';
    $Self->{Translation}->{'Print the workorder.'} = 'Arbeitsauftrag ausdrucken.';
    $Self->{Translation}->{'Projected Service Availability'} = 'Voraussichtliche Service-Verfügbarkeit';
    $Self->{Translation}->{'Projected Service Availability (PSA)'} = 'Projected Service Availability (PSA)';
    $Self->{Translation}->{'Projected Service Availability (PSA) of changes. Overview of approved changes and their services.'} =
        'Die Voraussichtliche Service-Verfügbarkeit (PSA) aller Changes. Übersicht über genehmigte Changes und deren Services.';
    $Self->{Translation}->{'Requested time'} = 'Wunschtermin';
    $Self->{Translation}->{'Required privileges in order for an agent to take a workorder.'} =
        'Benötigtes Recht zum Übernehmen eines Arbeitauftrags.';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = 'Erforderliche Berechtigungen, um auf die Übersicht aller Changes zuzugreifen.';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = 'Erforderliche Berechtigungen zum Löschen eines Arbeitauftrags.';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = 'Erforderliche Berechtigungen zum Ändern des Agenten eines Arbeitsauftrags.';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = 'Erforderliche Berechtigungen, um eine Vorlage aus einem Change zu erstellen.';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        'Erforderliche Berechtigungen, um eine Vorlage aus einem CAB eines Change zu erstellen.';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = 'Erforderliche Berechtigungen, um eine Vorlage aus einem Arbeitsauftrag zu erstellen.';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = 'Erforderliche Berechtigungen, um Changes aus Vorlagen zu erstellen.';
    $Self->{Translation}->{'Required privileges to create changes.'} = 'Erforderliche Berechtigungen zum Erstellen von Changes.';
    $Self->{Translation}->{'Required privileges to delete a template.'} = 'Erforderliche Berechtigungen zum Löschen einer Vorlage.';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = 'Erforderliche Berechtigungen zum Löschen eines Arbeitsauftrags.';
    $Self->{Translation}->{'Required privileges to delete changes.'} = 'Erforderliche Berechtigungen zum Löschen von Changes.';
    $Self->{Translation}->{'Required privileges to edit a template.'} = 'Erforderliche Berechtigungen zum Bearbeiten einer Vorlage.';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = 'Erforderliche Berechtigungen zum Bearbeiten eines Arbeitsauftrags.';
    $Self->{Translation}->{'Required privileges to edit changes.'} = 'Erforderliche Berechtigungen zum Bearbeiten von Changes.';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = 'Erforderliche Berechtigungen zum Bearbeiten der Bedingungen von Changes.';
    $Self->{Translation}->{'Required privileges to edit the content of a template.'} = 'Erforderliche Berechtigungen zum Bearbeiten des Inhalts einer Vorlage.';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        'Erforderliche Berechtigungen zum Bearbeiten der beteiligten Personen.';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = 'Erforderliche Berechtigungen zum Bearbeiten zum zeitlichen Verschieben von Changes.';
    $Self->{Translation}->{'Required privileges to print a change.'} = 'Erforderliche Berechtigungen zum Drucken von Changes.';
    $Self->{Translation}->{'Required privileges to reset changes.'} = 'Erforderliche Berechtigungen zum Zurücksetzen von Changes.';
    $Self->{Translation}->{'Required privileges to view a workorder.'} = 'Erforderliche Berechtigungen zum Betrachten eines Arbeitsauftrags.';
    $Self->{Translation}->{'Required privileges to view changes.'} = 'Erforderliche Berechtigungen zum Anschauen von Changes.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is a CAB member.'} =
        'Erforderliche Berechtigungen zum Einsehen der Liste der Changes bei denen der Benutzer Mitglied des CABs ist.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is the change manager.'} =
        'Benötigtes Recht zum Einsehen der Liste der Changes bei denen der Benutzer Change-Manager ist.';
    $Self->{Translation}->{'Required privileges to view overview over all templates.'} = 'Erforderliche Berechtigungen zum Einsehen der Liste von Vorlagen.';
    $Self->{Translation}->{'Required privileges to view the conditions of changes.'} = 'Erforderliche Berechtigungen zum Betrachten der Bedingungen von Changes.';
    $Self->{Translation}->{'Required privileges to view the history of a change.'} = 'Erforderliche Berechtigungen zum Einsehen der Historie eines Change.';
    $Self->{Translation}->{'Required privileges to view the history of a workorder.'} = 'Erforderliche Berechtigungen zum Betrachten der Historie eines Arbeitsauftrags.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a change.'} = 'Erforderliche Berechtigungen zum Einsehen der Historiendetails eines Change.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a workorder.'} =
        'Erforderliche Berechtigungen zum Betrachten der Historiendetails eines Arbeitsauftrags.';
    $Self->{Translation}->{'Required privileges to view the list of Change Schedule.'} = 'Erforderliche Berechtigungen zum Einsehen der Change-Zeitplan-Übersicht.';
    $Self->{Translation}->{'Required privileges to view the list of change PSA.'} = 'Erforderliche Berechtigungen zum Einsehen der Change PSA-Übersicht.';
    $Self->{Translation}->{'Required privileges to view the list of changes with an upcoming PIR (Post Implementation Review).'} =
        'Erforderliche Berechtigungen zum Einsehen der Liste von Changes mit einem anstehenden PIR (Post Implementation Review).';
    $Self->{Translation}->{'Required privileges to view the list of own changes.'} = 'Erforderliche Berechtigungen zum Einsehen der Liste der eigenen Changes.';
    $Self->{Translation}->{'Required privileges to view the list of own workorders.'} = 'Erforderliche Berechtigungen zum Einsehen der Liste von eigenen Arbeitsaufträgen.';
    $Self->{Translation}->{'Required privileges to write a report for the workorder.'} = 'Erforderliche Berechtigungen zum Verfassen eines Berichtes für einen Arbeitsauftrag.';
    $Self->{Translation}->{'Reset a change and its workorders.'} = 'Einen Change und seine Arbeitsaufträge zurücksetzen.';
    $Self->{Translation}->{'Reset change and its workorders.'} = 'Change und Arbeitsaufträge zurücksetzen.';
    $Self->{Translation}->{'Run task to check if specific times have been reached in changes and workorders.'} =
        'Aufgabe ausführen, um zu überprüfen, ob bestimmte Zeiten in Changes und Arbeitsaufträgen erreicht wurden.';
    $Self->{Translation}->{'Save change as a template.'} = 'Change als Vorlage speichern.';
    $Self->{Translation}->{'Save workorder as a template.'} = 'Arbeitsauftrag als Vorlage speichern.';
    $Self->{Translation}->{'Schedule'} = 'Zeitplan';
    $Self->{Translation}->{'Screen after creating a workorder'} = 'Ansicht nach Arbeitsauftrags-Erstellung';
    $Self->{Translation}->{'Search Changes'} = 'Changes suchen';
    $Self->{Translation}->{'Search Changes.'} = 'Changes suchen.';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        'Definiert das Change Nummer Generierung Modul. "AutoIncrement" erhöht die Change Nummer fortlaufend, dieses Format stellt sich als SystemID.Zähler dar (z.B. 100118, 100119). Mit "Datum" werden die Change Nummern aus dem aktuellen Datum und einem Zähler generiert, dieses Format stellt sich als Jahr.Monat.Tag.Zähler dar, z.B. 2010062400001, 2010062400002. Mit "DataChecksum" hängt der Zähler eine Prüfziffer an den Wert an zuzüglich der SystemID. Die Prüfziffer ändert sich täglich, dieses Format stellt sich als Jahr.Monat.Tag.SystemID.Zähler.Prüfziffer dar, z.B. 2010062410000017, 2010062410000026.';
    $Self->{Translation}->{'Set the agent for the workorder.'} = 'Den Agenten eines Arbeitsauftrags setzen.';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        'Definiert die standardmäßige Höhe (in Pixel) für Inline-HTML-Felder in der Change-Detailansicht und der Arbeitsauftrag-Detailansicht im Agenten-Interface.';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        'Definiert die maximale Höhe (in Pixel) für Inline-HTML-Felder in der Change-Detailansicht und der Arbeitsauftrag-Detailansicht im Agenten-Interface.';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        'Definiert die minimale Zählergröße für Changes (wenn "AutoIncrement" unter ITSMChange::NumberGenerator ausgewählt wurde). Standard ist 5, d.h. der Zähler startet mit 10000.';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = 'Konfiguration für die State Machine für Changes.';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = 'Konfiguration für die State Machine für Arbeitsaufträge.';
    $Self->{Translation}->{'Shows a checkbox in the workorder edit screen of the agent interface that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        'Zeigt in der "Arbeitsauftrag bearbeiten"-Ansicht im Agenten-Interface ein Kontrollkästchen, das es erlaubt die nachfolgenden Arbeitsaufträge zu verschieben falls der bearbeitete Arbeitsauftrag verändert wurde und die geplante Endzeit sich geändert hat.';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the workorder agent, in the zoom view of the workorder of the agent interface.'} =
        'Zeigt in der Arbeitsauftrag-Detailansicht im Agenten-Interface einen Menü-Link, der es erlaubt, den Arbeitsauftrags-Agenten zu ändern.';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        'Zeigt in der Change-Detailansicht des Agenten-Interface einen Menü-Link, der es erlaubt den Change als Vorlage zu speichern.';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a workorder as a template in the zoom view of the workorder, in the agent interface.'} =
        'Zeigt in der Arbeitsauftrag-Detailansicht im Agenten-Interface einen Menü Link, der es erlaubt, einen Arbeitsauftrag als Vorlage zu definieren.';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workorder, in the zoom view of the workorder of the agent interface.'} =
        'Zeigt in der Arbeitsauftrag-Detailansicht im Agenten-Interface einen Menü-Link, der es erlaubt, den Bericht eines Arbeitsauftrags zu bearbeiten.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        'Zeigt in der Change-Detailansicht des Agenten-Interface einen Menü-Link, der es erlaubt den Change mit einem anderen Objekt zu verknüpfen.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a workorder with another object in the zoom view of the workorder of the agent interface.'} =
        'Zeigt in der Arbeitsauftrag-Detailansicht im Agenten-Interface einen Menü-Link, der es erlaubt, einen Arbeitsauftrag mit einem anderen Objekt zu verknüpfen.';
    $Self->{Translation}->{'Shows a link in the menu that allows moving the time slot of a change in its zoom view of the agent interface.'} =
        'Zeigt in der Change-Detailansicht des Agenten-Interface einen Menü-Link zum Ändern des Zeitfensters.';
    $Self->{Translation}->{'Shows a link in the menu that allows taking a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the conditions of a change in the its zoom view of the agent interface.'} =
        'Zeigt in der Change Zoom Ansicht des Agenten-Interfaces einen Menu Link zum Zugriff auf die Bedingungen.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a change in the its zoom view of the agent interface.'} =
        'Zeigt in der Change Zoom Ansicht des Agenten-Interfaces einen Menu Link zum Zugriff auf die Historie.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to add a workorder in the change zoom view of the agent interface.'} =
        'Zeigt im Menü der Change-Detailansicht im Agenten-Interface einen Link zum Hinzufügen eines Arbeitsauftrags.';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        'Zeigt in der Change-Detailansicht des Agenten-Interface einen Menü-Link zum Löschen eines Change.';
    $Self->{Translation}->{'Shows a link in the menu to delete a workorder in its zoom view of the agent interface.'} =
        'Zeigt im Menü der Arbeitsauftrag-Detailansicht im Agenten-Interface einen Link zum Löschen eines Arbeitsauftrags.';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        'Zeigt in der Change Zoom Ansicht des Agenten-Interfaces einen Menu Link zum Bearbeiten.';
    $Self->{Translation}->{'Shows a link in the menu to edit a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        'Zeigt in der Change-Detailansicht des Agenten-Interface einen Menü-Link zum Zurückgehen.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the workorder zoom view of the agent interface.'} =
        'Zeigt im Menü der Arbeitsauftrag-Detailansicht im Agenten-Interface einen Link zum Zurückgehen.';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        'Zeigt in der "Change Zoom" Ansicht der Agenten-Oberfläche einen  Menu Link der es erlaubt den Change auszudrucken.';
    $Self->{Translation}->{'Shows a link in the menu to print a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        'Zeigt in der Change-Detailansicht des Agenten-Interface einen Menü-Link, der es erlaubt den Change und seine Arbeitsaufträge zurückzusetzen.';
    $Self->{Translation}->{'Shows a link in the menu to show the involved persons in a change, in the zoom view of the change in the agent interface.'} =
        'Zeigt im Menü der Change-Detailansicht im Agenten-Interface einen Link, der die beteiligten Personen eines Changes anzeigt.';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        'Zeigt die Change-Historie (umgekehrte Reihenfolge) im Agenten-Interface an.';
    $Self->{Translation}->{'State Machine'} = 'State Machine';
    $Self->{Translation}->{'Stores change and workorder ids and their corresponding template id, while a user is editing a template.'} =
        'Speichert Change und Arbeitsauftrags-ID und die zugehörige Vorlagen-ID während ein Benutzer die Vorlage bearbeitet.';
    $Self->{Translation}->{'Take Workorder'} = 'Arbeitsauftrag übernehmen';
    $Self->{Translation}->{'Take Workorder.'} = 'Arbeitsauftrag übernehmen.';
    $Self->{Translation}->{'Take the workorder.'} = 'Arbeitsauftrag übernehmen.';
    $Self->{Translation}->{'Template Overview'} = 'Vorlagenübersicht';
    $Self->{Translation}->{'Template type'} = 'Vorlagen-Typ';
    $Self->{Translation}->{'Template.'} = 'Vorlage.';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        'Change-Identifikator, z. B. Change#, MeinChange#. Als Standard wird Change# verwendet.';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        'Arbeitsauftrag-Identifikator, z. B. Arbeitsauftrag#, MeineArbeitsaufträge#. Als Standard wird "Workorder#" verwendet.';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        'Dieses ACL Modul beschränkt die Nutzung von Ticket-Typen, die in der Systemkonfiguration unter "ITSMChange::AddChangeLinkTicketTypes" definiert sind, zu den Nutzern der Gruppen aus "ITSMChange::RestrictTicketTypes::Groups". Weil diese ACL mit anderen ACLs, welche gebunden an den Tickettypen sind, kollidieren könnte, ist diese Option standardmäßig deaktiviert und sollte nur nach Bedarf aktiviert werden. ';
    $Self->{Translation}->{'Time Slot'} = 'Zeitfenster';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        'Typen der Tickets, in denen in der Ticket-Detailansicht ein Link angezeigt wird, um einen Change zu erstellen.';
    $Self->{Translation}->{'User Search'} = 'Benutzer-Suche';
    $Self->{Translation}->{'Workorder Add (from template).'} = 'Arbeitsauftrag hinzufügen (aus Vorlage).';
    $Self->{Translation}->{'Workorder Add.'} = 'Arbeitsauftrag hinzufügen.';
    $Self->{Translation}->{'Workorder Agent.'} = 'Arbeitsauftrags-Agent.';
    $Self->{Translation}->{'Workorder Delete.'} = 'Arbeitsauftrag löschen.';
    $Self->{Translation}->{'Workorder Edit.'} = 'Arbeitsauftrag bearbeiten.';
    $Self->{Translation}->{'Workorder History Zoom.'} = 'Arbeitsauftrag-Historiendetails.';
    $Self->{Translation}->{'Workorder History.'} = 'Arbeitsauftrags-Historie.';
    $Self->{Translation}->{'Workorder Report.'} = 'Arbeitsauftrags-Bericht.';
    $Self->{Translation}->{'Workorder Zoom'} = 'Arbeitsauftrag-Detailansicht';
    $Self->{Translation}->{'Workorder Zoom.'} = 'Arbeitsauftrag-Detailansicht.';
    $Self->{Translation}->{'once'} = 'einmalig';
    $Self->{Translation}->{'regularly'} = 'regelmäßig';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Do you really want to delete this action?',
    'Do you really want to delete this condition?',
    'Do you really want to delete this expression?',
    'Do you really want to delete this notification language?',
    'Do you really want to delete this notification?',
    'No',
    'Ok',
    'Please enter at least one search value or * to find anything.',
    'Settings',
    'Submit',
    'Yes',
    );

}

1;
