# --
# Kernel/Language/de_GeneralCatalog.pm - the german translation of GeneralCatalog
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: de_GeneralCatalog.pm,v 1.7 2007-10-01 15:08:34 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::de_GeneralCatalog;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'General Catalog'}            = 'Allgemeiner Katalog';
    $Self->{Translation}->{'General Catalog Management'} = 'Allgemeiner Katalog Verwaltung';
    $Self->{Translation}->{'Catalog Class'}              = 'Katalog Klasse';
    $Self->{Translation}->{'Add a new Catalog Class.'}   = 'Eine neue Katalog Klasse hinzufügen.';
    $Self->{Translation}->{'Add Catalog Item'}           = 'Katalog Eintrag hinzufügen';
    $Self->{Translation}->{'Add Catalog Class'}          = 'Katalog Klasse hinzufügen';
    $Self->{Translation}->{'Functionality'}              = 'Funktionalität';

    return 1;
}

1;
