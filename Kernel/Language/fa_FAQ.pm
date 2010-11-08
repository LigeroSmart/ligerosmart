# --
# Kernel/Language/fa_FAQ.pm - the persian (farsi) translation of FAQ
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Translated/Updated into Persian (Farsi) by Afshar Mohebbi <afshar.mohebbi at gmail.com>
# --
# $Id: fa_FAQ.pm,v 1.5 2010-11-08 15:41:12 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::fa_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'You have already voted!'} = 'شما قبلا رای داده‌اید!';
    $Lang->{'No rate selected!'}       = 'امتیاز را انتخاب نکرده‌اید!';
    $Lang->{'Thanks for your vote!'}   = 'از رای شما سپاسگزاریم!';
    $Lang->{'Votes'}                   = 'آرا';
    $Lang->{'LatestChangedItems'}      = 'آخرین اقلام تعریف شده';
    $Lang->{'LatestCreatedItems'}      = 'آخرین اقلام ایجاد شده';
    $Lang->{'Top10Items'}              = 'بالاترین ۱۰ قلم';
    $Lang->{'ArticleVotingQuestion'}   = 'سوال رای‌دهی به نوشته‌ها';
    $Lang->{'SubCategoryOf'}           = 'زیر مجموعه‌ی';
    $Lang->{'QuickSearch'}             = 'جستجوی سریع';
    $Lang->{'DetailSearch'}            = 'جستجوی با جزییات';
    $Lang->{'Categories'}              = 'دسته‌بندی‌ها';
    $Lang->{'SubCategories'}           = 'زیر دسته‌ها';
    $Lang->{'New FAQ Article'}         = 'نوشته جدید FAQ';
    $Lang->{'FAQ Category'}            = 'دسته FAQ';
    $Lang->{'A category should have a name!'}    = 'دسته بدون نام امکان پذیر نیست!';
    $Lang->{'A category should have a comment!'} = 'دسته بدون توضیح امکان پذیر نیست!';
    $Lang->{'FAQ Articles (new created)'}        = 'اخبار FAQ (جدیدا ایجاد شده)';
    $Lang->{'FAQ Articles (recently changed)'}   = 'اخبار FAQ (جدیدا تغییر یافته)';
    $Lang->{'FAQ Articles (Top 10)'}             = 'اخبار FAQ (۱۰ تای برتر)';
    $Lang->{'StartDay'}                          = 'روز آغاز';
    $Lang->{'StartMonth'}                        = 'ماه آغاز';
    $Lang->{'StartYear'}                         = 'سال آغاز';
    $Lang->{'EndDay'}                            = 'روز پایان';
    $Lang->{'EndMonth'}                          = 'ماه پایان';
    $Lang->{'EndYear'}                           = 'سال پایان';
    $Lang->{'Approval'}                          = 'تایید';
    $Lang->{
        'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'
        }
        = 'دسترسی به هیچ کدام از دسته‌بندی‌ها مقدور نیست. برای ایجاد یک نوشته جدید اقلا به یک دسته‌بندی باید دسترسی داشته باشید. لطفا از طریق منوی category دسترسی‌های گروه/دسته را بررسی فرمایید!';
    $Lang->{'Agent groups which can access this category.'}
        = 'گروه‌های کارشناسی که به این دسته‌بندی دسترسی دارند.';
    $Lang->{'A category needs at least one permission group!'}
        = 'یک دسته‌بندی اقلا نیاز به دسترسی به یک گروه را دارد!';
    $Lang->{'Will be shown as comment in Explorer.'} = 'در Explorer به صورت یک متن توضیحی نمایش داده خواهند شد.';

    return 1;
}

1;
