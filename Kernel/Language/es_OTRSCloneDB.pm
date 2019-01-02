# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::es_OTRSCloneDB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'List of tables should be skipped, perhaps internal DB tables. Please use lowercase.'} =
        'La lista de tablas debe omitirse, quizás tablas de Bases de datos internas. Utilice minúsculas.';
    $Self->{Translation}->{'Log file for replacement of malformed UTF-8 data values.'} = 'Archivo de registro para el reemplazo de valores de datos UTF-8 con formato incorrecto.';
    $Self->{Translation}->{'Settings for connecting with the target database.'} = 'Configuración para conectarse con la base de datos de destino.';
    $Self->{Translation}->{'Specifies which columns should be checked for valid UTF-8 source data.'} =
        'Especifica qué columnas deben comprobarse para los datos de origen UTF-8 válidos.';
    $Self->{Translation}->{'This setting specifies which table columns contain blob data as these need special treatment.'} =
        'Esta configuración especifica qué columnas de tabla contienen datos de blob ya que éstos necesitan un tratamiento especial.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
