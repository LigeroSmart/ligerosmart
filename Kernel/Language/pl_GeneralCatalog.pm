# --
# Kernel/Language/pl_GeneralCatalog.pm - the polski translation of GeneralCatalog
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: pl_GeneralCatalog.pm,v 1.1 2008-08-11 11:27:05 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::pl_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'Katalog g³ówny';
    $Lang->{'General Catalog Management'} = 'Zarz±dzanie katalogiem g³ównym';
    $Lang->{'Catalog Class'}              = '';
    $Lang->{'Add a new Catalog Class.'}   = '';
    $Lang->{'Add Catalog Item'}           = 'Dodaj element katalogu';
    $Lang->{'Add Catalog Class'}          = '';
    $Lang->{'Functionality'}              = 'Funkcjonalno¶æ';

    return 1;
}

1;
