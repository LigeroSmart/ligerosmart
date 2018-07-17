# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Você realmente deseja remover o apontamento de tempo deste dia ?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Editar registro de tempo';
    $Self->{Translation}->{'Go to settings'} = 'Ir para configurações';
    $Self->{Translation}->{'Date Navigation'} = 'Navegação de datas';
    $Self->{Translation}->{'Days without entries'} = 'Dias sem apontamentos';
    $Self->{Translation}->{'Select all days'} = 'Selecionar todos os dias';
    $Self->{Translation}->{'Mass entry'} = 'Entrada em massa';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Por favor, escolha o motivo de sua ausência para os dias selecionados';
    $Self->{Translation}->{'On vacation'} = 'Em férias';
    $Self->{Translation}->{'On sick leave'} = 'Em licença médica';
    $Self->{Translation}->{'On overtime leave'} = 'Em licença de horas extras';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'Campos obrigatórios estão marcados com "*"';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Você têm que preencher início e fim, ou um período de tempo.';
    $Self->{Translation}->{'Project'} = 'Projeto';
    $Self->{Translation}->{'Task'} = 'Tarefas';
    $Self->{Translation}->{'Remark'} = 'Observação';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = 'Por favor, adicione um comentário com mais de 8 caracteres!';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Datas negativas não são liberadas';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Horas repetidas não são liberadas. Inicie o apontamento em outro intervalo.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'Formato inválido! Por favor, entre com um tempo no formato HH:MM';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = 'Apenas 24:00 são permitidas como tempo final';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'Tempo inválido! Um dia tem apenas 24 horas.';
    $Self->{Translation}->{'End time must be after start time.'} = 'Tempo final deve ser depois do tempo inicial.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Horas repetidas não são liberadas. Inicie o apontamento em outro intervalo.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Período inválido! Um dia tem apenas 24 horas.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Um período válido deve ser maior que zero.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Período inválido! Períodos negativos não são liberados.';
    $Self->{Translation}->{'Add one row'} = 'Adicionar uma linha';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Você pode selecionar apenas um elemento no checkbox!';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Tem certeza de que você trabalhou enquanto estava em licença médica?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Tem certeza de que você trabalhou enquanto estava de férias?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Você tem certeza que trabalhou enquanto estava de licença de horas extras.';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Você tem certeza que trabalhou mais que 16 horas?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Relatório de apontamento de tempo mensal';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Horas extras (horas)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Horas extras (este mês)';
    $Self->{Translation}->{'Overtime (total)'} = 'Horas extras (total)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Restante da licença de horas extras';
    $Self->{Translation}->{'Vacation (Days)'} = 'Férias (Dias)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Férias tiradas (este mês)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Férias tiradas (total)';
    $Self->{Translation}->{'Remaining vacation'} = 'Férias restantes';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Licença Médica (Dias)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Licença médicas tiradas  ( este mês )';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Licença médicas tiradas  ( total )';
    $Self->{Translation}->{'Previous month'} = 'Mês anterior';
    $Self->{Translation}->{'Next month'} = 'Próximo mês';
    $Self->{Translation}->{'Weekday'} = 'Dia da semana';
    $Self->{Translation}->{'Working Hours'} = 'Horário de trabalho';
    $Self->{Translation}->{'Total worked hours'} = 'Total de horas trabalhadas';
    $Self->{Translation}->{'User\'s project overview'} = 'Visão de projeto de usuários';
    $Self->{Translation}->{'Hours (monthly)'} = 'Horas ( mensal )';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Horas ( Duração )';
    $Self->{Translation}->{'Grand total'} = 'Total geral';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Relatório de tempo';
    $Self->{Translation}->{'Month Navigation'} = 'Navegação Mensal';
    $Self->{Translation}->{'Go to date'} = 'Ir para data';
    $Self->{Translation}->{'User reports'} = 'Relatórios de usuários';
    $Self->{Translation}->{'Monthly total'} = 'Total mensal';
    $Self->{Translation}->{'Lifetime total'} = 'Duração total';
    $Self->{Translation}->{'Overtime leave'} = 'Licença de horas extras';
    $Self->{Translation}->{'Vacation'} = 'Férias';
    $Self->{Translation}->{'Sick leave'} = 'Licença médica';
    $Self->{Translation}->{'Vacation remaining'} = 'Férias restante';
    $Self->{Translation}->{'Project reports'} = 'Relatórios de projeto';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Relatório de projeto';
    $Self->{Translation}->{'Go to reporting overview'} = 'Ir para visão geral de relatórios';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        'Atualmente somente usuários ativos neste projeto são exibidos. Para alterar esse comportamento, por favor atualize a configuração:';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'Atualmente todos os apontamento de tempos dos usuários são exibidos. Para alterar esse comportamento, por favor atualize a configuração:';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Editar configurações do Projeto';
    $Self->{Translation}->{'Add project'} = 'Adicionar projeto';
    $Self->{Translation}->{'Go to settings overview'} = 'Ir para configurações gerais';
    $Self->{Translation}->{'Add Project'} = 'Adicionar projeto';
    $Self->{Translation}->{'Edit Project Settings'} = 'Editar Configurações do Projeto';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Já existe um projeto com este nome. Por favor, escolha um diferente.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Editar Configurações da Contabilidade de Tempo.';
    $Self->{Translation}->{'Add task'} = 'Adicionar tarefa';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = 'Filtrar por projetos, tarefas ou usuários';
    $Self->{Translation}->{'Time periods can not be deleted.'} = 'Períodos de tempo não podem ser excluídos.';
    $Self->{Translation}->{'Project List'} = 'Lista de projetos';
    $Self->{Translation}->{'Task List'} = 'Lista de tarefas';
    $Self->{Translation}->{'Add Task'} = 'Adicionar tarefa';
    $Self->{Translation}->{'Edit Task Settings'} = 'Editar configurações da Tarefa';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Já existe uma tarefa com esse nome. Por favor, escolha um nome diferente.';
    $Self->{Translation}->{'User List'} = 'Lista de usuários';
    $Self->{Translation}->{'User Settings'} = 'Configurações de usuário';
    $Self->{Translation}->{'User is allowed to see overtimes'} = 'O usuário tem permissão para ver horas extras';
    $Self->{Translation}->{'Show Overtime'} = 'Mostrar horas extras';
    $Self->{Translation}->{'User is allowed to create projects'} = 'O usuário tem permissão para criar projetos';
    $Self->{Translation}->{'Allow project creation'} = 'Liberar criação de projetos';
    $Self->{Translation}->{'User is allowed to skip time accounting'} = '';
    $Self->{Translation}->{'Allow time accounting skipping'} = '';
    $Self->{Translation}->{'If this option is selected, time accounting is effectively optional for the user.'} =
        '';
    $Self->{Translation}->{'There will be no warnings about missing entries and no entry enforcement.'} =
        '';
    $Self->{Translation}->{'Time Spans'} = 'Intervalos de tempo';
    $Self->{Translation}->{'Period Begin'} = 'Período Inicial';
    $Self->{Translation}->{'Period End'} = 'Período Final';
    $Self->{Translation}->{'Days of Vacation'} = 'Dias de Férias';
    $Self->{Translation}->{'Hours per Week'} = 'Horas por Semana';
    $Self->{Translation}->{'Authorized Overtime'} = 'Horas extras autorizada';
    $Self->{Translation}->{'Start Date'} = 'Data inicial ';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Por favor, insira uma data válida.';
    $Self->{Translation}->{'End Date'} = 'Data final';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Período final deve ser maior que  período inicial.';
    $Self->{Translation}->{'Leave Days'} = 'Dias de férias';
    $Self->{Translation}->{'Weekly Hours'} = 'Horas semanais';
    $Self->{Translation}->{'Overtime'} = 'Horas extras';
    $Self->{Translation}->{'No time periods found.'} = 'Período de tempo não encontrado.';
    $Self->{Translation}->{'Add time period'} = 'Adicionar período de tempo';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Ver registro de tempo';
    $Self->{Translation}->{'View of '} = 'Visão de';
    $Self->{Translation}->{'Previous day'} = 'Dia anterior';
    $Self->{Translation}->{'Next day'} = 'Próximo dia';
    $Self->{Translation}->{'No data found for this day.'} = 'Não foram encontrados dados para este dia.';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = 'Não foi possível inserir Unidades de Trabalho!';
    $Self->{Translation}->{'Last Projects'} = 'Últimos projetos';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = 'Configurações não salvas, pois um dia tem apenas 24 horas!';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = 'Não foi possível deletar Unidades de Trabalho!';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        'Esta Data está fora do limite, mas você não inseriu este dia ainda, então você possui UMA(!) chance de inserir';
    $Self->{Translation}->{'Incomplete Working Days'} = 'Dias de trabalhos incompletos';
    $Self->{Translation}->{'Please insert your working hours!'} = 'Por favor insira suas horas de trabalho!';
    $Self->{Translation}->{'Successful insert!'} = 'Inserido com sucesso!';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = 'Erro ao inserir múltiplas datas!';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = 'Entrada de várias datas inserida com sucesso!';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = 'Data inserida é inválida! Data foi alterada para hoje.';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        'Nenhum período de tempo configurado ou a data especificada está fora dos períodos de tempo definidos.';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        'Entre em contato com o administrador contábil do tempo para atualizar seus períodos de tempo!';
    $Self->{Translation}->{'Last Selected Projects'} = 'Últimos projetos selecionados';
    $Self->{Translation}->{'All Projects'} = 'Todos os projetos';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = 'Projeto de Relatório: Necessário ProjectID';
    $Self->{Translation}->{'Reporting Project'} = 'Projeto de Relatório';
    $Self->{Translation}->{'Reporting'} = 'Relatório';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = 'Impossível atualizar configurações de usuário!';
    $Self->{Translation}->{'Project added!'} = 'Projeto adicionado!';
    $Self->{Translation}->{'Project updated!'} = 'Projeto atualizado!';
    $Self->{Translation}->{'Task added!'} = 'Atividade adicionada!';
    $Self->{Translation}->{'Task updated!'} = 'Atividade atualizada!';
    $Self->{Translation}->{'The UserID is not valid!'} = 'O UserID não é válido!';
    $Self->{Translation}->{'Can\'t insert user data!'} = 'Não foi possível inserir dados de usuário!';
    $Self->{Translation}->{'Unable to add time period!'} = 'Impossível adicionar período de tempo!';
    $Self->{Translation}->{'Setting'} = 'Configuração';
    $Self->{Translation}->{'User updated!'} = 'Usuário atualizado!';
    $Self->{Translation}->{'User added!'} = 'Usuário adicionado!';
    $Self->{Translation}->{'Add a user to time accounting...'} = 'Adicionar um usuário para a contabilidade do tempo....';
    $Self->{Translation}->{'New User'} = 'Novo usuário';
    $Self->{Translation}->{'Period Status'} = 'Estado do período';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = 'Visão: Necessário %s!';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = 'Dias de trabalhos incompletos';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = 'Por favor, escolha pelo menos um dia!';
    $Self->{Translation}->{'Mass Entry'} = 'Entrada em massa';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Por favor escolha um motivo para a ausência';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Deletar entrada na Contabilidade de Tempo.';
    $Self->{Translation}->{'Confirm insert'} = 'Confirmar inserção';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'Módulo de notificação do Agente para ver o numero de dias incompletos do usuário.';
    $Self->{Translation}->{'Default name for new actions.'} = 'O nome padrão para novas ações.';
    $Self->{Translation}->{'Default name for new projects.'} = 'O nome padrão para novos projetos.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Configuração padrão para data final';
    $Self->{Translation}->{'Default setting for date start.'} = 'Configuração padrão para data inicial.';
    $Self->{Translation}->{'Default setting for description.'} = 'Configuração padrão para descrição.';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Configuração padrão para dias de férias.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Configuração padrão para horas extras,';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Configuração padrão para horas semanais padrão';
    $Self->{Translation}->{'Default status for new actions.'} = 'Estado padrão para novas ações.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Estado padrão para novos projetos';
    $Self->{Translation}->{'Default status for new users.'} = 'Estado para para novos usuários';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        'Define os projetos para os quais é necessária uma observação. Se o RegExp é encontrado no projeto, você tem que inserir uma observação. O RegExp usa o parâmetro smx.';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        'Determina se o módulo de estatísticas pode gerar informações do time accounting.';
    $Self->{Translation}->{'Edit time accounting settings.'} = 'Editar configurações da contabilidade de tempo.';
    $Self->{Translation}->{'Edit time record.'} = 'Editar registro de tempo.';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Para quantos dias atrás você pode inserir unidades de trabalho.';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        'Se ativado, somente os usuários que adicionou tempo de trabalho ao o projeto selecionado serão exibidos.';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        'Se ativado, os elementos suspensos na tela de edição são modificadas para campos de autocompletar modernizados.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        'Se habilitado, o filtro para os projetos anteriores pode ser usado em vez de duas listas de projetos (último e todos). Ele pode ser usado apenas se TimeAccounting::EnableAutoCompletion está habilitado.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        'Se habilitado, o filtro para projetos anteriores é ativado por padrão se há projetos anteriores. Ele pode ser usado apenas se EnableAutoCompletion e TimeAccounting::UseFilter estão habilitados.';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        'Se ativado, o usuário tem permissão para entrar "em licença de férias", "em licença médica" e "em licença de horas extras" de uma só vez para várias datas.';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        'O número máximo de dias de trabalho após o qual as "unidades de trabalho" devem ser inseridos';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        'O número máximo de dias de trabalho sem "unidades de trabalho"  após o qual um aviso será mostrado.';
    $Self->{Translation}->{'Overview.'} = 'Visão Geral.';
    $Self->{Translation}->{'Project time reporting.'} = 'Relatório de tempos de projetos.';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'As expressões regulares para restringir lista de ações de acordo com o projeto selecionado. Chave contém expressão regular para o projeto(s), Conteúdo contém expressões regulares para a ação(s).';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'As expressões regulares para restringir a lista de projeto de acordo com grupos de usuários. Chave contém expressão regular para o projeto (s), conteúdo contém lista  separada por vírgulas de grupos.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        'Especifique se o horário de trabalho pode ser inserido sem horários de início e término.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Esse módulo força preencher o TimeAccounting.';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'Este módulo de notificação dá um aviso se houver muitos dias de trabalho não registrados.';
    $Self->{Translation}->{'Time Accounting'} = 'Contabilidade Tempo';
    $Self->{Translation}->{'Time accounting edit.'} = 'Editar contabilidade de tempo';
    $Self->{Translation}->{'Time accounting overview.'} = 'Visão geral de contabilidade de tempo';
    $Self->{Translation}->{'Time accounting reporting.'} = 'Relatório de contabilidade de tempo';
    $Self->{Translation}->{'Time accounting settings.'} = 'Configurações de contabilidade de tempo';
    $Self->{Translation}->{'Time accounting view.'} = 'Ver contabilidade de tempo';
    $Self->{Translation}->{'Time accounting.'} = 'Contabilidade Tempo';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        'Usar para  algumas ações de reduzir as horas de trabalho (por exemplo, se apenas metade do tempo de viagem é pago Key => viajar; Content => 50)';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Confirm insert',
    'Delete Time Accounting Entry',
    'Mass Entry',
    'No',
    'Please choose a reason for absence!',
    'Please choose at least one day!',
    'Submit',
    'Yes',
    );

}

1;
