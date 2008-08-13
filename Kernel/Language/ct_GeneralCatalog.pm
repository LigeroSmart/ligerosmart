# --
# Kernel/Language/ct_GeneralCatalog.pm - the catalan translation of GeneralCatalog
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ct_GeneralCatalog.pm,v 1.1 2008-08-13 13:49:30 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::ct_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'Catàleg general';
    $Lang->{'General Catalog Management'} = 'Gestió del catàleg general';
    $Lang->{'Catalog Class'}              = 'Classe de catáleg';
    $Lang->{'Add a new Catalog Class.'}   = 'Afegir una nova classe de catàleg';
    $Lang->{'Add Catalog Item'}           = 'Afegir article de catàleg';
    $Lang->{'Add Catalog Class'}          = 'Afegir classe de catàleg';
    $Lang->{'Functionality'}              = 'Funcionalitat';

    return 1;
}

1;
