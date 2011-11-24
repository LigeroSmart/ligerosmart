# --
# Kernel/Language/da_ImportExport.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: da_ImportExport.pm,v 1.7 2011-11-24 15:42:26 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::da_ImportExport;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = 'Tilføj Mapping-Template';
    $Self->{Translation}->{'Charset'} = 'Tegnsæt';
    $Self->{Translation}->{'Colon (:)'} = 'Kolon (:)';
    $Self->{Translation}->{'Column'} = 'Kolonne';
    $Self->{Translation}->{'Column Separator'} = '';
    $Self->{Translation}->{'Dot (.)'} = 'Punktum (.)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Semikolon (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulator (TAB)';
    $Self->{Translation}->{'Include Column Headers'} = '';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Import/Ekport styring';
    $Self->{Translation}->{'Add template'} = '';
    $Self->{Translation}->{'Note'} = '';
    $Self->{Translation}->{'Create a template to import and export object information.'} = '';
    $Self->{Translation}->{'Start Import'} = 'Start import';
    $Self->{Translation}->{'Start Export'} = 'Start ekport';
    $Self->{Translation}->{'Delete Template'} = '';
    $Self->{Translation}->{'Step'} = 'Trin';
    $Self->{Translation}->{'Edit common information'} = 'Ret fælles information';
    $Self->{Translation}->{'Name is required!'} = '';
    $Self->{Translation}->{'Object is required!'} = '';
    $Self->{Translation}->{'Format is required!'} = '';
    $Self->{Translation}->{'Edit object information'} = 'Ret objekt information';
    $Self->{Translation}->{'Edit format information'} = 'Ret format information';
    $Self->{Translation}->{' is required!'} = '';
    $Self->{Translation}->{'Edit mapping information'} = 'Ret mapping information';
    $Self->{Translation}->{'No map elements found.'} = '';
    $Self->{Translation}->{'Add Mapping Element'} = '';
    $Self->{Translation}->{'Edit search information'} = 'Ret søgeinformation';
    $Self->{Translation}->{'Restrict export per search'} = 'Begræns ekport pr. søgning';
    $Self->{Translation}->{'Import information'} = 'Import information';
    $Self->{Translation}->{'Source File'} = 'Kilde fil';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} = '';
    $Self->{Translation}->{'Import and export object information.'} = '';
    $Self->{Translation}->{'Import/Export'} = 'Import/Ekport';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Column Seperator'} = 'Kolonne adskillelse';

}

1;
