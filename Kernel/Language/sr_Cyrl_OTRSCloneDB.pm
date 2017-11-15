# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::sr_Cyrl_OTRSCloneDB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'List of tables should be skipped, perhaps internal DB tables. Please use lowercase.'} =
        'Листа табела које треба прескочити, вероватно интерне табеле базе података. Молимо користите мала слова.';
    $Self->{Translation}->{'Log file for replacement of malformed UTF-8 data values.'} = 'Датотека дневника за замене неисправно формираних UTF-8 вредности података.';
    $Self->{Translation}->{'Settings for connecting with the target database.'} = 'Поставке за повезивање са циљном базом података.';
    $Self->{Translation}->{'Specifies which columns should be checked for valid UTF-8 source data.'} =
        'Одређује које колоне треба проверити за исправни UTF-8 извор података.';
    $Self->{Translation}->{'This setting specifies which table columns contain blob data as these need special treatment.'} =
        'Ова поставка одређује које колоне у табелама садрже „blob” податке јер њих треба посебно третитати.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
