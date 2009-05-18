# --
# Kernel/Language/ct_GeneralCatalog.pm - the catalan translation of GeneralCatalog
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Sistemes OTIC (ibsalut) - Antonio Linde
# --
# $Id: ct_GeneralCatalog.pm,v 1.3 2009-05-18 09:40:46 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ct_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

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
