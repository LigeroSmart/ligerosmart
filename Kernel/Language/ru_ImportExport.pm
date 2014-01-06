# --
# Kernel/Language/ru_ImportExport.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# Copyright (C) 2013 Yuriy Kolesnikov <ynkolesnikov at gmail.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_ImportExport;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = 'Добавление шаблона соответствия';
    $Self->{Translation}->{'Charset'} = 'Кодировка';
    $Self->{Translation}->{'Colon (:)'} = 'Двоеточие (:)';
    $Self->{Translation}->{'Column'} = 'Столбец';
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
    $Self->{Translation}->{'Delete Template'} = 'Удалить шаблон';
    $Self->{Translation}->{'Step'} = 'Шаг';
    $Self->{Translation}->{'Edit common information'} = 'Редактировать общую информацию';
    $Self->{Translation}->{'Object is required!'} = 'Объект обязателен!';
    $Self->{Translation}->{'Format is required!'} = 'Формат обязателен!';
    $Self->{Translation}->{'Edit object information'} = 'Редактировать информацию об объекте';
    $Self->{Translation}->{'Edit format information'} = 'Редактировать формат данных';
    $Self->{Translation}->{' is required!'} = 'обязателен!';
    $Self->{Translation}->{'Edit mapping information'} = 'Редактировать информацию соответствия';
    $Self->{Translation}->{'No map elements found.'} = 'Нет элементов сопоставления';
    $Self->{Translation}->{'Add Mapping Element'} = 'Добавьте элемент сопоставления';
    $Self->{Translation}->{'Edit search information'} = 'Редактировать поисковую информацию';
    $Self->{Translation}->{'Restrict export per search'} = 'Ограничить экспорт поиском';
    $Self->{Translation}->{'Import information'} = 'Информация импорта';
    $Self->{Translation}->{'Source File'} = 'Исходный файл';
    $Self->{Translation}->{'Success'} = 'Успешно';
    $Self->{Translation}->{'Failed'} = 'Не удалось выполнить';
    $Self->{Translation}->{'Duplicate names'} = 'Дублирующие имена';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Номер последней обработанной строки импортируемого файла';
    $Self->{Translation}->{'Ok'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        '';
    $Self->{Translation}->{'Import and export object information.'} = 'Импорт и экспорт информации об объектах';
    $Self->{Translation}->{'Import/Export'} = 'Импорт/Экспорт';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
