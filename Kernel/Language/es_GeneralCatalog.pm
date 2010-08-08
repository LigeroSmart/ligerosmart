# --
# Kernel/Language/es_GeneralCatalog.pm - the spanish translation of GeneralCatalog
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Aquiles Cohen
# --
# $Id: es_GeneralCatalog.pm,v 1.6 2010-08-08 21:01:54 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'Catalogo General';
    $Lang->{'General Catalog Management'} = 'Gestión del Catalogo General';
    $Lang->{'Catalog Class'}              = 'Clase de Catalogo';
    $Lang->{'Add a new Catalog Class.'}   = 'Añadir una nueva Clase al Catalogo';
    $Lang->{'Add Catalog Item'}           = 'Añadir Elemento al Catalogo';
    $Lang->{'Add Catalog Class'}          = 'Añadir Clase al Catalogo';
    $Lang->{'Functionality'}              = 'Funcionalidad';
    $Lang->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = '';

    return 1;
}

1;
