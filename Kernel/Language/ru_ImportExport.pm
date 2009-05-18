# --
# Kernel/Language/ru_ImportExport.pm - the russian translation of ImportExport
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Egor Tsilenko <bg8s at symlink.ru>
# --
# $Id: ru_ImportExport.pm,v 1.2 2009-05-18 09:42:52 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'}              = 'Импорт/Экспорт';
    $Lang->{'Import/Export Management'}   = 'Управление Импортом/Экспортом';
    $Lang->{'Add mapping template'}       = 'Добавление шаблона соответствия';
    $Lang->{'Start Import'}               = 'Начать импорт';
    $Lang->{'Start Export'}               = 'Начать экспорт';
    $Lang->{'Step'}                       = 'Шаг';
    $Lang->{'Edit common information'}    = 'Редактировать общую информацию';
    $Lang->{'Edit object information'}    = 'Редактировать информацию об объекте';
    $Lang->{'Edit format information'}    = 'Редактировать формат данных';
    $Lang->{'Edit mapping information'}   = 'Редактировать информацию соответствия';
    $Lang->{'Edit search information'}    = 'Редактировать поисковую информацию';
    $Lang->{'Import information'}         = 'Информация импорта';
    $Lang->{'Column'}                     = 'Столбец';
    $Lang->{'Restrict export per search'} = 'Ограничить экспорт поиском';
    $Lang->{'Source File'}                = 'Исходный файл';
    $Lang->{'Column Seperator'}           = 'Разделитель';
    $Lang->{'Tabulator (TAB)'}            = 'Табуляция (TAB)';
    $Lang->{'Semicolon (;)'}              = 'Точка с запятой (;)';
    $Lang->{'Colon (:)'}                  = 'Двоеточие (:)';
    $Lang->{'Dot (.)'}                    = 'Точка (.)';
    $Lang->{'Charset'}                    = 'Кодировка';

    return 1;
}

1;
