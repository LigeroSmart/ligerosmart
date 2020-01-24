# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::it_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketOverviewMedium
    $Self->{Translation}->{'Criticality'} = 'Criticità';
    $Self->{Translation}->{'Impact'} = 'Impatto';

    # JS Template: ServiceIncidentState
    $Self->{Translation}->{'Service Incident State'} = 'Stato dell\'incidente del servizio';

    # Perl Module: Kernel/Output/HTML/FilterElementPost/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Link ticket'} = 'Collega ticket';
    $Self->{Translation}->{'Change Decision of %s%s%s'} = 'Modifica decisione di %s%s%s';
    $Self->{Translation}->{'Change ITSM fields of %s%s%s'} = 'Modifica i campi ITSM di %s%s%s';

    # Perl Module: var/packagesetup/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Review Required'} = 'Richiesta revisione';
    $Self->{Translation}->{'Decision Result'} = 'Risultato approvazione';
    $Self->{Translation}->{'Approved'} = 'Approvato';
    $Self->{Translation}->{'Postponed'} = 'Rinviata';
    $Self->{Translation}->{'Pre-approved'} = 'Pre approvato';
    $Self->{Translation}->{'Rejected'} = 'Respinto';
    $Self->{Translation}->{'Repair Start Time'} = 'Data iniziale di riparazione';
    $Self->{Translation}->{'Recovery Start Time'} = 'Data iniziale di recupero';
    $Self->{Translation}->{'Decision Date'} = 'Data di approvazione';
    $Self->{Translation}->{'Due Date'} = 'Data di scadenza';

    # Database XML Definition: ITSMIncidentProblemManagement.sopm
    $Self->{Translation}->{'closed with workaround'} = 'chiuso con soluzione tampone (workaround)';

    # SysConfig
    $Self->{Translation}->{'Add a decision!'} = 'Aggiungi una risoluzione!';
    $Self->{Translation}->{'Additional ITSM Fields'} = 'Campi ITSM aggiuntivi';
    $Self->{Translation}->{'Additional ITSM ticket fields.'} = 'Campi ticket ITSM aggiuntivi.';
    $Self->{Translation}->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} =
        'Consente l\'aggiunta di note nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti.';
    $Self->{Translation}->{'Allows adding notes in the decision screen of the agent interface.'} =
        'Consente di aggiungere note nella schermata di decisione dell\'interfaccia agente.';
    $Self->{Translation}->{'Allows defining new types for ticket (if ticket type feature is enabled).'} =
        'Permette di definire nuovi tipi di ticket (se è abilitata la funzione ticket type)';
    $Self->{Translation}->{'Change the ITSM fields!'} = 'Cambia i campi ITSM!';
    $Self->{Translation}->{'Decision'} = 'Approvazione';
    $Self->{Translation}->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Definisce se è necessario un blocco ticket nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti (se il ticket non è ancora bloccato, il ticket viene bloccato e l\'agente corrente verrà impostato automaticamente come proprietario).';
    $Self->{Translation}->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Definisce se è necessario un blocco ticket nella schermata decisionale dell\'interfaccia agenti (se il ticket non è ancora bloccato, il ticket viene bloccato e l\'agente corrente verrà impostato automaticamente come proprietario).';
    $Self->{Translation}->{'Defines if the service incident state should be shown during service selection in the agent interface.'} =
        'Definisce se lo stato dell\'incidente del servizio deve essere visualizzato durante la selezione del servizio nell\'interfaccia agenti.';
    $Self->{Translation}->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} =
        'Definisce il corpo predefinito di una nota nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti.';
    $Self->{Translation}->{'Defines the default body of a note in the decision screen of the agent interface.'} =
        'Definisce il corpo predefinito di una nota nella schermata decisionale dell\'interfaccia agenti.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Definisce lo stato successivo predefinito di un ticket dopo aver aggiunto una nota, nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Definisce lo stato successivo predefinito di un ticket dopo aver aggiunto una nota, nella schermata decisionale dell\'interfaccia agenti.';
    $Self->{Translation}->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} =
        'Definisce l\'oggetto predefinito di una nota nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti.';
    $Self->{Translation}->{'Defines the default subject of a note in the decision screen of the agent interface.'} =
        'Definisce l\'oggetto predefinito di una nota nella schermata decisionale dell\'interfaccia agenti.';
    $Self->{Translation}->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} =
        'Definisce la priorità del ticket predefinita nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti.';
    $Self->{Translation}->{'Defines the default ticket priority in the decision screen of the agent interface.'} =
        'Definisce la priorità predefinita del ticket nella schermata decisionale dell\'interfaccia agenti.';
    $Self->{Translation}->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Definisce il commento cronologico per l\'azione aggiuntiva della schermata del campo ITSM, che viene utilizzata per la cronologia dei ticket.';
    $Self->{Translation}->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} =
        'Definisce il commento cronologico per l\'azione della schermata decisionale, che viene utilizzato per la cronologia dei ticket.';
    $Self->{Translation}->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Definisce il tipo di cronologia per l\'azione aggiuntiva della schermata del campo ITSM, che viene utilizzata per la cronologia dei ticket.';
    $Self->{Translation}->{'Defines the history type for the decision screen action, which gets used for ticket history.'} =
        'Definisce il tipo di cronologia per l\'azione della schermata decisionale, che viene utilizzata per la cronologia dei ticket.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Definisce lo stato successivo di un ticket dopo aver aggiunto una nota, nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Definisce lo stato successivo di un ticket dopo aver aggiunto una nota, nella schermata decisionale dell\'interfaccia agenti.';
    $Self->{Translation}->{'Dynamic fields shown in the additional ITSM field screen of the agent interface.'} =
        'Campi dinamici visualizzati nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti.';
    $Self->{Translation}->{'Dynamic fields shown in the decision screen of the agent interface.'} =
        'Campi dinamici visualizzati nella schermata decisionale dell\'interfaccia agenti.';
    $Self->{Translation}->{'Dynamic fields shown in the ticket zoom screen of the agent interface.'} =
        'Campi dinamici visualizzati nella schermata di zoom del ticket dell\'interfaccia agenti.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} =
        'Consente al modulo stats di generare statistiche sulla media della tariffa della soluzione di primo livello del ticket ITSM.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} =
        'Consente al modulo stats di generare statistiche sulla media della soluzione di ticket ITSM.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} =
        'Se una nota viene aggiunta da un agente, imposta lo stato di un ticket nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} =
        'Se una nota viene aggiunta da un agente, imposta lo stato di un ticket nella schermata decisionale dell\'interfaccia agenti.';
    $Self->{Translation}->{'Modifies the display order of the dynamic field ITSMImpact and other things.'} =
        'Modifica l\'ordine di visualizzazione del campo dinamico ITSMImpact e altre cose.';
    $Self->{Translation}->{'Module to dynamically show the service incident state and to calculate the priority.'} =
        'Modulo per mostrare dinamicamente lo stato dell\'incidente del servizio e calcolare la priorità.';
    $Self->{Translation}->{'Required permissions to use the additional ITSM field screen in the agent interface.'} =
        'Permessi necessari per utilizzare la schermata del campo ITSM aggiuntiva nell\'interfaccia agenti.';
    $Self->{Translation}->{'Required permissions to use the decision screen in the agent interface.'} =
        'Permessi necessari per utilizzare la schermata decisionale nell\'interfaccia agenti.';
    $Self->{Translation}->{'Service Incident State and Priority Calculation'} = 'Stato dell\'incidente del servizio e calcolo delle priorità';
    $Self->{Translation}->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Imposta il servizio nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti (Ticket::Il servizio deve essere attivato).';
    $Self->{Translation}->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Imposta il servizio nella schermata decisionale dell\'interfaccia agenti (Ticket::Il servizio deve essere attivato).';
    $Self->{Translation}->{'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Imposta il servizio nella schermata di priorità ticket di un ticket ingrandito nell\'interfaccia agenti (Ticket::Il servizio deve essere attivato).';
    $Self->{Translation}->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} =
        'Imposta il proprietario del ticket nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti.';
    $Self->{Translation}->{'Sets the ticket owner in the decision screen of the agent interface.'} =
        'Imposta il proprietario del ticket nella schermata decisionale dell\'interfaccia agenti.';
    $Self->{Translation}->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} =
        'Imposta il ticket responsabile nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti.';
    $Self->{Translation}->{'Sets the ticket responsible in the decision screen of the agent interface.'} =
        'Imposta il ticket responsabile nella schermata decisionale dell\'interfaccia agenti.';
    $Self->{Translation}->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Imposta il tipo di ticket nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti (Ticket::Tipo deve essere attivato).';
    $Self->{Translation}->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Imposta il tipo di ticket nella schermata decisionale dell\'interfaccia agenti (Ticket::Tipo deve essere attivato).';
    $Self->{Translation}->{'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Imposta il tipo di ticket nella schermata di priorità dei ticket di un ticket ingrandito nell\'interfaccia agenti (Ticket::Tipo deve essere attivato).';
    $Self->{Translation}->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} =
        'Mostra un collegamento nel menu per modificare la decisione di un ticket nella sua vista zoom dell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} =
        'Mostra un collegamento nel menu per modificare altri campi ITSM nella vista zoom ticket dell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} =
        'Mostra un elenco di tutti gli agenti coinvolti su questo ticket, nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} =
        'Mostra un elenco di tutti gli agenti coinvolti su questo ticket, nella schermata decisionale dell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} =
        'Mostra un elenco di tutti i possibili agenti (tutti gli agenti con note permessi sulla coda/ticket) per determinare chi deve essere informato di questa nota, nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} =
        'Mostra un elenco di tutti i possibili agenti (tutti gli agenti con permessi note sulla coda/ticket) per determinare chi deve essere informato di questa nota, nella schermata delle decisioni dell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} =
        'Mostra le opzioni di priorità dei ticket nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows the ticket priority options in the decision screen of the agent interface.'} =
        'Mostra le opzioni di priorità dei ticket nella schermata decisionale dell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} =
        'Mostra i campi del titolo nella schermata del campo ITSM aggiuntiva dell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows the title fields in the decision screen of the agent interface.'} =
        'Mostra i campi del titolo nella schermata decisionale dell\'interfaccia agenti.';
    $Self->{Translation}->{'Ticket decision.'} = 'Decisione del ticket.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Service Incident State',
    );

}

1;
