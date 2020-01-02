# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::es_MX_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = 'Criticidad ↔ Impacto ↔ Prioridad';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        'Administrar el resultado de la combinación de prioridad Criticidad ↔ Impacto.';
    $Self->{Translation}->{'Priority allocation'} = 'Asignación de Priodidad';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Tiempo Mínimo Entre Incidentes';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Criticidad';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Información del SLA';
    $Self->{Translation}->{'Last changed'} = 'Último cambio';
    $Self->{Translation}->{'Last changed by'} = 'Último cambio por';
    $Self->{Translation}->{'Associated Services'} = 'Servicios Asociados';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Información del Servicio';
    $Self->{Translation}->{'Current incident state'} = 'Estado actual del incidente';
    $Self->{Translation}->{'Associated SLAs'} = 'SLAs Relacionados';

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = 'Impacto';

    # Perl Module: Kernel/Modules/AgentITSMSLAPrint.pm
    $Self->{Translation}->{'No SLAID is given!'} = '¡No se proporcionó el \'SLAID\'!';
    $Self->{Translation}->{'SLAID %s not found in database!'} = '¡El \'SLAID\' %s no se encontró en la base de datos!';
    $Self->{Translation}->{'Calendar Default'} = 'Calendario por omisión';

    # Perl Module: Kernel/Modules/AgentITSMSLAZoom.pm
    $Self->{Translation}->{'operational'} = '';
    $Self->{Translation}->{'warning'} = '';
    $Self->{Translation}->{'incident'} = '';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'No ServiceID is given!'} = '¡No se proporcionó el  \'ServiceID\'!';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = '¡El \'ServiceID\' %s no se encontró en la base de datos!';
    $Self->{Translation}->{'Current Incident State'} = 'Estado del Incidente Actual';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'Estado del Incidente';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = 'Operacional';
    $Self->{Translation}->{'Incident'} = 'Incidente';
    $Self->{Translation}->{'End User Service'} = 'Servicio de Usuario final';
    $Self->{Translation}->{'Front End'} = 'Front End';
    $Self->{Translation}->{'Back End'} = 'Back End';
    $Self->{Translation}->{'IT Management'} = 'Administración de TI';
    $Self->{Translation}->{'Reporting'} = 'Reportes';
    $Self->{Translation}->{'IT Operational'} = 'Operaciones de TI';
    $Self->{Translation}->{'Demonstration'} = 'Demostración';
    $Self->{Translation}->{'Project'} = 'Proyecto';
    $Self->{Translation}->{'Underpinning Contract'} = 'Contrato de respaldo';
    $Self->{Translation}->{'Other'} = 'Otro';
    $Self->{Translation}->{'Availability'} = 'Disponibilidad';
    $Self->{Translation}->{'Response Time'} = 'Tiempo de Respuesta';
    $Self->{Translation}->{'Recovery Time'} = 'Tiempo de Reactivación';
    $Self->{Translation}->{'Resolution Rate'} = 'Porcentaje de Resolución';
    $Self->{Translation}->{'Transactions'} = 'Transacciones';
    $Self->{Translation}->{'Errors'} = 'Errores';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = 'Alternativo a';
    $Self->{Translation}->{'Both'} = 'Ambos';
    $Self->{Translation}->{'Connected to'} = 'Conectado a';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'Define las Acciones donde el botón de configuraciones esta disponible en el "widget" de objetos vinculados (LinkObject::ViewMode = "complex"). Por favor note que dichas Acciones deben tener registrados los siguientes archivos JS y CSS: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'Define cuales columnas se muestran en el \'widget\' de Servicios vinculados (LinkObject::ViewMode = "complex"). Nota: Solo atributos de Servicio do permitidos para las Columnas por omisión. Configuraciones posibles: 0 = Deshabitado,  1 = Disponible, 2 = Habilitado por omisión.';
    $Self->{Translation}->{'Depends on'} = 'Depende de';
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        'Módulo de Registro en el Fronted para la configuración AdminITSMCIPAllocate en la interfaz del agente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        'Módulo de Registro en el Fronted para el objeto AgentITSMSLA en la interfaz del agente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        'Módulo de Registro en el Fronted para el objeto AgentITSMSLAPrint en la interfaz del agente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        'Módulo de Registro en el Fronted para el objeto AgentITSMSLAZoom en la interfaz del agente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        'Módulo de Registro en el Fronted para el objeto AgentITSMService en la interfaz del agente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        'Módulo de Registro en el Fronted para el objeto AgentITSMServicePrint en la interfaz del agente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        'Módulo de Registro en el Fronted para el objeto AgentITSMServiceZoom en la interfaz del agente.';
    $Self->{Translation}->{'ITSM SLA Overview.'} = 'Vista general de \'SLA\' de ITSM';
    $Self->{Translation}->{'ITSM Service Overview.'} = 'Vista general de Servicios de ITSM';
    $Self->{Translation}->{'Incident State Type'} = 'Tipo de Estado de Incidente';
    $Self->{Translation}->{'Includes'} = 'Incluye';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Administrar matriz de prioridades';
    $Self->{Translation}->{'Manage the criticality - impact - priority matrix.'} = '';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'Módulo para mostrar un enlace de regreso en el menú de SLA';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = 'Módulo para mostrar un enlace de regreso en el menú del servicio';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = 'Módulo para mostrar el enlace en el menú de servicio.';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'Módulo para mostrar un enlace de impresión en el menú de SLA.';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = 'Módulo para mostrar un enlace de impresión en el menú de servicio.';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Parámetros para el estado de incidentes en la vista de preferencias.';
    $Self->{Translation}->{'Part of'} = 'Parte de';
    $Self->{Translation}->{'Relevant to'} = 'Aplicable a';
    $Self->{Translation}->{'Required for'} = 'Requerido para';
    $Self->{Translation}->{'SLA Overview'} = 'Resumen de SLA';
    $Self->{Translation}->{'SLA Print.'} = 'Imprimir \'SLA\'.';
    $Self->{Translation}->{'SLA Zoom.'} = 'Detailed de SLA.';
    $Self->{Translation}->{'Service Overview'} = 'Resumen de Servicio ';
    $Self->{Translation}->{'Service Print.'} = 'Imprimir Servicio.';
    $Self->{Translation}->{'Service Zoom.'} = 'Detalles del Servicio.';
    $Self->{Translation}->{'Service-Area'} = 'Servicio-Área';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        'Fija el tipo y direccion de los vínculos a ser usados para calcular el estado de incidencia. La llave es el nombre del tipo de vínculo (como está definido en  LinkObject::Type), y el valor es la direccion del \'IncidentLinkType\' que deberá de ser seguido para calcular el estado de incidencia. Por ejemplo si el  \'IncidentLinkType\' está fijado a \'DependsON\' y la direccion es \'Fuente\'. sólo los vínculos \'DependsOn\' serán seguidos (y no por el contrario su opuesto \'RequiredFor\') para calcular el estado de incidencia. Usted puede añadir tantos tipos de vínculos y direcciones como sea necesario, por ejemplo \'Includes\' con la dirección \'Destino\'. Todos los tipos de vínculos definidos en las opciones de  configuración el sistema  LinkObject::Type son posibles y su dirección puede ser \'Fuente\', \'Destino\' o \'Ambos\'. IMPORTANTE: DESPUES DE HACER CAMBIOS A ESTA OPCIÓN DE \'SYSCONFIG\' NECESITARÁ EJECUTAR el COMANDO DE CONSOLA bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate  ¡DE TAL FORMA QUE TODOS LOS ESTADOS DE INCIDENCIA SERÁN RECALCULADOS BASADOS EN LA NUEVA CONFIGURACIÓN!';
    $Self->{Translation}->{'Source'} = '';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Esta configuración define que un objeto \'ITSMChange\' puede ser vinculado con un objeto \'Ticket\' usando el tipo de vínculo \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Esta configuración define que un objeto \'ITSMConfigItem\' puede ser vinculado con un objeto \'FAQ\' usando el tipo de vínculo \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Esta configuración define que un objeto \'ITSMConfigItem\' puede ser vinculado con un objeto \'FAQ\' usando el tipo de vínculo \'ParentChild\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Esta configuración define que un objeto \'ITSMConfigItem\' puede ser vinculado con un objeto \'FAQ\' usando el tipo de vínculo \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        'Esta configuración define que un objeto \'ITSMConfigItem\' puede ser vinculado con un objeto \'Service\' usando el tipo de vínculo \'AlternativeTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Esta configuración define que un objeto \'ITSMConfigItem\' puede ser vinculado con un objeto \'Service\' usando el tipo de vínculo \'DependsOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        'Esta configuración define que un objeto \'ITSMConfigItem\' puede ser vinculado con un objeto \'Service\' usando el tipo de vínculo \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        'Esta configuración define que un objeto \'ITSMConfigItem\' puede ser vinculado con un objeto \'Ticket\' usando el tipo de vínculo \'AlternativeTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        'Esta configuración define que un objeto \'ITSMConfigItem\' puede ser vinculado con un objeto \'Ticket\' usando el tipo de vínculo \'DependsOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        'Esta configuración define que un objeto \'ITSMConfigItem\' puede ser vinculado con un objeto \'Ticket\' usando el tipo de vínculo \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        'Esta configuración define que un objeto \'ITSMConfigItem\' puede ser vinculado con otro objeto \'ITSMConfigItem\' usando el tipo de vínculo \'AlternativeTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        'Esta configuración define que un objeto \'ITSMConfigItem\' puede ser vinculado con otro objeto \'ITSMConfigItem\' usando el tipo de vínculo \'ConnectedTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Esta configuración define que un objeto \'ITSMConfigItem\' puede ser vinculado con otro objeto \'ITSMConfigItem\' usando el tipo de vínculo \'DependsOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        'Esta configuración define que un objeto \'ITSMConfigItem\' puede ser vinculado con otro objeto \'ITSMConfigItem\' usando el tipo de vínculo \'Includes\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        'Esta configuración define que un objeto \'ITSMConfigItem\' puede ser vinculado con otro objeto \'ITSMConfigItem\' usando el tipo de vínculo \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Esta configuración define que un objeto tipo \'ITSMWorkOrder\' puede ser enlazado con objetos \'ITSMConfigItem\' usando el tipo \'DependsOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        'Esta configuración define que un objeto tipo \'ITSMWorkOrder\' puede ser enlazado con objetos \'ITSMConfigItem\' usando el tipo \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Esta configuración define que un objeto tipo \'ITSMWorkOrder\' puede ser enlazado con objetos \'Service\' usando el tipo \'DependsOn\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        'Esta configuración define que un objeto tipo \'ITSMWorkOrder\' puede ser enlazado con objetos \'Service\' usando el tipo \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Esta configuración define que un objeto tipo \'ITSMWorkOrder\' puede ser enlazado con objetos \'Ticket\' usando el tipo \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Esta configuración define que un objeto tipo \'Servicie\' puede ser enlazado con objetos \'FAQ\' usando el tipo \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Esta configuración define que un objeto tipo \'Servicie\' puede ser enlazado con objetos \'FAQ\' usando el tipo \'ParentChild\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Esta configuración define que un objeto tipo \'Servicie\' puede ser enlazado con objetos \'FAQ\' usando el tipo \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Esta configuración define el tipo de enlace \'AlternativeTo\'. Si el nombre del  origen y el nombre del destino contienen el mismo valor, el enlace resultante es uno no-direccional. Si los valores son diferentes, el enlace resultante es un enlace direccional.';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Esta configuración define el tipo de enlace \'ConnectedTo\'. Si el nombre del  origen y el nombre del destino contienen el mismo valor, el enlace resultante es uno no-direccional. Si los valores son diferentes, el enlace resultante es un enlace direccional.';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Esta configuración define el tipo de enlace \'DependsOn\'. Si el nombre del  origen y el nombre del destino contienen el mismo valor, el enlace resultante es uno no-direccional. Si los valores son diferentes, el enlace resultante es un enlace direccional.';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Esta configuración define el tipo de enlace \'Includes\'. Si el nombre del  origen y el nombre del destino contienen el mismo valor, el enlace resultante es uno no-direccional. Si los valores son diferentes, el enlace resultante es un enlace direccional.';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Esta configuración define el tipo de enlace \'RelevantTo\'. Si el nombre del  origen y el nombre del destino contienen el mismo valor, el enlace resultante es uno no-direccional. Si los valores son diferentes, el enlace resultante es un enlace direccional.';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'Ancho de las áreas de texto del ITSM';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
