# --
# Kernel/Language/es_ImportExport.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: es_ImportExport.pm,v 1.15 2011-11-24 15:42:26 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_ImportExport;

use strict;

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
    $Self->{Translation}->{'Include Column Headers'} = '';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Gestión de Importación/Exportación';
    $Self->{Translation}->{'Add template'} = '';
    $Self->{Translation}->{'Create a template to import and export object information.'} = '';
    $Self->{Translation}->{'Start Import'} = 'Iniciar Importación';
    $Self->{Translation}->{'Start Export'} = 'Iniciar Exportación';
    $Self->{Translation}->{'Delete Template'} = '';
    $Self->{Translation}->{'Step'} = 'Paso';
    $Self->{Translation}->{'Edit common information'} = 'Editar información común';
    $Self->{Translation}->{'Object is required!'} = '¡Debe especificar Objeto!';
    $Self->{Translation}->{'Format is required!'} = '¡Debe especificar Formato!';
    $Self->{Translation}->{'Edit object information'} = 'Editar información de objeto';
    $Self->{Translation}->{'Edit format information'} = 'Editar información del formato';
    $Self->{Translation}->{' is required!'} = '';
    $Self->{Translation}->{'Edit mapping information'} = 'Editar información de mapeo';
    $Self->{Translation}->{'No map elements found.'} = 'No se encontraron elementos de mapeo.';
    $Self->{Translation}->{'Add Mapping Element'} = '';
    $Self->{Translation}->{'Edit search information'} = 'Editar información de búsqueda';
    $Self->{Translation}->{'Restrict export per search'} = 'Restringir exportación por búsqueda';
    $Self->{Translation}->{'Import information'} = 'Importar información';
    $Self->{Translation}->{'Source File'} = 'Archivo origen';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} = 'Registro de módulo de formato backend para el módulo import/export.';
    $Self->{Translation}->{'Import and export object information.'} = 'Importar y exportar información de objetos.';
    $Self->{Translation}->{'Import/Export'} = 'Importar/Exportar';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Class is required!'} = '¡Debe especificar Clase!';
    $Self->{Translation}->{'Column Separator is required!'} = '¡Debe especificar Separador de Columna!';
    $Self->{Translation}->{'Comma (,)'} = 'Coma (,)';
    $Self->{Translation}->{'Create a template in order to can import and export object information.'} = 'Agregue una plantilla nueva para poder importar y exportar.';
    $Self->{Translation}->{'Empty fields indicate that the current values are kept'} = 'Los campos vacíos indican que los valores actuales se mantienen';
    $Self->{Translation}->{'Go back'} = 'Regresar';

}

1;
