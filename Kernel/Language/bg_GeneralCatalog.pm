# --
# Kernel/Language/bg_GeneralCatalog.pm - the bulgarian translation of GeneralCatalog
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2007-2008 Milen Koutev
# --
# $Id: bg_GeneralCatalog.pm,v 1.13 2010-08-12 22:50:38 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::bg_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'Основен каталог';
    $Lang->{'General Catalog Management'} = 'Управление на основния каталог';
    $Lang->{'Catalog Class'}              = 'Класове в каталога';
    $Lang->{'Add a new Catalog Class.'}   = 'Добави нов клас в каталога.';
    $Lang->{'Add Catalog Item'}           = 'Добави елемент към каталога';
    $Lang->{'Add Catalog Class'}          = 'Добави клас в каталога';
    $Lang->{'Functionality'}              = 'Функционалност';
    $Lang->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = '';
    $Lang->{'Parameters for the example comment 2 of general catalog attributes.'} = '';
    $Lang->{'Parameters for the example permission groups of general catalog attributes.'} = '';

    return 1;
}

1;
