# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $CommandObject
    = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::SystemMonitoring::NagiosCheckTicketCount');

my $ConfigFile = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/Config/NagiosCheck.pm.example';

my $ExitCode = $CommandObject->Execute( '--config-file', $ConfigFile, '--aschecker', );

$Self->Is(
    $ExitCode,
    0,
    "Maint::SystemMonitoring::NagiosCheckTicketCount exit code",
);

1;
