# --
# Kernel/Language/bg_ITSMTicket.pm - the bulgarian translation of ITSMTicket
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# Copyright (C) 2007-2008 Milen Koutev
# --
# $Id: bg_ITSMTicket.pm,v 1.3 2008-08-14 11:49:53 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::bg_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Крайна дата';
    $Lang->{'Decision'}                     = 'Решение';
    $Lang->{'Reason'}                       = 'Основание';
    $Lang->{'Decision Date'}                = 'Дата за решаване';
    $Lang->{'Add decision to ticket'}       = 'Добави решение към билета';
    $Lang->{'Decision Result'}              = 'Резултат от решението';
    $Lang->{'Review Required'}              = 'Изисква преглеждане';
    $Lang->{'closed with workaround'}       = 'приключен с обходно решение';
    $Lang->{'Additional ITSM Fields'}       = 'Допълнителни ITSM полета';
    $Lang->{'Change ITSM fields of ticket'} = 'Промени ITSM полетата на билета';
    $Lang->{'Repair Start Time'}            = 'Време на стартиране на ремонта';
    $Lang->{'Recovery Start Time'}          = 'Време на стартиране на възстановяването';

    return 1;
}

1;
