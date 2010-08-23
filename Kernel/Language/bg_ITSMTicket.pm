# --
# Kernel/Language/bg_ITSMTicket.pm - the bulgarian translation of ITSMTicket
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2007-2008 Milen Koutev
# --
# $Id: bg_ITSMTicket.pm,v 1.7 2010-08-23 22:44:19 mp Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::bg_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Крайна дата';
    $Lang->{'Decision'}                     = 'Решение';
    $Lang->{'Reason'}                       = 'Основание';
    $Lang->{'Decision Date'}                = 'Дата за решаване';
    $Lang->{'Add decision to ticket'}       = 'Добави решение към билета';
    $Lang->{'Decision Result'}              = 'Резултат от решението';
    $Lang->{'Review Required'}              = 'Изисква преглеждане';
    $Lang->{'closed with workaround'}       = 'приключен с обходно решение';
    $Lang->{'Additional ITSM Fields'}       = 'Допълнителни ITSM полета';
    $Lang->{'Change ITSM fields of ticket'} = 'Промени ITSM полетата на билета';
    $Lang->{'Repair Start Time'}            = 'Време на стартиране на ремонта';
    $Lang->{'Recovery Start Time'}          = 'Време на стартиране на възстановяването';
    $Lang->{'Change the ITSM fields!'}      = '';
    $Lang->{'Add a decision!'}              = '';
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
    $Lang->{'Frontend module registration for the AgentTicketAddtlITSMField object in the agent interface.'} = '';
    $Lang->{'Frontend module registration for the AgentTicketDecision object in the agent interface.'} = '';
    $Lang->{'Module to show additional ITSM field link in menu.'} = '';
    $Lang->{'Module to show decision link in menu.'} = '';
    $Lang->{'Required permissions to use this option.'} = '';
    $Lang->{'A ticket lock is required. In case the ticket isn\'\t locked, the ticket gets locked and the current agent will be set automatically as ticket owner.'} = '';
    $Lang->{'If you want to set the ticket type (Ticket::Type needs to be activated).'} = '';
    $Lang->{'If you want to set the service (Ticket::Service needs to be activated).'} = '';
    $Lang->{'If you want to set the owner.'} = '';
    $Lang->{'If you want to set the responsible agent.'} = '';
    $Lang->{'Would you like to set the state of a ticket if a note is added by an agent?'} = '';
    $Lang->{'Default next states after adding a note.'} = '';
    $Lang->{'Default next state.'} = '';
    $Lang->{'Show note fields.'} = '';
    $Lang->{'Default note subject.'} = '';
    $Lang->{'Default note text.'} = '';
    $Lang->{'Show selection of involved agents.'} = '';
    $Lang->{'Show selection of agents to inform (all agents with note permissions on the queue/ticket).'} = '';
    $Lang->{'Default note type.'} = '';
    $Lang->{'Specify the different note types that you want to use in your system.'} = '';
    $Lang->{'Show priority options.'} = '';
    $Lang->{'Default priority options.'} = '';
    $Lang->{'Show title fields.'} = '';
    $Lang->{'Shown ticket free text options. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Lang->{'Shown ticket free time options. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Lang->{'Shown article free text options.'} = '';
    $Lang->{'History type for this action.'} = '';
    $Lang->{'History comment for this action.'} = '';
    $Lang->{'Here you can decide if the stats module may generate stats about itsm ticket first level solution rate stuff.'} = '';
    $Lang->{'Here you can decide if the stats module may generate stats about itsm ticket solution average stuff.'} = '';

    return 1;
}

1;
