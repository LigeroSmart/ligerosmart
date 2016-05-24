# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nb_NO_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMChangeManagement
    $Self->{Translation}->{'ITSMChange'} = 'Endring';
    $Self->{Translation}->{'ITSMChanges'} = 'Endringer';
    $Self->{Translation}->{'ITSM Changes'} = 'Endringer';
    $Self->{Translation}->{'workorder'} = 'Arbeidsordre';
    $Self->{Translation}->{'A change must have a title!'} = 'En endring må ha en tittel!';
    $Self->{Translation}->{'A condition must have a name!'} = 'En forutsetning må ha et navn!';
    $Self->{Translation}->{'A template must have a name!'} = 'En mal må ha et navn!';
    $Self->{Translation}->{'A workorder must have a title!'} = 'En arbeidsordre må ha en tittel!';
    $Self->{Translation}->{'Add CAB Template'} = 'Legg til CAB-mal';
    $Self->{Translation}->{'Add Workorder'} = 'Legg til Arbeidordre';
    $Self->{Translation}->{'Add a workorder to the change'} = 'Legg en arbeidsordre til endringen';
    $Self->{Translation}->{'Add new condition and action pair'} = 'Legg til nytt forutsetning-gjøremål-par';
    $Self->{Translation}->{'Agent interface module to show the ChangeManager overview icon.'} =
        '';
    $Self->{Translation}->{'Agent interface module to show the MyCAB overview icon.'} = '';
    $Self->{Translation}->{'Agent interface module to show the MyChanges overview icon.'} = '';
    $Self->{Translation}->{'Agent interface module to show the MyWorkOrders overview icon.'} =
        '';
    $Self->{Translation}->{'CABAgents'} = 'CAB-saksbehandlere';
    $Self->{Translation}->{'CABCustomers'} = 'CAB-kunder';
    $Self->{Translation}->{'Change Overview'} = 'Endring Oversikt';
    $Self->{Translation}->{'Change Schedule'} = 'Endre tidsplan';
    $Self->{Translation}->{'Change involved persons of the change'} = 'Endre involverte personer i endringen';
    $Self->{Translation}->{'ChangeHistory::ActionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ActionAddID'} = 'Nytt gjøremål (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ActionDelete'} = 'Gjøremål (ID=%s) slettet';
    $Self->{Translation}->{'ChangeHistory::ActionDeleteAll'} = 'Alle gjøremål for forutsetning (ID=%s) slettet';
    $Self->{Translation}->{'ChangeHistory::ActionExecute'} = 'Gjøremål (ID=%s) utført: %s';
    $Self->{Translation}->{'ChangeHistory::ActionUpdate'} = '%s (Gjøremål ID=%s): Ny: %s -> Gammel: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeActualEndTimeReached'} = 'Endring (ID=%s) har nådd faktisk sluttid.';
    $Self->{Translation}->{'ChangeHistory::ChangeActualStartTimeReached'} = 'Endring (ID=%s) har nådd faktisk starttid.';
    $Self->{Translation}->{'ChangeHistory::ChangeAdd'} = 'Ny Endring (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentAdd'} = 'Nytt Vedlegg: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentDelete'} = 'Slettet Vedlegg %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABDelete'} = 'CAB Slettet %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABUpdate'} = '%s: Ny: %s -> Gammel: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkAdd'} = 'Kobling til %s (ID=%s) lagt til';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkDelete'} = 'Kobling til %s (ID=%s) slettet';
    $Self->{Translation}->{'ChangeHistory::ChangeNotificationSent'} = 'Melding sendt til %s (Hendelse: %s)';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedEndTimeReached'} = 'Endring (ID=%s) har nådd planlagt sluttid.';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedStartTimeReached'} = 'Endring (ID=%s) har nådd planlagt starttid.';
    $Self->{Translation}->{'ChangeHistory::ChangeRequestedTimeReached'} = 'Endring (ID=%s) har nådd forespurt tid.';
    $Self->{Translation}->{'ChangeHistory::ChangeUpdate'} = '%s: Ny: %s -> Gammel: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAddID'} = 'Ny forutsetning (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ConditionDelete'} = 'Forutsetning (ID=%s) slettet';
    $Self->{Translation}->{'ChangeHistory::ConditionDeleteAll'} = 'Alle Forutsetninger for Endring (ID=%s) slettet';
    $Self->{Translation}->{'ChangeHistory::ConditionUpdate'} = '%s (Forutsetning ID=%s): Ny: %s -> Gammel: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAddID'} = 'Nytt uttrykk (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ExpressionDelete'} = 'Uttrykk (ID=%s) Slettet';
    $Self->{Translation}->{'ChangeHistory::ExpressionDeleteAll'} = 'Alle Uttrykk for Forutsetning (ID=%s) slettet';
    $Self->{Translation}->{'ChangeHistory::ExpressionUpdate'} = '%s (Uttrykk ID=%s): Ny: %s -> Gammel: %s';
    $Self->{Translation}->{'ChangeNumber'} = 'Endre nummer';
    $Self->{Translation}->{'Condition Edit'} = 'Endre Forutsetning';
    $Self->{Translation}->{'Create Change'} = 'Opprett Endring';
    $Self->{Translation}->{'Create a change from this ticket!'} = 'Opprett en Endring fra denne saken';
    $Self->{Translation}->{'Delete Workorder'} = 'Slett Arbeidsordre';
    $Self->{Translation}->{'Edit the change'} = 'Rediger endringen';
    $Self->{Translation}->{'Edit the conditions of the change'} = 'Endre forutsetningene for denne endringen';
    $Self->{Translation}->{'Edit the workorder'} = 'Endre arbeidsordren';
    $Self->{Translation}->{'Expression'} = 'Uttrykk';
    $Self->{Translation}->{'Full-Text Search in Change and Workorder'} = 'Fulltekstsøk i Endring og Arbeidsordre';
    $Self->{Translation}->{'ITSMCondition'} = 'Forutsetning';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'Arbeidsordre';
    $Self->{Translation}->{'Link another object to the change'} = 'Koble et annet objekt til endringen';
    $Self->{Translation}->{'Link another object to the workorder'} = 'Koble et annet objekt til arbeidsordren';
    $Self->{Translation}->{'Move all workorders in time'} = 'Flytt alle arbeidsordre i tid';
    $Self->{Translation}->{'My CABs'} = 'Mine Endringsråd';
    $Self->{Translation}->{'My Changes'} = 'Mine Endringer';
    $Self->{Translation}->{'My Workorders'} = 'Mine Arbeidsordre';
    $Self->{Translation}->{'No XXX settings'} = 'Ingen innstillinger for \'%s\'';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'PIR (Sluttevaluering)';
    $Self->{Translation}->{'PSA (Projected Service Availability)'} = 'PSA (Forventet tjenestetilgjengelighet)';
    $Self->{Translation}->{'Please select first a catalog class!'} = 'Vennligst velg en katalogklasse først!';
    $Self->{Translation}->{'Print the change'} = 'Skriv ut endringen';
    $Self->{Translation}->{'Print the workorder'} = 'Skriv ut arbeidsordren';
    $Self->{Translation}->{'RequestedTime'} = 'Forespurt tid';
    $Self->{Translation}->{'Save Change CAB as Template'} = 'Lagre Endringsråd som mal';
    $Self->{Translation}->{'Save change as a template'} = 'Lagre Endring som mal';
    $Self->{Translation}->{'Save workorder as a template'} = 'Lagre Arbeidsordre som mal';
    $Self->{Translation}->{'Search Changes'} = 'Søk i Endringer';
    $Self->{Translation}->{'Set the agent for the workorder'} = 'Sett saksbehandler for arbeidsordren';
    $Self->{Translation}->{'Take Workorder'} = 'Ta arbeidsordre';
    $Self->{Translation}->{'Take the workorder'} = 'Ta arbeidsordren';
    $Self->{Translation}->{'Template Overview'} = 'Maloversikt';
    $Self->{Translation}->{'The planned end time is invalid!'} = 'Planlagt sluttid er ugyldig!';
    $Self->{Translation}->{'The planned start time is invalid!'} = 'Planlagt starttid er ugyldig!';
    $Self->{Translation}->{'The planned time is invalid!'} = 'Planlagt tid er ugyldig!';
    $Self->{Translation}->{'The requested time is invalid!'} = 'Forespurt tid er ugyldig!';
    $Self->{Translation}->{'New (from template)'} = '';
    $Self->{Translation}->{'Add from template'} = '';
    $Self->{Translation}->{'Add Workorder (from template)'} = '';
    $Self->{Translation}->{'Add a workorder (from template) to the change'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReached'} = 'Arbeidsordre (ID=%s) har nådd faktisk sluttid.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'} =
        'Arbeidsordre (ID=%s) har nådd faktisk sluttid.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReached'} = 'Arbeidsordre (ID=%s) har nådd faktisk starttid.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'} =
        'Arbeidsordre (ID=%s) har nådd faktisk starttid.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAdd'} = 'Ny Arbeidsordre (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'} = 'Ny Arbeidsordre (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAdd'} = 'Nytt vedlegg til Arbeidsordre: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'} = '(ID=%s) Nytt vedlegg til Arbeidsordre: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Slettet vedlegget fra Arbeidsordre: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Slettet vedlegget fra Arbeidsordre: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAdd'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID'} =
        '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDelete'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID'} =
        '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDelete'} = 'Arbeidsordre (ID=%s) slettet';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'} = 'Arbeidsordre (ID=%s) slettet';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAdd'} = 'Kobling til %s (ID=%s) lagt til';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'} = '(ID=%s) Kobling til %s (ID=%s) lagt til';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'Kobling til %s (ID=%s) slettet';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'} = '(ID=%s) Kobling til %s (ID=%s) slettet';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'Melding sendt til %s (Hendelse: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '(ID=%s) Melding sent til %s (Hendelse: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'} = 'Arbeidsordre (ID=%s) har nådd planlagt sluttid.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'} =
        'Arbeidsordre (ID=%s) har nådd planlagt sluttid.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'} = 'Arbeidsordre (ID=%s) har nådd planlagt starttid.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} =
        'Arbeidsordre (ID=%s) har nådd planlagt starttid.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdate'} = '%s: Ny: %s -> Gammel: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'} = '(ID=%s) %s: Ny: %s -> Gammel: %s';
    $Self->{Translation}->{'WorkOrderNumber'} = 'Arbeidsordre nr';
    $Self->{Translation}->{'accepted'} = 'Akseptert';
    $Self->{Translation}->{'any'} = 'hvilken som helst';
    $Self->{Translation}->{'approval'} = 'Godkjenning';
    $Self->{Translation}->{'approved'} = 'Godkjent';
    $Self->{Translation}->{'backout'} = 'Plan for gjenoppretting';
    $Self->{Translation}->{'begins with'} = 'starter med';
    $Self->{Translation}->{'canceled'} = 'Avbrutt';
    $Self->{Translation}->{'contains'} = 'inneholder';
    $Self->{Translation}->{'created'} = 'Opprettet';
    $Self->{Translation}->{'decision'} = 'Beslutning';
    $Self->{Translation}->{'ends with'} = 'slutter med';
    $Self->{Translation}->{'failed'} = 'feilet';
    $Self->{Translation}->{'in progress'} = 'Under arbeid';
    $Self->{Translation}->{'is'} = 'er';
    $Self->{Translation}->{'is after'} = 'er etter';
    $Self->{Translation}->{'is before'} = 'er før';
    $Self->{Translation}->{'is empty'} = 'er tom';
    $Self->{Translation}->{'is greater than'} = 'er større enn';
    $Self->{Translation}->{'is less than'} = 'er mindre enn';
    $Self->{Translation}->{'is not'} = 'er ikke';
    $Self->{Translation}->{'is not empty'} = 'er ikke tom';
    $Self->{Translation}->{'not contains'} = 'inneholder ikke';
    $Self->{Translation}->{'pending approval'} = 'Avventer godkjenning';
    $Self->{Translation}->{'pending pir'} = 'Avventer Sluttevaluering';
    $Self->{Translation}->{'pir'} = 'PIR (Sluttevaluering)';
    $Self->{Translation}->{'ready'} = 'Klar';
    $Self->{Translation}->{'rejected'} = 'Avvist';
    $Self->{Translation}->{'requested'} = 'Forespurt';
    $Self->{Translation}->{'retracted'} = 'Trukket tilbake';
    $Self->{Translation}->{'set'} = 'satt';
    $Self->{Translation}->{'successful'} = 'Vellykket';

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category <-> Impact <-> Priority'} = 'Kategori <-> Omfang <-> Prioritet';
    $Self->{Translation}->{'Manage the priority result of combinating Category <-> Impact.'} =
        'Sett opp valg av prioritet basert på Kategori <-> Omfang';
    $Self->{Translation}->{'Priority allocation'} = 'Tildeling av prioritet';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'ITSM Endringer - Meldingsoppsett';
    $Self->{Translation}->{'Add Notification Rule'} = 'Legg til Meldingsregel';
    $Self->{Translation}->{'Rule'} = 'Regel';
    $Self->{Translation}->{'A notification should have a name!'} = 'En melding må ha et navn!';
    $Self->{Translation}->{'Name is required.'} = 'Navn er påkrevd';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = '';
    $Self->{Translation}->{'Select a catalog class!'} = 'Velg en katalogklasse';
    $Self->{Translation}->{'A catalog class is required!'} = 'En katalogklasse er påkrevd!';
    $Self->{Translation}->{'Add a state transition'} = 'Legg til en tilstandsendring';
    $Self->{Translation}->{'Catalog Class'} = 'Katalogklasse';
    $Self->{Translation}->{'Object Name'} = 'Objektets navn';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Oversikt over tilstandsendringer for';
    $Self->{Translation}->{'Delete this state transition'} = '';
    $Self->{Translation}->{'Add a new state transition for'} = 'Ny tilstandsendring for';
    $Self->{Translation}->{'Please select a state!'} = 'Vennligst velg en tilstand!';
    $Self->{Translation}->{'Please select a next state!'} = 'Vennligst velg neste tilstand!';
    $Self->{Translation}->{'Edit a state transition for'} = 'Redigér en tilstandsendring for';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Vil du virkelig slette tilstandsendringen?';
    $Self->{Translation}->{'from'} = 'fra';
    $Self->{Translation}->{'to'} = '';

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'Legg til Endring';
    $Self->{Translation}->{'ITSM Change'} = 'Endring';
    $Self->{Translation}->{'Justification'} = 'Berettigelse';
    $Self->{Translation}->{'Input invalid.'} = 'Ugyldig verdi.';
    $Self->{Translation}->{'Impact'} = 'Omfang';
    $Self->{Translation}->{'Requested Date'} = 'Forespurt dato';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'Velg mal for Endring';
    $Self->{Translation}->{'Time type'} = 'Tidstype';
    $Self->{Translation}->{'Invalid time type.'} = 'Ugyldig tidstype';
    $Self->{Translation}->{'New time'} = 'Ny tid';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'Lagre Endring-CAB som mal';
    $Self->{Translation}->{'go to involved persons screen'} = 'Gå til involverte personer';
    $Self->{Translation}->{'Invalid Name'} = 'Ugyldig navn';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Forutsetninger og Gjøremål';
    $Self->{Translation}->{'Delete Condition'} = 'Slett forutsetning';
    $Self->{Translation}->{'Add new condition'} = 'Legg til ny forutsetning';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = 'Trenger et gyldig navn';
    $Self->{Translation}->{'A valid name is needed.'} = '';
    $Self->{Translation}->{'Duplicate name:'} = '';
    $Self->{Translation}->{'This name is already used by another condition.'} = '';
    $Self->{Translation}->{'Matching'} = 'Som passer til';
    $Self->{Translation}->{'Any expression (OR)'} = 'Hvilket utrykk som helst (OR)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Alle uttrykk (AND)';
    $Self->{Translation}->{'Expressions'} = 'Uttrykk';
    $Self->{Translation}->{'Selector'} = 'Velger';
    $Self->{Translation}->{'Operator'} = 'Operator';
    $Self->{Translation}->{'Delete Expression'} = '';
    $Self->{Translation}->{'No Expressions found.'} = 'Ingen uttrykk funnet.';
    $Self->{Translation}->{'Add new expression'} = 'Legg til nytt uttrykk';
    $Self->{Translation}->{'Delete Action'} = '';
    $Self->{Translation}->{'No Actions found.'} = 'Ingen gjøremål funnet';
    $Self->{Translation}->{'Add new action'} = 'Legg til gjøremål';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = '';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of'} = '';
    $Self->{Translation}->{'Workorder'} = 'Arbeidsordre';
    $Self->{Translation}->{'Show details'} = 'Vis detaljer';
    $Self->{Translation}->{'Show workorder'} = 'Vis arbeidsordre';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of'} = 'Detaljert historikk for';
    $Self->{Translation}->{'Modified'} = 'Modifisert';
    $Self->{Translation}->{'Old Value'} = 'Gammel verdi';
    $Self->{Translation}->{'New Value'} = 'Ny verdi';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Involved Persons'} = 'Involverte personer';
    $Self->{Translation}->{'ChangeManager'} = 'Endringsansvarlig';
    $Self->{Translation}->{'User invalid.'} = 'Ugyldig bruker';
    $Self->{Translation}->{'ChangeBuilder'} = 'Opprettet av';
    $Self->{Translation}->{'Change Advisory Board'} = 'Endringsråd';
    $Self->{Translation}->{'CAB Template'} = 'CAB-mal';
    $Self->{Translation}->{'Apply Template'} = 'Bruk mal';
    $Self->{Translation}->{'NewTemplate'} = 'Ny mal';
    $Self->{Translation}->{'Save this CAB as template'} = 'Lagre dette Endringsråd som mal';
    $Self->{Translation}->{'Add to CAB'} = 'Legg til CAB';
    $Self->{Translation}->{'Invalid User'} = 'Ugyldig bruker';
    $Self->{Translation}->{'Current CAB'} = 'Nåværende CAB';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Kontekstvalg';
    $Self->{Translation}->{'Changes per page'} = 'Endringer per side';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'WorkOrderTitle'} = 'Arbeidsordretittel';
    $Self->{Translation}->{'ChangeTitle'} = 'Endringstittel';
    $Self->{Translation}->{'WorkOrderAgent'} = 'Saksbehandler for arbeidsordre';
    $Self->{Translation}->{'Workorders'} = 'Arbeidsordre';
    $Self->{Translation}->{'ChangeState'} = 'Endringstilstand';
    $Self->{Translation}->{'WorkOrderState'} = 'Arbeidsordretilstand';
    $Self->{Translation}->{'WorkOrderType'} = 'Type Arbeidsordre';
    $Self->{Translation}->{'Requested Time'} = 'Forespurt tid';
    $Self->{Translation}->{'PlannedStartTime'} = 'Planlagt start';
    $Self->{Translation}->{'PlannedEndTime'} = 'Planlagt slutt';
    $Self->{Translation}->{'ActualStartTime'} = 'Faktisk start';
    $Self->{Translation}->{'ActualEndTime'} = 'Faktisk slutt';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = '';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(f.eks. 10*5155 eller 888*)';
    $Self->{Translation}->{'CABAgent'} = 'CAB-saksbehandler';
    $Self->{Translation}->{'e.g.'} = 'f.eks.';
    $Self->{Translation}->{'CABCustomer'} = 'CAB-kunde';
    $Self->{Translation}->{'ITSM Workorder'} = 'Arbeidsordre';
    $Self->{Translation}->{'Instruction'} = 'Instruks';
    $Self->{Translation}->{'Report'} = 'Rapport';
    $Self->{Translation}->{'Change Category'} = 'Endre kategori';
    $Self->{Translation}->{'(before/after)'} = '(før/etter)';
    $Self->{Translation}->{'(between)'} = '(mellom)';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Lagre Endring som Mal';
    $Self->{Translation}->{'A template should have a name!'} = 'En mal må ha et navn!';
    $Self->{Translation}->{'The template name is required.'} = 'Malnavnet er påkrevd.';
    $Self->{Translation}->{'Reset States'} = 'Nullstill tilstander';
    $Self->{Translation}->{'Overwrite original template'} = '';
    $Self->{Translation}->{'Delete original change'} = '';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Flytt tidsrommet';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'Endringsinfo';
    $Self->{Translation}->{'PlannedEffort'} = 'Planlagt innsats';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Initiativtaker(e) til Endring';
    $Self->{Translation}->{'Change Manager'} = 'Endringsansvarlig';
    $Self->{Translation}->{'Change Builder'} = 'Den som opprettet Endringen';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Sist endret';
    $Self->{Translation}->{'Last changed by'} = 'Sist endret av';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        '';
    $Self->{Translation}->{'Download Attachment'} = 'Last ned vedlegg';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = 'Virkelig slette denne malen?';

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
    $Self->{Translation}->{'TemplateID'} = 'Mal-ID';
    $Self->{Translation}->{'Edit Content'} = '';
    $Self->{Translation}->{'CreateBy'} = 'Opprettet av';
    $Self->{Translation}->{'CreateTime'} = 'Opprettet';
    $Self->{Translation}->{'ChangeBy'} = 'Opprettet av';
    $Self->{Translation}->{'ChangeTime'} = 'Endret';
    $Self->{Translation}->{'Edit Template Content'} = '';
    $Self->{Translation}->{'Delete Template'} = 'Slett Mal';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = 'Legg Arbeidsordre til';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Ugyldig type arbeidsordre';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'Planlagt starttid må være før planlagt sluttid';
    $Self->{Translation}->{'Invalid format.'} = 'Ugyldig format.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Velg mal for Arbeidsordren';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Virkelig slette denne arbeidsordren?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Du kan ikke slette arbeidsordren. Den er i bruk av minst én forutsetning!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Denne arbeidsordren brukes av følgende Forutsetning(er)';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = '';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        '';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'Faktisk starttid må være før faktisk sluttid';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'Hvis sluttiden settes må også starttid settes!';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Nåværende saksbehandler';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Vil du virkelig ta denne arbeidsordren?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Lagre Arbeidsordre som Mal';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = '';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Arbeidsordre-info';

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
    $Self->{Translation}->{'WorkOrders'} = 'Arbeidsordre';
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
