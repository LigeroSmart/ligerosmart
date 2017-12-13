# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::sr_Latn_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminDynamicFieldMasterSlave
    $Self->{Translation}->{'Field'} = 'Polje';

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Manage Master/Slave status for %s%s%s'} = 'Upravljanje statusom Glavni/Zavisni za %s%s%s';

    # Perl Module: Kernel/Modules/AgentTicketMasterSlave.pm
    $Self->{Translation}->{'New Master Ticket'} = 'Novi glavni tiket';
    $Self->{Translation}->{'Unset Master Ticket'} = 'Opozovi podešavanje glavnog tiketa';
    $Self->{Translation}->{'Unset Slave Ticket'} = 'Opozovi podešavanje zavisnog tiketa';
    $Self->{Translation}->{'Slave of %s%s%s: %s'} = 'Zavisni od %s%s%s: %s';

    # Perl Module: Kernel/Output/HTML/TicketBulk/MasterSlave.pm
    $Self->{Translation}->{'Unset Master Tickets'} = 'Opozovi podešavanje glavnih tiketa';
    $Self->{Translation}->{'Unset Slave Tickets'} = 'Opozovi podešavanje zavisnih tiketa';

    # Perl Module: Kernel/System/DynamicField/Driver/MasterSlave.pm
    $Self->{Translation}->{'Master Ticket'} = 'Glavni tiket';

    # SysConfig
    $Self->{Translation}->{'All master tickets'} = 'Svi glavni tiketi';
    $Self->{Translation}->{'All slave tickets'} = 'Svi zavisni tiketi';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Dozvoljava dodavanje beleški na Glavni/Zavisni ekranu detaljnog prikaza tiketa operaterskog interfejsa.';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'Promeni Glavni/Zavisni status tiketa.';
    $Self->{Translation}->{'Defines dynamic field name for master ticket feature.'} = 'Definiše dinamički naziv polja za funkciju glavnog tiketa.';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Određuje da li je potrebno zaključati glavni/zavisni ekran tiketa na detaljnom prikazu tiketa u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Određuje podrazumevani naredni status tiketa posle dodavalja beleške, na glavni/zavisni ekranu detaljnog prikaza tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Određuje podrazumevani prioritet tiketa na glavni/zavisni ekanu detaljnog prikaza tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Defines the default type of the note in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Određuje podrazumevani tip beleške na glavni/zavisni ekranu detaljnog prikaza tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Određuje komentar za istorijat na glavni/zavisni ekranskoj akciji, što će se koristiti za istorijat u interfejsu operatera.';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Određuje tip istorijata za glavni/zavisni ekransku akciju, što će se koristiti za istorijat u interfejsu operatera.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Određuje naredni status tiketa posle dodavalja beleške, na glavni/zavisni ekranu detaljnog prikaza tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Enables the advanced MasterSlave part of the feature.'} = 'Aktivira napredni deo funkcije Glavni/Zavisni.';
    $Self->{Translation}->{'Enables the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'} =
        'Aktiviranje svojstva da zavisni tiket prati glavni na novi glavni u naprednom Glavni/Zavisni modu.';
    $Self->{Translation}->{'Enables the feature to change the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Aktiviranje funkcije za promenu stanja tiketa Glavni/Zavisni  u naprednom Glavni/Zavisni modu.';
    $Self->{Translation}->{'Enables the feature to forward articles from type \'forward\' of a master ticket to the customers of the slave tickets. By default (disabled) it will not forward articles from type \'forward\' to the slave tickets.'} =
        'Aktiviranje svojstva za prosleđivanje članaka od tipa „prosledi” glavnog tiketa korisnicima zavisnih tiketa. Podrazumevano je (isključeno) da se ništa ne prosleđuje zavisnim tiketima.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after change of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Aktiviranje funkcije za zadržavanje veze nadređeni-podređeni posle izmene stanja Glavni/Zavisni  u naprednom Glavni/Zavisni modu.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after unset of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Aktiviranje funkcije za zadržavanje veze nadređeni-podređeni posle opoziva podešavanja stanja Glavni/Zavisni  u naprednom Glavni/Zavisni modu.';
    $Self->{Translation}->{'Enables the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Aktiviranje funkcije za opoziv podešavanja stanja tiketa Glavni/Zavisni  u naprednom Glavni/Zavisni modu.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Ako je operater dodao napomenu, podešava status tiketa na ekranu Glavni/Zavisni tiketa na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Master / Slave'} = 'Glavni / Zavisni';
    $Self->{Translation}->{'Master Tickets'} = 'Glavni tiketi';
    $Self->{Translation}->{'MasterSlave'} = 'Glavni/Zavisni';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = 'Modul Glavni/Zavisni za funkciju masovne obrade tiketa.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parametri za pozadinski prikaz kontrolne table pregleda glavnih tiketa u interfejsu operatera. „Limit” je broj unosa podrezumevano prikazanih. „Grupa” se koristi da ograniči pristup dodatku (npr. Grupa: admin;group1;group2;). „Podrazumevano” određuje da li je podrazumevano aktiviran ili da je potrebno da ga korisnik manuelno aktivira. „CacheTTLLocal” je vreme u minutama za keš dodatka.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parametri za pozadinski prikaz kontrolne table pregleda glavnih tiketa u interfejsu operatera. „Limit” je broj unosa podrezumevano prikazanih. „Grupa” se koristi da ograniči pristup dodatku (npr. Grupa: admin;group1;group2;). „Podrazumevano” određuje da li je podrazumevano aktiviran ili da je potrebno da ga korisnik manuelno aktivira. „CacheTTLLocal” je vreme u minutama za keš dodatka.';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'Registracija modula događaja za tikete.';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Neophodna dozvola za upotrebu glavni/zavisni ekrana detaljnog prikaza tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Određuje podrazumevani sadržaj za napomene dodate na na Glavni/Zavisni ekranu detaljnog prikaza tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Određuje podrazumevani predmet za napomene dodate na Glavni/Zavisni ekranu detaljnog prikaza tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Određuje odgovornog operatera za tiket na Glavni/Zavisni ekranu detaljnog prikaza tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Određuje servis na Glavni/Zavisni ekranu detaljnog prikaza tiketa u interfejsu operatera (Potrebno je aktivirati Tiket::Servis)..';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Određuje vlasnika tiketa na Glavni/Zavisni ekranu detaljnog prikaza tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Određuje tip tiketa na Glavni/Zavisni ekranu detaljnog prikaza tiketa u interfejsu operatera (Potrebno je aktivirati Tiket::Tip).';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za izmenu Glavni/Zavisni statusa tiketa na detaljnom prikazu tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Prikazuje listu svih operatera uključenih u ovaj tiket na Glavni/Zavisni ekranu detaljnog prikaza tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Prikazuje listu svih mogućih operatera (svi operateri sa dozvolom za napomenu za red/tiket) radi utvrđivanja ko treba da bude informisan o ovoj napomeni, na Glavni/Zavisni ekranu tiketa na detaljnom prikazu tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Prikazuje opcije prioriteta tiketa na Glavni/Zavisni ekranu tiketa na detaljnom prikazu tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Shows the title field in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Slave Tickets'} = 'Zavisni tiketi';
    $Self->{Translation}->{'Specifies the different article types where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        'Navodi razne tipove članaka gde će stvarno ime sa glavnog tiketa biti zamenjeno sa jednim na zavisnom tiketu.';
    $Self->{Translation}->{'Specifies the different note types that will be used in the system.'} =
        'Određuje različite tipove napomena koji će se koristiti u sistemu.';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        'Ovaj modul aktivira polje Glavni/Zavisni na ekranu novih imejl i telefonskih tiketa.';
    $Self->{Translation}->{'Ticket MasterSlave.'} = 'Tiket Glavni/Zavisni.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
