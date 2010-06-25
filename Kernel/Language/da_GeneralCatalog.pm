# --
# Kernel/Language/da_GeneralCatalog.pm - provides da (Danish) language translation
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: da_GeneralCatalog.pm,v 1.1 2010-06-25 08:54:55 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::da_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'General Katalog';
    $Lang->{'General Catalog Management'} = 'General Katalog Management';
    $Lang->{'Catalog Class'}              = 'Katalog Klasse';
    $Lang->{'Add a new Catalog Class.'}   = 'Tilføj ny katalog klasse.';
    $Lang->{'Add Catalog Item'}           = 'Tilføj katalog post';
    $Lang->{'Add Catalog Class'}          = 'Tilføj Katalog klasse';
    $Lang->{'Functionality'}              = 'Funktionalitet';

    return 1;
}

1;
