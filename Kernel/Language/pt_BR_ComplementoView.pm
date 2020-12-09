# --
# Kernel/Language/pt_BR_ComplementoView.pm - translation file
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_ComplementoView;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketComplementoView
    $Self->{Translation}->{'Without Owner'} = 'Não atribuído';
    $Self->{Translation}->{'not defined'} = 'Não definido';
    $Self->{Translation}->{'select one bellow to apply'} = 'selecione um abaixo';

    $Self->{Translation}->{'Next Week'} = 'Durante a semana';

    $Self->{Translation}->{'Solution Expired'} = 'Solução vencida';
    $Self->{Translation}->{'Solution Expires Today'} = 'Solução vence hoje';
    $Self->{Translation}->{'Solution Expires Tomorrow'} = 'Solução vence amanhã';
    $Self->{Translation}->{'Solution Expires Next Week'} = 'Solução vence esta semana';

    $Self->{Translation}->{'Follow Up Expired'} = 'Acompanhamento vencido';
    $Self->{Translation}->{'Follow Up Expires Today'} = 'Acompanhamento vence hoje';
    $Self->{Translation}->{'Follow Up Expires Tomorrow'} = 'Acompanhamento vence amanhã';
    $Self->{Translation}->{'Follow Up Expires Next Week'} = 'Acompanhamento vence esta semana';

    $Self->{Translation}->{'First Response Expired'} = 'Primeira Resposta vencida';
    $Self->{Translation}->{'First Response Expires Today'} = 'Primeira Resposta vence hoje';
    $Self->{Translation}->{'First Response Expires Tomorrow'} = 'Primeira Resposta vence amanhã';
    $Self->{Translation}->{'First Response Expires Next Week'} = 'Primeira Resposta vence esta semana';

}

1;
