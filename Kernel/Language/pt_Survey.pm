# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pt_Survey;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Criar novo questionário';
    $Self->{Translation}->{'Introduction'} = 'Introdução';
    $Self->{Translation}->{'Survey Introduction'} = 'Introdução de questionário';
    $Self->{Translation}->{'Notification Body'} = 'Corpo da Notificação';
    $Self->{Translation}->{'Ticket Types'} = 'Tipos de ticket';
    $Self->{Translation}->{'Internal Description'} = 'Descrição interna';
    $Self->{Translation}->{'Customer conditions'} = 'Condições do cliente';
    $Self->{Translation}->{'Please choose a Customer property to add a condition.'} = 'Por favor, escolha uma propriedade do cliente para adicionar uma condição.';
    $Self->{Translation}->{'Public survey key'} = 'Chave pública do questionário';
    $Self->{Translation}->{'Example survey'} = 'Exemplo';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Editar Informações Gerais';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Editar Perguntas';
    $Self->{Translation}->{'You are here'} = 'Está aqui';
    $Self->{Translation}->{'Survey Questions'} = 'Perguntas do questionário';
    $Self->{Translation}->{'Add Question'} = 'Adicionar Questão';
    $Self->{Translation}->{'Type the question'} = 'Introduza a questão';
    $Self->{Translation}->{'Answer required'} = 'Resposta obrigatória';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Nenhuma pergunta definida para este questionário.';
    $Self->{Translation}->{'Question'} = 'Questão';
    $Self->{Translation}->{'Answer Required'} = 'Resposta Obrigatória';
    $Self->{Translation}->{'When you finish to edit the survey questions just close this screen.'} =
        'Quando terminar de editar as perguntas do questionário, apenas feche a janela.';
    $Self->{Translation}->{'Close this window'} = 'Fechar esta janela';
    $Self->{Translation}->{'Edit Question'} = 'Editar Questão';
    $Self->{Translation}->{'go back to questions'} = 'voltar às perguntas';
    $Self->{Translation}->{'Question:'} = 'Questão:';
    $Self->{Translation}->{'Possible Answers For'} = 'Possíveis Respostas Para';
    $Self->{Translation}->{'Add Answer'} = 'Adicionar resposta';
    $Self->{Translation}->{'No answers saved for this question.'} = 'Não há respostas definidas para esta pergunta';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Esta pergunta não possui várias respostas, uma área de texto será mostrada';
    $Self->{Translation}->{'Edit Answer'} = 'Editar resposta';
    $Self->{Translation}->{'go back to edit question'} = 'voltar para editar pergunta';
    $Self->{Translation}->{'Answer:'} = 'Resposta';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Survey overview options'} = 'Opções da visão geral';
    $Self->{Translation}->{'Searches in the attributes Number, Title, Introduction, Description, NotificationSender, NotificationSubject and NotificationBody, overriding other attributes with the same name.'} =
        'Procura nos atributos Número, Título, Introdução, Descrição, Enviador de Notificação, Assunto de Notificação e Corpo de Notificação, sobrescrevendo atributos com o mesmo nome.';
    $Self->{Translation}->{'Survey Create Time'} = 'Hora de criação do questionário';
    $Self->{Translation}->{'No restriction'} = 'Sem restrições';
    $Self->{Translation}->{'Only surveys created between'} = 'Apenas questionários criados entre';
    $Self->{Translation}->{'Max. shown surveys per page'} = 'Qtd. máx. de questionários exibidos por página';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Remetente da Notificação';
    $Self->{Translation}->{'Notification Subject'} = 'Assunto da Notificação';
    $Self->{Translation}->{'Changed By'} = 'Modificado por';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = 'Resumo de Estatísticas de';
    $Self->{Translation}->{'Requests Table'} = 'Tabela de Pedidos';
    $Self->{Translation}->{'Select all requests'} = 'Selecionar todos os pedidos';
    $Self->{Translation}->{'Send Time'} = 'Hora de Envio';
    $Self->{Translation}->{'Vote Time'} = 'Hora do Voto';
    $Self->{Translation}->{'Select this request'} = 'Selecionar este pedido';
    $Self->{Translation}->{'See Details'} = 'Ver detalhes';
    $Self->{Translation}->{'Delete stats'} = 'Apagar estatística';
    $Self->{Translation}->{'Survey Stat Details'} = 'Detalhes da estatística';
    $Self->{Translation}->{'go back to stats overview'} = 'voltar ao resumo de estatísticas';
    $Self->{Translation}->{'Previous vote'} = 'Voto anterior';
    $Self->{Translation}->{'Next vote'} = 'Próximo voto';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Informação acerca do questionário';
    $Self->{Translation}->{'Sent requests'} = 'Pedidos enviados';
    $Self->{Translation}->{'Received surveys'} = 'Pedidos recebidos';
    $Self->{Translation}->{'Survey Details'} = 'Detalhes do questionário';
    $Self->{Translation}->{'Ticket Services'} = 'Serviços';
    $Self->{Translation}->{'Survey Results Graph'} = 'Gráfico de resultados';
    $Self->{Translation}->{'No stat results.'} = 'Sem resultados.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Questionário';
    $Self->{Translation}->{'Please answer these questions'} = 'Por favor, responda estas questões';
    $Self->{Translation}->{'Show my answers'} = 'Mostrar minhas respostas';
    $Self->{Translation}->{'These are your answers'} = 'Estas são suas respostas';
    $Self->{Translation}->{'Survey Title'} = 'Título da Pesquisa';

    # Perl Module: Kernel/Modules/AgentSurveyAdd.pm
    $Self->{Translation}->{'Add New Survey'} = 'Adicionar Novo Questionário';

    # Perl Module: Kernel/Modules/AgentSurveyEdit.pm
    $Self->{Translation}->{'You have no permission for this survey!'} = 'Não tem permissão para este questionário!';
    $Self->{Translation}->{'No SurveyID is given!'} = 'ID do questionário em falta!';
    $Self->{Translation}->{'Survey Edit'} = 'Editar Questionário';

    # Perl Module: Kernel/Modules/AgentSurveyEditQuestions.pm
    $Self->{Translation}->{'You have no permission for this survey or question!'} = 'Não tem permissão para este questionário ou pergunta!';
    $Self->{Translation}->{'You have no permission for this survey, question or answer!'} = 'Não tem permissão para este questionário, pergunta ou resposta!';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Editar Perguntas de Questionério';
    $Self->{Translation}->{'Yes/No'} = 'Sim/Não';
    $Self->{Translation}->{'Radio (List)'} = 'Radio (Lista)';
    $Self->{Translation}->{'Checkbox (List)'} = 'Caixa de verificação (Lista)';
    $Self->{Translation}->{'Net Promoter Score'} = '';
    $Self->{Translation}->{'Question Type'} = 'Tipo de questão';
    $Self->{Translation}->{'Complete'} = 'Concluído';
    $Self->{Translation}->{'Incomplete'} = 'Incompleto';
    $Self->{Translation}->{'Question Edit'} = 'Editar Perguntas';
    $Self->{Translation}->{'Answer Edit'} = 'Editar Respostas';

    # Perl Module: Kernel/Modules/AgentSurveyStats.pm
    $Self->{Translation}->{'Stats Overview'} = 'Resumo de estatísticas';
    $Self->{Translation}->{'You have no permission for this survey or stats detail!'} = 'Não tem permissão para este questionário ou detalhes de estatísticas!';
    $Self->{Translation}->{'Stats Detail'} = 'Detalhe da estatística';

    # Perl Module: Kernel/Modules/AgentSurveyZoom.pm
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'Não é possível definir novo estado! Nenhuma pergunta definida.';
    $Self->{Translation}->{'Can\'t set new status! Questions incomplete.'} = 'Não é possível definir novo estado! Perguntas incompletas.';
    $Self->{Translation}->{'Status changed.'} = 'Estado alterado.';
    $Self->{Translation}->{'- No queue selected -'} = 'Nenhuma fila selecionada';
    $Self->{Translation}->{'- No ticket type selected -'} = '- Nenhum tipo de ticket selecionado -';
    $Self->{Translation}->{'- No ticket service selected -'} = '- Nenhum serviço de ticket selecionado -';
    $Self->{Translation}->{'- Change Status -'} = '- Alterar Estado -';
    $Self->{Translation}->{'Master'} = 'Mestre';
    $Self->{Translation}->{'Invalid'} = 'Inválido';
    $Self->{Translation}->{'New Status'} = 'Novo estado';
    $Self->{Translation}->{'Survey Description'} = 'Descrição de questionário';
    $Self->{Translation}->{'answered'} = 'Respondido';
    $Self->{Translation}->{'not answered'} = 'Não respondido';

    # Perl Module: Kernel/Modules/PublicSurvey.pm
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Obrigado pela sua participação.';
    $Self->{Translation}->{'The survey is finished.'} = 'Este questionário terminou.';
    $Self->{Translation}->{'Survey Message!'} = 'Mensagem da Pesquisa!';
    $Self->{Translation}->{'Module not enabled.'} = 'Módulo não habilitado.';
    $Self->{Translation}->{'This functionality is not enabled, please contact your administrator.'} =
        'Esta funcionalidade não está ativa, por favor contate seu administrador.';
    $Self->{Translation}->{'Survey Error!'} = 'Erro na Pesquisa!';
    $Self->{Translation}->{'Invalid survey key.'} = 'Chave da pesquisa inválida.';
    $Self->{Translation}->{'The inserted survey key is invalid, if you followed a link maybe this is obsolete or broken.'} =
        'A chave da pesquisa inserida é inválida, se você acessou um link, talvez ele esteja obsoleto ou quebrado.';
    $Self->{Translation}->{'Survey Vote'} = 'Voto da Pesquisa';
    $Self->{Translation}->{'Survey Vote Data'} = 'Dados do voto da pesquisa';
    $Self->{Translation}->{'You have already answered the survey.'} = 'Você já respondeu a pesquisa.';

    # Perl Module: Kernel/System/Stats/Dynamic/SurveyList.pm
    $Self->{Translation}->{'Survey List'} = 'Lista de questionários';

    # JS File: Survey.Agent.SurveyEditQuestions
    $Self->{Translation}->{'Do you really want to delete this question? ALL associated data will be LOST!'} =
        'Tem a certeza que pretende apagar esta pergunta? TODOS os dados associados serão PERDIDOS!';
    $Self->{Translation}->{'Do you really want to delete this answer?'} = 'Tem a certeza que pretende apagar esta resposta?';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Um Módulo de Questionário.';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Um módulo para editar perguntas de questionário.';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        'Todos os parâmetros do Questionário na interface do agente.';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        'Intervalo de dias após enviar um e-mail de pedido dentro do qual novos pedidos não serão enviadas para o mesmo cliente. Selecionar 0 irá sempre enviar o e-mail de pedido.';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Corpo padrão para o e-mail de notificação de clientes sobre novo questionário.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Remetente padrão para o e-mail de notificação de clientes sobre novo questionário.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Assunto padrão para o e-mail de notificação de clientes sobre novo questionário.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Define o módulo de visão geral para exibir a visão compacta de uma lista de questionários.';
    $Self->{Translation}->{'Defines groups which have a permission to change survey status. Array is empty by default and agents from all groups can change survey status.'} =
        'Define grupos que têm permissão para alterar o estado do questionário.  A matriz está vazia por padrão, logo, agentes de todos os grupos podem alterar o estado do questionário.';
    $Self->{Translation}->{'Defines if survey requests will be only send to real customers.'} =
        'Define se os pedidos de questionário serão enviados apenas para clientes reais.';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        'Define a quantidade máxima de questionários que são enviados para um cliente a cada 30 dias (0 significa que não há máximo; todos os pedidos de questionário serão enviados).';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ). Note: delayed survey sending is done by the OTRS Daemon, prior activation of \'Daemon::SchedulerCronTaskManager::Task###SurveyRequestsSend\' setting.'} =
        'Define a quantidade de horas que um ticket deve estar fechado para enviar um pedido de questionário (0 significa enviar imediatamente após fecho). Nota: um envio tardio de questionário é feito pelo OTRS Daemon, sob ativação da configuração  \'Daemon::SchedulerCronTaskManager::Task###SurveyRequestsSend\' .';
    $Self->{Translation}->{'Defines the columns for the dropdown list for building send conditions (0 => inactive, 1 => active).'} =
        'Define as colunas da lista suspensa para criação de condições de envio (0=> inativo, 1=> ativo).';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        'Define a altura padrão para Richtext nos elementos da SurveyZoom';
    $Self->{Translation}->{'Defines the groups (rw) which can delete survey stats.'} = 'Define os grupos (rw) que podem apagar as estatísticas do questionário.';
    $Self->{Translation}->{'Defines the maximum height for Richtext views for SurveyZoom elements.'} =
        'Define a altura máxima para visualizações do Richtext nos elementos do SurveyZoom.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        'Define as colunas exibidas na visão geral do questionário. Esta opção não tem efeito sobre a posição das colunas.';
    $Self->{Translation}->{'Determines if the statistics module may generate survey lists.'} =
        'Determina se o módulo de estatísticas pode gerar listas de questionários.';
    $Self->{Translation}->{'Edit survey general information.'} = 'Editar informação geral do questionário.';
    $Self->{Translation}->{'Edit survey questions.'} = 'Editar as questões do questionário.';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        'Habilita ou desabilita a tela ShowVoteData na interface pública para exibir dados do resultado de uma pesquisa específica quando o cliente tenta responder uma pesquisa pela segunda vez.';
    $Self->{Translation}->{'Enable or disable the send condition check for the service.'} = 'Ativa ou desativa verificação de condições de serviços para envio.';
    $Self->{Translation}->{'Enable or disable the send condition check for the ticket type.'} =
        'Ativa ou desativa verificação de condições de tipos para envio.';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        'Registo de módulo de interface para adição do questionário na interface do agente.';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        'Registo de módulo de interface para edição do questionário na interface do agente.';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        'Registo de módulo de interface para estatística do questionário na interface do agente.';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        'Registo de módulo de interface para detalhes de pesquisa na interface de atendente.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        'Módulo de auto registo de inquéritos de cliente no interface público';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Se esta regex for encontrada, nenhum questionário será enviado para o cliente';
    $Self->{Translation}->{'Limit.'} = 'Limite.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Parâmetros para as páginas (nas quais os questionários são mostrados) da visão geral compacta.';
    $Self->{Translation}->{'Public Survey.'} = 'Inquérito público';
    $Self->{Translation}->{'Results older than the configured amount of days will be deleted. Note: delete results done by the OTRS Daemon, prior activation of \'Task###SurveyRequestsDelete\' setting.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        'Exibe um link no menu para editar um questionário na interface do agente.';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        'Exibe um link no menu para editar perguntas do questionário na interface do agent.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        'Exibe um link no menu para voltar da visão de detalhes de um questionário na interface do agente.';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        'Exibe um link no menu para detalhar as estatísticas do questionário na interface do agente.';
    $Self->{Translation}->{'Stats Details'} = 'Detalhes da estatística';
    $Self->{Translation}->{'Survey Add Module.'} = 'Módulo de adição de questionário.';
    $Self->{Translation}->{'Survey Edit Module.'} = 'Módulo de edição de questionário';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Limite da Visão Geral de Questionário "Pequena"';
    $Self->{Translation}->{'Survey Stats Module.'} = 'Módulo de Estatísticas de Questionário';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Módulo de Detalhe de Questionário';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small".'} = 'Limite de questionários por página na Visão Geral para a vista "Pequena".';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = 'Os questionários não serão enviados para os endereços de e-mail configurados.';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'O identificador de um questionário, ex. Questionário#, MeuQuestionário#. O padrão é Questionário#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        'Módulo de evento de tickets para enviar pedidos de questionário via e-mail automaticamente para clientes se um ticket for fechado.';
    $Self->{Translation}->{'Trigger delete results (including vote data and requests).'} = 'Acionar os resultados da exclusão ( incluindo dados de voto e pedidos)';
    $Self->{Translation}->{'Trigger sending delayed survey requests.'} = 'Disparar o envio de pedidos de questionários atrasados.';
    $Self->{Translation}->{'Zoom into statistics details.'} = 'Zoom em detalhes de estatísticas.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Do you really want to delete this answer?',
    'Do you really want to delete this question? ALL associated data will be LOST!',
    'Settings',
    'Submit',
    );

}

1;
