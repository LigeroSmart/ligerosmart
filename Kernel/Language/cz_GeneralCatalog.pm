# --
# Kernel/Language/cz_GeneralCatalog.pm - the czech translation of GeneralCatalog
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: cz_GeneralCatalog.pm,v 1.6 2008-05-21 08:36:37 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::cz_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

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
