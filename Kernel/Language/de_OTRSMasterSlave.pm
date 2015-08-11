# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketBulk
    $Self->{Translation}->{'MasterTicket'} = '';

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Manage Master/Slave'} = 'Master/Slave verwalten';

    # SysConfig
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'Den MasterSlave Status des Tickets ändern.';
    $Self->{Translation}->{'Define dynamic field name for master ticket feature.'} = '';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        '';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the default type of the note in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Enable the advanced MasterSlave part of the feature.'} = 'Das erweiterte Verhalten der MasterSlave Erweiterung aktivieren.';
    $Self->{Translation}->{'Enable the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'} =
        'Aktiviere den Modus das Slave Tickets dem Master Ticket im erweiterten MasterSlave Verhalten zum neuen Master folgen.';
    $Self->{Translation}->{'Enable the feature to forward articles of a master ticket to the customers of the slave tickets. By default (disabled) it will not forward anything to the slave tickets.'} =
        '';
    $Self->{Translation}->{'Enable the feature to change the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'Enable the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Aktiviere den Modus um den MasterSlave Status eines Tickets im erweiterten MasterSlave Verhalten aufzuheben.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        '';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        '';
    $Self->{Translation}->{'Registration of the ticket event module.'} = '';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Benötigte Berechtigungen um den MasterSlave Dialog im Zoom Ticket Dialog des Agenteninterface anzeigen zu lassen.';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        '';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'Zeigt einen Link im Menü um den MasterSlave Status eines Tickets im Ticket Zoom Interface des Agenten an.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the title fields in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Specifies the different article types where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        '';
    $Self->{Translation}->{'This module is preparing master/slave pulldown in email and phone ticket.'} =
        'Legt das Modul fest das das DropDown Feld im Email- und Telefonticket Dialog bereitstellt.';

}

1;
