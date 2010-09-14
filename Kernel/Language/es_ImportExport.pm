# --
# Kernel/Language/es_ImportExport.pm - the spanish translation of ImportExport
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Aquiles Cohen
# --
# $Id: es_ImportExport.pm,v 1.11 2010-09-14 21:49:14 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'}              = 'Importar/Exportar';
    $Lang->{'Import/Export Management'}   = 'Gestión de Importación/Exportación';
    $Lang->{'Add mapping template'}       = 'Añadir plantilla de mapeo';
    $Lang->{'Start Import'}               = 'Iniciar Importación';
    $Lang->{'Start Export'}               = 'Iniciar Exportación';
    $Lang->{'Step'}                       = 'Paso';
    $Lang->{'Edit common information'}    = 'Editar información común';
    $Lang->{'Edit object information'}    = 'Editar información de objeto';
    $Lang->{'Edit format information'}    = 'Editar información del formato';
    $Lang->{'Edit mapping information'}   = 'Editar información de mapeo';
    $Lang->{'Edit search information'}    = 'Editar información de búsqueda';
    $Lang->{'Import information'}         = 'Importar información';
    $Lang->{'Column'}                     = 'Columna';
    $Lang->{'Restrict export per search'} = 'Restringir exportación por búsqueda';
    $Lang->{'Source File'}                = 'Archivo origen';
    $Lang->{'Column Separator'}           = 'Separador de Columna';
    $Lang->{'Tabulator (TAB)'}            = 'Tabulador (TAB)';
    $Lang->{'Semicolon (;)'}              = 'Punto y Coma (;)';
    $Lang->{'Colon (:)'}                  = 'Dos puntos (:)';
    $Lang->{'Dot (.)'}                    = 'Punto (.)';
    $Lang->{'Comma (,)'}                  = 'Coma (,)';
    $Lang->{'Charset'}                    = 'Juego de caracteres';
    $Lang->{'Frontend module registration for the agent interface.'} = 'Registro de módulo frontend para la interfaz del agente.';
    $Lang->{'Format backend module registration for the import/export module.'} = 'Registro de módulo de formato backend para el módulo import/export.';
    $Lang->{'Import and export object information.'} = 'Importar y exportar información de objetos.';
    $Lang->{'Object is required!'} = '¡Debe especificar Objeto!';
    $Lang->{'Format is required!'} = '¡Debe especificar Formato!';
    $Lang->{'Class is required!'} = '¡Debe especificar Clase!';
    $Lang->{'Column Separator is required!'} = '¡Debe especificar Separador de Columna!';
    $Lang->{'No map elements found.'} = 'No se encontraron elementos de mapeo.';
    $Lang->{'Empty fields indicate that the current values are kept'} = 'Los campos vacíos indican que los valores actuales se mantienen';
    $Lang->{'Create a template in order to can import and export object information.'} = 'Agregue una plantilla nueva para poder importar y exportar.';

    return 1;
}

1;
