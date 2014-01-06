# --
# Kernel/Language/fa_ImportExport.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fa_ImportExport;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = 'اضافه کردن یک قالب نگاشت';
    $Self->{Translation}->{'Charset'} = 'کدبندی اطلاعات';
    $Self->{Translation}->{'Colon (:)'} = 'دونقطه (:)';
    $Self->{Translation}->{'Column'} = 'ستون';
    $Self->{Translation}->{'Column Separator'} = 'جداکننده ستون‌ها';
    $Self->{Translation}->{'Dot (.)'} = 'نقطه (.)';
    $Self->{Translation}->{'Semicolon (;)'} = 'سمی کالن (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'جدول ساز (TAB)';
    $Self->{Translation}->{'Include Column Headers'} = '';
    $Self->{Translation}->{'Import summary for'} = '';
    $Self->{Translation}->{'Imported records'} = '';
    $Self->{Translation}->{'Exported records'} = '';
    $Self->{Translation}->{'Records'} = '';
    $Self->{Translation}->{'Skipped'} = '';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'مدیریت ورود/صدور';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'ساخت قالبی برای ورود و صدور اطلاعات آبجکت';
    $Self->{Translation}->{'Start Import'} = 'شروع عملیات ورود';
    $Self->{Translation}->{'Start Export'} = 'شروع عملیات صدور';
    $Self->{Translation}->{'Delete Template'} = 'حذف قالب';
    $Self->{Translation}->{'Step'} = 'گام';
    $Self->{Translation}->{'Edit common information'} = 'ویرایش اطلاعات عمومی';
    $Self->{Translation}->{'Name is required!'} = '';
    $Self->{Translation}->{'Object is required!'} = 'آبجکت مورد نیاز است!';
    $Self->{Translation}->{'Format is required!'} = 'قالب‌بندی مورد نیاز است!';
    $Self->{Translation}->{'Edit object information'} = 'ویرایش اطلاعات آبجکتی';
    $Self->{Translation}->{'Edit format information'} = 'ویرایش اطلاعات قالب‌بندی';
    $Self->{Translation}->{' is required!'} = ' مورد نیاز است!';
    $Self->{Translation}->{'Edit mapping information'} = 'ویرایش اطلاعات نگاشت';
    $Self->{Translation}->{'No map elements found.'} = 'هیچ عنصر نگاشتی یافت نشد.';
    $Self->{Translation}->{'Add Mapping Element'} = 'افزودن عنصر نگاشت';
    $Self->{Translation}->{'Edit search information'} = 'ویرایش اطلاعات جستجو';
    $Self->{Translation}->{'Restrict export per search'} = 'محدودسازی عملیات صدور به ازای جستجو';
    $Self->{Translation}->{'Import information'} = 'ورود اطلاعات';
    $Self->{Translation}->{'Source File'} = 'فایل منبع';
    $Self->{Translation}->{'Success'} = '';
    $Self->{Translation}->{'Failed'} = '';
    $Self->{Translation}->{'Duplicate names'} = '';
    $Self->{Translation}->{'Last processed line number of import file'} = '';
    $Self->{Translation}->{'Ok'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'قالب‌بندی ثبت ماژول برای ماژول ورود/صدور';
    $Self->{Translation}->{'Import and export object information.'} = 'ورود و صدور اطلاعات آبجکت';
    $Self->{Translation}->{'Import/Export'} = 'ورود/صدور';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Template List'} = 'فهرست قالب‌ها';

}

1;
