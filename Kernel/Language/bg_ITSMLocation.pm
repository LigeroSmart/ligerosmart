# --
# Kernel/Language/bg_ITSMLocation.pm - the bulgarian translation of ITSMLocation
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: bg_ITSMLocation.pm,v 1.1 2008-06-21 12:45:18 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::bg_ITSMLocation;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Location'}            = 'Локация';
    $Lang->{'Location-Area'}       = '';
    $Lang->{'Location Management'} = 'Управление на локациите - Местоположенията';
    $Lang->{'Add Location'}        = 'Добави локация';
    $Lang->{'Add a new Location.'} = 'Можете да добавите нова локация';
    $Lang->{'Sub-Location of'}     = 'Под-локация на';
    $Lang->{'Address'}             = 'Адрес';
    $Lang->{'Building'}            = 'Сграда';
    $Lang->{'Floor'}               = 'Етаж';
    $Lang->{'IT Facility'}         = 'ИТ Съоръжение/Помещение';
    $Lang->{'Office'}              = 'Офис';
    $Lang->{'Other'}               = 'Други';
    $Lang->{'Outlet'}              = 'Извод-розетка';
    $Lang->{'Rack'}                = 'Шкаф-рак';
    $Lang->{'Room'}                = 'Стая';
    $Lang->{'Workplace'}           = 'Работно място';

    return 1;
}

1;
