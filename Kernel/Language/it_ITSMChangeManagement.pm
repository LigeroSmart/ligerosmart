# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::it_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category ↔ Impact ↔ Priority'} = 'Categoria ↔ Impatto ↔ Priorità';
    $Self->{Translation}->{'Manage the priority result of combinating Category ↔ Impact.'} =
        'Gestire il risultato prioritario della combinazione di Categoria ↔ Impatto.';
    $Self->{Translation}->{'Priority allocation'} = 'Assegnazione prioritaria';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'Gestione delle notifiche di ChangeManagement ITSM';
    $Self->{Translation}->{'Add Notification Rule'} = 'Aggiungi regola di notifica';
    $Self->{Translation}->{'Edit Notification Rule'} = 'Modifica regola di notifica';
    $Self->{Translation}->{'A notification should have a name!'} = 'Una notifica deve avere un nome!';
    $Self->{Translation}->{'Name is required.'} = 'Il nome è obbligatorio.';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'Admin State Machine';
    $Self->{Translation}->{'Select a catalog class!'} = 'Seleziona una classe di catalogo!';
    $Self->{Translation}->{'A catalog class is required!'} = 'Una classe di catalogo è richiesta!';
    $Self->{Translation}->{'Add a state transition'} = 'Aggiungi una transizione di stato';
    $Self->{Translation}->{'Catalog Class'} = 'Classe di Catalogo';
    $Self->{Translation}->{'Object Name'} = 'Nome oggetto';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Panoramica sulle transizioni di stato per';
    $Self->{Translation}->{'Delete this state transition'} = 'Elimina questa transizione di stato';
    $Self->{Translation}->{'Add a new state transition for'} = 'Aggiungi una nuova transizione di stato per';
    $Self->{Translation}->{'Please select a state!'} = 'Seleziona uno stato!';
    $Self->{Translation}->{'Please select a next state!'} = 'Seleziona uno stato successivo!';
    $Self->{Translation}->{'Edit a state transition for'} = 'Modifica una transizione di stato per';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Vuoi veramente cancellare la transizione di stato';

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'Aggiungi modifica';
    $Self->{Translation}->{'ITSM Change'} = 'ITSM Change';
    $Self->{Translation}->{'Justification'} = 'Giustificazione';
    $Self->{Translation}->{'Input invalid.'} = 'Input non valido.';
    $Self->{Translation}->{'Impact'} = 'Impatto';
    $Self->{Translation}->{'Requested Date'} = 'Data richiesta';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'Seleziona Cambia modello';
    $Self->{Translation}->{'Time type'} = 'Tipo di tempo';
    $Self->{Translation}->{'Invalid time type.'} = 'Tipo di tempo non valido.';
    $Self->{Translation}->{'New time'} = 'Nuovo tempo';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'Salva Modifica CAB come modello';
    $Self->{Translation}->{'go to involved persons screen'} = 'vai alla schermata delle persone coinvolte';
    $Self->{Translation}->{'Invalid Name'} = 'Nome non valido';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Condizioni e azioni';
    $Self->{Translation}->{'Delete Condition'} = 'Elimina condizione';
    $Self->{Translation}->{'Add new condition'} = 'Aggiungi nuova condizione';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Edit Condition'} = 'Modifica condizione';
    $Self->{Translation}->{'Need a valid name.'} = 'Hai bisogno di un nome valido.';
    $Self->{Translation}->{'A valid name is needed.'} = 'È necessario un nome valido.';
    $Self->{Translation}->{'Duplicate name:'} = 'Nome duplicato:';
    $Self->{Translation}->{'This name is already used by another condition.'} = 'Questo nome è già utilizzato da un\'altra condizione.';
    $Self->{Translation}->{'Matching'} = 'Accoppiamento';
    $Self->{Translation}->{'Any expression (OR)'} = 'Qualsiasi espressione (OR)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Tutte le espressioni (AND)';
    $Self->{Translation}->{'Expressions'} = 'Espressioni';
    $Self->{Translation}->{'Selector'} = 'Selettore';
    $Self->{Translation}->{'Operator'} = 'Operatore';
    $Self->{Translation}->{'Delete Expression'} = 'Elimina espressione';
    $Self->{Translation}->{'No Expressions found.'} = 'Nessuna espressione trovata.';
    $Self->{Translation}->{'Add new expression'} = 'Aggiungi nuova espressione';
    $Self->{Translation}->{'Delete Action'} = 'Elimina azione';
    $Self->{Translation}->{'No Actions found.'} = 'Nessuna azione trovata.';
    $Self->{Translation}->{'Add new action'} = 'Aggiungi nuova azione';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = 'Vuoi veramente cancellare questa modifica?';

    # Template: AgentITSMChangeEdit
    $Self->{Translation}->{'Edit %s%s'} = 'Modificare %s%s';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of %s%s'} = 'Storico di %s%s';
    $Self->{Translation}->{'History Content'} = '';
    $Self->{Translation}->{'Workorder'} = 'Ordine di lavoro';
    $Self->{Translation}->{'Createtime'} = '';
    $Self->{Translation}->{'Show details'} = 'Mostra i dettagli';
    $Self->{Translation}->{'Show workorder'} = 'Mostrare ordine di lavoro';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of %s'} = 'Informazioni dettagliate sulla storia di %s';
    $Self->{Translation}->{'Modified'} = 'Modificata';
    $Self->{Translation}->{'Old Value'} = 'Vecchio valore';
    $Self->{Translation}->{'New Value'} = 'Nuovo valore';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Edit Involved Persons of %s%s'} = 'Modifica persone coinvolte di %s%s';
    $Self->{Translation}->{'Involved Persons'} = 'Persone coinvolte';
    $Self->{Translation}->{'ChangeManager'} = 'ChangeManager';
    $Self->{Translation}->{'User invalid.'} = 'Utente non valido.';
    $Self->{Translation}->{'ChangeBuilder'} = 'ChangeBuilder';
    $Self->{Translation}->{'Change Advisory Board'} = 'Consiglio consultivo del cambiamento';
    $Self->{Translation}->{'CAB Template'} = 'Modello CAB';
    $Self->{Translation}->{'Apply Template'} = 'Applica Modello';
    $Self->{Translation}->{'NewTemplate'} = 'NewTemplate';
    $Self->{Translation}->{'Save this CAB as template'} = 'Salva questo CAB come modello';
    $Self->{Translation}->{'Add to CAB'} = 'Aggiungi a CAB';
    $Self->{Translation}->{'Invalid User'} = 'Utente non valido';
    $Self->{Translation}->{'Current CAB'} = 'CAB corrente';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = '';
    $Self->{Translation}->{'Changes per page'} = 'Modifiche per pagina';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'Workorder Title'} = 'Titolo dell\'ordine di lavoro';
    $Self->{Translation}->{'Change Title'} = 'Cambia titolo';
    $Self->{Translation}->{'Workorder Agent'} = 'Agente di ordine di lavoro';
    $Self->{Translation}->{'Change Builder'} = 'Cambia costruttore';
    $Self->{Translation}->{'Change Manager'} = 'Gestione dei Change';
    $Self->{Translation}->{'Workorders'} = 'Ordini di lavoro';
    $Self->{Translation}->{'Change State'} = 'Cambia stato';
    $Self->{Translation}->{'Workorder State'} = 'Stato dell\'ordine di lavoro';
    $Self->{Translation}->{'Workorder Type'} = 'Tipo di ordine di lavoro';
    $Self->{Translation}->{'Requested Time'} = 'Tempo richiesto';
    $Self->{Translation}->{'Planned Start Time'} = 'Ora di inizio pianificata';
    $Self->{Translation}->{'Planned End Time'} = 'Ora di fine pianificata';
    $Self->{Translation}->{'Actual Start Time'} = 'Ora di inizio effettiva';
    $Self->{Translation}->{'Actual End Time'} = 'Ora di fine effettiva';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = 'Vuoi davvero ripristinare questa modifica?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(ad es. \'10*5155\' o \'105658*\')';
    $Self->{Translation}->{'CAB Agent'} = 'Agente CAB';
    $Self->{Translation}->{'e.g.'} = 'ad es.';
    $Self->{Translation}->{'CAB Customer'} = 'Cliente CAB';
    $Self->{Translation}->{'ITSM Workorder Instruction'} = 'Istruzioni per l\'ordinatore ITSM';
    $Self->{Translation}->{'ITSM Workorder Report'} = 'Rapporto sull\'ordine di lavoro ITSM';
    $Self->{Translation}->{'ITSM Change Priority'} = 'Priorità di cambiamento ITSM';
    $Self->{Translation}->{'ITSM Change Impact'} = 'Impatto del cambiamento ITSM';
    $Self->{Translation}->{'Change Category'} = 'Cambia categoria';
    $Self->{Translation}->{'(before/after)'} = '(prima/dopo)';
    $Self->{Translation}->{'(between)'} = '(tra)';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Salva modifica come modello';
    $Self->{Translation}->{'A template should have a name!'} = 'Un modello dovrebbe avere un nome!';
    $Self->{Translation}->{'The template name is required.'} = 'È richiesto il nome del modello.';
    $Self->{Translation}->{'Reset States'} = 'Ripristina Stati';
    $Self->{Translation}->{'Overwrite original template'} = 'Sovrascrivi modello originale';
    $Self->{Translation}->{'Delete original change'} = 'Elimina la modifica originale';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Sposta fascia oraria';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'Modifica informazioni';
    $Self->{Translation}->{'Planned Effort'} = 'Sforzo pianificato';
    $Self->{Translation}->{'Accounted Time'} = 'Tempo contabilizzato';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Cambia iniziatore(i)';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Ultima modifica';
    $Self->{Translation}->{'Last changed by'} = '';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        '';
    $Self->{Translation}->{'Download Attachment'} = '';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = 'Modifica modello CAB';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        'Ciò creerà una nuova modifica da questo modello, quindi puoi modificarlo e salvarlo.';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        'La nuova modifica verrà eliminata automaticamente dopo essere stata salvata come modello.';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        'Ciò creerà un nuovo ordine di lavoro da questo modello, in modo che tu possa modificarlo e salvarlo.';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        'Verrà creato un cambiamento temporaneo che contiene l\'ordine di lavoro.';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        'La modifica temporanea e il nuovo ordine di lavoro verranno eliminati automaticamente dopo che l\'ordine di lavoro è stato salvato come modello.';
    $Self->{Translation}->{'Do you want to proceed?'} = 'Vuoi continuare?';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'Template ID'} = 'Modello ID';
    $Self->{Translation}->{'Edit Content'} = 'Modifica contenuto';
    $Self->{Translation}->{'Create by'} = 'Creato da';
    $Self->{Translation}->{'Change by'} = 'Cambiato da';
    $Self->{Translation}->{'Change Time'} = 'Cambia ora';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to %s%s'} = 'Aggiungi ordine di lavoro a %s%s';
    $Self->{Translation}->{'Instruction'} = 'Istruzione';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Tipo di ordine di lavoro non valido.';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'L\'ora di inizio pianificata deve essere precedente all\'ora di fine pianificata!';
    $Self->{Translation}->{'Invalid format.'} = 'Formato non valido.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Seleziona modello di ordine di lavoro';

    # Template: AgentITSMWorkOrderAgent
    $Self->{Translation}->{'Edit Workorder Agent of %s%s'} = 'Modifica agente di lavoro di %s%s';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Vuoi veramente cancellare questo ordine?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Non è possibile eliminare questo ordine di lavoro. È usato in almeno una condizione!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Questo ordine di lavoro viene utilizzato nelle seguenti condizione(i)';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Edit %s%s-%s'} = 'Modifica %s%s-%s';
    $Self->{Translation}->{'Move following workorders accordingly'} = 'Spostare i seguenti ordini di lavoro di conseguenza';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        'Se l\'ora di fine pianificata di questo ordine di lavoro viene modificata, gli orari di inizio pianificati di tutti i seguenti ordini di lavoro verranno modificati di conseguenza';

    # Template: AgentITSMWorkOrderHistory
    $Self->{Translation}->{'History of %s%s-%s'} = 'Storia di %s%s-%s';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'Edit Report of %s%s-%s'} = 'Modifica rapporto di %s%s-%s';
    $Self->{Translation}->{'Report'} = 'Report';
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'L\'ora di inizio effettiva deve essere precedente all\'ora di fine effettiva!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'L\'ora di inizio effettiva deve essere impostata, quando è impostata l\'ora di fine effettiva!';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Agente attuale';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Vuoi davvero prendere questo ordine?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Salva Modello di lavoro come modello';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = 'Elimina ordine di lavoro originale (e modifiche circostanti)';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Informazioni ordine di lavoro';

    # Perl Module: Kernel/Modules/AdminITSMChangeNotification.pm
    $Self->{Translation}->{'Notification Added!'} = 'Notifica aggiunta!';
    $Self->{Translation}->{'Unknown notification %s!'} = 'Notifica sconosciuta %s!';
    $Self->{Translation}->{'There was an error creating the notification.'} = 'Si è verificato un errore durante la creazione della notifica.';

    # Perl Module: Kernel/Modules/AdminITSMStateMachine.pm
    $Self->{Translation}->{'State Transition Updated!'} = 'Transizione di stato aggiornata!';
    $Self->{Translation}->{'State Transition Added!'} = 'Aggiunta transizione di stato!';

    # Perl Module: Kernel/Modules/AgentITSMChange.pm
    $Self->{Translation}->{'Overview: ITSM Changes'} = 'Panoramica: modifiche ITSM';

    # Perl Module: Kernel/Modules/AgentITSMChangeAdd.pm
    $Self->{Translation}->{'Ticket with TicketID %s does not exist!'} = 'Ticket con TicketID %s non esiste!';
    $Self->{Translation}->{'Missing sysconfig option "ITSMChange::AddChangeLinkTicketTypes"!'} =
        'Opzione sysconfig mancante "ITSMChange::AddChangeLinkTicketTypes"!';
    $Self->{Translation}->{'Was not able to add change!'} = 'Non è stato possibile aggiungere il cambiamento!';

    # Perl Module: Kernel/Modules/AgentITSMChangeAddFromTemplate.pm
    $Self->{Translation}->{'Was not able to create change from template!'} = 'Impossibile creare il cambiamento dal modello!';

    # Perl Module: Kernel/Modules/AgentITSMChangeCABTemplate.pm
    $Self->{Translation}->{'No ChangeID is given!'} = ' Nessun ChangeID è dato!';
    $Self->{Translation}->{'No change found for changeID %s.'} = 'Nessuna modifica trovata per changeID %s.';
    $Self->{Translation}->{'The CAB of change "%s" could not be serialized.'} = 'Il CAB del cambiamento "%s" non è stato possibile serializzare.';
    $Self->{Translation}->{'Could not add the template.'} = 'Impossibile aggiungere il modello.';

    # Perl Module: Kernel/Modules/AgentITSMChangeCondition.pm
    $Self->{Translation}->{'Change "%s" not found in database!'} = 'Modificare "%s" non trovato nel database!';
    $Self->{Translation}->{'Could not delete ConditionID %s!'} = 'Impossibile eliminare ConditionID %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeConditionEdit.pm
    $Self->{Translation}->{'No %s is given!'} = '';
    $Self->{Translation}->{'Could not create new condition!'} = 'Impossibile creare una nuova condizione!';
    $Self->{Translation}->{'Could not update ConditionID %s!'} = 'Impossibile aggiornare ConditionID %s!';
    $Self->{Translation}->{'Could not update ExpressionID %s!'} = 'Impossibile aggiornare ExpressionID %s!';
    $Self->{Translation}->{'Could not add new Expression!'} = 'Impossibile aggiungere una nuova espressione!';
    $Self->{Translation}->{'Could not update ActionID %s!'} = 'Impossibile aggiornare ActionID %s!';
    $Self->{Translation}->{'Could not add new Action!'} = 'Impossibile aggiungere una nuova azione!';
    $Self->{Translation}->{'Could not delete ExpressionID %s!'} = 'Impossibile eliminare ExpressionID %s!';
    $Self->{Translation}->{'Could not delete ActionID %s!'} = 'Impossibile eliminare ActionID %s!';
    $Self->{Translation}->{'Error: Unknown field type "%s"!'} = 'Errore: tipo di campo sconosciuto "%s"!';
    $Self->{Translation}->{'ConditionID %s does not belong to the given ChangeID %s!'} = 'ConditionID %s non appartiene al ChangeID specificato %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeDelete.pm
    $Self->{Translation}->{'Change "%s" does not have an allowed change state to be deleted!'} =
        'Modificare "%s" non è consentito eliminare uno stato di modifica!';
    $Self->{Translation}->{'Was not able to delete the changeID %s!'} = 'Impossibile eliminare il changeID %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeEdit.pm
    $Self->{Translation}->{'Was not able to update Change!'} = 'Impossibile aggiornare Change!';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ChangeID is given!'} = 'Impossibile mostrare la cronologia, poiché non viene fornito alcun ChangeID!';
    $Self->{Translation}->{'Change "%s" not found in the database!'} = 'Modificare "%s" non trovato nel database!';
    $Self->{Translation}->{'Unknown type "%s" encountered!'} = 'Tipo sconosciuto "%s" incontrato!';
    $Self->{Translation}->{'Change History'} = 'Cambiare la storia';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistoryZoom.pm
    $Self->{Translation}->{'Can\'t show history zoom, no HistoryEntryID is given!'} = 'Impossibile mostrare lo zoom della cronologia, non viene fornito alcun HistoryEntryID!';
    $Self->{Translation}->{'HistoryEntry "%s" not found in database!'} = 'HistoryEntry "%s" non trovato nel database!';

    # Perl Module: Kernel/Modules/AgentITSMChangeInvolvedPersons.pm
    $Self->{Translation}->{'Was not able to update Change CAB for Change %s!'} = 'Impossibile aggiornare Change CAB for Change %s!';
    $Self->{Translation}->{'Was not able to update Change %s!'} = 'Impossibile aggiornare Change %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeManager.pm
    $Self->{Translation}->{'Overview: ChangeManager'} = 'Panoramica: ChangeManager';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyCAB.pm
    $Self->{Translation}->{'Overview: My CAB'} = 'Panoramica: My CAB';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyChanges.pm
    $Self->{Translation}->{'Overview: My Changes'} = 'Panoramica: le mie modifiche';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyWorkOrders.pm
    $Self->{Translation}->{'Overview: My Workorders'} = 'Panoramica: I miei lavori';

    # Perl Module: Kernel/Modules/AgentITSMChangePIR.pm
    $Self->{Translation}->{'Overview: PIR'} = 'Panoramica: PIR';

    # Perl Module: Kernel/Modules/AgentITSMChangePSA.pm
    $Self->{Translation}->{'Overview: PSA'} = 'Panoramica: PSA';

    # Perl Module: Kernel/Modules/AgentITSMChangePrint.pm
    $Self->{Translation}->{'WorkOrder "%s" not found in database!'} = 'Ordine di lavoro "%s" non trovato nel database!';
    $Self->{Translation}->{'Can\'t create output, as the workorder is not attached to a change!'} =
        'Impossibile creare output, poiché il workorder non è associato a una modifica!';
    $Self->{Translation}->{'Can\'t create output, as no ChangeID is given!'} = 'Impossibile creare output, poiché non viene fornito alcun ChangeID!';
    $Self->{Translation}->{'unknown change title'} = 'titolo del cambiamento sconosciuto';
    $Self->{Translation}->{'ITSM Workorder'} = 'Ordine di lavoro ITSM';
    $Self->{Translation}->{'WorkOrderNumber'} = 'WorkOrderNumber';
    $Self->{Translation}->{'WorkOrderTitle'} = 'WorkOrderTitle';
    $Self->{Translation}->{'unknown workorder title'} = 'titolo di lavoro sconosciuto';
    $Self->{Translation}->{'ChangeState'} = 'ChangeState';
    $Self->{Translation}->{'PlannedEffort'} = 'PlannedEffort';
    $Self->{Translation}->{'CAB Agents'} = 'Agenti CAB';
    $Self->{Translation}->{'CAB Customers'} = 'Clienti CAB';
    $Self->{Translation}->{'RequestedTime'} = 'RequestedTime';
    $Self->{Translation}->{'PlannedStartTime'} = 'PlannedStartTime';
    $Self->{Translation}->{'PlannedEndTime'} = 'PlannedEndTime';
    $Self->{Translation}->{'ActualStartTime'} = 'ActualStartTime';
    $Self->{Translation}->{'ActualEndTime'} = 'ActualEndTime';
    $Self->{Translation}->{'ChangeTime'} = 'ChangeTime';
    $Self->{Translation}->{'ChangeNumber'} = 'ChangeNumber';
    $Self->{Translation}->{'WorkOrderState'} = 'WorkOrderState';
    $Self->{Translation}->{'WorkOrderType'} = 'WorkOrderType';
    $Self->{Translation}->{'WorkOrderAgent'} = 'WorkOrderAgent';
    $Self->{Translation}->{'ITSM Workorder Overview (%s)'} = 'Panoramica sull\'ordine di lavoro ITSM (%s)';

    # Perl Module: Kernel/Modules/AgentITSMChangeReset.pm
    $Self->{Translation}->{'Was not able to reset WorkOrder %s of Change %s!'} = 'Impossibile ripristinare WorkOrder %s di cambiamenti %s!';
    $Self->{Translation}->{'Was not able to reset Change %s!'} = 'Impossibile ripristinare la modifica %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeSchedule.pm
    $Self->{Translation}->{'Overview: Change Schedule'} = 'Panoramica: modifica programma';

    # Perl Module: Kernel/Modules/AgentITSMChangeSearch.pm
    $Self->{Translation}->{'Change Search'} = 'Cambia ricerca';
    $Self->{Translation}->{'ChangeTitle'} = 'ChangeTitle';
    $Self->{Translation}->{'WorkOrders'} = 'WorkOrders';
    $Self->{Translation}->{'Change Search Result'} = 'Cambia risultato ricerca';
    $Self->{Translation}->{'Change Number'} = 'Cambia numero';
    $Self->{Translation}->{'Work Order Title'} = 'Titolo dell\'ordine di lavoro';
    $Self->{Translation}->{'Change Description'} = 'Modifica descrizione';
    $Self->{Translation}->{'Change Justification'} = 'Modifica giustificazione';
    $Self->{Translation}->{'WorkOrder Instruction'} = 'Istruzioni sull\'ordine di lavoro';
    $Self->{Translation}->{'WorkOrder Report'} = 'Rapporto sull\'ordine di lavoro.';
    $Self->{Translation}->{'Change Priority'} = 'Cambia priorità';
    $Self->{Translation}->{'Change Impact'} = '';
    $Self->{Translation}->{'Created By'} = '';
    $Self->{Translation}->{'WorkOrder State'} = '';
    $Self->{Translation}->{'WorkOrder Type'} = '';
    $Self->{Translation}->{'WorkOrder Agent'} = '';
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
    $Self->{Translation}->{'WorkOrder History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistoryZoom.pm
    $Self->{Translation}->{'History entry "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrder History Zoom'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTake.pm
    $Self->{Translation}->{'Was not able to take the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTemplate.pm
    $Self->{Translation}->{'The workorder "%s" could not be serialized.'} = '';

    # Perl Module: Kernel/Output/HTML/Layout/ITSMChange.pm
    $Self->{Translation}->{'Need config option %s!'} = '';
    $Self->{Translation}->{'Config option %s needs to be a HASH ref!'} = '';
    $Self->{Translation}->{'No config option found for the view "%s"!'} = '';
    $Self->{Translation}->{'Title: %s | Type: %s'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyCAB.pm
    $Self->{Translation}->{'My CABs'} = 'I miei CAB';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyChanges.pm
    $Self->{Translation}->{'My Changes'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyWorkOrders.pm
    $Self->{Translation}->{'My Work Orders'} = '';

    # Perl Module: Kernel/System/ITSMChange/History.pm
    $Self->{Translation}->{'%s: %s'} = '';
    $Self->{Translation}->{'New Action (ID=%s)'} = '';
    $Self->{Translation}->{'Action (ID=%s) deleted'} = '';
    $Self->{Translation}->{'All Actions of Condition (ID=%s) deleted'} = '';
    $Self->{Translation}->{'Action (ID=%s) executed: %s'} = '';
    $Self->{Translation}->{'%s (Action ID=%s): (new=%s, old=%s)'} = '';
    $Self->{Translation}->{'Change (ID=%s) reached actual end time.'} = '';
    $Self->{Translation}->{'Change (ID=%s) reached actual start time.'} = '';
    $Self->{Translation}->{'New Change (ID=%s)'} = '';
    $Self->{Translation}->{'New Attachment: %s'} = '';
    $Self->{Translation}->{'Deleted Attachment %s'} = '';
    $Self->{Translation}->{'CAB Deleted %s'} = '';
    $Self->{Translation}->{'%s: (new=%s, old=%s)'} = '';
    $Self->{Translation}->{'Link to %s (ID=%s) added'} = '';
    $Self->{Translation}->{'Link to %s (ID=%s) deleted'} = '';
    $Self->{Translation}->{'Notification sent to %s (Event: %s)'} = '';
    $Self->{Translation}->{'Change (ID=%s) reached planned end time.'} = '';
    $Self->{Translation}->{'Change (ID=%s) reached planned start time.'} = '';
    $Self->{Translation}->{'Change (ID=%s) reached requested time.'} = '';
    $Self->{Translation}->{'New Condition (ID=%s)'} = '';
    $Self->{Translation}->{'Condition (ID=%s) deleted'} = '';
    $Self->{Translation}->{'All Conditions of Change (ID=%s) deleted'} = '';
    $Self->{Translation}->{'%s (Condition ID=%s): (new=%s, old=%s)'} = '';
    $Self->{Translation}->{'New Expression (ID=%s)'} = '';
    $Self->{Translation}->{'Expression (ID=%s) deleted'} = '';
    $Self->{Translation}->{'All Expressions of Condition (ID=%s) deleted'} = '';
    $Self->{Translation}->{'%s (Expression ID=%s): (new=%s, old=%s)'} = '';
    $Self->{Translation}->{'Workorder (ID=%s) reached actual end time.'} = '';
    $Self->{Translation}->{'Workorder (ID=%s) reached actual start time.'} = '';
    $Self->{Translation}->{'New Workorder (ID=%s)'} = '';
    $Self->{Translation}->{'New Attachment for WorkOrder: %s'} = '';
    $Self->{Translation}->{'(ID=%s) New Attachment for WorkOrder: %s'} = '';
    $Self->{Translation}->{'Deleted Attachment from WorkOrder: %s'} = '';
    $Self->{Translation}->{'(ID=%s) Deleted Attachment from WorkOrder: %s'} = '';
    $Self->{Translation}->{'New Report Attachment for WorkOrder: %s'} = '';
    $Self->{Translation}->{'(ID=%s) New Report Attachment for WorkOrder: %s'} = '';
    $Self->{Translation}->{'Deleted Report Attachment from WorkOrder: %s'} = '';
    $Self->{Translation}->{'(ID=%s) Deleted Report Attachment from WorkOrder: %s'} = '';
    $Self->{Translation}->{'Workorder (ID=%s) deleted'} = '';
    $Self->{Translation}->{'(ID=%s) Link to %s (ID=%s) added'} = '';
    $Self->{Translation}->{'(ID=%s) Link to %s (ID=%s) deleted'} = '';
    $Self->{Translation}->{'(ID=%s) Notification sent to %s (Event: %s)'} = '';
    $Self->{Translation}->{'Workorder (ID=%s) reached planned end time.'} = '';
    $Self->{Translation}->{'Workorder (ID=%s) reached planned start time.'} = '';
    $Self->{Translation}->{'(ID=%s) %s: (new=%s, old=%s)'} = '';

    # Perl Module: Kernel/System/ITSMChange/ITSMCondition/Object/ITSMWorkOrder.pm
    $Self->{Translation}->{'all'} = 'tutti';
    $Self->{Translation}->{'any'} = 'qualsiasi';

    # Perl Module: Kernel/System/ITSMChange/Notification.pm
    $Self->{Translation}->{'Previous Change Builder'} = '';
    $Self->{Translation}->{'Previous Change Manager'} = '';
    $Self->{Translation}->{'Workorder Agents'} = '';
    $Self->{Translation}->{'Previous Workorder Agent'} = '';
    $Self->{Translation}->{'Change Initiators'} = '';
    $Self->{Translation}->{'Group ITSMChange'} = '';
    $Self->{Translation}->{'Group ITSMChangeBuilder'} = '';
    $Self->{Translation}->{'Group ITSMChangeManager'} = '';

    # Database XML Definition: ITSMChangeManagement.sopm
    $Self->{Translation}->{'requested'} = 'richiesto';
    $Self->{Translation}->{'pending approval'} = 'in attesa di approvazione';
    $Self->{Translation}->{'rejected'} = 'rifiutato';
    $Self->{Translation}->{'approved'} = 'approvato';
    $Self->{Translation}->{'in progress'} = 'in corso';
    $Self->{Translation}->{'pending pir'} = '';
    $Self->{Translation}->{'successful'} = '';
    $Self->{Translation}->{'failed'} = 'non riuscito';
    $Self->{Translation}->{'canceled'} = 'annullato';
    $Self->{Translation}->{'retracted'} = '';
    $Self->{Translation}->{'created'} = 'creato';
    $Self->{Translation}->{'accepted'} = 'accettato';
    $Self->{Translation}->{'ready'} = 'pronto';
    $Self->{Translation}->{'approval'} = 'approvazione';
    $Self->{Translation}->{'workorder'} = '';
    $Self->{Translation}->{'backout'} = '';
    $Self->{Translation}->{'decision'} = 'decisione';
    $Self->{Translation}->{'pir'} = '';
    $Self->{Translation}->{'ChangeStateID'} = '';
    $Self->{Translation}->{'CategoryID'} = '';
    $Self->{Translation}->{'ImpactID'} = '';
    $Self->{Translation}->{'PriorityID'} = '';
    $Self->{Translation}->{'ChangeManagerID'} = '';
    $Self->{Translation}->{'ChangeBuilderID'} = '';
    $Self->{Translation}->{'WorkOrderStateID'} = '';
    $Self->{Translation}->{'WorkOrderTypeID'} = '';
    $Self->{Translation}->{'WorkOrderAgentID'} = '';
    $Self->{Translation}->{'is'} = 'è';
    $Self->{Translation}->{'is not'} = 'non è';
    $Self->{Translation}->{'is empty'} = 'è vuoto';
    $Self->{Translation}->{'is not empty'} = 'non è vuoto';
    $Self->{Translation}->{'is greater than'} = 'è maggiore di';
    $Self->{Translation}->{'is less than'} = 'è minore di';
    $Self->{Translation}->{'is before'} = 'è prima';
    $Self->{Translation}->{'is after'} = 'è dopo';
    $Self->{Translation}->{'contains'} = 'contiene';
    $Self->{Translation}->{'not contains'} = 'non contiene';
    $Self->{Translation}->{'begins with'} = 'inizia con';
    $Self->{Translation}->{'ends with'} = 'termina con';
    $Self->{Translation}->{'set'} = '';

    # JS File: ITSM.Agent.ChangeManagement.Condition
    $Self->{Translation}->{'Do you really want to delete this expression?'} = '';
    $Self->{Translation}->{'Do you really want to delete this action?'} = '';
    $Self->{Translation}->{'Do you really want to delete this condition?'} = '';

    # JS File: ITSM.Agent.ChangeManagement.ConfirmDialog
    $Self->{Translation}->{'Ok'} = '';

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        '';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        '';
    $Self->{Translation}->{'Actual end time'} = '';
    $Self->{Translation}->{'Actual start time'} = '';
    $Self->{Translation}->{'Add Workorder'} = '';
    $Self->{Translation}->{'Add Workorder (from Template)'} = '';
    $Self->{Translation}->{'Add a change from template.'} = '';
    $Self->{Translation}->{'Add a change.'} = '';
    $Self->{Translation}->{'Add a workorder (from template) to the change.'} = '';
    $Self->{Translation}->{'Add a workorder to the change.'} = '';
    $Self->{Translation}->{'Add from template'} = 'Aggiungi da modello';
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
    $Self->{Translation}->{'Change Schedule'} = '';
    $Self->{Translation}->{'Change Schedule.'} = '';
    $Self->{Translation}->{'Change Settings'} = '';
    $Self->{Translation}->{'Change Zoom'} = '';
    $Self->{Translation}->{'Change Zoom.'} = '';
    $Self->{Translation}->{'Change and Workorder Templates'} = '';
    $Self->{Translation}->{'Change and workorder templates edited by this user.'} = '';
    $Self->{Translation}->{'Change area.'} = '';
    $Self->{Translation}->{'Change involved persons of the change.'} = '';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small".'} = '';
    $Self->{Translation}->{'Change number'} = '';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = '';
    $Self->{Translation}->{'Change state'} = '';
    $Self->{Translation}->{'Change time'} = '';
    $Self->{Translation}->{'Change title'} = '';
    $Self->{Translation}->{'Condition Edit'} = '';
    $Self->{Translation}->{'Condition Overview'} = '';
    $Self->{Translation}->{'Configure which screen should be shown after a new workorder has been created.'} =
        '';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        '';
    $Self->{Translation}->{'Create Change'} = '';
    $Self->{Translation}->{'Create Change (from Template)'} = '';
    $Self->{Translation}->{'Create a change (from template) from this ticket.'} = '';
    $Self->{Translation}->{'Create a change from this ticket.'} = '';
    $Self->{Translation}->{'Create and manage ITSM Change Management notifications.'} = '';
    $Self->{Translation}->{'Create and manage change notifications.'} = '';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        '';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        '';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = '';
    $Self->{Translation}->{'Define which columns are shown in the linked Changes widget (LinkObject::ViewMode = "complex"). Note: Only Change attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
    $Self->{Translation}->{'Define which columns are shown in the linked Workorder widget (LinkObject::ViewMode = "complex"). Note: Only Workorder attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
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
    $Self->{Translation}->{'Defines if the change state can be set in the change edit screen of the agent interface.'} =
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
    $Self->{Translation}->{'Defines the field type of CompareValue fields for change attributes used in the change condition edit screen of the agent interface. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        '';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for workorder attributes used in the change condition edit screen of the agent interface. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        '';
    $Self->{Translation}->{'Defines the object attributes that are selectable for change objects in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the object attributes that are selectable for workorder objects in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute AccountedTime in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualEndTime in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualStartTime in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute CategoryID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeBuilderID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeManagerID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeStateID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeTitle in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute DynamicField in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ImpactID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEffort in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEndTime in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedStartTime in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PriorityID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute RequestedTime in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderAgentID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderNumber in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderStateID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTitle in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTypeID in the change condition edit screen of the agent interface.'} =
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
    $Self->{Translation}->{'Defines the signals for each ITSM change state.'} = '';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        '';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        '';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        '';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        '';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = '';
    $Self->{Translation}->{'Delete a change.'} = '';
    $Self->{Translation}->{'Delete the change.'} = '';
    $Self->{Translation}->{'Delete the workorder.'} = '';
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
    $Self->{Translation}->{'Dynamic fields (for changes and workorders) shown in the change print screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change add screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change search screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder add screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder report screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'DynamicField event module to handle the update of conditions if dynamic fields are added, updated or deleted.'} =
        '';
    $Self->{Translation}->{'Edit a change.'} = '';
    $Self->{Translation}->{'Edit the change.'} = '';
    $Self->{Translation}->{'Edit the conditions of the change.'} = '';
    $Self->{Translation}->{'Edit the workorder.'} = '';
    $Self->{Translation}->{'Enables the minimal change counter size (if "Date" was selected as ITSMChange::NumberGenerator).'} =
        '';
    $Self->{Translation}->{'Forward schedule of changes. Overview over approved changes.'} =
        '';
    $Self->{Translation}->{'History Zoom'} = '';
    $Self->{Translation}->{'ITSM Change CAB Templates.'} = '';
    $Self->{Translation}->{'ITSM Change Condition Edit.'} = '';
    $Self->{Translation}->{'ITSM Change Condition Overview.'} = '';
    $Self->{Translation}->{'ITSM Change Manager Overview.'} = '';
    $Self->{Translation}->{'ITSM Change Notifications'} = '';
    $Self->{Translation}->{'ITSM Change PIR Overview.'} = '';
    $Self->{Translation}->{'ITSM Change notification rules'} = '';
    $Self->{Translation}->{'ITSM Changes'} = '';
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
    $Self->{Translation}->{'ITSMChange'} = '';
    $Self->{Translation}->{'ITSMWorkOrder'} = '';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notifications are sent (every X hours).'} =
        '';
    $Self->{Translation}->{'Link another object to the change.'} = '';
    $Self->{Translation}->{'Link another object to the workorder.'} = '';
    $Self->{Translation}->{'List of all change events to be displayed in the GUI.'} = '';
    $Self->{Translation}->{'List of all workorder events to be displayed in the GUI.'} = '';
    $Self->{Translation}->{'Lookup of CAB members for autocompletion.'} = '';
    $Self->{Translation}->{'Lookup of agents, used for autocompletion.'} = '';
    $Self->{Translation}->{'Manage ITSM Change Management state machine.'} = '';
    $Self->{Translation}->{'Manage the category ↔ impact ↔ priority matrix.'} = '';
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
    $Self->{Translation}->{'Move all workorders in time.'} = '';
    $Self->{Translation}->{'New (from template)'} = 'Nuovo (da modello)';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        '';
    $Self->{Translation}->{'Other Settings'} = 'Altre impostazioni';
    $Self->{Translation}->{'Overview over all Changes.'} = '';
    $Self->{Translation}->{'PIR'} = '';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = '';
    $Self->{Translation}->{'PSA'} = '';
    $Self->{Translation}->{'Parameters for the UserCreateWorkOrderNextMask object in the preference view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        '';
    $Self->{Translation}->{'Performs the configured action for each event (as an Invoker) for each configured Webservice.'} =
        '';
    $Self->{Translation}->{'Planned end time'} = '';
    $Self->{Translation}->{'Planned start time'} = '';
    $Self->{Translation}->{'Print the change.'} = '';
    $Self->{Translation}->{'Print the workorder.'} = '';
    $Self->{Translation}->{'Projected Service Availability'} = '';
    $Self->{Translation}->{'Projected Service Availability (PSA)'} = '';
    $Self->{Translation}->{'Projected Service Availability (PSA) of changes. Overview of approved changes and their services.'} =
        '';
    $Self->{Translation}->{'Requested time'} = '';
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
    $Self->{Translation}->{'Reset change and its workorders.'} = '';
    $Self->{Translation}->{'Run task to check if specific times have been reached in changes and workorders.'} =
        '';
    $Self->{Translation}->{'Save change as a template.'} = '';
    $Self->{Translation}->{'Save workorder as a template.'} = '';
    $Self->{Translation}->{'Schedule'} = '';
    $Self->{Translation}->{'Screen after creating a workorder'} = '';
    $Self->{Translation}->{'Search Changes'} = '';
    $Self->{Translation}->{'Search Changes.'} = '';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        '';
    $Self->{Translation}->{'Set the agent for the workorder.'} = '';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        '';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = '';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = 'Imposta la macchina a stati per gli ordini di lavoro.';
    $Self->{Translation}->{'Shows a checkbox in the workorder edit screen of the agent interface that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the workorder agent, in the zoom view of the workorder of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a workorder as a template in the zoom view of the workorder, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workorder, in the zoom view of the workorder of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a workorder with another object in the zoom view of the workorder of the agent interface.'} =
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
        'Mostra un collegamento nel menu per aggiungere un ordine di lavoro nella vista di modifica dello zoom dell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        'Mostra un collegamento nel menu per eliminare una modifica nella vista zoom dell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows a link in the menu to delete a workorder in its zoom view of the agent interface.'} =
        'Mostra un collegamento nel menu per eliminare un ordine di lavoro nella sua vista zoom dell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        'Mostra un collegamento nel menu per tornare indietro nella vista di modifica dello zoom dell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the workorder zoom view of the agent interface.'} =
        'Mostra un collegamento nel menu per tornare indietro nella vista di zoom dell\'ordine di lavoro dell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        'Mostrare un collegamento nel menu per ripristinare una modifica e i relativi workorder nella visualizzazione zoom dell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows a link in the menu to show the involved persons in a change, in the zoom view of the change in the agent interface.'} =
        'Mostra un collegamento nel menu per mostrare le persone coinvolte in una modifica, nella vista zoom della modifica nell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        'Mostra la cronologia delle modifiche (ordine inverso) nell\'interfaccia agenti.';
    $Self->{Translation}->{'State Machine'} = 'Macchina statale';
    $Self->{Translation}->{'Stores change and workorder ids and their corresponding template id, while a user is editing a template.'} =
        'Memorizza gli ID di cambiamento e di ordine di lavoro e il loro ID modello corrispondente, mentre un utente sta modificando un modello.';
    $Self->{Translation}->{'Take Workorder'} = 'Prendi l\'ordine di lavoro';
    $Self->{Translation}->{'Take Workorder.'} = 'Prendi l\'ordine di lavoro.';
    $Self->{Translation}->{'Take the workorder.'} = 'Prendi l\'ordine.';
    $Self->{Translation}->{'Template Overview'} = 'Riepilogo del modello';
    $Self->{Translation}->{'Template type'} = 'Tipo di modello';
    $Self->{Translation}->{'Template.'} = 'Modello';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        'L\'identificatore di una modifica, ad es. Change#, MyChange#. L\'impostazione predefinita è Change#.';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        'L\'identificatore per un ordine di lavoro, ad es. Workorder#, MyWorkorder#. L\'impostazione predefinita è Workorder#.';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        'Questo modulo ACL limita l\'utilizzo dei tipi di ticket definiti nell\'opzione sysconfig \'ITSMChange::AddChangeLinkTicketTypes\', agli utenti dei gruppi come definiti in "ITSMChange::RestrictTicketTypes::Groups". Poiché questo ACL potrebbe scontrarsi con altri ACL correlati anche al tipo di ticket, questa opzione di sysconfig è disabilitata per impostazione predefinita e deve essere attivata solo se necessario.';
    $Self->{Translation}->{'Time Slot'} = 'Fascia oraria';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        'Tipi di ticket, in cui nella visualizzazione dello zoom del ticket verrà visualizzato un collegamento per aggiungere una modifica.';
    $Self->{Translation}->{'User Search'} = 'Ricerca utente';
    $Self->{Translation}->{'Workorder Add (from template).'} = 'Aggiungi all\'ordine di lavoro (dal modello).';
    $Self->{Translation}->{'Workorder Add.'} = 'Aggiungi ordine di lavoro.';
    $Self->{Translation}->{'Workorder Agent.'} = 'Agente di ordine di lavoro.';
    $Self->{Translation}->{'Workorder Delete.'} = 'Elimina ordine di lavoro.';
    $Self->{Translation}->{'Workorder Edit.'} = 'Modifica ordine di lavoro.';
    $Self->{Translation}->{'Workorder History Zoom.'} = 'Zoom cronologia ordine di lavoro.';
    $Self->{Translation}->{'Workorder History.'} = 'Storia degli ordini di lavoro.';
    $Self->{Translation}->{'Workorder Report.'} = 'Rapporto sull\'ordine di lavoro.';
    $Self->{Translation}->{'Workorder Zoom'} = 'Zoom sull\'ordine di lavoro';
    $Self->{Translation}->{'Workorder Zoom.'} = 'Zoom sull\'ordine di lavoro.';
    $Self->{Translation}->{'once'} = 'una volta';
    $Self->{Translation}->{'regularly'} = 'Regolarmente';


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
