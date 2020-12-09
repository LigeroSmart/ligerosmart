# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::gl_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = 'Criticidad ↔ Impacto ↔ Prioridade';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        'Manexar os resultados prioritarios da combinación Criticidad ↔ Impacto';
    $Self->{Translation}->{'Priority allocation'} = 'Asignación da prioridad';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Tempo mínimo entre Incidentes';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Criticidad';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Información do Acordo do Nivel de Servizo ANS';
    $Self->{Translation}->{'Last changed'} = 'Último cambio';
    $Self->{Translation}->{'Last changed by'} = 'Último cambio feito por';
    $Self->{Translation}->{'Associated Services'} = 'Servizos asociados';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Información do Servizo';
    $Self->{Translation}->{'Current incident state'} = 'Estado actual do incidente';
    $Self->{Translation}->{'Associated SLAs'} = 'ANS asociados';

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = 'Impacto';

    # Perl Module: Kernel/Modules/AgentITSMSLAPrint.pm
    $Self->{Translation}->{'No SLAID is given!'} = '';
    $Self->{Translation}->{'SLAID %s not found in database!'} = '';
    $Self->{Translation}->{'Calendar Default'} = '';

    # Perl Module: Kernel/Modules/AgentITSMSLAZoom.pm
    $Self->{Translation}->{'operational'} = '';
    $Self->{Translation}->{'warning'} = '';
    $Self->{Translation}->{'incident'} = '';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'No ServiceID is given!'} = '';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = '';
    $Self->{Translation}->{'Current Incident State'} = 'Estado do Incidente actual';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'Estado do Incidente';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = 'Funcional';
    $Self->{Translation}->{'Incident'} = 'Incidente';
    $Self->{Translation}->{'End User Service'} = 'Servizo usuario final';
    $Self->{Translation}->{'Front End'} = 'Interface';
    $Self->{Translation}->{'Back End'} = 'Infraestrutura';
    $Self->{Translation}->{'IT Management'} = 'Xestión TI';
    $Self->{Translation}->{'Reporting'} = 'Informes';
    $Self->{Translation}->{'IT Operational'} = 'Operación TI';
    $Self->{Translation}->{'Demonstration'} = 'Demostración';
    $Self->{Translation}->{'Project'} = 'Proxecto';
    $Self->{Translation}->{'Underpinning Contract'} = 'Contrato de soporte';
    $Self->{Translation}->{'Other'} = 'Outros';
    $Self->{Translation}->{'Availability'} = 'Dispoñibilidade';
    $Self->{Translation}->{'Response Time'} = 'Tempo de resposta';
    $Self->{Translation}->{'Recovery Time'} = 'Tempo de recuperación';
    $Self->{Translation}->{'Resolution Rate'} = 'Indice de resolución';
    $Self->{Translation}->{'Transactions'} = 'Transaccións';
    $Self->{Translation}->{'Errors'} = 'Erros';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = 'Alternativa a';
    $Self->{Translation}->{'Both'} = '';
    $Self->{Translation}->{'Connected to'} = 'Conectado a';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        '';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
    $Self->{Translation}->{'Depends on'} = 'Depende de';
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        'Rexistro Módulo FrontEnd para ó AdminITSMCIP da configuración asignada na área de administración';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        'Rexistro Módulo FrontEnd para ó obxeto AgentITSMSLA na interface do axente';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        'Rexistro Módulo FrontEnd para ó  obxeto imprimir AgentITSMSLA na interface do axente';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        'Rexistro Módulo FrontEnd para ó  obxeto zoom AgentITSMSLA na interface do axente';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        'Rexistro Módulo FrontEnd para ó  obxeto servizo AgentITSMSLA na interface do axente';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        'Rexistro Módulo FrontEnd para ó  obxeto servizo imprimir AgentITSM na interface do axente';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        'Rexistro Módulo FrontEnd para ó  obxeto servizo zoom AgentITSM na interface do axente';
    $Self->{Translation}->{'ITSM SLA Overview.'} = '';
    $Self->{Translation}->{'ITSM Service Overview.'} = '';
    $Self->{Translation}->{'Incident State Type'} = '';
    $Self->{Translation}->{'Includes'} = 'inclúe';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Manexar a prioridade da matriz';
    $Self->{Translation}->{'Manage the criticality - impact - priority matrix.'} = '';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'Módulo para mostrar enlace posterior en menú do ANS';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = 'Módulo para mostrar enlace posterior en menú de servizo';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = 'Módulo para mostrar enlace ó enlace no menú de servizo';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'Módulo para mostrar enlace de impresión no menú do ANS';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = 'Módulo para mostrar enlace de impresión no menú de servizo';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Parámetros para os estados do incidente na vista de preferencia';
    $Self->{Translation}->{'Part of'} = 'Parte de';
    $Self->{Translation}->{'Relevant to'} = 'Relevante para';
    $Self->{Translation}->{'Required for'} = 'Requirido por';
    $Self->{Translation}->{'SLA Overview'} = 'Vista xeral do Acordo do Nivel de Servizo';
    $Self->{Translation}->{'SLA Print.'} = '';
    $Self->{Translation}->{'SLA Zoom.'} = '';
    $Self->{Translation}->{'Service Overview'} = 'Vista xeral do servizo';
    $Self->{Translation}->{'Service Print.'} = '';
    $Self->{Translation}->{'Service Zoom.'} = '';
    $Self->{Translation}->{'Service-Area'} = 'Área do servizo';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        '';
    $Self->{Translation}->{'Source'} = '';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Este axuste define que un obxecto de \'ITSMChange\' pode ser conectado con obxectos \'Ticket\' que utilizan o tipo de enlace \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Este axuste define que un obxecto de \'ITSMConfigItem\' pode ser conectado con obxectos de \'FAQ\' que utilizan o tipo de enlace \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Este axuste define que un obxecto de \'ITSMConfigItem\' pode ser conectado con obxectos de \'FAQ\' que utilizan o tipo de enlace de \'ParentChild\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Este axuste define que un obxecto de \'ITSMConfigItem\' pode ser conectado con obxectos de \'FAQ\' que utilizan o tipo de enlace de \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        'Este axuste define que un obxecto de \'ITSMConfigItem\' pode ser conectado con obxectos de \'Service\' que utilizan o tipo de enlace de \'AlternativeTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Este axuste define que un obxecto de \'ITSMConfigItem\' pode ser conectado con obxectos de \'Service\' que utilizan o tipo de enlace de \'DependsOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        'Este axuste define que un obxecto de \'ITSMConfigItem\' pode ser conectado con obxectos de \'Service\' que utilizan o tipo de enlace de \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        'Este axuste define que o obxeto \'ITSMConfigItem\' pode ser vinculado con obxetos \'Ticket\' empregando o tipo de vinculación \'AlternativeTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        'Este axuste define que o obxeto \'ITSMConfigItem\' pode ser vinculado con obxetos \'Ticket\' empregando o tipo de vinculación \'DependsOn\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        'Este axuste define que o obxeto \'ITSMConfigItem\' pode ser vinculado con obxetos \'Ticket\' empregando o tipo de vinculación \'RelevantTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        'Este axuste define que o obxeto \'ITSMConfigItem\' pode ser vinculado con outros obxetos \'ITSMConfigItem\' empregando o tipo de vinculación \'AlternativeTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        'Este axuste define que o obxeto \'ITSMConfigItem\' pode ser vinculado con outros obxetos \'ITSMConfigItem\' empregando o tipo de vinculación \'ConnectedTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Este axuste define que o obxeto \'ITSMConfigItem\' pode ser vinculado con outros obxetos \'ITSMConfigItem\' empregando o tipo de vinculación \'DependsOn\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        'Este axuste define que o obxeto \'ITSMConfigItem\' pode ser vinculado con outros obxetos \'ITSMConfigItem\' empregando o tipo de vinculación \'Includes\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        'Este axuste define que o obxeto \'ITSMConfigItem\' pode ser vinculado con outros obxetos \'ITSMConfigItem\' empregando o tipo de vinculación \'RelevantTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Este axuste define que o obxeto \'ITSMWorkOrder\' pode ser vinculado con obxetos \'ITSMConfigItem\' empregando o tipo de vinculación \'DependsOn\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        'Este axuste define que o obxeto \'ITSMWorkOrder\' pode ser vinculado con obxetos \'ITSMConfigItem\' empregando o tipo de vinculación \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Este axuste define que o obxeto \'ITSMWorkOrder\' pode ser vinculado con obxetos \'Service\' empregando o tipo de vinculación \'DependsOn\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        'Este axuste define que o obxeto \'ITSMWorkOrder\' pode ser vinculado con obxetos \'Service\' empregando o tipo de vinculación \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Este axuste define que o obxeto \'ITSMWorkOrder\' pode ser vinculado con obxetos \'Ticket\' empregando o tipo de vinculación \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Este axuste define que o obxeto \'Service\' pode ser vinculado con obxetos \'FAQ\' empregando o tipo de vinculación \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Este axuste define que o obxeto \'Service\' pode ser vinculado con obxetos \'FAQ\' empregando o tipo de vinculación \'ParentChild\'';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Este axuste define que o obxeto \'Service\' pode ser vinculado con obxetos \'FAQ\' empregando o tipo de vinculación \'RelevantTo\'';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Este axuste define o tipo de vinculación \'AlternativeTo\'. Se o nome fonte e o nome do obxetivo conteñen o mesmo valor, a vinculación resultante é unha non direccional. Se os valores son diferentes, a vinculación resultante é unha direccional.';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Este axuste define o tipo de vinculación \'ConnectedTo\'. Se o nome fonte e o nome do obxetivo conteñen o mesmo valor, a vinculación resultante é unha non direccional. Se os valores son diferentes, a vinculación resultante é unha direccional.';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Este axuste define o tipo de vinculación \'DependsOn\'. Se o nome fonte e o nome do obxetivo conteñen o mesmo valor, a vinculación resultante é unha non direccional. Se os valores son diferentes, a vinculación resultante é unha direccional.';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Este axuste define o tipo de vinculación \'Includes\'. Se o nome fonte e o nome do obxetivo conteñen o mesmo valor, a vinculación resultante é unha non direccional. Se os valores son diferentes, a vinculación resultante é unha direccional.';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Este axuste define o tipo de vinculación \'RelevantTo\'. Se o nome fonte e o nome do obxetivo conteñen o mesmo valor, a vinculación resultante é unha non direccional. Se os valores son diferentes, a vinculación resultante é unha direccional.';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'Anchura das áreas de texto da ITSM.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
