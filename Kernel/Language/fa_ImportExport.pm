# --
# Kernel/Language/fa_ImportExport.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: fa_ImportExport.pm,v 1.6 2011-01-24 20:49:14 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fa_ImportExport;

use strict;

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

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'مدیریت ورود/صدور';
    $Self->{Translation}->{'Add template'} = '';
    $Self->{Translation}->{'Create a template to import and export object information.'} = '';
    $Self->{Translation}->{'Start Import'} = 'شروع عملیات ورود';
    $Self->{Translation}->{'Start Export'} = 'شروع عملیات صدور';
    $Self->{Translation}->{'Delete Template'} = '';
    $Self->{Translation}->{'Step'} = 'گام';
    $Self->{Translation}->{'Edit common information'} = 'ویرایش اطلاعات عمومی';
    $Self->{Translation}->{'Object is required!'} = '';
    $Self->{Translation}->{'Format is required!'} = '';
    $Self->{Translation}->{'Edit object information'} = 'ویرایش اطلاعات آبجکتی';
    $Self->{Translation}->{'Edit format information'} = 'ویرایش اطلاعات قالب‌بندی';
    $Self->{Translation}->{' is required!'} = '';
    $Self->{Translation}->{'Edit mapping information'} = 'ویرایش اطلاعات نگاشت';
    $Self->{Translation}->{'No map elements found.'} = '';
    $Self->{Translation}->{'Add Mapping Element'} = '';
    $Self->{Translation}->{'Edit search information'} = 'ویرایش اطلاعات جستجو';
    $Self->{Translation}->{'Restrict export per search'} = 'محدودسازی عملیات صدور به ازای جستجو';
    $Self->{Translation}->{'Import information'} = 'ورود اطلاعات';
    $Self->{Translation}->{'Source File'} = 'فایل منبع';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} = '';
    $Self->{Translation}->{'Import and export object information.'} = '';
    $Self->{Translation}->{'Import/Export'} = 'ورود/صدور';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
