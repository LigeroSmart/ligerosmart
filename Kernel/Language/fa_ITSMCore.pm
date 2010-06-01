# --
# Kernel/Language/fa_ITSMCore.pm - the persian (farsi) translation of ITSMCore
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2003-2009 Afshar Mohebbi <afshar.mohebbi at gmail.com>
# ---
# $Id: fa_ITSMCore.pm,v 1.3 2010-06-01 19:25:22 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fa_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'اهمیت';
    $Lang->{'Impact'}                              = 'اثر';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'اهمیت <-> اثر <-> اولویت';
    $Lang->{'allocation'}                          = 'اختصاص';
    $Lang->{'Priority allocation'}                 = '';
    $Lang->{'Relevant to'}                         = 'مرتبط با';
    $Lang->{'Includes'}                            = 'مشتمل است بر';
    $Lang->{'Part of'}                             = 'بخشی از';
    $Lang->{'Depends on'}                          = 'وابسته است به';
    $Lang->{'Required for'}                        = 'مورد نیاز است برای';
    $Lang->{'Connected to'}                        = 'متصل است به';
    $Lang->{'Alternative to'}                      = 'جایگزینی برای';
    $Lang->{'Incident State'}                      = 'وضعیت رخداد';
    $Lang->{'Current Incident State'}              = 'وضعیت جاری رخداد';
    $Lang->{'Current State'}                       = 'وضعیت جاری';
    $Lang->{'Service-Area'}                        = 'بخش سرویس';
    $Lang->{'Minimum Time Between Incidents'}      = 'حداقل زمان بین دو رخداد';
    $Lang->{'Service Overview'}                    = 'خلاصه سرویس';
    $Lang->{'SLA Overview'}                        = 'خلاصه SLA';
    $Lang->{'Associated Services'}                 = 'سرویس‌های مرتبط';
    $Lang->{'Associated SLAs'}                     = 'SLAهای مرتبط';
    $Lang->{'Back End'}                            = 'پشت صحنه';
    $Lang->{'Demonstration'}                       = 'نمایش';
    $Lang->{'End User Service'}                    = 'سرویس کاربر نهایی';
    $Lang->{'Front End'}                           = 'جلو صحنه';
    $Lang->{'IT Management'}                       = 'مدیریت IT';
    $Lang->{'IT Operational'}                      = 'عملیات IT';
    $Lang->{'Other'}                               = 'بقیه';
    $Lang->{'Project'}                             = 'پروژه';
    $Lang->{'Reporting'}                           = 'گزارشی';
    $Lang->{'Training'}                            = 'آموزشی';
    $Lang->{'Underpinning Contract'}               = 'قرارداد آماده چاپ';
    $Lang->{'Availability'}                        = 'میزان در دسترس بودن';
    $Lang->{'Errors'}                              = 'خطاها';
    $Lang->{'Other'}                               = 'بقیه';
    $Lang->{'Recovery Time'}                       = 'زمان بهبود';
    $Lang->{'Resolution Rate'}                     = 'نرخ حل مسئله';
    $Lang->{'Response Time'}                       = 'زمان پاسخگویی';
    $Lang->{'Transactions'}                        = 'تراکنش‌ها';

    return 1;
}

1;
