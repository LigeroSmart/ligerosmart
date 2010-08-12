# --
# Kernel/Language/ru_GeneralCatalog.pm - the russian translation of GeneralCatalog
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Egor Tsilenko <bg8s at symlink.ru>
# --
# $Id: ru_GeneralCatalog.pm,v 1.4 2010-08-12 22:50:38 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'Общий каталог';
    $Lang->{'General Catalog Management'} = 'Управление общим каталогом';
    $Lang->{'Catalog Class'}              = 'Класс каталога';
    $Lang->{'Add a new Catalog Class.'}   = 'Добавить новый класс каталога';
    $Lang->{'Add Catalog Item'}           = 'Добавление элемента каталога';
    $Lang->{'Add Catalog Class'}          = 'Добавление класса каталога';
    $Lang->{'Functionality'}              = 'Функциональность';
    $Lang->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = '';
    $Lang->{'Parameters for the example comment 2 of general catalog attributes.'} = '';
    $Lang->{'Parameters for the example permission groups of general catalog attributes.'} = '';

    return 1;
}

1;
