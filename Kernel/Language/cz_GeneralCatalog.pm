# --
# Kernel/Language/cz_GeneralCatalog.pm - the czech translation of GeneralCatalog
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# Copyright (C) 2007-2008 Milen Koutev
# --
# $Id: cz_GeneralCatalog.pm,v 1.10 2009-07-20 12:19:07 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cz_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'V¹eobecný katalog';
    $Lang->{'General Catalog Management'} = 'Øízení v¹eobecného katalogu';
    $Lang->{'Catalog Class'}              = 'Tøídy v katalogu';
    $Lang->{'Add a new Catalog Class.'}   = 'Pøidat novou tøídu do katalogu.';
    $Lang->{'Add Catalog Item'}           = 'Pøidat prvek do katalogu';
    $Lang->{'Add Catalog Class'}          = 'Pøidat tøídu do katalogu';
    $Lang->{'Functionality'}              = 'Funkcionalita';

    return 1;
}

1;
