# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_TW_OTRSCloneDB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'List of tables should be skipped, perhaps internal DB tables. Please use lowercase.'} =
        '列表內的資料表應該略過，可能是內部DB的資料表。請使用小寫。';
    $Self->{Translation}->{'Log file for replacement of malformed UTF-8 data values.'} = '用於替換格式錯誤的UTF-8資料的Log文件。';
    $Self->{Translation}->{'Settings for connecting with the target database.'} = '資料庫連線設定。';
    $Self->{Translation}->{'Specifies which columns should be checked for valid UTF-8 source data.'} =
        '指定哪些列應該檢查來源為UTF-8的資料';
    $Self->{Translation}->{'This setting specifies which table columns contain blob data as these need special treatment.'} =
        '此設定指定表格列的blob資料需要特殊處理。';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
