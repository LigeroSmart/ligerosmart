# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::hu_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminDynamicFieldMasterSlave
    $Self->{Translation}->{'Field'} = 'Mező';

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Manage Master/Slave status for %s%s%s'} = '%s%s%s mester/alárendelt állapotának kezelése';

    # Perl Module: Kernel/Modules/AgentTicketMasterSlave.pm
    $Self->{Translation}->{'New Master Ticket'} = 'Új mesterjegy';
    $Self->{Translation}->{'Unset Master Ticket'} = 'Mesterjegy törlése';
    $Self->{Translation}->{'Unset Slave Ticket'} = 'Alárendelt jegy törlése';
    $Self->{Translation}->{'Slave of %s%s%s: %s'} = '%s%s%s alárendeltje: %s';

    # Perl Module: Kernel/Output/HTML/TicketBulk/MasterSlave.pm
    $Self->{Translation}->{'Unset Master Tickets'} = 'Mesterjegyek törlése';
    $Self->{Translation}->{'Unset Slave Tickets'} = 'Alárendelt jegyek törlése';

    # Perl Module: Kernel/System/DynamicField/Driver/MasterSlave.pm
    $Self->{Translation}->{'Master'} = 'Mester';
    $Self->{Translation}->{'Slave of %s%s%s'} = '%s%s%s alárendeltje';
    $Self->{Translation}->{'Master Ticket'} = 'Mesterjegy';

    # SysConfig
    $Self->{Translation}->{'All master tickets'} = 'Összes mesterjegy';
    $Self->{Translation}->{'All slave tickets'} = 'Összes alárendelt jegy';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Lehetővé teszi jegyzetek hozzáadását egy nagyított jegynek a jegy mester-alárendelt képernyőjén az ügyintézői felületen.';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'Változtassa meg a jegy mester-alárendelt állapotát.';
    $Self->{Translation}->{'Defines dynamic field name for master ticket feature.'} = 'Meghatározza a dinamikus mező nevét a mesterjegy funkciónál.';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Meghatározza, hogy szükséges-e jegyzárolás egy nagyított jegynek a jegy mester-alárendelt képernyőjén az ügyintézői felületen (ha a jegy még nincs zárolva, akkor a jegy zárolva lesz, és az aktuális ügyintéző automatikusan annak tulajdonosaként lesz beállítva).';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Meghatározza egy jegy alapértelmezett következő állapotát egy jegyzet hozzáadása után egy nagyított jegynek a jegy mester-alárendelt képernyőjén az ügyintézői felületen.';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Meghatározza az alapértelmezett jegyprioritást egy nagyított jegynek a jegy mester-alárendelt képernyőjén az ügyintézői felületen.';
    $Self->{Translation}->{'Defines the default type of the note in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Meghatározza a jegyzet alapértelmezett típusát egy nagyított jegynek a jegy mester-alárendelt képernyőjén az ügyintézői felületen.';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Azt az előzmény megjegyzést határozza meg a jegy mester-alárendelt képernyő műveleténél, amelyet a jegy előzményeinél szoktak használni az ügyintézői felületen.';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Azt az előzmény típust határozza meg a jegy mester-alárendelt képernyő műveleténél, amelyet a jegy előzményeinél szoktak használni az ügyintézői felületen.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Meghatározza egy jegy következő állapotát egy jegyzet hozzáadása után egy nagyított jegynek a jegy mester-alárendelt képernyőjén az ügyintézői felületen.';
    $Self->{Translation}->{'Enables the advanced MasterSlave part of the feature.'} = 'Engedélyezi a funkció speciális mester-alárendelt részét.';
    $Self->{Translation}->{'Enables the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'} =
        'Engedélyezi azt a funkciót, hogy az alárendelt jegyek a mesterjegyet kövessék egy új mesterhez a speciális mester-alárendelt módban.';
    $Self->{Translation}->{'Enables the feature to change the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Engedélyezi a funkciót egy jegy mester-alárendelt állapotának megváltoztatásához a speciális mester-alárendelt módban.';
    $Self->{Translation}->{'Enables the feature to forward articles from type \'forward\' of a master ticket to the customers of the slave tickets. By default (disabled) it will not forward articles from type \'forward\' to the slave tickets.'} =
        'Engedélyezi a funkciót a bejegyzések továbbításához egy mesterjegy „továbbítás” típusából az alárendelt jegyek ügyfeleihez. Alapértelmezetten (letiltva) nem fog bejegyzéseket továbbítani a „továbbítás” típusból az alárendelt jegyekhez.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after change of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Engedélyezi a funkciót a szülő-gyermek kapcsolat megtartásához a mester-alárendelt állapot megváltoztatása után a speciális mester-alárendelt módban.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after unset of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Engedélyezi a funkciót a szülő-gyermek kapcsolat megtartásához a mester-alárendelt állapot törlése után a speciális mester-alárendelt módban.';
    $Self->{Translation}->{'Enables the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Engedélyezi a funkciót egy jegy mester-alárendelt állapotának törléséhez a speciális mester-alárendelt módban.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Ha egy ügyintéző hozzáadott egy megjegyzést, akkor beállítja a jegy állapotát egy nagyított jegynek a jegy mester-alárendelt képernyőjén az ügyintézői felületen.';
    $Self->{Translation}->{'Master / Slave'} = 'Mester / alárendelt';
    $Self->{Translation}->{'Master Tickets'} = 'Mesterjegyek';
    $Self->{Translation}->{'MasterSlave'} = 'Mester-alárendelt';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = 'Mester-alárendelt modul a jegy tömeges funkciójához.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Paraméterek az ügyintézői felület mesterjegyei áttekintőjének vezérlőpult háttérprogramjához. A „Limit” az alapértelmezetten megjelenített bejegyzések száma. A „Group” használható a hozzáférés korlátozásához a bővítményre (például Group: admin;csoport1;csoport2;). A „Default” jelzi, hogy a bővítmény alapértelmezetten engedélyezve van, vagy hogy a felhasználónak kézzel kell engedélyeznie azt. A „CacheTTLLocal” a bővítmény gyorsítótár ideje percben.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Paraméterek az ügyintézői felület alárendelt jegyei áttekintőjének vezérlőpult háttérprogramjához. A „Limit” az alapértelmezetten megjelenített bejegyzések száma. A „Group” használható a hozzáférés korlátozásához a bővítményre (például Group: admin;csoport1;csoport2;). A „Default” jelzi, hogy a bővítmény alapértelmezetten engedélyezve van, vagy hogy a felhasználónak kézzel kell engedélyeznie azt. A „CacheTTLLocal” a bővítmény gyorsítótár ideje percben.';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'A jegy esemény modul regisztrációja.';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'A szükséges jogosultságok egy nagyított jegynek a jegy mester-alárendelt képernyőjének használatához az ügyintézői felületen.';
    $Self->{Translation}->{'Sets if Master / Slave field must be selected by the agent.'} = 'Beállítja, hogy az ügyintézőnek ki kell választania a mester/alárendelt mezőt.';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Beállítja az alapértelmezett törzsszöveget egy nagyított jegynek a jegy mester-alárendelt képernyőjén hozzáadott jegyzeteknél az ügyintézői felületen.';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Beállítja az alapértelmezett tárgyat egy nagyított jegynek a jegy mester-alárendelt képernyőjén hozzáadott jegyzeteknél az ügyintézői felületen.';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Beállítja a jegy felelős ügyintézőjét egy nagyított jegynek a jegy mester-alárendelt képernyőjén az ügyintézői felületen.';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Beállítja a szolgáltatást egy nagyított jegynek a jegy mester-alárendelt képernyőjén az ügyintézői felületen (a Ticket::Service lehetőségnek aktiválva kell lennie).';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Beállítja a jegy tulajdonosát egy nagyított jegynek a jegy mester-alárendelt képernyőjén az ügyintézői felületen.';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Beállítja a jegy típusát egy nagyított jegynek a jegy mester-alárendelt képernyőjén az ügyintézői felületen (a Ticket::Type lehetőségnek aktiválva kell lennie).';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben egy jegy mester-alárendelt állapotának megváltoztatásához az ügyintézői felület jegynagyítás nézetében.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Megjeleníti a jegyen részt vevő összes ügyintéző listáját egy nagyított jegynek a jegy mester-alárendelt képernyőjén az ügyintézői felületen.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Megjeleníti az összes lehetséges ügyintéző (a várólistán vagy jegyen jegyzet jogosultsággal rendelkező összes ügyintéző) listáját egy nagyított jegynek a jegy mester-alárendelt képernyőjén az ügyintézői felületen annak meghatározásához, hogy kit kell tájékoztatni erről a jegyzetről.';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Megjeleníti a jegy prioritási lehetőségeket egy nagyított jegynek a jegy mester-alárendelt képernyőjén az ügyintézői felületen.';
    $Self->{Translation}->{'Shows the title field in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Megjeleníti a címmezőt egy nagyított jegynek a jegy mester-alárendelt képernyőjén az ügyintézői felületen.';
    $Self->{Translation}->{'Slave Tickets'} = 'Alárendelt jegyek';
    $Self->{Translation}->{'Specifies the different article types where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        'Megadja a különböző bejegyzéstípusokat, ahol a mesterjegyben lévő valódi név ki lesz cserélve az alárendelt jegyben lévővel.';
    $Self->{Translation}->{'Specifies the different note types that will be used in the system.'} =
        'Megadja a különböző jegyzettípusokat, amelyek a rendszeren használva lesznek.';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        'Ez a modul bekapcsolja a mester/alárendelt mezőt az új e-mail és telefonos jegy képernyőkön.';
    $Self->{Translation}->{'Ticket MasterSlave.'} = 'Jegy mester-alárendelt.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
