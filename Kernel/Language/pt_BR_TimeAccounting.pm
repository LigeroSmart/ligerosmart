# --
# Kernel/Language/pt_BR_TimeAccounting.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: pt_BR_TimeAccounting.pm,v 1.2 2011-05-19 15:48:07 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_TimeAccounting;

use strict;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} = 'Você realmente deseja excluir a contabilização desse dia?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Editar registro de tempo';
    $Self->{Translation}->{'Project settings'} = 'Definições de Projeto';
    $Self->{Translation}->{'Date Navigation'} = 'Escolha de Data';
    $Self->{Translation}->{'Previous day'} = 'Dia anterior';
    $Self->{Translation}->{'Next day'} = 'Próximo Dia';
    $Self->{Translation}->{'Days without entries'} = 'Dias sem entradas';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'Os campos que são obrigatórios são marcados com um asterisco "*"';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Você tem que preencher o tempo de início e final ou um período de tempo.';
    $Self->{Translation}->{'Project'} = 'Projeto';
    $Self->{Translation}->{'Task'} = 'Tarefa';
    $Self->{Translation}->{'Remark'} = 'Marcar';
    $Self->{Translation}->{'Date Navigation'} = 'Escolha de Data';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!.'} = 'Por favor insira um comentário com pelo menos 8 caracteres';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Valores negativos não são permitidos.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} = 'Este horário de início é indicado em outra entrada.';
    $Self->{Translation}->{'End time must be after start time.'} = 'Hora de término deve ser posterior à hora de início.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} = 'Horas repetidas não são permitidas. Hora de término coincide com outro intervalo.';
    $Self->{Translation}->{'Period is bigger than the interval between start and end times!'} = 'Período é maior do que o intervalo entre os horários de início e fim!';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Período inválido! Um dia só tem 24 horas.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Um período válido deve ser maior que zero.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Período inválido! Períodos negativos não são permitidos.';
    $Self->{Translation}->{'Add one row'} = 'Adicionar uma linha';
    $Self->{Translation}->{'Total'} = 'Total';
    $Self->{Translation}->{'On vacation'} = 'Em férias';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Você pode selecionar apenas um elemento da caixa de seleção!';
    $Self->{Translation}->{'On sick leave'} = 'Em licença médica';
    $Self->{Translation}->{'On overtime leave'} = 'Em sobrehora';
    $Self->{Translation}->{'Show all items'} = 'Mostrar todos os itens';
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Excluir Entrada de Contabilização de Tempo';
    $Self->{Translation}->{'Confirm insert'} = 'Confirme inserir';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Tem certeza que você trabalhou enquanto esteve em licença médica?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Tem certeza que você trabalhou enquanto esteve em férias?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} = 'Tem certeza que você trabalhou em período de sobrehora?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Tem certeza que você trabalhou mais de 16 horas?';
    $Self->{Translation}->{'Select all days'} = '';
    $Self->{Translation}->{'Mass entry'} = '';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} = '';
    $Self->{Translation}->{'Please choose at least one day!'} = '';
    $Self->{Translation}->{'Please choose a reason for absence!'} = '';
    $Self->{Translation}->{'Mass Entry'} = '';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = '';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = '';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Visão Geral do Relatório de Contabilização Mensal de Tempo';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Hora-extra (em Horas)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Hora-extra (este mês)';
    $Self->{Translation}->{'Overtime (total)'} = 'Hora-extra (total)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Hora-extra remanescente';
    $Self->{Translation}->{'Vacation (Days)'} = 'Férias (em Dias)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Férias gozadas (este mês)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Férias gozadas (total)';
    $Self->{Translation}->{'Remaining vacation'} = 'Férias remanescentes';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Dias Afastados (em Dias)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Afastamento por doença (este Mês)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Afastamento por doença (total)';
    $Self->{Translation}->{'Previous month'} = 'Mês anterior';
    $Self->{Translation}->{'Next month'} = 'Próximo mês';
    $Self->{Translation}->{'Day'} = 'Dia';
    $Self->{Translation}->{'Weekday'} = 'Dia de semana';
    $Self->{Translation}->{'Working Hours'} = 'Horas de Trabalho';
    $Self->{Translation}->{'Total worked hours'} = 'Total de horas trabalhadas';
    $Self->{Translation}->{'User\'s project overview'} = 'Visão geral de projetos de usuário';
    $Self->{Translation}->{'Hours (monthly)'} = 'Horas (por mês)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Horas (total)';
    $Self->{Translation}->{'Grand total'} = 'Total Geral';

    # Template: AgentTimeAccountingProjectReporting
    $Self->{Translation}->{'Project report'} = 'Relatório do projeto';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Relatório de Horas';
    $Self->{Translation}->{'Month Navigation'} = 'Escolha de Mês';
    $Self->{Translation}->{'User reports'} = 'Relatórios de usuário';
    $Self->{Translation}->{'Monthly total'} = 'Total mensal';
    $Self->{Translation}->{'Lifetime total'} = 'Soma Total';
    $Self->{Translation}->{'Overtime leave'} = 'Sobrehora';
    $Self->{Translation}->{'Vacation'} = 'Férias';
    $Self->{Translation}->{'Sick leave'} = 'Licença médica';
    $Self->{Translation}->{'LeaveDay Remaining'} = 'Dias de Afastamento Remanescentes';
    $Self->{Translation}->{'Project reports'} = 'Relatórios de projeto';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Editar definições de projeto para contabilização de tempo';
    $Self->{Translation}->{'Add project'} = 'Adicionar projeto';
    $Self->{Translation}->{'Add Project'} = 'Adicionar Projeto';
    $Self->{Translation}->{'Edit Project Settings'} = 'Editar as configurações do projeto';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} = 'Já existe um projeto com este nome. Por favor, escolha um diferente..';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Editar definições de contabilização de tempo';
    $Self->{Translation}->{'Add task'} = 'Adicionar tarefa';
    $Self->{Translation}->{'New user'} = 'Novo usuário';
    $Self->{Translation}->{'Filter for Projects'} = 'Filtro para Projetos';
    $Self->{Translation}->{'Filter for Tasks'} = 'Filtro para Tarefas';
    $Self->{Translation}->{'Filter for Users'} = 'Filtro para Usuários';
    $Self->{Translation}->{'Project List'} = 'Lista de Projetos';
    $Self->{Translation}->{'Task List'} = 'Lista de Tarefas';
    $Self->{Translation}->{'Add Task'} = 'Adicionar Tarefa';
    $Self->{Translation}->{'Edit Task Settings'} = 'Editar Definições da Tarefa';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} = 'Já existe uma tarefa com este nome. Por favor, escolha um diferente.';
    $Self->{Translation}->{'User List'} = 'Lista de usuários';
    $Self->{Translation}->{'New User Settings'} = 'Novas Configurações do Usuário';
    $Self->{Translation}->{'Edit User Settings'} = 'Editar as configurações do usuário';
    $Self->{Translation}->{'Comments'} = 'Comentários';
    $Self->{Translation}->{'Show Overtime'} = 'Mostrar Sobrehoras';
    $Self->{Translation}->{'Allow project creation'} = 'Permitir criação de projeto';
    $Self->{Translation}->{'Period Begin'} = 'Início de Período';
    $Self->{Translation}->{'Period End'} = 'Fim de Período';
    $Self->{Translation}->{'Days of Vacation'} = 'Dias de Férias';
    $Self->{Translation}->{'Hours per Week'} = 'Horas por semana';
    $Self->{Translation}->{'Authorized Overtime'} = 'Sobrehora autorizada';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Final do período deve ser após o período de início.';
    $Self->{Translation}->{'No time periods found.'} = 'Sem períodos de tempo encontrados.';
    $Self->{Translation}->{'Add time period'} = 'Adicionar período de tempo';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Ver Registro de Tempo';
    $Self->{Translation}->{'View of '} = 'Visão de';
    $Self->{Translation}->{'No data found for this day.'} = 'Não foram encontrados dados para este dia.';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} = 'Agente de notificação módulo de interface para ver o número de dias de trabalho incompleto para o usuário.';
    $Self->{Translation}->{'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".'} = '';
    $Self->{Translation}->{'Default name for new actions.'} = 'O nome padrão para novas ações.';
    $Self->{Translation}->{'Default name for new projects.'} = 'O nome padrão para novos projetos.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Configuração padrão para a data de término.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Configuração padrão para a data de início.';
    $Self->{Translation}->{'Default setting for description.'} = '';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Configuração padrão para dias de ausência.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Configuração padrão para horas extraordinárias.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Configuração padrão para o horário semanal normal.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Estado padrão para novas ações.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Estado padrão para novos projectos.';
    $Self->{Translation}->{'Default status for new users.'} = 'Estado padrão para os novos usuários.';
    $Self->{Translation}->{'Defines if time accounting must be set to all tickets in bulk action.'} = '';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} = 'Dentro desta opção de configuração, uma regexp pode ser definida que determina quais projetos são registrados com uma observação deve ser (o regexp funciona com SMX-parâmetros).';
    $Self->{Translation}->{'Edit time accounting settings'} = 'Editar definições de controle de tempo';
    $Self->{Translation}->{'Edit time record'} = 'Editar registro de tempo';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Define-se quando é possível editar as entradas de tempo em idosos (por exemplo, 10 dias antes.';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to autocompletion fields.'} = 'Se ativado, os elementos de lista pendente na tela de edição são alteradas para campos autocompletar.';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} = '';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} = 'O número máximo de dias de trabalho após o qual as unidades de trabalho devem ser inseridas.';
    $Self->{Translation}->{'Maximum number of working days withouth working units entry after which a warning will be shown.'} = 'O número máximo de dias de trabalho, sem uma entrada, após o qual será exibido um aviso.';
    $Self->{Translation}->{'Project time reporting'} = 'O relatório de Tempo do projeto ';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} = 'Expressões regulares para restringir a lista de ações de acordo com o projeto selecionado. A chave contém a expressão regular para o projeto(s), o conteúdo contém expressões regulares para ação(ões).';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} = 'Expressões regulares para restringir a lista de projetos de acordo com grupos de usuários. A chave contém a expressão regular para o(s) projeto(s), o conteúdo contém a lista de grupos separados por vírgulas.';
    $Self->{Translation}->{'Saves the login and password on the session table in the database, if "DB" was selected for SessionModule.'} = '';
    $Self->{Translation}->{'Show article as rich text even if rich text writing is disabled.'} = '';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} = 'Especifica se as horas de trabalho podem ser introduzidas sem horários de início e fim.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Este módulo obriga inserções na Contabilização de Tempo.';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} = 'Este módulo de notificação dá um aviso se houver muitos dias úteis incompletos.';
    $Self->{Translation}->{'Time accounting.'} = 'Contabilidade de Tempo.';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} = 'Para usar se alguma ações reduziram as horas úteis (por exemplo, se apenas metade do tempo de viagem é pago, Chave => Viagem; Conteúdo => 50).';

    $Self->{Translation}->{'Mon'} = 'Seg';
    $Self->{Translation}->{'Tue'} = 'Ter';
    $Self->{Translation}->{'Wed'} = 'Qua';
    $Self->{Translation}->{'Thu'} = 'Qui';
    $Self->{Translation}->{'Fri'} = 'Sex';
    $Self->{Translation}->{'Sat'} = 'Sáb';
    $Self->{Translation}->{'Sun'} = 'Dom';
    $Self->{Translation}->{'January'} = 'Janeiro';
    $Self->{Translation}->{'February'} = 'Fevereiro';
    $Self->{Translation}->{'March'} = 'Março';
    $Self->{Translation}->{'April'} = 'Abril';
    $Self->{Translation}->{'May'} = 'Maio';
    $Self->{Translation}->{'June'} = 'Junho';
    $Self->{Translation}->{'July'} = 'Julho';
    $Self->{Translation}->{'August'} = 'Agosto';
    $Self->{Translation}->{'September'} = 'Setembro';
    $Self->{Translation}->{'October'} = 'Outubro';
    $Self->{Translation}->{'November'} = 'Novembro';
    $Self->{Translation}->{'December'} = 'Dezembro';

    $Self->{Translation}->{'Show all projects'} = 'Mostrar todos os projetos';
    $Self->{Translation}->{'Show valid projects'} = 'Mostrar projetos válidos';
    $Self->{Translation}->{'TimeAccounting'} = 'Contabilização de Tempo';
    $Self->{Translation}->{'Actions'} = 'Ações';
    $Self->{Translation}->{'User updated!'} = 'Usuário atualizado!';
    $Self->{Translation}->{'User added!'} = 'Usuário adicionado!';
    $Self->{Translation}->{'Project added!'} = 'Projeto adicionado!';
    $Self->{Translation}->{'Project updated!'} = 'Projeto atualizado!';
    $Self->{Translation}->{'Task added!'} = 'Tarefa adicionada!';
    $Self->{Translation}->{'Task updated!'} = 'Tarefa atualizada!';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Can\'t delete Working Units!'} = 'Não é possível excluir Unidades de Trabalho!';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = 'Um dia só tem 24 horas!';
    $Self->{Translation}->{'Please insert your working hours!'} = 'Informe suas horas trabalhadas!';
    $Self->{Translation}->{'Reporting'} = 'Reportando';
    $Self->{Translation}->{'Successful insert!'} = 'Sucesso na inserção!';

}

1;
