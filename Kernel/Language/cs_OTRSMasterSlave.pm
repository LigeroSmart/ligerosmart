# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cs_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Change Free Text of Ticket'} = '';
    $Self->{Translation}->{'Change Owner of Ticket'} = 'Změnit vlastníka Tiketu';
    $Self->{Translation}->{'Close Ticket'} = 'Uzavřít Tiket';
    $Self->{Translation}->{'Add Note to Ticket'} = 'Přidat poznámku k Tiketu';
    $Self->{Translation}->{'Set Pending'} = 'Nastavit - čeká na vyřízení';
    $Self->{Translation}->{'Change Priority of Ticket'} = 'Změnit prioritu Tiketu';
    $Self->{Translation}->{'Change Responsible of Ticket'} = '';
    $Self->{Translation}->{'Manage Master/Slave'} = 'Správa vztahu Nadřízený/Podřízený';
    $Self->{Translation}->{'Set Master/Slave Value'} = '';
    $Self->{Translation}->{'Optional'} = 'Volitelné';
    $Self->{Translation}->{'Inform involved Agents'} = 'Informovat zúčastněné řešitele';
    $Self->{Translation}->{'Note will be (also) received by:'} = 'Poznámka bude (také) doručena:';

    # Perl Module: Kernel/Modules/AgentTicketMasterSlave.pm
    $Self->{Translation}->{'New Master Ticket'} = '';
    $Self->{Translation}->{'Unset Master Ticket'} = '';
    $Self->{Translation}->{'Unset Slave Ticket'} = '';
    $Self->{Translation}->{'Slave of Ticket#'} = '';

    # SysConfig
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Dovoluje přidávání poznámek při zobrazení Nadřízeného / Podřízeného v detailu tiketu - AgentTicketZoom.';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'Změna stavu Nadřízený/Podřízený.';
    $Self->{Translation}->{'Define dynamic field name for master ticket feature.'} = 'Pojmenování dynamického pole zajišťujícího funkci Nadřízeného tiketu.';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Určuje, zda je vyžadováno uzamknutí tiketu při zobrazení Nadřízeného / Podřízeného v detailu tiketu v AgentTicketZoom. (Není-li tiket zatím uzemčen, bude uzamčen a stávající agent bude automaticky určen jako vlastník.)';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Určuje defaultní následují stav tiketu po přidání poznámky - v zobrazení Nadřízený / Podřízený v detailu tiketu v AgentTicketZoom.';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Určuje defaultní prioritu tiketu v zobrazení Nadřízený / Podřízený v AgentTicketZoom.';
    $Self->{Translation}->{'Defines the default type of the note in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Určuje defaultní typ poznámky v pohledu Nadřízený / Podřízený v detailu tiketu v AgentTicketZoom.';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Určuje komentář historie pro akci zobrazení Nadřízený / Podřízený, komentář je použit v historii tiketu v rozhraní agenta.';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Určuje typ historie pro akci zobrazení Nadřízený / Podřízený, typ je použit v historii tiketu v rozhraní agenta.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Určuje další stav tiketu po přidání poznámky v zobrazení Nadřízený / Podřízený v detailu tiketu v rozhraní agenta.';
    $Self->{Translation}->{'Enable the advanced MasterSlave part of the feature.'} = 'Povoluje pokročilou část  konceptu Nadřízený/Podřízený.';
    $Self->{Translation}->{'Enable the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'} =
        'Povoluje podřízeným tiketům následovat nadřízené tikety k novému nadřízenému tiketu - v pokročilém konceptu Nadřízený / Podřízený.';
    $Self->{Translation}->{'Enable the feature to change the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Povoluje změnu stavu naddřízený / podřízený tiketu v pokročilém modu konceptu Nadřízený / Podřízený.';
    $Self->{Translation}->{'Enable the feature to forward articles from type \'forward\' of a master ticket to the customers of the slave tickets. By default (disabled) it will not forward articles from type \'forward\' to the slave tickets.'} =
        '';
    $Self->{Translation}->{'Enable the feature to keep parent-child link after change of the MasterSlave state in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'Enable the feature to keep parent-child link after unset of the MasterSlave state in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'Enable the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Povoluje zrušení stavu tiketu nadřízený / podřízený v pokročilém modu konceptu Nadřízený / Podřízený. ';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Pokud je přidána poznámka agentem, určí stav tiketu v zobrazení Nadřízený / Podřízený - v detailu tiketu v rozhraní agenta.';
    $Self->{Translation}->{'Master / Slave'} = '';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = '';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parametry nastavení nástěnky v přehledu nadřízených tiketů v rozhraní agenta. "Limit" je množství standardně viditelných vstupů. "Group" se používá k omezení přístupu k pluginu (např.: Group: admin;group1;group2;). "Default" určuje, zda je plugin povolen standardně nebo zda jej musí uživatel povolit manuálně. "CacheTTLLocal" je cachovací čas pluginu -  v minutách.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parametry nastavení nástěnky pro přehled podřízených tiketů v rozhraní agenta. "Limit" je množství standardně viditelných vstupů. "Group" se používá k omezení přístupu k pluginu (např.: Group: admin;group1;group2;). "Default" určuje, zda je plugin povolen standardně nebo zda jej musí uživatel povolit manuálně. "CacheTTLLocal" je cachovací čas pluginu - v minutách.';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'Registrace modulu událostí tiketu.';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Požadovaná oprávnění k užívání zobrazení Nadřízený / Podřízený v detailu tiketu v rozhraní agenta.';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Určuje defaultní text těla poznámky přidané v zobrazení Nadřízený / Podřízený v detailu tiketu v rozhraní agenta.';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Určuje defaultní subjekt poznámek v zobrazení Nadřízený / Podřízený v detailu tiketu v rozhraní agenta.';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Určuje zodpovědného agenta v zobrazení Nadřízený / Podřízený v detailu tiketu v rozhraní agenta.';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Určuje servis v zobrazení Nadřízený / Podřízený v detailu tiketu v rozhraní agenta. (Musí být aktivován Ticket::Service.)';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Určuje vlastníka tiketu v zobrazení Nadřízený / Podřízený v detailu tiketu v rozhraní agenta.';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Určuje typ tiketu v zobrazení Nadřízený / Podřízený v detailu tiketu v rozhraní agenta. (Musí být aktivován Ticket::Type.)';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'Zobrazuje link v menu,  který slouží ke změně statusu tiketu v nadřízený / podřízený, v detailu tiketu v rozhraní agenta.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Zobrazuje seznam všech agentů, kteří se podíleli na tiketu,  v zobrazení Nadřízený / Podřízený v detailu tiketu v rozhraní agenta';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Zobrazuje seznam možných agentů (všichni agenti mohoucí přidat poznámku k frontě/tiketu), aby bylo možno určit, kdo bude o poznámce informován - v zobrazení Nadřízeného/Podřízeného zazoomovaného tiketu v agentském prostředí. ';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the title fields in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Specifies the different article types where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        '';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        '';

}

1;
