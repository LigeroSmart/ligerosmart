# --
# Kernel/Language/nb_NO_GeneralCatalog.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# Copyright (C) 2011 Eirik Wulff <eirik at epledoktor.no>
# --
# $Id: nb_NO_GeneralCatalog.pm,v 1.1 2011-04-20 10:47:41 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nb_NO_GeneralCatalog;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Funksjonalitet';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Administrasjon av Generell Katalog';
    $Self->{Translation}->{'Add Catalog Item'} = 'Legg til katalogobjekt';
    $Self->{Translation}->{'Add Catalog Class'} = 'Legg til katalog-klasse';
    $Self->{Translation}->{'Catalog Class'} = 'Katalog-klasse';
    $Self->{Translation}->{'A Catalog Class should have a description!'} = 'En katalog-klasse må ha en beskrivelse!';
    $Self->{Translation}->{'Catalog Class is required.'} = 'Katalogklasse er påkrevd.';
    $Self->{Translation}->{'A Catalog Class should have a Name!'} = 'En katalogklasse må ha et navn';
    $Self->{Translation}->{'Name is required.'} = 'Navn er påkrevd.';

    # SysConfig
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Opprett og administrér den generelle katalogen';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = 'Forsidemodul-registrering for AdminGeneralCatalog-oppsett i admin-delen.';
    $Self->{Translation}->{'General Catalog'} = 'Generell Katalog';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} = 'Parametre for eksempelkommentar 2 i attributtene for generell katalog';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} = 'Parametere for tilgangsgruppe-eksempel i attributtene for generell katalog.';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
