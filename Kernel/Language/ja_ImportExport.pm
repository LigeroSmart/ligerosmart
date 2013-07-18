# --
# Kernel/Language/ja_ImportExport.pm - translation file
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ja_ImportExport;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = '';
    $Self->{Translation}->{'Colon (:)'} = '';
    $Self->{Translation}->{'Column'} = '';
    $Self->{Translation}->{'Dot (.)'} = '';
    $Self->{Translation}->{'Semicolon (;)'} = '';
    $Self->{Translation}->{'Tabulator (TAB)'} = '';
    $Self->{Translation}->{'Import summary for'} = '';
    $Self->{Translation}->{'Imported records'} = '';
    $Self->{Translation}->{'Exported records'} = '';
    $Self->{Translation}->{'Records'} = '';
    $Self->{Translation}->{'Skipped'} = '';

    # Template: AdminImportExport
    $Self->{Translation}->{'Delete Template'} = '';
    $Self->{Translation}->{'Object is required!'} = '';
    $Self->{Translation}->{'Format is required!'} = '';
    $Self->{Translation}->{' is required!'} = '';
    $Self->{Translation}->{'No map elements found.'} = '';
    $Self->{Translation}->{'Success'} = '';
    $Self->{Translation}->{'Failed'} = '';
    $Self->{Translation}->{'Duplicate names'} = '';
    $Self->{Translation}->{'Last processed line number of import file'} = '';
    $Self->{Translation}->{'Ok'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
