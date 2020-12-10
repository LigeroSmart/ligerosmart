# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::vi_VN_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Quản lý Nhập/Xuất';
    $Self->{Translation}->{'Add template'} = '';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Tạo một mẫu để nhập và xuất thông tin đối tượng.';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        '';
    $Self->{Translation}->{'Start Import'} = 'Bắt đầu nhập vào';
    $Self->{Translation}->{'Start Export'} = 'Bắt đầu xuất ra';
    $Self->{Translation}->{'Delete this template'} = '';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = '';
    $Self->{Translation}->{'Name is required!'} = 'Yêu cầu phải có tên!';
    $Self->{Translation}->{'Object is required!'} = 'Yêu cầu phải có đối tượng!';
    $Self->{Translation}->{'Format is required!'} = 'Yêu cầu phải có định dạng!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = '';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = '';
    $Self->{Translation}->{'is required!'} = 'là bắt buộc!';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = '';
    $Self->{Translation}->{'No map elements found.'} = 'Không tìm thấy đối tượng map.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Thêm đối tượng mapping';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = '';
    $Self->{Translation}->{'Restrict export per search'} = 'Giới hạn dữ liệu xuất mỗi lần tìm kiếm';
    $Self->{Translation}->{'Import information'} = 'Thông tin nhập vào';
    $Self->{Translation}->{'Source File'} = 'Tệp nguồn';
    $Self->{Translation}->{'Import summary for %s'} = '';
    $Self->{Translation}->{'Records'} = 'Bản ghi';
    $Self->{Translation}->{'Success'} = 'Thành công';
    $Self->{Translation}->{'Duplicate names'} = 'Trùng tên';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Dòng cuối cùng được xử lý trong tệp nhập vào';
    $Self->{Translation}->{'Ok'} = 'Đồng ý';
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
    $Self->{Translation}->{'Column Separator'} = 'Phân cách cột';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Bộ lập bảng (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Dấu chấm phẩy (;)';
    $Self->{Translation}->{'Colon (:)'} = 'Dấu hai chấm (:)';
    $Self->{Translation}->{'Dot (.)'} = 'Dấu chấm (.)';
    $Self->{Translation}->{'Comma (,)'} = '';
    $Self->{Translation}->{'Charset'} = 'Bộ mã ký tự';
    $Self->{Translation}->{'Include Column Headers'} = 'Gồm tiêu đề cột';
    $Self->{Translation}->{'Column'} = 'Cột';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = '';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        '';
    $Self->{Translation}->{'Template was deleted successfully.'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Đăng ký mô-đun định dạng nền cho mô-đun nhập/xuất';
    $Self->{Translation}->{'Import and export object information.'} = 'Thông tin nhập và xuất đối tượng.';
    $Self->{Translation}->{'Import/Export'} = 'Nhập/Xuất';


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
