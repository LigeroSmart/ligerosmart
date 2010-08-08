# --
# Kernel/Language/it_GeneralCatalog.pm - the italian translation of GeneralCatalog
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: it_GeneralCatalog.pm,v 1.2 2010-08-08 21:01:54 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::it_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'Catalogo Generale';
    $Lang->{'General Catalog Management'} = 'Gestione del Catalogo Generale';
    $Lang->{'Catalog Class'}              = 'Classe di Catalogo';
    $Lang->{'Add a new Catalog Class.'}   = 'Aggiungi una nuova Classe al Catalogo';
    $Lang->{'Add Catalog Item'}           = 'Aggiungi Elemento al Catalogo';
    $Lang->{'Add Catalog Class'}          = 'Aggiungi Classe al Catalogo';
    $Lang->{'Functionality'}              = 'Funzionalità';
    $Lang->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = '';

    return 1;
}

1;
