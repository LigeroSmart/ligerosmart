# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::hu_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = 'Leképezési sablon hozzáadása';
    $Self->{Translation}->{'Charset'} = 'Karakterkészlet';
    $Self->{Translation}->{'Colon (:)'} = 'Kettőspont (:)';
    $Self->{Translation}->{'Column'} = 'Oszlop';
    $Self->{Translation}->{'Column Separator'} = 'Oszlopelválasztó';
    $Self->{Translation}->{'Dot (.)'} = 'Pont (.)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Pontosvessző (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulátor (TAB)';
    $Self->{Translation}->{'Include Column Headers'} = 'Oszlopfejlécek felvétele';
    $Self->{Translation}->{'Import summary for'} = 'Importálási összegzés ehhez';
    $Self->{Translation}->{'Imported records'} = 'Importált rekordok';
    $Self->{Translation}->{'Exported records'} = 'Exportált rekordok';
    $Self->{Translation}->{'Records'} = 'Rekordok';
    $Self->{Translation}->{'Skipped'} = 'Kihagyva';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Importálás/exportálás kezelés';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Sablon létrehozása objektuminformációk importálásához és exportálásához.';
    $Self->{Translation}->{'Start Import'} = 'Importálás indítása';
    $Self->{Translation}->{'Start Export'} = 'Exportálás indítása';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = '';
    $Self->{Translation}->{'Name is required!'} = 'A név kötelező!';
    $Self->{Translation}->{'Object is required!'} = 'Az objektum kötelező!';
    $Self->{Translation}->{'Format is required!'} = 'A formátum kötelező!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = '';
    $Self->{Translation}->{'Step 3 of 5'} = '';
    $Self->{Translation}->{'is required!'} = 'kötelező!';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = '';
    $Self->{Translation}->{'No map elements found.'} = 'Nem találhatók térképelemek.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Leképezési elemek hozzáadása';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = '';
    $Self->{Translation}->{'Restrict export per search'} = 'Exportálás korlátozása keresésenként';
    $Self->{Translation}->{'Import information'} = 'Importálási információk';
    $Self->{Translation}->{'Source File'} = 'Forrásfájl';
    $Self->{Translation}->{'Success'} = 'Sikeres';
    $Self->{Translation}->{'Failed'} = 'Sikertelen';
    $Self->{Translation}->{'Duplicate names'} = 'Nevek kettőzése';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Az importfájl utolsó feldolgozott sorszáma';
    $Self->{Translation}->{'Ok'} = 'OK';

    # Perl Module: Kernel/Modules/AdminImportExport.pm
    $Self->{Translation}->{'No object backend found!'} = '';
    $Self->{Translation}->{'No format backend found!'} = '';
    $Self->{Translation}->{'Template not found!'} = '';
    $Self->{Translation}->{'Can\'t insert/update template!'} = '';
    $Self->{Translation}->{'Needed TemplateID!'} = '';
    $Self->{Translation}->{'Error occurred. Import impossible! See Syslog for details.'} = '';
    $Self->{Translation}->{'Error occurred. Export impossible! See Syslog for details.'} = '';
    $Self->{Translation}->{'number'} = '';
    $Self->{Translation}->{'number bigger than zero'} = '';
    $Self->{Translation}->{'integer'} = '';
    $Self->{Translation}->{'integer bigger than zero'} = '';
    $Self->{Translation}->{'Element required, please insert data'} = '';
    $Self->{Translation}->{'Invalid data, please insert a valid %s'} = '';
    $Self->{Translation}->{'Format not found!'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Formátum háttérprogram modul regisztráció az importálás/exportálás modulhoz.';
    $Self->{Translation}->{'Import and export object information.'} = 'Objektuminformációk importálása és exportálása.';
    $Self->{Translation}->{'Import/Export'} = 'Importálás/exportálás';

}

1;
