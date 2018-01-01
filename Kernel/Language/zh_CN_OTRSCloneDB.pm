# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_OTRSCloneDB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'List of tables should be skipped, perhaps internal DB tables. Please use lowercase.'} =
        '应该跳过的数据库表（可能是数据库内部表）清单，请使用小写字母。';
    $Self->{Translation}->{'Log file for replacement of malformed UTF-8 data values.'} = '记录畸形的UTF-8数据值替换情况的日志文件。';
    $Self->{Translation}->{'Settings for connecting with the target database.'} = '连接到目标数据库的设置。';
    $Self->{Translation}->{'Specifies which columns should be checked for valid UTF-8 source data.'} =
        '指定哪些列需要检查源数据是否为有效的UTF-8格式。';
    $Self->{Translation}->{'This setting specifies which table columns contain blob data as these need special treatment.'} =
        '这个设置项指定包含BLOB数据的表列名，这些列需要特殊处理。';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
