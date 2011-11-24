# --
# Kernel/Language/pl_ImportExport.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: pl_ImportExport.pm,v 1.11 2011-11-24 15:42:26 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_ImportExport;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = '';
    $Self->{Translation}->{'Charset'} = 'Kodowanie';
    $Self->{Translation}->{'Colon (:)'} = 'Dwukropek (:)';
    $Self->{Translation}->{'Column'} = 'Kolumna';
    $Self->{Translation}->{'Column Separator'} = 'Separator kolumny';
    $Self->{Translation}->{'Dot (.)'} = 'Kropka (.)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Orednik (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulator (TAB)';
    $Self->{Translation}->{'Include Column Headers'} = '';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Zarz1dzanie Importem/Exportem';
    $Self->{Translation}->{'Add template'} = '';
    $Self->{Translation}->{'Create a template to import and export object information.'} = '';
    $Self->{Translation}->{'Start Import'} = 'Rozpocznij Import';
    $Self->{Translation}->{'Start Export'} = 'Rozpocznij Export';
    $Self->{Translation}->{'Delete Template'} = '';
    $Self->{Translation}->{'Step'} = '';
    $Self->{Translation}->{'Edit common information'} = '';
    $Self->{Translation}->{'Object is required!'} = '';
    $Self->{Translation}->{'Format is required!'} = '';
    $Self->{Translation}->{'Edit object information'} = '';
    $Self->{Translation}->{'Edit format information'} = '';
    $Self->{Translation}->{' is required!'} = '';
    $Self->{Translation}->{'Edit mapping information'} = '';
    $Self->{Translation}->{'No map elements found.'} = '';
    $Self->{Translation}->{'Add Mapping Element'} = '';
    $Self->{Translation}->{'Edit search information'} = '';
    $Self->{Translation}->{'Restrict export per search'} = '';
    $Self->{Translation}->{'Import information'} = '';
    $Self->{Translation}->{'Source File'} = 'Plik Yród3owy';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} = '';
    $Self->{Translation}->{'Import and export object information.'} = '';
    $Self->{Translation}->{'Import/Export'} = 'Import/Export';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
