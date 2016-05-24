# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'Adicionar decisão ao chamado';
    $Self->{Translation}->{'Decision Date'} = 'Data de Decisão';
    $Self->{Translation}->{'Decision Result'} = 'Decisão Resultante';
    $Self->{Translation}->{'Due Date'} = 'Data de vencimento';
    $Self->{Translation}->{'Reason'} = 'Razão';
    $Self->{Translation}->{'Recovery Start Time'} = 'Horário Inicial de Recuperação';
    $Self->{Translation}->{'Repair Start Time'} = 'Horário Inicial de Reparo';
    $Self->{Translation}->{'Review Required'} = 'Revisão Requisitada';
    $Self->{Translation}->{'closed with workaround'} = 'fechado com solução de contorno';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = 'Alterar Decisão de Chamado';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'Alterar os campos ITSM do chamado';
    $Self->{Translation}->{'Service Incident State'} = 'Estado de Incidente do Serviço';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = 'Associar chamado';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'Criticalidade';
    $Self->{Translation}->{'Impact'} = 'Impacto';

}

1;
