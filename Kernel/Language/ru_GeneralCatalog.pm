# --
# Kernel/Language/ru_GeneralCatalog.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# Copyright (C) 2013 Yuriy Kolesnikov <ynkolesnikov at gmail.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_GeneralCatalog;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Функциональность';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Управление Общим каталогом';
    $Self->{Translation}->{'Add Catalog Item'} = 'Добавление элемента каталога';
    $Self->{Translation}->{'Add Catalog Class'} = 'Добавление класса каталога';
    $Self->{Translation}->{'Catalog Class'} = 'Класс каталога';

    # SysConfig
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Создание и управление Общим каталогом';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        'Module registration для конфигурации AdminGeneralCatalog в панели администратора.';
    $Self->{Translation}->{'General Catalog'} = 'Общий каталог';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        'Добавление дополнительного комментария к атрибутам Общего каталога';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
