# --
# Kernel/Language/pl_GeneralCatalog.pm - the polish translation of GeneralCatalog
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Maciej Loszajc
# --
# $Id: pl_GeneralCatalog.pm,v 1.5 2010-08-08 21:01:54 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

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
    $Lang->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = '';

    return 1;
}

1;
