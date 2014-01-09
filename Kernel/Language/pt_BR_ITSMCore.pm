# --
# Kernel/Language/pt_BR_ITSMCore.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_ITSMCore;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = 'Alternativa a';
    $Self->{Translation}->{'Availability'} = 'Disponibilidade';
    $Self->{Translation}->{'Back End'} = '';
    $Self->{Translation}->{'Connected to'} = 'Conectado a';
    $Self->{Translation}->{'Current State'} = 'Estado Atual';
    $Self->{Translation}->{'Demonstration'} = 'Demonstração';
    $Self->{Translation}->{'Depends on'} = 'Depende de';
    $Self->{Translation}->{'End User Service'} = 'Serviço a Usuário Final';
    $Self->{Translation}->{'Errors'} = 'Erros';
    $Self->{Translation}->{'Front End'} = '';
    $Self->{Translation}->{'IT Management'} = 'Gerenciamento de TI';
    $Self->{Translation}->{'IT Operational'} = 'Operações de TI';
    $Self->{Translation}->{'Impact'} = 'Impacto';
    $Self->{Translation}->{'Incident State'} = 'Estado de Incidente';
    $Self->{Translation}->{'Includes'} = 'Inclui';
    $Self->{Translation}->{'Other'} = 'Outro';
    $Self->{Translation}->{'Part of'} = 'Parte de';
    $Self->{Translation}->{'Project'} = 'Projeto';
    $Self->{Translation}->{'Recovery Time'} = 'Tempo de Recuperação';
    $Self->{Translation}->{'Relevant to'} = 'Relevante a';
    $Self->{Translation}->{'Reporting'} = 'Relatório';
    $Self->{Translation}->{'Required for'} = 'Requisitado por';
    $Self->{Translation}->{'Resolution Rate'} = 'Taxa de Resolução';
    $Self->{Translation}->{'Response Time'} = 'Tempo de Resposta';
    $Self->{Translation}->{'SLA Overview'} = 'Visão Geral de SLA';
    $Self->{Translation}->{'Service Overview'} = 'Visão Geral de Serviço';
    $Self->{Translation}->{'Service-Area'} = 'Área Serviço';
    $Self->{Translation}->{'Training'} = 'Treinamento';
    $Self->{Translation}->{'Transactions'} = 'Transações';
    $Self->{Translation}->{'Underpinning Contract'} = 'Contrato com Terceiros';
    $Self->{Translation}->{'allocation'} = 'atribuição';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Criticalidade <-> Impacto <-> Prioridade';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        'Gerenciar a prioridade resultante da combinação Criticalidade <-> Impacto.';
    $Self->{Translation}->{'Priority allocation'} = 'Atribuição de prioridade';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Tempo Mínimo entre Incidentes';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Criticalidade';

    # Template: AgentITSMCustomerSearch

    # Template: AgentITSMSLA

    # Template: AgentITSMSLAPrint
    $Self->{Translation}->{'SLA-Info'} = 'Informação do SLA';
    $Self->{Translation}->{'Last changed'} = 'Última alteração';
    $Self->{Translation}->{'Last changed by'} = 'Última alteração por';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Informação de SLA';
    $Self->{Translation}->{'Associated Services'} = 'Serviços Associados';

    # Template: AgentITSMService

    # Template: AgentITSMServicePrint
    $Self->{Translation}->{'Service-Info'} = 'Informação de serviço';
    $Self->{Translation}->{'Current Incident State'} = 'Estado Atual de Incidente';
    $Self->{Translation}->{'Associated SLAs'} = 'SLAs Associados';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Informação de serviço';
    $Self->{Translation}->{'Current incident state'} = 'Estado Atual de Incidente';

    # SysConfig
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        'Registro de módulo de interface para a configuração AdminITSMCIPAllocate na área administrativa.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        'Registro de módulo de interface para o objeto AgentITSMSLA na interface de atendente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        'Registro de módulo de interface para o objeto AgentITSMSLAPrint na interface de atendente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        'Registro de módulo de interface para o objeto AgentITSMSLAZoom na interface de atendente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        'Registro de módulo de interface para o objeto AgentITSMService na interface de atendente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        'Registro de módulo de interface para o objeto AgentITSMServicePrint na interface de atendente.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        'Registro de módulo de interface para o objeto AgentITSMServiceZoom na interface de atendente.';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Gerenciar matriz de prioridade.';
    $Self->{Translation}->{'Module to show back link in service menu.'} = 'Módulo para mostrar o link voltar no menu serviço.';
    $Self->{Translation}->{'Module to show back link in sla menu.'} = 'Módulo para mostrar o link voltar no menu SLA.';
    $Self->{Translation}->{'Module to show print link in service menu.'} = 'Módulo para mostrar o link imprimir no menu serviço.';
    $Self->{Translation}->{'Module to show print link in sla menu.'} = 'Módulo para mostrar o link imprimir no menu SLA.';
    $Self->{Translation}->{'Module to show the link link in service menu.'} = 'Módulo para mostrar o link associar no menu serviço.';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Parâmetros para os estados de incidente na visão de preferências.';
    $Self->{Translation}->{'Set the type of link to be used to calculate the incident state.'} =
        'Definir o tipo de link a ser utilizado para calcular o estado de incidente.';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Essa configuração define que um objeto \'MudançaITSM\' pode ser associado com objetos \'Chamado\' usando o tipo de associação \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Essa configuração define que um objeto \'ItemConfigITSM\' pode ser associado com objetos \'FAQ\' usando o tipo de associação \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Essa configuração define que um objeto \'ItemConfigITSM\' pode ser associado com objetos \'FAQ\' usando o tipo de associação \'PaiFilho\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Essa configuração define que um objeto \'ItemConfigITSM\' pode ser associado com objetos \'FAQ\' usando o tipo de associação \'Relevante a\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        'Essa configuração define que um objeto \'ItemConfigITSM\' pode ser associado com objetos \'Serviço\' usando o tipo de associação \'Alternativa a\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Essa configuração define que um objeto \'ItemConfigITSM\' pode ser associado com objetos \'Serviço\' usando o tipo de associação \'Depende de\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        'Essa configuração define que um objeto \'ItemConfigITSM\' pode ser associado com objetos \'Serviço\' usando o tipo de associação \'Relevante a\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        'Essa configuração define que um objeto \'ItemConfigITSM\' pode ser associado com objetos \'Chamado\' usando o tipo de associação \'Alternativa a\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        'Essa configuração define que um objeto \'ItemConfigITSM\' pode ser associado com objetos \'Chamado\' usando o tipo de associação \'Depende de\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        'Essa configuração define que um objeto \'ItemConfigITSM\' pode ser associado com objetos \'Chamado\' usando o tipo de associação \'Relevante a\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        'Essa configuração define que um objeto \'ItemConfigITSM\' pode ser associado com outros objetos \'ItemConfigITSM\' usando o tipo de associação \'Alternativa a\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        'Essa configuração define que um objeto \'ItemConfigITSM\' pode ser associado com outros objetos \'ItemConfigITSM\' usando o tipo de associação \'Conectado a\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Essa configuração define que um objeto \'ItemConfigITSM\' pode ser associado com outros objetos \'ItemConfigITSM\' usando o tipo de associação \'Depende de\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        'Essa configuração define que um objeto \'ItemConfigITSM\' pode ser associado com outros objetos \'ItemConfigITSM\' usando o tipo de associação \'Inclui\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        'Essa configuração define que um objeto \'ItemConfigITSM\' pode ser associado com outros objetos \'ItemConfigITSM\' usando o tipo de associação \'Relevante a\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Essa configuração define que um objeto \'OrdemServiçoITSM\' pode ser associado com objetos \'ItemConfigITSM\' usando o tipo de associação \'Depende de\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        'Essa configuração define que um objeto \'OrdemServiçoITSM\' pode ser associado com objetos \'ItemConfigITSM\' usando o tipo de associação \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Essa configuração define que um objeto \'OrdemServiçoITSM\' pode ser associado com objetos \'Serviço\' usando o tipo de associação \'Depende de\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        'Essa configuração define que um objeto \'OrdemServiçoITSM\' pode ser associado com objetos \'Serviço\' usando o tipo de associação \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Essa configuração define que um objeto \'OrdemServiçoITSM\' pode ser associado com objetos \'Chamado\' usando o tipo de associação \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Essa configuração define que um objeto \'Serviço\' pode ser associado com objetos \'FAQ\' usando o tipo de associação \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Essa configuração define que um objeto \'Serviço\' pode ser associado com objetos \'FAQ\' usando o tipo de associação \'PaiFilho\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Essa configuração define que um objeto \'Serviço\' pode ser associado com objetos \'FAQ\' usando o tipo de associação \'Relevante a\'.';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Esta configuração define o tipo de link \'Alternativa a\'. Se o nome da fonte e o nome do alvo contêm o mesmo valor, a associação resultante é não-direcional. Se os valores são diferentes, a associação resultante é um link direcional.';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Esta configuração define o tipo de link \'Conectado a\'. Se o nome da fonte e o nome do alvo contêm o mesmo valor, a associação resultante é não-direcional. Se os valores são diferentes, a associação resultante é um link direcional.';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Esta configuração define o tipo de link \'Depende de\'. Se o nome da fonte e o nome do alvo contêm o mesmo valor, a associação resultante é não-direcional. Se os valores são diferentes, a associação resultante é um link direcional.';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Esta configuração define o tipo de link \'Inclui\'. Se o nome da fonte e o nome do alvo contêm o mesmo valor, a associação resultante é não-direcional. Se os valores são diferentes, a associação resultante é um link direcional.';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Esta configuração define o tipo de link \'Relevante a\'. Se o nome da fonte e o nome do alvo contêm o mesmo valor, a associação resultante é não-direcional. Se os valores são diferentes, a associação resultante é um link direcional.';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'Número de caracteres por linha em áreas de texto ITSM.';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
