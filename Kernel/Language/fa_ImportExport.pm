# --
# Kernel/Language/fa_ImportExport.pm - the persian (farsi) translation of fa_ImportExport
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2003-2009 Afshar Mohebbi <afshar.mohebbi at gmail.com>
# --
# $Id: fa_ImportExport.pm,v 1.2 2010-05-17 13:49:17 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fa_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'}              = 'ورود/صدور';
    $Lang->{'Import/Export Management'}   = 'مدیریت ورود/صدور';
    $Lang->{'Add mapping template'}       = 'اضافه کردن یک قالب نگاشت';
    $Lang->{'Start Import'}               = 'شروع عملیات ورود';
    $Lang->{'Start Export'}               = 'شروع عملیات صدور';
    $Lang->{'Step'}                       = 'گام';
    $Lang->{'Edit common information'}    = 'ویرایش اطلاعات عمومی';
    $Lang->{'Edit object information'}    = 'ویرایش اطلاعات آبجکتی';
    $Lang->{'Edit format information'}    = 'ویرایش اطلاعات قالب‌بندی';
    $Lang->{'Edit mapping information'}   = 'ویرایش اطلاعات نگاشت';
    $Lang->{'Edit search information'}    = 'ویرایش اطلاعات جستجو';
    $Lang->{'Import information'}         = 'ورود اطلاعات';
    $Lang->{'Column'}                     = 'ستون';
    $Lang->{'Restrict export per search'} = 'محدودسازی عملیات صدور به ازای جستجو';
    $Lang->{'Source File'}                = 'فایل منبع';
    $Lang->{'Column Separator'}           = 'جداکننده ستون‌ها';
    $Lang->{'Tabulator (TAB)'}            = 'جدول ساز (TAB)';
    $Lang->{'Semicolon (;)'}              = 'سمی کالن (;)';
    $Lang->{'Colon (:)'}                  = 'دونقطه (:)';
    $Lang->{'Dot (.)'}                    = 'نقطه (.)';
    $Lang->{'Charset'}                    = 'کدبندی اطلاعات';

    return 1;
}

1;
