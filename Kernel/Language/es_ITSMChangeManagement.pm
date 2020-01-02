# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::es_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category ↔ Impact ↔ Priority'} = 'Categoría ↔ Impacto ↔ Prioridad';
    $Self->{Translation}->{'Manage the priority result of combinating Category ↔ Impact.'} =
        'Gestionar la prioridad resultado de combinar Categoría ↔ Impacto.';
    $Self->{Translation}->{'Priority allocation'} = 'Asignar prioridad';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'Gestión de Notificaciones de Cambios ITSM';
    $Self->{Translation}->{'Add Notification Rule'} = 'Agregar Regla de Notificación';
    $Self->{Translation}->{'Edit Notification Rule'} = 'Editar Regla de Notificación';
    $Self->{Translation}->{'A notification should have a name!'} = '¡Las Notificaciones deben tener un nombre!';
    $Self->{Translation}->{'Name is required.'} = 'El nombre es requerido';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'Administración de Maquina de Estados';
    $Self->{Translation}->{'Select a catalog class!'} = '¡Seleccione una clase del catalogo!';
    $Self->{Translation}->{'A catalog class is required!'} = '¡Se requiere una clase del Catálogo!';
    $Self->{Translation}->{'Add a state transition'} = 'Adicionar un estado de transición';
    $Self->{Translation}->{'Catalog Class'} = 'Clase de Catálogo';
    $Self->{Translation}->{'Object Name'} = 'Nombre del Objeto';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Resumen de las transiciones de estado para';
    $Self->{Translation}->{'Delete this state transition'} = 'Eliminar este estado de transición';
    $Self->{Translation}->{'Add a new state transition for'} = 'Adicionar un estado de transición nuevo para';
    $Self->{Translation}->{'Please select a state!'} = '¡Por favor seleccione un estado!';
    $Self->{Translation}->{'Please select a next state!'} = '!Por favor seleccione el siguiente estado¡';
    $Self->{Translation}->{'Edit a state transition for'} = 'Editar un estado de transición para';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = '¿Realmente desea eliminar esta transición de estado?';

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'Agregar Cambio';
    $Self->{Translation}->{'ITSM Change'} = 'Cambio ITSM';
    $Self->{Translation}->{'Justification'} = 'Justificación';
    $Self->{Translation}->{'Input invalid.'} = 'Entrada inválida';
    $Self->{Translation}->{'Impact'} = 'Impacto';
    $Self->{Translation}->{'Requested Date'} = 'Fecha solicitada';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'Seleccionar Plantilla de Cambio';
    $Self->{Translation}->{'Time type'} = 'Tipo de fecha';
    $Self->{Translation}->{'Invalid time type.'} = 'Tipo de hora inválido.';
    $Self->{Translation}->{'New time'} = 'Nuevo intervalo de tiempo';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'Guardar Comité de Cambio como plantilla';
    $Self->{Translation}->{'go to involved persons screen'} = 'volver a pantalla de personas involucradas';
    $Self->{Translation}->{'Invalid Name'} = 'Nombre no válido';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Condiciones y Acciones';
    $Self->{Translation}->{'Delete Condition'} = 'Eliminar condición';
    $Self->{Translation}->{'Add new condition'} = 'Agregar nueva condición';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Edit Condition'} = 'Editar condición';
    $Self->{Translation}->{'Need a valid name.'} = 'Se requiere un nombre válido';
    $Self->{Translation}->{'A valid name is needed.'} = 'Se requiere un nombre valido.';
    $Self->{Translation}->{'Duplicate name:'} = 'Nombre duplicado:';
    $Self->{Translation}->{'This name is already used by another condition.'} = 'Este nombre esta siendo usado por otra Condición.';
    $Self->{Translation}->{'Matching'} = 'Coincidentes';
    $Self->{Translation}->{'Any expression (OR)'} = 'Cualquier expresión (O)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Todas las expresiones (Y)';
    $Self->{Translation}->{'Expressions'} = 'Expresiones';
    $Self->{Translation}->{'Selector'} = 'Selector';
    $Self->{Translation}->{'Operator'} = 'Operador';
    $Self->{Translation}->{'Delete Expression'} = 'Eliminar expresión';
    $Self->{Translation}->{'No Expressions found.'} = 'No se encuentran Expresiones.';
    $Self->{Translation}->{'Add new expression'} = 'Agregar expresión nueva';
    $Self->{Translation}->{'Delete Action'} = 'Eliminar Acción';
    $Self->{Translation}->{'No Actions found.'} = 'No se encuentran Acciones.';
    $Self->{Translation}->{'Add new action'} = 'Agregar acción nueva';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = '¿Realmente desea eliminar este Cambio?';

    # Template: AgentITSMChangeEdit
    $Self->{Translation}->{'Edit %s%s'} = 'Editar %s%s';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of %s%s'} = 'Histórico de %s%s';
    $Self->{Translation}->{'History Content'} = 'Contenido del historial';
    $Self->{Translation}->{'Workorder'} = 'Orden de Trabajo';
    $Self->{Translation}->{'Createtime'} = 'Fecha de Creación';
    $Self->{Translation}->{'Show details'} = 'Mostrar detalles';
    $Self->{Translation}->{'Show workorder'} = 'Mostrar Orden de Trabajo';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of %s'} = 'Información detallada de la historia';
    $Self->{Translation}->{'Modified'} = 'Modificado';
    $Self->{Translation}->{'Old Value'} = 'Valor Antiguo';
    $Self->{Translation}->{'New Value'} = 'Nuevo Valor';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Edit Involved Persons of %s%s'} = 'Editar personas involucradas de ';
    $Self->{Translation}->{'Involved Persons'} = 'Personas Involucradas';
    $Self->{Translation}->{'ChangeManager'} = 'Administrador de Cambios';
    $Self->{Translation}->{'User invalid.'} = 'El usuario no es válido.';
    $Self->{Translation}->{'ChangeBuilder'} = 'Constructor de Cambios';
    $Self->{Translation}->{'Change Advisory Board'} = 'Comités de Cambio';
    $Self->{Translation}->{'CAB Template'} = 'Plantilla de Comité de Cambio';
    $Self->{Translation}->{'Apply Template'} = 'Aplicar Plantilla';
    $Self->{Translation}->{'NewTemplate'} = 'Nueva Plantilla';
    $Self->{Translation}->{'Save this CAB as template'} = 'Salvar Comité de Cambio como plantilla';
    $Self->{Translation}->{'Add to CAB'} = 'Agregar al Comité de Cambios';
    $Self->{Translation}->{'Invalid User'} = 'Usuario inválido';
    $Self->{Translation}->{'Current CAB'} = 'Comité de Cambios Actual';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Ajustes de Contexto';
    $Self->{Translation}->{'Changes per page'} = 'Cambios por página';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'Workorder Title'} = 'Título de la Orden de Trabajo';
    $Self->{Translation}->{'Change Title'} = 'Cambiar Título';
    $Self->{Translation}->{'Workorder Agent'} = 'Agente de la Orden de Trabajo';
    $Self->{Translation}->{'Change Builder'} = 'Constructor del Cambio';
    $Self->{Translation}->{'Change Manager'} = 'Administrador del Cambio';
    $Self->{Translation}->{'Workorders'} = 'Orden de Trabajo';
    $Self->{Translation}->{'Change State'} = 'Cambiar Estado';
    $Self->{Translation}->{'Workorder State'} = 'Estado de la Orden de Trabajo';
    $Self->{Translation}->{'Workorder Type'} = 'Tipo de Orden de Trabajo';
    $Self->{Translation}->{'Requested Time'} = 'Fecha de Solicitud';
    $Self->{Translation}->{'Planned Start Time'} = 'Fecha de inicio planificada';
    $Self->{Translation}->{'Planned End Time'} = 'Fecha de fin planificada';
    $Self->{Translation}->{'Actual Start Time'} = 'Fecha actual de inicio';
    $Self->{Translation}->{'Actual End Time'} = 'Fecha actual de fin';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = '¿Realmente desea resetear este Cambio?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(ej. 10*5155 o 105658*)';
    $Self->{Translation}->{'CAB Agent'} = 'Agente del CAB';
    $Self->{Translation}->{'e.g.'} = 'ej.';
    $Self->{Translation}->{'CAB Customer'} = 'Cliente del CAB';
    $Self->{Translation}->{'ITSM Workorder Instruction'} = 'ITSM instrucción de Orden de trabajo';
    $Self->{Translation}->{'ITSM Workorder Report'} = 'ITSM informe de la Orden de trabajo';
    $Self->{Translation}->{'ITSM Change Priority'} = 'ITSM Cambio de Prioridad';
    $Self->{Translation}->{'ITSM Change Impact'} = 'ITSM Cambio de Impacto';
    $Self->{Translation}->{'Change Category'} = 'Categoría de Cambio';
    $Self->{Translation}->{'(before/after)'} = '(antes/después)';
    $Self->{Translation}->{'(between)'} = '(entre)';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Guardar Cambio como Plantilla';
    $Self->{Translation}->{'A template should have a name!'} = '¡Una plantilla debe tener un nombre!';
    $Self->{Translation}->{'The template name is required.'} = 'El nombre de la plantilla es imprescindible.';
    $Self->{Translation}->{'Reset States'} = 'Reestablecer Estados';
    $Self->{Translation}->{'Overwrite original template'} = 'Sobreescribir platilla original';
    $Self->{Translation}->{'Delete original change'} = 'Eliminar cambio original';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Mover Periodo de Tiempo';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'Información del Cambio';
    $Self->{Translation}->{'Planned Effort'} = 'Esfuerzo planeado';
    $Self->{Translation}->{'Accounted Time'} = 'Tiempo contabilizado';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Iniciador(es) de Cambio(s)';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Último cambio';
    $Self->{Translation}->{'Last changed by'} = 'Último cambio por';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Para abrir links en los siguientes bloques de descripción, podria necesitar presionar la teclas Ctrl, Cmd o Shift mientras presiona el link (depende del browser y el SO)';
    $Self->{Translation}->{'Download Attachment'} = 'Descargar Adjunto';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = 'Editar Plantilla de Comité de Cambios';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        'Esto creará un nuevo cambio a partir de esta plantilla, para que lo pueda editar y guardar.';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        'El nuevo cambio será eliminado automáticamente luego de que sea guardado como plantilla.';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        'Esto creará una nueva orden de trabajo a partir de esta plantilla, para que la pueda editar y guardar.';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        ' Se creará un cambio temporalmente, el cual contendrá la orden de trabajo.';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        'El cambio temporal y la nueva orden de trabajo se eliminarán de forma automática después de que la orden de trabajo se haya guardado como plantilla.';
    $Self->{Translation}->{'Do you want to proceed?'} = '¿Desea proceder?';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'Template ID'} = 'Plantilla ID';
    $Self->{Translation}->{'Edit Content'} = 'Editar Contenido';
    $Self->{Translation}->{'Create by'} = 'Creado por';
    $Self->{Translation}->{'Change by'} = 'Cambiado por';
    $Self->{Translation}->{'Change Time'} = 'Cambiar tiempo';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to %s%s'} = 'Añadir Orden de trabajo a %s%s';
    $Self->{Translation}->{'Instruction'} = 'Instrucción';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Tipo de orden de trabajo inválido.';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = '¡La fecha planeada de inicio debe ser anterior a la de finalización!';
    $Self->{Translation}->{'Invalid format.'} = 'Formato no válido.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Seleccionar Plantilla de Orden de Trabajo';

    # Template: AgentITSMWorkOrderAgent
    $Self->{Translation}->{'Edit Workorder Agent of %s%s'} = 'Editar Agente de la Orden de trabajo de %s%s';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = '¿Realmente desea eliminar esta orden de trabajo?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        '¡No es posible eliminar esta orden de trabajo, pues está siendo usada en al menos una Condición!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Esta orden de trabajo se usa en la(s) siguiente(s) condicion(es)';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Edit %s%s-%s'} = 'Editar %s%s-%s';
    $Self->{Translation}->{'Move following workorders accordingly'} = 'Mover las siguientes ordenes de trabajo correspondientemente';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        'Si se cambia la hora de finalización prevista de esta orden de trabajo , las horas de inicio planificadas de todas las siguientes órdenes de trabajo se cambiarán en consecuencia';

    # Template: AgentITSMWorkOrderHistory
    $Self->{Translation}->{'History of %s%s-%s'} = 'Historial de %s%s-%s';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'Edit Report of %s%s-%s'} = 'Editar informe de %s%s-%s';
    $Self->{Translation}->{'Report'} = 'Reporte';
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = '¡La hora de inicio actual debe ser anterior a la de finalización!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        '¡Debe establecer la hora de inicio actual cuando la hora de término está establecida!';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Agente Actual';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = '¿Realmente desea tomar esta orden de trabajo?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Guardar Orden de Trabajo como Plantilla';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = 'Eliminar orden de trabajo original (y el cambio que la rodea)';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Información de la Orden de Trabajo';

    # Perl Module: Kernel/Modules/AdminITSMChangeNotification.pm
    $Self->{Translation}->{'Notification Added!'} = '¡Añadida notificación!';
    $Self->{Translation}->{'Unknown notification %s!'} = '¡Notificación desconocida %s!';
    $Self->{Translation}->{'There was an error creating the notification.'} = 'Se produjo un error al crear la notificación.';

    # Perl Module: Kernel/Modules/AdminITSMStateMachine.pm
    $Self->{Translation}->{'State Transition Updated!'} = '¡Estado de transición actualizado!';
    $Self->{Translation}->{'State Transition Added!'} = '¡Estado de transición añadido!';

    # Perl Module: Kernel/Modules/AgentITSMChange.pm
    $Self->{Translation}->{'Overview: ITSM Changes'} = 'Resumen: Cambios ITSM';

    # Perl Module: Kernel/Modules/AgentITSMChangeAdd.pm
    $Self->{Translation}->{'Ticket with TicketID %s does not exist!'} = '¡El Ticket con la ID %s no existe!';
    $Self->{Translation}->{'Missing sysconfig option "ITSMChange::AddChangeLinkTicketTypes"!'} =
        'Falta la opción sysconfig "ITSMChange::AddChangeLinkTicketTypes"!';
    $Self->{Translation}->{'Was not able to add change!'} = 'No se pudo agregar el cambio!';

    # Perl Module: Kernel/Modules/AgentITSMChangeAddFromTemplate.pm
    $Self->{Translation}->{'Was not able to create change from template!'} = 'No se pudo crear el cambio desde la plantilla!';

    # Perl Module: Kernel/Modules/AgentITSMChangeCABTemplate.pm
    $Self->{Translation}->{'No ChangeID is given!'} = 'No se ha dado ChangeID';
    $Self->{Translation}->{'No change found for changeID %s.'} = 'No se encontró cambio paraChangeID %s';
    $Self->{Translation}->{'The CAB of change "%s" could not be serialized.'} = 'El CAB de cambio "%s" no pudo ser serializado.';
    $Self->{Translation}->{'Could not add the template.'} = 'No se pudo agregar la plantilla.';

    # Perl Module: Kernel/Modules/AgentITSMChangeCondition.pm
    $Self->{Translation}->{'Change "%s" not found in database!'} = '¡Cambio "%s" no se encontró en la base de datos!';
    $Self->{Translation}->{'Could not delete ConditionID %s!'} = '¡No se pudo borrar la ConditionID %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeConditionEdit.pm
    $Self->{Translation}->{'No %s is given!'} = '¡No se indica el %s!';
    $Self->{Translation}->{'Could not create new condition!'} = '¡No se pudo crear una nuevo condición!';
    $Self->{Translation}->{'Could not update ConditionID %s!'} = '¡No se pudo actualizar la ConditionID%s!';
    $Self->{Translation}->{'Could not update ExpressionID %s!'} = '¡No se pudo actualizar la ExpressionID%s!';
    $Self->{Translation}->{'Could not add new Expression!'} = '¡No se pudo añadir una nueva expresión!';
    $Self->{Translation}->{'Could not update ActionID %s!'} = '¡No se pudo actualizar ActionID%s¡';
    $Self->{Translation}->{'Could not add new Action!'} = '¡No se pudo añadir Nueva Acción!';
    $Self->{Translation}->{'Could not delete ExpressionID %s!'} = '¡No se pudo borrar ExpressionID%s!';
    $Self->{Translation}->{'Could not delete ActionID %s!'} = '¡No se pudo borrar ActionID%s!';
    $Self->{Translation}->{'Error: Unknown field type "%s"!'} = '¡Error: Tipo de campo desconocido "%s"!';
    $Self->{Translation}->{'ConditionID %s does not belong to the given ChangeID %s!'} = '¡ConditionID %s no pertenece al ChangeID%s facilitado!';

    # Perl Module: Kernel/Modules/AgentITSMChangeDelete.pm
    $Self->{Translation}->{'Change "%s" does not have an allowed change state to be deleted!'} =
        '¡Cambio "%s" no dispone de un cambio de estado permitido para ser borrado!';
    $Self->{Translation}->{'Was not able to delete the changeID %s!'} = '¡No fue posible borrar el ChangeID%s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeEdit.pm
    $Self->{Translation}->{'Was not able to update Change!'} = 'No se pudo actualizar el Cambio!';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ChangeID is given!'} = '¡No se puede mostrar el historial, ya que no se ha facilitado el ChangeID!';
    $Self->{Translation}->{'Change "%s" not found in the database!'} = '¡Cambio "%s" no se encontró en la base de datos!';
    $Self->{Translation}->{'Unknown type "%s" encountered!'} = '¡Tipo desconocido "%s" encontrado!';
    $Self->{Translation}->{'Change History'} = 'Historial de cambio';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistoryZoom.pm
    $Self->{Translation}->{'Can\'t show history zoom, no HistoryEntryID is given!'} = '¡No se puede mostrar el historial del zoom, no se ha facilitado HistoryEntryID!';
    $Self->{Translation}->{'HistoryEntry "%s" not found in database!'} = '¡Historial de entrada "%s" no se encontró en la base de datos!';

    # Perl Module: Kernel/Modules/AgentITSMChangeInvolvedPersons.pm
    $Self->{Translation}->{'Was not able to update Change CAB for Change %s!'} = '¡No se pudo actualizar el CAB de Cambio para el Cambio %s!';
    $Self->{Translation}->{'Was not able to update Change %s!'} = '¡No fue posible actualizar el Cambio %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeManager.pm
    $Self->{Translation}->{'Overview: ChangeManager'} = 'Resumen: CambioManager';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyCAB.pm
    $Self->{Translation}->{'Overview: My CAB'} = 'Resumen: Mi CAB';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyChanges.pm
    $Self->{Translation}->{'Overview: My Changes'} = 'Resumen: Mis Cambios';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyWorkOrders.pm
    $Self->{Translation}->{'Overview: My Workorders'} = 'Resumen: Mis ordenes de trabajo';

    # Perl Module: Kernel/Modules/AgentITSMChangePIR.pm
    $Self->{Translation}->{'Overview: PIR'} = 'Resumen: PIR';

    # Perl Module: Kernel/Modules/AgentITSMChangePSA.pm
    $Self->{Translation}->{'Overview: PSA'} = 'Resumen: PSA';

    # Perl Module: Kernel/Modules/AgentITSMChangePrint.pm
    $Self->{Translation}->{'WorkOrder "%s" not found in database!'} = '¡Orden de trabajo "%s" no se encontró en la base de datos!';
    $Self->{Translation}->{'Can\'t create output, as the workorder is not attached to a change!'} =
        '¡No se puede crear la salida, ya que la Orden de trabajo no está adjunto a un cambio!';
    $Self->{Translation}->{'Can\'t create output, as no ChangeID is given!'} = '¡No se puede crear la salida, ya que no se ha facilitado el ChangeID!';
    $Self->{Translation}->{'unknown change title'} = 'Título del cambio desconocido';
    $Self->{Translation}->{'ITSM Workorder'} = 'Orden de Trabajo ITSM';
    $Self->{Translation}->{'WorkOrderNumber'} = 'Número de la Orden de Trabajo';
    $Self->{Translation}->{'WorkOrderTitle'} = 'Título de la Orden de Trabajo';
    $Self->{Translation}->{'unknown workorder title'} = 'Título de la Orden de trabajo desconocido';
    $Self->{Translation}->{'ChangeState'} = 'Estado del Cambio';
    $Self->{Translation}->{'PlannedEffort'} = 'Esfuerzo Planeado';
    $Self->{Translation}->{'CAB Agents'} = 'Agentes CAB';
    $Self->{Translation}->{'CAB Customers'} = 'Clientes CAB';
    $Self->{Translation}->{'RequestedTime'} = 'Fecha Solicitada';
    $Self->{Translation}->{'PlannedStartTime'} = 'Fecha de Inicio Planeado';
    $Self->{Translation}->{'PlannedEndTime'} = 'Fecha de Finalización Planeada';
    $Self->{Translation}->{'ActualStartTime'} = 'Fecha de Inicio Real';
    $Self->{Translation}->{'ActualEndTime'} = 'Fecha de Finalización Real';
    $Self->{Translation}->{'ChangeTime'} = 'Fecha del cambio';
    $Self->{Translation}->{'ChangeNumber'} = 'Número del Cambio';
    $Self->{Translation}->{'WorkOrderState'} = 'Estado de la Orden de Trabajo';
    $Self->{Translation}->{'WorkOrderType'} = 'Tipo de Orden de Trabajo';
    $Self->{Translation}->{'WorkOrderAgent'} = 'Agente de la Orden de Trabajo';
    $Self->{Translation}->{'ITSM Workorder Overview (%s)'} = 'ITSM Resumen de la orden de trabajo (%s)';

    # Perl Module: Kernel/Modules/AgentITSMChangeReset.pm
    $Self->{Translation}->{'Was not able to reset WorkOrder %s of Change %s!'} = '¡No fue posible restablecer la Orden de trabajo %s del cambio %s!';
    $Self->{Translation}->{'Was not able to reset Change %s!'} = '¡No fue posible restablecer el cambio%s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeSchedule.pm
    $Self->{Translation}->{'Overview: Change Schedule'} = 'Resumen: Cambiar programación';

    # Perl Module: Kernel/Modules/AgentITSMChangeSearch.pm
    $Self->{Translation}->{'Change Search'} = 'Cambiar Búsqueda';
    $Self->{Translation}->{'ChangeTitle'} = 'Título del Cambio';
    $Self->{Translation}->{'WorkOrders'} = 'Orden de Trabajo';
    $Self->{Translation}->{'Change Search Result'} = 'Cambiar resultado de búsqueda';
    $Self->{Translation}->{'Change Number'} = 'Cambiar Número';
    $Self->{Translation}->{'Work Order Title'} = 'Título Orden de trabajo';
    $Self->{Translation}->{'Change Description'} = 'Cambiar descripción';
    $Self->{Translation}->{'Change Justification'} = 'Cambiar Justificación';
    $Self->{Translation}->{'WorkOrder Instruction'} = 'Instrucción Orden de trabajo';
    $Self->{Translation}->{'WorkOrder Report'} = 'Reporte Orden de trabajo';
    $Self->{Translation}->{'Change Priority'} = 'Cambiar Prioridad';
    $Self->{Translation}->{'Change Impact'} = 'Cambiar Impacto';
    $Self->{Translation}->{'Created By'} = 'Creador por';
    $Self->{Translation}->{'WorkOrder State'} = 'Estado Orden de trabajo';
    $Self->{Translation}->{'WorkOrder Type'} = 'Tipo de Orden de trabajo';
    $Self->{Translation}->{'WorkOrder Agent'} = 'Agente de Orden de trabajo';
    $Self->{Translation}->{'before'} = 'antes ';

    # Perl Module: Kernel/Modules/AgentITSMChangeTemplate.pm
    $Self->{Translation}->{'The change "%s" could not be serialized.'} = 'El cambio "%s" no pudo ser serializado.';
    $Self->{Translation}->{'Could not update the template "%s".'} = 'No se pudo actualizar la plantilla. "%s".';
    $Self->{Translation}->{'Could not delete change "%s".'} = 'No se pudo eliminar el cambio "%s".';

    # Perl Module: Kernel/Modules/AgentITSMChangeTimeSlot.pm
    $Self->{Translation}->{'The change can\'t be moved, as it has no workorders.'} = 'El cambio no puede ser movido, ya que no tiene órdenes de trabajo.';
    $Self->{Translation}->{'Add a workorder first.'} = 'Añadir primero una orden de trabajo.';
    $Self->{Translation}->{'Can\'t move a change which already has started!'} = '¡No se puede mover una cambio que ya ha comenzado!';
    $Self->{Translation}->{'Please move the individual workorders instead.'} = 'Por favor, mueva las órdenes de trabajo individuales en su lugar.';
    $Self->{Translation}->{'The current %s could not be determined.'} = 'El actual %s no pudo ser determinado.';
    $Self->{Translation}->{'The %s of all workorders has to be defined.'} = 'El %s de todas las órdenes de trabajo tiene que ser definido.';
    $Self->{Translation}->{'Was not able to move time slot for workorder #%s!'} = '¡No se pudo mover el intervalo de tiempo para el orden de trabajo #%s!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateDelete.pm
    $Self->{Translation}->{'You need %s permission!'} = '¡Necesita permiso %s!';
    $Self->{Translation}->{'No TemplateID is given!'} = '¡No se ha proporcionado TemplateID!';
    $Self->{Translation}->{'Template "%s" not found in database!'} = '¡Plantilla "%s" no se encontró en la base de datos!';
    $Self->{Translation}->{'Was not able to delete the template %s!'} = '¡No se pudo eliminar la plantilla %s!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEdit.pm
    $Self->{Translation}->{'Was not able to update Template %s!'} = 'No se pudo actualizar la Plantilla %s!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditCAB.pm
    $Self->{Translation}->{'Was not able to update Template "%s"!'} = 'No se pudo actualizar la Plantilla "%s"!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditContent.pm
    $Self->{Translation}->{'Was not able to create change!'} = '¡No fue posible crear el cambio!';
    $Self->{Translation}->{'Was not able to create workorder from template!'} = '¡No fue posible crear la orden de trabajo desde la plantilla!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateOverview.pm
    $Self->{Translation}->{'Overview: Template'} = 'Resumen: Plantilla';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAdd.pm
    $Self->{Translation}->{'You need %s permissions on the change!'} = '¡Necesita %s permisos en el cambio!';
    $Self->{Translation}->{'Was not able to add workorder!'} = '¡No fue posible añadir Orden de trabajo!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAgent.pm
    $Self->{Translation}->{'No WorkOrderID is given!'} = '¡No se ha proporcionado WorkOrderID!';
    $Self->{Translation}->{'Was not able to set the workorder agent of the workorder "%s" to empty!'} =
        '¡No fue posible configurar el agente de orden de trabajo del pedido de trabajo "%s" para que se vacíe!';
    $Self->{Translation}->{'Was not able to update the workorder "%s"!'} = '¡No se pudo actualizar el orden de trabajo "%s"!';
    $Self->{Translation}->{'Could not find Change for WorkOrder %s!'} = '¡No se pudo encontrar Cambio para Orden de trabajo!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderDelete.pm
    $Self->{Translation}->{'Was not able to delete the workorder %s!'} = '¡No se pudo eliminar la orden de trabajo %s!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderEdit.pm
    $Self->{Translation}->{'Was not able to update WorkOrder %s!'} = '¡No fue posible actualizar la Orden de trabajo %s!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no WorkOrderID is given!'} = '¡No se puede mostrar el historial, ya que no se ha proporcionado WorkOrderID!';
    $Self->{Translation}->{'WorkOrder "%s" not found in the database!'} = '¡Orden de trabajo "%s" no se encontró en la base de datos!';
    $Self->{Translation}->{'WorkOrder History'} = 'Historial de la Orden de trabajo';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistoryZoom.pm
    $Self->{Translation}->{'History entry "%s" not found in the database!'} = '¡Entrada del historial "%s" no se encontró en la base de datos!';
    $Self->{Translation}->{'WorkOrder History Zoom'} = 'Detalle del historial de la Orden de trabajo';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTake.pm
    $Self->{Translation}->{'Was not able to take the workorder %s!'} = '¡No fue posible tomar la Orden de trabajo %s!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTemplate.pm
    $Self->{Translation}->{'The workorder "%s" could not be serialized.'} = 'La orden de trabajo"%s" no pudo ser serializada.';

    # Perl Module: Kernel/Output/HTML/Layout/ITSMChange.pm
    $Self->{Translation}->{'Need config option %s!'} = '¡Necesita la opción de configuración %s!';
    $Self->{Translation}->{'Config option %s needs to be a HASH ref!'} = '¡La opción de configuración %s necesita ser una ref HASH!';
    $Self->{Translation}->{'No config option found for the view "%s"!'} = '¡No se ha encontrado ninguna opcón de configuración para la vista "%s"!';
    $Self->{Translation}->{'Title: %s | Type: %s'} = 'Título: %s | Tipo: %s';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyCAB.pm
    $Self->{Translation}->{'My CABs'} = 'Mis Comités de Cambio (CABs)';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyChanges.pm
    $Self->{Translation}->{'My Changes'} = 'Mis Cambios';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyWorkOrders.pm
    $Self->{Translation}->{'My Work Orders'} = 'Mis Órdenes de Trabajo';

    # Perl Module: Kernel/System/ITSMChange/History.pm
    $Self->{Translation}->{'%s: %s'} = '%s:%s';
    $Self->{Translation}->{'New Action (ID=%s)'} = 'Nueva acción (ID=%s)';
    $Self->{Translation}->{'Action (ID=%s) deleted'} = 'Acción (ID=%s) eliminada';
    $Self->{Translation}->{'All Actions of Condition (ID=%s) deleted'} = 'Todas las acciones de la Condición (ID=%s) eliminadas';
    $Self->{Translation}->{'Action (ID=%s) executed: %s'} = 'Acción (ID=%s) ejecutada: %s';
    $Self->{Translation}->{'%s (Action ID=%s): (new=%s, old=%s)'} = '%s (Acción ID=%s): (nuevo=%s, viejo=%s)';
    $Self->{Translation}->{'Change (ID=%s) reached actual end time.'} = 'Cambio (ID=%s) alcanzó la hora de finalización real.';
    $Self->{Translation}->{'Change (ID=%s) reached actual start time.'} = 'El cambio (ID=%s) alcanzó la hora de inicio real.';
    $Self->{Translation}->{'New Change (ID=%s)'} = 'Nuevo Cambio (ID=%s)';
    $Self->{Translation}->{'New Attachment: %s'} = 'Nuevo archivo adjunto: %s';
    $Self->{Translation}->{'Deleted Attachment %s'} = 'Adjunto borrado %s';
    $Self->{Translation}->{'CAB Deleted %s'} = 'CAB borrado %s';
    $Self->{Translation}->{'%s: (new=%s, old=%s)'} = '%s:(nuevo=%s, viejo=%s)';
    $Self->{Translation}->{'Link to %s (ID=%s) added'} = 'Enlace a %s (ID=%s) añadido';
    $Self->{Translation}->{'Link to %s (ID=%s) deleted'} = 'Enlace a %s(ID=%s) borrado';
    $Self->{Translation}->{'Notification sent to %s (Event: %s)'} = 'Notificación enviada a %s(Event:%s)';
    $Self->{Translation}->{'Change (ID=%s) reached planned end time.'} = 'Cambio (ID=%s) alcanzó el tiempo de finalización planificado.';
    $Self->{Translation}->{'Change (ID=%s) reached planned start time.'} = 'El cambio (ID =%s) alcanzó la hora de inicio planificada.';
    $Self->{Translation}->{'Change (ID=%s) reached requested time.'} = 'El cambio (ID=%s) alcanzó el tiempo solicitado.';
    $Self->{Translation}->{'New Condition (ID=%s)'} = 'Nueva Condición (ID=%s)';
    $Self->{Translation}->{'Condition (ID=%s) deleted'} = 'Condición (ID=%s) borrada';
    $Self->{Translation}->{'All Conditions of Change (ID=%s) deleted'} = 'Todas las condiciones de Cambio (ID=%s) borrado';
    $Self->{Translation}->{'%s (Condition ID=%s): (new=%s, old=%s)'} = '%s (Condición ID=%s): (nuevo=%s, viejo%s)';
    $Self->{Translation}->{'New Expression (ID=%s)'} = 'Nueva expresión (ID=%s)';
    $Self->{Translation}->{'Expression (ID=%s) deleted'} = 'Expresión (ID=%s) borrada';
    $Self->{Translation}->{'All Expressions of Condition (ID=%s) deleted'} = 'Todas las expresiones de Condición (ID=%s) borradas';
    $Self->{Translation}->{'%s (Expression ID=%s): (new=%s, old=%s)'} = '%s(Expresión ID=%s): (nuevo=%s, viejo=%s)';
    $Self->{Translation}->{'Workorder (ID=%s) reached actual end time.'} = 'Orden de trabajo (ID =%s) alcanzó el tiempo real de finalización.';
    $Self->{Translation}->{'Workorder (ID=%s) reached actual start time.'} = 'Orden de trabajo (ID=%s) llegó a la hora de inicio real.';
    $Self->{Translation}->{'New Workorder (ID=%s)'} = 'Nueva Orden de trabajo (ID=%s)';
    $Self->{Translation}->{'New Attachment for WorkOrder: %s'} = 'Nuevo adjunto para Orden de trabajo:%s';
    $Self->{Translation}->{'(ID=%s) New Attachment for WorkOrder: %s'} = '(ID=%s) Nuevo adjunto para Orden de trabajo: %s';
    $Self->{Translation}->{'Deleted Attachment from WorkOrder: %s'} = 'Borrado adjunto de Orden de trabajo: %s';
    $Self->{Translation}->{'(ID=%s) Deleted Attachment from WorkOrder: %s'} = '(ID=%s) Borrado adjunto de Orden de trabajo: %s';
    $Self->{Translation}->{'New Report Attachment for WorkOrder: %s'} = 'Nuevo anexo adjunto para Orden de trabajo: %s';
    $Self->{Translation}->{'(ID=%s) New Report Attachment for WorkOrder: %s'} = '(ID=%s) Nuevo anexo adjunto para Orden de trabajo: %s';
    $Self->{Translation}->{'Deleted Report Attachment from WorkOrder: %s'} = 'Borrado anexo adjunto de Orden de trabajo: %s';
    $Self->{Translation}->{'(ID=%s) Deleted Report Attachment from WorkOrder: %s'} = '(ID=%s) Borrado anexo adjunto de Orden de trabajo: %s';
    $Self->{Translation}->{'Workorder (ID=%s) deleted'} = 'Orden de trabajo (ID=%s) borrada';
    $Self->{Translation}->{'(ID=%s) Link to %s (ID=%s) added'} = '(ID=%s) enlace a %s(ID=%s) añadido';
    $Self->{Translation}->{'(ID=%s) Link to %s (ID=%s) deleted'} = '(ID=%s) enlace a %s (ID=%s) borrado';
    $Self->{Translation}->{'(ID=%s) Notification sent to %s (Event: %s)'} = '(ID=%s) Notificación enviada a %s (Evento: %s)';
    $Self->{Translation}->{'Workorder (ID=%s) reached planned end time.'} = 'Orden de trabajo (ID =%s) alcanzó la hora de finalización planificada.';
    $Self->{Translation}->{'Workorder (ID=%s) reached planned start time.'} = 'Orden de trabajo (ID=%s) alcanzó la hora de inicio planificada.';
    $Self->{Translation}->{'(ID=%s) %s: (new=%s, old=%s)'} = '(ID=%s)%s:(nuevo=%s, viejo=%s)';

    # Perl Module: Kernel/System/ITSMChange/ITSMCondition/Object/ITSMWorkOrder.pm
    $Self->{Translation}->{'all'} = 'todo';
    $Self->{Translation}->{'any'} = 'cualquiera';

    # Perl Module: Kernel/System/ITSMChange/Notification.pm
    $Self->{Translation}->{'Previous Change Builder'} = 'Anterior Constructor del cambio';
    $Self->{Translation}->{'Previous Change Manager'} = 'Anterior Gestor del Cambio';
    $Self->{Translation}->{'Workorder Agents'} = 'Agentes de la Orden de Trabajo';
    $Self->{Translation}->{'Previous Workorder Agent'} = 'Anterior Agente de la Orden de Trabajo';
    $Self->{Translation}->{'Change Initiators'} = 'Iniciadores del Cambio';
    $Self->{Translation}->{'Group ITSMChange'} = 'Grupo ITSMChange';
    $Self->{Translation}->{'Group ITSMChangeBuilder'} = 'Grupo ITSMChangeBuilder';
    $Self->{Translation}->{'Group ITSMChangeManager'} = 'Grupo ITSMChangeManager';

    # Database XML Definition: ITSMChangeManagement.sopm
    $Self->{Translation}->{'requested'} = 'solicitado';
    $Self->{Translation}->{'pending approval'} = 'aprobación pendiente';
    $Self->{Translation}->{'rejected'} = 'rechazado';
    $Self->{Translation}->{'approved'} = 'aprobado';
    $Self->{Translation}->{'in progress'} = 'en progreso';
    $Self->{Translation}->{'pending pir'} = 'revisión post-implementación pendiente';
    $Self->{Translation}->{'successful'} = 'exitoso';
    $Self->{Translation}->{'failed'} = 'fallido';
    $Self->{Translation}->{'canceled'} = 'cancelada';
    $Self->{Translation}->{'retracted'} = 'devuelto';
    $Self->{Translation}->{'created'} = 'creado';
    $Self->{Translation}->{'accepted'} = 'aceptada';
    $Self->{Translation}->{'ready'} = 'lista';
    $Self->{Translation}->{'approval'} = 'aprobación';
    $Self->{Translation}->{'workorder'} = 'orden de trabajo';
    $Self->{Translation}->{'backout'} = 'plan de vuelta atrás';
    $Self->{Translation}->{'decision'} = 'decisión';
    $Self->{Translation}->{'pir'} = 'revisión post-implementación';
    $Self->{Translation}->{'ChangeStateID'} = 'ChangeStateID';
    $Self->{Translation}->{'CategoryID'} = 'CategoryID';
    $Self->{Translation}->{'ImpactID'} = 'ImpactoID';
    $Self->{Translation}->{'PriorityID'} = 'PrioridadID';
    $Self->{Translation}->{'ChangeManagerID'} = 'GestorCambioID';
    $Self->{Translation}->{'ChangeBuilderID'} = 'ConstructorCambioID';
    $Self->{Translation}->{'WorkOrderStateID'} = 'EstadoOrdenTrabajoID';
    $Self->{Translation}->{'WorkOrderTypeID'} = 'TipoOrdenTrabajoID';
    $Self->{Translation}->{'WorkOrderAgentID'} = 'AgenteOrdenTrabajoID';
    $Self->{Translation}->{'is'} = 'es';
    $Self->{Translation}->{'is not'} = 'no es';
    $Self->{Translation}->{'is empty'} = 'está vacío(a)';
    $Self->{Translation}->{'is not empty'} = 'no está vacío(a)';
    $Self->{Translation}->{'is greater than'} = 'es mayor que';
    $Self->{Translation}->{'is less than'} = 'es menor que';
    $Self->{Translation}->{'is before'} = 'está antes';
    $Self->{Translation}->{'is after'} = 'está después';
    $Self->{Translation}->{'contains'} = 'contiene';
    $Self->{Translation}->{'not contains'} = 'no contiene';
    $Self->{Translation}->{'begins with'} = 'comienza con';
    $Self->{Translation}->{'ends with'} = 'termina con';
    $Self->{Translation}->{'set'} = 'configurada';

    # JS File: ITSM.Agent.ChangeManagement.Condition
    $Self->{Translation}->{'Do you really want to delete this expression?'} = '¿De verdad quieres eliminar esta expresión?';
    $Self->{Translation}->{'Do you really want to delete this action?'} = '¿De verdad quieres eliminar esta acción?';
    $Self->{Translation}->{'Do you really want to delete this condition?'} = '¿De verdad quieres eliminar esta condición?';

    # JS File: ITSM.Agent.ChangeManagement.ConfirmDialog
    $Self->{Translation}->{'Ok'} = 'Ok';

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        'Una lista de los agentes que tienen permiso para tomar órdenes de trabajo. Key es un nombre de inicio de sesión. Content puede ser 0 ó 1.';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        'Una lista de estados para las órdenes de trabajo, misma que será asignada a ActualStartTime, si para este punto seguía vacío.';
    $Self->{Translation}->{'Actual end time'} = 'Hora de finalización actual';
    $Self->{Translation}->{'Actual start time'} = 'Hora de inicio actual';
    $Self->{Translation}->{'Add Workorder'} = 'Agregar Orden de Trabajo';
    $Self->{Translation}->{'Add Workorder (from Template)'} = 'Añadir Orden de trabajo (desde Plantilla)';
    $Self->{Translation}->{'Add a change from template.'} = 'Agregar un cambio desde una plantilla.';
    $Self->{Translation}->{'Add a change.'} = 'Añadir un cambio.';
    $Self->{Translation}->{'Add a workorder (from template) to the change.'} = 'Añadir una Orden de trabajo (desde Plantilla) para el cambio.';
    $Self->{Translation}->{'Add a workorder to the change.'} = 'Añadir una orden de trabajo para el cambio.';
    $Self->{Translation}->{'Add from template'} = 'Agregar desde plantilla';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = 'Administrar la matriz CIP.';
    $Self->{Translation}->{'Admin of the state machine.'} = 'Administrar la máquina de estados.';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        'Módulo de notificación de la interface del Agente para mostrar el número de change advisory boards.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        'Módulo de notificación de la interface del Agente para mostrar el número de  cambios administrados por el usuario.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        'Módulo de notificación de la interface del Agente para mostrar el número de cambios.';
    $Self->{Translation}->{'Agent interface notification module to see the number of workorders.'} =
        'Módulo de notificación de la interfaz de agente para ver el número de órdenes de trabajo.';
    $Self->{Translation}->{'CAB Member Search'} = 'Búsqueda de miembros CAB';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        'Tiempo caché en minutos para las barras de tareas de gestión del cambio. Por defecto:  3 horas (180 minutos).';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        'Tiempo caché en minutos para la gestión del cambio. Por defecto: 5 días (7200 minutos).';
    $Self->{Translation}->{'Change CAB Templates'} = 'Cambiar las plantillas de CAB';
    $Self->{Translation}->{'Change History.'} = 'Cambiar Historial.';
    $Self->{Translation}->{'Change Involved Persons.'} = 'Cambiar personas involucradas.';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = 'Cambie Límite Vista General "Pequeña"';
    $Self->{Translation}->{'Change Overview.'} = 'Cambiar Resumen.';
    $Self->{Translation}->{'Change Print.'} = 'Cambiar Impresión.';
    $Self->{Translation}->{'Change Schedule'} = 'Cambiar Programación';
    $Self->{Translation}->{'Change Schedule.'} = 'Cambiar Programación.';
    $Self->{Translation}->{'Change Settings'} = 'Cambiar Configuraciones.';
    $Self->{Translation}->{'Change Zoom'} = 'Cambiar Detalle';
    $Self->{Translation}->{'Change Zoom.'} = 'Ampliación del Cambio.';
    $Self->{Translation}->{'Change and Workorder Templates'} = 'Plantillas de Cambio y Órdenes de trabajo';
    $Self->{Translation}->{'Change and workorder templates edited by this user.'} = 'Plantillas de Cambio y Órdenes de trabajo editados por este usuario.';
    $Self->{Translation}->{'Change area.'} = 'Cambiar area.';
    $Self->{Translation}->{'Change involved persons of the change.'} = 'El cambio involucró a las personas del cambio.';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small".'} = 'Límite de cambio por página para Cambio Descripción general "Pequeño".';
    $Self->{Translation}->{'Change number'} = 'Cambiar numero';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = 'Cambie el enrutador del backend de búsqueda de la interfaz de agente.';
    $Self->{Translation}->{'Change state'} = 'Cambiar estado';
    $Self->{Translation}->{'Change time'} = 'Cambiar hora';
    $Self->{Translation}->{'Change title'} = 'Cambiar título';
    $Self->{Translation}->{'Condition Edit'} = 'Editar Condición';
    $Self->{Translation}->{'Condition Overview'} = 'Resumen de la condición';
    $Self->{Translation}->{'Configure which screen should be shown after a new workorder has been created.'} =
        'Configure que pantalla se mostrará después de que una nueva orden de trabajo ha sido creada.';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        'Configura el intervalo de envío de notificaciones cuando alguno de los valores del tiempo, como la fecha de inicio planeada, se alcanzan/sobrepasan.';
    $Self->{Translation}->{'Create Change'} = 'Crear un Cambio';
    $Self->{Translation}->{'Create Change (from Template)'} = 'Crear Cambio (desde Plantilla) ';
    $Self->{Translation}->{'Create a change (from template) from this ticket.'} = 'Crear un cambio (desde Plantilla) desde este ticket.';
    $Self->{Translation}->{'Create a change from this ticket.'} = 'Crear un cambio desde este ticket.';
    $Self->{Translation}->{'Create and manage ITSM Change Management notifications.'} = 'Crear y gestionar notificaciones de Gestión del Cambio ITSM.';
    $Self->{Translation}->{'Create and manage change notifications.'} = 'Crear y gestionar notificaciones de cambio.';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        'Tipo default para las órdenes de trabajo. Este registro debe existir en la clase \'ITSM::ChangeManagement::WorkOrder::Type\' del catálogo general.';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'Definir acciones donde está disponible un botón de configuración en el widget de objetos vinculados (LinkObject::ViewMode = "complex"). Tenga en cuenta que estas acciones deben haber registrado los siguientes archivos JS y CSS: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js y Core.Agent.LinkObject.js.';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = 'Define las señales para cada estado de las órdenes de trabajo.';
    $Self->{Translation}->{'Define which columns are shown in the linked Changes widget (LinkObject::ViewMode = "complex"). Note: Only Change attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'Definir qué columnas se muestran en el widget de Cambios vinculado (LinkObject::ViewMode = "complex"). Nota: Solo se permiten los atributos de cambio para las columnas predeterminadas. Configuraciones posibles: 0 = Deshabilitado, 1 = Disponible, 2 = Habilitado por defecto.';
    $Self->{Translation}->{'Define which columns are shown in the linked Workorder widget (LinkObject::ViewMode = "complex"). Note: Only Workorder attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'Definir qué columnas se muestran en el widget Orden de trabajo vinculado (LinkObject::ViewMode = "complex"). Nota: solo los atributos Workorder están permitidos para DefaultColumns. Configuraciones posibles: 0 = Deshabilitado, 1 = Disponible, 2 = Habilitado por defecto.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        'Define un módulo de resumen para mostrar la vista pequeña de una lista de cambios.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        'Define un módulo de resumen para mostrar la vista pequeña de una lista de plantillas.';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = 'Define si será posible imprimir el tiempo contabilizado.';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = 'Define si será posible imprimir el esfuerzo planeado.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        'Define si los estados finales de cambio alcanzables (según lo definido por la máquina de estado) deben permitirse si un cambio está en un estado bloqueado.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        'Define si se deben permitir los estados finales de orden de trabajo alcanzables (según lo definido por la máquina de estado) si un pedido de trabajo está en un estado bloqueado.';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = 'Determina si el tiempo contabilizado debe mostrarse.';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = 'Determina si las fechas de inicio y finalización reales deben fijarse.';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        'Define si las funciones de búsqueda de cambio y búsqueda de orden de trabajo podrían usar el espejo DB.';
    $Self->{Translation}->{'Defines if the change state can be set in the change edit screen of the agent interface.'} =
        'Define si el estado del cambio puede fijarse en la pantalla de edición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines if the planned effort should be shown.'} = 'Determina si el esfuerzo planeado debe mostrarse.';
    $Self->{Translation}->{'Defines if the requested date should be print by customer.'} = 'Define si la fecha solicitada debe ser impresa por el cliente.';
    $Self->{Translation}->{'Defines if the requested date should be searched by customer.'} =
        'Define si la fecha solicitada debe ser buscada por el cliente.';
    $Self->{Translation}->{'Defines if the requested date should be set by customer.'} = 'Define si la fecha solicitada debe ser establecida por el cliente.';
    $Self->{Translation}->{'Defines if the requested date should be shown by customer.'} = 'Define si la fecha solicitada debe ser mostrada por el cliente.';
    $Self->{Translation}->{'Defines if the workorder state should be shown.'} = 'Determina si el estado de la orden de trabajo debe mostrarse.';
    $Self->{Translation}->{'Defines if the workorder title should be shown.'} = 'Determina si el título de la orden de trabajo debe mostrarse.';
    $Self->{Translation}->{'Defines shown graph attributes.'} = 'Define los atributos mostrados en las gráficas.';
    $Self->{Translation}->{'Defines that only changes containing Workorders linked with services, which the customer user has permission to use will be shown. Any other changes will not be displayed.'} =
        'Define que únicamente se mostrarán los cambios que contienen órdenes de trabajo, vinculadas con servicios, que el cliente tiene permiso de usar. El resto de los cambios no se desplegará.';
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = 'Define los estados de cambio que se permitirán eliminar.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change PSA overview.'} =
        'Define los estados de los cambios que serán utilizados como filtros en la vista de resumen de la PSA de los cambios.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change Schedule overview.'} =
        'Define los estados de los cambios que serán utilizados como filtros en la vista de resumen de la agenda de los cambios.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyCAB overview.'} =
        'Define los estados de los cambios que serán utilizados como filtros en la vista de resumen de MyCAB.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyChanges overview.'} =
        'Define los estados de los cambios que serán utilizados como filtros en la vista de resumen de MyChanges.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change manager overview.'} =
        'Define los estados de los cambios que serán utilizados como filtros en la vista de resumen de la gestión de cambios.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change overview.'} =
        'Define los estados de los cambios que serán usados como filtros en los resúmenes de dichos cambios.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the customer change schedule overview.'} =
        'Define los estados de los cambios que serán utilizados como filtros en la vista de resumen de edición de la agenda, en la interfaz del cliente.';
    $Self->{Translation}->{'Defines the default change title for a dummy change which is needed to edit a workorder template.'} =
        'Define el título por defecto de un cambio que será utilizado para un cambio temporal, el cual se necesita para editar una plantilla de orden de trabajo.';
    $Self->{Translation}->{'Defines the default sort criteria in the change PSA overview.'} =
        'Define el criterio de ordenamiento por default para la vista de resumem de la PSA de los cambios.';
    $Self->{Translation}->{'Defines the default sort criteria in the change manager overview.'} =
        'Define el criterio de ordenamiento por default para la vista de resumem del administrador de los cambios.';
    $Self->{Translation}->{'Defines the default sort criteria in the change overview.'} = 'Define el criterio de ordenamiento por default para la vista de resumem de los cambios.';
    $Self->{Translation}->{'Defines the default sort criteria in the change schedule overview.'} =
        'Define el criterio de ordenamiento por default para la vista de resumem de la agenda de los cambios.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyCAB overview.'} =
        'Define el criterio de ordenamiento por default de los cambios para la vista de resumem de MyCAB.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyChanges overview.'} =
        'Define el criterio de ordenamiento por default de los cambios para la vista de resumem de MyChanges.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyWorkorders overview.'} =
        'Define el criterio de ordenamiento por default de los cambios para la vista de resumem de MyWorkorders.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the PIR overview.'} =
        'Define el criterio de ordenamiento por default de los cambios para la vista de resumem de las PIR.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the customer change schedule overview.'} =
        'Define el criterio de ordenamiento por default de los cambios para la vista de resumem de edición de la agenda, en la interfaz del cliente.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the template overview.'} =
        'Define el criterio de ordenamiento por default de los cambios para la vista de resumem de las plantillas.';
    $Self->{Translation}->{'Defines the default sort order in the MyCAB overview.'} = 'Define el parámetro de ordenamiento por default para la vista de resumem de MyCAB.';
    $Self->{Translation}->{'Defines the default sort order in the MyChanges overview.'} = 'Define el parámetro de ordenamiento por default para la vista de resumem de MyChanges.';
    $Self->{Translation}->{'Defines the default sort order in the MyWorkorders overview.'} =
        'Define el parámetro de ordenamiento por default para la vista de resumem de MyWorkorders.';
    $Self->{Translation}->{'Defines the default sort order in the PIR overview.'} = 'Define el parámetro de ordenamiento por default para la vista de resumem de las PIR.';
    $Self->{Translation}->{'Defines the default sort order in the change PSA overview.'} = 'Define el parámetro de ordenamiento por default para la vista de resumem de la PSA de los cambios.';
    $Self->{Translation}->{'Defines the default sort order in the change manager overview.'} =
        'Define el parámetro de ordenamiento por default para la vista de resumem de la agenda de los cambios.';
    $Self->{Translation}->{'Defines the default sort order in the change overview.'} = 'Define el parámetro de ordenamiento por default en la vista de resumen de los cambios.';
    $Self->{Translation}->{'Defines the default sort order in the change schedule overview.'} =
        'Define el parámetro de ordenamiento por default para la vista de resumem de la agenda de los cambios.';
    $Self->{Translation}->{'Defines the default sort order in the customer change schedule overview.'} =
        'Define el parámetro de ordenamiento por default para la vista de resumem de edición de la angenda, en la interfaz del cliente.';
    $Self->{Translation}->{'Defines the default sort order in the template overview.'} = 'Define el parámetro de ordenamiento por default para la vista de resumem de las plantillas.';
    $Self->{Translation}->{'Defines the default value for the category of a change.'} = 'Define el valor por default de la categoría de los cambios.';
    $Self->{Translation}->{'Defines the default value for the impact of a change.'} = 'Define el valor por default del impacto de los cambios.';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for change attributes used in the change condition edit screen of the agent interface. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Define el tipo de campo de CompareValue para los atributos del cambio usados en la pantalla de edición de condición del cambio en la interfaz del agente. Valor válido es Selección, Texto y Fecha. Si un tipo no está definido, el campo no se mostrará.';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for workorder attributes used in the change condition edit screen of the agent interface. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Define el tipo de campo CompareValue para los atriburos de las órdenes de trabajo usados en la pantalla de edición de la condición del cambio en la interfaz del agente. Valor válido es Selección, Texto y Fecha. Si un tipo no está definido , el campo no se mostrará.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for change objects in the change condition edit screen of the agent interface.'} =
        'Define los atributos de objeto que son seleccionables para cambiar objetos en la pantalla de edición de la condición del cambio en la interfaz del agente.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for workorder objects in the change condition edit screen of the agent interface.'} =
        'Define los atributos de objeto que son seleccionables para objetos de Orden de Trabajo en la pantalla de edición de la condición del cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute AccountedTime in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionables para el atributo AccountedTime en la pantalla de edición de la condición del cambio en la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualEndTime in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionables para el atributo ActualEndTime en la pantalla de edición de la condición del cambio en la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualStartTime in the change condition edit screen of the agent interface.'} =
        'Define a los operadores que son seleccionables para el atributo ActualStartTime en la pantalla de edición de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute CategoryID in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionables para el atributo CategoryID en la pantalla de edición de la condición del cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeBuilderID in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionable para el atributo ConstructorCambioID en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeManagerID in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionados para el atributo ChangeManagerID en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeStateID in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionados para el atributo ChangeStateID en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeTitle in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionados para el atributo ChangeTitleID en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute DynamicField in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionados para el atributo CampoDinámico en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ImpactID in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionados para el atributo ImpactID en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEffort in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionados para el atributo EsfuerzoPlaneado en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEndTime in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionados para el atributo PlannedEndTime en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedStartTime in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionados para el atributo PlannedStartTime en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PriorityID in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionados para el atributo PrioridadID en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute RequestedTime in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionados para el atributo RequestedTime en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderAgentID in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionados para el atributo WorkOrderAgentID en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderNumber in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionados para el atributo WorkOrderNumber en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderStateID in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionados para el atributo WorkOrderStateID en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTitle in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionados para el atributo WorkOrderTitle en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTypeID in the change condition edit screen of the agent interface.'} =
        'Define los operadores que son seleccionados para el atributo ChangeManagerID en la pantalla de edición de la condición de cambio de la interfaz del agente.';
    $Self->{Translation}->{'Defines the period (in years), in which start and end times can be selected.'} =
        'Define el periodo (en años) en el que las fechas de inicio y finalización pueden seleccionarse.';
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom. To show workorder dynamic fields in the tooltip, they must be specified like DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, etc.'} =
        'Define los atributos mostrados de un pedido de trabajo en la información sobre herramientas del gráfico de orden de trabajo en el detalle de cambio. Para mostrar los campos dinámicos de orden de trabajo en la información sobre herramientas, se deben especificar como DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, etc.';
    $Self->{Translation}->{'Defines the shown columns in the Change PSA overview. This option has no effect on the position of the column.'} =
        'Define las columnas mostradas en la vista de resumen de la PSA de los cambios, sin que esto tenga efecto en la posición de las mismas.';
    $Self->{Translation}->{'Defines the shown columns in the Change Schedule overview. This option has no effect on the position of the column.'} =
        'Define las columnas mostradas en la vista de resumen de la agenda de los cambios, sin que esto tenga efecto en la posición de las mismas.';
    $Self->{Translation}->{'Defines the shown columns in the MyCAB overview. This option has no effect on the position of the column.'} =
        'Define las columnas mostradas en la vista de resumen de MyCAB, sin que esto tenga efecto en la posición de las mismas.';
    $Self->{Translation}->{'Defines the shown columns in the MyChanges overview. This option has no effect on the position of the column.'} =
        'Define las columnas mostradas en la vista de resumen de MyChanges, sin que esto tenga efecto en la posición de las mismas.';
    $Self->{Translation}->{'Defines the shown columns in the MyWorkorders overview. This option has no effect on the position of the column.'} =
        'Define las columnas mostradas en la vista de resumen de MyWorkorders, sin que esto tenga efecto en la posición de las mismas.';
    $Self->{Translation}->{'Defines the shown columns in the PIR overview. This option has no effect on the position of the column.'} =
        'Define las columnas mostradas en la vista de resumen de las PIR, sin que esto tenga efecto en la posición de las mismas.';
    $Self->{Translation}->{'Defines the shown columns in the change manager overview. This option has no effect on the position of the column.'} =
        'Define las columnas mostradas en la vista de resumen del administrador de los cambios, sin que esto tenga efecto en la posición de las mismas.';
    $Self->{Translation}->{'Defines the shown columns in the change overview. This option has no effect on the position of the column.'} =
        'Define las columnas mostradas en la vista de resumen de los cambios, sin que esto tenga efecto en la posición de las mismas.';
    $Self->{Translation}->{'Defines the shown columns in the change search. This option has no effect on the position of the column.'} =
        'Define las columnas mostradas en la búsqueda de cambios, sin que esto tenga efecto en la posición de las mismas.';
    $Self->{Translation}->{'Defines the shown columns in the customer change schedule overview. This option has no effect on the position of the column.'} =
        'Define las columnas mostradas en la vista de resumen de edición de la angenda de la interfaz del cliente, sin que esto tenga efecto en la posición de las mismas.';
    $Self->{Translation}->{'Defines the shown columns in the template overview. This option has no effect on the position of the column.'} =
        'Define las columnas mostradas en la vista de resumen de las plantillas, sin que esto tenga efecto en la posición de las mismas.';
    $Self->{Translation}->{'Defines the signals for each ITSM change state.'} = 'Define las señales para cada cambio de estado ITSM.';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        'Define los tipos de plantilla que serán utilizados como filtros en la vista de resumen de las plantillas.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        'Define los estados de las órdenes de trabajo que serán utilizados como filtros en la vista de resumen de MyWorkorders.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        'Define los estados de las órdenes de trabajo que serán utilizados como filtros en la vista de resumen de las PIR.';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        'Define los tipos de órdenes de trabajo que se usarán en la vista de resumen de las PIR.';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = 'Determina si deben enviarse notificaciones.';
    $Self->{Translation}->{'Delete a change.'} = 'Eliminar un cambio.';
    $Self->{Translation}->{'Delete the change.'} = 'Borrar el cambio.';
    $Self->{Translation}->{'Delete the workorder.'} = 'Borrar la orden de trabajo.';
    $Self->{Translation}->{'Details of a change history entry.'} = 'Detalles de una entrada de historial de cambios.';
    $Self->{Translation}->{'Determines if an agent can exchange the X-axis of a stat if he generates one.'} =
        'Determina si, al crear una estadística, es posible que los agentes intercambien las X-axis de las mismas.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes done for config item classes.'} =
        'Determina si el módulo comun de estadísticas debe generar estadísticas sobre cambios hechos a clases de elementos de configuración.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding change state updates within a timeperiod.'} =
        'Determina si el módulo comun de estadísticas debe generar estadísticas sobre los cambios, respecto a las actualizaciones de estado de los cambios en un periodo determinado.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding the relation between changes and incident tickets.'} =
        'Determina si el módulo comun de estadísticas debe generar estadísticas sobre los cambios, respecto a la relación entre los cambios y los tickets de tipo incidente.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes.'} =
        'Determina si el módulo comun de estadísticas debe generar estadísticas sobre los cambios.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about the number of Rfc tickets a requester created.'} =
        'Determina si el módulo comun de estadísticas debe generar estadísticas sobre el número de tickets Rfc que una persona creó.';
    $Self->{Translation}->{'Dynamic fields (for changes and workorders) shown in the change print screen of the agent interface.'} =
        'Campos dinámicos (para cambios y órdenes de trabajo) que se muestran en la pantalla de cambio de impresión de la interfaz de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the change add screen of the agent interface.'} =
        'Los campos dinámicos que se muestran en la pantalla de agregar cambios de la interfaz de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the change edit screen of the agent interface.'} =
        'Campos dinámicos que se muestran en la pantalla de modificación de cambios de la interfaz de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the change search screen of the agent interface.'} =
        'Campos dinámicos que se muestran en la pantalla de búsqueda de cambios de la interfaz de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the change zoom screen of the agent interface.'} =
        'Campos dinámicos que se muestran en la pantalla de detalle de cambio de la interfaz de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder add screen of the agent interface.'} =
        'Los campos dinámicos que se muestran en la pantalla de agregar orden de trabajo de la interfaz de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder edit screen of the agent interface.'} =
        'Campos dinámicos que se muestran en la pantalla de edición de órdenes de trabajo de la interfaz de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder report screen of the agent interface.'} =
        'Campos dinámicos que se muestran en la pantalla de informe de órdenes de trabajo de la interfaz de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder zoom screen of the agent interface.'} =
        'Campos dinámicos que se muestran en la pantalla de detalle de la orden de trabajo de la interfaz de agente.';
    $Self->{Translation}->{'DynamicField event module to handle the update of conditions if dynamic fields are added, updated or deleted.'} =
        'Módulo de evento DynamicField para gestionar la actualización de las condiciones si se agregan, actualizan o eliminan campos dinámicos.';
    $Self->{Translation}->{'Edit a change.'} = 'Editar un cambio.';
    $Self->{Translation}->{'Edit the change.'} = 'Editar el cambio.';
    $Self->{Translation}->{'Edit the conditions of the change.'} = 'Editar las condiciones del cambio.';
    $Self->{Translation}->{'Edit the workorder.'} = 'Editar la orden de trabajo.';
    $Self->{Translation}->{'Enables the minimal change counter size (if "Date" was selected as ITSMChange::NumberGenerator).'} =
        'Habilita el tamaño mínimo del contador de cambios (Si "Fecha" estaba seleccionado como ITSMChange::NumberGenerator).';
    $Self->{Translation}->{'Forward schedule of changes. Overview over approved changes.'} =
        'Enviar el horario de cambios. Descripción general de los cambios aprobados.';
    $Self->{Translation}->{'History Zoom'} = 'Detalle del historial';
    $Self->{Translation}->{'ITSM Change CAB Templates.'} = 'Plantillas CAB para el Cambio ITSM.';
    $Self->{Translation}->{'ITSM Change Condition Edit.'} = 'Editar Condición del Cambio en ITSM.';
    $Self->{Translation}->{'ITSM Change Condition Overview.'} = 'Resumen de la condición del cambio en ITSM.';
    $Self->{Translation}->{'ITSM Change Manager Overview.'} = 'Resumen del Gestor del Cambio en ITSM.';
    $Self->{Translation}->{'ITSM Change Notifications'} = 'Notificaciones del cambio en ITSM';
    $Self->{Translation}->{'ITSM Change PIR Overview.'} = 'Resumen del Cambio PIR en ITSM.';
    $Self->{Translation}->{'ITSM Change notification rules'} = 'Reglas de notificación del Cambio en ITSM';
    $Self->{Translation}->{'ITSM Changes'} = 'Cambios';
    $Self->{Translation}->{'ITSM MyCAB Overview.'} = 'Resumen MyCAG en ITSM';
    $Self->{Translation}->{'ITSM MyChanges Overview.'} = 'Resumen de MyChanges en ITSM.';
    $Self->{Translation}->{'ITSM MyWorkorders Overview.'} = 'Resumen MyWorkorders en ITSM.';
    $Self->{Translation}->{'ITSM Template Delete.'} = 'Borrar plantilla en ITSM';
    $Self->{Translation}->{'ITSM Template Edit CAB.'} = 'Editar Plantilla CAB en ITSM';
    $Self->{Translation}->{'ITSM Template Edit Content.'} = 'Editar contenido de Plantilla en ITSM.';
    $Self->{Translation}->{'ITSM Template Edit.'} = 'Editar Plantilla en ITSM.';
    $Self->{Translation}->{'ITSM Template Overview.'} = 'Resumen de Plantilla en ITSM.';
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = 'Módulo de eventos para ITSM que elimina condiciones.';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = 'Módulo de eventos ITSM que elimina la memoria cache para una barra de herramientas.';
    $Self->{Translation}->{'ITSM event module that deletes the history of changes.'} = 'Módulo de eventos ITSM que elimina el historial de cambios.';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        'Módulo de eventos para ITSM que verifica condiciones y ejecuta acciones.';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = 'Módulo de eventos para ITSM para enviar notificaciones.';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = 'Módulo de eventos para ITSM que actualiza la historia de los cambios.';
    $Self->{Translation}->{'ITSM event module that updates the history of conditions.'} = 'Módulo de eventos que actualiza el historial de condiciones.';
    $Self->{Translation}->{'ITSM event module that updates the history of workorders.'} = 'Módulo de eventos que actualiza el historial de las órdenes de trabajo.';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = 'Módulo de eventos para ITSM que recalcula los números de las órdenes de trabajo.';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        'Módulo de eventos para ITSM para definir las fechas de inicio y finalización reales de las órdenes de trabajo.';
    $Self->{Translation}->{'ITSMChange'} = 'Cambio';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'Orden de Trabajo';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notifications are sent (every X hours).'} =
        'Si la frecuencia es \'regular\', puede configurar la frecuencia con la que se envían las notificaciones (every X hours).';
    $Self->{Translation}->{'Link another object to the change.'} = 'Enlazar otro objecto al cambio.';
    $Self->{Translation}->{'Link another object to the workorder.'} = 'Enlazar otro objecto a la orden de trabajo.';
    $Self->{Translation}->{'List of all change events to be displayed in the GUI.'} = 'La lista de todos los eventos de cambio se mostrará en el GUI.';
    $Self->{Translation}->{'List of all workorder events to be displayed in the GUI.'} = 'La lista de todas las órdenes de trabajo se mostrará en el GUI.';
    $Self->{Translation}->{'Lookup of CAB members for autocompletion.'} = 'Búsqueda de miembros de CAB para autocompletar.';
    $Self->{Translation}->{'Lookup of agents, used for autocompletion.'} = 'Búsqueda de agentes, usada para autocompletar.';
    $Self->{Translation}->{'Manage ITSM Change Management state machine.'} = 'Gestionar el estado de la máquina en la Gestión del Cambio ITSM.';
    $Self->{Translation}->{'Manage the category ↔ impact ↔ priority matrix.'} = 'Gestionar la matriz categoría ↔ impacto ↔ prioridad.';
    $Self->{Translation}->{'Module to check if WorkOrderAdd or WorkOrderAddFromTemplate should be permitted.'} =
        'Módulo para verificar si WorkOrderAdd o WorkOrderAddFromTemplate se deben permitir.';
    $Self->{Translation}->{'Module to check the CAB members.'} = 'Módulo para verificar los miembros del CAB.';
    $Self->{Translation}->{'Module to check the agent.'} = 'Módulo para verificar el agente.';
    $Self->{Translation}->{'Module to check the change builder.'} = 'Módulo para verificar el creador de los cambios.';
    $Self->{Translation}->{'Module to check the change manager.'} = 'Módulo para verificar el administrador de los cambios.';
    $Self->{Translation}->{'Module to check the workorder agent.'} = 'Módulo para verificar el agente de la orden de trabajo.';
    $Self->{Translation}->{'Module to check whether no workorder agent is set.'} = 'Módulo para verificar si el agente de una orden de trabajo se ha establecido.';
    $Self->{Translation}->{'Module to check whether the agent is contained in the configured list.'} =
        'Módulo para verificar si el agente está incluido en la lista de configuración.';
    $Self->{Translation}->{'Module to show a link to create a change from this ticket. The ticket will be automatically linked with the new change.'} =
        'Módulo que muestra un vínculo para crear un cambio de este ticket. El ticket se vinculará automaticamente con el cambio nuevo.';
    $Self->{Translation}->{'Move Time Slot.'} = 'Mover ranura del tiempo.';
    $Self->{Translation}->{'Move all workorders in time.'} = 'Mover todas las órdenes de trabajo al mismo tiempo.';
    $Self->{Translation}->{'New (from template)'} = 'Nuevo (desde plantilla)';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        'Sólo los usuarios que pertenezcan a estos grupos tendrán permiso de usar los tipos de tickets, tal y como se define en "ITSMChange::AddChangeLinkTicketTypes" si la funcionalidad "Ticket::Acl::Module###200-Ticket::Acl::Module" está habilitada.';
    $Self->{Translation}->{'Other Settings'} = 'Otros ajustes';
    $Self->{Translation}->{'Overview over all Changes.'} = 'Resumen sobre todos los Cambios.';
    $Self->{Translation}->{'PIR'} = 'PIR';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'Revisión Post Implementación (PIR)';
    $Self->{Translation}->{'PSA'} = 'PSA';
    $Self->{Translation}->{'Parameters for the UserCreateWorkOrderNextMask object in the preference view of the agent interface.'} =
        'Parámetros para el objeto UserCreateWorkOrderNextMask en la vista de preferencia de la interfaz de agente.';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        'Parámetros para las páginas (en las que se muestran los cambios) en el resumen de cambios pequeños.';
    $Self->{Translation}->{'Performs the configured action for each event (as an Invoker) for each configured Webservice.'} =
        'Realiza la acción configurada para cada evento ( como un Invoker) para cada servicio Web configurado.';
    $Self->{Translation}->{'Planned end time'} = 'Hora de finalización planificada';
    $Self->{Translation}->{'Planned start time'} = 'Hora de inicio planificada';
    $Self->{Translation}->{'Print the change.'} = 'Imprimir el cambio.';
    $Self->{Translation}->{'Print the workorder.'} = 'Imprimir la orden de trabajo.';
    $Self->{Translation}->{'Projected Service Availability'} = 'Disponibilidad del servicio proyectado';
    $Self->{Translation}->{'Projected Service Availability (PSA)'} = 'Disponibilidad Proyectada del Servicio (PSA)';
    $Self->{Translation}->{'Projected Service Availability (PSA) of changes. Overview of approved changes and their services.'} =
        'Disponibilidadl de servicio proyectada (PSA) de cambios. Resumen de los cambios aprobados y sus servicios.';
    $Self->{Translation}->{'Requested time'} = 'Tiempo solicitado';
    $Self->{Translation}->{'Required privileges in order for an agent to take a workorder.'} =
        'Privilegios necesarios para que un agente tome una orden de trabajo.';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = 'Permisos necesarios para acceder a la vista de resumen de todos los cambios.';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = 'Privilegios necesarios para agregar una orden de trabajo.';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = 'Privilegios necesarios para modificar el agente de una orden de trabajo.';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = 'Privilegios necesarios para crear una plantilla a partir de un cambio.';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        'Privilegios necesarios para crear una platilla a partir de un CAB de cambios.';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = 'Privilegios necesarios para crear una plantilla a partir de una orden de trabajo.';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = 'Privilegios requeridos para crear cambios basados en plantillas.';
    $Self->{Translation}->{'Required privileges to create changes.'} = 'Privilegios necesarios para crear cambios.';
    $Self->{Translation}->{'Required privileges to delete a template.'} = 'Privilegios necesarios para eliminar una plantilla.';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = 'Privilegios necesarios para eliminar una orden de trabajo.';
    $Self->{Translation}->{'Required privileges to delete changes.'} = 'Privilegios requeridos para eliminar cambios.';
    $Self->{Translation}->{'Required privileges to edit a template.'} = 'Privilegios necesarios para modificar una plantilla.';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = 'Privilegios necesarios para modificar una orden de trabajo.';
    $Self->{Translation}->{'Required privileges to edit changes.'} = 'Privilegios necesarios para modificar cambios.';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = 'Privilegios necesarios para modificar las condiciones de los cambios.';
    $Self->{Translation}->{'Required privileges to edit the content of a template.'} = 'Privilegios requeridos para editar el contenido de una plantilla.';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        'Privilegios necesarios para modificar la lista de personas involucradas en un cambio.';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = 'Privilegios necesarios para mover cambios en el tiempo.';
    $Self->{Translation}->{'Required privileges to print a change.'} = 'Privilegios necesarios para imprimir un cambio.';
    $Self->{Translation}->{'Required privileges to reset changes.'} = 'Privilegios requeridos para reajustar cambios.';
    $Self->{Translation}->{'Required privileges to view a workorder.'} = 'Privilegios necesarios para ver una orden de trabajo.';
    $Self->{Translation}->{'Required privileges to view changes.'} = 'Privilegios necesarios para ver los cambios.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is a CAB member.'} =
        'Privilegios necesarios para ver la lista de los cambios, donde el usuario es un miembro del CAB.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is the change manager.'} =
        'Privilegios necesarios para ver la lista de los cambios, donde el usuario es el administrador de cambios.';
    $Self->{Translation}->{'Required privileges to view overview over all templates.'} = 'Permisos necesarios para acceder a la vista de resumen de todas las plantillas.';
    $Self->{Translation}->{'Required privileges to view the conditions of changes.'} = 'Privilegios necesarios para ver las condiciones de los cambios.';
    $Self->{Translation}->{'Required privileges to view the history of a change.'} = 'Privilegios necesarios para ver la historia de los cambios.';
    $Self->{Translation}->{'Required privileges to view the history of a workorder.'} = 'Privilegios necesarios para ver la historia de una orden de trabajo.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a change.'} = 'Privilegios necesarios para acceder a la vista detallada de la historia de los cambios.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a workorder.'} =
        'Privilegios necesarios para ver la vista detallada de la historia de una orden de trabajo.';
    $Self->{Translation}->{'Required privileges to view the list of Change Schedule.'} = 'Privilegios necesarios para ver la lista de la agenda de los cambios.';
    $Self->{Translation}->{'Required privileges to view the list of change PSA.'} = 'Privilegios necesarios para ver la lista de la PSA de los cambios.';
    $Self->{Translation}->{'Required privileges to view the list of changes with an upcoming PIR (Post Implementation Review).'} =
        'Privilegios necesarios para ver la lista de cambios con un PIR (Revisión Post Implementación) próximo.';
    $Self->{Translation}->{'Required privileges to view the list of own changes.'} = 'Privilegios necesarios para ver una lista de mis cambios propios.';
    $Self->{Translation}->{'Required privileges to view the list of own workorders.'} = 'Privilegios necesarios para ver una lista de mis órdenes de trabajo propias.';
    $Self->{Translation}->{'Required privileges to write a report for the workorder.'} = 'Privilegios necesarios para hacer un reporte de una orden de trabajo.';
    $Self->{Translation}->{'Reset a change and its workorders.'} = 'Restablece un cambio y sus órdenes de trabajo.';
    $Self->{Translation}->{'Reset change and its workorders.'} = 'Resetear cambio y sus órdenes de trabajo.';
    $Self->{Translation}->{'Run task to check if specific times have been reached in changes and workorders.'} =
        'Ejecuta la tarea para verificar si se han alcanzado los tiempos específicos en los cambios y en las órdenes de trabajo.';
    $Self->{Translation}->{'Save change as a template.'} = 'Salvar cambio como una plantilla.';
    $Self->{Translation}->{'Save workorder as a template.'} = 'Salvar orden de trabajo como una plantilla.';
    $Self->{Translation}->{'Schedule'} = 'Programar';
    $Self->{Translation}->{'Screen after creating a workorder'} = 'Pantalla posterior a la creación de una orden de trabajo';
    $Self->{Translation}->{'Search Changes'} = 'Buscar Cambios';
    $Self->{Translation}->{'Search Changes.'} = 'Buscar Cambios.';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        'Selecciona el módulo generador de números de cambio. "AutoIncrement" incrementa el número de cambio, el SystemID y el contador se usan con el formato SystemID.counter (por ejemplo, 100118, 100119). Con "Fecha", los números de cambio serán generados por la fecha actual y un contador; este formato se ve como Year.Month.Day.counter, p. 2010062400001, 2010062400002. Con "DateChecksum", el contador se agregará como suma de verificación a la cadena de fecha más el ID del sistema. La suma de comprobación se rotará diariamente. Este formato se ve como Year.Month.Day.SystemID.Counter.CheckSum, p. 2010062410000017, 2010062410000026.';
    $Self->{Translation}->{'Set the agent for the workorder.'} = 'Establece el agente para la orden de trabajo.';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        'Establezca la altura por defecto (en píxeles) de los campos inline HTML en la pantalla de detalle de cambio y la pantalla de detalle de la orden de trabajo de la interfaz del agente.';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        'Establezca  la altura máxima (en píxeles) de los campos inline HTML en el detalle de la pantalla de cambio y la pantalla de detalle de la orden de trabajo de la interfaz del agente.';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        'Estable el tamaño mínimo del contador de cambios (si se seleccionó "AutoIncrement" como ITSMChange::NumberGenerator). El valor por defecto es 5, esto significa que el contador comienza desde 10000.';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = 'Configura la máquina de estados para los cambios.';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = 'Configura la máquina de estados para las órdenes de trabajo';
    $Self->{Translation}->{'Shows a checkbox in the workorder edit screen of the agent interface that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        'Muestra una casilla de verificación en la pantalla de edición de órdenes de trabajo de la interfaz del agente que define si los siguientes pedidos de trabajo también deberían moverse si un pedido en curso se modifica y la hora de finalización planificada ha cambiado.';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the workorder agent, in the zoom view of the workorder of the agent interface.'} =
        'Muestra un enlace en el menú que permite cambiar el agente de la orden de trabajo, en la vista ampliada de la orden de trabajo de la interfaz del agente.';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        'Muestra un vínculo en el menú que permite definir un cambio como una plantilla, en la vista detallada de dicho cambio, en la interfaz del agente.';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a workorder as a template in the zoom view of the workorder, in the agent interface.'} =
        'Muestra un enlace en el menú que permite definir una orden de trabajo como plantilla en la vista de detalle del pedido de trabajo, en la interfaz de agente.';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workorder, in the zoom view of the workorder of the agent interface.'} =
        'Muestra un enlace en el menú que permite editar el informe de una orden de trabajo, en la vista ampliada de la orden de trabajo de la interfaz del agente. ';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        'Muestra un link en el menú para vincular un cambio con otro objeto, en la vista detallada de dicho cambio de la interfaz del agente.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a workorder with another object in the zoom view of the workorder of the agent interface.'} =
        'Muestra un enlace en el menú que permite vincular una orden de trabajo con otro objeto en la vista ampliada de la orden del trabajo de la interfaz del agente.';
    $Self->{Translation}->{'Shows a link in the menu that allows moving the time slot of a change in its zoom view of the agent interface.'} =
        'Muestra un vínculo en el menú que permite mover el periodo de tiempo de un cambio, en su vista detallada de la interfaz del agente.';
    $Self->{Translation}->{'Shows a link in the menu that allows taking a workorder in the its zoom view of the agent interface.'} =
        'Muestra un enlace en el menú que permite tomar una orden de trabajo en la vista ampliada de la interfaz de agente.';
    $Self->{Translation}->{'Shows a link in the menu to access the conditions of a change in the its zoom view of the agent interface.'} =
        'Muestra un vínculo en el menú para acceder a las condiciones de un cambio en su vista detallada de la interfaz del agente.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a change in the its zoom view of the agent interface.'} =
        'Muestra un link en el menú para acceder a la historia de un cambio en su vista detallada, en la interfaz del agente.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a workorder in the its zoom view of the agent interface.'} =
        'Muestra un enlace en el menú para acceder al historial de un pedido de trabajo en la vista ampliada de la interfaz de agente.';
    $Self->{Translation}->{'Shows a link in the menu to add a workorder in the change zoom view of the agent interface.'} =
        'Muestra un enlace en el menú para agregar una orden de trabajo en la vista de cambio ampliada de la interfaz de agente.';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        'Muestra un vínculo en el menú para eliminar un cambio en la vista de zoom o en la interfaz de agente.';
    $Self->{Translation}->{'Shows a link in the menu to delete a workorder in its zoom view of the agent interface.'} =
        'Muestra un enlace en el menú para eliminar una orden de trabajo en su vista ampliada de la interfaz de agente.';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        'Muestra un link en el menú para editar un cambio en su vista detallada, en la interfaz del agente.';
    $Self->{Translation}->{'Shows a link in the menu to edit a workorder in the its zoom view of the agent interface.'} =
        'Muestra un enlace en el menú para editar una orden de trabajo en la vista ampliada de la interfaz de agente.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        'Muestra un link en el menú para regresar en la vista detallada de un cambio de la interfaz del agente.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the workorder zoom view of the agent interface.'} =
        'Muestra un enlace en el menú para volver a la vista ampliada de la orden de trabajo de la interfaz de agente.';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        'Muestra un link en el menú para imprimir un cambio en su vista detallada, en la interfaz del agente.';
    $Self->{Translation}->{'Shows a link in the menu to print a workorder in the its zoom view of the agent interface.'} =
        'Muestra un enlace en el menú para imprimir una orden de trabajo en la vista ampliada de la interfaz de agente.';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        'Muestra un vínculo en el menú para reajustar un cambio y sus ordenes de trabajo en la vista de zoom o en la interfaz de agente.';
    $Self->{Translation}->{'Shows a link in the menu to show the involved persons in a change, in the zoom view of the change in the agent interface.'} =
        'Muesta un enlace en el menú que muestra a las personas implicadas en el cambio, en la vista ampliada del cambio en la interfaz del agente.';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        'Muestra la historia del cambio (ordenado inversamente) en la interfaz del agente.';
    $Self->{Translation}->{'State Machine'} = 'Máquina de Estados';
    $Self->{Translation}->{'Stores change and workorder ids and their corresponding template id, while a user is editing a template.'} =
        'Ids de órdenes de trabajo y almacenes del cambio y su id de plantilla correspondiente, mientras un usuario está editando una plantilla.';
    $Self->{Translation}->{'Take Workorder'} = 'Tomar Orden de Trabajo';
    $Self->{Translation}->{'Take Workorder.'} = 'Coger Orden de trabajo.';
    $Self->{Translation}->{'Take the workorder.'} = 'Coger la orden de trabajo.';
    $Self->{Translation}->{'Template Overview'} = 'Resumen de Plantillas';
    $Self->{Translation}->{'Template type'} = 'Tipo de plantilla';
    $Self->{Translation}->{'Template.'} = 'Plantilla.';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        'Identificador de un cambio, por ejemplo: Cambio#, MiCambio#. El default es Change#.';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        'Identificador de una orden de trabajo, por ejemplo: OrdenDeTrabajo#, MiOrdenDeTrabajo#. El default es Workorder#.';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        'Este módulo ACL restringe el uso de los tipos de ticket definidos en la opción sysconfig \'ITSMChange::AddChangeLinkTicketTypes\' a los usuarios de los grupos definidos en "ITSMChange::RestrictTicketTypes::Groups". Como esta ACL podría colisionar con otras ACL que también están relacionadas con el tipo de ticket, esta opción de sysconfig está deshabilitada por defecto y solo se debe activar si es necesario.';
    $Self->{Translation}->{'Time Slot'} = 'Periodo de tiempo';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        'Tipos de tickets en cuya vista detallada aparecerá un vínculo para agregar un cambio.';
    $Self->{Translation}->{'User Search'} = 'Búsqueda de Usuario';
    $Self->{Translation}->{'Workorder Add (from template).'} = 'Añadir Orden de trabajo (desde Plantilla)';
    $Self->{Translation}->{'Workorder Add.'} = 'Añadir Orden de trabajo';
    $Self->{Translation}->{'Workorder Agent.'} = 'Agente de Orden de trabajo.';
    $Self->{Translation}->{'Workorder Delete.'} = 'Borrar Orden de trabajo.';
    $Self->{Translation}->{'Workorder Edit.'} = 'Editar Orden de trabajo.';
    $Self->{Translation}->{'Workorder History Zoom.'} = 'Vista detallada del Historial de la Orden de trabajo.';
    $Self->{Translation}->{'Workorder History.'} = 'Historial de Orden de trabajo.';
    $Self->{Translation}->{'Workorder Report.'} = 'Informe de Orden de trabajo.';
    $Self->{Translation}->{'Workorder Zoom'} = 'Detalle de la Orden de trabajo';
    $Self->{Translation}->{'Workorder Zoom.'} = 'Vista detallada de la Orden de trabajo.';
    $Self->{Translation}->{'once'} = 'una vez';
    $Self->{Translation}->{'regularly'} = 'regularmente';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Do you really want to delete this action?',
    'Do you really want to delete this condition?',
    'Do you really want to delete this expression?',
    'Do you really want to delete this notification language?',
    'Do you really want to delete this notification?',
    'No',
    'Ok',
    'Please enter at least one search value or * to find anything.',
    'Settings',
    'Submit',
    'Yes',
    );

}

1;
