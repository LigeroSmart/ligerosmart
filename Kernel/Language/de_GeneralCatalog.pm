# --
# Kernel/Language/de_GeneralCatalog.pm - the german translation of GeneralCatalog
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: de_GeneralCatalog.pm,v 1.4 2007-05-21 15:37:51 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::de_GeneralCatalog;

use strict;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'General Catalog'} = 'Allgemeiner Katalog';
    $Self->{Translation}->{'General Catalog Management'} = 'Allgemeiner Katalog Verwaltung';
    $Self->{Translation}->{'Catalog Class'} = 'Katalog Klasse';
    $Self->{Translation}->{'Add a new Catalog Class.'} = 'Eine neue Katalog Klasse hinzufügen.';
    $Self->{Translation}->{'Functionality'} = 'Funktionalität';
    $Self->{Translation}->{'Add new item failed! See System Log for details.'} = 'Hinzufügen des neuen Eintrags fehlgeschlagen! Im System Log finden Sie weitere Informationen.';
    $Self->{Translation}->{'Add new class failed! Class name not valid.'} = 'Hinzufügen der neuen Klasse fehlgeschlagen! Name der Klasse ungültig.';
    $Self->{Translation}->{'Update item faild! See System Log for details.'} = 'Updaten des Eintrags fehlgeschlagen! Im System Log finden Sie weitere Informationen.';
}

1;