# --
# Kernel/Language/zh_CN_ImportExport.pm - the Chinese simple translation of ImportExport
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: zh_CN_ImportExport.pm,v 1.4 2010-09-08 18:02:53 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'}              = '导入/导出';
    $Lang->{'Import/Export Management'}   = '导入/导出管理';
    $Lang->{'Add mapping template'}       = '增加映射模版';
    $Lang->{'Start Import'}               = '开始导入';
    $Lang->{'Start Export'}               = '开始导出';
    $Lang->{'Step'}                       = '步骤';
    $Lang->{'Edit common information'}    = '编辑共用信息';
    $Lang->{'Edit object information'}    = '编辑对像信息';
    $Lang->{'Edit format information'}    = '编辑格式信息';
    $Lang->{'Edit mapping information'}   = '编辑映射信息';
    $Lang->{'Edit search information'}    = '编辑搜索信息';
    $Lang->{'Import information'}         = '导入信息';
    $Lang->{'Column'}                     = '列';
    $Lang->{'Restrict export per search'} = '限制导出每个搜寻';
    $Lang->{'Source File'}                = '源文件';
    $Lang->{'Column Separator'}           = '列分隔符';
    $Lang->{'Tabulator (TAB)'}            = '制表键 (TAB)';
    $Lang->{'Semicolon (;)'}              = '分号 (;)';
    $Lang->{'Colon (:)'}                  = '冒号 (:)';
    $Lang->{'Dot (.)'}                    = '句号 (.)';
    $Lang->{'Charset'}                    = '字符集';
# add by Never
    $Lang->{'Template'}                   = '模版';
    $Lang->{'Frontend module registration for the agent interface.'} = '';
    $Lang->{'Format backend module registration for the import/export module.'} = '';
    $Lang->{'Import and export object information.'} = '';

    return 1;
}

1;
