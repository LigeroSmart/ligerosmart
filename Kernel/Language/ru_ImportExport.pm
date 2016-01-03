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
    $Self->{Translation}->{'Step'} = 'Шаг';
    $Self->{Translation}->{'Edit common information'} = 'Редактировать общую информацию';
    $Self->{Translation}->{'Name is required!'} = 'Требуется имя!';
    $Self->{Translation}->{'Object is required!'} = 'Объект обязателен!';
    $Self->{Translation}->{'Format is required!'} = 'Формат обязателен!';
    $Self->{Translation}->{'Edit object information'} = 'Редактировать информацию об объекте';
    $Self->{Translation}->{'Edit format information'} = 'Редактировать формат данных';
    $Self->{Translation}->{'is required!'} = 'обязателен!';
    $Self->{Translation}->{'Edit mapping information'} = 'Редактировать информацию соответствия';
    $Self->{Translation}->{'No map elements found.'} = 'Нет элементов сопоставления.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Добавьте элемент сопоставления';
    $Self->{Translation}->{'Edit search information'} = 'Редактировать поисковую информацию';
    $Self->{Translation}->{'Restrict export per search'} = 'Ограничить экспорт поиском';
    $Self->{Translation}->{'Import information'} = 'Информация об импорте';
    $Self->{Translation}->{'Source File'} = 'Исходный файл';
    $Self->{Translation}->{'Success'} = 'Успешно';
    $Self->{Translation}->{'Failed'} = 'Не удалось выполнить';
    $Self->{Translation}->{'Duplicate names'} = 'Дублирующие имена';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Номер последней обработанной строки импортируемого файла';
    $Self->{Translation}->{'Ok'} = 'Ok';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Format backend module registration для модуля import/export.';
    $Self->{Translation}->{'Import and export object information.'} = 'Импорт и экспорт информации об объектах';
    $Self->{Translation}->{'Import/Export'} = 'Импорт/Экспорт';

}

1;
