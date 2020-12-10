package Kernel::Config::Files::ZZZZZDisableOTRSBusinessWarnings;
use strict;
use warnings;
no warnings 'redefine';
use utf8;
use Kernel::System::VariableCheck qw(:all);

sub Load {
    my ($File, $Self) = @_;
    delete $Self->{"Frontend::NotifyModule"}->{"8000-PackageManager-CheckNotVerifiedPackages"};
}

1;