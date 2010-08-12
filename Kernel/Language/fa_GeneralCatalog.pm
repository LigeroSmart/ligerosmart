# --
# Kernel/Language/fa_GeneralCatalog.pm - the persian (farsi) translation of GeneralCatalog
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2003-2009 Afshar Mohebbi <afshar.mohebbi at gmail.com>
# --
# $Id: fa_GeneralCatalog.pm,v 1.3 2010-08-12 22:50:38 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fa_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'فهرست عمومی';
    $Lang->{'General Catalog Management'} = 'مدیریت فهرست عمومی';
    $Lang->{'Catalog Class'}              = 'فهرست کلاسی';
    $Lang->{'Add a new Catalog Class.'}   = 'اضافه کردن فهرست کلاسی.';
    $Lang->{'Add Catalog Item'}           = 'اضافه کردن یک قلم فهرست';
    $Lang->{'Add Catalog Class'}          = 'اضافه کردن کلاس فهرستی';
    $Lang->{'Functionality'}              = 'کارکردی';
    $Lang->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = '';
    $Lang->{'Parameters for the example comment 2 of general catalog attributes.'} = '';
    $Lang->{'Parameters for the example permission groups of general catalog attributes.'} = '';

    return 1;
}

1;
