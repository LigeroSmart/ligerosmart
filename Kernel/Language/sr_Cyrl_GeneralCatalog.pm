# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::sr_Cyrl_GeneralCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Функционалност';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Управљање Општим каталогом';
    $Self->{Translation}->{'Items in Class'} = '';
    $Self->{Translation}->{'Edit Item'} = '';
    $Self->{Translation}->{'Add Class'} = '';
    $Self->{Translation}->{'Add Item'} = '';
    $Self->{Translation}->{'Add Catalog Item'} = 'Додавање ставке у каталог';
    $Self->{Translation}->{'Add Catalog Class'} = 'Додавање класе у каталог';
    $Self->{Translation}->{'Catalog Class'} = 'Каталог класа';
    $Self->{Translation}->{'Edit Catalog Item'} = 'Уреди ставку каталога';

    # SysConfig
    $Self->{Translation}->{'Comment 2'} = '';
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Креирање и управљање Општим каталогом.';
    $Self->{Translation}->{'Define the general catalog comment 2.'} = '';
    $Self->{Translation}->{'Define the group with permissions.'} = 'Дефинише групе са дозволама.';
    $Self->{Translation}->{'Defines the URL JS Color Picker path.'} = 'Дефинише URL путању за JS Color Picker.';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        'Регистрација "Frontend" модула за конфигурацију Администрације општег каталога у простору администратора.';
    $Self->{Translation}->{'General Catalog'} = 'Општи каталог';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        'Параметри за пример коментара 2 атрибута општег каталога.';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        'Параметри за пример групе за дозволе атрибута општег каталога.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
