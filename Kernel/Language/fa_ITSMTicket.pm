# --
# Kernel/Language/fa_ITSMTicket.pm - the persian (farsi) translation of fa_ITSMTicket
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# Copyright (C) 2003-2009 Afshar Mohebbi <afshar.mohebbi at gmail.com>
# --
# $Id: fa_ITSMTicket.pm,v 1.1 2009-07-20 10:36:08 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fa_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'تاریخ انجام';
    $Lang->{'Decision'}                     = 'تصمیم';
    $Lang->{'Reason'}                       = 'دلیل';
    $Lang->{'Decision Date'}                = 'تاریخ تصمیم';
    $Lang->{'Add decision to ticket'}       = 'الصاق یک تصمیم به درخواست';
    $Lang->{'Decision Result'}              = 'نتیجه تصمیم';
    $Lang->{'Review Required'}              = 'نیاز به بازبینی دارد';
    $Lang->{'closed with workaround'}       = 'موقتا بسته شد';
    $Lang->{'Additional ITSM Fields'}       = 'فیلدهای اضافه ITSM';
    $Lang->{'Change ITSM fields of ticket'} = 'تغییر فیلدهای ITSM درخواست';
    $Lang->{'Repair Start Time'}            = 'زمان شروع تعمیر';
    $Lang->{'Recovery Start Time'}          = 'زمان شروع بهبود';
    $Lang->{'Change the ITSM fields!'}      = 'فیلدهای ITSM را تغییر دهید!';
    $Lang->{'Add a decision!'}              = 'یک تصمیم اضافه کنید!';

    return 1;
}

1;
