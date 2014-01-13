# --
# Kernel/Language/zh_TW_ImportExport.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# Copyright (C) 2013 Michael Shi <micshi at 163.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_TW_ImportExport;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = '增加映射模版';
    $Self->{Translation}->{'Charset'} = '字符集';
    $Self->{Translation}->{'Colon (:)'} = '冒號 (:)';
    $Self->{Translation}->{'Column'} = '列';
    $Self->{Translation}->{'Comma (,)'} = '逗號(,)';
    $Self->{Translation}->{'Column Separator'} = '列分隔符';
    $Self->{Translation}->{'Dot (.)'} = '句號 (.)';
    $Self->{Translation}->{'Semicolon (;)'} = '分號 (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = '制表鍵 (TAB)';
    $Self->{Translation}->{'Include Column Headers'} = '包括列標題';
    $Self->{Translation}->{'Import summary for'} = '導入總結';
    $Self->{Translation}->{'Imported records'} = '導入紀錄';
    $Self->{Translation}->{'Exported records'} = '導出紀錄';
    $Self->{Translation}->{'Records'} = '紀錄';
    $Self->{Translation}->{'Skipped'} = '跳過的';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = '導入/導出管理';
    $Self->{Translation}->{'Create a template to import and export object information.'} = '創建模板導入和導出對象信息。';
    $Self->{Translation}->{'Start Import'} = '開始導入';
    $Self->{Translation}->{'Start Export'} = '開始導出';
    $Self->{Translation}->{'Delete Template'} = '删除模板';
    $Self->{Translation}->{'Step'} = '步驟';
    $Self->{Translation}->{'Edit common information'} = '編輯共用信息';
    $Self->{Translation}->{'The name is required!'} = '名稱是必需的！';
    $Self->{Translation}->{'Object is required!'} = '對象是必需的！';
    $Self->{Translation}->{'Format is required!'} = '格式是必需的';
    $Self->{Translation}->{'Edit object information'} = '編輯對象信息';
    $Self->{Translation}->{'Edit format information'} = '編輯格式信息';
    $Self->{Translation}->{' is required!'} = '是必需的!';
    $Self->{Translation}->{'Edit mapping information'} = '編輯映射信息';
    $Self->{Translation}->{'No map elements found.'} = '沒有找到映射的字段';
    $Self->{Translation}->{'Add Mapping Element'} = '添加映射字段';
    $Self->{Translation}->{'Edit search information'} = '編輯搜索信息';
    $Self->{Translation}->{'Restrict export per search'} = '限制導出每個搜尋';
    $Self->{Translation}->{'Import information'} = '導入信息';
    $Self->{Translation}->{'Source File'} = '源文件';
    $Self->{Translation}->{'Success'} = '成功';
    $Self->{Translation}->{'Failed'} = '失敗';
    $Self->{Translation}->{'Duplicate names'} = '重複的名稱';
    $Self->{Translation}->{'Last processed line number of import file'} = '導入文件最後處理的行數';
    $Self->{Translation}->{'Ok'} = '';
    $Self->{Translation}->{'Template List'} = '模板列表';
    $Self->{Translation}->{'Empty fields indicate that the current values are kept'} = '空字段表示保持當前的值';
    $Self->{Translation}->{'Column Separator is required!'} = '必须指定列分隔符!';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        '';
    $Self->{Translation}->{'Import and export object information.'} = '導入和導出對象信息';
    $Self->{Translation}->{'Import/Export'} = '導入/導出';


    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
