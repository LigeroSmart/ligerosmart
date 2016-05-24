# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMChangeManagement
    $Self->{Translation}->{'ITSMChange'} = 'Cambio';
    $Self->{Translation}->{'ITSMChanges'} = 'Cambios';
    $Self->{Translation}->{'ITSM Changes'} = 'Cambios';
    $Self->{Translation}->{'workorder'} = 'orden de trabajo';
    $Self->{Translation}->{'A change must have a title!'} = '¡Un cambio debe tener un título!';
    $Self->{Translation}->{'A condition must have a name!'} = '¡Una condición debe tener un nombre!';
    $Self->{Translation}->{'A template must have a name!'} = '¡Una plantilla debe tener un nombre!';
    $Self->{Translation}->{'A workorder must have a title!'} = '¡Cada orden de trabajo debe tener un título!';
    $Self->{Translation}->{'Add CAB Template'} = 'Agregar Plantilla de Comité de Cambios';
    $Self->{Translation}->{'Add Workorder'} = 'Agregar Orden de Trabajo';
    $Self->{Translation}->{'Add a workorder to the change'} = 'Agregar una orden de trabajo al cambio';
    $Self->{Translation}->{'Add new condition and action pair'} = 'Agregar par condición-acción nuevo';
    $Self->{Translation}->{'Agent interface module to show the ChangeManager overview icon.'} =
        'Módulo de la interfaz del agente que muestra el ícono de resumen de GestiónDeCambios.';
    $Self->{Translation}->{'Agent interface module to show the MyCAB overview icon.'} = 'Módulo de la interfaz del agente que muestra el ícono de resumen de MisCAB.';
    $Self->{Translation}->{'Agent interface module to show the MyChanges overview icon.'} = 'Módulo de la interfaz del agente que muestra el ícono de resumen de MisCambios.';
    $Self->{Translation}->{'Agent interface module to show the MyWorkOrders overview icon.'} =
        'Módulo de la interfaz del agente que muestra el ícono de resumen de MisÓrdenesDeTrabajo.';
    $Self->{Translation}->{'CABAgents'} = 'Agentes del CAB';
    $Self->{Translation}->{'CABCustomers'} = 'Clientes del CAB';
    $Self->{Translation}->{'Change Overview'} = 'Resumen de Cambios';
    $Self->{Translation}->{'Change Schedule'} = 'Cambiar Programación';
    $Self->{Translation}->{'Change involved persons of the change'} = 'Cambiar las personas involucradas en el cambio';
    $Self->{Translation}->{'ChangeHistory::ActionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ActionAddID'} = 'Nueva Acción (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ActionDelete'} = 'Acción (ID=%s) eliminada';
    $Self->{Translation}->{'ChangeHistory::ActionDeleteAll'} = 'Todas las Acciones de la Condición (ID=%s) eliminadas';
    $Self->{Translation}->{'ChangeHistory::ActionExecute'} = 'Acción (ID=%s) ejecutada: %s';
    $Self->{Translation}->{'ChangeHistory::ActionUpdate'} = '%s (ID de la Acción=%s): Nueva: %s <- Antigua: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeActualEndTimeReached'} = 'El Cambio (ID=%s) ha alcanzado su fecha de finalización real planeada.';
    $Self->{Translation}->{'ChangeHistory::ChangeActualStartTimeReached'} = 'El Cambio (ID=%s) ha alcanzado su fecha de inicio real planeada.';
    $Self->{Translation}->{'ChangeHistory::ChangeAdd'} = 'Cambio nuevo (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentAdd'} = 'Nuevo adjunto: %s ';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentDelete'} = 'Adjunto %s eliminado';
    $Self->{Translation}->{'ChangeHistory::ChangeCABDelete'} = 'Comité de cambios %s eliminado';
    $Self->{Translation}->{'ChangeHistory::ChangeCABUpdate'} = '%s: Nuevo: %s <- Antiguo: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkAdd'} = 'Vínculo a %s (ID=%s) agregado';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkDelete'} = 'Vínculo a %s (ID=%s) eliminado';
    $Self->{Translation}->{'ChangeHistory::ChangeNotificationSent'} = 'Notificación enviada a %s (Evento: %s)';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedEndTimeReached'} = 'El Cambio (ID=%s) ha alcanzado su fecha de finalización planeada.';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedStartTimeReached'} = 'El Cambio (ID=%s) ha alcanzado su fecha de inicio planeada.';
    $Self->{Translation}->{'ChangeHistory::ChangeRequestedTimeReached'} = 'El Cambio (ID=%s) ha alcanzado su fecha esperada de ocurrencia.';
    $Self->{Translation}->{'ChangeHistory::ChangeUpdate'} = '%s: Nuevo: %s <- Antiguo: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAddID'} = 'Nueva Condición (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ConditionDelete'} = 'Codición (ID=%s) eliminada';
    $Self->{Translation}->{'ChangeHistory::ConditionDeleteAll'} = 'Todas las condiciones del cambio (ID=%s) eliminadas';
    $Self->{Translation}->{'ChangeHistory::ConditionUpdate'} = '%s (ID de la Condición=%s): Nuevo: %s <- Antiguo: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAddID'} = 'Nueva Expresión (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ExpressionDelete'} = 'Expresión (ID=%s) eliminada';
    $Self->{Translation}->{'ChangeHistory::ExpressionDeleteAll'} = 'Todas las Expresiones de la Condición (ID=%s) eliminadas';
    $Self->{Translation}->{'ChangeHistory::ExpressionUpdate'} = '%s (ID de la Expresión=%s): Nueva: %s <- Antigua: %s';
    $Self->{Translation}->{'ChangeNumber'} = 'Número del Cambio';
    $Self->{Translation}->{'Condition Edit'} = 'Editar Condición';
    $Self->{Translation}->{'Create Change'} = 'Crear un Cambio';
    $Self->{Translation}->{'Create a change from this ticket!'} = '¡Crear un cambio a partir de este ticket!';
    $Self->{Translation}->{'Delete Workorder'} = 'Eliminar Orden de Trabajo';
    $Self->{Translation}->{'Edit the change'} = 'Editar el cambio';
    $Self->{Translation}->{'Edit the conditions of the change'} = 'Editar las condiciones del cambio';
    $Self->{Translation}->{'Edit the workorder'} = 'Editar la Orden de Trabajo';
    $Self->{Translation}->{'Expression'} = 'Expresión';
    $Self->{Translation}->{'Full-Text Search in Change and Workorder'} = 'Búsqueda de texto completo en un Cambio o una Orden de Trabajo';
    $Self->{Translation}->{'ITSMCondition'} = 'Condición';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'Orden de Trabajo';
    $Self->{Translation}->{'Link another object to the change'} = 'Vincular un objeto nuevo al cambio';
    $Self->{Translation}->{'Link another object to the workorder'} = 'Vincular un objeto nuevo a la orden de trabajo';
    $Self->{Translation}->{'Move all workorders in time'} = 'Mover todas las ordenes de trabajo a tiempo';
    $Self->{Translation}->{'My CABs'} = 'Mis Comités de Cambio (CABs)';
    $Self->{Translation}->{'My Changes'} = 'Mis Cambios';
    $Self->{Translation}->{'My Workorders'} = 'Mis Órdenes de Trabajo';
    $Self->{Translation}->{'No XXX settings'} = 'No hay configuraciones \'%s\' ';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'Revisión Post Implementación (PIR)';
    $Self->{Translation}->{'PSA (Projected Service Availability)'} = 'Disponibilidad Proyectada del Servicio (PSA)';
    $Self->{Translation}->{'Please select first a catalog class!'} = '¡Por favor seleccione primero una clase de catálogo!';
    $Self->{Translation}->{'Print the change'} = 'Imprimir el cambio';
    $Self->{Translation}->{'Print the workorder'} = 'Imprimir la Orden de Trabajo';
    $Self->{Translation}->{'RequestedTime'} = 'Fecha Solicitada';
    $Self->{Translation}->{'Save Change CAB as Template'} = 'Guardar Change CAB como Plantilla';
    $Self->{Translation}->{'Save change as a template'} = 'Guardar el cambio como plantilla';
    $Self->{Translation}->{'Save workorder as a template'} = 'Guardar orden de trabajo como plantilla';
    $Self->{Translation}->{'Search Changes'} = 'Buscar Cambios';
    $Self->{Translation}->{'Set the agent for the workorder'} = 'Asignar agente a la orden de trabajo';
    $Self->{Translation}->{'Take Workorder'} = 'Tomar Orden de Trabajo';
    $Self->{Translation}->{'Take the workorder'} = 'Tomar la Orden de Trabajo';
    $Self->{Translation}->{'Template Overview'} = 'Resumen de Plantillas';
    $Self->{Translation}->{'The planned end time is invalid!'} = '¡La fecha de finalización planeada es inválida!';
    $Self->{Translation}->{'The planned start time is invalid!'} = '¡La fecha de inicio planeada es inválida!';
    $Self->{Translation}->{'The planned time is invalid!'} = '¡El periodo de tiempo planeado es inválido!';
    $Self->{Translation}->{'The requested time is invalid!'} = '¡La fecha solicitada es inválida!';
    $Self->{Translation}->{'New (from template)'} = 'Nuevo (desde plantilla)';
    $Self->{Translation}->{'Add from template'} = 'Agregar desde plantilla';
    $Self->{Translation}->{'Add Workorder (from template)'} = 'Agregar Orden de Trabajo (desde plantilla)';
    $Self->{Translation}->{'Add a workorder (from template) to the change'} = 'Agregar Orden de Trabajo (desde plantilla) al Cambio';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReached'} = 'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de finalización real.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'} =
        'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de finalización real.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReached'} = 'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de inicio real.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'} =
        'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de inicio real.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAdd'} = 'Nueva Orden de Trabajo (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'} = 'Nueva Orden de Trabajo (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAdd'} = 'Nuevo adjunto: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'} = '(ID=%s) Nuevo adjunto para Orden de Trabajo: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Adjunto %s eliminado';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Borrar adjunto de Orden de Trabajo: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAdd'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID'} =
        '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDelete'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID'} =
        '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDelete'} = 'Orden de Trabajo (ID=%s) eliminada';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'} = 'Orden de Trabajo (ID=%s) eliminada';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAdd'} = 'Vínculo a %s (ID=%s) agregado';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'} = '(ID=%s) Vínculo a %s (ID=%s) adicionado';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'Vínculo a %s (ID=%s) eliminada';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'} = '(ID=%s) Vínculo a %s (ID=%s) eliminado';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSent'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'} = 'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de finalización planeada.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'} =
        'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de finalización planeada.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'} = 'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de inicio planeada.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} =
        'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de inicio planeada.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdate'} = '%s: Nueva: %s <- Antigua: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'} = '(ID=%s) %s: Nueva: %s <- Antigua: %s';
    $Self->{Translation}->{'WorkOrderNumber'} = 'Número de la Orden de Trabajo';
    $Self->{Translation}->{'accepted'} = 'aceptada';
    $Self->{Translation}->{'any'} = 'cualquiera';
    $Self->{Translation}->{'approval'} = 'aprobación';
    $Self->{Translation}->{'approved'} = 'aprobado';
    $Self->{Translation}->{'backout'} = 'plan de vuelta atrás';
    $Self->{Translation}->{'begins with'} = 'comienza con';
    $Self->{Translation}->{'canceled'} = 'cancelada';
    $Self->{Translation}->{'contains'} = 'contiene';
    $Self->{Translation}->{'created'} = 'creada';
    $Self->{Translation}->{'decision'} = 'decisión';
    $Self->{Translation}->{'ends with'} = 'termina con';
    $Self->{Translation}->{'failed'} = 'fallido';
    $Self->{Translation}->{'in progress'} = 'en progreso';
    $Self->{Translation}->{'is'} = 'es';
    $Self->{Translation}->{'is after'} = 'está después';
    $Self->{Translation}->{'is before'} = 'está antes';
    $Self->{Translation}->{'is empty'} = 'está vacío(a)';
    $Self->{Translation}->{'is greater than'} = 'es mayor que';
    $Self->{Translation}->{'is less than'} = 'es menor que';
    $Self->{Translation}->{'is not'} = 'no es';
    $Self->{Translation}->{'is not empty'} = 'no está vacío(a)';
    $Self->{Translation}->{'not contains'} = 'no contiene';
    $Self->{Translation}->{'pending approval'} = 'aprobación pendiente';
    $Self->{Translation}->{'pending pir'} = 'revisión post-implementación pendiente';
    $Self->{Translation}->{'pir'} = 'revisión post-implementación';
    $Self->{Translation}->{'ready'} = 'lista';
    $Self->{Translation}->{'rejected'} = 'rechazado';
    $Self->{Translation}->{'requested'} = 'solicitado';
    $Self->{Translation}->{'retracted'} = 'devuelto';
    $Self->{Translation}->{'set'} = 'configurada';
    $Self->{Translation}->{'successful'} = 'exitoso';

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category <-> Impact <-> Priority'} = 'Categoría <-> Impacto <-> Prioridad';
    $Self->{Translation}->{'Manage the priority result of combinating Category <-> Impact.'} =
        '';
    $Self->{Translation}->{'Priority allocation'} = 'Asignar prioridad';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'Gestión de Notificaciones de Cambios ITSM';
    $Self->{Translation}->{'Add Notification Rule'} = 'Agregar Regla de Notificación';
    $Self->{Translation}->{'Rule'} = 'Regla';
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
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Realmente desea eliminar esta transición de estado?';
    $Self->{Translation}->{'from'} = 'de';
    $Self->{Translation}->{'to'} = '';

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
    $Self->{Translation}->{'Invalid Name'} = 'Nombre inválido';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Condiciones y Acciones';
    $Self->{Translation}->{'Delete Condition'} = 'Eliminar condición';
    $Self->{Translation}->{'Add new condition'} = 'Agregar nueva condición';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = 'Se requiere un Nombre válido';
    $Self->{Translation}->{'A valid name is needed.'} = '';
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

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of'} = '';
    $Self->{Translation}->{'Workorder'} = 'Orden de Trabajo';
    $Self->{Translation}->{'Show details'} = 'Mostrar detalles';
    $Self->{Translation}->{'Show workorder'} = 'Mostrar Orden de Trabajo';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of'} = 'Información histórica detallada de';
    $Self->{Translation}->{'Modified'} = 'Modificado';
    $Self->{Translation}->{'Old Value'} = 'Valor Antiguo';
    $Self->{Translation}->{'New Value'} = 'Nuevo Valor';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Involved Persons'} = 'Personas Involucradas';
    $Self->{Translation}->{'ChangeManager'} = 'Administrador de Cambios';
    $Self->{Translation}->{'User invalid.'} = 'Usuario inválido';
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
    $Self->{Translation}->{'WorkOrderTitle'} = 'Título de la Orden de Trabajo';
    $Self->{Translation}->{'ChangeTitle'} = 'Título del Cambio';
    $Self->{Translation}->{'WorkOrderAgent'} = 'Agente de la Orden de Trabajo';
    $Self->{Translation}->{'Workorders'} = 'Orden de Trabajo';
    $Self->{Translation}->{'ChangeState'} = 'Estado del Cambio';
    $Self->{Translation}->{'WorkOrderState'} = 'Estado de la Orden de Trabajo';
    $Self->{Translation}->{'WorkOrderType'} = 'Tipo de Orden de Trabajo';
    $Self->{Translation}->{'Requested Time'} = 'Fecha de Solicitud';
    $Self->{Translation}->{'PlannedStartTime'} = 'Fecha de Inicio Planeado';
    $Self->{Translation}->{'PlannedEndTime'} = 'Fecha de Finalización Planeada';
    $Self->{Translation}->{'ActualStartTime'} = 'Fecha de Inicio Real';
    $Self->{Translation}->{'ActualEndTime'} = 'Fecha de Finalización Real';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = '¿Realmente desea resetear este Cambio?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(ej. 10*5155 o 105658*)';
    $Self->{Translation}->{'CABAgent'} = 'Agente del CAB';
    $Self->{Translation}->{'e.g.'} = 'ej.';
    $Self->{Translation}->{'CABCustomer'} = 'Cliente del CAB';
    $Self->{Translation}->{'ITSM Workorder'} = 'Orden de Trabajo ITSM';
    $Self->{Translation}->{'Instruction'} = 'Instrucción';
    $Self->{Translation}->{'Report'} = 'Reporte';
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
    $Self->{Translation}->{'PlannedEffort'} = 'Esfuerzo Planeado';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Iniciador(es) de Cambio(s)';
    $Self->{Translation}->{'Change Manager'} = 'Administrador del Cambio';
    $Self->{Translation}->{'Change Builder'} = 'Constructor del Cambio';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Último cambio';
    $Self->{Translation}->{'Last changed by'} = 'Último cambio por';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Para abrir links en los siguientes bloques de descripción, podria necesitar presionar la teclas Ctrl, Cmd o Shift mientras presiona el link (depende del browser y el SO)';
    $Self->{Translation}->{'Download Attachment'} = 'Descargar Adjunto';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = '¿Realmente desea eliminar esta plantilla?';

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
    $Self->{Translation}->{'TemplateID'} = 'IDPlantilla';
    $Self->{Translation}->{'Edit Content'} = 'Editar Contenido';
    $Self->{Translation}->{'CreateBy'} = 'Creado Por';
    $Self->{Translation}->{'CreateTime'} = 'Fecha de Creación';
    $Self->{Translation}->{'ChangeBy'} = 'Modificado Por';
    $Self->{Translation}->{'ChangeTime'} = 'Fecha del Cambio';
    $Self->{Translation}->{'Edit Template Content'} = 'Editar Contenido de la Plantilla';
    $Self->{Translation}->{'Delete Template'} = 'Eliminar Plantilla';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = 'Agregar Orden de Trabajo a';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Tipo de orden de trabajo inválido.';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = '¡La fecha planeada de inicio debe ser anterior a la de finalización!';
    $Self->{Translation}->{'Invalid format.'} = 'Formato inválido.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Seleccionar Plantilla de Orden de Trabajo';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = '¿Realmente desea eliminar esta orden de trabajo?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        '¡No es posible eliminar esta orden de trabajo, pues está siendo usada en al menos una Condición!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Esta orden de trabajo se usa en la(s) siguiente(s) condicion(es)';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = 'Mover las siguientes ordenes de trabajo correspondientemente';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        'Si se cambia la hora de finalización prevista de esta orden de trabajo , las horas de inicio planificadas de todas las siguientes órdenes de trabajo se cambiarán en consecuencia';

    # Template: AgentITSMWorkOrderReport
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
    $Self->{Translation}->{'Unknown notification %s!'} = '';
    $Self->{Translation}->{'There was an error creating the notification.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChange.pm
    $Self->{Translation}->{'Overview: ITSM Changes'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeAdd.pm
    $Self->{Translation}->{'Ticket with TicketID %s does not exist!'} = '';
    $Self->{Translation}->{'Missing sysconfig option "ITSMChange::AddChangeLinkTicketTypes"!'} =
        '';
    $Self->{Translation}->{'Was not able to add change!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeAddFromTemplate.pm
    $Self->{Translation}->{'Was not able to create change from template!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeCABTemplate.pm
    $Self->{Translation}->{'No ChangeID is given!'} = '';
    $Self->{Translation}->{'No change found for changeID %s.'} = '';
    $Self->{Translation}->{'The CAB of change "%s" could not be serialized.'} = '';
    $Self->{Translation}->{'Could not add the template.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeCondition.pm
    $Self->{Translation}->{'Change "%s" not found in database!'} = '';
    $Self->{Translation}->{'Could not delete ConditionID %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeConditionEdit.pm
    $Self->{Translation}->{'No %s is given!'} = '';
    $Self->{Translation}->{'Could not create new condition!'} = '';
    $Self->{Translation}->{'Could not update ConditionID %s!'} = '';
    $Self->{Translation}->{'Could not update ExpressionID %s!'} = '';
    $Self->{Translation}->{'Could not add new Expression!'} = '';
    $Self->{Translation}->{'Could not update ActionID %s!'} = '';
    $Self->{Translation}->{'Could not add new Action!'} = '';
    $Self->{Translation}->{'Could not delete ExpressionID %s!'} = '';
    $Self->{Translation}->{'Could not delete ActionID %s!'} = '';
    $Self->{Translation}->{'Error: Unknown field type "%s"!'} = '';
    $Self->{Translation}->{'ConditionID %s does not belong to the given ChangeID %s!'} = '';
    $Self->{Translation}->{'Please contact the administrator.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeDelete.pm
    $Self->{Translation}->{'Change "%s" does not have an allowed change state to be deleted!'} =
        '';
    $Self->{Translation}->{'Was not able to delete the changeID %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeEdit.pm
    $Self->{Translation}->{'Was not able to update Change!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ChangeID is given!'} = '';
    $Self->{Translation}->{'Change "%s" not found in the database!'} = '';
    $Self->{Translation}->{'Unknown type "%s" encountered!'} = '';
    $Self->{Translation}->{'Change History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistoryZoom.pm
    $Self->{Translation}->{'Can\'t show history zoom, no HistoryEntryID is given!'} = '';
    $Self->{Translation}->{'HistoryEntry "%s" not found in database!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeInvolvedPersons.pm
    $Self->{Translation}->{'Was not able to update Change CAB for Change %s!'} = '';
    $Self->{Translation}->{'Was not able to update Change %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeManager.pm
    $Self->{Translation}->{'Overview: ChangeManager'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyCAB.pm
    $Self->{Translation}->{'Overview: My CAB'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyChanges.pm
    $Self->{Translation}->{'Overview: My Changes'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyWorkOrders.pm
    $Self->{Translation}->{'Overview: My Workorders'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePIR.pm
    $Self->{Translation}->{'Overview: PIR'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePSA.pm
    $Self->{Translation}->{'Overview: PSA'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePrint.pm
    $Self->{Translation}->{'WorkOrder "%s" not found in database!'} = '';
    $Self->{Translation}->{'Can\'t create output, as the workorder is not attached to a change!'} =
        '';
    $Self->{Translation}->{'Can\'t create output, as no ChangeID is given!'} = '';
    $Self->{Translation}->{'unknown change title'} = '';
    $Self->{Translation}->{'unknown workorder title'} = '';
    $Self->{Translation}->{'ITSM Workorder Overview (%s)'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeReset.pm
    $Self->{Translation}->{'Was not able to reset WorkOrder %s of Change %s!'} = '';
    $Self->{Translation}->{'Was not able to reset Change %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSchedule.pm
    $Self->{Translation}->{'Overview: Change Schedule'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSearch.pm
    $Self->{Translation}->{'Change Search'} = '';
    $Self->{Translation}->{'WorkOrders'} = 'Orden de Trabajo';
    $Self->{Translation}->{'Change Search Result'} = '';
    $Self->{Translation}->{'Change Number'} = '';
    $Self->{Translation}->{'Change Title'} = '';
    $Self->{Translation}->{'Work Order Title'} = '';
    $Self->{Translation}->{'CAB Agent'} = '';
    $Self->{Translation}->{'CAB Customer'} = '';
    $Self->{Translation}->{'Change Description'} = '';
    $Self->{Translation}->{'Change Justification'} = '';
    $Self->{Translation}->{'WorkOrder Instruction'} = '';
    $Self->{Translation}->{'WorkOrder Report'} = '';
    $Self->{Translation}->{'Change Priority'} = '';
    $Self->{Translation}->{'Change Impact'} = '';
    $Self->{Translation}->{'Change State'} = '';
    $Self->{Translation}->{'Created By'} = '';
    $Self->{Translation}->{'WorkOrder State'} = '';
    $Self->{Translation}->{'WorkOrder Type'} = '';
    $Self->{Translation}->{'WorkOrder Agent'} = '';
    $Self->{Translation}->{'Planned Start Time'} = '';
    $Self->{Translation}->{'Planned End Time'} = '';
    $Self->{Translation}->{'Actual Start Time'} = '';
    $Self->{Translation}->{'Actual End Time'} = '';
    $Self->{Translation}->{'Change Time'} = '';
    $Self->{Translation}->{'before'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeTemplate.pm
    $Self->{Translation}->{'The change "%s" could not be serialized.'} = '';
    $Self->{Translation}->{'Could not update the template "%s".'} = '';
    $Self->{Translation}->{'Could not delete change "%s".'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeTimeSlot.pm
    $Self->{Translation}->{'The change can\'t be moved, as it has no workorders.'} = '';
    $Self->{Translation}->{'Add a workorder first.'} = '';
    $Self->{Translation}->{'Can\'t move a change which already has started!'} = '';
    $Self->{Translation}->{'Please move the individual workorders instead.'} = '';
    $Self->{Translation}->{'The current %s could not be determined.'} = '';
    $Self->{Translation}->{'The %s of all workorders has to be defined.'} = '';
    $Self->{Translation}->{'Was not able to move time slot for workorder #%s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateDelete.pm
    $Self->{Translation}->{'You need %s permission!'} = '';
    $Self->{Translation}->{'No TemplateID is given!'} = '';
    $Self->{Translation}->{'Template "%s" not found in database!'} = '';
    $Self->{Translation}->{'Was not able to delete the template %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEdit.pm
    $Self->{Translation}->{'Was not able to update Template %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditCAB.pm
    $Self->{Translation}->{'Was not able to update Template "%s"!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditContent.pm
    $Self->{Translation}->{'Was not able to create change!'} = '';
    $Self->{Translation}->{'Was not able to create workorder from template!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateOverview.pm
    $Self->{Translation}->{'Overview: Template'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAdd.pm
    $Self->{Translation}->{'You need %s permissions on the change!'} = '';
    $Self->{Translation}->{'Was not able to add workorder!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAgent.pm
    $Self->{Translation}->{'No WorkOrderID is given!'} = '';
    $Self->{Translation}->{'Was not able to set the workorder agent of the workorder "%s" to empty!'} =
        '';
    $Self->{Translation}->{'Was not able to update the workorder "%s"!'} = '';
    $Self->{Translation}->{'Could not find Change for WorkOrder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderDelete.pm
    $Self->{Translation}->{'Was not able to delete the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderEdit.pm
    $Self->{Translation}->{'Was not able to update WorkOrder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no WorkOrderID is given!'} = '';
    $Self->{Translation}->{'WorkOrder "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrderHistory::'} = '';
    $Self->{Translation}->{'WorkOrder History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistoryZoom.pm
    $Self->{Translation}->{'History entry "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrder History Zoom'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTake.pm
    $Self->{Translation}->{'Was not able to take the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTemplate.pm
    $Self->{Translation}->{'The workorder "%s" could not be serialized.'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyWorkOrders.pm
    $Self->{Translation}->{'My Work Orders'} = '';

}

1;
