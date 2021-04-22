# --
# Kernel/Language/pt_BR_GeneralCatalog.pm - translation file
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_AutoTicket;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{"Add AutoTicket"} = "Adicionar AutoTicket";
    $Self->{Translation}->{"Manage AutoTickets"} = "Gerenciar AutoTickets";
    $Self->{Translation}->{"Methods descriptions"} = "Descrição dos Métodos (NBD = Non Business Day, ou dia não útil ou folga)";
    $Self->{Translation}->{"Create based on SLA. By Pass NBD."} = "Criar de acordo com o SLA. Não criar se cair em DNU.";
    $Self->{Translation}->{"Create based on SLA. On NBD, solution on next business hour."} 
		= "Criar de acordo com o SLA. Em DNU, solução será na próxima hora útil.";
    $Self->{Translation}->{"Create based on SLA. On NBD, solution on previous business day."} 
		= "Criar de acordo com o SLA. Em DNU, solução será no dia útil anterior.";
    $Self->{Translation}->{"Create based on SLA. On NBD, solution on next business day."} 
		= "Criar de acordo com o SLA. Em DNU, solução será no próximo dia útil.";
    $Self->{Translation}->{"Create at scheduled time."} = "Criar no horário programado.";
    $Self->{Translation}->{"NBD = Non Business Day"} = "DNU = Dia não útil";
    $Self->{Translation}->{"Edit AutoTicket"} = "Editar AutoTicket";
    $Self->{Translation}->{"Ticket Title"} = "Titulo do Chamado";
    $Self->{Translation}->{"Customer Login"} = "Login do Cliente";
    $Self->{Translation}->{"First Article Text"} = "Texto do primeiro artigo";
    $Self->{Translation}->{"Creation Method"} = "Método de Criação";
    $Self->{Translation}->{"Repeat On"} = "Repetir em";
    $Self->{Translation}->{"Month day (separated by ;)"} = "Dias do mês (separados por ;)";
    $Self->{Translation}->{"Months"} = "Meses";
}

1;
