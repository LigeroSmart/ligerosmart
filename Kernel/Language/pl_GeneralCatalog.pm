# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_GeneralCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Funkcjonalność';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Zarządzanie katalogiem głównym';
    $Self->{Translation}->{'Add Catalog Item'} = 'Dodaj element katalogu';
    $Self->{Translation}->{'Add Catalog Class'} = 'Dodaj klasę katalogu';
    $Self->{Translation}->{'Catalog Class'} = 'Klasa katalogu';
    $Self->{Translation}->{'Edit Catalog Item'} = '';

    # SysConfig
    $Self->{Translation}->{'Comment 2'} = '';
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Utwórz i zarządzaj katalogiem głównym.';
    $Self->{Translation}->{'Define the general catalog comment 2.'} = '';
    $Self->{Translation}->{'Define the group with permissions.'} = '';
    $Self->{Translation}->{'Defines the URL JS Color Picker path.'} = '';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        'Rejestracja modułu frontend do konfiguracji modułu AdminGeneralCatalog w panelu administratora.';
    $Self->{Translation}->{'General Catalog'} = 'Katalog główny';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        'Parametry do przykładowego komentarza 2 atrybutów katalogu generalnego.';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        'Parametry dla przykładowych grup uprawnień atrybutów katalogu głównego.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
