# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pt_BR_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminDynamicFieldMasterSlave
    $Self->{Translation}->{'Field'} = 'Campo';

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Manage Master/Slave status for %s%s%s'} = 'Gerenciar estado de Mestre/Escravo para %s%s%s';

    # Perl Module: Kernel/Modules/AgentTicketMasterSlave.pm
    $Self->{Translation}->{'New Master Ticket'} = 'Novo Chamado Mestre';
    $Self->{Translation}->{'Unset Master Ticket'} = 'Desfazer Chamado Mestre';
    $Self->{Translation}->{'Unset Slave Ticket'} = 'Desfazer Chamado Escravo';
    $Self->{Translation}->{'Slave of %s%s%s: %s'} = 'Escravo de %s%s%s: %s';

    # Perl Module: Kernel/Output/HTML/TicketBulk/MasterSlave.pm
    $Self->{Translation}->{'Unset Master Tickets'} = 'Limpar Chamados Mestres';
    $Self->{Translation}->{'Unset Slave Tickets'} = 'Limpar Chamados Escravos';

    # Perl Module: Kernel/System/DynamicField/Driver/MasterSlave.pm
    $Self->{Translation}->{'Master'} = 'Mestre';
    $Self->{Translation}->{'Slave of %s%s%s'} = 'Escravo de %s%s%s';
    $Self->{Translation}->{'Master Ticket'} = 'Chamado Mestre';

    # SysConfig
    $Self->{Translation}->{'All master tickets'} = 'Todos chamados mestres';
    $Self->{Translation}->{'All slave tickets'} = 'Todos chamados escravos';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Permite adicionar notas na tela "MasterSlave"';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'Altera o estado MasterSlave de um chamado.';
    $Self->{Translation}->{'Defines dynamic field name for master ticket feature.'} = 'Define o nome do campo dinâmico para a funcionalidade de chamado mestre.';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Define se um bloqueio de ticket é requerido na tela MasterSlave de um ticket detalhado na interface de agente (se o ticket ainda não estiver bloqueado, o ticket será bloqueado e o agente corrente será automaticamente definido como o seu proprietário).';
    $Self->{Translation}->{'Defines if the MasterSlave note is visible for the customer by default.'} =
        '';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Define o próximo estado padrão de um ticket após uma nota ter sido adicionada, na tela MasterSlave de um ticket detalhado na interface de agente.';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Define a prioridade padrão do ticket na tela MasterSlave de um ticket detalhado na interface de agente.';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Define o comentário de histórico para a ação de tela MasterSlave do ticket, que é utilizada para o histórico do ticket na interface de agente.';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Define o tipo de histórico para a ação da tela MasterSlave do ticket, que é utilizado para o histórico do ticket na interface de agente.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Define o próximo estado de um ticket após uma nota ter sido adicionada, na tela MasterSlave de um ticket detalhado na interface de agente.';
    $Self->{Translation}->{'Enables the advanced MasterSlave part of the feature.'} = 'Habilita as funcionalidades avançadas do MasterSlave.';
    $Self->{Translation}->{'Enables the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'} =
        'Habilita a funcionalidade de chamados escravos seguirem chamados mestre para um novo mestre no modo avançado do MasterSlave.';
    $Self->{Translation}->{'Enables the feature to change the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Habilita a funcionalidade de alterar estado do MasterSlave de um chamado no modo avançado.';
    $Self->{Translation}->{'Enables the feature to forward articles from type \'forward\' of a master ticket to the customers of the slave tickets. By default (disabled) it will not forward articles from type \'forward\' to the slave tickets.'} =
        'Habilita a funcionalidade de encaminhar artigos do tipo \'forward\' de um chamado mestre para os clientes dos chamados escravos. Por padrão (desabilitado) os artigos não são encaminhados.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after change of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Habilita a funcionalidade que mantem o link pai-filho após a alteração do estado de MasterSlave no modo avançado do MasterSlave.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after unset of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Habilita a funcionalidade de manter a associação pai-filho depois de limpar o estado de MasterSlave no modo avançado.';
    $Self->{Translation}->{'Enables the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Habilita a funcionalidade de limpar o estado MasterSlave de um chamado no modo avançado.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Se uma nota for adicionada por um agente, define o estado do ticket na tela de MasterSlave de um ticket detalhado na interface de agente.';
    $Self->{Translation}->{'Master / Slave'} = 'Mestre / Escravo';
    $Self->{Translation}->{'Master Tickets'} = 'Chamados Mestres';
    $Self->{Translation}->{'MasterSlave'} = 'MestreEscravo';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = 'Módulo MestreEscravo para funcionalidade de ação em massa de chamado.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parâmetros para o backend do painel de visão geral de tickets mestre da interface de agente. "Limite" é a quantidade de registros exibida por padrão. "Grupo" é usado para restringir o acesso ao plugin (ex.: Grupo: admin;grupo1;grupo2). "Padrão" determina se o plugin é habilitado por padrão ou se o usuário precisa habilitá-lo manualmente. "CacheTTLLocal" é o tempo de cache em minutos para o plugin.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parâmetros para o backend do painel de visão geral de tickets mestre da interface de agente. "Limite" é a quantidade de registros exibida por padrão. "Grupo" é usado para restringir o acesso ao plugin (ex.: Grupo: admin;grupo1;grupo2). "Padrão" determina se o plugin é habilitado por padrão ou se o usuário precisa habilitá-lo manualmente. "CacheTTLLocal" é o tempo de cache em minutos para o plugin.';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'Registro do módulo de eventos de ticket.';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Permissões requeridas para usar a tela MasterSlave de ticket de um ticket detalhado na interface de agente.';
    $Self->{Translation}->{'Sets if Master / Slave field must be selected by the agent.'} = 'Define se o campo Mestre/ Escravo deve ser selecionado pelo agente.';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Define o corpo do texto padrão para notas adicionadas na tela MasterSlave de ticket de um ticket detalhado na interface de agente.';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Define o assunto padrão para notas adicionadas na tela MasterSlave de ticket de um ticket detalhado na interface de agente.';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Define o agente responsável do ticket na tela MasterSlave de ticket de um ticket detalhado na interface de agente.';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Define o serviço na tela MasterSlave de um ticket detalhado na interface de agente (Ticket::Service precisa ser ativado).';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Define o proprietário do ticket na tela MasterSlave de ticket de um ticket detalhado na interface de agente.';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Define o tipo do ticket na tela MasterSlave de ticket de um ticket detalhado na interface de agente (Ticket::Type precisa ser ativado).';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'Exibe um link no menu para alterar o estado MasterSlave de um ticket na tela de detalhe de ticket da interface de agente.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Exibe uma lista de todos os agentes envolvidos neste ticket, na tela MasterSlave de ticket de um ticket detalhado na interface de agente.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Exibe uma lista de todos os agentes possíveis (todos os agentes com permissão de nota na fila/ticket) para determinar quem deve ser informado sobre esta nota, na tela MasterSlave de ticket de um ticket detalhado na interface de agente.';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Exibe as opções de prioridade de ticket na tela MasterSlave de ticket de um ticket detalhado na interface de agente.';
    $Self->{Translation}->{'Shows the title field in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Mostra o título na tela de um chamado MestreEscravo de um chamado aberto na interface de agente.';
    $Self->{Translation}->{'Slave Tickets'} = 'Chamados Escravos';
    $Self->{Translation}->{'Specifies the different article types where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        'Especifica os diferentes tipos de artigo onde o nome real do ticket Master será substituído com o nome do ticket escravo.';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        'Este módulo ativa o campo Mestre/Escravo nas telas de novo chamado fone/e-mail.';
    $Self->{Translation}->{'Ticket MasterSlave.'} = 'Chamado MestreEscravo';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
