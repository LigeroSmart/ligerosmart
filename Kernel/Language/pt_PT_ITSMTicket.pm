# --
# Kernel/Language/pt_PT_ITSMTicket.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# Copyright (C) 2012 FCCN - Rui Francisco <rui.francisco@fccn.pt>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_PT_ITSMTicket;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = 'Alterar decisão do ticket';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'Alterar os campos ITSM do ticket';
    $Self->{Translation}->{'Impact'} = 'Impacto';

    # Template: AgentTicketAddtlITSMField

    # Template: AgentTicketDecision

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = 'Associar ticket';

    # Template: AgentTicketOverviewMedium

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'Criticidade';

    # Template: AgentTicketPhone

    # Template: AgentTicketPrint

    # Template: AgentTicketZoom
    $Self->{Translation}->{'Decision Result'} = 'Resultado da decisão';
    $Self->{Translation}->{'Decision Date'} = 'Data da Decisão';
    $Self->{Translation}->{'Repair Start Time'} = 'Horário Inicial de Reparação';
    $Self->{Translation}->{'Recovery Start Time'} = 'Horário Inicial da Recuperação';
    $Self->{Translation}->{'Due Date'} = 'Data vencimento';

    # Template: CustomerTicketPrint

    # Template: CustomerTicketZoom

    # SysConfig
    $Self->{Translation}->{'Add a decision!'} = 'Adicionar uma decisão!';
    $Self->{Translation}->{'Additional ITSM Fields'} = 'Campos ITSM adicionais';
    $Self->{Translation}->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} = 'Permite adicionar notas ao formulário de campos adicionais ITSM da interface de agente.';
    $Self->{Translation}->{'Allows adding notes in the decision screen of the agent interface.'} = 'Permite adicionar notas ao formuláriode decisão da interface de agente.';
    $Self->{Translation}->{'Article free text options shown in the additional ITSM field screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = 'Opções de texto livre de artigo mostradas no formulário de campos adicionais ITSM da interface de agente. Configurações possíveis: 0 = inativo, 1 = ativo, 2 = Ativo e necessário.';
    $Self->{Translation}->{'Article free text options shown in the decision screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = 'Opções de texto livre de artigo mostradas no formulário de decisão da interface de agente. Configurações possíveis: 0 = inativo, 1 = ativo, 2 = Ativo e necessário.';
    $Self->{Translation}->{'Change the ITSM fields!'} = 'Alterar campos ITSM!';
    $Self->{Translation}->{'Decision'} = 'Decisão';
    $Self->{Translation}->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} = 'Define se o bloqueio do ticket é obrigatório no formulário de campos adicionais ITSM da interface de agente (se o ticket não estiver bloqueado, será bloqueado e o agente atual será automaticamente definido como seu proprietário).';
    $Self->{Translation}->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} = 'Define se o bloqueio do ticket é obrigatório no formulário de decisão da interface de agente (se o ticket não estiver bloqueado, será bloqueado e o agente atual será automaticamente definido como seu proprietário).';
    $Self->{Translation}->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} = 'Define o texto por omissão de uma nota no formulário de campos adicionais ITSM da interface de agente.';
    $Self->{Translation}->{'Defines the default body of a note in the decision screen of the agent interface.'} = 'Define o texto por omissão de uma nota no formulário de decisão da interface de agente.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} = 'Define o próximo estado por omissão de um ticket após a adição de uma nota, no formulário de campos adicionais ITSM de agente.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} = 'Define o próximo estado por omissão de um ticket após a adição de uma nota, no formulário de decisão da interface de agente.';
    $Self->{Translation}->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} = 'Define o assunto por omissão de uma nota no formulário de campos adicionais ITSM da interface de agente.';
    $Self->{Translation}->{'Defines the default subject of a note in the decision screen of the agent interface.'} = 'Define o assunto por omissão de uma nota no formulário de decisão da interface de agente.';
    $Self->{Translation}->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} = 'Define a Prioridade por omissão de ticket no formulário de campos adicionais ITSM da interface de agente.';
    $Self->{Translation}->{'Defines the default ticket priority in the decision screen of the agent interface.'} = 'Define a Prioridade por omissão de ticket no formulário de decisão da interface de agente.';
    $Self->{Translation}->{'Defines the default type of the note in the additional ITSM field screen of the agent interface.'} = 'Define o tipo por omissão de uma nota no formulário de campos adicionais ITSM da interface de agente.';
    $Self->{Translation}->{'Defines the default type of the note in the decision screen of the agent interface.'} = 'Define o tipo por omissão de uma nota no formulário de decisão da interface de agente.';
    $Self->{Translation}->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} = 'Define o comentário de histórico para a ação de campos adicionais ITSM, utilizado no histórico do ticket.';
    $Self->{Translation}->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} = 'Define o comentário de histórico para a ação de decisão, utilizado no histórico do ticket.';
    $Self->{Translation}->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} = 'Define o tipo de histórico para a ação de campos adicionais ITSM, utilizado no histórico do ticket.';
    $Self->{Translation}->{'Defines the history type for the decision screen action, which gets used for ticket history.'} = 'Define o tipo de histórico para a ação de decisão, utilizado no histórico do ticket.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} = 'Define o próximo estado de um ticket após a adição de uma nota, no formulário de campos adicionais ITSM da interface de agente.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} = 'Define o próximo estado de um ticket após a adição de uma nota, no formulário de decisão da interface de agente.';
    $Self->{Translation}->{'Defines the the free key field number 13 for tickets to add a new ticket attribute.'} = 'Define o campo-chave livre número 13 para tickets para adicionar um novo atributo de ticket.';
    $Self->{Translation}->{'Defines the the free key field number 14 for tickets to add a new ticket attribute.'} = 'Define o campo-chave livre número 14 para tickets para adicionar um novo atributo de ticket.';
    $Self->{Translation}->{'Defines the the free key field number 15 for tickets to add a new ticket attribute.'} = 'Define o campo-chave livre número 15 para tickets para adicionar um novo atributo de ticket.';
    $Self->{Translation}->{'Defines the the free key field number 16 for tickets to add a new ticket attribute.'} = 'Define o campo-chave livre número 16 para tickets para adicionar um novo atributo de ticket.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} = 'Permite que o módulo de estatísticas gere estatísticas sobre o nível médio de tickets ITSM no primeiro nível de solução.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} = 'Permite que o módulo de estatísticas gere estatísticas sobre o nível médio de tickets ITSM no primeiro nível de solução.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} = 'Se uma nota é adicionada por um agente, define o estado do ticket no formulário de campos adicionais ITSM da interface de agente.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} = 'Se uma nota é adicionada por um agente, define o estado do ticket no formulário de decisão da interface de agente.';
    $Self->{Translation}->{'Required permissions to use the additional ITSM field screen in the agent interface.'} = 'Permissões necessárias para utilizar o formulário de campos adicionais ITSM do agente.';
    $Self->{Translation}->{'Required permissions to use the decision screen in the agent interface.'} = 'Permissões necessárias para utilizar o formulário de decisão do agente.';
    $Self->{Translation}->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} = 'Define o serviço adicional ao formulário de campos adicionais ITSM de interface do agente (ticket::Serviço necessita de estar ativo).';
    $Self->{Translation}->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} = 'Define o serviço do formulário de decisão do agente (ticket::Serviço necessita de estar ativo).';
    $Self->{Translation}->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} = 'Define o proprietário do ticket do formulário de campos adicionais ITSM do agente.';
    $Self->{Translation}->{'Sets the ticket owner in the decision screen of the agent interface.'} = 'Define o proprietário do ticket do formulário de decisão do agente.';
    $Self->{Translation}->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} = 'Define o responsável pelo ticket no formulário de campos adicionais ITSM d0 agente.';
    $Self->{Translation}->{'Sets the ticket responsible in the decision screen of the agent interface.'} = 'Define o responsável pelo ticket do formulário de decisão do agente.';
    $Self->{Translation}->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} = 'Define o tipo de ticket do formulário de campos adicionais ITSM do agente. (ticket::Tipo necessita de estar ativo).';
    $Self->{Translation}->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} = 'Define o tipo de ticket do formulário de decisão do agente (ticket::Tipo necessita de estar ativo).';
    $Self->{Translation}->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} = 'Mostra um link no menu para alterar a decisão de um ticket na vista de detalhes do agente.';
    $Self->{Translation}->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} = 'Mostra um link no menu para modificar campos adicionais ITSM na vista de detalhes do ticket do agente.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} = 'Mostra uma lista de todos os agentes envolvidos neste ticket, no formulário de campos adicionais ITSM do agente.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} = 'Mostra uma lista de todos os agentes envolvidos neste ticket, no formulário de decisão do agente.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} = 'Mostra uma lista dos agentes possíveis (todos os agentes com permissões de nota na fila/ticket) para determinar quem deve ser informado sobre esta nota, no formulário de campos adicionais ITSM do agente.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} = 'Mostra uma lista dos agentes possíveis (todos os agentes com permissões nota na fila/ticket) para determinar quem deve ser informado sobre esta nota, no formulário de decisão do agente.';
    $Self->{Translation}->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} = 'Mostra as opções de Prioridade do ticket no formulário de campos adicionais ITSM do agente.';
    $Self->{Translation}->{'Shows the ticket priority options in the decision screen of the agent interface.'} = 'Mostra as opções de Prioridade de ticket no formulário de decisão do agente.';
    $Self->{Translation}->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} = 'Mostra os campos de título no formulário de campos adicionais ITSM do agente.';
    $Self->{Translation}->{'Shows the title fields in the decision screen of the agent interface.'} = 'Mostra os campos de título no formulário de decisão do agente.';
    $Self->{Translation}->{'Ticket free text options shown in the additional ITSM field screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = 'Opções de texto livre de ticket visualizadas no formulário de campos adicionais ITSM do agente. Configurações possíveis: 0 = inativo, 1 = ativo, 2 = Ativo e necessário.';
    $Self->{Translation}->{'Ticket free text options shown in the decision screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = 'Opções de texto livre de ticket visualizadas no formulário no agente. Configurações possíveis: 0 = inativo, 1 = ativo, 2 = Ativo e necessário.';
    $Self->{Translation}->{'Ticket free time options shown in the additional ITSM field screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = 'Opções de tempo livre de ticket visualizadas no formulário de campos adicionais ITSM da interface de agente. Configurações possíveis: 0 = inativo, 1 = ativo, 2 = Ativo e necessário.';
    $Self->{Translation}->{'Ticket free time options shown in the decision screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = 'Opções de tempo livre de ticket visualizadas no formulário de decisão do agente. Configurações possíveis: 0 = inativo, 1 = ativo, 2 = Ativo e necessário.';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Add decision to ticket'} = 'Adicionar decisão ao ticket';
    $Self->{Translation}->{'Reason'} = 'Motivo';
    $Self->{Translation}->{'Review Required'} = 'Avaliação necessária ';
    $Self->{Translation}->{'closed with workaround'} = 'fechado com solução de contorno';

}

1;
