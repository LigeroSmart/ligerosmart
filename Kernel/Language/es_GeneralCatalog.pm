# --
# Kernel/Language/es_GeneralCatalog.pm - the spanish translation of GeneralCatalog
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: es_GeneralCatalog.pm,v 1.2 2008-08-13 14:19:21 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::es_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'Catalogo General';
    $Lang->{'General Catalog Management'} = 'Administración de Catalogo General';
    $Lang->{'Catalog Class'}              = 'Clase de Catalogo';
    $Lang->{'Add a new Catalog Class.'}   = 'Añadir una nueva Clase al Catalogo';
    $Lang->{'Add Catalog Item'}           = 'Añadir Elemento de Catalogo';
    $Lang->{'Add Catalog Class'}          = 'Añadir Clase de Catalogo';
    $Lang->{'Functionality'}              = 'Funcionalidad';

    return 1;
}

1;
