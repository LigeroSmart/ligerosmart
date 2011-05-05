# --
# Kernel/Language/bg_ImportExport.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: bg_ImportExport.pm,v 1.16 2011-05-05 09:36:13 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::bg_ImportExport;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = '';
    $Self->{Translation}->{'Charset'} = '';
    $Self->{Translation}->{'Colon (:)'} = '';
    $Self->{Translation}->{'Column'} = '';
    $Self->{Translation}->{'Column Separator'} = '';
    $Self->{Translation}->{'Dot (.)'} = '';
    $Self->{Translation}->{'Semicolon (;)'} = '';
    $Self->{Translation}->{'Tabulator (TAB)'} = '';
    $Self->{Translation}->{'Include Column Headers'} = '';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = '';
    $Self->{Translation}->{'Add template'} = '';
    $Self->{Translation}->{'Create a template to import and export object information.'} = '';
    $Self->{Translation}->{'Start Import'} = '';
    $Self->{Translation}->{'Start Export'} = '';
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
    $Self->{Translation}->{'Source File'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} = '';
    $Self->{Translation}->{'Import and export object information.'} = '';
    $Self->{Translation}->{'Import/Export'} = '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
