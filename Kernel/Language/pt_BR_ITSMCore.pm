# --
# Kernel/Language/pt_BR_ITSMCore.pm - the Brazilian translation of ITSMCore
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2010 Cristiano Korndörfer, http://www.dorfer.com.br/
# --
# $Id: pt_BR_ITSMCore.pm,v 1.2 2010-06-01 19:25:22 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'Criticalidade';
    $Lang->{'Impact'}                              = 'Impacto';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Criticalidade <-> Impacto <-> Prioridade';
    $Lang->{'allocate'}                            = 'Alocar';
    $Lang->{'Priority allocation'}                 = 'Alocar prioridade';
    $Lang->{'Relevant to'}                         = 'Relevante a';
    $Lang->{'Includes'}                            = 'Inclui';
    $Lang->{'Part of'}                             = 'Parte de';
    $Lang->{'Depends on'}                          = 'Depende de';
    $Lang->{'Required for'}                        = 'Requisitado por';
    $Lang->{'Connected to'}                        = 'Conectado a';
    $Lang->{'Alternative to'}                      = 'Alternativa a';
    $Lang->{'Incident State'}                      = 'Situação de Incidentes';
    $Lang->{'Current Incident State'}              = 'Situação Atual de Incidentes';
    $Lang->{'Current State'}                       = 'Situação Atual';
    $Lang->{'Service-Area'}                        = 'Serviço-Área';
    $Lang->{'Minimum Time Between Incidents'}      = 'Tempo Mínimo entre Incidentes';
    $Lang->{'Service Overview'}                    = 'Resumo do Serviço';
    $Lang->{'SLA Overview'}                        = 'Resumo da SLA';
    $Lang->{'Associated Services'}                 = 'Serviços Associados';
    $Lang->{'Associated SLAs'}                     = 'SLAs Associadas';
    $Lang->{'Back End'}                            = '';
    $Lang->{'Demonstration'}                       = 'Demonstração';
    $Lang->{'End User Service'}                    = 'Serviço a Usuário Final';
    $Lang->{'Front End'}                           = '';
    $Lang->{'IT Management'}                       = 'Gerenciamento de TI';
    $Lang->{'IT Operational'}                      = 'Operações de TI';
    $Lang->{'Other'}                               = 'Outro';
    $Lang->{'Project'}                             = 'Projeto';
    $Lang->{'Reporting'}                           = 'Relatório';
    $Lang->{'Training'}                            = 'Treinamento';
    $Lang->{'Underpinning Contract'}               = 'Contrato com Terceiros (UC)';
    $Lang->{'Availability'}                        = 'Avaliabilidade';
    $Lang->{'Errors'}                              = 'Erros';
    $Lang->{'Other'}                               = 'Outro';
    $Lang->{'Recovery Time'}                       = 'Tempo de Recuperação';
    $Lang->{'Resolution Rate'}                     = 'Taxa de Resolução';
    $Lang->{'Response Time'}                       = 'Tempo de Resposta';
    $Lang->{'Transactions'}                        = 'Transações';

    return 1;
}

1;
