# --
# Kernel/Language/pt_BR_ComplementoView.pm - translation file
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_ComplementoDashboards;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketComplementoView
    $Self->{Translation}->{'Without Responsible'} = 'Sem Responsável';
    $Self->{Translation}->{'Tickets available'} = 'Chamados Disponíveis';
    $Self->{Translation}->{'Not defined'} = 'Não definido';
    $Self->{Translation}->{'Overbalance'} = 'Excedente';
    $Self->{Translation}->{'Used'} = 'Usado';
    $Self->{Translation}->{'Consumed'} = 'Consumido';
    $Self->{Translation}->{'Quota'} = 'Contratado';

}

1;
