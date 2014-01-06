# --
# Kernel/Language/ms_ImportExport.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ms_ImportExport;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = 'Tambah templat peta';
    $Self->{Translation}->{'Charset'} = 'Set karakter';
    $Self->{Translation}->{'Colon (:)'} = 'Titik bertindih (:)';
    $Self->{Translation}->{'Column'} = 'Kolum';
    $Self->{Translation}->{'Column Separator'} = 'Kolum pemisah';
    $Self->{Translation}->{'Dot (.)'} = 'Titik (.)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Semikolon (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulator (TAB)';
    $Self->{Translation}->{'Include Column Headers'} = 'Termasuk Kolum Kepala';
    $Self->{Translation}->{'Import summary for'} = '';
    $Self->{Translation}->{'Imported records'} = '';
    $Self->{Translation}->{'Exported records'} = '';
    $Self->{Translation}->{'Records'} = '';
    $Self->{Translation}->{'Skipped'} = '';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Pengurusan Import/Eksport';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Cipta templat untuk import dan eksport informasi objek.';
    $Self->{Translation}->{'Start Import'} = 'Mula import';
    $Self->{Translation}->{'Start Export'} = 'Mula eksport';
    $Self->{Translation}->{'Delete Template'} = 'Padam templat';
    $Self->{Translation}->{'Step'} = 'Langkah';
    $Self->{Translation}->{'Edit common information'} = 'Audit informasi biasa';
    $Self->{Translation}->{'Name is required!'} = '';
    $Self->{Translation}->{'Object is required!'} = 'Objek adalah diperlukan!';
    $Self->{Translation}->{'Format is required!'} = 'Format adalah diperlukan!';
    $Self->{Translation}->{'Edit object information'} = 'Audit informasi objek';
    $Self->{Translation}->{'Edit format information'} = 'Audit informasi format';
    $Self->{Translation}->{' is required!'} = ' adalah diperlukan!';
    $Self->{Translation}->{'Edit mapping information'} = 'Audit informasi peta';
    $Self->{Translation}->{'No map elements found.'} = 'Tiada elemen peta ditemui.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Tambah elemen peta';
    $Self->{Translation}->{'Edit search information'} = 'Audit informasi carian';
    $Self->{Translation}->{'Restrict export per search'} = 'Dilarang eksport per carian';
    $Self->{Translation}->{'Import information'} = 'Informasi import';
    $Self->{Translation}->{'Source File'} = 'Sumber fail';
    $Self->{Translation}->{'Success'} = '';
    $Self->{Translation}->{'Failed'} = '';
    $Self->{Translation}->{'Duplicate names'} = '';
    $Self->{Translation}->{'Last processed line number of import file'} = '';
    $Self->{Translation}->{'Ok'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Format backend modul pendaftaran untuk modul import/eksport.';
    $Self->{Translation}->{'Import and export object information.'} = 'Informasi objek import dan eksport.';
    $Self->{Translation}->{'Import/Export'} = 'Import/Eksport';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
