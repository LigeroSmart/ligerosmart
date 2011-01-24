# --
# Kernel/Language/de_GeneralCatalog.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: de_GeneralCatalog.pm,v 1.17 2011-01-24 17:32:49 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_GeneralCatalog;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Funktionalität';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'General-Katalog-Verwaltung';
    $Self->{Translation}->{'Add Catalog Item'} = 'Katalog-Eintrag hinzufügen';
    $Self->{Translation}->{'Add Catalog Class'} = 'Katalog-Klasse hinzufügen';
    $Self->{Translation}->{'Catalog Class'} = 'Katalog-Klasse';
    $Self->{Translation}->{'A Catalog Class should have a description!'} = 'Eine General-Katalog-Klasse benötigt eine Beschereibung!';
    $Self->{Translation}->{'Catalog Class is required.'} = 'Katalog-Klasse ist erforderlich.';
    $Self->{Translation}->{'A Catalog Class should have a Name!'} = 'Eine Katalog-Klasse benötigt einen Namen!';
    $Self->{Translation}->{'Name is required.'} = 'Der Name ist erforderlich.';

    # SysConfig
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'General-Katalog erstellen und verwalten.';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = 'Frontendmodul-Registration der AdminGeneralCatalog Konfiguration im Admin-Bereich.';
    $Self->{Translation}->{'General Catalog'} = 'General-Katalog';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} = 'Parameter für den Beispiel-Kommentar 2 der General-Katalog-Attribute.';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} = 'Parameter für die zugriffsberechtigte Gruppe der General-Katalog-Attribute.';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
