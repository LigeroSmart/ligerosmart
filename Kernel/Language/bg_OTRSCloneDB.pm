# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::bg_OTRSCloneDB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'List of tables should be skipped, perhaps internal DB tables. Please use lowercase.'} =
        'Списъкът на таблиците трябва да бъде пропуснат, може би вътрешни DB таблици. Моля, използвайте малки букви.';
    $Self->{Translation}->{'Log file for replacement of malformed UTF-8 data values.'} = 'Лог файл за замяна на неправилни стойности на данни в UTF-8.';
    $Self->{Translation}->{'Settings for connecting with the target database.'} = 'Настройки за свързване с базата данни.';
    $Self->{Translation}->{'Specifies which columns should be checked for valid UTF-8 source data.'} =
        'Указва кои колони трябва да бъдат проверени за валидни UTF-8 изходни данни.';
    $Self->{Translation}->{'This setting specifies which table columns contain blob data as these need special treatment.'} =
        'Тази настройка указва кои колони в таблицата съдържат данни за блокове, тъй като те изискват специално използване.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
