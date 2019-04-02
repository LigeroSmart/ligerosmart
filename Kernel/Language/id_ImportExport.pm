# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::id_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Manajamen Impor/Ekspor';
    $Self->{Translation}->{'Add template'} = 'Tambahkan templat';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Buat sebuah template untuk mengimpor dan ekspor obyek informasi.';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        '';
    $Self->{Translation}->{'Start Import'} = 'Mulai Impor';
    $Self->{Translation}->{'Start Export'} = 'Mulai Ekspor';
    $Self->{Translation}->{'Delete this template'} = '';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = '';
    $Self->{Translation}->{'Name is required!'} = 'Nama dibutuhkan!';
    $Self->{Translation}->{'Object is required!'} = 'Obyek dibutuhkan!';
    $Self->{Translation}->{'Format is required!'} = 'Format dibutuhkan!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = '';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = '';
    $Self->{Translation}->{'is required!'} = 'dibutuhkan!';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = '';
    $Self->{Translation}->{'No map elements found.'} = 'Tidak ditemukan elemen peta.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Tambah Elemen Pemetaan';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = '';
    $Self->{Translation}->{'Restrict export per search'} = 'Batas ekspor per pencarian';
    $Self->{Translation}->{'Import information'} = 'Informasi impor ';
    $Self->{Translation}->{'Source File'} = 'Berkas Sumber';
    $Self->{Translation}->{'Import summary for %s'} = '';
    $Self->{Translation}->{'Records'} = 'Data';
    $Self->{Translation}->{'Success'} = 'Berhasil';
    $Self->{Translation}->{'Duplicate names'} = 'Nama duplikat';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Nomor baris terakhir berkas impor yang diproses';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Do you really want to delete this template item?'} = '';

    # Perl Module: Kernel/Modules/AdminImportExport.pm
    $Self->{Translation}->{'No object backend found!'} = '';
    $Self->{Translation}->{'No format backend found!'} = '';
    $Self->{Translation}->{'Template not found!'} = '';
    $Self->{Translation}->{'Can\'t insert/update template!'} = '';
    $Self->{Translation}->{'Needed TemplateID!'} = '';
    $Self->{Translation}->{'Error occurred. Import impossible! See Syslog for details.'} = '';
    $Self->{Translation}->{'Error occurred. Export impossible! See Syslog for details.'} = '';
    $Self->{Translation}->{'Template List'} = '';
    $Self->{Translation}->{'number'} = '';
    $Self->{Translation}->{'number bigger than zero'} = '';
    $Self->{Translation}->{'integer'} = '';
    $Self->{Translation}->{'integer bigger than zero'} = '';
    $Self->{Translation}->{'Element required, please insert data'} = '';
    $Self->{Translation}->{'Invalid data, please insert a valid %s'} = '';
    $Self->{Translation}->{'Format not found!'} = '';

    # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
    $Self->{Translation}->{'Column Separator'} = 'Pemisah Kolom';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tab (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Titikkoma (;)';
    $Self->{Translation}->{'Colon (:)'} = 'Titikdua (:)';
    $Self->{Translation}->{'Dot (.)'} = 'Titik (.)';
    $Self->{Translation}->{'Comma (,)'} = '';
    $Self->{Translation}->{'Charset'} = 'Karakter';
    $Self->{Translation}->{'Include Column Headers'} = 'Sertakan Kepala Kolom';
    $Self->{Translation}->{'Column'} = 'Kolom';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = '';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        '';
    $Self->{Translation}->{'Template was deleted successfully.'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Format modul pendaftaran backend untuk modul impor/ekspor.';
    $Self->{Translation}->{'Import and export object information.'} = 'Informasi obyek impor dan ekspor.';
    $Self->{Translation}->{'Import/Export'} = 'Impor/Ekspor';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Confirm',
    'Delete this template',
    'Deleting template...',
    'Template was deleted successfully.',
    'There was an error deleting the template. Please check the logs for more information.',
    );

}

1;
