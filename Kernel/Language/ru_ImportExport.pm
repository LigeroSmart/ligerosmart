# --
# Kernel/Language/ru_ImportExport.pm - the russian translation of ImportExport
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Egor Tsilenko <bg8s at symlink.ru>
# --
# $Id: ru_ImportExport.pm,v 1.5 2010-09-14 21:25:45 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

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
    $Lang->{'Column Separator'}           = 'Разделитель';
    $Lang->{'Tabulator (TAB)'}            = 'Табуляция (TAB)';
    $Lang->{'Semicolon (;)'}              = 'Точка с запятой (;)';
    $Lang->{'Colon (:)'}                  = 'Двоеточие (:)';
    $Lang->{'Dot (.)'}                    = 'Точка (.)';
    $Lang->{'Charset'}                    = 'Кодировка';
    $Lang->{'Frontend module registration for the agent interface.'} = '';
    $Lang->{'Format backend module registration for the import/export module.'} = '';
    $Lang->{'Import and export object information.'} = '';
    $Lang->{'Object is required!'} = '';
    $Lang->{'Format is required!'} = '';
    $Lang->{'Class is required!'} = '';
    $Lang->{'Column Separator is required!'} = '';
    $Lang->{'No map elements found.'} = '';

    return 1;
}

1;
