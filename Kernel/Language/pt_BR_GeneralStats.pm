# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pt_BR_GeneralStats;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Period Type'} = 'Tipo de Período';
    $Self->{Translation}->{'Opening Period'} = 'Período por Data de Abertura';
    $Self->{Translation}->{'Closing Period'} = 'Período por Data de Fechamento';
    $Self->{Translation}->{'Closing Period'} = 'Período por Data de Fechamento';
    $Self->{Translation}->{'NumberOfEmails'} = 'Quantidade de emails enviados';
    $Self->{Translation}->{'AverageFirstResponseInMin'} = 'Tempo médio de primeira resposta em minutos';
    $Self->{Translation}->{'AverageFirstResponse'} = 'Tempo médio de primeira resposta';
    $Self->{Translation}->{'AverageSolution'} = 'Tempo médio de solução';
    $Self->{Translation}->{'AverageSolutionInMin'} = 'Tempo médio de solução em minutos';
    $Self->{Translation}->{'Send Mail Date'} = 'Data de envio do Email';
    $Self->{Translation}->{'Send Mail Hour'} = 'Hora do envio do Email';
    $Self->{Translation}->{'General report of average time indicators for first response and solution by Agents.'} = 
        'Relatório geral de indicadores de média de tempos sobre primeira resposta e solução por parte dos Agentes.';
    $Self->{Translation}->{'General report of indicators for first response and solution times.'} = 
        'Relatório geral de indicadores de tempos de primeira resposta e solução.';
    $Self->{Translation}->{'General report of articles of type email sent to the customer.'} = 
        'Relatório geral de artigos do tipo email enviado para o cliente.';

}

1;
