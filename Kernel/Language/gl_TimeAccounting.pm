# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::gl_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Quere realmente borrar o Tempo Contabilizado deste día?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Edite Rexistro Tempo';
    $Self->{Translation}->{'Go to settings'} = 'Ir á configuración';
    $Self->{Translation}->{'Date Navigation'} = 'Navegación entre datas';
    $Self->{Translation}->{'Days without entries'} = 'Días sen entradas';
    $Self->{Translation}->{'Select all days'} = 'Seleccionar todos os días';
    $Self->{Translation}->{'Mass entry'} = 'Introdución en masa';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Escolla o motivo da súa ausencia nos días seleccionados';
    $Self->{Translation}->{'On vacation'} = 'Vacacións';
    $Self->{Translation}->{'On sick leave'} = 'Licenza por enfermidade';
    $Self->{Translation}->{'On overtime leave'} = 'En permiso de horas extras';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'Os campos obrigatorios están marcados cun «*».';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Hai que dar unha hora de inicio e de remate ou un período de tempo.';
    $Self->{Translation}->{'Project'} = 'Proxecto';
    $Self->{Translation}->{'Task'} = 'Tarefa';
    $Self->{Translation}->{'Remark'} = 'Observación';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = '';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Non se permiten horas negativas.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Non se permiten horas repetidas. A hora de inicio coincide con outro intervalo.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'O formato é incorrecto! Introduza unha hora no formato HH:MM.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '24:00 só está permitido como hora de finalización.';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'A hora é incorrecta! Un día só ten 24 horas.';
    $Self->{Translation}->{'End time must be after start time.'} = 'A hora de finalización ha de ser posterior á de inicio.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Non se permiten horas repetidas. A hora de finalización coincide con outro intervalo.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'O período é incorrecto! Un día só ten 24 horas.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Un período correcto ha de ser maior de cero.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'O período é incorrecto! Non se permiten períodos negativos.';
    $Self->{Translation}->{'Add one row'} = 'Engadir unha fila';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Só é posíbel seleccionar un elemento!';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Confirma que traballou mentres tiña licenza por enfermidade?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Confirma que traballou mentres estaba de vacacións?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Confirma que traballou mentres tiña permiso por horas extras?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Confirma que traballou máis de dezaseis horas?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Vista xeral mensual de reporte de tempo';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Horas extra (horas)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Horas extra (este mes)';
    $Self->{Translation}->{'Overtime (total)'} = 'Horas extra (total)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Permiso por horas extras restantes';
    $Self->{Translation}->{'Vacation (Days)'} = 'Vacacións (días)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Vacacións collidas (este mes)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Vacacións collidas (totais)';
    $Self->{Translation}->{'Remaining vacation'} = 'Vacacións restantes';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Licenza por enfermidade (días)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Licenzas por enfermidade collidas (este mes)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Licenzas por enfermidade collidas (totais)';
    $Self->{Translation}->{'Previous month'} = 'Mes anterior';
    $Self->{Translation}->{'Next month'} = 'Mes seguinte';
    $Self->{Translation}->{'Weekday'} = 'Día da semana';
    $Self->{Translation}->{'Working Hours'} = 'Horas laborais';
    $Self->{Translation}->{'Total worked hours'} = 'Horas traballadas totais';
    $Self->{Translation}->{'User\'s project overview'} = 'Vista xeral do proxecto do usuario';
    $Self->{Translation}->{'Hours (monthly)'} = 'Horas (por mes)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Horas (vida)';
    $Self->{Translation}->{'Grand total'} = 'Total acumulado';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Reporte tempo';
    $Self->{Translation}->{'Month Navigation'} = 'Navegación por meses';
    $Self->{Translation}->{'Go to date'} = 'Ir a unha data';
    $Self->{Translation}->{'User reports'} = 'Informes de usuario';
    $Self->{Translation}->{'Monthly total'} = 'Total mensual';
    $Self->{Translation}->{'Lifetime total'} = 'Total da vida';
    $Self->{Translation}->{'Overtime leave'} = 'Licenza por horas extra';
    $Self->{Translation}->{'Vacation'} = 'Vacacións';
    $Self->{Translation}->{'Sick leave'} = 'Licenza por enfermidade';
    $Self->{Translation}->{'Vacation remaining'} = 'Vacacións restantes';
    $Self->{Translation}->{'Project reports'} = 'Informes de proxectos';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Informe de proxectos';
    $Self->{Translation}->{'Go to reporting overview'} = 'Ir á vista xeral de informes';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        'Actualmente só usuarios activos neste proxecto son mostrados. Para cambiar este comportamento, por favor actualice o axuste:';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'Todo o tempo contabilizado polos usuarios é mostrado. Para cambiar este comportamento, por favor actulice o axuste:';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Edite Contabilización do Tempo en Axustes de Proyecto';
    $Self->{Translation}->{'Add project'} = 'Engadir un proxecto';
    $Self->{Translation}->{'Go to settings overview'} = 'Vaia á vista xeral de axustes';
    $Self->{Translation}->{'Add Project'} = 'Engadir un proxecto';
    $Self->{Translation}->{'Edit Project Settings'} = 'Editar a configuración do proxecto';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Xa hai un proxecto con este nome. Por favor, escolla un diferente.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Edite Contabilización do Tempo en Axustes';
    $Self->{Translation}->{'Add task'} = 'Engadir unha tarefa';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = '';
    $Self->{Translation}->{'Time periods can not be deleted.'} = '';
    $Self->{Translation}->{'Project List'} = 'Lista de proxectos';
    $Self->{Translation}->{'Task List'} = 'Lista de tarefas';
    $Self->{Translation}->{'Add Task'} = 'Engadir unha tarefa';
    $Self->{Translation}->{'Edit Task Settings'} = 'Editar a configuración da tarefa';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Xa hai unha tarefa con este nome. Por favor, escolla un diferente.';
    $Self->{Translation}->{'User List'} = 'Lista de usuarios';
    $Self->{Translation}->{'User Settings'} = '';
    $Self->{Translation}->{'User is allowed to see overtimes'} = '';
    $Self->{Translation}->{'Show Overtime'} = 'Mostrar Tempo Exceso';
    $Self->{Translation}->{'User is allowed to create projects'} = '';
    $Self->{Translation}->{'Allow project creation'} = 'Permitir creación proxecto';
    $Self->{Translation}->{'User is allowed to skip time accounting'} = '';
    $Self->{Translation}->{'Allow time accounting skipping'} = '';
    $Self->{Translation}->{'If this option is selected, time accounting is effectively optional for the user.'} =
        '';
    $Self->{Translation}->{'There will be no warnings about missing entries and no entry enforcement.'} =
        '';
    $Self->{Translation}->{'Time Spans'} = '';
    $Self->{Translation}->{'Period Begin'} = 'Comienzo Periodo';
    $Self->{Translation}->{'Period End'} = 'Fin Periodo';
    $Self->{Translation}->{'Days of Vacation'} = 'Días de Vacaciones';
    $Self->{Translation}->{'Hours per Week'} = 'Horas por Semana';
    $Self->{Translation}->{'Authorized Overtime'} = 'Exceso Tempo Autorizado';
    $Self->{Translation}->{'Start Date'} = 'Data de comezo';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Por favor introduzca unha data válida';
    $Self->{Translation}->{'End Date'} = 'Data de finalización';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Fin do periodo debe ser despois de que comience o periodo';
    $Self->{Translation}->{'Leave Days'} = 'Días de permiso';
    $Self->{Translation}->{'Weekly Hours'} = 'Horas semanais';
    $Self->{Translation}->{'Overtime'} = 'Horas extra';
    $Self->{Translation}->{'No time periods found.'} = 'Non se atoparon períodos de tempo.';
    $Self->{Translation}->{'Add time period'} = 'Engadir periodo de tempo';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Vista Rexistro de Tempo';
    $Self->{Translation}->{'View of '} = 'Vista de';
    $Self->{Translation}->{'Previous day'} = 'Día anterior';
    $Self->{Translation}->{'Next day'} = 'Día seguinte';
    $Self->{Translation}->{'No data found for this day.'} = 'Non se atoparon datos para este día.';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = '';
    $Self->{Translation}->{'Last Projects'} = '';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = '';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = '';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        '';
    $Self->{Translation}->{'Incomplete Working Days'} = '';
    $Self->{Translation}->{'Successful insert!'} = 'Inserción satisfactoria!';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = 'Erro mentres introducíanse datas múltiples!';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = 'Entradas satisfactoriamente introducidas para varias datas!';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = 'Data introducida foi invalida! A data foi cambiada a hoxe.';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        '';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        '';
    $Self->{Translation}->{'Last Selected Projects'} = '';
    $Self->{Translation}->{'All Projects'} = '';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = '';
    $Self->{Translation}->{'Reporting Project'} = '';
    $Self->{Translation}->{'Reporting'} = 'Informes';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = '';
    $Self->{Translation}->{'Project added!'} = '';
    $Self->{Translation}->{'Project updated!'} = '';
    $Self->{Translation}->{'Task added!'} = '';
    $Self->{Translation}->{'Task updated!'} = '';
    $Self->{Translation}->{'The UserID is not valid!'} = '';
    $Self->{Translation}->{'Can\'t insert user data!'} = '';
    $Self->{Translation}->{'Unable to add time period!'} = '';
    $Self->{Translation}->{'Setting'} = 'Configuración';
    $Self->{Translation}->{'User updated!'} = '';
    $Self->{Translation}->{'User added!'} = '';
    $Self->{Translation}->{'Add a user to time accounting...'} = '';
    $Self->{Translation}->{'New User'} = '';
    $Self->{Translation}->{'Period Status'} = '';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = '';

    # Perl Module: Kernel/Output/HTML/Notification/TimeAccounting.pm
    $Self->{Translation}->{'Please insert your working hours!'} = 'Introduza as súas horas de traballo!';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = '';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = 'Escolla ao menos un día!';
    $Self->{Translation}->{'Mass Entry'} = 'Introdución en masa';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Escolla o motivo da ausencia!';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Elimine Entrada Tempo Contabilizado';
    $Self->{Translation}->{'Confirm insert'} = 'Confirme a inserción';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'Módulo notificación interface de axente para ver o número de días de traballo incompletos para o usuario.';
    $Self->{Translation}->{'Default name for new actions.'} = 'Nome predeterminado para as accións novas.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Nome predeterminado para os proxectos novos.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Axuste por defecto para fin da data.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Axuste por defecto para inicio da data.';
    $Self->{Translation}->{'Default setting for description.'} = 'Configuración predefinida da descrición';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Configuración predefinida dos días de permiso.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Configuración predefinida das horas extra.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Axuste por defecto para as horas estandard semanáis.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Estado predeterminado para as accións novas.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Estado predeterminado para os proxectos novos.';
    $Self->{Translation}->{'Default status for new users.'} = 'Estado predeterminado para os usuarios novos.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        'Define os proxectos para os cales un comentario é requirido. Se a ExpReg coincide no proxecto, ten que insertar un comentario tamén. A ExpReg usa o parámetro smx.';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        'Determina se o módulo de estatísticas pode xerar información de contabilización de tempo.';
    $Self->{Translation}->{'Edit time accounting settings.'} = '';
    $Self->{Translation}->{'Edit time record.'} = '';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Por cantos días atrás pode insertar unidades de traballo.';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        'Se habilitado, só usuarios que engadiron tempo de traballo ao proxecto seleccionado son mostrados.';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        '';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        '';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        '';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        'Se habilitado, ao usuario permiteselle introducir "permiso de vacacións" , "permiso por enfermidade" e "permiso por exceso de tempo" para multiples datas dunha vez.';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        'Número máximo de días de traballo despois dos cales as unidades de traballo deben ser insertadas.';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        'Número máximo de días de traballo sen entradas de unidades de traballo despois dos cales unha alerta será mostrada.';
    $Self->{Translation}->{'Overview.'} = '';
    $Self->{Translation}->{'Project time reporting.'} = '';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'Expresións regulares para a lista que contrinxe a acción segundo o proxecto seleccionado. Chave contén a expresión regular para proxecto(s), contido contén expresións regulares para acción(s).';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'Expresións regulares para a lista que contrinxe o proxecto segundo os grupos seleccionados. Chave contén a expresión regular para proxecto(s), contido contén lista separada por comas de grupos.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        'Especifica se as horas de traballo poden ser insertadas sen tempos de inicio e fin.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Este módulo forza as insercións en ContabilizaciónTempo.';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'Este módulo de notificación da unha alerta se hai moitos días de traballo incompletos.';
    $Self->{Translation}->{'Time Accounting'} = 'Contabilizar Tempo';
    $Self->{Translation}->{'Time accounting edit.'} = 'Edite contabilización do tempo.';
    $Self->{Translation}->{'Time accounting overview.'} = 'Vista Xeral contabilización tempo.';
    $Self->{Translation}->{'Time accounting reporting.'} = 'Informe contabilización tempo.';
    $Self->{Translation}->{'Time accounting settings.'} = 'Axustes contabilización tempo.';
    $Self->{Translation}->{'Time accounting view.'} = 'Vista contabilización tempo.';
    $Self->{Translation}->{'Time accounting.'} = 'Contabilización tempo.';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        'Para usar se algunhas accións reduciron as horas de traballo (por exemplo, se só a mitade do tempo de viaxe é pagado Chave => viaxe; Contido => 50).';


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
