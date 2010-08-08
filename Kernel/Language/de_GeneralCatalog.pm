# --
# Kernel/Language/de_GeneralCatalog.pm - the german translation of GeneralCatalog
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: de_GeneralCatalog.pm,v 1.15 2010-08-08 21:01:54 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.15 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'General Catalog';
    $Lang->{'General Catalog Management'} = 'General Catalog Verwaltung';
    $Lang->{'Catalog Class'}              = 'Katalog Klasse';
    $Lang->{'Add a new Catalog Class.'}   = 'Eine neue Katalog Klasse hinzufügen.';
    $Lang->{'Add Catalog Item'}           = 'Katalog Eintrag hinzufügen';
    $Lang->{'Add Catalog Class'}          = 'Katalog Klasse hinzufügen';
    $Lang->{'Functionality'}              = 'Funktionalität';
    $Lang->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = 'Frontendmodul-Registration der AdminGeneralCatalog Konfiguration im Admin-Bereich.';

    return 1;
}

1;
