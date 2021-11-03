# --
# Copyright (C) 2015-2019 Ligero https://ligero.online
# Copyright (C) 2015-2019 Complemento https://complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::Language::pt_BR_CustomerContracts;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;
    
    $Self->{Translation}->{'Customer Contract'} = 'Contratos de Clientes';
    $Self->{Translation}->{'Create and manage customer contacts.'} = 'Crie e gerencie contratos.';
    $Self->{Translation}->{'Customer Contract Management'} = 'Gerenciamento de Contratos de Clientes';
    $Self->{Translation}->{'Search for customer name.'} = 'Procure pelo nome do cliente.';
    $Self->{Translation}->{'Add customer contract'} = 'Adicionar um contrato de cliente';
    $Self->{Translation}->{'Customer contacts are needed to have a customer costs history.'} = 'Os contatos do cliente são necessários para ter um histórico de custos do cliente.';
    $Self->{Translation}->{'Add Customer Contract'} = 'Adicionar um contrato de cliente';
    $Self->{Translation}->{'Contract Type'} = 'Tipo de Contrato';
    $Self->{Translation}->{'Closing Period'} = 'Periodo de Fechamento';
    $Self->{Translation}->{'Absolut Period'} = 'Periodo Absoluto';
    $Self->{Translation}->{'Relative Period'} = 'Periodo Relativo';
    $Self->{Translation}->{'Price Rules'} = 'Regras de Preço';
    $Self->{Translation}->{'Franchise Rules'} = 'Regras de Franquia';
    $Self->{Translation}->{'Treatment Types'} = 'Tipos de Tratamentos';
    $Self->{Translation}->{'Total Value'} = 'Valor Total';
    $Self->{Translation}->{'Value Remaining'} = 'Valor Restante';
    $Self->{Translation}->{'Customer Address'} = 'Endereço do Cliente';
    $Self->{Translation}->{'Customer City'} = 'Cidade do Cliente';
    $Self->{Translation}->{'Validy Contracts'} = 'Contratos Vigentes';
    $Self->{Translation}->{'Hour / Value Avaliable'} = 'Horas / Valor Disponível';
    $Self->{Translation}->{'Hour / Value Used'} = 'Horas / Valor Utilizados';
    $Self->{Translation}->{'Recurrence'} = 'Recorrência';
    $Self->{Translation}->{'Value Hours'} = 'Valor Horas';

    return;
}

1;