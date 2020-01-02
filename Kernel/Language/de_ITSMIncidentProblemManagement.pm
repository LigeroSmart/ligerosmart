# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::de_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketOverviewMedium
    $Self->{Translation}->{'Criticality'} = 'Kritikalität';
    $Self->{Translation}->{'Impact'} = 'Auswirkung';

    # JS Template: ServiceIncidentState
    $Self->{Translation}->{'Service Incident State'} = 'Service-Vorfallstatus';

    # Perl Module: Kernel/Output/HTML/FilterElementPost/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Link ticket'} = 'Ticket verknüpfen';
    $Self->{Translation}->{'Change Decision of %s%s%s'} = 'Change-Entscheidung von %s%s%s';
    $Self->{Translation}->{'Change ITSM fields of %s%s%s'} = 'Change ITSM-Felder von %s%s%s';

    # Perl Module: var/packagesetup/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Review Required'} = 'Überprüfung erforderlich';
    $Self->{Translation}->{'Decision Result'} = 'Entscheidung';
    $Self->{Translation}->{'Approved'} = 'Genehmigt';
    $Self->{Translation}->{'Postponed'} = 'Zurückgestellt';
    $Self->{Translation}->{'Pre-approved'} = 'Vor-genehmigt';
    $Self->{Translation}->{'Rejected'} = 'Zurückgewiesen';
    $Self->{Translation}->{'Repair Start Time'} = 'Reparatur-Startzeit';
    $Self->{Translation}->{'Recovery Start Time'} = 'Wiederherstellung-Startzeit';
    $Self->{Translation}->{'Decision Date'} = 'Entscheidungsdatum';
    $Self->{Translation}->{'Due Date'} = 'Fälligkeitsdatum';

    # Database XML Definition: ITSMIncidentProblemManagement.sopm
    $Self->{Translation}->{'closed with workaround'} = 'provisorisch geschlossen';

    # SysConfig
    $Self->{Translation}->{'Add a decision!'} = 'Bitte fügen Sie eine Entscheidung hinzu.';
    $Self->{Translation}->{'Additional ITSM Fields'} = 'Zusätzliche ITSM-Felder';
    $Self->{Translation}->{'Additional ITSM ticket fields.'} = 'Zusätzliche ITSM-Ticketfelder.';
    $Self->{Translation}->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} =
        'Erlaubt das Hinzufügen von Notizen in der Ansicht "Zusätzliche ITSM-Felder" im Agenten-Interface.';
    $Self->{Translation}->{'Allows adding notes in the decision screen of the agent interface.'} =
        'Erlaubt das Hinzufügen von Notizen in der Entscheidungs-Ansicht im Agenten-Interface.';
    $Self->{Translation}->{'Allows defining new types for ticket (if ticket type feature is enabled).'} =
        'Ermöglicht die Definition neuer Ticket-Typen  (wenn Ticket-Typ-Funktion aktiviert ist).';
    $Self->{Translation}->{'Change the ITSM fields!'} = 'Ändern Sie die ITSM-Felder!';
    $Self->{Translation}->{'Decision'} = 'Entscheidung';
    $Self->{Translation}->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Bestimmt, ob diese Ansicht im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.';
    $Self->{Translation}->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Bestimmt, ob diese Ansicht im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.';
    $Self->{Translation}->{'Defines if the service incident state should be shown during service selection in the agent interface.'} =
        'Bestimmt, ob der Service-Vorfallstatus während der Service-Auswahl im Agenten-Interface angezeigt werden soll.';
    $Self->{Translation}->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} =
        'Definiert den Standard-Inhalt einer Notiz in der Ansicht "Zusätzliche ITSM Felder" im Agenten-Interface.';
    $Self->{Translation}->{'Defines the default body of a note in the decision screen of the agent interface.'} =
        'Definiert den Standard-Inhalt einer Notiz in der Ansicht "Change-Entscheidung..." im Agenten-Interface.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Bestimmt den Standard-Folgestatus für Tickets, für die über die zusätzlichen ITSM Felder im Agenten-Interface eine Notiz hinzugefügt wurde.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Bestimmt den Folgestatus für Tickets, für die in der Ansicht "Change-Entscheidung..." im Agenten-Interface eine Notiz hinzugefügt wurde.';
    $Self->{Translation}->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} =
        'Definiert den Standard-Betreff einer Notiz in der Ansicht "Zusätzliche ITSM Felder" im Agenten-Interface.';
    $Self->{Translation}->{'Defines the default subject of a note in the decision screen of the agent interface.'} =
        'Definiert den Standard-Betreff einer Notiz in der Ansicht "Change-Entscheidung..." im Agenten-Interface.';
    $Self->{Translation}->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} =
        'Definiert die Standard-Priorität in der Ansicht "Zusätzliche ITSM Felder" im Agenten-Interface.';
    $Self->{Translation}->{'Defines the default ticket priority in the decision screen of the agent interface.'} =
        'Definiert die Standard-Priorität in der Ansicht "Change-Entscheidung..." im Agenten-Interface.';
    $Self->{Translation}->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Steuert den Historien-Kommentar für die Aktionen in der Ansicht "Zusätzliche ITSM-Felder" im Agenten-Interface.';
    $Self->{Translation}->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} =
        'Steuert den Historien-Kommentar für die Entscheidungs-Aktion im Agentenbereich.';
    $Self->{Translation}->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Definiert den Historien-Typ für die "zusätzliche ITSM-Felder"-Aktion, der für die Ticket-Historie verwendet wird.';
    $Self->{Translation}->{'Defines the history type for the decision screen action, which gets used for ticket history.'} =
        'Definiert den Historien-Typ für die "Entscheidung"-Aktion, der für die Ticket-Historie verwendet wird.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Bestimmt den Standard-Folgestatus für Tickets, für die über die zusätzlichen ITSM Felder im Agenten-Interface eine Notiz hinzugefügt wurde.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Bestimmt den Folgestatus für Tickets, für die in der Ansicht "Change-Entscheidung..." im Agenten-Interface eine Notiz hinzugefügt wurde.';
    $Self->{Translation}->{'Dynamic fields shown in the additional ITSM field screen of the agent interface.'} =
        'Die angezeigten Dynamischen Felder in der Ansicht "zusätzliche ITSM-Felder" im Agenten-Interface.';
    $Self->{Translation}->{'Dynamic fields shown in the decision screen of the agent interface.'} =
        'Die angezeigten Dynamischen Felder in der Ansicht "Entscheidung" im Agenten-Interface.';
    $Self->{Translation}->{'Dynamic fields shown in the ticket zoom screen of the agent interface.'} =
        'Die angezeigten Dynamischen Felder in der Ticket-Detailansicht im Agenten-Interface.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} =
        'Erlaubt dem Statistikmodul, Statistiken über die durchschnittliche Lösungsrate von ITMS-Tickets zu erfassen.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} =
        'Erlaubt dem Statistikmodul, Statistiken über die durchschnittliche Lösungsrate von ITMS-Tickets zu erfassen.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} =
        'Wenn eine Notiz von einem Agenten hinzugefügt wird, wird der Status eines Tickets in der Ansicht "Zusätzliche ITSM-Felder" im Agenten-Interface gesetzt.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} =
        'Wenn eine Notiz von einem Agenten hinzugefügt wird, wird der Status eines Tickets in der Ansicht "Entscheidung" im Agenten-Interface gesetzt.';
    $Self->{Translation}->{'Modifies the display order of the dynamic field ITSMImpact and other things.'} =
        'Ändert die Anzeigereihenfolge des dynamischen Feldes ITSMImpact und andere Dinge.';
    $Self->{Translation}->{'Module to dynamically show the service incident state and to calculate the priority.'} =
        'Modul zur dynamischen Anzeige des Service-Vorfallstatus und zur Berechnung der Priorität.';
    $Self->{Translation}->{'Required permissions to use the additional ITSM field screen in the agent interface.'} =
        'Erforderliche Berechtigungen, um die Ansicht "Zusätzliche ITSM-Felder" im Agenten-Interface nutzen zu können.';
    $Self->{Translation}->{'Required permissions to use the decision screen in the agent interface.'} =
        'Erforderliche Berechtigungen, um die Ansicht "Entscheidung" im Agenten-Interface nutzen zu können.';
    $Self->{Translation}->{'Service Incident State and Priority Calculation'} = 'Service-Vorfallstatus- und Prioritätsberechnung';
    $Self->{Translation}->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Setzt den Service in der Ansicht "Zusätzliche ITSM-Felder-Oberfläche für Tickets im Agentenbereich (Ticket::Type muss aktiviert sein).';
    $Self->{Translation}->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Setzt den Service in der Ansicht "Entscheidung" für Tickets im Agenten-Interface (Ticket::Service muss aktiviert sein).';
    $Self->{Translation}->{'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Setzt den Service in der Ansicht "Priorität" für Tickets im Agenten-Interface.';
    $Self->{Translation}->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} =
        'Setzt den Ticket-Besitzer in der Ansicht "Zusätzliche ITSM-Felder" für Tickets im Agenten-Interface.';
    $Self->{Translation}->{'Sets the ticket owner in the decision screen of the agent interface.'} =
        'Setzt den Besitzer in der Ansicht "Entscheidung" für Tickets im Agenten-Interface.';
    $Self->{Translation}->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} =
        'Setzt den Ticket-Verantwortlichen in der Ansicht "Zusätzliche ITSM-Felder" für Tickets im Agenten-Interface.';
    $Self->{Translation}->{'Sets the ticket responsible in the decision screen of the agent interface.'} =
        'Setzt den Ticket-Verantwortlichen in der Ansicht "Entscheidung" für Tickets im Agenten-Interface.';
    $Self->{Translation}->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Setzt den Ticket-Typ in der Ansicht "Zusätzliche ITSM-Felder" für Tickets im Agenten-Interface (Ticket::Type muss aktiviert sein).';
    $Self->{Translation}->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Setzt den Ticket-Typ in der Ansicht "Entscheidung" für Tickets im Agenten-Interface (Ticket::Type muss aktiviert sein).';
    $Self->{Translation}->{'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Setzt den Ticket-Typ in der Prioritäts-Ansicht für Tickets im Agenten-Interface (Ticket::Type muss aktiviert sein).';
    $Self->{Translation}->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} =
        'Zeigt in der Ticket-Detailansicht im Ticket-Menü einen Link an um die Entscheidung an einem Ticket zu ändern';
    $Self->{Translation}->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} =
        'Zeigt einen Link in der Menü-Leiste in der Detailansicht im Agenten-Interface an, der es ermöglicht die zusätzlichen ITSM-Felder zu bearbeiten.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} =
        'Zeigt in der Ansicht "Zusätzliche ITSM-Felder" des Agenten-Interface eine Liste aller am Ticket beteiligten Agenten.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} =
        'Zeigt in der Ansicht "Entscheidung" eine Liste aller am Ticket beteiligten Agenten.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} =
        'Zeigt in der "Zusätzliche ITSM-Felder"-Ansicht des Agenten-Interface eine Liste aller möglichen Agenten (alle Agenten mit Berechtigung für Notizen in diesem Ticket/ dieser Queue) die informiert werden sollen.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} =
        'Zeigt in der "Entscheidung"-Ansicht des Agenten-Interface eine Liste aller möglichen Agenten (alle Agenten mit Berechtigung für Notizen in diesem Ticket/ dieser Queue) die informiert werden sollen.';
    $Self->{Translation}->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} =
        'Zeigt die Ticket-Priorität in der in der Ansicht "Zusätzliche ITSM-Felder" im Agenten-Interface.';
    $Self->{Translation}->{'Shows the ticket priority options in the decision screen of the agent interface.'} =
        'Zeigt die Ticket-Priorität in der in der Ansicht "Entscheidung" im Agenten-Interface.';
    $Self->{Translation}->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} =
        'Zeigt die Titelfelder in der Ansicht "Zusätzliche ITSM-Fdelder" im Agenten-Interface.';
    $Self->{Translation}->{'Shows the title fields in the decision screen of the agent interface.'} =
        'Zeigt die Titelfelder in der Ansicht "Entscheidung" im Agenten-Interface.';
    $Self->{Translation}->{'Ticket decision.'} = 'Ticket-Entscheidung';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Service Incident State',
    );

}

1;
