# --
# Kernel/Language/de_ITSMTicket.pm - the german translation of ITSMTicket
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: de_ITSMTicket.pm,v 1.5 2010-08-23 22:41:45 mp Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Fälligkeitsdatum';
    $Lang->{'Decision'}                     = 'Entscheidung';
    $Lang->{'Reason'}                       = 'Begründung';
    $Lang->{'Decision Date'}                = 'Entscheidungsdatum';
    $Lang->{'Add decision to ticket'}       = 'Entscheidung an Ticket hängen';
    $Lang->{'Decision Result'}              = 'Entscheidung';
    $Lang->{'Review Required'}              = 'Nachbearbeitung erforderlich';
    $Lang->{'closed with workaround'}       = 'provisorisch geschlossen';
    $Lang->{'Additional ITSM Fields'}       = 'Zusätzliche ITSM Felder';
    $Lang->{'Change ITSM fields of ticket'} = 'Ändern der ITSM Felder des Tickets';
    $Lang->{'Repair Start Time'}            = 'Reparatur Startzeit';
    $Lang->{'Recovery Start Time'}          = 'Wiederherstellung Startzeit';
    $Lang->{'Change the ITSM fields!'}      = 'Ändern der ITSM-Felder!';
    $Lang->{'Add a decision!'}              = 'Hinzufügen einer Entscheidung!';
    $Lang->{'Allows defining new types for ticket (if ticket type feature is enabled), e.g. incident, problem, change, ...'} = '';
    $Lang->{'Defines the the free key field number 13 for tickets to add a new ticket attribute.'} = '';
    $Lang->{'Defines the free text field number 13 for tickets to add a new ticket attribute.'} = '';
    $Lang->{'Defines the the free key field number 14 for tickets to add a new ticket attribute.'} = '';
    $Lang->{'Defines the free text field number 14 for tickets to add a new ticket attribute.'} = '';
    $Lang->{'Defines the default selection of the free text field number 14 for tickets (if more than one option is provided).'} = '';
    $Lang->{'Defines the the free key field number 15 for tickets to add a new ticket attribute.'} = '';
    $Lang->{'Defines the free text field number 15 for tickets to add a new ticket attribute.'} = '';
    $Lang->{'Defines the default selection of the free text field number 15 for tickets (if more than one option is provided).'} = '';
    $Lang->{'Defines the the free key field number 16 for tickets to add a new ticket attribute.'} = '';
    $Lang->{'Defines the free text field number 16 for tickets to add a new ticket attribute.'} = '';
    $Lang->{'Defines the default selection of the free text field number 16 for tickets (if more than one option is provided).'} = '';
    $Lang->{'Defines the free time key field number 3 for tickets.'} = '';
    $Lang->{'Defines the years (in future and in past) which can get selected in free time field number 3.'} = '';
    $Lang->{'Defines the free time key field number 4 for tickets.'} = '';
    $Lang->{'Defines the years (in future and in past) which can get selected in free time field number 4.'} = '';
    $Lang->{'Defines the free time key field number 5 for tickets.'} = '';
    $Lang->{'Defines the years (in future and in past) which can get selected in free time field number 5.'} = '';
    $Lang->{'Defines the free time key field number 6 for tickets.'} = '';
    $Lang->{'Defines the years (in future and in past) which can get selected in free time field number 6.'} = '';
    $Lang->{'Defines the difference from now (in seconds) of the free time field number 6\'s default value.'} = '';
    $Lang->{'Frontend module registration for the agent interface.'} = '';
    $Lang->{'Ticket free text options shown in the close ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Lang->{'Ticket free text options shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Lang->{'Ticket free text options shown in the email ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Lang->{'Ticket free text options shown in the phone ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Lang->{'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} = '';
    $Lang->{'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} = '';
    $Lang->{'Ticket free text options shown in the ticket search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Lang->{'Ticket free time options shown in the ticket search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Lang->{'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.'} = '';
    $Lang->{'Frontend module registration for the AgentTicketAddtlITSMField object in the agent interface.'} = 'Frontendmodul-Registration des AgentTicketAddtlITSMField-Objekts im Agent-Interface.';
    $Lang->{'Frontend module registration for the AgentTicketDecision object in the agent interface.'} = 'Frontendmodul-Registration des AgentTicketDecision-Objekts im Agent-Interface.';
    $Lang->{'Module to show additional ITSM field link in menu.'} = 'Über dieses Modul wird der Zusätzliche ITSM Felder-Link in der Linkleiste der Ticketansicht angezeigt.';
    $Lang->{'Module to show decision link in menu.'} = 'Über dieses Modul wird der Entscheidung-Link in der Linkleiste der Ticketansicht angezeigt.';
    $Lang->{'Required permissions to use this option.'} = 'Benötigte Rechte zur Bearbeitung des Tickets.';
    $Lang->{'A ticket lock is required. In case the ticket isn\'\t locked, the ticket gets locked and the current agent will be set automatically as ticket owner.'} = 'Eine Ticket-Sperre wird benötigt. Wenn Ticket nicht gesperrt ist, wird das Ticket automatisch gesperrt und der Agent als Besitzer gesetzt.';
    $Lang->{'If you want to set the ticket type (Ticket::Type needs to be activated).'} = 'Wenn der Ticket-Typ gesetzt werden soll (Ticket::Type muss aktiv sein).';
    $Lang->{'If you want to set the service (Ticket::Service needs to be activated).'} = 'Wenn der Service gesetzt werden soll (Ticket::Service muss aktiv sein).';
    $Lang->{'If you want to set the owner.'} = 'Wenn der Besitzer gesetzt werden soll.';
    $Lang->{'If you want to set the responsible agent.'} = 'Wenn der Verantwortliche gesetzt werden soll.';
    $Lang->{'Would you like to set the state of a ticket if a note is added by an agent?'} = 'Soll der Status eines Tickets gesetzt werden können, wenn eine Notiz durch einen Agent angelegt wird?';
    $Lang->{'Default next states after adding a note.'} = 'Nächstmögliche Status nach dem Hinzufügen einer Notiz.';
    $Lang->{'Default next state.'} = 'Standardmäßig ausgewählter nächster Status.';
    $Lang->{'Show note fields.'} = 'Eingabemöglichkeit für Notiz.';
    $Lang->{'Default note subject.'} = 'Standardtext im Betreff einer Notiz.';
    $Lang->{'Default note text.'} = 'Standardtext im Textfeld einer Notiz.';
    $Lang->{'Show selection of involved agents.'} = 'Auswahl der involvierten Agents anzeigen.';
    $Lang->{'Show selection of agents to inform (all agents with note permissions on the queue/ticket).'} = 'Auswahl der zu informierenden Agents anzeigen (alle Agenten mit "notiz" Rechten am Ticket/Queue).';
    $Lang->{'Default note type.'} = 'Voreingestellter Notiztyp.';
    $Lang->{'Specify the different note types that you want to use in your system.'} = 'Hier können die verschiedenen Notiz-Typen festgelegt werden, die innerhalb des Systems verwendet werden sollen.';
    $Lang->{'Show priority options.'} = 'Möglichkeit eine Priorität auszuwählen.';
    $Lang->{'Default priority options.'} = 'Default Auswahl der Priorität.';
    $Lang->{'Show title fields.'} = 'Eingabemöglichkeit für Title.';
    $Lang->{'Shown ticket free text options. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = 'Angezeigte Ticket-Frei-Text-Felder. Mögliche Einstellungen: 0 = Deaktiviert, 1 = Aktiviert, 2 = Aktiviert und Pflichtfeld.';
    $Lang->{'Shown ticket free time options. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = 'Angezeigte Ticket-Frei-Time-Felder. Mögliche Einstellungen: 0 = Deaktiviert, 1 = Aktiviert, 2 = Aktiviert und Pflichtfeld.';
    $Lang->{'Shown article free text options.'} = 'Gezeigte Artikel-Frei-Text-Felder.';
    $Lang->{'History type for this action.'} = 'Historientyp für diese Aktion.';
    $Lang->{'History comment for this action.'} = 'Historienkommentar für diese Aktion.';
    $Lang->{'Here you can decide if the stats module may generate stats about itsm ticket first level solution rate stuff.'} = 'Hier können Sie festlegen, ob das Statistik-Modul auch Statistiken über ITSM-Ticket-Erstlösungsrate Dinge generieren darf.';
    $Lang->{'Here you can decide if the stats module may generate stats about itsm ticket solution average stuff.'} = 'Hier können Sie festlegen, ob das Statistik-Modul auch Statistiken über ITSM-Ticket-Lösungszeit-Durchscnitt Dinge generieren darf.';

    return 1;
}

1;
