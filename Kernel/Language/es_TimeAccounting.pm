# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::es_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        '¿Realmente desea eliminar la Contabilidad de Tiempo de este día?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Modificar registro de horas';
    $Self->{Translation}->{'Go to settings'} = 'Ir a configuraciones';
    $Self->{Translation}->{'Date Navigation'} = 'Navegación por fecha';
    $Self->{Translation}->{'Days without entries'} = 'Días sin registro';
    $Self->{Translation}->{'Select all days'} = 'Seleccionar todos los días';
    $Self->{Translation}->{'Mass entry'} = 'Registro masivo';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Por favor escoja una razón para su ausencia para los días seleccionados';
    $Self->{Translation}->{'On vacation'} = 'De vacaciones';
    $Self->{Translation}->{'On sick leave'} = 'Ausente por enfermedad';
    $Self->{Translation}->{'On overtime leave'} = 'Ausente por haber trabajado horas extras';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'Los campos requeridos están marcados con un "*".';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Es necesario que proporcione una hora de inicio y una de finalización o un periodo.';
    $Self->{Translation}->{'Project'} = 'Proyecto';
    $Self->{Translation}->{'Task'} = 'Tarea';
    $Self->{Translation}->{'Remark'} = 'Comentario';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = '¡Por favor, añade un comentario con mas de 8 caracteres!';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'No se permite la inserción de horas negativas.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'No se permite la inserción de horas repetidas. La hora de inicio está incluída en otro intervalo.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = '¡Formato no válido! Por favor introduzca las horas con el formato HH:MM.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '24:00 es solo permitido como tiempo final.';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = '¡Hora no válida! Un día solo tiene 24 horas.';
    $Self->{Translation}->{'End time must be after start time.'} = 'La hora de finalización debe ser posterior a la de inicio.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'No se permite la inserción de horas repetidas. La hora de finalización está incluída en otro intervalo.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = '¡Periodo no válido! Un día sólo tiene 24 horas.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Un periodo válido debe ser mayor a cero.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = '¡Periodo no válido! No se permiten periodos negativos.';
    $Self->{Translation}->{'Add one row'} = 'Añadir una fila';
    $Self->{Translation}->{'You can only select one checkbox element!'} = '¡Sólo se permite elegir un elemento de la casilla de verificación!';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = '¿Está seguro que trabajó durante su ausencia por enfermedad?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = '¿Está seguro que trabajó durante sus vacaciones?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        '¿Está seguro que trabajó durante su ausencia por haber trabajado horas extras?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = '¿Está seguro que trabajó más de 16 horas?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Vista mensual de tiempos reportados';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Número de horas extras';
    $Self->{Translation}->{'Overtime (this month)'} = 'Horas extras trabajadas (este mes)';
    $Self->{Translation}->{'Overtime (total)'} = 'Total de horas extras';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Horas restantes para ausentarse por haber trabajado horas extras';
    $Self->{Translation}->{'Vacation (Days)'} = 'Vacaciones (días)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Vacaciones tomadas (este mes)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Vacaciones tomadas (total)';
    $Self->{Translation}->{'Remaining vacation'} = 'Días de vacaciones restantes';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Ausencia por enfermedad (días)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Ausencias por enfermedad (este mes)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Ausencias por enfermedad (total)';
    $Self->{Translation}->{'Previous month'} = 'Mes anterior';
    $Self->{Translation}->{'Next month'} = 'Mes siguiente';
    $Self->{Translation}->{'Weekday'} = 'Día de la semana';
    $Self->{Translation}->{'Working Hours'} = 'Horas trabajadas';
    $Self->{Translation}->{'Total worked hours'} = 'Total de horas trabajadas';
    $Self->{Translation}->{'User\'s project overview'} = 'Vista de proyecto de usuario';
    $Self->{Translation}->{'Hours (monthly)'} = 'Horas (mensuales)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Horas (tiempo de vida)';
    $Self->{Translation}->{'Grand total'} = 'Total neto';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Reporte de horas';
    $Self->{Translation}->{'Month Navigation'} = 'Navegación por mes';
    $Self->{Translation}->{'Go to date'} = 'Ir a fecha';
    $Self->{Translation}->{'User reports'} = 'Reportes de usuario';
    $Self->{Translation}->{'Monthly total'} = 'Total mensual';
    $Self->{Translation}->{'Lifetime total'} = 'Tiempo total de vida';
    $Self->{Translation}->{'Overtime leave'} = 'Ausencia por haber trabajado horas extras';
    $Self->{Translation}->{'Vacation'} = 'Vacaciones';
    $Self->{Translation}->{'Sick leave'} = 'Ausencia por enfermedad';
    $Self->{Translation}->{'Vacation remaining'} = 'Días libres restantes';
    $Self->{Translation}->{'Project reports'} = 'Reportes de proyecto';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Reporte de proyecto';
    $Self->{Translation}->{'Go to reporting overview'} = 'Ir al resumen de reportes';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        'Actualmente solo se muestran los usuarios activos en este proyecto. Para cambiar este comportamiento, por favor actualize la configuración:';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'Actualmente se muestran todos los usuarios de contabilidad de tiempo. Para cambiar este comportamiento, por favor actualize la configuración:';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Modificar la configuración del proyecto de contabilidad de tiempo.';
    $Self->{Translation}->{'Add project'} = 'Agregar proyecto';
    $Self->{Translation}->{'Go to settings overview'} = 'Ir al resumen de configuración';
    $Self->{Translation}->{'Add Project'} = 'Agregar Proyecto';
    $Self->{Translation}->{'Edit Project Settings'} = 'Modificar la Configuración del Proyecto';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Ya existe un proyecto con este nombre. Por favor, elija uno diferente.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Modificar la Configuración de la Contabilidad de Tiempo';
    $Self->{Translation}->{'Add task'} = 'Agregar tarea';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = 'Filtro para proyectos, tareas o usuarios.';
    $Self->{Translation}->{'Time periods can not be deleted.'} = 'Los períodos de tiempo no se pueden borrar.';
    $Self->{Translation}->{'Project List'} = 'Lista de Proyectos';
    $Self->{Translation}->{'Task List'} = 'Lista de Tareas';
    $Self->{Translation}->{'Add Task'} = 'Agregar Tarea';
    $Self->{Translation}->{'Edit Task Settings'} = 'Modificar la Configuración de la Tarea';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Ya existe una tarea con este nombre. Por favor, elija uno diferente.';
    $Self->{Translation}->{'User List'} = 'Lista de Usuarios';
    $Self->{Translation}->{'User Settings'} = 'Ajustes de usuario';
    $Self->{Translation}->{'User is allowed to see overtimes'} = 'El usuario puede ver horas extras';
    $Self->{Translation}->{'Show Overtime'} = 'Mostrar horas extra';
    $Self->{Translation}->{'User is allowed to create projects'} = 'El usuario tiene permitido crear proyectos';
    $Self->{Translation}->{'Allow project creation'} = 'Permitir creación de proyectos';
    $Self->{Translation}->{'User is allowed to skip time accounting'} = '';
    $Self->{Translation}->{'Allow time accounting skipping'} = '';
    $Self->{Translation}->{'If this option is selected, time accounting is effectively optional for the user.'} =
        '';
    $Self->{Translation}->{'There will be no warnings about missing entries and no entry enforcement.'} =
        '';
    $Self->{Translation}->{'Time Spans'} = 'Lapso de tiempo';
    $Self->{Translation}->{'Period Begin'} = 'Periodo de inicio';
    $Self->{Translation}->{'Period End'} = 'Periodo de finalización';
    $Self->{Translation}->{'Days of Vacation'} = 'Días de Vacaciones';
    $Self->{Translation}->{'Hours per Week'} = 'Horas por Semana';
    $Self->{Translation}->{'Authorized Overtime'} = 'Tiempo Extra Autorizado';
    $Self->{Translation}->{'Start Date'} = 'Fecha de inicio';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Por favor inserte una fecha válida.';
    $Self->{Translation}->{'End Date'} = 'Fecha de finalización';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'El periodo de finalización debe ser posterior al de inicio.';
    $Self->{Translation}->{'Leave Days'} = 'Días de ausencia';
    $Self->{Translation}->{'Weekly Hours'} = 'Horas semanales';
    $Self->{Translation}->{'Overtime'} = 'Horas extra';
    $Self->{Translation}->{'No time periods found.'} = 'No se encontraron periodos de tiempo.';
    $Self->{Translation}->{'Add time period'} = 'Agregar periodo de tiempo';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Ver registro de tiempo';
    $Self->{Translation}->{'View of '} = 'Resumen de ';
    $Self->{Translation}->{'Previous day'} = 'Día anterior';
    $Self->{Translation}->{'Next day'} = 'Día siguiente';
    $Self->{Translation}->{'No data found for this day.'} = 'No se encontraron datos de este día.';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = '¡No se pueden insertar unidades de trabajo!';
    $Self->{Translation}->{'Last Projects'} = 'Últimos Proyectos';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = '¡No se puede guardar la configuración, porque un día sólo tiene 24 horas!';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = '¡No se pueden borrar unidades de trabajo!';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        'Esta fecha está fuera del límite, pero no ha insertado todavía este día, por lo que obtiene una ( ¡solo una!) oportunidad de insertar';
    $Self->{Translation}->{'Incomplete Working Days'} = 'Días Laborales Incompletos';
    $Self->{Translation}->{'Please insert your working hours!'} = '¡Por favor inserte sus horas de trabajo!';
    $Self->{Translation}->{'Successful insert!'} = '¡Inserción exitosa!';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = '¡Error al insertar múltiples fechas!';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = '¡Se han insertado satisfactoriamente entradas para varias fechas!';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = '¡La fecha introducida no era válida! La fecha se cambió a hoy.';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        'Sin período de tiempo configurado, o la fecha especificada está fuera de los períodos de tiempo definidos.';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        '¡Por favor, póngase en contacto con el administrador de contabilidad de tiempo para actualizar sus períodos de tiempo!';
    $Self->{Translation}->{'Last Selected Projects'} = 'Últimos Proyectos seleccionados';
    $Self->{Translation}->{'All Projects'} = 'Todos los Proyectos';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = 'ReportingProject: necesita ProjectID';
    $Self->{Translation}->{'Reporting Project'} = 'Proyecto de Reportes';
    $Self->{Translation}->{'Reporting'} = 'Reportes';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = '¡No se puede actualizar la configuración del usuario!';
    $Self->{Translation}->{'Project added!'} = '¡Proyecto añadido!';
    $Self->{Translation}->{'Project updated!'} = '¡Proyecto actualizado!';
    $Self->{Translation}->{'Task added!'} = '¡Tarea añadida!';
    $Self->{Translation}->{'Task updated!'} = '¡Tarea actualizada!';
    $Self->{Translation}->{'The UserID is not valid!'} = '¡La ID de usuario no es valida!';
    $Self->{Translation}->{'Can\'t insert user data!'} = '¡No puede insertar datos de usuario!';
    $Self->{Translation}->{'Unable to add time period!'} = '¡No se puede añadir un período de tiempo!';
    $Self->{Translation}->{'Setting'} = 'Ajuste';
    $Self->{Translation}->{'User updated!'} = '¡Usuario actualizado!';
    $Self->{Translation}->{'User added!'} = '¡Usuario añadido!';
    $Self->{Translation}->{'Add a user to time accounting...'} = 'Añadir un usuario a la contabilidad del tiempo...';
    $Self->{Translation}->{'New User'} = 'Nuevo Usuario';
    $Self->{Translation}->{'Period Status'} = 'Estado del período';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = 'Ver: ¡Necesita %s!';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = 'Días laborales incompletos';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = '¡Por favor seleccione al menos un día!';
    $Self->{Translation}->{'Mass Entry'} = 'Registro Masivo';
    $Self->{Translation}->{'Please choose a reason for absence!'} = '¡Por favor escoja una razón por ausencia!';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Eliminar Registro de Contabilidad de Tiempo';
    $Self->{Translation}->{'Confirm insert'} = 'Confirmar inserción';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'Módulo de notificación de la interfaz del agente, necesario para visualizar el número de días incompletos de un usuario.';
    $Self->{Translation}->{'Default name for new actions.'} = 'Nombre por defecto para acciones nuevas.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Nombre por defecto para proyectos nuevos.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Configuración por defecto para la fecha de finalización.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Configuración por defecto para la fecha de inicio.';
    $Self->{Translation}->{'Default setting for description.'} = 'Configuración por defecto para la descripción.';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Configuración por defecto para las faltas (días de ausencia).';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Configuración por defecto para las horas extras.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Configuración por defecto para las horas semanales estándar.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Estado por defecto para acciones nuevas.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Estado por defecto para proyectos nuevos.';
    $Self->{Translation}->{'Default status for new users.'} = 'Estado por defecto para usuarios nuevos.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        'Define para cuáles proyectos es obligatoria la inserción de comentarios. Si la expresión regular coincide con el proyecto, se tiene que escribir un comentario. La expresión regular usa el parámetro smx.';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        'Determina si el módulo de estadísticas debe generar información de contabilidad de tiempo.';
    $Self->{Translation}->{'Edit time accounting settings.'} = 'Editar la configuración de Contabilidad de tiempo.';
    $Self->{Translation}->{'Edit time record.'} = 'Editar registro de tiempo.';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Especifica el número máximo de días para registrar horas de trabajo atrasadas (por ejemplo: 10 días de antigüedad).';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        'Si se habilita, solamente los usuarios que han registrado sus tiempos en el proyecto seleccionado serán mostrados';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        'Si se habilita, los elementos desplegables en la pantalla de edición se cambiaran a mordernos campos de autocompletado.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        'Si está habilitado, el filtro para los proyectos anteriores puede usarse en lugar de dos listas de proyectos (último y todos). Se podría usar solo si  imeAccounting::EnableAutoCompletion está habilitado.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        'Si está habilitado, el filtro para los proyectos previos está activo por defecto si existen proyectos previos. Se podría usar solo si EnableAutoCompletion y TimeAccounting::UseFilter está habilitado.';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        'Si se habilita, se le permitirá al usuario registrar "vacaciones", "ausencia por enfermedad", "ausencia por haber trabajado horas extra" en múltiples fechas al mismo tiempo.';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        'Número máximo de días laborales después de los cuales es obligatorio reportar las horas trabajadas.';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        'Número máximo de días laborales sin registro de horas trabajadas después de los cuales se mostrará una advertencia';
    $Self->{Translation}->{'Overview.'} = 'Vista general.';
    $Self->{Translation}->{'Project time reporting.'} = 'Reporte del tiempo del proyecto.';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'Expresiones regulares para restringir la lista de acciones, de acuerdo al proyecto seleccionado. Key contiene la expresión regular para los proyectos y Content, las expresiones regulares para las acciones.';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'Expresiones regulares para restringir la lista de proyectos, de acuerdo a los grupos de usuarios. Key contiene la expresión regular para los proyectos y Content, una lista de grupos, separados por comas.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        'Especifica si es posible insertar las horas trabajadas sin definir los tiempos de inicio y finalización de las tareas.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Este módulo hace obligatoria la inserción de horas trabajadas.';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'Módulo de notificación que muestra una advertencia si hay demasiados días sin registro de horas trabajadas.';
    $Self->{Translation}->{'Time Accounting'} = 'Contabilidad de Tiempo';
    $Self->{Translation}->{'Time accounting edit.'} = 'Editar contabilidad de tiempo';
    $Self->{Translation}->{'Time accounting overview.'} = 'Resumen de contabilidad de tiempo';
    $Self->{Translation}->{'Time accounting reporting.'} = 'Reporte de contabilidad de tiempo';
    $Self->{Translation}->{'Time accounting settings.'} = 'Ajustes de contabilidad de tiempo';
    $Self->{Translation}->{'Time accounting view.'} = 'Ver contabilidad de tiempo';
    $Self->{Translation}->{'Time accounting.'} = 'Contabilidad de tiempo.';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        'Se usa si algunas acciones reducen el número de horas trabajadas (por ejemplo: si sólo se paga la mitad del tiempo de viaje puede especificarse Key => Viaje; Content => 50).';


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
