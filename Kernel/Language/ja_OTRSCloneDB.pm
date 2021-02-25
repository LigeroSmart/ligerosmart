# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ja_OTRSCloneDB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'List of tables should be skipped, perhaps internal DB tables. Please use lowercase.'} =
        'テーブルのリストはスキップする必要があります。おそらく内部DBテーブルです。 小文字を使用してください。';
    $Self->{Translation}->{'Log file for replacement of malformed UTF-8 data values.'} = '不正なUTF-8形式データの値を置換するためのログファイル';
    $Self->{Translation}->{'Settings for connecting with the target database.'} = 'ターゲットデータベースに接続するための設定。';
    $Self->{Translation}->{'Specifies which columns should be checked for valid UTF-8 source data.'} =
        '有効なUTF-8形式のソースデータを検証するためのスペックファイル';
    $Self->{Translation}->{'This setting specifies which table columns contain blob data as these need special treatment.'} =
        'この設定は、特別な処理が必要なBLOBデータを含む表の列を指定します。';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
