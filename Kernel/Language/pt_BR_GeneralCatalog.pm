# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_GeneralCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Funcionalidade';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Gerenciamento do Catálogo Geral';
    $Self->{Translation}->{'Add Catalog Item'} = 'Adicionar Item ao Catálogo';
    $Self->{Translation}->{'Add Catalog Class'} = 'Adicionar Classe ao Catálogo';
    $Self->{Translation}->{'Catalog Class'} = 'Classe do Catálogo';

}

1;
