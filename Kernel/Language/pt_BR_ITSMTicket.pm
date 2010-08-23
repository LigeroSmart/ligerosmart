# --
# Kernel/Language/pt_BR_ITSMTicket.pm - the Brazilian translation of ITSMTicket
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2010 Cristiano Korndörfer, http://www.dorfer.com.br/
# --
# $Id: pt_BR_ITSMTicket.pm,v 1.2 2010-08-23 18:58:35 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Data Vencimento';
    $Lang->{'Decision'}                     = 'Decisão';
    $Lang->{'Reason'}                       = 'Razão';
    $Lang->{'Decision Date'}                = 'Data de Decisão';
    $Lang->{'Add decision to ticket'}       = 'Adicionar Decisão à Solicitação';
    $Lang->{'Decision Result'}              = 'Decisão Resultante';
    $Lang->{'Review Required'}              = 'Revisão Requisitada';
    $Lang->{'closed with workaround'}       = 'fechada com solução de contorno';
    $Lang->{'Additional ITSM Fields'}       = 'Campos adicionais ITSM';
    $Lang->{'Change ITSM fields of ticket'} = 'Mudar os campos ITSM da solicitação';
    $Lang->{'Repair Start Time'}            = 'Hora Inicial do Reparo';
    $Lang->{'Recovery Start Time'}          = 'Hora Inicial da Recuperação';
    $Lang->{'Change the ITSM fields!'}      = 'Mudar os campos ITSM!';
    $Lang->{'Add a decision!'}              = 'Adicionar uma decisão!';
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

    return 1;
}

1;
