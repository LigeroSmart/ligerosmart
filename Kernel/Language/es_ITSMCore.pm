# --
# Kernel/Language/es_ITSMCore.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_ITSMCore;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = 'Alterantiva a';
    $Self->{Translation}->{'Availability'} = 'Disponibilidad';
    $Self->{Translation}->{'Back End'} = 'Backend';
    $Self->{Translation}->{'Connected to'} = 'Conectado a';
    $Self->{Translation}->{'Current State'} = 'Estado Actual';
    $Self->{Translation}->{'Demonstration'} = 'Demostración';
    $Self->{Translation}->{'Depends on'} = 'Depende en';
    $Self->{Translation}->{'End User Service'} = 'Servicio de Usuario Final';
    $Self->{Translation}->{'Errors'} = 'Errores';
    $Self->{Translation}->{'Front End'} = 'Frontend';
    $Self->{Translation}->{'IT Management'} = 'Administración de TI';
    $Self->{Translation}->{'IT Operational'} = 'Operación de TI';
    $Self->{Translation}->{'Impact'} = 'Impacto';
    $Self->{Translation}->{'Incident State'} = 'Estado del Incidente';
    $Self->{Translation}->{'Includes'} = 'Incluye';
    $Self->{Translation}->{'Other'} = 'Otro';
    $Self->{Translation}->{'Part of'} = 'Parte de';
    $Self->{Translation}->{'Project'} = 'Proyecto';
    $Self->{Translation}->{'Recovery Time'} = 'Tiempo de Recuperación';
    $Self->{Translation}->{'Relevant to'} = 'Relevante a';
    $Self->{Translation}->{'Reporting'} = 'Informes';
    $Self->{Translation}->{'Required for'} = 'Requerido para';
    $Self->{Translation}->{'Resolution Rate'} = 'Tasa de Resolución';
    $Self->{Translation}->{'Response Time'} = 'Tiempo de Respuesta';
    $Self->{Translation}->{'SLA Overview'} = 'Descripción de SLA';
    $Self->{Translation}->{'Service Overview'} = 'Descripción de Servicios';
    $Self->{Translation}->{'Service-Area'} = 'Area-Servicio';
    $Self->{Translation}->{'Training'} = 'Entrenamiento';
    $Self->{Translation}->{'Transactions'} = 'Transacciones';
    $Self->{Translation}->{'Underpinning Contract'} = '';
    $Self->{Translation}->{'allocation'} = 'Asignar';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Urgencia <-> Impacto <-> Prioridad';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        'Administrar la prioridad resultante al combinar Urgencia <-> Impacto.';
    $Self->{Translation}->{'Priority allocation'} = 'Asignar prioridad';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Tiempo Mínimo entre Incidentes';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Urgencia';

    # Template: AgentITSMCustomerSearch

    # Template: AgentITSMSLA

    # Template: AgentITSMSLAPrint
    $Self->{Translation}->{'SLA-Info'} = '';
    $Self->{Translation}->{'Last changed'} = '';
    $Self->{Translation}->{'Last changed by'} = '';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = '';
    $Self->{Translation}->{'Associated Services'} = 'Servicios Asociados';

    # Template: AgentITSMService

    # Template: AgentITSMServicePrint
    $Self->{Translation}->{'Service-Info'} = '';
    $Self->{Translation}->{'Current Incident State'} = 'Estado de Incidente Actual';
    $Self->{Translation}->{'Associated SLAs'} = 'SLAs Asociados';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = '';
    $Self->{Translation}->{'Current incident state'} = 'Estado ctual del incidente';

    # SysConfig
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        'Registro del módulo frontend para la configuración de AdminITSMCIPAllocate en el área de administrar.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        'Registro del módulo frontend para el objeto AgentITSMSLA en la interfaz del agente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        'Registro del módulo frontend para el objeto AgentITSMSLAPrint en la interfaz del agente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        'Registro del módulo frontend para el objeto AgentITSMSLAZoom en la interfaz del agente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        'Registro del módulo frontend para el objeto AgentITSMService en la interfaz del agente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        'Registro del módulo frontend para el objeto AgentITSMServicePrint en la interfaz del agente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        'Registro del módulo frontend para el objeto AgentITSMServiceZoom en la interfaz del agente.';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Administrar la matríz de prioridades.';
    $Self->{Translation}->{'Module to show back link in service menu.'} = 'Módulo para mostar un vínculo para regresar en el menú de servicio.';
    $Self->{Translation}->{'Module to show back link in sla menu.'} = 'Módulo para mostar un vínculo para regresar en el menú de SLA.';
    $Self->{Translation}->{'Module to show print link in service menu.'} = 'Módulo para mostar un vínculo para imprimir en el menú de servicio.';
    $Self->{Translation}->{'Module to show print link in sla menu.'} = 'Módulo para mostar un vínculo para imprimir en el menú de SLA.';
    $Self->{Translation}->{'Module to show the link link in service menu.'} = 'Módulo para mostar el vínculo "Vincular" en el menú de servicio.';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Parámetros para los estados de los incidentes en la vista de preferencias.';
    $Self->{Translation}->{'Set the type of link to be used to calculate the incident state.'} =
        'Define el tipo de vínculo usado para calcular el estado del incidente.';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Define que un objeto \'ITSMChange\' puede ser vinculado con objetos \'Ticket\' usando el vínculo de tipo \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'FAQ\' usando el vínculo de tipo \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'FAQ\' usando el vínculo de tipo \'ParentChild\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'FAQ\' usando el vínculo de tipo \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'Service\' usando el vínculo de tipo \'AlternativeTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'Service\' usando el vínculo de tipo \'DependsOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'Service\' usando el vínculo de tipo \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'Ticket\' usando el vínculo de tipo \'AlternativeTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'Ticket\' usando el vínculo de tipo \'AlternativeTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con objetos \'Ticket\' usando el vínculo de tipo \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con otros objetos \'ITSMConfigItem\' usando el vínculo de tipo \'AlternativeTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con otros objetos \'ITSMConfigItem\' usando el vínculo de tipo \'ConnectedTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con otros objetos \'ITSMConfigItem\' usando el vínculo de tipo \'DependsOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con otros objetos \'ITSMConfigItem\' usando el vínculo de tipo \'Includes\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        'Define que un objeto \'ITSMConfigItem\' puede ser vinculado con otros objetos \'ITSMConfigItem\' usando el vínculo \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Define que un objeto \'ITSMWorkOrder\' puede ser vinculado con objetos \'ITSMConfigItem\' usando el vínculo de tipo \'DependsOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        'Define que un objeto \'ITSMWorkOrder\' puede ser vinculado con objetos \'ITSMConfigItem\' usando el vínculo de tipo \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Define que un objeto \'ITSMWorkOrder\' puede ser vinculado con objetos \'Service\' usando el vínculo de tipo \'DependsOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        'Define que un objeto \'ITSMWorkOrder\' puede ser vinculado con objetos \'Service\' usando el vínculo de tipo \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Define que un objeto \'ITSMWorkOrder\' puede ser vinculado con objetos \'Ticket\' usando el vínculo de tipo \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Define que un objeto \'Service\' puede ser vinculado con objetos \'FAQ\' usando el vínculo de tipo \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Define que un objeto \'Service\' puede ser vinculado con objetos \'FAQ\' usando el vínculo de tipo \'ParentChild\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Define que un objeto \'Service\' puede ser vinculado con objetos \'FAQ\' usando el vínculo de tipo \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Define el tipo de vínculo \'AlternativeTo\'. Si el SourceName y el TargetName contienen el mismo valor, el resultado es un vínculo no direccionado. Si los valores son diferentes, el resultado es un vínculo direccionado.';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Define el tipo de vínculo \'ConnectedTo\'. Si el SourceName y el TargetName contienen el mismo valor, el resultado es un vínculo no direccionado. Si los valores son diferentes, el resultado es un vínculo direccionado.';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Define el tipo de vínculo \'DependsOn\'. Si el SourceName y el TargetName contienen el mismo valor, el resultado es un vínculo no direccionado. Si los valores son diferentes, el resultado es un vínculo direccionado.';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Define el tipo de vínculo \'Includes\'. Si el SourceName y el TargetName contienen el mismo valor, el resultado es un vínculo no direccionado. Si los valores son diferentes, el resultado es un vínculo direccionado.';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Define el tipo de vínculo \'RelevantTo\'. Si el SourceName y el TargetName contienen el mismo valor, el resultado es un vínculo no direccionado. Si los valores son diferentes, el resultado es un vínculo direccionado.';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'Define el ancho de las textareas del ITSM.';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
