# --
# Kernel/Language/nb_NO_ITSMChangeManagement.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nb_NO_ITSMChangeManagement;

use strict;
use warnings;

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
    $Self->{Translation}->{'ActionExecute::successfully'} = 'Vellykket';
    $Self->{Translation}->{'ActionExecute::unsuccessfully'} = 'Mislykket';
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
    $Self->{Translation}->{'Attribute'} = 'Attributt';
    $Self->{Translation}->{'Rule'} = 'Regel';
    $Self->{Translation}->{'Recipients'} = 'Mottakere';
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

    # Template: AgentITSMCABMemberSearch

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
    $Self->{Translation}->{'This field is required'} = 'Dette feltet er obligatorisk';
    $Self->{Translation}->{'Invalid Name'} = 'Ugyldig navn';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Forutsetninger og Gjøremål';
    $Self->{Translation}->{'Delete Condition'} = 'Slett forutsetning';
    $Self->{Translation}->{'Add new condition'} = 'Legg til ny forutsetning';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = 'Trenger et gyldig navn';
    $Self->{Translation}->{'A a valid name is needed.'} = 'Et gyldig navn kreves.';
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

    # Template: AgentITSMChangeEdit

    # Template: AgentITSMChangeHistory
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

    # Template: AgentITSMChangePrint
    $Self->{Translation}->{'ITSM Workorder'} = 'Arbeidsordre';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = '';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(f.eks. 10*5155 eller 888*)';
    $Self->{Translation}->{'CABAgent'} = 'CAB-saksbehandler';
    $Self->{Translation}->{'e.g.'} = 'f.eks.';
    $Self->{Translation}->{'CABCustomer'} = 'CAB-kunde';
    $Self->{Translation}->{'Instruction'} = 'Instruks';
    $Self->{Translation}->{'Report'} = 'Rapport';
    $Self->{Translation}->{'Change Category'} = 'Endre kategori';
    $Self->{Translation}->{'(before/after)'} = '(før/etter)';
    $Self->{Translation}->{'(between)'} = '(mellom)';
    $Self->{Translation}->{'Run Search'} = 'Utfør søket';

    # Template: AgentITSMChangeSearchResultPrint
    $Self->{Translation}->{'WorkOrders'} = 'Arbeidsordre';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Lagre Endring som Mal';
    $Self->{Translation}->{'A template should have a name!'} = 'En mal må ha et navn!';
    $Self->{Translation}->{'The template name is required.'} = 'Malnavnet er påkrevd.';
    $Self->{Translation}->{'Reset States'} = 'Nullstill tilstander';

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
    $Self->{Translation}->{'Download Attachment'} = 'Last ned vedlegg';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = 'Virkelig slette denne malen?';

    # Template: AgentITSMTemplateEdit

    # Template: AgentITSMTemplateOverviewNavBar

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = 'Mal-ID';
    $Self->{Translation}->{'CreateBy'} = 'Opprettet av';
    $Self->{Translation}->{'CreateTime'} = 'Opprettet';
    $Self->{Translation}->{'ChangeBy'} = 'Opprettet av';
    $Self->{Translation}->{'ChangeTime'} = 'Endret';
    $Self->{Translation}->{'Delete: '} = 'Slett: ';
    $Self->{Translation}->{'Delete Template'} = 'Slett Mal';

    # Template: AgentITSMUserSearch

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = 'Legg Arbeidsordre til';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Ugyldig type arbeidsordre';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'Planlagt starttid må være før planlagt sluttid';
    $Self->{Translation}->{'Invalid format.'} = 'Ugyldig format.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Velg mal for Arbeidsordren';

    # Template: AgentITSMWorkOrderAgent

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Virkelig slette denne arbeidsordren?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Du kan ikke slette arbeidsordren. Den er i bruk av minst én forutsetning!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Denne arbeidsordren brukes av følgende Forutsetning(er)';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = '';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        '';

    # Template: AgentITSMWorkOrderHistory

    # Template: AgentITSMWorkOrderHistoryZoom

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'Faktisk starttid må være før faktisk sluttid';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'Hvis sluttiden settes må også starttid settes!';
    $Self->{Translation}->{'Existing attachments'} = '';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Nåværende saksbehandler';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Vil du virkelig ta denne arbeidsordren?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Lagre Arbeidsordre som Mal';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Arbeidsordre-info';

    # Template: CustomerITSMChangeOverview

    # Template: ITSMChange

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        'Liste over saksbehandlere som har tilgang til å ta arbeidsordre. Innholdet er 0 eller 1.';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        'Liste over arbeidsordretilstander som vil utløse at faktisk starttid blir satt (hvis tom fra før).';
    $Self->{Translation}->{'Admin of notification rules.'} = '';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = 'Administrasjon av CIP-matrisen';
    $Self->{Translation}->{'Admin of the state machine.'} = 'Administrasjon av tilstandsendringer';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        'Saksbehandlermodul som viser antallet endringsråd.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        'Saksbehandlermodul som viser antallet endringer styrt av brukeren.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        'Saksbehandlermodul som viser antallet endringer.';
    $Self->{Translation}->{'Agent interface notification module to see the number of work orders.'} =
        'Saksbehandlermodul som viser antallet arbeidsordre.';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        '';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        '';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = '';
    $Self->{Translation}->{'Change free text options shown in the change add of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        'Vis fritekstfelt for innlegg vist i "Legg til Endring"-skjermen. Mulige innstillinger: 0 = Av, 1 = På, 2 = På og obligatorisk';
    $Self->{Translation}->{'Change free text options shown in the change edit of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        'Vis fritekstfelt for innlegg vist i "Endringsredigering"-skjermen. Mulige innstillinger: 0 = Av, 1 = På, 2 = På og obligatorisk';
    $Self->{Translation}->{'Change free text options shown in the change search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        'Vis fritekstfelt for innlegg vist i Søk etter Endringer. Mulige innstillinger: 0 = Av, 1 = På, 2 = På og obligatorisk';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small"'} = 'Endre antall viste Endringer per side i "Liten" visning';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = '';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        'Setter opp hvor ofte meldinger blir sendt ut når planlagt starttid eller andre tidspunkter nås eller passeres';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        'Forvalgt type for en arbeidsordre. Denne verdien må finnes i generell katalog.';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = 'Sett opp signaler for hver arbeidsordretilstand';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        'Setter opp en oversiktsmodul til å vise "Liten" visning av endringslisten';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        'Setter opp en oversiktsmodul til å vise "Liten" visning av mal-listen';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = 'Spesifiserer om det er mulig å skrive ut kontert tid.';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = 'Spesifiserer om det er mulig å skrive ut planlagt innsats.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = 'Spesifiserer om tidskontering skal vises.';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = 'Spesifiserer om faktisk start- og sluttid bør settes.';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        '';
    $Self->{Translation}->{'Defines if the change state can be set in AgentITSMChangeEdit.'} =
        'Spesifiserer om Endringstilstand kan settes i "Endre Endring"';
    $Self->{Translation}->{'Defines if the planned effort should be shown.'} = 'Spesifiserer om planlagt innsats skal vises.';
    $Self->{Translation}->{'Defines if the requested date should be print by customer.'} = 'Spesifiserer om forespurt dato skal kunne skrives ut av kunden';
    $Self->{Translation}->{'Defines if the requested date should be searched by customer.'} =
        'Spesifiserer om forespurt dato skal være søkbar av kunden';
    $Self->{Translation}->{'Defines if the requested date should be set by customer.'} = 'Spesifiserer om forespurt dato skal kunne settes av kunden.';
    $Self->{Translation}->{'Defines if the requested date should be shown by customer.'} = 'Spesifiserer om forespurt dato skal vises til kunden.';
    $Self->{Translation}->{'Defines if the workorder state should be shown.'} = 'Spesifiserer om arbeidsordrens tilstand skal vises.';
    $Self->{Translation}->{'Defines if the workorder title should be shown.'} = 'Spesifiserer om arbeidsordrens tittel skal vises.';
    $Self->{Translation}->{'Defines shown graph attributes.'} = '';
    $Self->{Translation}->{'Defines that only changes containing Workorders linked with services, which the customer user has permission to use will be shown. Any other changes will not be displayed.'} =
        'Spesifiserer at kun Endringer som inneholder Arbeidsordre som er koblet til Tjenester som kunden har tilgang til å bruke skal vises. Alle andre endringer vil ikke bli viste.';
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change PSA overview.'} =
        'Spesifiserer Endringstilstander som kan brukes som filtre i oversikten over Forventet Tilgjengelighet (PSA)';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change Schedule overview.'} =
        'Spesifiserer Endringstilstander som kan brukes som filtre i Endringsplan-oversikten';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyCAB overview.'} =
        'Spesifiserer Endringstilstander som kan brukes som filtre i "Mine Endringsråd"';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyChanges overview.'} =
        'Spesifiserer Endringstilstander som kan brukes som filtre i "Mine Endringer"';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change manager overview.'} =
        'Spesifiserer Endringstilstander som kan brukes som filtre i Endringsansvarlig-oversikten';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change overview.'} =
        'Spesifiserer Endringstilstander som kan brukes som filtre i Endringsoversikten';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the customer change schedule overview.'} =
        'Spesifiserer Endringstilstander som kan brukes som filtre i kundens Endringsplan-oversikt';
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
        'Definerer standard sorteringskriterier for Forventet Tilgjengelighet (PSA)-oversikten.';
    $Self->{Translation}->{'Defines the default sort criteria in the change manager overview.'} =
        'Definerer standard sorteringskriterier for endringsansvarlig-oversikten';
    $Self->{Translation}->{'Defines the default sort criteria in the change overview.'} = 'Definerer standard sorteringskriterier for Endringsoversikten';
    $Self->{Translation}->{'Defines the default sort criteria in the change schedule overview.'} =
        'Definerer standard sorteringskriterier for Endringsplan-oversikten';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyCAB overview.'} =
        'Definerer standard sorteringskriterier for "Mine Endringsråd"';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyChanges overview.'} =
        'Definerer standard sorteringskriterier for "Mine Endringer"';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyWorkorders overview.'} =
        'Definerer standard sorteringskriterier for "Mine Arbeidsordre"';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the PIR overview.'} =
        'Definerer standard sorteringskriterier for Sluttevalueringsoversikten';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the customer change schedule overview.'} =
        'Definerer standard sorteringskriterier for Endringsplan-oversikten for kunder';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the template overview.'} =
        'Definerer standard sorteringskriterier for mal-oversikten';
    $Self->{Translation}->{'Defines the default sort order in the MyCAB overview.'} = 'Definerer standard sorteringsrekkefølge for "Mine Endringsråd"';
    $Self->{Translation}->{'Defines the default sort order in the MyChanges overview.'} = 'Definerer standard sorteringsrekkefølge for "Mine Endringer"';
    $Self->{Translation}->{'Defines the default sort order in the MyWorkorders overview.'} =
        'Definerer standard sorteringsrekkefølge for "Mine Arbeidsordre"';
    $Self->{Translation}->{'Defines the default sort order in the PIR overview.'} = 'Definerer standard sorteringsrekkefølge for Sluttevaluering-oversikten';
    $Self->{Translation}->{'Defines the default sort order in the change PSA overview.'} = 'Definerer standard sorteringsrekkefølge for Forventet Tilgjengelighet (PSA)-oversikten';
    $Self->{Translation}->{'Defines the default sort order in the change manager overview.'} =
        'Definerer standard sorteringsrekkefølge for Endringsansvarlig-oversikten';
    $Self->{Translation}->{'Defines the default sort order in the change overview.'} = 'Definerer standard sorteringsrekkefølge for Endringsoversikten';
    $Self->{Translation}->{'Defines the default sort order in the change schedule overview.'} =
        'Definerer standard sorteringsrekkefølge for Endringsplan-oversikten';
    $Self->{Translation}->{'Defines the default sort order in the customer change schedule overview.'} =
        'Definerer standard sorteringsrekkefølge for Endringsplan-oversikten for kunder';
    $Self->{Translation}->{'Defines the default sort order in the template overview.'} = 'Definerer standard sorteringsrekkefølge for mal-oversikten';
    $Self->{Translation}->{'Defines the default value for the category of a change.'} = 'Definerer forvalgt kategori for en Endring';
    $Self->{Translation}->{'Defines the default value for the impact of a change.'} = 'Definerer en forvalgt verdi for omfanget til en Endring';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for change attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        '';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for workorder attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        '';
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
    $Self->{Translation}->{'Defines the maximum number of change freetext fields.'} = '';
    $Self->{Translation}->{'Defines the maximum number of workorder freetext fields.'} = '';
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
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeFreeKey in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeFreeText in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeManagerID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeStateID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeTitle in AgentITSMChangeConditionEdit.'} =
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
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderFreeKey in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderFreeText in AgentITSMChangeConditionEdit.'} =
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
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom.'} =
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
    $Self->{Translation}->{'Event list to be displayed on GUI to trigger generic interface invokers.'} =
        '';
    $Self->{Translation}->{'ITSM event module deletes the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = '';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = '';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        '';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = '';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = '';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        '';
    $Self->{Translation}->{'ITSM event module updates the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module updates the history of conditions.'} = '';
    $Self->{Translation}->{'ITSM event module updates the history of workorders.'} = '';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notications are sent (every X hours).'} =
        '';
    $Self->{Translation}->{'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.'} =
        '';
    $Self->{Translation}->{'Logfile for the ITSM change counter. This file is used for creating the change numbers.'} =
        'Loggfil for ITSM Endringsteller. Denne filen brukes for å opprett endringsnumrene';
    $Self->{Translation}->{'Module to check the CAB members.'} = 'Modul for å sjekke CAB-medlemmer';
    $Self->{Translation}->{'Module to check the agent.'} = 'Modul for å sjekke saksbehandleren';
    $Self->{Translation}->{'Module to check the change builder.'} = 'Modul for å sjekke den som opprettet Endringen';
    $Self->{Translation}->{'Module to check the change manager.'} = 'Modul for å sjekke Endringsansvarlig';
    $Self->{Translation}->{'Module to check the workorder agent.'} = 'Modul for å sjekke saksbehandler for en arbeidsordre';
    $Self->{Translation}->{'Module to check whether no workorder agent is set.'} = 'Modul for å sjekk om ingen saksbehandler er satt for arbeidsordren';
    $Self->{Translation}->{'Module to check whether the agent is contained in the configured list.'} =
        'Modul som sjekker om saksbehandleren befinner seg i den konfigurerte listen.';
    $Self->{Translation}->{'Module to show a link to create a change from this ticket. The ticket will be automatically linked with the new change.'} =
        '';
    $Self->{Translation}->{'Notification (ITSM Change Management)'} = 'Meldinger (ITSM Endringsstyring)';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        '';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        '';
    $Self->{Translation}->{'Presents a link in the menu to show the involved persons in a change, in the zoom view of such change in the agent interface.'} =
        '';
    $Self->{Translation}->{'Required privileges in order for an agent to take a workorder.'} =
        'Rettigheter som kreves for at en saksbehandler skal kunne ta en arbeidsordre';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = 'Rettigheter som kreves for å se oversikt over alle endringer';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = 'Rettigheter som kreves for å opprette en arbeidsordre.';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = 'Rettigheter som kreves for å endre saksbehandler på en arbeidsordre.';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = 'Rettigheter som kreves for å opprett en mal fra en endring';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        'Rettigheter som kreves for å opprette en mal fra en endrings endringsråd (CAB).';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = 'Rettigheter som kreves for å opprett en mal fra en arbeidsordre';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = '';
    $Self->{Translation}->{'Required privileges to create changes.'} = 'Rettigheter som kreves for å opprette endringer.';
    $Self->{Translation}->{'Required privileges to delete a template.'} = 'Rettighter som kreves for å slette en mal';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = 'Rettigheter som kreves for å slette en arbeidsordre';
    $Self->{Translation}->{'Required privileges to delete changes.'} = '';
    $Self->{Translation}->{'Required privileges to edit a template.'} = 'Rettigheter som kreves for å redigere en mal';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = 'Rettigheter som kreves for å redigere en arbeidsordre';
    $Self->{Translation}->{'Required privileges to edit changes.'} = 'Rettigheter som kreves for å redigere endringer';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = 'Rettigheter som kreves for å endre forutsetninger for en endring';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        'Rettigheter som kreves for å endre involverte personer i en endring';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = 'Rettigheter som kreves for å flytte endringer i tid';
    $Self->{Translation}->{'Required privileges to print a change.'} = 'Rettigheter som kreves for å skrive ut en endring';
    $Self->{Translation}->{'Required privileges to reset changes.'} = '';
    $Self->{Translation}->{'Required privileges to view a workorder.'} = 'Rettigheter som kreves for å se en arbeidsordre';
    $Self->{Translation}->{'Required privileges to view changes.'} = 'Rettigheter som kreves for å se endringer';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is a CAB member.'} =
        'Rettigheter som kreves for å se listen over endringer der brukeren er medlem av CAB';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is the change manager.'} =
        'Rettigheter som kreves for å se listen over endringer der brukeren er endringsansvarlig';
    $Self->{Translation}->{'Required privileges to view overview over all templates.'} = 'Rettigheter som kreves for å se oversikten over alle maler.';
    $Self->{Translation}->{'Required privileges to view the conditions of changes.'} = 'Rettigheter som kreves for å se forutsetningene til endringer';
    $Self->{Translation}->{'Required privileges to view the history of a change.'} = 'Rettigheter som kreves for å se historikken til en endring';
    $Self->{Translation}->{'Required privileges to view the history of a workorder.'} = 'Rettigheter som kreves for å se historikken til en arbeidsordre';
    $Self->{Translation}->{'Required privileges to view the history zoom of a change.'} = 'Rettigheter som kreves for å se detaljert historikk for en endring';
    $Self->{Translation}->{'Required privileges to view the history zoom of a workorder.'} =
        'Rettigheter som kreves for å se detaljert historikk for en arbeidsordre';
    $Self->{Translation}->{'Required privileges to view the list of Change Schedule.'} = 'Rettigheter som kreves for å se listen over Endringsplaner';
    $Self->{Translation}->{'Required privileges to view the list of change PSA.'} = 'Rettigheter som kreves for å se listen over endringers forventede tjenestetilgjengelighet';
    $Self->{Translation}->{'Required privileges to view the list of changes with an upcoming PIR (Post Implementation Review).'} =
        'Rettigheter som kreves for å se listen over endringer med kommende Sluttevalueringer';
    $Self->{Translation}->{'Required privileges to view the list of own changes.'} = 'Rettigheter som kreves for å se listen over egne endringer';
    $Self->{Translation}->{'Required privileges to view the list of own workorders.'} = 'Rettigheter som kreves for å se listen over egne arbeidsordre';
    $Self->{Translation}->{'Required privileges to write a report for the workorder.'} = 'Rettigheter som kreves for å skrive en rapport for arbeidsordren';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        '';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        '';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = 'Setter opp tilstandsendringer for Endringer';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = 'Setter opp tilstandsendringer for Arbeidsordre';
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
    $Self->{Translation}->{'State Machine'} = 'Tilstandsendringer';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        '';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        '';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        '';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        '';
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
    $Self->{Translation}->{'Cache time in minutes for the change management.'} = 'Mellomlagringstid i minutter for endringsstyring';
    $Self->{Translation}->{'Change#'} = 'Endringsnr';
    $Self->{Translation}->{'PIR'} = 'PIR (Sluttevaluering)';
    $Self->{Translation}->{'Projected Service Availability'} = 'PSA (Forventet tjenestetilgjengelighet)';
    $Self->{Translation}->{'Search Agent'} = 'Søk etter Saksbehandler';
    $Self->{Translation}->{'Your language'} = 'Ditt språk';

}

1;
