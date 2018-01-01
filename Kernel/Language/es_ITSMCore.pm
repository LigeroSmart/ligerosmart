# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = 'Criticidad ↔ Impacto ↔ Prioridad';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        'Gestiona la prioridad resultado de la combinación de Criticidad ↔ Impacto';
    $Self->{Translation}->{'Priority allocation'} = 'Asignar prioridad';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Tiempo mínimo entre Incidentes';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Urgencia';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Información del SLA';
    $Self->{Translation}->{'Last changed'} = 'Último cambio';
    $Self->{Translation}->{'Last changed by'} = 'Último cambio por';
    $Self->{Translation}->{'Associated Services'} = 'Servicios Asociados';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Información del Servicio';
    $Self->{Translation}->{'Current incident state'} = 'Estado actual del incidente';
    $Self->{Translation}->{'Associated SLAs'} = 'SLA Asociados';

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = 'Impacto';

    # Perl Module: Kernel/Modules/AgentITSMSLAPrint.pm
    $Self->{Translation}->{'No SLAID is given!'} = '¡No se ha facilitado SLAID!';
    $Self->{Translation}->{'SLAID %s not found in database!'} = '¡SLAID %s no se encontró en la base de datos!';
    $Self->{Translation}->{'Calendar Default'} = 'Calendario por defecto';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'No ServiceID is given!'} = '¡No se ha facilitado el ServiceID!';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = 'ServiceID %s no se encontró en la base de datos!';
    $Self->{Translation}->{'Current Incident State'} = 'Estado de Incidente Actual';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'Estado del Incidente';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = 'Operacional';
    $Self->{Translation}->{'Incident'} = 'Incidente';
    $Self->{Translation}->{'End User Service'} = 'Servicio de Usuario Final';
    $Self->{Translation}->{'Front End'} = 'Frontend';
    $Self->{Translation}->{'Back End'} = 'Backend';
    $Self->{Translation}->{'IT Management'} = 'Administración de TI';
    $Self->{Translation}->{'Reporting'} = 'Informes';
    $Self->{Translation}->{'IT Operational'} = 'Operación de TI';
    $Self->{Translation}->{'Demonstration'} = 'Demostración';
    $Self->{Translation}->{'Project'} = 'Proyecto';
    $Self->{Translation}->{'Underpinning Contract'} = 'Contrato con Terceros';
    $Self->{Translation}->{'Other'} = 'Otro';
    $Self->{Translation}->{'Availability'} = 'Disponibilidad';
    $Self->{Translation}->{'Response Time'} = 'Tiempo de Respuesta';
    $Self->{Translation}->{'Recovery Time'} = 'Tiempo de Recuperación';
    $Self->{Translation}->{'Resolution Rate'} = 'Tasa de Resolución';
    $Self->{Translation}->{'Transactions'} = 'Transacciones';
    $Self->{Translation}->{'Errors'} = 'Errores';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = 'Alternativa a';
    $Self->{Translation}->{'Both'} = 'Ambos';
    $Self->{Translation}->{'Connected to'} = 'Conectado a';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'Definir acciones donde está disponible un botón de configuración en el widget de objetos vinculados (LinkObject::ViewMode = "complex"). Tenga en cuenta que estas acciones deben haber registrado los siguientes archivos JS y CSS: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js y Core.Agent.LinkObject.js.';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'Defina qué columnas se muestran en el widget de servicios vinculados (LinkObject::ViewMode = "complex"). Nota: Sólo se permiten atributos de servicio para columnas predeterminadas. Ajustes posibles: 0 = Desactivado, 1 = Disponible, 2 = Activado de forma predeterminada.';
    $Self->{Translation}->{'Depends on'} = 'Depende de';
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
    $Self->{Translation}->{'ITSM SLA Overview.'} = 'Descripción de ITSM SLA';
    $Self->{Translation}->{'ITSM Service Overview.'} = 'Visión general del servicio ITSM.';
    $Self->{Translation}->{'Incident State Type'} = 'Tipo de Estado de Incidente';
    $Self->{Translation}->{'Incident State Type.'} = 'Tipo de Estado de Incidente.';
    $Self->{Translation}->{'Includes'} = 'Incluye';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Administrar la matríz de prioridades.';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'Módulo para mostrar el elemento de menú Volver en el menú SLA';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = 'Módulo para mostrar el elemento de menú Volver en menú servicio.';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = 'Módulo para mostrar el enlace al menú elemento en menú servicio.';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'Módulo para mostrar el elemento de menú Imprimir en el menú SLA.';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = 'Módulo para mostrar el elemento de menún Imprimir en el menú servicio.';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Parámetros para los estados de los incidentes en la vista de preferencias.';
    $Self->{Translation}->{'Part of'} = 'Parte de';
    $Self->{Translation}->{'Relevant to'} = 'Relevante a';
    $Self->{Translation}->{'Required for'} = 'Requerido para';
    $Self->{Translation}->{'SLA Overview'} = 'Vista general del SLA';
    $Self->{Translation}->{'SLA Print.'} = 'Imprimir SLA.';
    $Self->{Translation}->{'SLA Zoom.'} = 'Ampliar SLA.';
    $Self->{Translation}->{'Service Overview'} = 'Descripción de Servicios';
    $Self->{Translation}->{'Service Print.'} = 'Imprimir Servicio.';
    $Self->{Translation}->{'Service Zoom.'} = 'Ampliar Servicios.';
    $Self->{Translation}->{'Service-Area'} = 'Servicio-Área';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        'Establezca el tipo y la dirección de los enlaces que se usarán para calcular el estado de la incidencia. La clave es el nombre del tipo de enlace (como se define en LinkObject::Type), y el valor es la dirección del IncidentLinkType que se debe seguir para calcular el estado de la incidencia. Por ejemplo, si el IncidentLinkType está fijado en "Depende de"  y la dirección es "Origen", solo se seguirán los enlaces "Depende de" (y no el enlace opuesto "Requerido para"), para calcular el estado de la incidencia. Puede agregar más tipos de enlaces y direcciones si lo desea, por ejemplo "Includes" con la dirección "objetivo". Todos los tipos de enlaces definidos en las opciones de sysconfig LinkObject::Type son posibles y la dirección puede ser "Origen", "Objetivo" o "Ambas". IMPORTANTE: TRAS REALIZAR LOS CAMBIOS EN ESTA OPCIÓN DE SYSCONFIG, NECESITA EJECUTAR EL COMANDO DE CONSOLA bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate PARA QUE TODOS LOS ESTADOS SE RECALCULEN EN BASE A LAS NUEVAS CONFIGURACIONES.';
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


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
