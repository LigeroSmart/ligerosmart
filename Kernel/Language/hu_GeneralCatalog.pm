# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
    $Self->{Translation}->{'Items in Class'} = 'Elemek az osztályban';
    $Self->{Translation}->{'Edit Item'} = 'Elem szerkesztése';
    $Self->{Translation}->{'Add Class'} = 'Osztály hozzáadása';
    $Self->{Translation}->{'Add Item'} = 'Elem hozzáadása';
    $Self->{Translation}->{'Add Catalog Item'} = 'Katalóguselem hozzáadása';
    $Self->{Translation}->{'Add Catalog Class'} = 'Katalógusosztály hozzáadása';
    $Self->{Translation}->{'Catalog Class'} = 'Katalógusosztály';
    $Self->{Translation}->{'Edit Catalog Item'} = 'Katalóguselem szerkesztése';

    # JS File: ITSM.GeneralCatalog
    $Self->{Translation}->{'Warning incident state can not be set to invalid.'} = 'A figyelmeztetés incidensállapotot nem lehet érvénytelenre állítani.';

    # SysConfig
    $Self->{Translation}->{'Comment 2'} = '2. megjegyzés';
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Az általános katalógus létrehozása és kezelése.';
    $Self->{Translation}->{'Define the general catalog comment 2.'} = 'Meghatározza az általános katalógus 2. megjegyzését.';
    $Self->{Translation}->{'Defines the URL JS Color Picker path.'} = 'Meghatározza a JS színválasztó útvonalának URL-ét.';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        'Előtétprogram modul regisztráció az adminisztrációs területen lévő általános katalógus beállításhoz.';
    $Self->{Translation}->{'General Catalog'} = 'Általános katalógus';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        'Paraméterek az általános katalógus attribútumainak 2. példa megjegyzéseihez.';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        'Paraméterek az általános katalógus attribútumainak példa jogosultság csoportjaihoz.';
    $Self->{Translation}->{'Permission Group'} = 'Jogosultsági csoport';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Warning',
    'Warning incident state can not be set to invalid.',
    );

}

1;
