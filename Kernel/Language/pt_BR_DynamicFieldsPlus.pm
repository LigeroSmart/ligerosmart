# --
# Copyright (C) 2015-2019 Ligero https://ligero.online
# Copyright (C) 2015-2019 Complemento https://complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::Language::pt_BR_DynamicFieldsPlus;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Dynamic Field Allocation'} = 'Alocação de Campos Dinâmicos';
    $Self->{Translation}->{'Select system areas to allocate this Dynamic Field'} = 'Selecione as áreas do sistema para alocar este Campo Dinâmico';
    $Self->{Translation}->{'Areas'} = 'Áreas';
    $Self->{Translation}->{'Agent Iterface - New Phone Ticket'} = 'Interface do Agente - Novo chamado via fone';
    $Self->{Translation}->{'Customer Interface - New Ticket'} = 'Interface do Cliente - Abertura de chamados';
    $Self->{Translation}->{'Agent Interface - Ticket Zoom'} = 'Interface do Agente - Detalhes do chamado';
    $Self->{Translation}->{'Customer Interface - Ticket Zoom'} = 'Interface do Cliente - Detalhes do chamado';
    $Self->{Translation}->{'Agent Interface - Process Widget'} = 'Interface do Agente - Visão de processo do chamado';
    $Self->{Translation}->{'Agent Interface - New Email Ticket'} = 'Interface do Agente - Novo chamado via e-mail';
    $Self->{Translation}->{'Agent Interface - Allow ticket search'} = 'Interface do Agente - Permitir pesquisa de ticket';
    $Self->{Translation}->{'Agent Interface - Allow show as column on ticket lists'} = 'Interface do Agente - Permitir mostrar como coluna nas listas de ticket';
    $Self->{Translation}->{'Agent Interface - Free Text'} = 'Interface do Agente - Texto livre';
    $Self->{Translation}->{'Agent Interface - Note'} = 'Interface do Agente - Nota';
    $Self->{Translation}->{'Agent Interface - Close'} = 'Interface do Agente - Fechamento';
    $Self->{Translation}->{'Visibility '} = 'Visibilidade ';
    $Self->{Translation}->{'Dynamic Fields Process Widget Details'} = 'Campos Dinâmicos no Widget do chamado';
    $Self->{Translation}->{'Group '} = 'Grupo ';
    $Self->{Translation}->{'0 - Disabled'} = '0 - Desabilitado';
    $Self->{Translation}->{'1 - Enabled'} = '1 - Habilitado';
    $Self->{Translation}->{'2 - Enabled and Mandatory'} = '2 - Habilitado e Obrigatório';

    return;
}

1;