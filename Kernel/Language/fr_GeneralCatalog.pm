# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr_GeneralCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Fonctionnalité';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Gestion du Catalogue Général';
    $Self->{Translation}->{'Add Catalog Item'} = 'Ajouter un Element au Catalogue';
    $Self->{Translation}->{'Add Catalog Class'} = 'Ajouter une Classe de Catalogue';
    $Self->{Translation}->{'Catalog Class'} = 'Classe de Catalogue';

}

1;
