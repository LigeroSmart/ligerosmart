# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::es_MX_OTRSCloneDB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'List of tables should be skipped, perhaps internal DB tables. Please use lowercase.'} =
        'Lista de las tablas que deben ser omitidas, quizá tablas internas de la Base de Datos. Por favor utilice minúsculas.';
    $Self->{Translation}->{'Log file for replacement of malformed UTF-8 data values.'} = 'Archivo de trazas para los valores de los datos UTF-8 incorrectos o reemplazados.';
    $Self->{Translation}->{'Settings for connecting with the target database.'} = 'Ajustes de conexión a la base de datos destino.';
    $Self->{Translation}->{'Specifies which columns should be checked for valid UTF-8 source data.'} =
        'Especifica qué columnas deben verificarse para obtener datos de origen UTF-8 válidos.';
    $Self->{Translation}->{'This setting specifies which table columns contain blob data as these need special treatment.'} =
        'Esta configuración especifica qué columnas de la tabla contienen datos \'blob\', ya que necesitan un tratamiento especial.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
