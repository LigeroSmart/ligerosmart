# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nl_ITSMChangeManagement;

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
    $Self->{Translation}->{'A change must have a title!'} = 'Vul een titel in voor de change.';
    $Self->{Translation}->{'A condition must have a name!'} = 'Vul een titel in voor de conditie';
    $Self->{Translation}->{'A template must have a name!'} = 'Kies een naam voor de template.';
    $Self->{Translation}->{'A workorder must have a title!'} = 'Vul een titel in voor de workorder';
    $Self->{Translation}->{'Add CAB Template'} = 'CAB template toevoegen';
    $Self->{Translation}->{'Add Workorder'} = 'Workorder toevoegen';
    $Self->{Translation}->{'Add a workorder to the change'} = 'Voeg een workorder toe aan deze change';
    $Self->{Translation}->{'Add new condition and action pair'} = 'Voeg een contitie- en actie-paar toe';
    $Self->{Translation}->{'Agent interface module to show the ChangeManager overview icon.'} =
        '';
    $Self->{Translation}->{'Agent interface module to show the MyCAB overview icon.'} = '';
    $Self->{Translation}->{'Agent interface module to show the MyChanges overview icon.'} = '';
    $Self->{Translation}->{'Agent interface module to show the MyWorkOrders overview icon.'} =
        '';
    $Self->{Translation}->{'CABAgents'} = 'CAB gebruikers';
    $Self->{Translation}->{'CABCustomers'} = 'CAB klanten';
    $Self->{Translation}->{'Change Overview'} = 'Changeoverzicht';
    $Self->{Translation}->{'Change Schedule'} = 'Change Schedule';
    $Self->{Translation}->{'Change involved persons of the change'} = 'Wijzig de betrokken personen bij deze change';
    $Self->{Translation}->{'ChangeHistory::ActionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ActionAddID'} = 'Nieuwe actie (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ActionDelete'} = 'Actie (ID=%s) verwijderd';
    $Self->{Translation}->{'ChangeHistory::ActionDeleteAll'} = 'Alle akties (ID=%s) verwijderd';
    $Self->{Translation}->{'ChangeHistory::ActionExecute'} = 'Actie (ID=%s) uitgevoerd: %s';
    $Self->{Translation}->{'ChangeHistory::ActionUpdate'} = '%s (Actie-ID=%s): nieuw: %s <- Old: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeActualEndTimeReached'} = 'Change (ID=%s) is beëindigd.';
    $Self->{Translation}->{'ChangeHistory::ChangeActualStartTimeReached'} = 'Change (ID=%s) is begonnen.';
    $Self->{Translation}->{'ChangeHistory::ChangeAdd'} = 'Nieuwe Change (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentAdd'} = 'Nieuwe bijlage: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentDelete'} = 'Bijlage verwijderd: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABDelete'} = 'CAB verwijderd %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABUpdate'} = '%s: nieuw: %s <- oud: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkAdd'} = 'Link naar %s (ID=%s) toegevoegd';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkDelete'} = 'Link naar %s (ID=%s) verwijderd';
    $Self->{Translation}->{'ChangeHistory::ChangeNotificationSent'} = 'Notificatie gestuurd aan %s(Event: %s)';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedEndTimeReached'} = 'Change (ID=%s) heeft de geplande eindtijd bereikt.';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedStartTimeReached'} = 'Change (ID=%s) heeft de geplande starttijd bereikt.';
    $Self->{Translation}->{'ChangeHistory::ChangeRequestedTimeReached'} = 'Change (ID=%s) heeft de aangevraagde eindtijd bereikt.';
    $Self->{Translation}->{'ChangeHistory::ChangeUpdate'} = '%s: nieuw: %s <- oud: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAddID'} = 'Nieuwe conditie (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ConditionDelete'} = 'Conditie (ID=%s) verwijderd';
    $Self->{Translation}->{'ChangeHistory::ConditionDeleteAll'} = 'Alle condities voor change (ID=%s) verwijderd.';
    $Self->{Translation}->{'ChangeHistory::ConditionUpdate'} = '%s (conditie ID=%s): nieuw: %s <- oud: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAddID'} = 'Nieuwe expressie (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ExpressionDelete'} = 'Expressie (ID=%s) verwijderd';
    $Self->{Translation}->{'ChangeHistory::ExpressionDeleteAll'} = 'Alle expressies voor change (ID=%s) verwijderd';
    $Self->{Translation}->{'ChangeHistory::ExpressionUpdate'} = '%s (expressie-ID=%s): nieuw: %s <- oud: %s';
    $Self->{Translation}->{'ChangeNumber'} = 'Changenummer';
    $Self->{Translation}->{'Condition Edit'} = 'Contities bewerken';
    $Self->{Translation}->{'Create Change'} = 'Change aanmaken';
    $Self->{Translation}->{'Create a change from this ticket!'} = 'Maak een change van dit ticket';
    $Self->{Translation}->{'Delete Workorder'} = 'Work Order verwijderen';
    $Self->{Translation}->{'Edit the change'} = 'Change wijzigen';
    $Self->{Translation}->{'Edit the conditions of the change'} = 'Wijzig de condities van deze change';
    $Self->{Translation}->{'Edit the workorder'} = 'Work Order wijzigen';
    $Self->{Translation}->{'Expression'} = 'Voorwaarde';
    $Self->{Translation}->{'Full-Text Search in Change and Workorder'} = 'Zoeken op tekst binnen changes en work orders';
    $Self->{Translation}->{'ITSMCondition'} = 'Conditie';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'Work Order';
    $Self->{Translation}->{'Link another object to the change'} = 'Koppel een object aan deze change';
    $Self->{Translation}->{'Link another object to the workorder'} = 'Koppel een ander object aan deze Work Order';
    $Self->{Translation}->{'Move all workorders in time'} = 'Verplaats alle workorders in tijd';
    $Self->{Translation}->{'My CABs'} = 'Mijn CABs';
    $Self->{Translation}->{'My Changes'} = 'Mijn changes';
    $Self->{Translation}->{'My Workorders'} = '';
    $Self->{Translation}->{'No XXX settings'} = 'Geen \'%s\' gekozen';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'PIR (Post Implementation Review)';
    $Self->{Translation}->{'PSA (Projected Service Availability)'} = 'PSA (Projected Service Availability)';
    $Self->{Translation}->{'Please select first a catalog class!'} = 'Kies een Catalog klasse.';
    $Self->{Translation}->{'Print the change'} = 'Change afdrukken';
    $Self->{Translation}->{'Print the workorder'} = 'Work Order afdrukken';
    $Self->{Translation}->{'RequestedTime'} = 'Gevraagde implementatietijd';
    $Self->{Translation}->{'Save Change CAB as Template'} = 'Bewaar deze CAB als sjabloon';
    $Self->{Translation}->{'Save change as a template'} = 'Sla deze change op als template';
    $Self->{Translation}->{'Save workorder as a template'} = 'Workorder als template opslaan';
    $Self->{Translation}->{'Search Changes'} = 'Zoek Changes';
    $Self->{Translation}->{'Set the agent for the workorder'} = 'Kies een agent voor Work Order';
    $Self->{Translation}->{'Take Workorder'} = 'Work Order overnemen';
    $Self->{Translation}->{'Take the workorder'} = 'Deze Work Order overnemen';
    $Self->{Translation}->{'Template Overview'} = 'Templateoverzicht';
    $Self->{Translation}->{'The planned end time is invalid!'} = 'De geplande eindtijd is ongeldig';
    $Self->{Translation}->{'The planned start time is invalid!'} = 'Die geplande eindtijd is';
    $Self->{Translation}->{'The planned time is invalid!'} = 'Het geplande tijdstip is ongeldig';
    $Self->{Translation}->{'The requested time is invalid!'} = 'Die angegebene Zeit ist ungültig!';
    $Self->{Translation}->{'New (from template)'} = '';
    $Self->{Translation}->{'Add from template'} = '';
    $Self->{Translation}->{'Add Workorder (from template)'} = '';
    $Self->{Translation}->{'Add a workorder (from template) to the change'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReached'} = 'Work Order (ID=%s) is beëindigd.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'} =
        'Work Order (ID=%s) is beëindigd.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReached'} = 'Work Order (ID=%s) is begonnen.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'} =
        'Work Order (ID=%s) is begonnen.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAdd'} = 'nieuwe Workorder (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'} = 'Nieuw Work Order (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAdd'} = 'Nieuwe bijlage bij Work Order: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'} = '(ID=%s) Nieuwe bijlage bij Work Order: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Bijlage van Work Order verwijderd: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Bijlage van Work Order verwijderd: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAdd'} = 'Nieuwe bericht bijlage bij Work Order: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID'} =
        '(ID=%s) Nieuwe bericht bijlage bij Work Order: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDelete'} = 'Bericht bijlage van Work Order verwijderd: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID'} =
        '(ID=%s) Bericht bijlage van Work Order verwijderd: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDelete'} = 'Work Order (ID=%s) verwijderd';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'} = 'Workorder (ID=%s) verwijderd';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAdd'} = 'Link naar %s (ID=%s) toegevoegd';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'} = '(ID=%s) Link naar %s (ID=%s) toegevoegd';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'Link naar %s (ID=%s) verwijderd';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'} = '(ID=%s) Link naar %s (ID=%s) verwijderd';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'Notificatie gestuurd aan %s (Event: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '(ID=%s) Notificatie gestuurd aan %s (Event: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'} = 'Work Order (ID=%s) heeft de geplande eindtijd bereikt.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'} =
        'Work Order (ID=%s) heeft de geplande eindtijd bereikt.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'} = 'Work Order (ID=%s) heeft de geplande starttijd bereikt.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} =
        'Work Order (ID=%s) heeft de geplande starttijd bereikt.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdate'} = '%s: nieuw: %s <- oud: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'} = '(ID=%s) %s: nieuw: %s <- oud: %s';
    $Self->{Translation}->{'WorkOrderNumber'} = 'Work Order-nummer';
    $Self->{Translation}->{'accepted'} = 'Geaccepteerd';
    $Self->{Translation}->{'any'} = 'enkele';
    $Self->{Translation}->{'approval'} = 'Goedkeuring';
    $Self->{Translation}->{'approved'} = 'Goedgekeurd';
    $Self->{Translation}->{'backout'} = 'Backout Plan';
    $Self->{Translation}->{'begins with'} = 'begint met';
    $Self->{Translation}->{'canceled'} = 'Gecanceld';
    $Self->{Translation}->{'contains'} = 'bevat';
    $Self->{Translation}->{'created'} = 'Aangemaakt';
    $Self->{Translation}->{'decision'} = 'Beslissing';
    $Self->{Translation}->{'ends with'} = 'eindigt op';
    $Self->{Translation}->{'failed'} = 'Mislukt';
    $Self->{Translation}->{'in progress'} = 'In uitvoering';
    $Self->{Translation}->{'is'} = 'is';
    $Self->{Translation}->{'is after'} = 'is later dan';
    $Self->{Translation}->{'is before'} = 'is eerder dan';
    $Self->{Translation}->{'is empty'} = 'is leeg';
    $Self->{Translation}->{'is greater than'} = 'is groter dan';
    $Self->{Translation}->{'is less than'} = 'is kleiner dan';
    $Self->{Translation}->{'is not'} = 'is niet';
    $Self->{Translation}->{'is not empty'} = 'is niet leeg';
    $Self->{Translation}->{'not contains'} = 'bevat niet';
    $Self->{Translation}->{'pending approval'} = 'Wacht op goedkeuring';
    $Self->{Translation}->{'pending pir'} = 'Wacht op PIR';
    $Self->{Translation}->{'pir'} = 'PIR (Post Implementation Review)';
    $Self->{Translation}->{'ready'} = 'Klaar';
    $Self->{Translation}->{'rejected'} = 'Afgewezen';
    $Self->{Translation}->{'requested'} = 'Aangevraagd';
    $Self->{Translation}->{'retracted'} = 'Ingetrokken';
    $Self->{Translation}->{'set'} = 'plaats';
    $Self->{Translation}->{'successful'} = 'Succesvol';

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category <-> Impact <-> Priority'} = 'Categorie <-> Impact <-> Prioriteit';
    $Self->{Translation}->{'Manage the priority result of combinating Category <-> Impact.'} =
        'Beheer de prioriteit op basis van de Categorie <-> Impact combinatie.';
    $Self->{Translation}->{'Priority allocation'} = 'Prioriteit-toewijzing';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'ITSM Change Management notificiatie beheer';
    $Self->{Translation}->{'Add Notification Rule'} = 'Notificatie regel toevoegen';
    $Self->{Translation}->{'Rule'} = 'Regel';
    $Self->{Translation}->{'A notification should have a name!'} = 'Geef een naam voor de notificatie.';
    $Self->{Translation}->{'Name is required.'} = '';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'Beheer status-machine.';
    $Self->{Translation}->{'Select a catalog class!'} = 'Selecteer een catalogus-klasse';
    $Self->{Translation}->{'A catalog class is required!'} = 'Een catalogus-klasse is verplicht.';
    $Self->{Translation}->{'Add a state transition'} = 'Nieuwe statusovergang toevoegen';
    $Self->{Translation}->{'Catalog Class'} = 'Catalogus-klasse';
    $Self->{Translation}->{'Object Name'} = 'Object-naam';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Overzicht van statusovergangen voor';
    $Self->{Translation}->{'Delete this state transition'} = '';
    $Self->{Translation}->{'Add a new state transition for'} = 'Voeg een nieuwe statusovergang toe voor';
    $Self->{Translation}->{'Please select a state!'} = 'Selecteer een status.';
    $Self->{Translation}->{'Please select a next state!'} = 'Selecteer een volgende status.';
    $Self->{Translation}->{'Edit a state transition for'} = 'Bewerken van statusovergangen voor';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Wilt u deze statusovergang verwijderen';
    $Self->{Translation}->{'from'} = 'van';
    $Self->{Translation}->{'to'} = '';

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'Change toevoegen';
    $Self->{Translation}->{'ITSM Change'} = 'Change';
    $Self->{Translation}->{'Justification'} = 'Rechtvaardiging';
    $Self->{Translation}->{'Input invalid.'} = 'Ongeldige invoer.';
    $Self->{Translation}->{'Impact'} = 'Impact';
    $Self->{Translation}->{'Requested Date'} = 'Gevraagde implementatietijd';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'Change template kiezen';
    $Self->{Translation}->{'Time type'} = 'Tijd-type';
    $Self->{Translation}->{'Invalid time type.'} = 'Ongeldige tijdsoort';
    $Self->{Translation}->{'New time'} = 'Nieuw tijdstip';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'Bewaar Change CAB als sjabloon';
    $Self->{Translation}->{'go to involved persons screen'} = 'ga naar betrokken personen';
    $Self->{Translation}->{'Invalid Name'} = 'Ongeldige naam';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Condities en acties';
    $Self->{Translation}->{'Delete Condition'} = 'Verwijder conditie';
    $Self->{Translation}->{'Add new condition'} = 'Conditie toevoegen';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = 'Geen geldige naam.';
    $Self->{Translation}->{'A valid name is needed.'} = '';
    $Self->{Translation}->{'Duplicate name:'} = '';
    $Self->{Translation}->{'This name is already used by another condition.'} = '';
    $Self->{Translation}->{'Matching'} = 'Matching';
    $Self->{Translation}->{'Any expression (OR)'} = 'Een voorwaarde (OR)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Alle voorwaarden (AND)';
    $Self->{Translation}->{'Expressions'} = 'Voorwaarden';
    $Self->{Translation}->{'Selector'} = 'Selectie';
    $Self->{Translation}->{'Operator'} = 'Operator';
    $Self->{Translation}->{'Delete Expression'} = '';
    $Self->{Translation}->{'No Expressions found.'} = 'Geen expressies gevonden.';
    $Self->{Translation}->{'Add new expression'} = 'Nieuwe voorwaarde toevoegen';
    $Self->{Translation}->{'Delete Action'} = '';
    $Self->{Translation}->{'No Actions found.'} = 'Geen acties gevonden.';
    $Self->{Translation}->{'Add new action'} = 'Nieuwe actie toevoegen';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = '';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of'} = '';
    $Self->{Translation}->{'Workorder'} = 'Work Order';
    $Self->{Translation}->{'Show details'} = 'Toon details';
    $Self->{Translation}->{'Show workorder'} = 'Toon Work Order';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of'} = 'Gedetailleerde informatie van';
    $Self->{Translation}->{'Modified'} = '';
    $Self->{Translation}->{'Old Value'} = 'Oude waarde';
    $Self->{Translation}->{'New Value'} = 'Nieuwe waarde';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Involved Persons'} = 'Betrokken personen';
    $Self->{Translation}->{'ChangeManager'} = 'Change Manager';
    $Self->{Translation}->{'User invalid.'} = 'Gebruiker ongeldig.';
    $Self->{Translation}->{'ChangeBuilder'} = 'Change-samensteller';
    $Self->{Translation}->{'Change Advisory Board'} = 'Change Advisory Board';
    $Self->{Translation}->{'CAB Template'} = 'CAB sjabloon';
    $Self->{Translation}->{'Apply Template'} = 'Kies sjabloon';
    $Self->{Translation}->{'NewTemplate'} = 'Nieuw sjabloon';
    $Self->{Translation}->{'Save this CAB as template'} = 'Bewaar dit CAB als sjabloon';
    $Self->{Translation}->{'Add to CAB'} = 'Toevoegen aan CAB';
    $Self->{Translation}->{'Invalid User'} = 'Ongeldige gebruiker';
    $Self->{Translation}->{'Current CAB'} = 'Actueel CAB';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Context Instellingen';
    $Self->{Translation}->{'Changes per page'} = 'Changes per pagina';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'WorkOrderTitle'} = 'Work Order-titel';
    $Self->{Translation}->{'ChangeTitle'} = 'Change-titel';
    $Self->{Translation}->{'WorkOrderAgent'} = 'Work Order-gebruiker';
    $Self->{Translation}->{'Workorders'} = 'Workorders';
    $Self->{Translation}->{'ChangeState'} = 'Change-status';
    $Self->{Translation}->{'WorkOrderState'} = 'Work Order-status';
    $Self->{Translation}->{'WorkOrderType'} = 'Work Order-type';
    $Self->{Translation}->{'Requested Time'} = 'Aangevraagd tijdstip';
    $Self->{Translation}->{'PlannedStartTime'} = 'Geplande starttijd';
    $Self->{Translation}->{'PlannedEndTime'} = 'Geplande eindtijd';
    $Self->{Translation}->{'ActualStartTime'} = 'Werkelijke starttijd';
    $Self->{Translation}->{'ActualEndTime'} = 'Werkelijke eindtijd';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = '';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = 'bijvoorbeeld 10*5155';
    $Self->{Translation}->{'CABAgent'} = 'CAB gebruiker';
    $Self->{Translation}->{'e.g.'} = 'bijvoorbeeld';
    $Self->{Translation}->{'CABCustomer'} = 'CAB klant';
    $Self->{Translation}->{'ITSM Workorder'} = 'Workorder';
    $Self->{Translation}->{'Instruction'} = 'Instructie';
    $Self->{Translation}->{'Report'} = 'Bericht';
    $Self->{Translation}->{'Change Category'} = 'Change categorie';
    $Self->{Translation}->{'(before/after)'} = '(voor/na)';
    $Self->{Translation}->{'(between)'} = '(tussen)';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Bewaar Change als sjabloon';
    $Self->{Translation}->{'A template should have a name!'} = 'Geef een naam op voor dit sjabloon.';
    $Self->{Translation}->{'The template name is required.'} = 'De naam is een verplicht veld.';
    $Self->{Translation}->{'Reset States'} = 'Statussen resetten';
    $Self->{Translation}->{'Overwrite original template'} = '';
    $Self->{Translation}->{'Delete original change'} = '';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Verplaats timeslot';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'Change-informatie';
    $Self->{Translation}->{'PlannedEffort'} = 'Geplande inspanning';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Change initiator(s)';
    $Self->{Translation}->{'Change Manager'} = 'Change Manager';
    $Self->{Translation}->{'Change Builder'} = 'Operationeel Change Manager';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Laatst aangepast op';
    $Self->{Translation}->{'Last changed by'} = 'Laatst aangepast door';
    $Self->{Translation}->{'Ok'} = 'OK';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Om de links in de omschrijvingen te openen, is het mogelijk dat u Ctrl of Cmd of Shift moet indrukken terwijl u op de link klikt (afhankelijk van uw browser en besturingssysteem).';
    $Self->{Translation}->{'Download Attachment'} = 'Download bijlage';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = 'Wilt u deze template echt verwijderen?';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = '';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        '';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        '';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        '';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        '';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        '';
    $Self->{Translation}->{'Do you want to proceed?'} = '';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = 'SjabloonID';
    $Self->{Translation}->{'Edit Content'} = '';
    $Self->{Translation}->{'CreateBy'} = 'Aangemaakt door';
    $Self->{Translation}->{'CreateTime'} = 'Aangemaakt op';
    $Self->{Translation}->{'ChangeBy'} = 'Aangepast door';
    $Self->{Translation}->{'ChangeTime'} = 'Aangepast op';
    $Self->{Translation}->{'Edit Template Content'} = '';
    $Self->{Translation}->{'Delete Template'} = 'Verwijder Template';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = 'Voeg werkorder toe aan';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Ongeldig workorder-type';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'De gepande starttijd moet eerder zijn dan de einddatum.';
    $Self->{Translation}->{'Invalid format.'} = 'Ongeldig formaat.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Workorder template kiezen';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Wilt u deze Work Order verwijderen?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Deze Work Order kan niet verwijderd worden. Hij is in tenminste één conditie gebruikt.';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Deze Work Order is gebruikt in de volgende conditie(s)';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = '';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        '';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'De werkelijke starttijd moet eerder zijn dan de werkelijke eindtijd.';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'De werkelijke starttijd moet gevuld zijn als de werkelijke eindtijd gevuld is.';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Actuele gebruiker';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Deze Work Order overnemen?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Work Order opslaan als template';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = '';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Work Order-informatie';

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
    $Self->{Translation}->{'WorkOrders'} = 'Work Orders';
    $Self->{Translation}->{'Change Search Result'} = '';
    $Self->{Translation}->{'Change Number'} = '';
    $Self->{Translation}->{'Change Title'} = '';
    $Self->{Translation}->{'Work Order Title'} = '';
    $Self->{Translation}->{'CAB Agent'} = '';
    $Self->{Translation}->{'CAB Customer'} = '';
    $Self->{Translation}->{'Change Description'} = '';
    $Self->{Translation}->{'Change Justification'} = '';
    $Self->{Translation}->{'WorkOrder Instruction'} = '';
    $Self->{Translation}->{'WorkOrder Report'} = '';
    $Self->{Translation}->{'Change Priority'} = '';
    $Self->{Translation}->{'Change Impact'} = '';
    $Self->{Translation}->{'Change State'} = '';
    $Self->{Translation}->{'Created By'} = '';
    $Self->{Translation}->{'WorkOrder State'} = '';
    $Self->{Translation}->{'WorkOrder Type'} = '';
    $Self->{Translation}->{'WorkOrder Agent'} = '';
    $Self->{Translation}->{'Planned Start Time'} = '';
    $Self->{Translation}->{'Planned End Time'} = '';
    $Self->{Translation}->{'Actual Start Time'} = '';
    $Self->{Translation}->{'Actual End Time'} = '';
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
    $Self->{Translation}->{'My Work Orders'} = '';

}

1;
