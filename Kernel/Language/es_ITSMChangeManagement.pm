# --
# Kernel/Language/es_ITSMChangeManagement.pm - the spanish translation of ITSMChangeManagement
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# Copyright (C) 2010 Leonardo Certuche <leonardo.certuche at itcon-ltda.com>
# --
# $Id: es_ITSMChangeManagement.pm,v 1.3 2010-04-27 20:29:14 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_ITSMChangeManagement;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    # misc
    $Lang->{'A change must have a title!'}          = 'Cada cambio debe tener un título';
    $Lang->{'as Template'}                          = 'como Plantilla';
    $Lang->{'Template Name'}                        = 'Nombre de la plantilla';
    $Lang->{'Templates'}                            = 'Plantillas';
    $Lang->{'A workorder must have a title!'}       = 'Cada Orden de Trabajo debe tener un título';
    $Lang->{'Clear'}                                = 'Limpiar campos';
    $Lang->{'Create a change from this ticket!'}    = 'Crear un cambio a partir de este ticket!';
    $Lang->{'Create Change'}                        = 'Crear un Cambio';
    $Lang->{'e.g.'}                                 = 'ej.';

    # workaraound for the imparative of the word 'save' (the space is important!)
    $Lang->{'Save '}                                = 'Guardar ';

    $Lang->{'Save CAB'}                             = 'Guardar CAB';
    $Lang->{'Save Change CAB'}                      = 'Guardar Change CAB';
    $Lang->{'Save Change'}                          = 'Guardar Change';
    $Lang->{'Save Workorder'}                       = 'Guardar Workorder';
    $Lang->{'New time'}                             = 'Nuevo intervalo de tiempo';
    $Lang->{'Requested (by customer) Date'}         = 'Fecha solicitada (por el cliente)';
    $Lang->{'The planned end time is invalid!'}     = 'La fecha de finalización planeada es inválida!';
    $Lang->{'The planned start time is invalid!'}   = 'La fecha de inicio planeada es inválida!';
    $Lang->{'The planned start time must be before the planned end time!'} = 'La fecha planeada de inicio debe ser anterior a la fecha planeada de finalización!';
    $Lang->{'The requested time is invalid!'}       = 'La fecha solicitada es inválida!';
    $Lang->{'Time type'}                            = 'Tipo de fecha';
    $Lang->{'Do you really want to delete this template?'} = 'Realmente desea eliminar esta plantilla?';
    $Lang->{'Change Advisory Board'}                = 'Comités de Cambio';
    $Lang->{'CAB'}                                  = 'CAB';

    # ITSM ChangeManagement icons
    $Lang->{'My Changes'}                           = 'Mis Cambios';
    $Lang->{'My Workorders'}                        = 'Mis Órdendes de Trabajo';
    $Lang->{'PIR (Post Implementation Review)'}     = 'Revisión Post Implementación (PIR)';
    $Lang->{'PSA (Projected Service Availability)'} = 'Disponibilidad proyectada del servicio (PSA)';
    $Lang->{'My CABs'}                              = 'Mis Comités de Cambio (CABs)';
    $Lang->{'Change Overview'}                      = 'Vista de Cambios';
    $Lang->{'Template Overview'}                    = 'Vista de Plantillas';
    $Lang->{'Search Changes'}                       = 'Buscar Cambios';

    # Change menu
    $Lang->{'ITSM Change'}                           = 'Cambio';
    $Lang->{'ITSM Workorder'}                        = 'Orden de Trabajo';
    $Lang->{'Schedule'}                              = 'Agenda';
    $Lang->{'Involved Persons'}                      = 'Personas Involucradas';
    $Lang->{'Add Workorder'}                         = 'Adicionar Orden de Trabajo';
    $Lang->{'Template'}                              = 'Plantilla';
    $Lang->{'Move Time Slot'}                        = 'Mover periodo de tiempo';
    $Lang->{'Print the change'}                      = 'Imprimir el cambio';
    $Lang->{'Edit the change'}                       = 'Editar el cambio';
    $Lang->{'Change involved persons of the change'} = 'Cambiar las personas involucradas en el Cambio';
    $Lang->{'Add a workorder to the change'}         = 'Adicionar una Orden de Trabajo al Cambio';
    $Lang->{'Edit the conditions of the change'}     = 'Editar las condiciones del Cambio';
    $Lang->{'Link another object to the change'}     = 'Vincular un nuevo objeto al Cambio';
    $Lang->{'Save change as a template'}             = 'Guardar el Cambio como Plantilla';
    $Lang->{'Move all workorders in time'}           = 'Mover todas las Ordenes de Trabajo en el tiempo';
    $Lang->{'Current CAB'}                           = 'Comité de Cambios Actual';
    $Lang->{'Add to CAB'}                            = 'Adicionar el Comité de Cambios';
    $Lang->{'Add CAB Template'}                      = 'Adicionar Comité a la Plantilla';
    $Lang->{'Add Workorder to'}                      = 'Adicionar Orden de Trabajo a';
    $Lang->{'Select Workorder Template'}             = 'Seleccionar Plantilla de Orden de Trabajo';
    $Lang->{'Select Change Template'}                = 'Seleccionar Plantilla de Cambio';
    $Lang->{'The planned time is invalid!'}          = 'El periodo de tiempo planeado es inválido!';

    # Workorder menu
    $Lang->{'Workorder'}                            = 'Orden de Trabajo';
    $Lang->{'Save workorder as a template'}         = 'Guardar Orden de Trabajo como Plantilla';
    $Lang->{'Link another object to the workorder'} = 'Vincular otro Objeto a la Orden de Trabajo';
    $Lang->{'Delete Workorder'}                     = 'Borrar Orden de Trabajo';
    $Lang->{'Edit the workorder'}                   = 'Editar la Orden de Trabajo';
    $Lang->{'Print the workorder'}                  = 'Imprimir la Orden de Trabajo';
    $Lang->{'Set the agent for the workorder'}      = 'Asignar Agente a la Orden de Trabajo';

    # Template menu
    $Lang->{'A template must have a name!'} = 'Toda plantilla debe tener un nombre!';

    # Change attributes as returned from ChangeGet(), or taken by ChangeUpdate()
    $Lang->{'AccountedTime'}    = 'Tiempo Contabilizado';
    $Lang->{'ActualEndTime'}    = 'Finalización Real';
    $Lang->{'ActualStartTime'}  = 'Inicio Real';
    $Lang->{'CABAgent'}         = 'Agente del CAB';
    $Lang->{'CABAgents'}        = 'Agentes del CAB';
    $Lang->{'CABCustomer'}      = 'Cliente del CAB';
    $Lang->{'CABCustomers'}     = 'Clientes del CAB';
    $Lang->{'Category'}         = 'Categoria';
    $Lang->{'ChangeBuilder'}    = 'Constructor del Cambio';
    $Lang->{'ChangeBy'}         = 'Modificado por';
    $Lang->{'ChangeManager'}    = 'Administrador del Cambio';
    $Lang->{'ChangeNumber'}     = 'Numero del Cambio';
    $Lang->{'ChangeTime'}       = 'Fecha del Cambio';
    $Lang->{'ChangeState'}      = 'Estado del Cambio';
    $Lang->{'ChangeTitle'}      = 'Titulo del Cambio';
    $Lang->{'CreateBy'}         = 'Creado por';
    $Lang->{'CreateTime'}       = 'Fecha de Creación';
    $Lang->{'Description'}      = 'Descripción';
    $Lang->{'Impact'}           = 'Impacto';
    $Lang->{'Justification'}    = 'Justificación';
    $Lang->{'PlannedEffort'}    = 'Esfuerzo Planeado';
    $Lang->{'PlannedEndTime'}   = 'Finalización Planeada';
    $Lang->{'PlannedStartTime'} = 'Inicio Planeado';
    $Lang->{'Priority'}         = 'Prioridad';
    $Lang->{'RequestedTime'}    = 'Fecha Solicitada';

    # Workorder attributes as returned from WorkOrderGet(), or taken by WorkOrderUpdate()
    $Lang->{'Instruction'}      = 'Instrucción';
    $Lang->{'Report'}           = 'Reporte';
    $Lang->{'WorkOrderAgent'}   = 'Agente de la Orden de Trabajo';
    $Lang->{'WorkOrderNumber'}  = 'Número de la Orden de Trabajo';
    $Lang->{'WorkOrderState'}   = 'Estado de la Orden de Trabajo';
    $Lang->{'WorkOrderTitle'}   = 'Título de la Orden de Trabajo';
    $Lang->{'WorkOrderType'}    = 'Tipo de Orden de Trabajo';

    # Change history
    $Lang->{'ChangeHistory::ChangeAdd'}              = 'Nuevo Cambio (ID=%s)';
    $Lang->{'ChangeHistory::ChangeUpdate'}           = '%s: Nuevo: %s -> Antiguo: %s';
    $Lang->{'ChangeHistory::ChangeLinkAdd'}          = 'Vinculo a %s (ID=%s) adicionado';
    $Lang->{'ChangeHistory::ChangeLinkDelete'}       = 'Vinculo a %s (ID=%s) borrado';
    $Lang->{'ChangeHistory::ChangeCABUpdate'}        = '%s: Nuevo: %s -> Antiguo: %s';
    $Lang->{'ChangeHistory::ChangeCABDelete'}        = 'Comité de Cambios Eliminado %s';
    $Lang->{'ChangeHistory::ChangeAttachmentAdd'}    = 'Nuevo Adjunto: %s';
    $Lang->{'ChangeHistory::ChangeAttachmentDelete'} = 'Borrar Adjunto %s';
    $Lang->{'ChangeHistory::ChangeNotificationSent'} = 'Notificación enviada a %s (Evento: %s)';

    # workorder history
    $Lang->{'WorkOrderHistory::WorkOrderAdd'}              = 'Nueva Orden de Trabajo (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdate'}           = '%s: Nueva: %s -> Antigua: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAdd'}          = 'Vinculo a %s (ID=%s) adicionado';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDelete'}       = 'Vinculo a %s (ID=%s) borrado';
    $Lang->{'WorkOrderHistory::WorkOrderDelete'}           = 'Orden de Trabajo (ID=%s) borrada';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAdd'}    = 'Nuevo adjunto para Orden de Trabajo: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Borrar adjunto de Orden de Trabajo: %s';

    # long workorder history
    $Lang->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'}              = 'Nueva Orden de Trabajo (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'}           = '(ID=%s) %s: Nueva: %s -> Antigua: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'}          = '(ID=%s) Vinculo a %s (ID=%s) adicionado';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'}       = '(ID=%s) Vinculo a %s (ID=%s) borrado';
    $Lang->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'}           = 'Orden de Trabajo (ID=%s) borrada';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'}    = '(ID=%s) Nuevo adjunto para Orden de Trabajo: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Borrar adjunto de Orden de Trabajo: %s';

    # condition history
    $Lang->{'ChangeHistory::ConditionAdd'}       = '%s: %s';
    $Lang->{'ChangeHistory::ConditionAddID'}     = 'Nueva Condición (ID=%s)';
    $Lang->{'ChangeHistory::ConditionUpdate'}    = '%s (ID de la Condición=%s): Nuevo: %s -> Antiguo: %s';
    $Lang->{'ChangeHistory::ConditionDelete'}    = 'Codición (ID=%s) borrada';
    $Lang->{'ChangeHistory::ConditionDeleteAll'} = 'Todas las condiciones del cambio (ID=%s) borradas';

    # expression history
    $Lang->{'ChangeHistory::ExpressionAdd'}       = '%s: %s';
    $Lang->{'ChangeHistory::ExpressionAddID'}     = 'Nueva Expresión (ID=%s)';
    $Lang->{'ChangeHistory::ExpressionUpdate'}    = '%s (ID de la Expresión=%s): Nueva: %s -> Antigua: %s';
    $Lang->{'ChangeHistory::ExpressionDelete'}    = 'Expresión (ID=%s) borrada';
    $Lang->{'ChangeHistory::ExpressionDeleteAll'} = 'Todas las Expresiones de la Condición (ID=%s) borradas';

    # action history
    $Lang->{'ChangeHistory::ActionAdd'}       = '%s: %s';
    $Lang->{'ChangeHistory::ActionAddID'}     = 'Nueva Acción (ID=%s)';
    $Lang->{'ChangeHistory::ActionUpdate'}    = '%s (ID de la Acción=%s): Nueva: %s -> Antigua: %s';
    $Lang->{'ChangeHistory::ActionDelete'}    = 'Acción (ID=%s) borrada';
    $Lang->{'ChangeHistory::ActionDeleteAll'} = 'Todas las Acciones de la Condición (ID=%s) borradas';
    $Lang->{'ChangeHistory::ActionExecute'}   = 'Acción (ID=%s) ejecutada: %s';
    $Lang->{'ActionExecute::successfully'}    = 'Con éxito';
    $Lang->{'ActionExecute::unsuccessfully'}  = 'Sin éxito';

    # history for time events
    $Lang->{'ChangeHistory::ChangePlannedStartTimeReached'}                      = 'El Cambio (ID=%s) ha alcanzado su fecha de inicio planeada.';
    $Lang->{'ChangeHistory::ChangePlannedEndTimeReached'}                        = 'El Cambio (ID=%s) ha alcanzado su fecha de finalización planeada.';
    $Lang->{'ChangeHistory::ChangeActualStartTimeReached'}                       = 'El Cambio (ID=%s) ha alcanzado su fecha de inicio real planeada.';
    $Lang->{'ChangeHistory::ChangeActualEndTimeReached'}                         = 'El Cambio (ID=%s) ha alcanzado su fecha de finalización real planeada.';
    $Lang->{'ChangeHistory::ChangeRequestedTimeReached'}                         = 'El Cambio (ID=%s) ha alcanzado su fecha esperada de ocurrencia.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'}                = 'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de inicio planeada.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'}                  = 'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de finalización planeada.';
    $Lang->{'WorkOrderHistory::WorkOrderActualStartTimeReached'}                 = 'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de inicio real.';
    $Lang->{'WorkOrderHistory::WorkOrderActualEndTimeReached'}                   = 'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de finalización real.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} = 'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de inicio planeada.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'}   = 'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de finalización planeada.';
    $Lang->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'}  = 'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de inicio real.';
    $Lang->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'}    = 'La Orden de Trabajo (ID=%s) ha alcanzado su fecha de finalización real.';

    # change states
    $Lang->{'requested'}        = 'Solicitado';
    $Lang->{'pending approval'} = 'Pendiente por Aprobación';
    $Lang->{'pending pir'}      = 'Pendiente de Revisión Post-Implementación';
    $Lang->{'rejected'}         = 'Rechazado';
    $Lang->{'approved'}         = 'Aprobado';
    $Lang->{'in progress'}      = 'En Progreso';
    $Lang->{'successful'}       = 'Exitoso';
    $Lang->{'failed'}           = 'Fallido';
    $Lang->{'canceled'}         = 'Cancelado';
    $Lang->{'retracted'}        = 'Devuelto';

    # workorder states
    $Lang->{'created'}     = 'Creada';
    $Lang->{'accepted'}    = 'Aceptada';
    $Lang->{'ready'}       = 'Lista';
    $Lang->{'in progress'} = 'En Progreso';
    $Lang->{'closed'}      = 'Cerrada';
    $Lang->{'canceled'}    = 'Cancelada';

    # Admin Interface
    $Lang->{'Category <-> Impact <-> Priority'}      = 'Categoria <-> Impacto <-> Prioridad';
    $Lang->{'Notification (ITSM Change Management)'} = 'Notificaciones de Cambios';

    # Admin StateMachine
    $Lang->{'Add a state transition'}               = 'Adicionar un estado de transición';
    $Lang->{'Add a new state transition for'}       = 'Adicionar un nuevo estado de transición para';
    $Lang->{'Edit a state transition for'}          = 'Editar un estado de transición para';
    $Lang->{'Overview over state transitions for'}  = 'Vista de las transiciones de estado para';
    $Lang->{'Object Name'}                          = 'Nombre del Objeto';
    $Lang->{'Please select first a catalog class!'} = 'Por favor seleccione primero una clase de catálogo';

    # workorder types
    $Lang->{'approval'}  = 'Aprobación';
    $Lang->{'decision'}  = 'Decisión';
    $Lang->{'workorder'} = 'Orden de trabajo';
    $Lang->{'backout'}   = 'Plan de Vuelta Atrás';
    $Lang->{'pir'}       = 'Revisión Post-Implementación';

    # objects that can be used in condition expressions and actions
    $Lang->{'ITSMChange'}    = 'Cambio';
    $Lang->{'ITSMWorkOrder'} = 'Orden de Trabajo';
    $Lang->{'ITSMCondition'} = 'Condición';

    # Overviews
    $Lang->{'Change Schedule'} = 'Cambiar Programación';

    # Workorder delete
    $Lang->{'Do you really want to delete this workorder?'} = 'Realmente desea borrar esta orden de trabajo';
    $Lang->{'You can not delete this Workorder. It is used in at least one Condition!'} = 'No es posible borrar esta orden de trabajo pues está siendo usada en al menos una Condición';
    $Lang->{'This Workorder is used in the following Condition(s)'} = 'Esta orden de trabajo es usada en las siguiente(s) condicion(es)';

    # Take workorder
    $Lang->{'Imperative::Take Workorder'}                 = 'Tomar Orden de Trabajo';
    $Lang->{'Take Workorder'}                             = 'Tomar Orden de Trabajo';
    $Lang->{'Take the workorder'}                         = 'Tomar La Orden de Trabajo';
    $Lang->{'Current Agent'}                              = 'Agente actual';
    $Lang->{'Do you really want to take this workorder?'} = 'Realmente quiere tomar esta Orden de Trabajo?';

    # Condition Overview and Edit
    $Lang->{'Condition'}                                = 'Condición';
    $Lang->{'Conditions'}                               = 'Condiciones';
    $Lang->{'Expression'}                               = 'Expresión';
    $Lang->{'Expressions'}                              = 'Expresiones';
    $Lang->{'Action'}                                   = 'Acción';
    $Lang->{'Actions'}                                  = 'Acciones';
    $Lang->{'Matching'}                                 = 'Coincidentes';
    $Lang->{'Conditions and Actions'}                   = 'Condiciones y Acciones';
    $Lang->{'Add new condition and action pair'}        = 'Adicionar nuevo par condición-acción';
    $Lang->{'A condition must have a name!'}            = 'Cada condición debe tener un nombre!';
    $Lang->{'Condition Edit'}                           = 'Editar Condición';
    $Lang->{'Add new expression'}                       = 'Adicionar nueva expresión';
    $Lang->{'Add new action'}                           = 'Adicionar nueva acción';
    $Lang->{'Any expression'}                           = 'Cualquier expresión';
    $Lang->{'All expressions'}                          = 'Todas las expresiones';
    $Lang->{'any'}                                         = 'Cualquiera';
    $Lang->{'all'}                                         = 'Todo';
    $Lang->{'is'}                                          = 'es';
    $Lang->{'is not'}                                      = 'no es';
    $Lang->{'is empty'}                                    = 'está vacía';
    $Lang->{'is not empty'}                                = 'no está vacía';
    $Lang->{'is greater than'}                             = 'es más grande que';
    $Lang->{'is less than'}                                = 'es menor que';
    $Lang->{'is before'}                                   = 'está antes';
    $Lang->{'is after'}                                    = 'está después';
    $Lang->{'contains'}                                    = 'contiene';
    $Lang->{'not contains'}                                = 'no contiene';
    $Lang->{'begins with'}                                 = 'comienza con';
    $Lang->{'ends with'}                                   = 'finaliza con';
    $Lang->{'set'}                                         = 'configurada';
    $Lang->{'lock'}                                        = 'bloqueada';

    # Change Zoom
    $Lang->{'Change Initiator(s)'} = 'Iniciador(es) del cambios';

    # AgentITSMChangePrint
    $Lang->{'Linked Objects'} = 'Objetos Vinculados';
    $Lang->{'Full-Text Search in Change and Workorder'} = 'Búsqueda de texto completo en un Cambio o una Orden de Trabajo';

    # AgentITSMChangeSearch
    $Lang->{'No XXX settings'} = "No hay configuraciones '%s' ";

    return 1;
}

1;
