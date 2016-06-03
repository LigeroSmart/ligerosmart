# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = 'Добавить шаблон сопоставления';
    $Self->{Translation}->{'Charset'} = 'Кодировка';
    $Self->{Translation}->{'Colon (:)'} = 'Двоеточие (:)';
    $Self->{Translation}->{'Column'} = 'Столбец ';
    $Self->{Translation}->{'Column Separator'} = 'Разделитель';
    $Self->{Translation}->{'Dot (.)'} = 'Точка (.)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Точка с запятой (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Табуляция (TAB)';
    $Self->{Translation}->{'Include Column Headers'} = 'Включить заголовки столбцов';
    $Self->{Translation}->{'Import summary for'} = 'Отчет об импорте';
    $Self->{Translation}->{'Imported records'} = 'Импортировано записей';
    $Self->{Translation}->{'Exported records'} = 'Экспортировано записей';
    $Self->{Translation}->{'Records'} = 'Записей';
    $Self->{Translation}->{'Skipped'} = 'Пропущено';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Управление Импортом/Экспортом';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Создайте шаблон для импорта и экспорта информации объектов';
    $Self->{Translation}->{'Start Import'} = 'Начать импорт';
    $Self->{Translation}->{'Start Export'} = 'Начать экспорт';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = '';
    $Self->{Translation}->{'Name is required!'} = 'Требуется имя!';
    $Self->{Translation}->{'Object is required!'} = 'Объект обязателен!';
    $Self->{Translation}->{'Format is required!'} = 'Формат обязателен!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = '';
    $Self->{Translation}->{'Step 3 of 5'} = '';
    $Self->{Translation}->{'is required!'} = 'обязателен!';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = '';
    $Self->{Translation}->{'No map elements found.'} = 'Нет элементов сопоставления.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Добавьте элемент сопоставления';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = '';
    $Self->{Translation}->{'Restrict export per search'} = 'Ограничить экспорт поиском';
    $Self->{Translation}->{'Import information'} = 'Информация об импорте';
    $Self->{Translation}->{'Source File'} = 'Исходный файл';
    $Self->{Translation}->{'Success'} = 'Успешно';
    $Self->{Translation}->{'Failed'} = 'Не удалось выполнить';
    $Self->{Translation}->{'Duplicate names'} = 'Дублирующие имена';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Номер последней обработанной строки импортируемого файла';
    $Self->{Translation}->{'Ok'} = 'Ok';

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
        'Format backend module registration для модуля import/export.';
    $Self->{Translation}->{'Import and export object information.'} = 'Импорт и экспорт информации об объектах';
    $Self->{Translation}->{'Import/Export'} = 'Импорт/Экспорт';

}

1;
