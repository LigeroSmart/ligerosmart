# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
    $Self->{Translation}->{'Items in Class'} = 'Ставке у класи';
    $Self->{Translation}->{'Edit Item'} = 'Уреди ставку';
    $Self->{Translation}->{'Add Class'} = 'Додај класу';
    $Self->{Translation}->{'Add Item'} = 'Додај ставку';
    $Self->{Translation}->{'Add Catalog Item'} = 'Додавање ставке у каталог';
    $Self->{Translation}->{'Add Catalog Class'} = 'Додавање класе у каталог';
    $Self->{Translation}->{'Catalog Class'} = 'Каталог класа';
    $Self->{Translation}->{'Edit Catalog Item'} = 'Уреди ставку каталога';

    # JS File: ITSM.GeneralCatalog
    $Self->{Translation}->{'Warning incident state can not be set to invalid.'} = '';

    # SysConfig
    $Self->{Translation}->{'Comment 2'} = 'Коментар 2';
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Креирање и управљање општим каталогом.';
    $Self->{Translation}->{'Define the general catalog comment 2.'} = 'Дефинише коментар 2 у општем каталогу.';
    $Self->{Translation}->{'Defines the URL JS Color Picker path.'} = 'Дефинише URL путању за JS Color Picker.';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        'Регистрација приступног модула за AdminGeneralCatalog у интерфејсу администратора.';
    $Self->{Translation}->{'General Catalog'} = 'Општи каталог';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        'Параметри за пример коментара 2 атрибута општег каталога.';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        'Параметри за пример групе за дозволе атрибута општег каталога.';
    $Self->{Translation}->{'Permission Group'} = 'Група приступа';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Warning',
    'Warning incident state can not be set to invalid.',
    );

}

1;
