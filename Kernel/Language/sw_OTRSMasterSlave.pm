# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sw_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminDynamicFieldMasterSlave
    $Self->{Translation}->{'Field'} = 'Uga';

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Manage Master/Slave status for %s%s%s'} = '';

    # Perl Module: Kernel/Modules/AgentTicketMasterSlave.pm
    $Self->{Translation}->{'New Master Ticket'} = '';
    $Self->{Translation}->{'Unset Master Ticket'} = '';
    $Self->{Translation}->{'Unset Slave Ticket'} = '';
    $Self->{Translation}->{'Slave of %s%s%s: %s'} = '';

    # Perl Module: Kernel/Output/HTML/TicketBulk/MasterSlave.pm
    $Self->{Translation}->{'Unset Master Tickets'} = '';
    $Self->{Translation}->{'Unset Slave Tickets'} = '';

    # Perl Module: Kernel/System/DynamicField/Driver/MasterSlave.pm
    $Self->{Translation}->{'Master'} = 'Fuzu';
    $Self->{Translation}->{'Slave of %s%s%s'} = '';
    $Self->{Translation}->{'Master Ticket'} = '';

    # SysConfig
    $Self->{Translation}->{'All master tickets'} = '';
    $Self->{Translation}->{'All slave tickets'} = '';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Ruhusu kuongeza vidokezi katika skrini ya MkuuMtumwa ya tiketi iliyokuzwa katika kiolesura cha wakala.';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'Badilisha hali ya Mkuu/mtumwa ya tiketi.';
    $Self->{Translation}->{'Defines dynamic field name for master ticket feature.'} = '';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Fafanua kama kufunga kwa tiketi kunahitajika katika skrini ya tiketi ya  mkuumtumwa ya tiketi iliyokuzwa katika kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi zipatwe kufungwa na wakala wa sasa atafanywa automatiki kuwa mmiliki wake).';
    $Self->{Translation}->{'Defines if the MasterSlave note is visible for the customer by default.'} =
        '';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Inafafanua chaguo-msingi la hali iyajo ya tiketi baada ya kuongeza kidokezo, katika skrini ya mkuumtumwa ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Inafafanua kipaumbele chaguo-msingi cha tiketi katika skrini ya mkuumtumwa ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Inafafanua historia ya maoni kwa kitendo cha skrini ya tiketi mkuumtumwa, ambayo inatumika na historia ya tiketi ya kiolesura cha wakala.';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Fafanua aina ya historia kwa kitendo cha skrini ya mkuumtumwa cha tiketi, ambacho kinatumika na historia ya tiketi katika kiolesura cha wakala.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Fafanua hali inayofuata ya tiketi baada ya kuongeza kidokezo, katika skrini ya mkuumtumwa ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.';
    $Self->{Translation}->{'Enables the advanced MasterSlave part of the feature.'} = '';
    $Self->{Translation}->{'Enables the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'Enables the feature to change the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'Enables the feature to forward articles from type \'forward\' of a master ticket to the customers of the slave tickets. By default (disabled) it will not forward articles from type \'forward\' to the slave tickets.'} =
        '';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after change of the MasterSlave state in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after unset of the MasterSlave state in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'Enables the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Kama kidokezo kimeongezwa na wakala, inaweka hali ya tiketi katika skrini ya mkuumtumwa ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.';
    $Self->{Translation}->{'Master / Slave'} = '';
    $Self->{Translation}->{'Master Tickets'} = '';
    $Self->{Translation}->{'MasterSlave'} = '';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = '';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parameta kwa backend ya dasibodi ya mapitio ya tiketi kuu ya kiolesura cha wakala. \'\'Kikomo\'\' ni namba ya vipengee halisi vinavyoonyeshwa kwa mchaguo-halisi. \'\'Kikundi\'\' kinatumika kuzuia kufikia kuchomeka (mfano Kikundi:Utawala;kikundi cha 1;kikundi cha 2;). \'\'Chaguo-msingi\'\' inahakiki kama mchomeko umewezeshwa kwa mchaguo-msingi au kama mtumizi anahitaji kuwezesha kwa mkono. \'\'HifadhimudaTTLKiambo\'\' ni muda wa hifadhi muda katika dakika kwa mchomeko.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parameta kwa backend ya dasibodi ya mapitio ya tiketi tumwa ya kiolesura cha wakala. \'\'Kikomo\'\' ni namba ya vipengee halisi vinavyoonyeshwa kwa mchaguo-halisi. \'\'Kikundi\'\' kinatumika kuzuia kufikia kuchomeka (mfano Kikundi:Utawala;kikundi cha 1;kikundi cha 2;). \'\'Chaguo-msingi\'\' inahakiki kama mchomeko umewezeshwa kwa mchaguo-msingi au kama mtumizi anahitaji kuwezesha kwa mkono. \'\'HifadhimudaTTLKiambo\'\' ni muda wa hifadhi muda katika dakika kwa mchomeko.';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'Usajili wa kipimo cha tukio la tiketi.';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Inahitaji ruhusa kutumia skrini ya mkuumtumwa ya tiketi ya tiketi iliyokuzwa katika kioesura cha wakala.';
    $Self->{Translation}->{'Sets if Master / Slave field must be selected by the agent.'} = '';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Inaweka matini kiini kilichoongezwa cha chaguo-msingi katika skrini ya mkuumtuwa ya tiketi katika tiketi iliyokuzwa katika kiolesura cha wakala.';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Inaweka somo la chaguo-msingi kwa kipengele kilichoongezwa katika skrini ya mkuumtuwa ya tiketi katika tiketi iliyokuzwa katika kiolesura cha wakala.';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Inaweka wakala ambaye anahusika na tiketi katika skrini ya mkuumtumwa ya tiketi ya tiketi iliyokuzwa katikat kiolesura cha wakala.';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Inaweka huduma katika skrini ya mkuumtumwa ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala (Tiketi::Huduma inayohitaji kuamilishwa).';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Inaweka mmiliki wa tiketi katika skrini ya mkuumtumwa ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Inaweka aina ya tiketi katika skrini ya mkuumtumwa ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala (tiketi:: aina inayoitaji kuamilishwa).';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'Inaonyesha kiungo katika menyu cha kubadilisha hadhi ya mkuumtumwa ya tiketi katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Inaonyesha orodha ya mawakala wote wanaohusika na tiketi hii, katika skrini ya tiketi mkuu/mtumwa ya tiketi iliyokuzwa katika kiolesura cha wakala.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Inaonyesha orodha ya wakala wote wanaoweza (mawakala wote wenye kidokezo cha ruhusa ya tiketi/foleni) kutambua nani ataarifiwe kuhusu kidokezo hiki, katika skrini ya tiketi mkuumtumwa ya tiketi iliyokuzwa katika kiolesura chwa wakala.';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Inaonyesha machaguo ya kipaumbele ya tiketi katika skrini ya tiketi mkuumtumwa ya tiketi iliyokuzwa katika kiolesura cha wakala.';
    $Self->{Translation}->{'Shows the title field in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Slave Tickets'} = '';
    $Self->{Translation}->{'Specifies the different article types where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        'Inabainisha aina mbalimbali za makala ambazo majina yake ya ukweli kutoka tiketi kuu yatabadilishwa na mojawapo katika tiketi tumwa.';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        '';
    $Self->{Translation}->{'Ticket MasterSlave.'} = '';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
