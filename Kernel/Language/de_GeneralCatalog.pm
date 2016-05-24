# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
    $Self->{Translation}->{'General Catalog Management'} = 'General-Katalog-Verwaltung';
    $Self->{Translation}->{'Add Catalog Item'} = 'Katalog-Eintrag hinzufügen';
    $Self->{Translation}->{'Add Catalog Class'} = 'Katalog-Klasse hinzufügen';
    $Self->{Translation}->{'Catalog Class'} = 'Katalog-Klasse';

}

1;
