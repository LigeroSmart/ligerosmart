# --
# Kernel/Language/zh_CN_ImportExport.pm - translation file
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_ImportExport;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = '增加映射模版';
    $Self->{Translation}->{'Charset'} = '字符集';
    $Self->{Translation}->{'Colon (:)'} = '冒号 (:)';
    $Self->{Translation}->{'Column'} = '列';
    $Self->{Translation}->{'Column Separator'} = '列分隔符';
    $Self->{Translation}->{'Dot (.)'} = '句号 (.)';
    $Self->{Translation}->{'Semicolon (;)'} = '分号 (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = '制表键 (TAB)';
    $Self->{Translation}->{'Include Column Headers'} = '';
    $Self->{Translation}->{'Import summary for'} = '';
    $Self->{Translation}->{'Imported records'} = '';
    $Self->{Translation}->{'Exported records'} = '';
    $Self->{Translation}->{'Records'} = '';
    $Self->{Translation}->{'Skipped'} = '';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = '导入/导出管理';
    $Self->{Translation}->{'Create a template to import and export object information.'} = '';
    $Self->{Translation}->{'Start Import'} = '开始导入';
    $Self->{Translation}->{'Start Export'} = '开始导出';
    $Self->{Translation}->{'Delete Template'} = '';
    $Self->{Translation}->{'Step'} = '步骤';
    $Self->{Translation}->{'Edit common information'} = '编辑共用信息';
    $Self->{Translation}->{'Name is required!'} = '';
    $Self->{Translation}->{'Object is required!'} = '';
    $Self->{Translation}->{'Format is required!'} = '';
    $Self->{Translation}->{'Edit object information'} = '编辑对像信息';
    $Self->{Translation}->{'Edit format information'} = '编辑格式信息';
    $Self->{Translation}->{' is required!'} = '';
    $Self->{Translation}->{'Edit mapping information'} = '编辑映射信息';
    $Self->{Translation}->{'No map elements found.'} = '';
    $Self->{Translation}->{'Add Mapping Element'} = '';
    $Self->{Translation}->{'Edit search information'} = '编辑搜索信息';
    $Self->{Translation}->{'Restrict export per search'} = '限制导出每个搜寻';
    $Self->{Translation}->{'Import information'} = '导入信息';
    $Self->{Translation}->{'Source File'} = '源文件';
    $Self->{Translation}->{'Success'} = '';
    $Self->{Translation}->{'Failed'} = '';
    $Self->{Translation}->{'Duplicate names'} = '';
    $Self->{Translation}->{'Last processed line number of import file'} = '';
    $Self->{Translation}->{'Ok'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        '';
    $Self->{Translation}->{'Import and export object information.'} = '';
    $Self->{Translation}->{'Import/Export'} = '导入/导出';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
