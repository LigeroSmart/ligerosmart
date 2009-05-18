# --
# Kernel/Language/cz_GeneralCatalog.pm - the czech translation of GeneralCatalog
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# Copyright (C) 2007-2008 Milen Koutev
# --
# $Id: cz_GeneralCatalog.pm,v 1.9 2009-05-18 09:40:46 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cz_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'Všeobecný katalog';
    $Lang->{'General Catalog Management'} = 'Řízení všeobecného katalogu';
    $Lang->{'Catalog Class'}              = 'Třídy v katalogu';
    $Lang->{'Add a new Catalog Class.'}   = 'Přidat novou třídu do katalogu.';
    $Lang->{'Add Catalog Item'}           = 'Přidat prvek do katalogu';
    $Lang->{'Add Catalog Class'}          = 'Přidat třídu do katalogu';
    $Lang->{'Functionality'}              = 'Funkcionalita';

    return 1;
}

1;
