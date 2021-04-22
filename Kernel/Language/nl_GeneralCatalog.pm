# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::nl_GeneralCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Functionaliteit';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Algemene Catalogus beheer';
    $Self->{Translation}->{'Items in Class'} = 'Items in klasse';
    $Self->{Translation}->{'Edit Item'} = 'Item bewerken';
    $Self->{Translation}->{'Add Class'} = 'Klasse toevoegen';
    $Self->{Translation}->{'Add Item'} = 'Item toevoegen';
    $Self->{Translation}->{'Add Catalog Item'} = 'Catalogusitem toevoegen';
    $Self->{Translation}->{'Add Catalog Class'} = 'Catalogusklasse toevoegen';
    $Self->{Translation}->{'Catalog Class'} = 'Catalogusklasse';
    $Self->{Translation}->{'Edit Catalog Item'} = 'Catalogusitem bewerken';

    # JS File: ITSM.GeneralCatalog
    $Self->{Translation}->{'Warning incident state can not be set to invalid.'} = 'Waarschuwing incident status kan niet worden ingesteld op ongeldig.';

    # SysConfig
    $Self->{Translation}->{'Comment 2'} = 'Commentaar 2';
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Maak en beheer de Algemene Catalogus.';
    $Self->{Translation}->{'Define the general catalog comment 2.'} = 'Definieer de algemene cataloguscommentaar 2.';
    $Self->{Translation}->{'Defines the URL JS Color Picker path.'} = 'Definieert het URL JS-kleurkiezerpad.';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        'Frontend module registratie voor de AdminGeneralCatalog configuratie in het admin gebied.';
    $Self->{Translation}->{'General Catalog'} = 'Algemene Catalogus';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        'Parameters voor het voorbeeldcommentaar 2 van de algemene cataloguskenmerken.';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        'Parameters voor de voorbeeldmachtigingsgroepen van de algemene cataloguskenmerken.';
    $Self->{Translation}->{'Permission Group'} = 'Toestemmingsgroep';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Warning',
    'Warning incident state can not be set to invalid.',
    );

}

1;
