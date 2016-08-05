# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
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

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Change Free Text of %s%s'} = 'Den Freitext von %s%s ändern';
    $Self->{Translation}->{'Change Owner of %s%s'} = 'Eigentümer von %s%s ändern';
    $Self->{Translation}->{'Close %s%s'} = '%s%s schließen';
    $Self->{Translation}->{'Add Note to %s%s'} = 'Notiz zu %s%s hinzufügen';
    $Self->{Translation}->{'Set Pending Time for %s%s'} = 'Wartezeit setzen für %s%s';
    $Self->{Translation}->{'Change Priority of %s%s'} = 'Priorität von %s%s ändern';
    $Self->{Translation}->{'Change Responsible of %s%s'} = 'Verantwortlichen von %s%s ändern';
    $Self->{Translation}->{'Manage Master/Slave status for %s%s'} = '';
    $Self->{Translation}->{'Set Master/Slave Value'} = 'Master/Slave Wert festlegen';
    $Self->{Translation}->{'Text will also be received by:'} = 'Text wird auch gesendet an:';

    # Perl Module: Kernel/Modules/AgentTicketMasterSlave.pm
    $Self->{Translation}->{'New Master Ticket'} = 'Neues Master Ticket';
    $Self->{Translation}->{'Unset Master Ticket'} = 'Aufheben des Master Tickets';
    $Self->{Translation}->{'Unset Slave Ticket'} = 'Aufheben des Slave Tickets';
    $Self->{Translation}->{'Slave of Ticket#'} = 'Slave von Ticket';

    # Perl Module: Kernel/Output/HTML/TicketBulk/MasterSlave.pm
    $Self->{Translation}->{'Unset Master Tickets'} = '';
    $Self->{Translation}->{'Unset Slave Tickets'} = '';

    # SysConfig
    $Self->{Translation}->{'All master tickets'} = '';
    $Self->{Translation}->{'All slave tickets'} = '';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Erlaubt das hinzufügen von Notizen in der MasterSlave Ansicht des Agenten-Interface.';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'Den MasterSlave Status des Tickets ändern.';
    $Self->{Translation}->{'Defines dynamic field name for master ticket feature.'} = '';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Bestimmt den Folgestatus für Tickets, für die im MasterSlave Bildschirm des Agenten-Interface eine Notiz hinzugefügt wurde.';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Bestimmt die standardmäßige Ticket Priorität für Tickets im MasterSlave Bildschirm des Agenten-Interface.';
    $Self->{Translation}->{'Defines the default type of the note in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Bestimmt den standardmäßigen Typ einer Notiz für Tickets im MasterSlave Bildschirm des Agenten-Interface.';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Bestimmt den Historien Kommentar von Ticket Aktionen im MasterSlave Bildschirm, welcher für die Ticket Historie im Agenten Interface verwendet wird.';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Bestimmt den Historien Typ von Ticket Aktionen im MasterSlave Bildschirm, welcher für die Ticket Historie im Agenten Interface verwendet wird.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Bestimmt den Folgestatus für Tickets, für die im MasterSlave Bildschirm des Agenten-Interface eine Notiz hinzugefügt wurde.';
    $Self->{Translation}->{'Disabled'} = '';
    $Self->{Translation}->{'Enabled'} = '';
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
        'Ermöglicht das Ändern des TIcket Status, beim Hinzufügen einer Notiz innerhalb des MasterSlave Bildschirms.';
    $Self->{Translation}->{'Master / Slave'} = 'Master / Slave';
    $Self->{Translation}->{'Master Tickets'} = '';
    $Self->{Translation}->{'MasterSlave'} = '';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = 'MasterSlave Modul für die Funktion von Sammelaktionen';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Einstellung der Übersichtsseitenparameter für Master Tickets in der Agentenoberfläche. "Limit" gibt die Anzahl der standardmäßig dargestellten Einträge an. "Group" wird verwendet, um den Zugriff auf das Plugin zu begrenzen (bspw. Group: admin;group1;group2;). "Default" bestimmt, ob das Plugin standardmäßig aktiviert ist oder ob der Benutzer es selbst aktivieren muss. "CacheTTLLocal" ist die Caching-Zeit des Plugins, angegeben in Minuten.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Einstellung der Übersichtsseitenparameter für Slave Tickets in der Agentenoberfläche. "Limit" gibt die Anzahl der standardmäßig dargestellten Einträge an. "Group" wird verwendet, um den Zugriff auf das Plugin zu begrenzen (bspw. Group: admin;group1;group2;). "Default" bestimmt, ob das Plugin standardmäßig aktiviert ist oder ob der Benutzer es selbst aktivieren muss. "CacheTTLLocal" ist die Caching-Zeit des Plugins, angegeben in Minuten.';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'Registrierung des Ticket Event Moduls.';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Benötigte Berechtigungen um den MasterSlave Dialog im Zoom Ticket Dialog des Agenteninterface anzeigen zu lassen.';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Bestimmt den standardmäßigen Body Text einer Notiz für Tickets im MasterSlave Bildschirm des Agenten-Interface.';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Bestimmt den standardmäßigen Betreff einer Notiz für Tickets im MasterSlave Bildschirm des Agenten-Interface.';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Bestimmt den verantwortlichen Agenten eines Tickets im MasterSlave Bildschirm des Agenten-Interface für ein aufgerufenes Ticket.';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Bestimmt den Service eines Tickets im MasterSlave Bildschirm des Agenten-Interface für ein aufgerufenes Ticket (Ticket::Service muss aktiviert sein).';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Bestimmt den Besitzer eines Tickets im MasterSlave Bildschirm des Agenten-Interface für ein aufgerufenes Ticket.';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Bestimmt den Ticket Typ eines Tickets im MasterSlave Bildschirm des Agenten-Interface für ein aufgerufenes Ticket (Ticket::Type muss aktiviert sein).';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'Zeigt einen Link im Menü um den MasterSlave Status eines Tickets im Ticket Zoom Interface des Agenten an.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Zeigt eine Liste aller involvierten Agenten für das gewählte Ticket im MasterSlave Bildschirm des Agenten-Interface an.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Zeigt eine Liste aller möglichen Agenten (alle Agenten mit Notiz Berechtigung auf der Queue/dem Ticket) für das gewählte Ticket im MasterSlave Bildschirm des Agenten-Interface an.';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Zeigt die Priorität eines Tickets im MasterSlave Bildschirm des Agenten-Interface für ein aufgerufenes Ticket.';
    $Self->{Translation}->{'Shows the title fields in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Zeigt die Titel-Felder in der MasterSlave-Oberfläche eines aufgerufenen Tickets im Agenten-Interface.';
    $Self->{Translation}->{'Slave Tickets'} = '';
    $Self->{Translation}->{'Specifies the different article types where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        'Definiert die verschiedene Artikeltypen in denen der reale Name des Master-TIckets mit denen des Slave-Tickets ersetzt wird.';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        'Dieses Modul aktiviert das Master/Slave Feld in der Anzeige für ein neues Email- oder Telefon-Ticket.';
    $Self->{Translation}->{'Ticket MasterSlave.'} = '';

}

1;
