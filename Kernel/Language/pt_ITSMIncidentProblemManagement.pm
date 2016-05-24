# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'Adicionar decisão ao ticket';
    $Self->{Translation}->{'Decision Date'} = 'Data da Decisão';
    $Self->{Translation}->{'Decision Result'} = 'Resultado da decisão';
    $Self->{Translation}->{'Due Date'} = 'Data vencimento';
    $Self->{Translation}->{'Reason'} = 'Motivo';
    $Self->{Translation}->{'Recovery Start Time'} = 'Horário Inicial da Recuperação';
    $Self->{Translation}->{'Repair Start Time'} = 'Horário Inicial de Reparação';
    $Self->{Translation}->{'Review Required'} = 'Avaliação necessária ';
    $Self->{Translation}->{'closed with workaround'} = 'fechado com solução de contorno';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = 'Alterar decisão do ticket';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'Alterar os campos ITSM do ticket';
    $Self->{Translation}->{'Service Incident State'} = 'Estado de Incidente do Serviço';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = 'Associar ticket';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'Criticidade';
    $Self->{Translation}->{'Impact'} = 'Impacto';

}

1;
