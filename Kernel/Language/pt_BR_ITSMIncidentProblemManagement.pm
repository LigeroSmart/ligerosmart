# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pt_BR_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketOverviewMedium
    $Self->{Translation}->{'Criticality'} = 'Criticalidade';
    $Self->{Translation}->{'Impact'} = 'Impacto';

    # JS Template: ServiceIncidentState
    $Self->{Translation}->{'Service Incident State'} = 'Estado de Incidente do Serviço';

    # Perl Module: Kernel/Output/HTML/FilterElementPost/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Link ticket'} = 'Associar chamado';
    $Self->{Translation}->{'Change Decision of %s%s%s'} = 'Mudar decisão de %s%s%s';
    $Self->{Translation}->{'Change ITSM fields of %s%s%s'} = 'Alterar campos ITSM de %s%s%s';

    # Perl Module: var/packagesetup/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Review Required'} = 'Revisão Requisitada';
    $Self->{Translation}->{'Decision Result'} = 'Decisão Resultante';
    $Self->{Translation}->{'Approved'} = 'Aprovado';
    $Self->{Translation}->{'Postponed'} = 'Prorrogado';
    $Self->{Translation}->{'Pre-approved'} = 'Pré-aprovado';
    $Self->{Translation}->{'Rejected'} = 'Rejeitado';
    $Self->{Translation}->{'Repair Start Time'} = 'Horário Inicial de Reparo';
    $Self->{Translation}->{'Recovery Start Time'} = 'Horário Inicial de Recuperação';
    $Self->{Translation}->{'Decision Date'} = 'Data de Decisão';
    $Self->{Translation}->{'Due Date'} = 'Data de vencimento';

    # Database XML Definition: ITSMIncidentProblemManagement.sopm
    $Self->{Translation}->{'closed with workaround'} = 'fechado com solução de contorno';

    # SysConfig
    $Self->{Translation}->{'Add a decision!'} = 'Adicionar uma decisão!';
    $Self->{Translation}->{'Additional ITSM Fields'} = 'Campos adicionais ITSM';
    $Self->{Translation}->{'Additional ITSM ticket fields.'} = 'Campos adicionais de Ticket ITSM';
    $Self->{Translation}->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} =
        'Permite adicionar notas na tela de campos adicionais ITSM da interface de atendente.';
    $Self->{Translation}->{'Allows adding notes in the decision screen of the agent interface.'} =
        'Permite adicionar notas na tela de decisão da interface de atendente.';
    $Self->{Translation}->{'Allows defining new types for ticket (if ticket type feature is enabled).'} =
        'Permite definir novos tipos de chamado (caso a funcionalidade tipo do chamado esteja habilitada).';
    $Self->{Translation}->{'Change the ITSM fields!'} = 'Alterar campos ITSM!';
    $Self->{Translation}->{'Decision'} = 'Decisão';
    $Self->{Translation}->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Define se um bloqueio de chamado é exigido na tela de campos adicionais ITSM da interface de atendente (se o chamado não estiver bloqueado ainda, o chamado será bloqueadoe o atendente atual será automaticamente definido como seu proprietário).';
    $Self->{Translation}->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Define se um bloqueio de chamado é exigido na tela de decisão da interface de atendente (se o chamado não estiver bloqueado ainda, o chamado será bloqueadoe o atendente atual será automaticamente definido como seu proprietário).';
    $Self->{Translation}->{'Defines if the service incident state should be shown during service selection in the agent interface.'} =
        'Define se o estado de incidente do serviço deve ser mostrado durante a seleção de serviço na interface de atendente.';
    $Self->{Translation}->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} =
        'Define o corpo padrão de uma nota na tela de campos adicionais ITSM da interface de atendente.';
    $Self->{Translation}->{'Defines the default body of a note in the decision screen of the agent interface.'} =
        'Define o corpo padrão de uma nota na tela de decisão da interface de atendente.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Define o próximo estado padrão de um chamado após a adição de uma nota, na tela de campos adicionais ITSM da interface de atendente.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Define o próximo estado padrão de um chamado após a adição de uma nota, na tela de decisão da interface de atendente.';
    $Self->{Translation}->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} =
        'Define o assunto padrão de uma nota na tela de campos adicionais ITSM da interface de atendente.';
    $Self->{Translation}->{'Defines the default subject of a note in the decision screen of the agent interface.'} =
        'Define o assunto padrão de uma nota na tela de decisão da interface de atendente.';
    $Self->{Translation}->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} =
        'Define a prioridade padrão de chamado na tela de campos adicionais ITSM da interface de atendente.';
    $Self->{Translation}->{'Defines the default ticket priority in the decision screen of the agent interface.'} =
        'Define a prioridade padrão de chamado na tela de decisão da interface de atendente.';
    $Self->{Translation}->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Define o comentário de histórico para a ação de campos adicionais ITSM, que é usado no histórico do chamado.';
    $Self->{Translation}->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} =
        'Define o comentário de histórico para a ação de decisão, que é usado no histórico do chamado.';
    $Self->{Translation}->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Define o tipo de histórico para a ação de campos adicionais ITSM, que é usado no histórico do chamado.';
    $Self->{Translation}->{'Defines the history type for the decision screen action, which gets used for ticket history.'} =
        'Define o tipo de histórico para a ação de decisão, que é usado no histórico do chamado.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Define o próximo estado de um chamado após a adição de uma nota, na tela de campos adicionais ITSM da interface de atendente.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Define o próximo estado de um chamado após a adição de uma nota, na tela de decisão da interface de atendente.';
    $Self->{Translation}->{'Dynamic fields shown in the additional ITSM field screen of the agent interface.'} =
        'Campos dinâmicos mostrados no campo de tela ITSM adicional da interface de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the decision screen of the agent interface.'} =
        'Campos dinâmicos mostrados na tela de decisão da interface do agente.';
    $Self->{Translation}->{'Dynamic fields shown in the ticket zoom screen of the agent interface.'} =
        'Campos dinâmicos mostrados na tela de zoom do ticket da interface de agente.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} =
        'Permite que o módulo de estatísticas gere estatísticas sobre o nível médio de chamados ITSM no primeiro nível de solução.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} =
        'Permite que o módulo de estatísticas gere estatísticas sobre o nível médio de chamados ITSM no primeiro nível de solução.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} =
        'Se uma nota é adicionada por um atendente, define o estado de um chamado na tela de campos adicionais ITSM da interface de atendente.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} =
        'Se uma nota é adicionada por um atendente, define o estado de um chamado na tela de decisão da interface dd atendente.';
    $Self->{Translation}->{'Modifies the display order of the dynamic field ITSMImpact and other things.'} =
        'Modifica a ordem de exibição do campo dinâmico ITSMImpact e outras coisas.';
    $Self->{Translation}->{'Module to dynamically show the service incident state and to calculate the priority.'} =
        'Módulo para mostrar dinamicamente o estado do incidente de serviço e para calcular a prioridade.';
    $Self->{Translation}->{'Required permissions to use the additional ITSM field screen in the agent interface.'} =
        'Permissões necessárias para usar a tela de campos adicionais ITSM na interface de atendente.';
    $Self->{Translation}->{'Required permissions to use the decision screen in the agent interface.'} =
        'Permissões necessárias para usar a tela de decisão na interface de atendente.';
    $Self->{Translation}->{'Service Incident State and Priority Calculation'} = 'Estado de Incidente de Serviço e Cálculo de prioridade.';
    $Self->{Translation}->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Define o serviço adicional na tela de campos adicionais ITSM de interface do atendente (Chamado::Serviço precisa estar ativado).';
    $Self->{Translation}->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Define o serviço na tela de decisão da interface de atendente (Chamado::Serviço precisa estar ativado).';
    $Self->{Translation}->{'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Define o serviço na tela de prioridade de ticket de um ticket em zoom na interface de agente (Ticket::Service precisa estar ativo).';
    $Self->{Translation}->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} =
        'Define o proprietário do chamado na tela de campos adicionais ITSM da interface de atendente.';
    $Self->{Translation}->{'Sets the ticket owner in the decision screen of the agent interface.'} =
        'Define o proprietário do chamado na tela de decisão da interface de atendente.';
    $Self->{Translation}->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} =
        'Define o responsável pelo chamado de tela de campos adicionais ITSM da interface de atendente.';
    $Self->{Translation}->{'Sets the ticket responsible in the decision screen of the agent interface.'} =
        'Define o responsável pelo chamado na tela decisão da interface de atendente.';
    $Self->{Translation}->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Define o tipo de chamado na tela de campos adicionais ITSM da interface de atendente. (Chamado::Tipo precisa estar ativado).';
    $Self->{Translation}->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Define o tipo de chamado na tela de decisão da interface de atendente (Chamado::Tipo precisa estar ativado).';
    $Self->{Translation}->{'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Define o tipo de serviço na tela de prioridade do ticket de um ticket em zoom na interface de agente (Ticket::Type precisa estar ativo).';
    $Self->{Translation}->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} =
        'Mostra um link no menu para alterar a decisão de um chamado na sua visão em detalhes na interface de atendente.';
    $Self->{Translation}->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} =
        'Mostra um link no menu para modificar campos adicionais ITSM na visão em detalhes de um chamado na interface de atendente.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} =
        'Mostra uma lista de todos os atendentes envolvidos neste chamado, na tela de campos adicionais ITSM da interface de atendente.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} =
        'Mostra uma lista de todos os atendentes envolvidos neste chamado, na tela de decisão da interface de atendente.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} =
        'Mostra uma lista de todos os atendentes possíveis (todos os atendentes com permissões de nota na fila/chamado) para determinar quem deve ser informado sobre esta nota, na tela de campos adicionais ITSM da interface de atendente.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} =
        'Mostra uma lista de todos os atendentes possíveis (todos os atendentes com permissões nota na fila/chamado) para determinar quem deve ser informado sobre esta nota, na tela de decisão da interface de atendente.';
    $Self->{Translation}->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} =
        'Mostra as opções de prioridade de chamado na tela de campos adicionais ITSM da interface de atendente.';
    $Self->{Translation}->{'Shows the ticket priority options in the decision screen of the agent interface.'} =
        'Mostra as opções de prioridade de chamado na tela de decisão da interface de atendente.';
    $Self->{Translation}->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} =
        'Mostra os campos de título na tela de campos adicionais ITSM da interface de atendente.';
    $Self->{Translation}->{'Shows the title fields in the decision screen of the agent interface.'} =
        'Mostra os campos de título na tela de decisão da interface de atendente.';
    $Self->{Translation}->{'Ticket decision.'} = 'Decisão de Chamado.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Service Incident State',
    );

}

1;
