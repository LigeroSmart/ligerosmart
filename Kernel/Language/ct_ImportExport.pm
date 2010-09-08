# --
# Kernel/Language/ct_ImportExport.pm - the catalan translation of ImportExport
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Sistemes OTIC (ibsalut) - Antonio Linde
# --
# $Id: ct_ImportExport.pm,v 1.5 2010-09-08 18:02:53 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ct_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'}              = 'Importar/Exportar';
    $Lang->{'Import/Export Management'}   = 'Gestiò de Importar/Exportar';
    $Lang->{'Add mapping template'}       = 'Afegir plantilla de mapatge';
    $Lang->{'Start Import'}               = 'Començar importació';
    $Lang->{'Start Export'}               = 'Començar exportació';
    $Lang->{'Step'}                       = 'Pas';
    $Lang->{'Edit common information'}    = 'Editar informació comuna';
    $Lang->{'Edit object information'}    = 'Editar informació d\'objecte';
    $Lang->{'Edit format information'}    = 'Editar informació de format';
    $Lang->{'Edit mapping information'}   = 'Editar informació de mapatge';
    $Lang->{'Edit search information'}    = 'Editar informació de recerca';
    $Lang->{'Import information'}         = 'Importar informació';
    $Lang->{'Column'}                     = 'Columna';
    $Lang->{'Restrict export per search'} = 'Restringir exportació per recerca';
    $Lang->{'Source File'}                = 'Fitxer font';
    $Lang->{'Column Separator'}           = 'Separador de columna';
    $Lang->{'Tabulator (TAB)'}            = 'Tabulador (TAB)';
    $Lang->{'Semicolon (;)'}              = 'Punt i coma (;)';
    $Lang->{'Colon (:)'}                  = 'Dos punts (:)';
    $Lang->{'Dot (.)'}                    = 'Punt (.)';
    $Lang->{'Charset'}                    = 'Conjunt de caràcters';
    $Lang->{'Frontend module registration for the agent interface.'} = '';
    $Lang->{'Format backend module registration for the import/export module.'} = '';
    $Lang->{'Import and export object information.'} = '';

    return 1;
}

1;
