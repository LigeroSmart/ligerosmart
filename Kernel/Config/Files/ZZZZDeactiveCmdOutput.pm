package Kernel::Config::Files::ZZZZDeactiveCmdOutput;
use strict;
use warnings;
no warnings 'redefine';

sub Load {
    my ($File, $Self) = @_;
    delete $Self->{"DashboardBackend"}->{"0420-CmdOutput"};
}

1;
