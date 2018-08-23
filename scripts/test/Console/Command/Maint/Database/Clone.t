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
use utf8;

# prevent used once warning
use Kernel::System::ObjectManager;

use vars (qw($Self));

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Database::Clone');

# check command without option
my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    1,
    "Maint::Database::Clone - No options",
);

# check command with '--dry-run' option
$ExitCode = $CommandObject->Execute('--dry-run');

$Self->Is(
    $ExitCode,
    0,
    "Maint::Database::Clone --mode dry option",
);

1;
