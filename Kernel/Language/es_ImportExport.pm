# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::es_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Gestión de Importación/Exportación';
    $Self->{Translation}->{'Add template'} = 'Agregar plantilla';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Crear una plantilla para importar y exportar información de objetos.';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        '';
    $Self->{Translation}->{'Start Import'} = 'Iniciar Importación';
    $Self->{Translation}->{'Start Export'} = 'Iniciar Exportación';
    $Self->{Translation}->{'Delete this template'} = '';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = 'Paso 1 de 5 - Editar la información común';
    $Self->{Translation}->{'Name is required!'} = 'Es requerido un nombre!';
    $Self->{Translation}->{'Object is required!'} = 'Es requerido un objeto!';
    $Self->{Translation}->{'Format is required!'} = 'Es requerido un formato.';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = 'Paso 2 de 5 - Editar la información del objeto';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = 'Paso 3 de 5 - Editar la información de formato';
    $Self->{Translation}->{'is required!'} = 'es requerido!';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = 'Paso 4 de 5 - Editar la información de mapeo';
    $Self->{Translation}->{'No map elements found.'} = 'No se han encontrado mapas.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Agregar un Elemento de Mapeo';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = 'Paso 5 de 5 - Editar información de búsqueda';
    $Self->{Translation}->{'Restrict export per search'} = 'Restringir la exportación a la búsqueda';
    $Self->{Translation}->{'Import information'} = 'Información de importación';
    $Self->{Translation}->{'Source File'} = 'Archivo Fuente';
    $Self->{Translation}->{'Import summary for %s'} = 'Resumen de importación para %s';
    $Self->{Translation}->{'Records'} = 'Registros';
    $Self->{Translation}->{'Success'} = 'Éxito';
    $Self->{Translation}->{'Duplicate names'} = 'Nombres duplicados';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Último número de línea procesada del archivo a importar';
    $Self->{Translation}->{'Ok'} = 'Aceptar';
    $Self->{Translation}->{'Do you really want to delete this template item?'} = '';

    # Perl Module: Kernel/Modules/AdminImportExport.pm
    $Self->{Translation}->{'No object backend found!'} = '¡No se encontró un \'backend\' para el objeto!';
    $Self->{Translation}->{'No format backend found!'} = '¡No se encontró un \'backend\' para el formato!';
    $Self->{Translation}->{'Template not found!'} = '¡No se encontró la plantilla!';
    $Self->{Translation}->{'Can\'t insert/update template!'} = '¡No fue posible insertar/actualizar la plantilla!';
    $Self->{Translation}->{'Needed TemplateID!'} = '¡Se necesita \'TemplateID\'!';
    $Self->{Translation}->{'Error occurred. Import impossible! See Syslog for details.'} = 'Ha ocurrido un error. ¡Imposible de Importar¡ Revise las trazas del sistema para obtener los detalles.';
    $Self->{Translation}->{'Error occurred. Export impossible! See Syslog for details.'} = 'Ha ocurrido un error. ¡Imposible de Exportar¡ Revise las trazas del sistema para obtener los detalles.';
    $Self->{Translation}->{'Template List'} = 'Lista de Plantillas';
    $Self->{Translation}->{'number'} = 'número';
    $Self->{Translation}->{'number bigger than zero'} = 'número mayor a cero';
    $Self->{Translation}->{'integer'} = 'entero';
    $Self->{Translation}->{'integer bigger than zero'} = 'entero mayor a cero';
    $Self->{Translation}->{'Element required, please insert data'} = 'Elemento requerido, por favor inserte el dato';
    $Self->{Translation}->{'Invalid data, please insert a valid %s'} = 'Datos inválidos, por favor oeste un %s válido';
    $Self->{Translation}->{'Format not found!'} = '¡No se encontró el Formato!';

    # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
    $Self->{Translation}->{'Column Separator'} = 'Separador de Columna';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulador (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Punto y coma (;)';
    $Self->{Translation}->{'Colon (:)'} = 'Dos Puntos (:)';
    $Self->{Translation}->{'Dot (.)'} = 'Punto (.)';
    $Self->{Translation}->{'Comma (,)'} = 'Coma (,)';
    $Self->{Translation}->{'Charset'} = 'Conjunto de Caracteres';
    $Self->{Translation}->{'Include Column Headers'} = 'Incluir Cabecera de Columnas';
    $Self->{Translation}->{'Column'} = 'Calumna';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = '';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        '';
    $Self->{Translation}->{'Template was deleted successfully.'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Formato del módulo administrativo de registro para el módulo de importación/exportación.';
    $Self->{Translation}->{'Import and export object information.'} = 'Importar y exportar información de un objeto.';
    $Self->{Translation}->{'Import/Export'} = 'Importar/Exportar';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Confirm',
    'Delete this template',
    'Deleting template...',
    'Template was deleted successfully.',
    'There was an error deleting the template. Please check the logs for more information.',
    );

}

1;
