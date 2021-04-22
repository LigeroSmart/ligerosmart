# --
# Kernel/Language/pt_BR_GeneralCatalog.pm - translation file
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_Followers;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{"Select All"} = "Selecionar todos";
    $Self->{Translation}->{"Add a note to the ticket. You can send notes to all agents or using the checkbox  to choose the recipients."} = "Adicionar uma nota ao ticket. Você pode enviar notas para todos os agentes ou usando a caixa de seleção para escolher os destinatários";
    $Self->{Translation}->{"Users"} = "Usuários";
	
   $Self->{Translation}->{"Please fill the field."} = "Por favor, preencha o campo";
}

1;
