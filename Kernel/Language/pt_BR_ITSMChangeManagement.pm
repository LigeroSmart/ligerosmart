# --
# Kernel/Language/pt_BR_ITSMChangeManagement.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_ITSMChangeManagement;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAITSMChangeManagement
    $Self->{Translation}->{'ITSMChange'} = 'Mudança';
    $Self->{Translation}->{'ITSMChanges'} = 'Mudanças';
    $Self->{Translation}->{'ITSM Changes'} = 'Mudanças ITSM';
    $Self->{Translation}->{'workorder'} = 'Ordem de Serviço';
    $Self->{Translation}->{'A change must have a title!'} = 'Uma mudança deve ter um título!';
    $Self->{Translation}->{'A condition must have a name!'} = 'Uma condição deve ter um nome!';
    $Self->{Translation}->{'A template must have a name!'} = 'Um modelo deve ter um nome!';
    $Self->{Translation}->{'A workorder must have a title!'} = 'Uma ordem de serviço deve ter um título!';
    $Self->{Translation}->{'ActionExecute::successfully'} = 'Com sucesso';
    $Self->{Translation}->{'ActionExecute::unsuccessfully'} = 'Sem sucesso';
    $Self->{Translation}->{'Add CAB Template'} = 'Adicionar modelo de CCM';
    $Self->{Translation}->{'Add Workorder'} = 'Adicionar Ordem';
    $Self->{Translation}->{'Add a workorder to the change'} = 'Adicionar ordem de serviço à mudança';
    $Self->{Translation}->{'Add new condition and action pair'} = 'Adicionar nova condição e par de ações';
    $Self->{Translation}->{'Agent interface module to show the ChangeManager overview icon.'} =
        'Módulo de interface de atendente para exibir o ícone de visão geral Gerente de Mudança.';
    $Self->{Translation}->{'Agent interface module to show the MyCAB overview icon.'} = 'Módulo de interface de atendente para exibir o ícone de visão geral MeuCCM.';
    $Self->{Translation}->{'Agent interface module to show the MyChanges overview icon.'} = 'Módulo de interface de atendente para exibir o ícone de visão geral Minhas Mudanças.';
    $Self->{Translation}->{'Agent interface module to show the MyWorkOrders overview icon.'} =
        'Módulo de interface de atendente para exibir o ícone de visão geral Minhas Ordens de Serviços.';
    $Self->{Translation}->{'CABAgents'} = 'Atendentes CCM';
    $Self->{Translation}->{'CABCustomers'} = 'Clientes CCM';
    $Self->{Translation}->{'Change Overview'} = 'Visão Geral de Mudanças';
    $Self->{Translation}->{'Change Schedule'} = 'Agenda de Mudanças';
    $Self->{Translation}->{'Change involved persons of the change'} = 'Alterar pessoas envolvidas na mudança';
    $Self->{Translation}->{'ChangeHistory::ActionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ActionAddID'} = 'Nova Ação (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ActionDelete'} = 'Ação (ID=%s) deletada';
    $Self->{Translation}->{'ChangeHistory::ActionDeleteAll'} = 'Todas as Ações de Condição (ID=%s) deletadas';
    $Self->{Translation}->{'ChangeHistory::ActionExecute'} = 'Ação (ID=%s) executada: %s';
    $Self->{Translation}->{'ChangeHistory::ActionUpdate'} = '%s (Ação ID=%s): Nova: %s -> Antiga: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeActualEndTimeReached'} = 'Mudança (ID=%s) atingiu o tempo real de fim.';
    $Self->{Translation}->{'ChangeHistory::ChangeActualStartTimeReached'} = 'Mudança (ID=%s) atingiu o tempo real de início.';
    $Self->{Translation}->{'ChangeHistory::ChangeAdd'} = 'Nova Mudança (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentAdd'} = 'Novo Anexo: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentDelete'} = 'Anexo Deletado %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABDelete'} = 'CCM Deletado %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABUpdate'} = '%s: Nova: %s -> Antiga: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkAdd'} = 'Associação a %s (ID=%s) adicionada';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkDelete'} = 'Associação a %s (ID=%s) deletada';
    $Self->{Translation}->{'ChangeHistory::ChangeNotificationSent'} = 'Notificação enviada para %s (Evento: %s)';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedEndTimeReached'} = 'Mudança (ID=%s) atingiu o tempo de fim previsto.';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedStartTimeReached'} = 'Mudança (ID=%s) atingiu o tempo de início previsto.';
    $Self->{Translation}->{'ChangeHistory::ChangeRequestedTimeReached'} = 'Mudança (ID=%s) atingiu o tempo solicitado.';
    $Self->{Translation}->{'ChangeHistory::ChangeUpdate'} = '%s: Nova: %s -> Antiga: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAddID'} = 'Nova Condição (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ConditionDelete'} = 'Condição (ID=%s) deletada';
    $Self->{Translation}->{'ChangeHistory::ConditionDeleteAll'} = 'Todas as Condições de Mudança (ID=%s) deletadas';
    $Self->{Translation}->{'ChangeHistory::ConditionUpdate'} = '%s (Condição ID=%s): Nova: %s -> Antiga: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAddID'} = 'Nova Expressão (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ExpressionDelete'} = 'Expressão (ID=%s) deletada';
    $Self->{Translation}->{'ChangeHistory::ExpressionDeleteAll'} = 'Todas as Expressões de Condição (ID=%s) deletadas';
    $Self->{Translation}->{'ChangeHistory::ExpressionUpdate'} = '%s (ID Expressão=%s): Nova: %s -> Antiga: %s';
    $Self->{Translation}->{'ChangeNumber'} = 'Número da Mudança';
    $Self->{Translation}->{'Condition Edit'} = 'Editar Condição';
    $Self->{Translation}->{'Create Change'} = 'Criar Mudança';
    $Self->{Translation}->{'Create a change from this ticket!'} = 'Criar uma mudança a partir deste chamado!';
    $Self->{Translation}->{'Delete Workorder'} = 'Excluir Ordem de Serviço';
    $Self->{Translation}->{'Edit the change'} = 'Editar a mudança';
    $Self->{Translation}->{'Edit the conditions of the change'} = 'Editar as condições da mudança';
    $Self->{Translation}->{'Edit the workorder'} = 'Editar Ordem de Serviço';
    $Self->{Translation}->{'Expression'} = 'Expressão';
    $Self->{Translation}->{'Full-Text Search in Change and Workorder'} = 'Procura por texto completo em mudanças e ordens de serviço';
    $Self->{Translation}->{'ITSMCondition'} = 'Condição ITSM';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'Ordem de Serviço ITSM';
    $Self->{Translation}->{'Link another object to the change'} = 'Associar um outro objeto à mudança';
    $Self->{Translation}->{'Link another object to the workorder'} = 'Associar um outro objeto à ordem de serviço';
    $Self->{Translation}->{'Move all workorders in time'} = 'Mover todas as ordens de serviço no tempo';
    $Self->{Translation}->{'My CABs'} = 'Meus CCMs';
    $Self->{Translation}->{'My Changes'} = 'Minhas Mudanças';
    $Self->{Translation}->{'My Work Orders'} = 'Minhas Ordens de Serviço';
    $Self->{Translation}->{'No XXX settings'} = 'Nenhuma \'%s\' configuração';
    $Self->{Translation}->{'Schedule'} = 'Calendário de Mudanças';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'RPI (Revisão Pós-Implementação)';
    $Self->{Translation}->{'PIR'} = 'Revisão Pós-Implementação';
    $Self->{Translation}->{'Projected Service Availability (PSA)'} = 'DPS (Disponibilidade Projetada de Serviço)';
    $Self->{Translation}->{'Projected Service Availability'} = 'Disponibilidade Projetada de Serviço';
    $Self->{Translation}->{'Please select first a catalog class!'} = 'Por favor, selecione primeiro uma classe de catálogo!';
    $Self->{Translation}->{'Print the change'} = 'Imprimir a mudança';
    $Self->{Translation}->{'Print the workorder'} = 'Imprimir a ordem de serviço';
    $Self->{Translation}->{'RequestedTime'} = 'Solicitado em';
    $Self->{Translation}->{'Save Change CAB as Template'} = 'Salvar CCM da mudança como modelo';
    $Self->{Translation}->{'Save change as a template'} = 'Salvar mudança como modelo';
    $Self->{Translation}->{'Save workorder as a template'} = 'Salvar ordem de serviço como modelo';
    $Self->{Translation}->{'Search Changes'} = 'Procurar Mudanças';
    $Self->{Translation}->{'Set the agent for the workorder'} = 'Alocar atendente para a ordem de serviço';
    $Self->{Translation}->{'Take Workorder'} = 'Assumir Ordem de Serviço';
    $Self->{Translation}->{'Take the workorder'} = 'Assumir a ordem de serviço';
    $Self->{Translation}->{'Template Overview'} = 'Visão Geral de Modelos';
    $Self->{Translation}->{'The planned end time is invalid!'} = 'O horário de término planejado é inválido!';
    $Self->{Translation}->{'The planned start time is invalid!'} = 'O horário de início planejado é inválido!';
    $Self->{Translation}->{'The planned time is invalid!'} = 'O horário planejado é inválido!';
    $Self->{Translation}->{'The requested time is invalid!'} = 'O tempo especificado é inválido!';
    $Self->{Translation}->{'New (from template)'} = 'Nova (utilizando modelo)';
    $Self->{Translation}->{'Add from template'} = 'Adicionar utilizando modelo';
    $Self->{Translation}->{'Add Workorder (from template)'} = 'Adicionar ordem (com modelo)';
    $Self->{Translation}->{'Add a workorder (from template) to the change'} = 'Adicionar uma ordem (com modelo) à mudança';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReached'} = 'Ordem de Serviço (ID=%s) atingiu o tempo real de fim.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'} =
        'Ordem de Serviço (ID=%s) atingiu o tempo real de fim.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReached'} = 'Ordem de Serviço (ID=%s) atingiu o tempo real de início.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'} =
        'Ordem de Serviço (ID=%s) atingiu o tempo real de início.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAdd'} = 'Nova Ordem de Serviço (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'} = 'Nova Ordem de Serviço (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAdd'} = 'Novo anexo à ordem %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'} = '(ID=%s) Novo anexo à ordem: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Anexo deletado da ordem: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) anexo deletado da ordem: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAdd'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID'} =
        '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDelete'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID'} =
        '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDelete'} = 'Ordem (ID=%s) deletada';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'} = 'Ordem (ID=%s) deletada';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAdd'} = 'Associação a %s (ID=%s) adicionada';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'} = '(ID=%s) Associação a %s (ID=%s) adicionada';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'Associação a %s (ID=%s) deletada';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'} = '(ID=%s) Associação a %s (ID=%s) deletada';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'Notificação enviada para %s (Evento: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '(ID=%s) Notificação enviada para %s (Evento: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'} = 'Ordem de Serviço (ID=%s) atingiu o tempo final previsto.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'} =
        'Ordem de Serviço (ID=%s) atingiu o tempo final previsto.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'} = 'Ordem de Serviço (ID=%s) atingiu o tempo de início previsto.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} =
        'Ordem de Serviço (ID=%s) atingiu o tempo de início previsto.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdate'} = '%s: Nova: %s -> Antiga: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'} = '(ID=%s) %s: Nova: %s -> Antiga: %s';
    $Self->{Translation}->{'WorkOrderNumber'} = 'Número da Ordem de Serviço';
    $Self->{Translation}->{'accepted'} = 'Aceita';
    $Self->{Translation}->{'any'} = 'qualquer';
    $Self->{Translation}->{'approval'} = 'Aprovação';
    $Self->{Translation}->{'approved'} = 'Aprovada';
    $Self->{Translation}->{'backout'} = 'Plano de Retorno';
    $Self->{Translation}->{'begins with'} = 'inicia com';
    $Self->{Translation}->{'canceled'} = 'Cancelada';
    $Self->{Translation}->{'contains'} = 'contém';
    $Self->{Translation}->{'created'} = 'Criada';
    $Self->{Translation}->{'decision'} = 'Decisão';
    $Self->{Translation}->{'ends with'} = 'termina com';
    $Self->{Translation}->{'failed'} = 'Falha';
    $Self->{Translation}->{'in progress'} = 'Em Andamento';
    $Self->{Translation}->{'is'} = 'é';
    $Self->{Translation}->{'is after'} = 'é depois';
    $Self->{Translation}->{'is before'} = 'é antes';
    $Self->{Translation}->{'is empty'} = 'é vazio';
    $Self->{Translation}->{'is greater than'} = 'é maior que';
    $Self->{Translation}->{'is less than'} = 'é menor que';
    $Self->{Translation}->{'is not'} = 'não é';
    $Self->{Translation}->{'is not empty'} = 'não está vazio';
    $Self->{Translation}->{'not contains'} = 'não contém';
    $Self->{Translation}->{'pending approval'} = 'Aprovação Pendente';
    $Self->{Translation}->{'pending pir'} = 'RPI Pendente';
    $Self->{Translation}->{'pir'} = 'RPI (Revisão Pós-Implementação)';
    $Self->{Translation}->{'ready'} = 'Pronta';
    $Self->{Translation}->{'rejected'} = 'Rejeitada';
    $Self->{Translation}->{'requested'} = 'Requerida';
    $Self->{Translation}->{'retracted'} = 'Retratada';
    $Self->{Translation}->{'set'} = 'configurar';
    $Self->{Translation}->{'successful'} = 'Sucesso';

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category <-> Impact <-> Priority'} = 'Categoria <-> Impacto <-> Prioridade';
    $Self->{Translation}->{'Manage the priority result of combinating Category <-> Impact.'} =
        'Gestão de prioridade a partir da combinação da categoria <-> Impacto.';
    $Self->{Translation}->{'Priority allocation'} = 'Atribuir prioridade';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'Gerenciamento de Notificações de Gerência de Mudança ITSM';
    $Self->{Translation}->{'Add Notification Rule'} = 'Adicionar Regra de Notificação';
    $Self->{Translation}->{'Attribute'} = 'Atributo';
    $Self->{Translation}->{'Rule'} = 'Regra';
    $Self->{Translation}->{'Recipients'} = 'Destinatários';
    $Self->{Translation}->{'A notification should have a name!'} = 'A notificação precisa de um nome!';
    $Self->{Translation}->{'Name is required.'} = 'Nome é obrigatório.';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'Gerenciar Máquina de Estado';
    $Self->{Translation}->{'Select a catalog class!'} = 'Selecione uma classe de catálogo!';
    $Self->{Translation}->{'A catalog class is required!'} = 'Uma classe de catálogo é necessária!';
    $Self->{Translation}->{'Add a state transition'} = 'Adicionar uma transição de estado';
    $Self->{Translation}->{'Catalog Class'} = 'Classe de Catálogo';
    $Self->{Translation}->{'Object Name'} = 'Nome do Objeto';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Revisão de uma transição de estado para';
    $Self->{Translation}->{'Delete this state transition'} = 'Excluir esta transição de estado';
    $Self->{Translation}->{'Add a new state transition for'} = 'Adicionar uma nova transição de estado para';
    $Self->{Translation}->{'Please select a state!'} = 'Por favor selecione um estado!';
    $Self->{Translation}->{'Please select a next state!'} = 'Por favor, escolha o próximo estado!';
    $Self->{Translation}->{'Edit a state transition for'} = 'Editar uma transição de estado para';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Você quer mesmo excluir esta transição de estado?';
    $Self->{Translation}->{'from'} = 'de';

    # Template: AgentITSMCABMemberSearch

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'Adicionar Mudança';
    $Self->{Translation}->{'ITSM Change'} = 'Mudança';
    $Self->{Translation}->{'Justification'} = 'Justificativa';
    $Self->{Translation}->{'Input invalid.'} = 'Entrada inválida.';
    $Self->{Translation}->{'Impact'} = 'Impacto';
    $Self->{Translation}->{'Requested Date'} = 'Data Solicitada';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'Selecione modelo de mudança';
    $Self->{Translation}->{'Time type'} = 'Tipo de Horário';
    $Self->{Translation}->{'Invalid time type.'} = 'Tipo de horário inválido.';
    $Self->{Translation}->{'New time'} = 'Novo horário';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'Salvar CCM da Mudança como modelo';
    $Self->{Translation}->{'go to involved persons screen'} = 'ir para a tela "Pessoas Envolvidas"';
    $Self->{Translation}->{'This field is required'} = 'Este campo é obrigatório';
    $Self->{Translation}->{'Invalid Name'} = 'Nome inválido';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Condições e Ações';
    $Self->{Translation}->{'Delete Condition'} = 'Excluir Condição';
    $Self->{Translation}->{'Add new condition'} = 'Adicionar nova condição';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = 'Um nome válido é necessário.';
    $Self->{Translation}->{'A a valid name is needed.'} = 'Um nome válido é necessário.';
    $Self->{Translation}->{'Matching'} = 'Combinação';
    $Self->{Translation}->{'Any expression (OR)'} = 'Qualquer expressão lógica (OU)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Todas as expressões lógicas (E)';
    $Self->{Translation}->{'Expressions'} = 'Expressões';
    $Self->{Translation}->{'Selector'} = 'Seletor';
    $Self->{Translation}->{'Operator'} = 'Operador';
    $Self->{Translation}->{'Delete Expression'} = 'Excluir Expressão';
    $Self->{Translation}->{'No Expressions found.'} = 'Nenhuma expressão lógica encontrada.';
    $Self->{Translation}->{'Add new expression'} = 'Adicionar nova expressão';
    $Self->{Translation}->{'Delete Action'} = 'Excluir Ação';
    $Self->{Translation}->{'No Actions found.'} = 'Nenhuma ação encontrada.';
    $Self->{Translation}->{'Add new action'} = 'Adicionar nova ação';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = 'Você quer realmente excluir esta mudança?';

    # Template: AgentITSMChangeEdit

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'Workorder'} = 'Ordem de Serviço';
    $Self->{Translation}->{'Show details'} = 'Mostrar detalhes';
    $Self->{Translation}->{'Show workorder'} = 'Mostrar Ordem de Serviço';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of'} = 'Informações detalhadas sobre o histórico  de';
    $Self->{Translation}->{'Modified'} = 'Modificado';
    $Self->{Translation}->{'Old Value'} = 'Antigo Valor';
    $Self->{Translation}->{'New Value'} = 'Novo valor';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Involved Persons'} = 'Pessoas Envolvidas';
    $Self->{Translation}->{'ChangeManager'} = 'Gerente da Mudança';
    $Self->{Translation}->{'User invalid.'} = 'Usuário inválido';
    $Self->{Translation}->{'ChangeBuilder'} = 'Construtor da Mudança';
    $Self->{Translation}->{'Change Advisory Board'} = 'Conselho Consultivo de Mudança';
    $Self->{Translation}->{'CAB Template'} = 'Modelo de CCM';
    $Self->{Translation}->{'Apply Template'} = 'Aplicar Modelo';
    $Self->{Translation}->{'NewTemplate'} = 'Novo modelo';
    $Self->{Translation}->{'Save this CAB as template'} = 'Salvar este CCM como modelo';
    $Self->{Translation}->{'Add to CAB'} = 'Adicionar ao CCM';
    $Self->{Translation}->{'Invalid User'} = 'Usuário inválido';
    $Self->{Translation}->{'Current CAB'} = 'CCM Atual';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Configurações de Contexto';
    $Self->{Translation}->{'Changes per page'} = 'Mudanças por página';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'WorkOrderTitle'} = 'Título da Ordem de Serviço';
    $Self->{Translation}->{'ChangeTitle'} = 'Título da Mudança';
    $Self->{Translation}->{'WorkOrderAgent'} = 'Atendente da Ordem de Serviço';
    $Self->{Translation}->{'Workorders'} = 'Ordem de Serviço';
    $Self->{Translation}->{'ChangeState'} = 'Estado da Mudança';
    $Self->{Translation}->{'WorkOrderState'} = 'Estado da Ordem de Serviço';
    $Self->{Translation}->{'WorkOrderType'} = 'Tipo da Ordem de Serviço';
    $Self->{Translation}->{'Requested Time'} = 'Horário solicitado';
    $Self->{Translation}->{'PlannedStartTime'} = 'Início Planejado';
    $Self->{Translation}->{'PlannedEndTime'} = 'Término Planejado';
    $Self->{Translation}->{'ActualStartTime'} = 'Início Real';
    $Self->{Translation}->{'ActualEndTime'} = 'Término Real';

    # Template: AgentITSMChangePrint
    $Self->{Translation}->{'ITSM Workorder'} = 'Ordem de Serviço ITSM';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = 'Você quer realmente redefinir esta mudança?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(ex. 10*5155 ou 105658*)';
    $Self->{Translation}->{'CABAgent'} = 'Atendente CCM';
    $Self->{Translation}->{'e.g.'} = 'ex.';
    $Self->{Translation}->{'CABCustomer'} = 'Cliente CCM';
    $Self->{Translation}->{'Instruction'} = 'Instrução';
    $Self->{Translation}->{'Report'} = 'Relatório';
    $Self->{Translation}->{'Change Category'} = 'Categoria da Mudança';
    $Self->{Translation}->{'(before/after)'} = '(antes/depois)';
    $Self->{Translation}->{'(between)'} = '(entre)';
    $Self->{Translation}->{'Run Search'} = 'Executar Pesquisa';

    # Template: AgentITSMChangeSearchResultPrint
    $Self->{Translation}->{'WorkOrders'} = 'Ordens de Serviço';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Salvar Alteração como Modelo';
    $Self->{Translation}->{'A template should have a name!'} = 'Um modelo precisa de um nome!';
    $Self->{Translation}->{'The template name is required.'} = 'O nome do modelo é necessário.';
    $Self->{Translation}->{'Reset States'} = 'Restabelecer Estados';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Deslocar Horários';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'Informação da Mudança';
    $Self->{Translation}->{'PlannedEffort'} = 'Esforço Planejado';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Iniciador(es) da Mudança';
    $Self->{Translation}->{'Change Manager'} = 'Gerente da Mudança';
    $Self->{Translation}->{'Change Builder'} = 'Construtor da Mudança';
    $Self->{Translation}->{'CAB'} = 'CCM';
    $Self->{Translation}->{'Last changed'} = 'Última alteração';
    $Self->{Translation}->{'Last changed by'} = 'Última alteração por';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Download Attachment'} = 'Baixar Anexo';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = 'Você quer realmente excluir este modelo?';

    # Template: AgentITSMTemplateEdit

    # Template: AgentITSMTemplateOverviewNavBar

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = 'Template-ID';
    $Self->{Translation}->{'CreateBy'} = 'Criado por';
    $Self->{Translation}->{'CreateTime'} = 'Criado em';
    $Self->{Translation}->{'ChangeBy'} = 'Alterado por';
    $Self->{Translation}->{'ChangeTime'} = 'Alterado em';
    $Self->{Translation}->{'Delete: '} = 'Excluir: ';
    $Self->{Translation}->{'Delete Template'} = 'Excluir modelo';

    # Template: AgentITSMUserSearch

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = 'Adicionar ordem de serviço a';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Tipo de ordem de serviço inválido';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'O horário de início planejado deve ser anterior ao horário de término planejado!';
    $Self->{Translation}->{'Invalid format.'} = 'Formato inválido.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Selecione modelo de ordem de serviço';

    # Template: AgentITSMWorkOrderAgent

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Você quer realmente excluir esta ordem de serviço?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Você não pode excluir esta ordem de serviço. Ela está sendo usada por pelo menos uma condição!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Esta ordem de serviço está sendo usada pela(s) condição(ões)';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = 'Mover as seguintes ordens de acordo';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        'Se o término planejado desta ordem de serviço for alterado, o horário planejado de início de todas as seguintes ordens também serão alterados';

    # Template: AgentITSMWorkOrderHistory

    # Template: AgentITSMWorkOrderHistoryZoom

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'O horário de início real deve ser antes do tempo final real !';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'O horário de início real deve ser definido, quando o tempo de término real é configurado!';
    $Self->{Translation}->{'Existing attachments'} = 'Anexos existentes';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Atendente atual';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Você quer realmente assumir esta ordem de serviço?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Salvar Ordem de Serviço como Modelo';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Informação da Ordem de Serviço';

    # Template: CustomerITSMChangeOverview

    # Template: ITSMChange

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        'Uma lista dos agentes que têm permissão para ter Ordens de Serviço.Chave é um nome de login.O conteúdo é 0 ou 1';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        'Uma lista de estados de Ordem de Serviço, em que a hora de início real de uma Ordem de Serviço será definido se ele estava vazio neste momento.';
    $Self->{Translation}->{'Admin of notification rules.'} = 'Gerenciar regras de notificação.';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = 'Gerenciar matriz CIP.';
    $Self->{Translation}->{'Admin of the state machine.'} = 'Gerenciar máquina de estado.';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        'Módulo de notificação da interface do Atendente para ver o número de conselhos consultivos de mudança.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        'Módulo de notificação da interface do Atendente para ver o número de mudanças gerenciado pelo usuário.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        'Módulo de notificação da interface do Atendente para ver o número de alterações.';
    $Self->{Translation}->{'Agent interface notification module to see the number of work orders.'} =
        'Módulo de notificação da interface do Atendente para ver o número de ordens de serviço.';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        '';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        '';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = 'Limite para a visão de mudanças "pequeno"';
    $Self->{Translation}->{'Change free text options shown in the change add of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        'Alterar opções de texto livre mostrando na mudança adicionar o agente de interface. Configurações possíveis: 0 = desativado, 1 = ativado, 2 = ativado e necessário.';
    $Self->{Translation}->{'Change free text options shown in the change edit of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        'Alterar opções de texto livre mostrando na mudança edição da interface do agente. Configurações possíveis: 0 = desativado, 1 = ativado, 2 = ativado e necessário.';
    $Self->{Translation}->{'Change free text options shown in the change search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        'Alterar opções de texto livre mostrando na mudança pesquisa do agente de interface. Configurações possíveis: 0 = desativado, 1 = Ativado.';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small"'} = 'Limite para a página visão de mudanças "pequeno"';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = 'Alterar busca apoiadas do roteador do agente de interface';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        'Configura a freqüência com que as notificações são enviadas quando o tempo previsto de início ou outros valores de tempo ter sido atingido/passou.';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        'Tipo padrão de Ordem de Serviço.Esta entrada deve existir na classe catálogo geral \'ITSM::Gestão da Mudança::Ordem de Serviço::Tipo\'.';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = 'Definição dos avisos para cada estado de Ordem de Serviço.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        'Define uma visão global do módulo para mostrar uma pequena visão da lista de mudanças.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        'Define uma visão global do módulo para mostrar uma pequena vistão da lista de modelos.';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = 'Define se será possível imprimir o tempo contabilizado.';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = 'Define se será possível imprimir o esforço planejado.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = 'Define se o tempo contabilizado deve ser mostrado.';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = 'Define se o real início e de término deve ser definido.';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        '';
    $Self->{Translation}->{'Defines if the change state can be set in AgentITSMChangeEdit.'} =
        'Define se o estado de mudança pode ser definida em AtendenteITSMEditarMudança.';
    $Self->{Translation}->{'Defines if the planned effort should be shown.'} = 'Define se o esforço planejado deve ser mostrado.';
    $Self->{Translation}->{'Defines if the requested date should be print by customer.'} = 'Define se a data solicitada deverá ser impressa por cliente';
    $Self->{Translation}->{'Defines if the requested date should be searched by customer.'} =
        'Define se a data solicitada deverá ser pesquisado pelo cliente..';
    $Self->{Translation}->{'Defines if the requested date should be set by customer.'} = 'Define se a data solicitada deverá ser definido pelo cliente.';
    $Self->{Translation}->{'Defines if the requested date should be shown by customer.'} = 'Define se a data solicitada deve ser indicada pelo cliente.';
    $Self->{Translation}->{'Defines if the workorder state should be shown.'} = 'Define se o estado da Ordem de Serviço deve ser mostrado.';
    $Self->{Translation}->{'Defines if the workorder title should be shown.'} = 'Define se o título da Ordem de Serviço deve ser mostrado.';
    $Self->{Translation}->{'Defines shown graph attributes.'} = 'Define mostrado atributos gráfico.';
    $Self->{Translation}->{'Defines that only changes containing Workorders linked with services, which the customer user has permission to use will be shown. Any other changes will not be displayed.'} =
        'Define que somente mudanças contendo Ordens de Serviço relacionadas com os serviços, que o usuário cliente tem permissão para utilizar será mostrado. Quaisquer outras alterações não serão exibidas.';
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change PSA overview.'} =
        'Define os estados de mudança que será utilizado como filtros na visão global de Mudança PSA.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change Schedule overview.'} =
        'Define os estados de mudança que será utilizada como filtros na mudança visão global de agendamento.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyCAB overview.'} =
        'Define os estados de mudança que será utilizada como filtros na minha visão global CCM.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyChanges overview.'} =
        'Define os estados de mudança que será utilizada como filtros na minha visão global de mudança.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change manager overview.'} =
        'Define os estados de mudança que será utilizada como filtros na visão global do gerente de mudança.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change overview.'} =
        'Define os estados mudança que será utilizada como filtros na visão global de mudança.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the customer change schedule overview.'} =
        'Define os estados de mudança que será utilizada como filtros na visão global do cliente agendar a mudança.';
    $Self->{Translation}->{'Defines the default selection of the free key field number 1 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 1 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 1 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 1 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 10 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 10 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 10 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 10 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 11 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 11 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 11 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 11 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 12 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 12 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 12 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 12 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 13 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 13 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 13 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 13 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 14 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 14 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 14 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 14 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 15 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 15 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 15 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 15 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 16 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 16 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 16 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 16 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 17 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 17 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 17 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 17 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 18 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 18 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 18 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 18 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 19 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 19 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 19 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 19 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 2 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 2 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 2 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 2 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 20 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 20 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 20 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 20 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 21 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 21 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 21 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 21 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 22 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 22 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 22 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 22 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 23 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 23 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 23 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 23 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 24 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 24 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 24 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 24 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 25 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 25 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 25 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 25 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 26 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 26 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 26 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 26 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 27 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 27 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 27 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 27 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 28 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 28 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 28 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 28 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 29 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 29 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 29 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 29 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 3 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 3 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 3 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 3 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 30 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 30 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 30 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 30 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 31 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 31 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 31 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 31 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 32 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 32 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 32 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 32 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 33 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 33 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 33 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 33 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 34 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 34 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 34 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 34 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 35 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 35 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 35 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 35 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 36 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 36 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 36 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 36 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 37 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 37 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 37 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 37 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 38 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 38 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 38 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 38 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 39 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 39 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 39 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 39 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 4 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 4 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 4 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 4 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 40 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 40 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 40 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 40 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 41 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 41 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 41 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 41 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 42 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 42 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 42 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 42 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 43 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 43 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 43 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 43 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 44 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 44 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 44 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 44 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 45 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 45 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 45 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 45 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 46 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 46 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 46 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 46 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 47 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 47 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 47 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 47 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 48 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 48 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 48 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 48 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 49 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 49 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 49 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 49 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 5 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 5 para mudanças (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 5 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 5 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 50 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 50 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 50 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 50 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 6 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 6 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 6 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 6 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 7 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 7 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 7 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 7 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 8 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 8 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 8 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 8 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 9 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 9 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 9 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 9 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 1 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 1 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 1 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 1 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 10 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 10 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 10 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 10 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 11 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 11 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 11 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 11 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 12 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 12 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 12 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 12 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 13 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 13 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 13 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 13 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 14 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 14 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 14 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 14 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 15 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 15 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 15 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 15 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 16 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 16 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 16 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 16 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 17 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 17 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 17 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 17 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 18 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 18 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 18 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 18 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 19 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 19 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 19 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 19 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 2 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 2 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 2 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 2 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 20 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 20 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 20 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 20 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 21 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 21 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 21 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 21 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 22 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 22 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 22 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 22 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 23 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 23 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 23 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 23 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 24 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 24 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 24 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 24 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 25 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 25 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 25 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 25 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 26 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 26 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 26 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 26 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 27 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 27 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 27 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 27 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 28 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 28 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 28 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 28 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 29 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 29 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 29 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 29 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 3 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 3 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 3 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 3 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 30 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 30 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 30 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 30 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 31 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 31 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 31 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 31 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 32 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 32 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 32 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 32 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 33 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 33 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 33 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 33 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 34 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 34 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 34 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 34 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 35 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 35 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 35 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 35 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 36 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 36 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 36 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 36 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 37 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 37 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 37 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 37 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 38 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 38 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 38 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 38 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 39 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 39 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 39 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 39 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 4 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 4 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 4 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 4 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 40 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 40 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 40 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 40 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 41 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 41 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 41 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 41 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 42 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 42 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 42 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 42 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 43 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 43 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 43 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 43 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 44 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 44 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 44 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 44 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 45 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 45 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 45 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 45 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 46 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 46 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 46 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 46 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 47 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 47 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 47 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 47 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 48 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 48 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 48 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 48 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 49 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 49 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 49 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 49 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 5 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 5 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 5 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 5 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 50 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 50 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 50 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 50 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 6 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 6 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 6 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 6 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 7 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 7 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 7 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 7 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 8 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 8 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 8 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 8 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 9 for changes (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 9 para mudanças(se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 9 for workorders (if more than one option is provided).'} =
        'Define a seleção padrão o campo-chave livre número 9 para ordens de serviço (se houver mais de uma opção é fornecida).';
    $Self->{Translation}->{'Defines the default sort criteria in the change PSA overview.'} =
        'Define os critérios de classificação padrão na mudança de visão global da PSA.';
    $Self->{Translation}->{'Defines the default sort criteria in the change manager overview.'} =
        'Define os critérios de classificação padrão na visão global da gestão de mudanças.';
    $Self->{Translation}->{'Defines the default sort criteria in the change overview.'} = 'Define os critérios de classificação padrão na visão global de mudança.';
    $Self->{Translation}->{'Defines the default sort criteria in the change schedule overview.'} =
        'Define os critérios de classificação padrão na visão global de programar mudanças.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyCAB overview.'} =
        'Define os critérios de classificação padrão de mudanças na visão global Meu CCM.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyChanges overview.'} =
        'Define os critérios de classificação padrão de mudanças na visão global MinhaS MudançaS.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyWorkorders overview.'} =
        'Define os critérios de classificação padrão de mudanças na visão global Minha Ordem de Serviço.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the PIR overview.'} =
        'Define os critérios de classificação padrão de mudanças na visão global RPI.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the customer change schedule overview.'} =
        'Define os critérios de classificação padrão de mudanças na visão global Calendário de Mudanças.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the template overview.'} =
        'Define os critérios de classificação padrão de mudanças na visão global Modelos.';
    $Self->{Translation}->{'Defines the default sort order in the MyCAB overview.'} = 'Define a ordem de classificação padrão na visão global de Meu CCM.';
    $Self->{Translation}->{'Defines the default sort order in the MyChanges overview.'} = 'Define a ordem de classificação padrão na visão global de Minha Mudança.';
    $Self->{Translation}->{'Defines the default sort order in the MyWorkorders overview.'} =
        'Define a ordem de classificação padrão na visão global de Minha Ordem de Serviço.';
    $Self->{Translation}->{'Defines the default sort order in the PIR overview.'} = 'Define a ordem de classificação padrão na visão global de RPI.';
    $Self->{Translation}->{'Defines the default sort order in the change PSA overview.'} = 'Define a ordem de classificação padrão na visão global de Mudança PSA.';
    $Self->{Translation}->{'Defines the default sort order in the change manager overview.'} =
        'Define a ordem de classificação padrão na visão global da gestão de mudança.';
    $Self->{Translation}->{'Defines the default sort order in the change overview.'} = 'Define a ordem de classificação padrão na visão global de mudança.';
    $Self->{Translation}->{'Defines the default sort order in the change schedule overview.'} =
        'Define a ordem de classificação padrão na visão global de programar a mudança.';
    $Self->{Translation}->{'Defines the default sort order in the customer change schedule overview.'} =
        'Define a ordem de classificação padrão na visão global do cliente programar a mudança.';
    $Self->{Translation}->{'Defines the default sort order in the template overview.'} = 'Define a ordem de classificação padrão na visão global de modelo.';
    $Self->{Translation}->{'Defines the default value for the category of a change.'} = 'Define o valor padrão para a categoria de uma mudança.';
    $Self->{Translation}->{'Defines the default value for the impact of a change.'} = 'Define o valor padrão para o impacto de uma mudança.';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for change attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Define o tipo de campo para comparar os campos de valor para o atendente de mudança, atributos em ITSM Editar Condição de Mudança. Os valores válidos são de Seleção, texto e data. Se nenhum tipo é definido, o campo não é exibido.';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for workorder attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Define o tipo de campo para comparar os campos de valor para a Ordem de Serviço, atributos em ITSM Editar Condição de Mudança. Os valores válidos são de Seleção, texto e data. Se nenhum tipo é definido, o campo não é exibido.';
    $Self->{Translation}->{'Defines the free key field number 1 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 1 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 1 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 1 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 10 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 10 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 10 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 10 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 11 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 11 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 11 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 11 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 12 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 12 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 12 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 12 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 13 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 13 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 13 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 13 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 14 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 14 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 14 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 14 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 15 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 15 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 15 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 15 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 16 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 16 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 16 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 16 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 17 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 17 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 17 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 17 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 18 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 18 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 18 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 18 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 19 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 19 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 19 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 19 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 2 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 2 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 2 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 2 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 20 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 20 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 20 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 20 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 21 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 21 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 21 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 21 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 22 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 22 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 22 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 22 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 23 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 23 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 23 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 23 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 24 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 24 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 24 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 24 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 25 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 25 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 25 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 25 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 26 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 26 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 26 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 26 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 27 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 27 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 27 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 27 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 28 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 28 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 28 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 28 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 29 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 29 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 29 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 29 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 3 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 3 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 3 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 3 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 30 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 30 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 30 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 30 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 31 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 31 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 31 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 31 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 32 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 32 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 32 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 32 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 33 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 33 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 33 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 33 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 34 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 34 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 34 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 34 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 35 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 35 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 35 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 35 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 36 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 36 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 36 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 36 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 37 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 37 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 37 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 37 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 38 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 38 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 38 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 38 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 39 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 39 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 39 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 39 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 4 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 4 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 4 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 4 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 40 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 40 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 40 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 40 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 41 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 41 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 41 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 41 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 42 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 42 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 42 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 42 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 43 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 43 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 43 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 43 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 44 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 44 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 44 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 44 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 45 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 45 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 45 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 45 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 46 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 46 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 46 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 46 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 47 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 47 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 47 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 47 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 48 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 48 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 48 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 48 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 49 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 49 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 49 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 49 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 5 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 5 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 5 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 5 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 50 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 50 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 50 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 50 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 6 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 6 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 6 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 6 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 7 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 7 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 7 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 7 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 8 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 8 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 8 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 8 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free key field number 9 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 9 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free key field number 9 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 9 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 1 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 1 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 1 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 1 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 10 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 10 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 10 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 10 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 11 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 11 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 11 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 11 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 12 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 12 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 13 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 13 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 13 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 13 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 14 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 14 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 14 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 14 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 15 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 15 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 15 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 15 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 16 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 16 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 16 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 16 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 17 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 17 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 17 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 17 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 18 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 18 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 18 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 18 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 19 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 19 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 19 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 19 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 2 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 2 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 2 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 2 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 20 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 20 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 20 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 20 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 21 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 21 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 21 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 21 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 22 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 22 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 22 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 22 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 23 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 23 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 23 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 23 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 24 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 24 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 24 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 24 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 25 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 25 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 25 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 25 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 26 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 26 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 26 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 26 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 27 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 27 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 27 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 27 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 28 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 28 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 28 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 28 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 29 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 29 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 29 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 29 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 3 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 3 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 3 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 3 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 30 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 30 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 30 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 30 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 31 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 31 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 31 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 31 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 32 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 32 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 32 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 32 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 33 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 33 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 33 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 33 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 34 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 34 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 34 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 34 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 35 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 35 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 35 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 35 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 36 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 36 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 36 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 36 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 37 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 37 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 37 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 37 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 38 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 38 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 38 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 38 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 39 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 39 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 39 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 39 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 4 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 4 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 4 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 4 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 40 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 40 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 40 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 40 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 41 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 41 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 41 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 41 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 42 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 42 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 42 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 42 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 43 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 43 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 43 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 43 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 44 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 44 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 44 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 44 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 45 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 45 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 45 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 45 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 46 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 46 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 46 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 416de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 47 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 47 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 47 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 47 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 48 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 48 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 48 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 48 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 49 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 49 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 49 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 49 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 5 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 5 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 5 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 5 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 50 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 50 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 50 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 50 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 6 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 6 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 6 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 6 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 7 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 7 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 7 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 7 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 8 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 8 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 8 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 8 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the free text field number 9 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 9 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Defines the free text field number 9 for workorders to add a new workorder attribute.'} =
        'Define o campo-chave livre número 9 de ordens de serviço para adicionar um novo atributo de ordem de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 1 for changes.'} =
        'Define o link http do campo-chave livre número 1 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 1 for workorders.'} =
        'Define o link http do campo-chave livre número 1 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 10 for changes.'} =
        'Define o link http do campo-chave livre número 10 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 10 for workorders.'} =
        'Define o link http do campo-chave livre número 10 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 11 for changes.'} =
        'Define o link http do campo-chave livre número 11 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 11 for workorders.'} =
        'Define o link http do campo-chave livre número 11 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 12 for changes.'} =
        'Define o link http do campo-chave livre número 12 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 12 for workorders.'} =
        'Define o link http do campo-chave livre número 12 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 13 for changes.'} =
        'Define o link http do campo-chave livre número 13 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 13 for workorders.'} =
        'Define o link http do campo-chave livre número 13 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 14 for changes.'} =
        'Define o link http do campo-chave livre número 14 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 14 for workorders.'} =
        'Define o link http do campo-chave livre número 14 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 15 for changes.'} =
        'Define o link http do campo-chave livre número 15 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 15 for workorders.'} =
        'Define o link http do campo-chave livre número 15 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 16 for changes.'} =
        'Define o link http do campo-chave livre número 16 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 16 for workorders.'} =
        'Define o link http do campo-chave livre número 16 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 17 for changes.'} =
        'Define o link http do campo-chave livre número 17 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 17 for workorders.'} =
        'Define o link http do campo-chave livre número 17 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 18 for changes.'} =
        'Define o link http do campo-chave livre número 18 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 18 for workorders.'} =
        'Define o link http do campo-chave livre número 18 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 19 for changes.'} =
        'Define o link http do campo-chave livre número 19 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 19 for workorders.'} =
        'Define o link http do campo-chave livre número 19 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 2 for changes.'} =
        'Define o link http do campo-chave livre número 2 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 2 for workorders.'} =
        'Define o link http do campo-chave livre número 2 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 20 for changes.'} =
        'Define o link http do campo-chave livre número 20 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 20 for workorders.'} =
        'Define o link http do campo-chave livre número 20 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 21 for changes.'} =
        'Define o link http do campo-chave livre número 21 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 21 for workorders.'} =
        'Define o link http do campo-chave livre número 21 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 22 for changes.'} =
        'Define o link http do campo-chave livre número 22 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 22 for workorders.'} =
        'Define o link http do campo-chave livre número 22 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 23 for changes.'} =
        'Define o link http do campo-chave livre número 23 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 23 for workorders.'} =
        'Define o link http do campo-chave livre número 23 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 24 for changes.'} =
        'Define o link http do campo-chave livre número 24 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 24 for workorders.'} =
        'Define o link http do campo-chave livre número 24 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 25 for changes.'} =
        'Define o link http do campo-chave livre número 25 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 25 for workorders.'} =
        'Define o link http do campo-chave livre número 25 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 26 for changes.'} =
        'Define o link http do campo-chave livre número 26 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 26 for workorders.'} =
        'Define o link http do campo-chave livre número 26 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 27 for changes.'} =
        'Define o link http do campo-chave livre número 27 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 27 for workorders.'} =
        'Define o link http do campo-chave livre número 27 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 28 for changes.'} =
        'Define o link http do campo-chave livre número 28 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 28 for workorders.'} =
        'Define o link http do campo-chave livre número 28 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 29 for changes.'} =
        'Define o link http do campo-chave livre número 29 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 29 for workorders.'} =
        'Define o link http do campo-chave livre número 29 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 3 for changes.'} =
        'Define o link http do campo-chave livre número 3 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 3 for workorders.'} =
        'Define o link http do campo-chave livre número 3 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 30 for changes.'} =
        'Define o link http do campo-chave livre número 30 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 30 for workorders.'} =
        'Define o link http do campo-chave livre número 30 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 31 for changes.'} =
        'Define o link http do campo-chave livre número 31 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 31 for workorders.'} =
        'Define o link http do campo-chave livre número 31 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 32 for changes.'} =
        'Define o link http do campo-chave livre número 32 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 32 for workorders.'} =
        'Define o link http do campo-chave livre número 32 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 33 for changes.'} =
        'Define o link http do campo-chave livre número 33 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 33 for workorders.'} =
        'Define o link http do campo-chave livre número 33 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 34 for changes.'} =
        'Define o link http do campo-chave livre número 34 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 34 for workorders.'} =
        'Define o link http do campo-chave livre número 34 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 35 for changes.'} =
        'Define o link http do campo-chave livre número 35 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 35 for workorders.'} =
        'Define o link http do campo-chave livre número 35 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 36 for changes.'} =
        'Define o link http do campo-chave livre número 36 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 36 for workorders.'} =
        'Define o link http do campo-chave livre número 36 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 37 for changes.'} =
        'Define o link http do campo-chave livre número 37 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 37 for workorders.'} =
        'Define o link http do campo-chave livre número 37 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 38 for changes.'} =
        'Define o link http do campo-chave livre número 38 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 38 for workorders.'} =
        'Define o link http do campo-chave livre número 38 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 39 for changes.'} =
        'Define o link http do campo-chave livre número 39 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 39 for workorders.'} =
        'Define o link http do campo-chave livre número 39 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 4 for changes.'} =
        'Define o link http do campo-chave livre número 4 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 4 for workorders.'} =
        'Define o link http do campo-chave livre número 4 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 40 for changes.'} =
        'Define o link http do campo-chave livre número 40 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 40 for workorders.'} =
        'Define o link http do campo-chave livre número 40 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 41 for changes.'} =
        'Define o link http do campo-chave livre número 41 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 41 for workorders.'} =
        'Define o link http do campo-chave livre número 41 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 42 for changes.'} =
        'Define o link http do campo-chave livre número 42 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 42 for workorders.'} =
        'Define o link http do campo-chave livre número 42 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 43 for changes.'} =
        'Define o link http do campo-chave livre número 43 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 43 for workorders.'} =
        'Define o link http do campo-chave livre número 43 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 44 for changes.'} =
        'Define o link http do campo-chave livre número 44 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 44 for workorders.'} =
        'Define o link http do campo-chave livre número 44 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 45 for changes.'} =
        'Define o link http do campo-chave livre número 45 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 45 for workorders.'} =
        'Define o link http do campo-chave livre número 45 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 46 for changes.'} =
        'Define o link http do campo-chave livre número 46 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 46 for workorders.'} =
        'Define o link http do campo-chave livre número 46 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 47 for changes.'} =
        'Define o link http do campo-chave livre número 47 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 47 for workorders.'} =
        'Define o link http do campo-chave livre número 47 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 48 for changes.'} =
        'Define o link http do campo-chave livre número 48 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 48 for workorders.'} =
        'Define o link http do campo-chave livre número 48 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 49 for changes.'} =
        'Define o link http do campo-chave livre número 49 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 49 for workorders.'} =
        'Define o link http do campo-chave livre número 49 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 5 for changes.'} =
        'Define o link http do campo-chave livre número 5 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 5 for workorders.'} =
        'Define o link http do campo-chave livre número 5 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 50 for changes.'} =
        'Define o link http do campo-chave livre número 50 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 50 for workorders.'} =
        'Define o link http do campo-chave livre número 50 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 6 for changes.'} =
        'Define o link http do campo-chave livre número 6 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 6 for workorders.'} =
        'Define o link http do campo-chave livre número 6 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 7 for changes.'} =
        'Define o link http do campo-chave livre número 7 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 7 for workorders.'} =
        'Define o link http do campo-chave livre número 7 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 8 for changes.'} =
        'Define o link http do campo-chave livre número 8 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 8 for workorders.'} =
        'Define o link http do campo-chave livre número 8 para ordens de serviço.';
    $Self->{Translation}->{'Defines the http link for the free text field number 9 for changes.'} =
        'Define o link http do campo-chave livre número 9 para mudanças.';
    $Self->{Translation}->{'Defines the http link for the free text field number 9 for workorders.'} =
        'Define o link http do campo-chave livre número 9 para ordens de serviço.';
    $Self->{Translation}->{'Defines the maximum number of change freetext fields.'} = 'Define o número máximo de campos texto livre para mudanças.';
    $Self->{Translation}->{'Defines the maximum number of workorder freetext fields.'} = 'Define o número máximo de campos texto livre para ordem de serviço.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for change objects in AgentITSMChangeConditionEdit.'} =
        'Define os atributos de objeto que são selecionáveis para objetos de mudança em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for workorder objects in AgentITSMChangeConditionEdit.'} =
        'Define os atributos de objeto que são selecionáveis para objetos de ordem de serviço em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute AccountedTime in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Tempo Contabilizados em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualEndTime in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Hora de término real em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualStartTime in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Hora de início real em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute CategoryID in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Categoria ID em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeBuilderID in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Alterar Construtor ID em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeFreeKey in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Alterar Chave Livre em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeFreeText in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Alterar Chave Texto em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeManagerID in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Alterar Gerente ID em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeStateID in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Alterar Estado ID em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeTitle in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Alterar Título ID em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ImpactID in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Impacto ID em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEffort in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Esforço Planejado em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEndTime in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Hora Final Planejada em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedStartTime in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Hora Ínicio Planejada em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PriorityID in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Prioridade ID em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute RequestedTime in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Tempo Requerido em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderAgentID in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Ordem de Serviço Atendente ID em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderFreeKey in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Ordem de Serviço Chave Livre em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderFreeText in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Ordem de Serviço Texto Livre em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderNumber in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Número Ordem de Serviço em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderStateID in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Estado ID Ordem de Serviço em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTitle in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Título Ordem de Serviço em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTypeID in AgentITSMChangeConditionEdit.'} =
        'Define os operadores que são selecionáveis para o atributo Tipo ID Ordem de Serviço em o Atentente Editar a Condição de Mudança do ITSM.';
    $Self->{Translation}->{'Defines the period (in years), in which start and end times can be selected.'} =
        'Define o período (em anos), em que os horários de início e fim podem ser selecionados.';
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the Change PSA overview. This option has no effect on the position of the column.'} =
        'Define as colunas mostrando na Mudança visão geral da PSA. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines the shown columns in the Change Schedule overview. This option has no effect on the position of the column.'} =
        'Define as colunas mostrando na Mudança visão geral da Agenda. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines the shown columns in the MyCAB overview. This option has no effect on the position of the column.'} =
        'Define as colunas mostrando a visão geral da Meu CCM. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines the shown columns in the MyChanges overview. This option has no effect on the position of the column.'} =
        'Define as colunas mostrando a visão geral das Minhas Mudanças. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines the shown columns in the MyWorkorders overview. This option has no effect on the position of the column.'} =
        'Define as colunas mostrando a visão geral das Minhas Ordens de Serviço. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines the shown columns in the PIR overview. This option has no effect on the position of the column.'} =
        'Define as colunas mostrando a visão geral da RPI. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines the shown columns in the change manager overview. This option has no effect on the position of the column.'} =
        'Define as colunas mostrando a visão geral do gerente de mudança. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines the shown columns in the change overview. This option has no effect on the position of the column.'} =
        'Define as colunas mostrando a visão geral da mudança. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines the shown columns in the change search. This option has no effect on the position of the column.'} =
        'Define as colunas mostrando a pesquisa da mudança. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines the shown columns in the customer change schedule overview. This option has no effect on the position of the column.'} =
        'Define as colunas mostrando a visão geral do cliente agendar a mudança. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines the shown columns in the template overview. This option has no effect on the position of the column.'} =
        'Define as colunas mostrando a visão geral do modelo. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines the signals for each ITSMChange state.'} = 'Define os sinais para cada estado Mudança ITSM.';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        'Define os tipos de modelo que será usado como filtros na visão global de modelo.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        'Define os estados de ordem de serviço que será usado como filtros na visão global das Minhas Ordens de Serviço.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        'Define os estados de ordem de serviço que será usado como filtros na visão global da RPI.';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        'Define os tipos de ordem de serviço que será usado como filtros para mostrar na visão global da RPI.';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = 'Define se as notificações devem ser enviadas.';
    $Self->{Translation}->{'Determines if an agent can exchange the X-axis of a stat if he generates one.'} =
        'Determina se um atendente pode trocar o eixo X de uma estatística se ele gere um.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes done for config item classes.'} =
        'Determina se o módulo de estatísticas comuns podem gerar estatísticas sobre as mudanças feitas para as classes de item de configuração.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding change state updates within a timeperiod.'} =
        'Determina se o módulo de estatísticas comuns podem gerar estatísticas sobre as mudanças referentes às atualizações mudança de estado dentro de um período de tempo.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding the relation between changes and incident tickets.'} =
        'Determina se o módulo de estatísticas comuns podem gerar estatísticas sobre as mudanças a respeito da relação entre as mudanças e os chamados de incidente.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes.'} =
        'Determina se o módulo de estatísticas comuns podem gerar estatísticas sobre as mudanças.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about the number of Rfc tickets a requester created.'} =
        'Determina se o módulo de estatísticas comuns podem gerar estatísticas sobre o número de chamados RFC a um solicitante criado.';
    $Self->{Translation}->{'Event list to be displayed on GUI to trigger generic interface invokers.'} =
        '';
    $Self->{Translation}->{'ITSM event module deletes the history of changes.'} = 'Módulo de evento ITSM apaga o histórico de mudanças.';
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = 'Módulo de evento ITSM que limpa condições.';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = '';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        'Módulo de evento ITSM que coincide com as condições e executa as ações.';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = 'Módulo de eventos ITSM que envia notificações.';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = 'Módulo de evento ITSM que atualiza o histórico de mudanças.';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = 'Módulo de evento ITSM para recalcular os números de ordem de serviço.';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        'Módulo de evento ITSM para definir o tempo início e de término de ordens de serviço.';
    $Self->{Translation}->{'ITSM event module updates the history of changes.'} = 'Módulo de evento ITSM atualiza o histórico de mudanças.';
    $Self->{Translation}->{'ITSM event module updates the history of conditions.'} = 'Módulo de evento ITSM atualiza o histórico de condições.';
    $Self->{Translation}->{'ITSM event module updates the history of workorders.'} = 'Módulo de evento ITSM atualiza o histórico de ordens de serviço.';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notications are sent (every X hours).'} =
        'Se a freqüência é \'regular \', você pode configurar quantas vezes as notificações são enviados (a cada X horas).';
    $Self->{Translation}->{'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.'} =
        '';
    $Self->{Translation}->{'Logfile for the ITSM change counter. This file is used for creating the change numbers.'} =
        'Arquivo de log para o contador de mudança ITSM. Este arquivo é usado para criar os números de mudança.';
    $Self->{Translation}->{'Module to check the CAB members.'} = 'Módulo para verificar os membros do CCM.';
    $Self->{Translation}->{'Module to check the agent.'} = 'Módulo para verificar o atendente.';
    $Self->{Translation}->{'Module to check the change builder.'} = 'Módulo para verificar o construtor da mudança.';
    $Self->{Translation}->{'Module to check the change manager.'} = 'Módulo para verificar o gerente de mudança.';
    $Self->{Translation}->{'Module to check the workorder agent.'} = 'Módulo para verificar o atendente da ordem de serviço.';
    $Self->{Translation}->{'Module to check whether no workorder agent is set.'} = 'Módulo para verificar se não existe atendente de ordem de serviço definido.';
    $Self->{Translation}->{'Module to check whether the agent is contained in the configured list.'} =
        'Módulo para verificar se o atendente está contido na lista configurada.';
    $Self->{Translation}->{'Module to show a link to create a change from this ticket. The ticket will be automatically linked with the new change.'} =
        'Módulo para mostrar um link para criar uma mudança a partir deste chamado. O chamado será automaticamente ligado com a nova mudança.';
    $Self->{Translation}->{'Notification (ITSM Change Management)'} = 'Notificação (Gerenciamento de Mudança ITSM)';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        'Somente usuários desses grupos têm permissão para usar os tipos de chamados, tal como definido em "MudançaITSM:TiposChamadosAdicionarLinkMudança" se o recurso "Chamado::ACL:: Módulo###200-Chamado::ACL::Módulo" é habilitado..';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        'Parâmetros para as páginas (em que as mudanças são mostradas) da pequena visão global de mudança.';
    $Self->{Translation}->{'Presents a link in the menu to show the involved persons in a change, in the zoom view of such change in the agent interface.'} =
        'Apresenta um link no menu para mostrar as pessoas envolvidas em uma mudança, em vista a ampliar essa mudança na interface do atendente.';
    $Self->{Translation}->{'Required privileges in order for an agent to take a workorder.'} =
        'Privilégios necessários a fim de um agente ter uma ordem de serviço.';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = 'Privilégios necessários para acessar a visão global de todas as alterações.';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = 'Privilégios necessários para adicionar uma ordem de serviço.';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = 'Privilégios necessários para alterar o atendente de ordem de serviço.';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = 'Privilégios necessários para criar um modelo de uma alteração.';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        'Privilégios necessários para criar um modelo de uma mudança\' CCM.';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = 'Privilégios necessários para criar um modelo de uma ordem de serviço.';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = '';
    $Self->{Translation}->{'Required privileges to create changes.'} = 'Privilégios necessários para criar mudanças.';
    $Self->{Translation}->{'Required privileges to delete a template.'} = 'Privilégios necessários para criar um modelo.';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = 'Privilégios necessários para criar uma ordem de serviço.';
    $Self->{Translation}->{'Required privileges to delete changes.'} = 'Privilégios necessários para excluir mudanças.';
    $Self->{Translation}->{'Required privileges to edit a template.'} = 'Privilégios necessários para editar um modelo.';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = 'Privilégios necessários para editar uma ordem de serviço.';
    $Self->{Translation}->{'Required privileges to edit changes.'} = 'Privilégios necessários para editar uma mudança.';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = 'Privilégios necessários para editar uma condição de mudança.';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        'Privilégios necessários para editar pessoas envolvidas na mudança.';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = 'Privilégios necessários para mover as mudanças no tempo.';
    $Self->{Translation}->{'Required privileges to print a change.'} = 'Privilégios necessários para imprimir uma mudança.';
    $Self->{Translation}->{'Required privileges to reset changes.'} = 'Privilégios necessários para redefinir mudanças.';
    $Self->{Translation}->{'Required privileges to view a workorder.'} = 'Privilégios necessários para visualizar uma ordem de serviço.';
    $Self->{Translation}->{'Required privileges to view changes.'} = 'Privilégios necessários para visualizar mudanças.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is a CAB member.'} =
        'Privilégios necessários para visualizar a lista de mudanças, onde o usuário é membro do CCM.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is the change manager.'} =
        'Privilégios necessários para visualizar a lista de mudanças, onde o usuário é o gerente da mudança.';
    $Self->{Translation}->{'Required privileges to view overview over all templates.'} = 'Privilégios necessários para visualizar a visão global sobre todos os modelos.';
    $Self->{Translation}->{'Required privileges to view the conditions of changes.'} = 'Privilégios necessários para visualizar as condições de mudanças.';
    $Self->{Translation}->{'Required privileges to view the history of a change.'} = 'Privilégios necessários para visualizar o histórico de uma mudança.';
    $Self->{Translation}->{'Required privileges to view the history of a workorder.'} = 'Privilégios necessários para visualizar o histórico de uma ordem de serviço.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a change.'} = 'Privilégios necessários para visualizar o histórico ampliado de uma mudança.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a workorder.'} =
        'Privilégios necessários para visualizar o histórico ampliado de uma ordem de serviço.';
    $Self->{Translation}->{'Required privileges to view the list of Change Schedule.'} = 'Privilégios necessários para visualizar a lista da Agenda Mudança.';
    $Self->{Translation}->{'Required privileges to view the list of change PSA.'} = 'Privilégios necessários para visualizar o lista de mudanças PSA.';
    $Self->{Translation}->{'Required privileges to view the list of changes with an upcoming PIR (Post Implementation Review).'} =
        'Privilégios necessários para visualizar a lista de mudanças com um próximo RPI (Postar Revisão da Implementação).';
    $Self->{Translation}->{'Required privileges to view the list of own changes.'} = 'Privilégios necessários para visualizar a lista de mudanças próprias.';
    $Self->{Translation}->{'Required privileges to view the list of own workorders.'} = 'Privilégios necessários para visualizar a lista de ordem de serviço própria.';
    $Self->{Translation}->{'Required privileges to write a report for the workorder.'} = 'Privilégios necessários para escrever um relatório para a ordem de serviço.';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        '';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        '';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = 'Configura a máquina do estado para as mudanças.';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = 'Configura a máquina do estado para as ordens de serviço.';
    $Self->{Translation}->{'Shows a checkbox in the AgentITSMWorkOrderEdit screen that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the work order agent, in the zoom view of such work order of the agent interface.'} =
        'Mostra um link no menu que permite alterar a ordem de serviço do atendente, no ampliar visualização da ordem de serviço como do atendente de interface.';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        'Mostra um link no menu que permite definir uma mudança como um modelo no ampliar visualização de mudança, na interface do atendente.';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a work order as a template in the zoom view of the work order, in the agent interface.'} =
        'Mostra um link no menu que permite definir uma ordem de serviço como um modelo no ampliar visualização da ordem de serviço, na interface do agente.';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workd order, in the zoom view of such work order of the agent interface.'} =
        'Mostra um link no menu que permite a edição do relatório de uma ordem de serviço, no ampliar visualização de ordem de serviço, tais como atendente de interface.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        'Mostra um link no menu que permite ligar uma mudança com outro objeto na mudança ampliar visualização do atendente de interface.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a work order with another object in the zoom view of such work order of the agent interface.'} =
        'Mostra um link no menu que permite a ligação de uma ordem de serviço com outro objeto no modo de ampliar exibição de ordem de serviço agente de interface.';
    $Self->{Translation}->{'Shows a link in the menu that allows moving the time slot of a change in its zoom view of the agent interface.'} =
        'Mostra um link no menu que permite mover o intervalo de tempo de uma mudança em sua opinião, ampliar visualização da interface do atendente.';
    $Self->{Translation}->{'Shows a link in the menu that allows taking a work order in the its zoom view of the agent interface.'} =
        'Mostra um link no menu que permite a captura de uma ordem de serviço ampliar sua visualização do atendente de interface.';
    $Self->{Translation}->{'Shows a link in the menu to access the conditions of a change in the its zoom view of the agent interface.'} =
        'Mostra um link no menu para acessar as condições de uma mudança ampliar sua visualização do atendente de interface.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a change in the its zoom view of the agent interface.'} =
        'Mostra um link no menu para acessar o histórico de uma mudança ampliar sua visualização do atendente de interface.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a work order in the its zoom view of the agent interface.'} =
        'Mostra um link no menu para acessar o histórico de uma ordem de serviço ampliar sua visualização  do atendente de interface.';
    $Self->{Translation}->{'Shows a link in the menu to add a work order in the change zoom view of the agent interface.'} =
        'Mostra um link no menu para adicionar uma ordem de serviço na mudança ampliar sua visualização do atendente de interface.';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to delete a work order in its zoom view of the agent interface.'} =
        'Mostra um link no menu para apagar uma ordem de serviço ampliar sua visualização do atendente de interface.';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        'Mostra um link no menu para editar uma mudança ampliar sua visualização do atendente de interface.';
    $Self->{Translation}->{'Shows a link in the menu to edit a work order in the its zoom view of the agent interface.'} =
        'Mostra um link no menu para editar uma ordem de serviço ampliar sua visualização do atendente de interface.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        'Mostra um link no menu para voltar a mudança e ampliar sua visualização do atendente de interface.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the work order zoom view of the agent interface.'} =
        'Mostra um link no menu para voltar a ordem de serviço e ampliar sua visualização do atendente de interface.';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        'Mostra um link no menu para imprimir uma mudança e ampliar sua visualização do atendente de interface.';
    $Self->{Translation}->{'Shows a link in the menu to print a work order in the its zoom view of the agent interface.'} =
        'Mostra um link no menu para imprimir uma ordem de serviço e ampliar sua visualização do atendente de interface.';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        'Mostra o histórico de alterações (ordenados reverso) na interface do atendente.';
    $Self->{Translation}->{'State Machine'} = 'Máquina de Estado';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        'O identificador de uma Mudança, por exemplo, Mudança#,Minha mudança#. O padrão é Mudança#.';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        'O identificador de uma Ordem de Serviço, por exemplo, Ordem de Serviço#,Minha Ordem de Serviço#. O padrão é a Ordem de Serviço#.';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        '';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        'Tipos de chamados, onde no chamado amplia sua visualização de um link para adicionar uma mudança será exibida.';
    $Self->{Translation}->{'Workorder free text options shown in the change search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        'Ordem de Serviço a fim de opções de texto livre mostrado na busca de mudanças na interface do atendente. Configurações possíveis: 0 = desativado, 1 = Ativado.';
    $Self->{Translation}->{'Workorder free text options shown in the workorder add of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        'Ordem de Serviço a fim de opções de texto livre mostrado na ordem de serviço de adicionar o atendente de interface. Configurações possíveis: 0 = desativado, 1 = ativado, 2 = Habilitado e necessária.';
    $Self->{Translation}->{'Workorder free text options shown in the workorder edit of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        'Ordem de Serviço a fim de opções de texto livre mostrado na ordem de serviço de edição da interface do atendente. Configurações possíveis: 0 = desativado, 1 = ativado, 2 = Habilitado e necessária.';
    $Self->{Translation}->{'Workorder free text options shown in the workorder report of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        'Ordem de Serviço a fim de opções de texto livre indicado no relatório de ordem de serviço do agente de interface. Configurações possíveis: 0 = desativado, 1 = ativado, 2 = Habilitado e necessária.';
    $Self->{Translation}->{'Screen after creating a workorder'}
        = 'Tela Após Criar Ordem de Serviço';
    $Self->{Translation}->{'Show this screen after I created a new workorder'}
        = 'Mostra esta tela após a criação de uma nova ordem';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Adapts the width of the autocomplete drop down to the length of the longest option.'} =
        'Adaptar-se a largura do auto-complete suspenso para o comprimento da maior opção.';
    $Self->{Translation}->{'Cache time in minutes for the change management.'} = 'Provisão de tempo em minutos para a gestão da mudança.';
    $Self->{Translation}->{'Defines the free text field number 12 for changes to add a new change attribute.'} =
        'Define o campo-chave livre número 12 de mudanças para adicionar um novo atributo de mudança.';
    $Self->{Translation}->{'Enables or disables TypeAhead for the autocomplete feature.'} = 'Ativa ou desativa o tipo de cabeçalho para o recurso de autocompletar.';
    $Self->{Translation}->{'Enables or disables the autocomplete feature for the CAB member search in the ITSM agent interface.'} =
        'Ativa ou desativa o recurso de autocompletar para a busca do membro CCM na interface do atendente ITSM';
    $Self->{Translation}->{'Enables or disables the autocomplete feature for the customer search in the ITSM agent interface.'} =
        'Ativa ou desativa o recurso de autocompletar para a busca do cliente na interface do atendente ITSM.';
    $Self->{Translation}->{'Enables or disables the autocomplete feature for the user search in the ITSM agent interface.'} =
        'Ativa ou desativa o recurso de autocompletar para a busca do usuário na interface do atendente ITSM.';
    $Self->{Translation}->{'Search Agent'} = 'Pesquisar atendente';
    $Self->{Translation}->{'Selects the change number generator module. With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        'Seleciona o módulo gerador de números da mudança. Com a "Data", os números de mudança serão gerados até a data atual e um contador, este formato é semelhante a do Ano.Mês.Dia.Contador, por exemplo, 2010062400001, 2010062400002. Com a "Soma de verificação da data", o contador será adicionado como soma de verificação para a seqüência de data mais a identificação do sistema. A verificação será rodado em uma base diária. Este formato é semelhante a do Ano.Mês.Dia.Sistema de identificação.Contador.Soma de verificação, por exemplo, 2010062410000017, 2010062410000026.';
    $Self->{Translation}->{'Sets the maximal number of search results for the autocomplete feature.'} =
        'Define o número máximo de resultados de pesquisa para o recurso de autocompletar.';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups".'} =
        'Este módulo ACL restringe o uso dos tipos de chamados que são definidos na opção sysconfig \'ITSM Mudança::AdicionarLinkAlterarTiposChamados\', para os usuários dos grupos, tal como definido em "Alterar ITSM::Restringir Tipos Chamados::Grupos".';

}

1;
