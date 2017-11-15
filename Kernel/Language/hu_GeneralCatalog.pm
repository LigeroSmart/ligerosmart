# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::hu_GeneralCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Funkcionalitás';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Általános katalógus kezelés';
    $Self->{Translation}->{'Add Catalog Item'} = 'Katalóguselem hozzáadása';
    $Self->{Translation}->{'Add Catalog Class'} = 'Katalógusosztály hozzáadása';
    $Self->{Translation}->{'Catalog Class'} = 'Katalógusosztály';
    $Self->{Translation}->{'Edit Catalog Item'} = 'Katalóguselem szerkesztése';

    # SysConfig
    $Self->{Translation}->{'Comment 2'} = '';
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Az általános katalógus létrehozása és kezelése.';
    $Self->{Translation}->{'Define the general catalog comment 2.'} = '';
    $Self->{Translation}->{'Define the group with permissions.'} = 'A jogosultságokkal rendelkező csoport meghatározása.';
    $Self->{Translation}->{'Defines the URL JS Color Picker path.'} = 'Meghatározza a JS színválasztó útvonalának URL-ét.';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        'Előtétprogram modul regisztráció az adminisztrációs területen lévő AdminGeneralCatalog beállításhoz.';
    $Self->{Translation}->{'General Catalog'} = 'Általános katalógus';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        'Paraméterek az általános katalógus attribútumainak 2. példa megjegyzéseihez.';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        'Paraméterek az általános katalógus attribútumainak példa jogosultság csoportjaihoz.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
