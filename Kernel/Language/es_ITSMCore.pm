# --
# Kernel/Language/es_ITSMCore.pm - the spanish translation of ITSMCore
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Aquiles Cohen
# --
# $Id: es_ITSMCore.pm,v 1.16 2010-08-20 22:52:36 mp Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.16 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'Urgencia';
    $Lang->{'Impact'}                              = 'Impacto';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Urgencia <-> Impacto <-> Prioridad';
    $Lang->{'allocation'}                          = 'Asignar';
    $Lang->{'Priority allocation'}                 = 'Asignar prioridad';
    $Lang->{'Relevant to'}                         = 'Relevante a';
    $Lang->{'Includes'}                            = 'Incluye';
    $Lang->{'Part of'}                             = 'Parte de';
    $Lang->{'Depends on'}                          = 'Depende en';
    $Lang->{'Required for'}                        = 'Requerido para';
    $Lang->{'Connected to'}                        = 'Conectado a';
    $Lang->{'Alternative to'}                      = 'Alterantiva a';
    $Lang->{'Incident State'}                      = 'Estado del Incidente';
    $Lang->{'Current Incident State'}              = 'Estado de Incidente Actual';
    $Lang->{'Current State'}                       = 'Estado Actual';
    $Lang->{'Service-Area'}                        = 'Area-Servicio';
    $Lang->{'Minimum Time Between Incidents'}      = 'Tiempo Mínimo entre Incidentes';
    $Lang->{'Service Overview'}                    = 'Descripción de Servicios';
    $Lang->{'SLA Overview'}                        = 'Descripción de SLA';
    $Lang->{'Associated Services'}                 = 'Servicios Asociados';
    $Lang->{'Associated SLAs'}                     = 'SLAs Asociados';
    $Lang->{'Back End'}                            = 'Backend';
    $Lang->{'Demonstration'}                       = 'Demostración';
    $Lang->{'End User Service'}                    = 'Servicio de Usuario Final';
    $Lang->{'Front End'}                           = 'Frontend';
    $Lang->{'IT Management'}                       = 'Administración de TI';
    $Lang->{'IT Operational'}                      = 'Operación de TI';
    $Lang->{'Other'}                               = 'Otro';
    $Lang->{'Project'}                             = 'Proyecto';
    $Lang->{'Reporting'}                           = 'Informes';
    $Lang->{'Training'}                            = 'Entrenamiento';
    $Lang->{'Underpinning Contract'}               = '';
    $Lang->{'Availability'}                        = 'Disponibilidad';
    $Lang->{'Errors'}                              = 'Errores';
    $Lang->{'Other'}                               = 'Otro';
    $Lang->{'Recovery Time'}                       = 'Tiempo de Recuperación';
    $Lang->{'Resolution Rate'}                     = 'Tasa de Resolución';
    $Lang->{'Response Time'}                       = 'Tiempo de Respuesta';
    $Lang->{'Transactions'}                        = 'Transacciones';
    $Lang->{'This setting controls the name of the application as is shown in the web interface as well as the tabs and title bar of your web browser.'} = 'Esta configuración controla el nombre de la aplicación, tal y como se muestra en la interfaz web, así como en las tabs y en la barra de título del explorador web.';
    $Lang->{'Determines the way the linked objects are displayed in each zoom mask.'} = 'Determina la manera en que los objetos vinculados se despliegan en cada máscara de zoom.';
    $Lang->{'List of online repositories (for example you also can use other installations as repositoriy by using Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name").'} = 'Lista de los repositorios disponibles (por ejemplo, también se pueden usar otras instalaciones como respositorio, usando Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" y Content="Algún nombre").';
    $Lang->{'Frontend module registration for the AgentITSMService object in the agent interface.'} = 'Registro del módulo frontend para el objeto AgentITSMService en la interfaz del agente.';
    $Lang->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} = 'Registro del módulo frontend para el objeto AgentITSMSLA en la interfaz del agente.';
    $Lang->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} = 'Registro del módulo frontend para el objeto AgentITSMServiceZoom en la interfaz del agente.';
    $Lang->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} = 'Registro del módulo frontend para el objeto AgentITSMServicePrint en la interfaz del agente.';
    $Lang->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} = 'Registro del módulo frontend para el objeto AgentITSMSLAZoom en la interfaz del agente.';
    $Lang->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} = 'Registro del módulo frontend para el objeto AgentITSMSLAPrint en la interfaz del agente.';
    $Lang->{'Module to show back link in service menu.'} = 'Módulo para mostar un vínculo para regresar en el menú de servicio.';
    $Lang->{'Module to show print link in service menu.'} = 'Módulo para mostar un vínculo para imprimir en el menú de servicio.';
    $Lang->{'Module to show the link link in service menu.'} = 'Módulo para mostar el vínculo "Vincular" en el menú de servicio.';
    $Lang->{'Module to show back link in sla menu.'} = 'Módulo para mostar un vínculo para regresar en el menú de SLA.';
    $Lang->{'Module to show print link in sla menu.'} = 'Módulo para mostar un vínculo para imprimir en el menú de SLA.';
    $Lang->{'If ticket service/SLA feature is enabled, you can define ticket services and SLAs for tickets (e. g. email, desktop, network, ...).'} = 'Si la funcionalidad del ticket Servicio/SLA está habilitada, es posible definir servicios y SLAs para los tickets (por ejemplo: email, escritorio, red, ...).';
    $Lang->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} = 'Registro del módulo frontend para la configuración de AdminITSMCIPAllocate en el área de administrar.';
    $Lang->{'Set the type of link to be used to calculate the incident state.'} = 'Define el tipo de vínculo usado para calcular el estado del incidente.';
    $Lang->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} = 'Define el tipo de vínculo \'AlternativeTo\'. Si el SourceName y el TargetName contienen el mismo valor, el resultado es un vínculo no direccionado. Si los valores son diferentes, el resultado es un vínculo direccionado.';
    $Lang->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} = 'Define el tipo de vínculo \'ConnectedTo\'. Si el SourceName y el TargetName contienen el mismo valor, el resultado es un vínculo no direccionado. Si los valores son diferentes, el resultado es un vínculo direccionado.';
    $Lang->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} = 'Define el tipo de vínculo \'DependsOn\'. Si el SourceName y el TargetName contienen el mismo valor, el resultado es un vínculo no direccionado. Si los valores son diferentes, el resultado es un vínculo direccionado.';
    $Lang->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} = 'Define el tipo de vínculo \'Includes\'. Si el SourceName y el TargetName contienen el mismo valor, el resultado es un vínculo no direccionado. Si los valores son diferentes, el resultado es un vínculo direccionado.';
    $Lang->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} = 'Define el tipo de vínculo \'RelevantTo\'. Si el SourceName y el TargetName contienen el mismo valor, el resultado es un vínculo no direccionado. Si los valores son diferentes, el resultado es un vínculo direccionado.';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} = 'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con otros objetos \'ITSMConfigItem\' usando el vínculo de tipo \'AlternativeTo\'.';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} = 'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con otros objetos \'ITSMConfigItem\' usando el vínculo de tipo \'ConnectedTo\'.';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} = 'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con otros objetos \'ITSMConfigItem\' usando el vínculo de tipo \'DependsOn\'.';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} = 'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con otros objetos \'ITSMConfigItem\' usando el vínculo de tipo \'Includes\'.';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} = 'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con otros objetos \'ITSMConfigItem\' usando el vínculo \'RelevantTo\'.';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} = 'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'Ticket\' usando el vínculo de tipo \'AlternativeTo\'.';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} = 'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'Ticket\' usando el vínculo de tipo \'AlternativeTo\'.';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} = 'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'Ticket\' usando el vínculo de tipo \'RelevantTo\'.';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} = 'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'Service\' usando el vínculo de tipo \'AlternativeTo\'.';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} = 'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'Service\' usando el vínculo de tipo \'DependsOn\'.';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} = 'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'Service\' usando el vínculo de tipo \'RelevantTo\'.';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} = 'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'FAQ\' usando el vínculo de tipo \'Normal\'.';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} = 'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'FAQ\' usando el vínculo de tipo \'ParentChild\'.';
    $Lang->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} = 'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'FAQ\' usando el vínculo de tipo \'RelevantTo\'.';
    $Lang->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} = 'Define que un objeto \'Service\' puede ser vinculado con objetos \'FAQ\' usando el vínculo de tipo \'Normal\'.';
    $Lang->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} = 'Define que un objeto \'Service\' puede ser vinculado con objetos \'FAQ\' usando el vínculo de tipo \'ParentChild\'.';
    $Lang->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} = 'Define que un objeto \'Service\' puede ser vinculado con objetos \'FAQ\' usando el vínculo de tipo \'RelevantTo\'.';
    $Lang->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} = 'Define que un objeto \'ITSMWorkOrder\' puede ser vinculado con objetos \'Service\' usando el vínculo de tipo \'Normal\'.';
    $Lang->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} = 'Define que un objeto \'ITSMWorkOrder\' puede ser vinculado con objetos \'Service\' usando el vínculo de tipo \'DependsOn\'.';
    $Lang->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} = 'Define que un objeto \'ITSMWorkOrder\' puede ser vinculado con objetos \'ITSMConfigItem\' usando el vínculo de tipo \'Normal\'.';
    $Lang->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} = 'Define que un objeto \'ITSMWorkOrder\' puede ser vinculado con objetos \'ITSMConfigItem\' usando el vínculo de tipo \'DependsOn\'.';
    $Lang->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} = 'Define que un objeto \'ITSMWorkOrder\' puede ser vinculado con objetos \'Ticket\' usando el vínculo de tipo \'Normal\'.';
    $Lang->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} = 'Define que un objeto \'ITSMChange\' puede ser vinculado con objetos \'Ticket\' usando el vínculo de tipo \'Normal\'.';
    $Lang->{'Width of ITSM textareas.'} = 'Define el ancho de las textareas del ITSM.';
    $Lang->{'Parameters for the incident states in the preference view.'} = 'Parámetros para los estados de los incidentes en la vista de preferencias.';
    $Lang->{'Manage priority matrix.'} = 'Administrar la matríz de prioridades.';
    $Lang->{'Manage the priority result of combinating Criticality <-> Impact.'} = 'Administrar la prioridad resultante al combinar Urgencia <-> Impacto.';
    $Lang->{'Impact \ Criticality'} = 'Impacto \ Urgencia';
    $Lang->{'Service Actions'} = 'Acciones del Servicio';
    $Lang->{'SLA Actions'} = 'Acciones del SLA';
    $Lang->{'Current incident state'} = 'Estado ctual del incidente';
    $Lang->{'Linked Objects'} = 'Objetos vinculados';

    return 1;
}

1;
