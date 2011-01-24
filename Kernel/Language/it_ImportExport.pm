# --
# Kernel/Language/it_ImportExport.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: it_ImportExport.pm,v 1.6 2011-01-24 20:49:14 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::it_ImportExport;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = 'Aggiungi mappatura modello';
    $Self->{Translation}->{'Charset'} = 'Charset';
    $Self->{Translation}->{'Colon (:)'} = 'Due punti (:)';
    $Self->{Translation}->{'Column'} = 'Colonna';
    $Self->{Translation}->{'Column Separator'} = 'Separatore di colonna';
    $Self->{Translation}->{'Dot (.)'} = 'Punto (.)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Punto e virgola (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulatore (TAB)';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Gestione Importazione/Esportazione';
    $Self->{Translation}->{'Add template'} = '';
    $Self->{Translation}->{'Create a template to import and export object information.'} = '';
    $Self->{Translation}->{'Start Import'} = 'Iniziare Importazione';
    $Self->{Translation}->{'Start Export'} = 'Iniziare Esportazione';
    $Self->{Translation}->{'Delete Template'} = '';
    $Self->{Translation}->{'Step'} = 'Passo';
    $Self->{Translation}->{'Edit common information'} = 'Modifica informazioni comuni';
    $Self->{Translation}->{'Object is required!'} = '';
    $Self->{Translation}->{'Format is required!'} = '';
    $Self->{Translation}->{'Edit object information'} = 'Modifica informazioni oggetto';
    $Self->{Translation}->{'Edit format information'} = 'Modifica formato informazione';
    $Self->{Translation}->{' is required!'} = '';
    $Self->{Translation}->{'Edit mapping information'} = 'Modifica mappatura informazioni';
    $Self->{Translation}->{'No map elements found.'} = '';
    $Self->{Translation}->{'Add Mapping Element'} = '';
    $Self->{Translation}->{'Edit search information'} = 'Modifica informazioni di ricerca';
    $Self->{Translation}->{'Restrict export per search'} = 'Restringere esportazione per ricerca';
    $Self->{Translation}->{'Import information'} = 'Importare informazione';
    $Self->{Translation}->{'Source File'} = 'Archivio origine';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} = '';
    $Self->{Translation}->{'Import and export object information.'} = '';
    $Self->{Translation}->{'Import/Export'} = 'Importare/Esportare';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
