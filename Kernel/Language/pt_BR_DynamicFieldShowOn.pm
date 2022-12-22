# --
# Copyright (C) 2015-2019 Ligero https://ligero.online
# Copyright (C) 2015-2019 Complemento https://complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::Language::pt_BR_DynamicFieldShowOn;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Dynamic Field Allocation'} = 'Alocação de Campos Dinâmicos';
    $Self->{Translation}->{'Select system areas to allocate this Dynamic Field'} = 'Selecione as áreas do sistema para alocar este Campo Dinâmico';
    $Self->{Translation}->{'Areas'} = 'Áreas';

    $Self->{Translation}->{'Visibility'} = 'Visibilidade ';
    $Self->{Translation}->{'Dynamic Fields Process Widget Details'} = 'Campos Dinâmicos na Visão de Processo';
    $Self->{Translation}->{'Show in these groups'} = 'Mostrar nestes grupos ';

    $Self->{Translation}->{'Agent - Free Text'} = 'Atendente - Texto Livre';
    $Self->{Translation}->{'Agent - Edit Article'} = 'Atendente - Editar Artigo';
    $Self->{Translation}->{'Agent - Owner'} = 'Atendente - Proprietário';
    $Self->{Translation}->{'Agent - Pending'} = 'Atendente - Pendente';
    $Self->{Translation}->{'Agent - New Phone Ticket'} = 'Atendente - Novo Chamado Telefônico';
    $Self->{Translation}->{'Agent - Ticket Zoom'} = 'Atendente - Visão do Chamado';
    $Self->{Translation}->{'Agent - New Email Ticket'} = 'Atendente - Novo Chamado por E-mail';
    $Self->{Translation}->{'Agent - New Reply'} = 'Atendente - Nova Resposta';
    $Self->{Translation}->{'Agent - Outbound Email'} = 'Atendente - E-mail de Saída';
    $Self->{Translation}->{'Customer - List of Tickets'} = 'Cliente - Lista de Chamados';
    $Self->{Translation}->{'Customer - Ticket Zoom'} = 'Cliente - Visão do Chamado';
    $Self->{Translation}->{'Customer - Search'} = 'Cliente - Pesquisa de Chamados';
    $Self->{Translation}->{'Agent - Print'} = 'Atendente - Imprimir';
    $Self->{Translation}->{'Agent - Forward'} = 'Atendente - Encaminhar';
    $Self->{Translation}->{'Agent - Move'} = 'Atendente - Mover';
    $Self->{Translation}->{'Agent - Inbound Phone'} = 'Atendente - Chamada Telefônica Recebida';
    $Self->{Translation}->{'Agent - New Note'} = 'Atendente - Nova Nota';
    $Self->{Translation}->{'Agent - Outbound Phone'} = 'Atendente - Chamada Telefônica Realizada';
    $Self->{Translation}->{'Agent - Responsible'} = 'Atendente - Responsável';
    $Self->{Translation}->{'Agent - Additional ITSM Fields'} = 'Atendente - Campos ITSM Adicionais';
    $Self->{Translation}->{'Agent - Smart Classification'} = 'Atendente - Classificação Inteligente';
    $Self->{Translation}->{'Agent - List of Tickets'} = 'Atendente - Lista de Chamados';
    $Self->{Translation}->{'Customer - Print'} = 'Cliente - Imprimir';
    $Self->{Translation}->{'Agent - Search'} = 'Atendente - Pesquisa de Chamados';
    $Self->{Translation}->{'Agent - Priority'} = 'Atendente - Prioridade';
    $Self->{Translation}->{'Agent - Close'} = 'Atendente - Fechar';
    $Self->{Translation}->{'Agent - Decision'} = 'Atendente - Decisão';
    $Self->{Translation}->{'Customer - New Ticket'} = 'Cliente - Novo Chamado';
    $Self->{Translation}->{'Agent - Process Widget'} = 'Atendente - Visão de Processo';

    $Self->{Translation}->{'0 - Disabled'} = '0 - Desabilitado';
    $Self->{Translation}->{'1 - Enabled'} = '1 - Habilitado';
    $Self->{Translation}->{'2 - Enabled and Mandatory'} = '2 - Habilitado e Obrigatório';

    return;
}

1;
