# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ro_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Management import/export';
    $Self->{Translation}->{'Add template'} = '';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Crează un șablon pentru import/export informații obiecte.';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        '';
    $Self->{Translation}->{'Start Import'} = 'Start Import';
    $Self->{Translation}->{'Start Export'} = 'Start Export';
    $Self->{Translation}->{'Delete this template'} = '';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = 'Pasul 1 din 5 - Editează informații generale';
    $Self->{Translation}->{'Name is required!'} = 'Este necesara introducerea numelui!';
    $Self->{Translation}->{'Object is required!'} = 'Obiectul este cerut!';
    $Self->{Translation}->{'Format is required!'} = 'Formatul este cerut!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = 'Pasul 2 din 5 - Editează informații despre obiect';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = 'Pasul 3 din 5 - Editeaza informații despre format';
    $Self->{Translation}->{'is required!'} = 'este obligatoriu!';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = 'Pasul 4 din 5 - Editează informații despre asocieri';
    $Self->{Translation}->{'No map elements found.'} = 'Nu au fost găsite elemente de asociere.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Adaugă element de asociere';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = 'Pasul 5 din 5 - Editează informații de căutare';
    $Self->{Translation}->{'Restrict export per search'} = 'Limitează exportul la rezultatele căutarii';
    $Self->{Translation}->{'Import information'} = 'Importă informațiile';
    $Self->{Translation}->{'Source File'} = 'Fișier sursă';
    $Self->{Translation}->{'Import summary for %s'} = 'Rezumat import pentru %s';
    $Self->{Translation}->{'Records'} = 'Înregistrări';
    $Self->{Translation}->{'Success'} = 'Succes';
    $Self->{Translation}->{'Duplicate names'} = 'Nume duplicate';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Numărul ultimei linii procesate din fișierul de import';
    $Self->{Translation}->{'Ok'} = '确定';
    $Self->{Translation}->{'Do you really want to delete this template item?'} = '';

    # Perl Module: Kernel/Modules/AdminImportExport.pm
    $Self->{Translation}->{'No object backend found!'} = '';
    $Self->{Translation}->{'No format backend found!'} = '';
    $Self->{Translation}->{'Template not found!'} = '';
    $Self->{Translation}->{'Can\'t insert/update template!'} = 'Nu se poate introduce/actualiza șablon!';
    $Self->{Translation}->{'Needed TemplateID!'} = 'Necesar ID Șablon!';
    $Self->{Translation}->{'Error occurred. Import impossible! See Syslog for details.'} = 'Eroare. Import imposibil! Vezi Syslog pentru detalii.';
    $Self->{Translation}->{'Error occurred. Export impossible! See Syslog for details.'} = 'Eroare. Export imposibil! Vezi Syslog pentru detalii.';
    $Self->{Translation}->{'Template List'} = 'Listă Șabloane';
    $Self->{Translation}->{'number'} = 'numar';
    $Self->{Translation}->{'number bigger than zero'} = 'numar mai mare ca zero';
    $Self->{Translation}->{'integer'} = 'întreg';
    $Self->{Translation}->{'integer bigger than zero'} = 'întreg mai mare ca zero';
    $Self->{Translation}->{'Element required, please insert data'} = 'Element necesar, te rog sa introduci datele';
    $Self->{Translation}->{'Invalid data, please insert a valid %s'} = 'Date invalide, introdu date valide %s';
    $Self->{Translation}->{'Format not found!'} = 'Formatul nu a fost gasit!';

    # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
    $Self->{Translation}->{'Column Separator'} = 'Separator de coloană';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulator (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Punct și virgulă (;)';
    $Self->{Translation}->{'Colon (:)'} = 'Două puncte (:)';
    $Self->{Translation}->{'Dot (.)'} = 'Punct (.)';
    $Self->{Translation}->{'Comma (,)'} = 'Virgulă (,)';
    $Self->{Translation}->{'Charset'} = 'Set de caractere';
    $Self->{Translation}->{'Include Column Headers'} = 'Include capul de tabel';
    $Self->{Translation}->{'Column'} = 'Coloană';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = '';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        '';
    $Self->{Translation}->{'Template was deleted successfully.'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        '为导入/导出模块的格式后端模块注册。';
    $Self->{Translation}->{'Import and export object information.'} = 'Informații de import/export ale obiectului.';
    $Self->{Translation}->{'Import/Export'} = 'Import/Export';


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
