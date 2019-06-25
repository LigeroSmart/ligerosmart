# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::nb_NO_OTRSCloneDB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'List of tables should be skipped, perhaps internal DB tables. Please use lowercase.'} =
        '';
    $Self->{Translation}->{'Log file for replacement of malformed UTF-8 data values.'} = '';
    $Self->{Translation}->{'Settings for connecting with the target database.'} = '';
    $Self->{Translation}->{'Specifies which columns should be checked for valid UTF-8 source data.'} =
        '';
    $Self->{Translation}->{'This setting specifies which table columns contain blob data as these need special treatment.'} =
        '';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
