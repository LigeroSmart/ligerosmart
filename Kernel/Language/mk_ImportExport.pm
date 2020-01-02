# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::mk_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Внеси/Изнеси Менаџмент';
    $Self->{Translation}->{'Add template'} = 'Додади шаблон';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Креирај шаблон за внесени и изнесени објект информации';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        '';
    $Self->{Translation}->{'Start Import'} = 'Започни внесување';
    $Self->{Translation}->{'Start Export'} = 'Започни излез';
    $Self->{Translation}->{'Delete this template'} = '';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = '';
    $Self->{Translation}->{'Name is required!'} = 'Потребно е име!';
    $Self->{Translation}->{'Object is required!'} = 'Потребен е објект!';
    $Self->{Translation}->{'Format is required!'} = 'Потребен е формат!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = '';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = '';
    $Self->{Translation}->{'is required!'} = 'Задолжително е!';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = '';
    $Self->{Translation}->{'No map elements found.'} = 'Нема мапирани елементи.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Додади Мапирани Елементи';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = '';
    $Self->{Translation}->{'Restrict export per search'} = 'Ограничи излезни барања';
    $Self->{Translation}->{'Import information'} = 'Влезни Информации';
    $Self->{Translation}->{'Source File'} = 'Изворен податок';
    $Self->{Translation}->{'Import summary for %s'} = '';
    $Self->{Translation}->{'Records'} = 'Снимки';
    $Self->{Translation}->{'Success'} = 'Успешно';
    $Self->{Translation}->{'Duplicate names'} = 'Дупликат име ';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Последно обработени број на линии на внесени податоци';
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
    $Self->{Translation}->{'Column Separator'} = 'Разделувач на колони';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Таб (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Точка-запирка (;)';
    $Self->{Translation}->{'Colon (:)'} = 'Две Точки (:)';
    $Self->{Translation}->{'Dot (.)'} = 'Точка (.)';
    $Self->{Translation}->{'Comma (,)'} = '';
    $Self->{Translation}->{'Charset'} = 'Множество знаци';
    $Self->{Translation}->{'Include Column Headers'} = 'Вклучи заглавие на колона';
    $Self->{Translation}->{'Column'} = 'Колона';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = '';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        '';
    $Self->{Translation}->{'Template was deleted successfully.'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Формат позадински модул за регистрација за внеси / изнеси модул.';
    $Self->{Translation}->{'Import and export object information.'} = 'Внеси и изнеси објект информации';
    $Self->{Translation}->{'Import/Export'} = 'Внеси/Изнеси';


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
