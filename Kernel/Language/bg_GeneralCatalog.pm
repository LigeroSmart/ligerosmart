# --
# Kernel/Language/bg_GeneralCatalog.pm - the bulgarian translation of GeneralCatalog
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: bg_GeneralCatalog.pm,v 1.4 2008-01-23 16:24:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::bg_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub Data {
    my ($Self) = @_;

    $Self->{Translation}->{'General Catalog'} = 'Основен каталог';
    $Self->{Translation}->{'General Catalog Management'}
        = 'Управление на основния каталог';
    $Self->{Translation}->{'Catalog Class'} = 'Класове в каталога';
    $Self->{Translation}->{'Add a new Catalog Class.'}
        = 'Добави нов клас в каталога.';
    $Self->{Translation}->{'Add Catalog Item'}
        = 'Добави елемент към каталога';
    $Self->{Translation}->{'Add Catalog Class'} = 'Добави клас в каталога';
    $Self->{Translation}->{'Functionality'}     = 'Функционалност';

    return 1;
}

1;
