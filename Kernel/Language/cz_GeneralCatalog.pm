# --
# Kernel/Language/cz_GeneralCatalog.pm - the czech translation of GeneralCatalog
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: cz_GeneralCatalog.pm,v 1.3 2008-01-23 16:24:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::cz_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my ($Self) = @_;

    $Self->{Translation}->{'General Catalog'} = 'Všeobecný katalog';
    $Self->{Translation}->{'General Catalog Management'}
        = 'Řízení všeobecného katalogu';
    $Self->{Translation}->{'Catalog Class'}            = 'Třídy v katalogu';
    $Self->{Translation}->{'Add a new Catalog Class.'} = 'Přidat novou třídu do katalogu.';
    $Self->{Translation}->{'Add Catalog Item'}         = 'Přidat prvek do katalogu';
    $Self->{Translation}->{'Add Catalog Class'}        = 'Přidat třídu do katalogu';
    $Self->{Translation}->{'Functionality'}            = 'Funkcionalita';

    return 1;
}

1;
