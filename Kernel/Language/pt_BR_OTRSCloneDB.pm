# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pt_BR_OTRSCloneDB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'List of tables should be skipped, perhaps internal DB tables. Please use lowercase.'} =
        'Lista de tabelas que devem ser ignoradas, talvez tabelas de DB interno. Por favor, use letras minúsculas.';
    $Self->{Translation}->{'Log file for replacement of malformed UTF-8 data values.'} = 'Arquivo de log para substituição de valores de dados UTF-8 com formato incorreto.';
    $Self->{Translation}->{'Settings for connecting with the target database.'} = 'Configurações para conexão com o banco de dados de destino.';
    $Self->{Translation}->{'Specifies which columns should be checked for valid UTF-8 source data.'} =
        'Especifica quais colunas devem ser verificadas para validar a fonte de dados UTF-8.';
    $Self->{Translation}->{'This setting specifies which table columns contain blob data as these need special treatment.'} =
        'Essa configuração especifica quais colunas de tabela contêm dados do tipo blob, pois elas precisam de tratamento especial.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
