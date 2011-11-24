# --
# Kernel/Language/cs_ImportExport.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: cs_ImportExport.pm,v 1.4 2011-11-24 15:42:26 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cs_ImportExport;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = 'Nová šablona zobrazení';
    $Self->{Translation}->{'Charset'} = 'Znaková sada';
    $Self->{Translation}->{'Colon (:)'} = 'Dvojtečka (:)';
    $Self->{Translation}->{'Column'} = 'Sloupec';
    $Self->{Translation}->{'Column Separator'} = 'Oddělovač Sloupců';
    $Self->{Translation}->{'Dot (.)'} = 'Tečka (.)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Středník (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulátor (TAB)';
    $Self->{Translation}->{'Include Column Headers'} = '';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Import/Export Správa';
    $Self->{Translation}->{'Add template'} = '';
    $Self->{Translation}->{'Create a template to import and export object information.'} = '';
    $Self->{Translation}->{'Start Import'} = 'Zahájit Import';
    $Self->{Translation}->{'Start Export'} = 'Zahájit Export';
    $Self->{Translation}->{'Delete Template'} = '';
    $Self->{Translation}->{'Step'} = 'Krok';
    $Self->{Translation}->{'Edit common information'} = 'Editace obecných informací';
    $Self->{Translation}->{'Object is required!'} = '';
    $Self->{Translation}->{'Format is required!'} = '';
    $Self->{Translation}->{'Edit object information'} = 'Editace informací o objektu';
    $Self->{Translation}->{'Edit format information'} = 'Editace formátu';
    $Self->{Translation}->{' is required!'} = '';
    $Self->{Translation}->{'Edit mapping information'} = 'Editace mapování';
    $Self->{Translation}->{'No map elements found.'} = '';
    $Self->{Translation}->{'Add Mapping Element'} = '';
    $Self->{Translation}->{'Edit search information'} = 'Editace vyhledávání';
    $Self->{Translation}->{'Restrict export per search'} = 'Omezit Export vyhledáváním';
    $Self->{Translation}->{'Import information'} = 'Informace o Importu';
    $Self->{Translation}->{'Source File'} = 'Zdrojový Soubor';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} = '';
    $Self->{Translation}->{'Import and export object information.'} = '';
    $Self->{Translation}->{'Import/Export'} = 'Import/Export';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
