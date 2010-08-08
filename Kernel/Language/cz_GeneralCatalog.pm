# --
# Kernel/Language/cz_GeneralCatalog.pm - the czech translation of GeneralCatalog
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2007-2008 Milen Koutev
# Copyright (C) 2010 O2BS.com, s r.o. Jakub Hanus
# --
# $Id: cz_GeneralCatalog.pm,v 1.12 2010-08-08 21:01:54 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cz_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.12 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'Hlavní Katalog';
    $Lang->{'General Catalog Management'} = 'Správa Hlavního Katalogu';
    $Lang->{'Catalog Class'}              = 'Tøídy Katalogu';
    $Lang->{'Add a new Catalog Class.'}   = 'Pøidat Novou Tøídu Katalogu.';
    $Lang->{'Add Catalog Item'}           = 'Pøidat Polo¾ku Katalogu';
    $Lang->{'Add Catalog Class'}          = 'Pøidat Tøídu Katalogu';
    $Lang->{'Functionality'}              = 'Funkcionalita';
    $Lang->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = '';

    return 1;
}

1;
