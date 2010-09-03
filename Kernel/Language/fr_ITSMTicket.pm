# --
# Kernel/Language/fr_ITSMTicket.pm - the french translation of ITSMTicket
# Copyright (C) 2001-2009 Olivier Sallou <olivier.sallou at irisa.fr>
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: fr_ITSMTicket.pm,v 1.6 2010-09-03 18:17:04 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due date'}                     = 'Engagenent de date';
    $Lang->{'Decision'}                     = 'Décision';
    $Lang->{'Reason'}                       = 'Raison';
    $Lang->{'Decision Date'}                = 'Date de décision';
    $Lang->{'Add decision to ticket'}       = 'Ajouter une décision au ticket';
    $Lang->{'Decision Result'}              = 'Résultat de la Décision';
    $Lang->{'Review Required'}              = 'Revue requise';
    $Lang->{'closed with workaround'}       = 'Fermé avec contournement';
    $Lang->{'Additional ITSM Fields'}       = 'Champs ITSM additionels';
    $Lang->{'Change ITSM fields of ticket'} = 'Modifier les champs ITSM du ticket';
    $Lang->{'Repair Start Time'}            = 'Date de début de réparation';
    $Lang->{'Recovery Start Time'}          = 'Date de début de retour à la normale';
    $Lang->{'Change the ITSM fields!'}      = 'Modifiez les champs ITSM!';
    $Lang->{'Add a decision!'}              = 'Ajoutez une décision!';
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
    $Lang->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} = '';
    $Lang->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} = '';
    $Lang->{'Required permissions to use the additional ITSM field screen in the agent interface.'} = '';
    $Lang->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} = '';
    $Lang->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} = '';
    $Lang->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} = '';
    $Lang->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} = '';
    $Lang->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} = '';
    $Lang->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} = '';
    $Lang->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} = '';
    $Lang->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} = '';
    $Lang->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} = '';
    $Lang->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} = '';
    $Lang->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} = '';
    $Lang->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} = '';
    $Lang->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} = '';
    $Lang->{'Defines the default type of the note in the additional ITSM field screen of the agent interface.'} = '';
    $Lang->{'Specifies the different note types that will be used in the system.'} = '';
    $Lang->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} = '';
    $Lang->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} = '';
    $Lang->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} = '';
    $Lang->{'Ticket free text options shown in the additional ITSM field screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Lang->{'Ticket free time options shown in the additional ITSM field screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Lang->{'Article free text options shown in the additional ITSM field screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Lang->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} = '';
    $Lang->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} = '';
    $Lang->{'Required permissions to use the decision screen in the agent interface.'} = '';
    $Lang->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} = '';
    $Lang->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} = '';
    $Lang->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} = '';
    $Lang->{'Sets the ticket owner in the decision screen of the agent interface.'} = '';
    $Lang->{'Sets the ticket responsible in the decision screen of the agent interface.'} = '';
    $Lang->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} = '';
    $Lang->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} = '';
    $Lang->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} = '';
    $Lang->{'Allows adding notes in the decision screen of the agent interface.'} = '';
    $Lang->{'Defines the default subject of a note in the decision screen of the agent interface.'} = '';
    $Lang->{'Defines the default body of a note in the decision screen of the agent interface.'} = '';
    $Lang->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} = '';
    $Lang->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} = '';
    $Lang->{'Defines the default type of the note in the decision screen of the agent interface.'} = '';
    $Lang->{'Shows the ticket priority options in the decision screen of the agent interface.'} = '';
    $Lang->{'Defines the default ticket priority in the decision screen of the agent interface.'} = '';
    $Lang->{'Shows the title fields in the decision screen of the agent interface.'} = '';
    $Lang->{'Ticket free text options shown in the decision screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Lang->{'Ticket free time options shown in the decision screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Lang->{'Article free text options shown in the decision screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Lang->{'Defines the history type for the decision screen action, which gets used for ticket history.'} = '';
    $Lang->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} = '';
    $Lang->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} = '';
    $Lang->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} = '';
    $Lang->{'Link ticket'} = '';

    return 1;
}

1;
