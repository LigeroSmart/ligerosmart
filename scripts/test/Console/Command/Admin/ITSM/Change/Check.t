# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::ITSM::Change::Check');

# check command without option
my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    0,
    "Admin::ITSM::Change::Check - No options",
);

# check command with option --force
$ExitCode = $CommandObject->Execute('--force-pid');

$Self->Is(
    $ExitCode,
    0,
    "Option '--force-pid'",
);

1;
