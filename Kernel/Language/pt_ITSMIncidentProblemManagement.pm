# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pt_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketOverviewMedium
    $Self->{Translation}->{'Criticality'} = 'Criticidade';
    $Self->{Translation}->{'Impact'} = 'Impacto';

    # JS Template: ServiceIncidentState
    $Self->{Translation}->{'Service Incident State'} = 'Estado de Incidente do Serviço';

    # Perl Module: Kernel/Output/HTML/FilterElementPost/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Link ticket'} = 'Associar ticket';
    $Self->{Translation}->{'Change Decision of %s%s%s'} = 'Alterar a Decisão de%s%s%s';
    $Self->{Translation}->{'Change ITSM fields of %s%s%s'} = 'Altera campos ITSM de %s%s%s';

    # Perl Module: var/packagesetup/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Review Required'} = 'Avaliação necessária ';
    $Self->{Translation}->{'Decision Result'} = 'Resultado da decisão';
    $Self->{Translation}->{'Approved'} = 'Aprovado';
    $Self->{Translation}->{'Postponed'} = 'Adiado';
    $Self->{Translation}->{'Pre-approved'} = 'Pré-aprovado';
    $Self->{Translation}->{'Rejected'} = 'Rejeitado';
    $Self->{Translation}->{'Repair Start Time'} = 'Horário Inicial de Reparação';
    $Self->{Translation}->{'Recovery Start Time'} = 'Horário Inicial da Recuperação';
    $Self->{Translation}->{'Decision Date'} = 'Data da Decisão';
    $Self->{Translation}->{'Due Date'} = 'Data vencimento';

    # Database XML Definition: ITSMIncidentProblemManagement.sopm
    $Self->{Translation}->{'closed with workaround'} = 'fechado com solução de contorno';

    # SysConfig
    $Self->{Translation}->{'Add a decision!'} = 'Adicionar uma decisão!';
    $Self->{Translation}->{'Additional ITSM Fields'} = 'Campos ITSM adicionais';
    $Self->{Translation}->{'Additional ITSM ticket fields.'} = 'Campos adicionais de ticket ITSM.';
    $Self->{Translation}->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} =
        'Permite adicionar notas ao formulário de campos adicionais ITSM da interface de agente.';
    $Self->{Translation}->{'Allows adding notes in the decision screen of the agent interface.'} =
        'Permite adicionar notas ao formuláriode decisão da interface de agente.';
    $Self->{Translation}->{'Allows defining new types for ticket (if ticket type feature is enabled).'} =
        'Permite definir novos tipos de tickets (se a funcionalidade de tipo de ticket estiver ativa).';
    $Self->{Translation}->{'Change the ITSM fields!'} = 'Alterar campos ITSM!';
    $Self->{Translation}->{'Decision'} = 'Decisão';
    $Self->{Translation}->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Define se o bloqueio do ticket é obrigatório no formulário de campos adicionais ITSM da interface de agente (se o ticket não estiver bloqueado, será bloqueado e o agente atual será automaticamente definido como seu proprietário).';
    $Self->{Translation}->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Define se o bloqueio do ticket é obrigatório no formulário de decisão da interface de agente (se o ticket não estiver bloqueado, será bloqueado e o agente atual será automaticamente definido como seu proprietário).';
    $Self->{Translation}->{'Defines if the service incident state should be shown during service selection in the agent interface.'} =
        'Define se o estado de incidente do serviço deve ser mostrado durante a seleção de serviço na interface de atendente.';
    $Self->{Translation}->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} =
        'Define o texto por omissão de uma nota no formulário de campos adicionais ITSM da interface de agente.';
    $Self->{Translation}->{'Defines the default body of a note in the decision screen of the agent interface.'} =
        'Define o texto por omissão de uma nota no formulário de decisão da interface de agente.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Define o próximo estado por omissão de um ticket após a adição de uma nota, no formulário de campos adicionais ITSM de agente.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Define o próximo estado por omissão de um ticket após a adição de uma nota, no formulário de decisão da interface de agente.';
    $Self->{Translation}->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} =
        'Define o assunto por omissão de uma nota no formulário de campos adicionais ITSM da interface de agente.';
    $Self->{Translation}->{'Defines the default subject of a note in the decision screen of the agent interface.'} =
        'Define o assunto por omissão de uma nota no formulário de decisão da interface de agente.';
    $Self->{Translation}->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} =
        'Define a Prioridade por omissão de ticket no formulário de campos adicionais ITSM da interface de agente.';
    $Self->{Translation}->{'Defines the default ticket priority in the decision screen of the agent interface.'} =
        'Define a Prioridade por omissão de ticket no formulário de decisão da interface de agente.';
    $Self->{Translation}->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Define o comentário de histórico para a ação de campos adicionais ITSM, utilizado no histórico do ticket.';
    $Self->{Translation}->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} =
        'Define o comentário de histórico para a ação de decisão, utilizado no histórico do ticket.';
    $Self->{Translation}->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Define o tipo de histórico para a ação de campos adicionais ITSM, utilizado no histórico do ticket.';
    $Self->{Translation}->{'Defines the history type for the decision screen action, which gets used for ticket history.'} =
        'Define o tipo de histórico para a ação de decisão, utilizado no histórico do ticket.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Define o próximo estado de um ticket após a adição de uma nota, no formulário de campos adicionais ITSM da interface de agente.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Define o próximo estado de um ticket após a adição de uma nota, no formulário de decisão da interface de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the additional ITSM field screen of the agent interface.'} =
        'Campos dinâmicos mostrados no ecrâ adicional ITSM da interface do agente.';
    $Self->{Translation}->{'Dynamic fields shown in the decision screen of the agent interface.'} =
        'Campos dinâmicos mostrados no ecrâ de decisão da interface do agente.';
    $Self->{Translation}->{'Dynamic fields shown in the ticket zoom screen of the agent interface.'} =
        'Campos dinâmicos mostrados no ecrâ de zoom do pedido da interface do agente.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} =
        'Permite que o módulo de estatísticas gere estatísticas sobre o nível médio de tickets ITSM no primeiro nível de solução.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} =
        'Permite que o módulo de estatísticas gere estatísticas sobre o nível médio de tickets ITSM no primeiro nível de solução.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} =
        'Se uma nota é adicionada por um agente, define o estado do ticket no formulário de campos adicionais ITSM da interface de agente.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} =
        'Se uma nota é adicionada por um agente, define o estado do ticket no formulário de decisão da interface de agente.';
    $Self->{Translation}->{'Modifies the display order of the dynamic field ITSMImpact and other things.'} =
        'Modifica a ordem de exibição do campo dinâmico ITSMImpact e outras coisas.';
    $Self->{Translation}->{'Module to dynamically show the service incident state and to calculate the priority.'} =
        'Módulo para mostrar dinamicamente o estado do incidente do serviço e calcular a prioridade.';
    $Self->{Translation}->{'Required permissions to use the additional ITSM field screen in the agent interface.'} =
        'Permissões necessárias para utilizar o formulário de campos adicionais ITSM do agente.';
    $Self->{Translation}->{'Required permissions to use the decision screen in the agent interface.'} =
        'Permissões necessárias para utilizar o formulário de decisão do agente.';
    $Self->{Translation}->{'Service Incident State and Priority Calculation'} = 'Estado de Incidente de Serviço e Cálculo de Prioridade';
    $Self->{Translation}->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Define o serviço adicional ao formulário de campos adicionais ITSM de interface do agente (ticket::Serviço necessita de estar ativo).';
    $Self->{Translation}->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Define o serviço do formulário de decisão do agente (ticket::Serviço necessita de estar ativo).';
    $Self->{Translation}->{'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Define o serviço no ecran de prioridade do ticket, no detalhe de ticket no interface de agente (Ticket::Service necessita de ser ativado).';
    $Self->{Translation}->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} =
        'Define o proprietário do ticket do formulário de campos adicionais ITSM do agente.';
    $Self->{Translation}->{'Sets the ticket owner in the decision screen of the agent interface.'} =
        'Define o proprietário do ticket do formulário de decisão do agente.';
    $Self->{Translation}->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} =
        'Define o responsável pelo ticket no formulário de campos adicionais ITSM d0 agente.';
    $Self->{Translation}->{'Sets the ticket responsible in the decision screen of the agent interface.'} =
        'Define o responsável pelo ticket do formulário de decisão do agente.';
    $Self->{Translation}->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Define o tipo de ticket do formulário de campos adicionais ITSM do agente. (ticket::Tipo necessita de estar ativo).';
    $Self->{Translation}->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Define o tipo de ticket do formulário de decisão do agente (ticket::Tipo necessita de estar ativo).';
    $Self->{Translation}->{'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Define o tipo de ticket no ecran de prioridade de ticket do detalhe de um ticket no interface de agente (Ticket::Type necessita de ser ativado).';
    $Self->{Translation}->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} =
        'Mostra um link no menu para alterar a decisão de um ticket na vista de detalhes do agente.';
    $Self->{Translation}->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} =
        'Mostra um link no menu para modificar campos adicionais ITSM na vista de detalhes do ticket do agente.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} =
        'Mostra uma lista de todos os agentes envolvidos neste ticket, no formulário de campos adicionais ITSM do agente.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} =
        'Mostra uma lista de todos os agentes envolvidos neste ticket, no formulário de decisão do agente.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} =
        'Mostra uma lista dos agentes possíveis (todos os agentes com permissões de nota na fila/ticket) para determinar quem deve ser informado sobre esta nota, no formulário de campos adicionais ITSM do agente.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} =
        'Mostra uma lista dos agentes possíveis (todos os agentes com permissões nota na fila/ticket) para determinar quem deve ser informado sobre esta nota, no formulário de decisão do agente.';
    $Self->{Translation}->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} =
        'Mostra as opções de Prioridade do ticket no formulário de campos adicionais ITSM do agente.';
    $Self->{Translation}->{'Shows the ticket priority options in the decision screen of the agent interface.'} =
        'Mostra as opções de Prioridade de ticket no formulário de decisão do agente.';
    $Self->{Translation}->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} =
        'Mostra os campos de título no formulário de campos adicionais ITSM do agente.';
    $Self->{Translation}->{'Shows the title fields in the decision screen of the agent interface.'} =
        'Mostra os campos de título no formulário de decisão do agente.';
    $Self->{Translation}->{'Ticket decision.'} = 'Decisão de ticket.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Service Incident State',
    );

}

1;
