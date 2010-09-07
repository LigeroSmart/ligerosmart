# --
# Kernel/Language/es_ImportExport.pm - the spanish translation of ImportExport
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Aquiles Cohen
# --
# $Id: es_ImportExport.pm,v 1.7 2010-09-07 21:29:15 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'}              = 'Importar/Exportar';
    $Lang->{'Import/Export Management'}   = 'Gestión de Importación/Exportación';
    $Lang->{'Add mapping template'}       = 'Añadir mapeado de plantilla';
    $Lang->{'Start Import'}               = 'Iniciar Importación';
    $Lang->{'Start Export'}               = 'Iniciar Exportación';
    $Lang->{'Step'}                       = 'Paso';
    $Lang->{'Edit common information'}    = 'Editar información común';
    $Lang->{'Edit object information'}    = 'Editar información de objeto';
    $Lang->{'Edit format information'}    = 'Editar formato de información';
    $Lang->{'Edit mapping information'}   = 'Editar mapeado de información';
    $Lang->{'Edit search information'}    = 'Editar información de busqueda';
    $Lang->{'Import information'}         = 'Importar información';
    $Lang->{'Column'}                     = 'Columna';
    $Lang->{'Restrict export per search'} = 'Restringir exportación por consulta';
    $Lang->{'Source File'}                = 'Archivo origen';
    $Lang->{'Column Separator'}           = 'Separador de Columna';
    $Lang->{'Tabulator (TAB)'}            = 'Tabulador (TAB)';
    $Lang->{'Semicolon (;)'}              = 'Punto y Coma (;)';
    $Lang->{'Colon (:)'}                  = 'Dos puntos (:)';
    $Lang->{'Dot (.)'}                    = 'Punto (.)';
    $Lang->{'Charset'}                    = '';
    $Lang->{'Frontend module registration for the AdminImportExport in the admin area.'} = 'Registro de módulo frontend AdminImportExport en el área de admin';
    $Lang->{'Format backend module registration for the import/export module.'} = 'Formato backend para el módulo import/export.';
    return 1;
}

1;
