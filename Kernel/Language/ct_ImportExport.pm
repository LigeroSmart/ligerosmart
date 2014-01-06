# --
# Kernel/Language/ct_ImportExport.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ct_ImportExport;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = 'Afegir plantilla de mapatge';
    $Self->{Translation}->{'Charset'} = 'Conjunt de caràcters';
    $Self->{Translation}->{'Colon (:)'} = 'Dos punts (:)';
    $Self->{Translation}->{'Column'} = 'Columna';
    $Self->{Translation}->{'Column Separator'} = 'Separador de columna';
    $Self->{Translation}->{'Dot (.)'} = 'Punt (.)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Punt i coma (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulador (TAB)';
    $Self->{Translation}->{'Include Column Headers'} = '';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Gestiò de Importar/Exportar';
    $Self->{Translation}->{'Add template'} = '';
    $Self->{Translation}->{'Create a template to import and export object information.'} = '';
    $Self->{Translation}->{'Start Import'} = 'Començar importació';
    $Self->{Translation}->{'Start Export'} = 'Començar exportació';
    $Self->{Translation}->{'Delete Template'} = '';
    $Self->{Translation}->{'Step'} = 'Pas';
    $Self->{Translation}->{'Edit common information'} = 'Editar informació comuna';
    $Self->{Translation}->{'Object is required!'} = '';
    $Self->{Translation}->{'Format is required!'} = '';
    $Self->{Translation}->{'Edit object information'} = 'Editar informació d\'objecte';
    $Self->{Translation}->{'Edit format information'} = 'Editar informació de format';
    $Self->{Translation}->{' is required!'} = '';
    $Self->{Translation}->{'Edit mapping information'} = 'Editar informació de mapatge';
    $Self->{Translation}->{'No map elements found.'} = '';
    $Self->{Translation}->{'Add Mapping Element'} = '';
    $Self->{Translation}->{'Edit search information'} = 'Editar informació de recerca';
    $Self->{Translation}->{'Restrict export per search'} = 'Restringir exportació per recerca';
    $Self->{Translation}->{'Import information'} = 'Importar informació';
    $Self->{Translation}->{'Source File'} = 'Fitxer font';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} = '';
    $Self->{Translation}->{'Import and export object information.'} = '';
    $Self->{Translation}->{'Import/Export'} = 'Importar/Exportar';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
