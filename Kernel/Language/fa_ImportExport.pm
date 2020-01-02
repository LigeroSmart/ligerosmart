# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::fa_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'مدیریت ورود/صدور';
    $Self->{Translation}->{'Add template'} = 'اضافه کردن قالب';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'ساخت قالبی برای ورود و صدور اطلاعات آبجکت';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        '';
    $Self->{Translation}->{'Start Import'} = 'شروع عملیات ورود';
    $Self->{Translation}->{'Start Export'} = 'شروع عملیات صدور';
    $Self->{Translation}->{'Delete this template'} = '';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = '';
    $Self->{Translation}->{'Name is required!'} = '';
    $Self->{Translation}->{'Object is required!'} = 'آبجکت مورد نیاز است!';
    $Self->{Translation}->{'Format is required!'} = 'قالب‌بندی مورد نیاز است!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = '';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = '';
    $Self->{Translation}->{'is required!'} = '';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = '';
    $Self->{Translation}->{'No map elements found.'} = 'هیچ عنصر نگاشتی یافت نشد.';
    $Self->{Translation}->{'Add Mapping Element'} = 'افزودن عنصر نگاشت';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = '';
    $Self->{Translation}->{'Restrict export per search'} = 'محدودسازی عملیات صدور به ازای جستجو';
    $Self->{Translation}->{'Import information'} = 'ورود اطلاعات';
    $Self->{Translation}->{'Source File'} = 'فایل منبع';
    $Self->{Translation}->{'Import summary for %s'} = '';
    $Self->{Translation}->{'Records'} = '';
    $Self->{Translation}->{'Success'} = '';
    $Self->{Translation}->{'Duplicate names'} = '';
    $Self->{Translation}->{'Last processed line number of import file'} = '';
    $Self->{Translation}->{'Ok'} = 'تایید';
    $Self->{Translation}->{'Do you really want to delete this template item?'} = '';

    # Perl Module: Kernel/Modules/AdminImportExport.pm
    $Self->{Translation}->{'No object backend found!'} = '';
    $Self->{Translation}->{'No format backend found!'} = '';
    $Self->{Translation}->{'Template not found!'} = '';
    $Self->{Translation}->{'Can\'t insert/update template!'} = '';
    $Self->{Translation}->{'Needed TemplateID!'} = '';
    $Self->{Translation}->{'Error occurred. Import impossible! See Syslog for details.'} = '';
    $Self->{Translation}->{'Error occurred. Export impossible! See Syslog for details.'} = '';
    $Self->{Translation}->{'Template List'} = '';
    $Self->{Translation}->{'number'} = '';
    $Self->{Translation}->{'number bigger than zero'} = '';
    $Self->{Translation}->{'integer'} = '';
    $Self->{Translation}->{'integer bigger than zero'} = '';
    $Self->{Translation}->{'Element required, please insert data'} = '';
    $Self->{Translation}->{'Invalid data, please insert a valid %s'} = '';
    $Self->{Translation}->{'Format not found!'} = '';

    # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
    $Self->{Translation}->{'Column Separator'} = 'جداکننده ستون‌ها';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'جدول ساز (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = 'سمی کالن (;)';
    $Self->{Translation}->{'Colon (:)'} = 'دونقطه (:)';
    $Self->{Translation}->{'Dot (.)'} = 'نقطه (.)';
    $Self->{Translation}->{'Comma (,)'} = '';
    $Self->{Translation}->{'Charset'} = 'کدبندی اطلاعات';
    $Self->{Translation}->{'Include Column Headers'} = '';
    $Self->{Translation}->{'Column'} = 'ستون';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = '';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        '';
    $Self->{Translation}->{'Template was deleted successfully.'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'قالب‌بندی ثبت ماژول برای ماژول ورود/صدور';
    $Self->{Translation}->{'Import and export object information.'} = 'ورود و صدور اطلاعات آبجکت';
    $Self->{Translation}->{'Import/Export'} = 'ورود/صدور';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Confirm',
    'Delete this template',
    'Deleting template...',
    'Template was deleted successfully.',
    'There was an error deleting the template. Please check the logs for more information.',
    );

}

1;
