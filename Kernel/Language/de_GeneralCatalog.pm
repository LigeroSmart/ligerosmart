# --
# Kernel/Language/de_GeneralCatalog.pm - the german translation of GeneralCatalog
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: de_GeneralCatalog.pm,v 1.14 2009-05-18 09:40:46 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

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

    return 1;
}

1;
