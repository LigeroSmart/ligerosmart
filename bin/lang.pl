#!/usr/bin/perl
# Usage: export UserLanguage=en;/opt/otrs/bin/otrs.Console.pl Maint::Cache::Delete --allow-root; /opt/otrs/bin/lang.pl 
use strict;
use warnings;
use Data::Dumper;
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Kernel::System::ObjectManager;

local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.Console.pl',
    },
);

print "\n";

    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

    for (qw(1 2 3 4 )){
        print "\n\n getting $_ \n\n\n";
        my %ServiceData = $ServiceObject->ServiceGet(
            ServiceID => $_,
            UserID    => 1,
        );
            
    }

    my %ServiceList = $ServiceObject->ServiceList(
        Valid  => 1,   # (optional) default 1 (0|1)
        UserID => 1,
    );

    print Dumper(%ServiceList);

print "\n";
print "\n";