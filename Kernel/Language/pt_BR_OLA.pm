# --
# Kernel/Language/pt_BR_OLA.pm - translation file
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_OLA;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketComplementoView
    $Self->{Translation}->{'Expired'} = 'Expirado';
    $Self->{Translation}->{'Due Date'} = 'Vencimento';
    $Self->{Translation}->{'Expires at'} = 'Expira em';
    $Self->{Translation}->{'Remaining'} = 'Restam';
    $Self->{Translation}->{'Running Queue OLA'} = 'A.N.O. de Filas Em Andamento';
    $Self->{Translation}->{'Stopped Queues OLA'} = 'A.N.O. de Filas Em Pausa';
    $Self->{Translation}->{'In Progress'} = 'Em Andamento';
    $Self->{Translation}->{'In Progress - Alert'} = 'Em Andamento - Alerta';
    $Self->{Translation}->{'In Progress - Expired'} = 'Em Andamento - Expirado';
    $Self->{Translation}->{'Stopped'} = 'Pausado';
    $Self->{Translation}->{'Stopped - Expired'} = 'Pausado - Expirado';
    $Self->{Translation}->{'Operational Level Agreement (O.L.A.) Configuration'} = 'Configuração dos Acordos de Nível Operacional (A.N.O.)';
    $Self->{Translation}->{'Add O.L.A.'} = 'Adicionar A.N.O.';
    $Self->{Translation}->{'Duplicate Queue'} = 'Fila duplicada';
    $Self->{Translation}->{'There is an OLA already defined for this queue, please choose a different one.'} = 'Já existe um OLA definido para esta fila, por favor escolha outra.';

}

1;
