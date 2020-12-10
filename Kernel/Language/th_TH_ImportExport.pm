# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::th_TH_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'การจัดการ นำเข้า/ส่งออก';
    $Self->{Translation}->{'Add template'} = 'เพิ่มแม่แบบ';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'สร้างแม่แบบเพื่อนำเข้าและส่งออกข้อมูลออบเจกต์';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        '';
    $Self->{Translation}->{'Start Import'} = 'เริ่มนำเข้า';
    $Self->{Translation}->{'Start Export'} = 'เริ่มส่งออก';
    $Self->{Translation}->{'Delete this template'} = '';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = '';
    $Self->{Translation}->{'Name is required!'} = 'ต้องระบุชื่อ!';
    $Self->{Translation}->{'Object is required!'} = 'ต้องระบุออบเจกต์!';
    $Self->{Translation}->{'Format is required!'} = 'ต้องระบุรูปแบบ!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = '';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = '';
    $Self->{Translation}->{'is required!'} = 'ต้องระบุ!';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = '';
    $Self->{Translation}->{'No map elements found.'} = 'ไม่พบองค์ประกอบแผนที่';
    $Self->{Translation}->{'Add Mapping Element'} = 'เพิ่มองค์ประกอบของการทำแผนที่';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = '';
    $Self->{Translation}->{'Restrict export per search'} = 'การจำกัดการส่งออกตามการค้นหา';
    $Self->{Translation}->{'Import information'} = 'ข้อมูลนำเข้า';
    $Self->{Translation}->{'Source File'} = 'แหล่งไฟล์';
    $Self->{Translation}->{'Import summary for %s'} = '';
    $Self->{Translation}->{'Records'} = 'การบันทึก';
    $Self->{Translation}->{'Success'} = 'ความสำเร็จ';
    $Self->{Translation}->{'Duplicate names'} = 'ชื่อซ้ำ';
    $Self->{Translation}->{'Last processed line number of import file'} = 'หมายเลขของการประมวลครั้งสุดท้ายของการนำไฟล์เข้า';
    $Self->{Translation}->{'Ok'} = 'โอเค';
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
    $Self->{Translation}->{'Column Separator'} = 'ตัวคั่นคอลัมน์';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'ตัวทำตาราง(แท็บ)';
    $Self->{Translation}->{'Semicolon (;)'} = 'เครื่องหมายอัฒภาค(;)';
    $Self->{Translation}->{'Colon (:)'} = 'เครื่องหมายทวิภาค (:)';
    $Self->{Translation}->{'Dot (.)'} = 'จุด(.)';
    $Self->{Translation}->{'Comma (,)'} = '';
    $Self->{Translation}->{'Charset'} = 'เซตคาเรกเตอร์';
    $Self->{Translation}->{'Include Column Headers'} = 'รวมทั้งส่วนหัวของคอลัมน์';
    $Self->{Translation}->{'Column'} = 'คอลัมน์';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = '';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        '';
    $Self->{Translation}->{'Template was deleted successfully.'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'รูปแบบการลงทะเบียนโมดูล backend สำหรับโมดูลการนำเข้า / ส่งออก';
    $Self->{Translation}->{'Import and export object information.'} = 'การนำเข้าหรือส่งออกข้อมูลออบเจกต์';
    $Self->{Translation}->{'Import/Export'} = 'การนำเข้า/ส่งออก';


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
