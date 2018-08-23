# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;

use vars qw($Self);

my @Tests = (
    {
        Name    => 'Empty',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Wrong Day (string)',
        Config => {
            Number => 'a',
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Day (0)',
        Config => {
            Number => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Day (-1)',
        Config => {
            Number => -1,
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Day (8)',
        Config => {
            Number => 8,
        },
        Success => 0,
    },
    {
        Name   => 'Monday',
        Config => {
            Number => 1,
        },
        ExpectedResult => 'Monday',
        Success        => 1,
    },
    {
        Name   => 'Tuesday',
        Config => {
            Number => 2,
        },
        ExpectedResult => 'Tuesday',
        Success        => 1,
    },
    {
        Name   => 'Wednesday',
        Config => {
            Number => 3,
        },
        ExpectedResult => 'Wednesday',
        Success        => 1,
    },
    {
        Name   => 'Thursday',
        Config => {
            Number => 4,
        },
        ExpectedResult => 'Thursday',
        Success        => 1,
    },
    {
        Name   => 'Friday',
        Config => {
            Number => 5,
        },
        ExpectedResult => 'Friday',
        Success        => 1,
    },
    {
        Name   => 'Saturday',
        Config => {
            Number => 6,
        },
        ExpectedResult => 'Saturday',
        Success        => 1,
    },
    {
        Name   => 'Sunday',
        Config => {
            Number => 7,
        },
        ExpectedResult => 'Sunday',
        Success        => 1,
    },
);

no warnings 'once';    ## no critic
my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');
use warnings;

TEST:
for my $Test (@Tests) {
    my $DayName = $TimeAccountingObject->DayOfWeekToName( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->False(
            $DayName,
            "$Test->{Name} DayOfWeekToName() - with false",
        );
        next TEST;
    }

    $Self->Is(
        $DayName,
        $Test->{ExpectedResult},
        "$Test->{Name} DayOfWeekToName()",
    );
}

1;
