# --
# Kernel/Language/nl_GeneralCatalog.pm - the Dutch translation of GeneralCatalog
# Copyright (C) 2009 Michiel Beijen <michiel 'at' beefreeit.nl>
# --
# $Id: nl_GeneralCatalog.pm,v 1.3 2010-08-08 21:01:54 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nl_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'General Catalog';
    $Lang->{'General Catalog Management'} = 'General Catalog Beheer';
    $Lang->{'Catalog Class'}              = 'Catalog Klasse';
    $Lang->{'Add a new Catalog Class.'}   = 'Een nieuwe Catalog Klasse toevoegen';
    $Lang->{'Add Catalog Item'}           = 'Catalog Item toevoegen';
    $Lang->{'Add Catalog Class'}          = 'Catalog Klasse toevoegen';
    $Lang->{'Functionality'}              = 'Functionaliteit';
    $Lang->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = '';

    return 1;
}

1;
