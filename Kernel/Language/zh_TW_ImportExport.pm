# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::zh_TW_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = '導入/導出管理';
    $Self->{Translation}->{'Create a template to import and export object information.'} = '創建模板導入和導出對象信息。';
    $Self->{Translation}->{'Start Import'} = '開始導入';
    $Self->{Translation}->{'Start Export'} = '開始導出';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = '';
    $Self->{Translation}->{'Name is required!'} = '名稱是必需的！';
    $Self->{Translation}->{'Object is required!'} = '對象是必需的！';
    $Self->{Translation}->{'Format is required!'} = '格式是必需的';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = '';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = '';
    $Self->{Translation}->{'is required!'} = '必需的';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = '';
    $Self->{Translation}->{'No map elements found.'} = '沒有找到映射的字段';
    $Self->{Translation}->{'Add Mapping Element'} = '添加映射字段';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = '';
    $Self->{Translation}->{'Restrict export per search'} = '限制導出每個搜尋';
    $Self->{Translation}->{'Import information'} = '導入信息';
    $Self->{Translation}->{'Source File'} = '源文件';
    $Self->{Translation}->{'Import summary for %s'} = '';
    $Self->{Translation}->{'Records'} = '紀錄';
    $Self->{Translation}->{'Success'} = '成功';
    $Self->{Translation}->{'Duplicate names'} = '重複的名稱';
    $Self->{Translation}->{'Last processed line number of import file'} = '導入文件最後處理的行數';
    $Self->{Translation}->{'Ok'} = 'Ok';

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
    $Self->{Translation}->{'Column Separator'} = '列分隔符';
    $Self->{Translation}->{'Tabulator (TAB)'} = '制表鍵 (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = '分號 (;)';
    $Self->{Translation}->{'Colon (:)'} = '冒號 (:)';
    $Self->{Translation}->{'Dot (.)'} = '句號 (.)';
    $Self->{Translation}->{'Comma (,)'} = '';
    $Self->{Translation}->{'Charset'} = '字符集';
    $Self->{Translation}->{'Include Column Headers'} = '包括列標題';
    $Self->{Translation}->{'Column'} = '列';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        '';
    $Self->{Translation}->{'Import and export object information.'} = '導入和導出對象信息';
    $Self->{Translation}->{'Import/Export'} = '導入/導出';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
