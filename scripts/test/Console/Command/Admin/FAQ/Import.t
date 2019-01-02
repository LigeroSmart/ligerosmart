# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

# get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::FAQ::Import');

# test command without source argument
my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    1,
    "Option - without source-path argument",
);

my $SourcePath = $Kernel::OM->Get('Kernel::Config')->Get('Home') . "/scripts/test/sample/FAQ.csv";

# test command with source argument
$ExitCode = $CommandObject->Execute( '--separator', ';', '--quote', '', $SourcePath );

$Self->Is(
    $ExitCode,
    0,
    "Option - with source argument",
);

# cleanup is done by restore database

1;
