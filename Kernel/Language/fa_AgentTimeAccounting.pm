# --
# Kernel/Language/fa_AgentTimeAccounting.pm - Persian translation for AgentTimeAccounting
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: fa_AgentTimeAccounting.pm,v 1.1 2010-12-21 16:30:36 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fa_AgentTimeAccounting;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Setting'} = 'تنظیمات';
    $Lang->{'Project settings'} = 'تنظیمات پروژه';
    $Lang->{'Next day'} = 'روز بعد';
    $Lang->{'One day back'} = 'برگشت به روز قبل';
    $Lang->{'Date'} = 'تاریخ';
    $Lang->{'Comments'} = 'توضیحات';
    $Lang->{'until'} = 'تا';
    $Lang->{'Total ras eurs worked'} = 'جمع ساعات کاری';
    $Lang->{'Working Hours'} = 'ساعات کاری';
    $Lang->{'Hours per week'} = 'میزان ساعات در هفته';
    $Lang->{'this month'} = 'این ماه';
    $Lang->{'Overtime (Hours)'} = 'ساعات اضافه کار';
    $Lang->{'Overtime (total)'} = 'مجموع اضافه کار';
    $Lang->{'Overtime (this month)'} = 'اضافه کار این ماه';
    $Lang->{'Remaining overtime leave'} = 'اضافه کاری باقیمانده مجاز';
    $Lang->{'Vacation'} = 'مرخصی';
    $Lang->{'Vacation (Days)'} = 'مرخصی )روزها(';
    $Lang->{'Vacation taken (this month)'} = 'مرخصی‌های گرفته شده این ماه';
    $Lang->{'Vacation taken (total)'} = 'کل مرخصی‌های گرفته شده';
    $Lang->{'Remaining vacation'} = 'مرخصی باقیمانده';
    $Lang->{'Sick leave taken (this month)'} = 'استعلاجی گرفته شده این ماه';
    $Lang->{'Sick leave taken (total)'} = 'کل استعلاجی گرفته شده';
    $Lang->{'TimeAccounting'} = 'حسابداری زمان';
    $Lang->{'Time accounting.'} = 'حسابداری زمان';
    $Lang->{'Time reporting monthly overview'} = 'گزارش کلی ماهیانه زمان ';
    $Lang->{'Edit time record'} = 'ویرایش سابقه زمان';
    $Lang->{'Edit time accounting settings'} = 'ویرایش تنظیمات حسابداری زمان';
    $Lang->{'User reports'} = 'گزارشات کاربری';
    $Lang->{'User\'s project overview'} = 'نمای کلی پروژه کاربر';
    $Lang->{'Project report'} = 'گزارش پروژه';
    $Lang->{'Project reports'} = 'گزارشات پروژه';
    $Lang->{'Time reporting'} = 'گزارشگیری زمان';
    $Lang->{'LeaveDay Remaining'} = 'باقیمانده ترک کار';
    $Lang->{'Monthly total'} = 'کل ماهیانه';
    $Lang->{'View time record'} = 'نمایش سابقه زمان';
    $Lang->{'View of'} = 'نمای کلی از';
    $Lang->{'Monthly'} = 'ماهیانه';
    $Lang->{'Hours'} = 'ساعات';
    $Lang->{'Date navigation'} = 'راهبری تاریخ';
    $Lang->{'Month navigation'} = 'راهبری ماه';
    $Lang->{'Days without entries'} = 'روزهای ثبت نشده';
    $Lang->{'Project'} = 'پروژه';
    $Lang->{'Projects'} = 'پروژه‌ها';
    $Lang->{'Grand total'} = 'تعداد';
    $Lang->{'Lifetime'} = 'تعداد';
    $Lang->{'Lifetime total'} = 'تعداد';
    $Lang->{'Reporting'} = 'گزارشگیری';
    $Lang->{'Task settings'} = 'تنظیمات وظایف';
    $Lang->{'User settings'} = 'تنظیمات کاربری';
    $Lang->{'Show Overtime'} = 'نمایش اضافه کاری';
    $Lang->{'Allow project creation'} = 'اجازه ساخت پروژه';
    $Lang->{'Add time period'} = 'افزودن دوره زمانی';
    $Lang->{'Remark'} = 'تذکر';
    $Lang->{'Start'} = 'آغاز';
    $Lang->{'End'} = 'پایان';
    $Lang->{'Period begin'} = 'آغاز دوره';
    $Lang->{'Period end'} = 'پایان دوره';
    $Lang->{'Period'} = 'دوره';
    $Lang->{'Days of vacation'} = 'روزهای مرخصی';
    $Lang->{'On vacation'} = 'در مرخصی';
    $Lang->{'Sick day'} = 'بیماری';
    $Lang->{'Sick leave (Days)'} = 'روزهای استعلاجی';
    $Lang->{'Sick leave'} = 'استعلاجی';
    $Lang->{'On sick leave'} = 'در استعلاجی';
    $Lang->{'Task'} = 'وظیفه';
    $Lang->{'Authorized overtime'} = 'اضافه کار مجاز';
    $Lang->{'On overtime leave'} = 'در مازاد اضافه کاری';
    $Lang->{'Overtime leave'} = 'مازاد اضافه کاری';
    $Lang->{'Total'} = 'جمع کل';
    $Lang->{'Overview of '} = 'نمای کلی از';
    $Lang->{'TimeAccounting of'} = 'حسابداری زمان مربوط به';
    $Lang->{'Successful insert!'} = 'با موفقیت ثبت شد';
    $Lang->{'More input fields'} = 'فیلدهای ورودی بیشتر';
    $Lang->{'Do you really want to delete this Object'} = 'آیا واقعا مایل به حذف این مورد هستید؟';
    $Lang->{'Can\'t insert Working Units!'} = 'عدم توانایی در ثبت واحدهای کاری';
    $Lang->{'Can\'t save settings, because of missing task!'} = 'به دلیل فراموشی وظیفه، تنظیمات ذخیره نمی‌شود!';
    $Lang->{'Can\'t save settings, because of missing project!'} = 'به دلیل فراموشی پروژه، تنظیمات ذخیره نمی‌شود!';
    $Lang->{'Can\'t save settings, because the Period is bigger than the interval between Starttime and Endtime!'}
        = 'نمی‌توان تنظیمات را ذخیره کرد زیرا دوره زمانی از مقدار ورودی بین ساعت آغاز و پایان بزرگتر است!';
    $Lang->{'Can\'t save settings, because Starttime is older than Endtime!'}
        =  'نمی‌توان تنظیمات را ذخیره کرد زیرا زمان شروع بعد از زمان پایان است!';
    $Lang->{'Can\'t save settings, because of missing period!'} = 'نمی‌توان تنظیمات را ذخیره کرد زیرا دوره زمانی فراموش شده است!';
    $Lang->{'Can\'t save settings, because Period is not given!'} = 'نمی‌توان تنظیمات را ذخیره کرد زیرا دوره زمانی داده نشده است!';
    $Lang->{'Are you sure, that you worked while you were on sick leave?'} = 'آیا اطمینان دارید در زمانی که در زمان استعلاجی بودید، کار کرده‌اید؟';
    $Lang->{'Are you sure, that you worked while you were on vacation?'} = 'آیا اطمینان دارید در زمانی که در مرخصی بودید، کار کرده‌اید؟';
    $Lang->{'Are you sure, that you worked while you were on overtime leave?'} = 'آیا اطمینان دارید در زمانی که در مازاد اضافه کاری بودید، کار کرده‌اید؟';
    $Lang->{'Can\'t save settings, because a day has only 24 hours!'} = 'هر روز فقط ۲۴ ساعت دارد!';
    $Lang->{'Can\'t delete Working Units!'} = 'واحدهای کاری قابل خذف نیست!';
    $Lang->{'Please insert your working hours!'} = 'لطفا ساعات کاری خود را وارد نمایید!';
    $Lang->{'You have to insert a start and an end time or a period'} = 'شما باید یا یک دوره زمانی و یا زمان آغاز و پایان وارد نمایید!';
    $Lang->{'You can only select one checkbox element!'} = 'شما فقط می‌توانید یک گزینه را انتخاب نمایید!';
    $Lang->{'Edit time accounting project settings'} = 'ویرایش تنظیمات حسابداری زمان پروژه';
    $Lang->{'Project settings'} = 'تنظیمات پروژه';
    $Lang->{'If you select "Miscellaneous (misc)" the task, please explain this in the remarks field'} =
        'اگر وظایف همزمان را انتخاب کردید، لطفا در فیلدهای تذکر توضیح دهید';
    $Lang->{'Please add a remark with more than 8 characters!'} = 'لطفا تذکری با بیش از ۸ کاراکتر بیفزایید!';
    $Lang->{'Mon'} = 'دوشنبه';
    $Lang->{'Tue'} = 'سه‌شنبه';
    $Lang->{'Wed'} = 'چهارشنبه';
    $Lang->{'Thu'} = 'پنجشنبه';
    $Lang->{'Fri'} = 'جمعه';
    $Lang->{'Sat'} = 'شنبه';
    $Lang->{'Sun'} = 'یکشنبه';
    $Lang->{'January'} = 'ژانویه';
    $Lang->{'February'} = 'فوریه';
    $Lang->{'March'} = 'مارس';
    $Lang->{'April'} = '';
    $Lang->{'May'} = 'می';
    $Lang->{'June'} = 'ژوئن';
    $Lang->{'July'} = 'جولای';
    $Lang->{'August'} = '';
    $Lang->{'September'} = '';
    $Lang->{'October'} = 'اکتبر';
    $Lang->{'November'} = '';
    $Lang->{'December'} = 'دسامبر';
    $Lang->{'Frontend module registration for the agent interface.'} = '';
    $Lang->{'Overview'} = '';
    $Lang->{'Project time reporting'} = '';
    $Lang->{'Default name for new projects.'} = '';
    $Lang->{'Default status for new projects.'} = '';
    $Lang->{'Default name for new actions.'} = '';
    $Lang->{'Default status for new actions.'} = '';
    $Lang->{'Default setting for the standard weekly hours.'} = '';
    $Lang->{'Default setting for leave days.'} = '';
    $Lang->{'Default setting for overtime.'} = '';
    $Lang->{'Default setting for date start.'} = '';
    $Lang->{'Default setting for date end.'} = '';
    $Lang->{'Default status for new users.'} = '';
    $Lang->{'Maximum number of working days after which the working units have to be inserted.'} = '';
    $Lang->{'Maximum number of working days withouth working units entry after which a warning will be shown.'} = '';
    $Lang->{'This notification module gives a warning if there are too many incomplete working days.'} = '';
    $Lang->{'For how many days ago you can insert working units.'} = '';
    $Lang->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key =&gt; traveling; Content =&gt; 50).'}
        = '';
    $Lang->{'Specifies if working hours can be inserted without start and end times.'} = '';
    $Lang->{'This module forces inserts in TimeAccounting.'} = '';
    $Lang->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'}
        = '';
    $Lang->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'}
        = '';
    $Lang->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'}
        = '';

    return 1;
}

1;
