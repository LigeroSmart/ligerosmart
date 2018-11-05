# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::de_GeneralCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Funktionalität';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Allgemeine Katalogverwaltung';
    $Self->{Translation}->{'Items in Class'} = '';
    $Self->{Translation}->{'Edit Item'} = 'Ändere das Item';
    $Self->{Translation}->{'Add Class'} = '';
    $Self->{Translation}->{'Add Item'} = 'Füge Item hinzu';
    $Self->{Translation}->{'Add Catalog Item'} = 'Katalogartikel hinzufügen';
    $Self->{Translation}->{'Add Catalog Class'} = 'Katalogklasse hinzufügen';
    $Self->{Translation}->{'Catalog Class'} = 'Katalogklasse';
    $Self->{Translation}->{'Edit Catalog Item'} = 'Katalogartikel bearbeiten';

    # SysConfig
    $Self->{Translation}->{'Comment 2'} = '';
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Allgemeinen Katalog erstellen und verwalten.';
    $Self->{Translation}->{'Define the general catalog comment 2.'} = '';
    $Self->{Translation}->{'Define the group with permissions.'} = '';
    $Self->{Translation}->{'Defines the URL JS Color Picker path.'} = '';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        'Frontendmodul-Registration der AdminGeneralCatalog Konfiguration im Admin-Bereich.';
    $Self->{Translation}->{'General Catalog'} = 'Allgemeiner Katalog';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        'Parameter für den Beispiel-Kommentar 2 der General-Katalog-Attribute.';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        'Parameter für die zugriffsberechtigte Gruppe der General-Katalog-Attribute.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
