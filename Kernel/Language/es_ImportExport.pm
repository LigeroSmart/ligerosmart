# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = 'Añadir plantilla de mapeo';
    $Self->{Translation}->{'Charset'} = 'Juego de caracteres';
    $Self->{Translation}->{'Colon (:)'} = 'Dos puntos (:)';
    $Self->{Translation}->{'Column'} = 'Columna';
    $Self->{Translation}->{'Column Separator'} = 'Separador de Columna';
    $Self->{Translation}->{'Dot (.)'} = 'Punto (.)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Punto y Coma (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulador (TAB)';
    $Self->{Translation}->{'Include Column Headers'} = 'Incluir Cabecera de la Columna';
    $Self->{Translation}->{'Import summary for'} = 'Importar resumen para';
    $Self->{Translation}->{'Imported records'} = 'Registros importados';
    $Self->{Translation}->{'Exported records'} = 'Registros exportados';
    $Self->{Translation}->{'Records'} = 'Registros';
    $Self->{Translation}->{'Skipped'} = 'Saltado';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Gestión de Importación/Exportación';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Crear una plantilla para importar y exportar informacion del objeto.';
    $Self->{Translation}->{'Start Import'} = 'Iniciar Importación';
    $Self->{Translation}->{'Start Export'} = 'Iniciar Exportación';
    $Self->{Translation}->{'Step'} = 'Paso';
    $Self->{Translation}->{'Edit common information'} = 'Editar información común';
    $Self->{Translation}->{'Name is required!'} = 'El nombre es requerido';
    $Self->{Translation}->{'Object is required!'} = '¡Debe especificar Objeto!';
    $Self->{Translation}->{'Format is required!'} = '¡Debe especificar Formato!';
    $Self->{Translation}->{'Edit object information'} = 'Editar información de objeto';
    $Self->{Translation}->{'Edit format information'} = 'Editar información del formato';
    $Self->{Translation}->{'is required!'} = '¡es requerido!';
    $Self->{Translation}->{'Edit mapping information'} = 'Editar información de mapeo';
    $Self->{Translation}->{'No map elements found.'} = 'No se encontraron elementos de mapeo.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Añadir Mapeo de Elementos';
    $Self->{Translation}->{'Edit search information'} = 'Editar información de búsqueda';
    $Self->{Translation}->{'Restrict export per search'} = 'Restringir exportación por búsqueda';
    $Self->{Translation}->{'Import information'} = 'Importar información';
    $Self->{Translation}->{'Source File'} = 'Archivo origen';
    $Self->{Translation}->{'Success'} = 'Éxito';
    $Self->{Translation}->{'Failed'} = 'Fracasado';
    $Self->{Translation}->{'Duplicate names'} = 'Nombres duplicados';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Última número de línea procesada del archivo importar';
    $Self->{Translation}->{'Ok'} = 'Ok';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Registro de módulo de formato backend para el módulo import/export.';
    $Self->{Translation}->{'Import and export object information.'} = 'Importar y exportar información de objetos.';
    $Self->{Translation}->{'Import/Export'} = 'Importar/Exportar';

}

1;
