# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::it_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Manage Master/Slave status for %s%s%s'} = 'Gestisci lo stato Master / Slave per %s%s%s';

    # Perl Module: Kernel/Modules/AgentTicketMasterSlave.pm
    $Self->{Translation}->{'New Master Ticket'} = 'Nuovo ticket primario';
    $Self->{Translation}->{'Unset Master Ticket'} = 'Rimuovi ticket primario';
    $Self->{Translation}->{'Unset Slave Ticket'} = 'Rimuovi ticket secondario';
    $Self->{Translation}->{'Slave of %s%s%s: %s'} = 'Schiavo di: %s%s%s: %s';

    # Perl Module: Kernel/Output/HTML/TicketBulk/MasterSlave.pm
    $Self->{Translation}->{'Unset Master Tickets'} = 'Ticket master non impostati';
    $Self->{Translation}->{'Unset Slave Tickets'} = 'Ticket schiavi non impostati';

    # Perl Module: Kernel/System/DynamicField/Driver/MasterSlave.pm
    $Self->{Translation}->{'Master'} = 'Primario';
    $Self->{Translation}->{'Slave of %s%s%s'} = 'Schiavo di %s%s%s';
    $Self->{Translation}->{'Master Ticket'} = 'Ticket maestro';

    # SysConfig
    $Self->{Translation}->{'All master tickets'} = 'Tutti i ticket maestri';
    $Self->{Translation}->{'All slave tickets'} = 'Tutti i ticket schiavi';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Consente di aggiungere delle note nella schermata MasterSlave di un ticket nell\'interfaccia Agente';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'Cambia lo stato MasterSlave del ticket';
    $Self->{Translation}->{'Defines dynamic field name for master ticket feature.'} = 'Definisce il nome del campo dinamico per la funzione ticket principale.';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Definisce se è necessario un blocco ticket nella schermata MasterSlave del ticket di un ticket ingrandito nell\'interfaccia agenti (se il ticket non è ancora bloccato, il ticket viene bloccato e l\'agente corrente verrà impostato automaticamente come proprietario).';
    $Self->{Translation}->{'Defines if the MasterSlave note is visible for the customer by default.'} =
        'Definisce se la nota MasterSlave è visibile per il cliente per impostazione predefinita.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Definisce lo stato successivo predefinito di un ticket dopo aver aggiunto una nota, nella schermata MasterSlave del ticket di un ticket ingrandito nell\'interfaccia agenti.';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Definisce la priorità predefinita del ticket nella schermata MasterSlave del ticket di un ticket ingrandito nell\'interfaccia dell\'interfaccia agenti.';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Definisce il commento cronologico per l\'azione sullo schermo MasterSlave del ticket, che viene utilizzato per la cronologia dei ticket nell\'interfaccia agenti.';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Definisce il tipo di cronologia per l\'azione della schermata MasterSlave del ticket, che viene utilizzata per la cronologia dei ticket nell\'interfaccia agenti.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Definisce lo stato successivo di un ticket dopo aver aggiunto una nota, nella schermata MasterSlave del ticket di un ticket ingrandito nell\'interfaccia dell\'interfaccia agenti.';
    $Self->{Translation}->{'Enables the advanced MasterSlave part of the feature.'} = 'Abilita la parte avanzata di MasterSlave della funzione.';
    $Self->{Translation}->{'Enables the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'} =
        'Abilita la funzione che i ticket slave seguono il ticket master verso un nuovo master in modalità MasterSlave avanzata.';
    $Self->{Translation}->{'Enables the feature to change the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Abilita la funzione per cambiare lo stato MasterSlave di un ticket nella modalità MasterSlave avanzata.';
    $Self->{Translation}->{'Enables the feature to forward articles from type \'forward\' of a master ticket to the customers of the slave tickets. By default (disabled) it will not forward articles from type \'forward\' to the slave tickets.'} =
        'Abilita la funzione per inoltrare articoli dal tipo \'inoltra\' di un ticket principale ai clienti dei ticket slave. Per impostazione predefinita (disabilitato) non inoltrerà articoli dal tipo "inoltra" ai ticket schiavo.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after change of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Abilita la funzione per mantenere il collegamento genitore-figlio dopo la modifica dello stato MasterSlave nella modalità MasterSlave avanzata.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after unset of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Abilita la funzione per mantenere il collegamento genitore-figlio dopo aver disinserito lo stato MasterSlave nella modalità MasterSlave avanzata.';
    $Self->{Translation}->{'Enables the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Abilita la funzione a disinserire lo stato MasterSlave di un ticket nella modalità MasterSlave avanzata.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Se una nota viene aggiunta da un agente, imposta lo stato del ticket nella schermata MasterSlave del ticket di un ticket ingrandito nell\'interfaccia agenti.';
    $Self->{Translation}->{'Master / Slave'} = 'Primario / Secondario';
    $Self->{Translation}->{'Master Tickets'} = 'Ticket maestro';
    $Self->{Translation}->{'MasterSlave'} = 'MasterSlave';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = 'Modulo MasterSlave per la funzione Bulk Ticket.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parametri per il backend del dashboard della panoramica dei ticket principali dell\'interfaccia agenti. "Limite" è il numero di voci visualizzate per impostazione predefinita. "Gruppo" viene utilizzato per limitare l\'accesso al plug-in (ad es. Gruppo: admin; gruppo1; gruppo2;). "Predefinito" determina se il plug-in è abilitato per impostazione predefinita o se l\'utente deve abilitarlo manualmente. "CacheTTLLocal" è il tempo di cache in minuti per il plugin.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parametri per il backend del dashboard della panoramica dei ticket slave dell\'interfaccia dell\'interfaccia agenti. "Limite" è il numero di voci visualizzate per impostazione predefinita. "Gruppo" viene utilizzato per limitare l\'accesso al plug-in (ad es. Gruppo: admin; gruppo1; gruppo2;). "Predefinito" determina se il plug-in è abilitato per impostazione predefinita o se l\'utente deve abilitarlo manualmente. "CacheTTLLocal" è il tempo di cache in minuti per il plugin.';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'Registrazione del modulo di evento del ticket.';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Permessi necessari per utilizzare la schermata MasterSlave del ticket di un ticket ingrandito nell\'interfaccia agenti.';
    $Self->{Translation}->{'Sets if Master / Slave field must be selected by the agent.'} = 'Imposta se il campo Master / Slave deve essere selezionato dall\'agente.';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Imposta il corpo del testo predefinito per le note aggiunte nella schermata MasterSlave del ticket di un ticket ingrandito nell\'interfaccia dell\'interfaccia agenti.';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Imposta l\'oggetto predefinito per le note aggiunte nella schermata MasterSlave del ticket di un ticket ingrandito nell\'interfaccia agenti.';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Imposta l\'agente responsabile del ticket nella schermata MasterSlave del ticket di un ticket ingrandito nell\'interfaccia agenti.';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Imposta il servizio nella schermata del ticket MasterSlave di un ticket ingrandito nell\'interfaccia agenti (Ticket :: Il servizio deve essere attivato).';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Imposta il proprietario del ticket nella schermata MasterSlave del ticket di un ticket ingrandito nell\'interfaccia agenti.';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Imposta il tipo di ticket nella schermata MasterSlave del ticket di un ticket ingrandito nell\'interfaccia agenti (Ticket::Type deve essere attivato).';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'Mostra un collegamento nel menu per modificare lo stato MasterSlave di un ticket nella vista zoom ticket nell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Mostra un elenco di tutti gli agenti coinvolti su questo ticket, nella schermata MasterSlave del ticket di un ticket ingrandito nell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Mostra un elenco di tutti i possibili agenti (tutti gli agenti con i permessi note sulla coda/ticket) per determinare chi deve essere informato su questa nota, nella schermata MasterSlave del ticket di un ticket ingrandito nell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Mostra le opzioni di priorità del ticket nella schermata MasterSlave del ticket di un ticket ingrandito nell\'interfaccia agenti.';
    $Self->{Translation}->{'Shows the title field in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Mostra il campo del titolo nella schermata MasterSlave del ticket di un ticket ingrandito nell\'interfaccia agenti.';
    $Self->{Translation}->{'Slave Tickets'} = 'Ticket schiavi';
    $Self->{Translation}->{'Specifies the different article communication channels where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        'Specifica i diversi canali di comunicazione dell\'articolo in cui il nome reale del ticket Master verrà sostituito con quello nel ticket Slave.';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        'Questo modulo attiva il campo Primario/Secondario nelle schermate dei nuovi ticket tramite email e telefono.';
    $Self->{Translation}->{'This setting is deprecated and will be removed in further versions of OTRSMasterSlave.'} =
        'Questa impostazione è obsoleta e verrà rimossa in ulteriori versioni di OTRSMasterSlave.';
    $Self->{Translation}->{'Ticket MasterSlave.'} = 'Ticket MasterSlave.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
