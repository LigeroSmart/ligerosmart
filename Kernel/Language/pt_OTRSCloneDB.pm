# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pt_OTRSCloneDB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'List of tables should be skipped, perhaps internal DB tables. Please use lowercase.'} =
        'Lista de tabelas a ser ignoradas, talvez tabelas internas da BD.   Por favor utilize letras minúsculas.';
    $Self->{Translation}->{'Log file for replacement of malformed UTF-8 data values.'} = 'Ficheiro de log para a substituição de valores de dados UTF-8 com defeito.';
    $Self->{Translation}->{'Settings for connecting with the target database.'} = 'Configurações para ligação à base de dados destino.';
    $Self->{Translation}->{'Specifies which columns should be checked for valid UTF-8 source data.'} =
        'Especifica que colunas a verificar para dados de origem UTF-8 válidos.';
    $Self->{Translation}->{'This setting specifies which table columns contain blob data as these need special treatment.'} =
        'Este parâmetro específica que colunas da tabela contém, dados blob, pois necessitam de tratamento especial.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
