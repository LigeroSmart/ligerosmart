# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# $origin: https://github.com/OTRS/otrs/blob/6f9a6349dda49b071e87dcf0ff2c2c199c2b2ec4/scripts/test/Console/Command/Admin/Service/Add.t
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Service::Add');

my ( $Result, $ExitCode );

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ParentServiceName = "ParentService" . $Helper->GetRandomID();
my $ChildServiceName  = "ChildService" . $Helper->GetRandomID();

# try to execute command without any options
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# provide minimum options
# ---
# ITSM
# ---
#$ExitCode = $CommandObject->Execute( '--name', $ParentServiceName );
$ExitCode = $CommandObject->Execute( '--name', $ParentServiceName, '--criticality', '3 normal', '--type', 'Demonstration' );
# ---
$Self->Is(
    $ExitCode,
    0,
    "Minimum options ( the service is added - $ParentServiceName )",
);

# same again (should fail because already exists)
# ---
# ITSM
# ---
#$ExitCode = $CommandObject->Execute( '--name', $ParentServiceName );
$ExitCode = $CommandObject->Execute( '--name', $ParentServiceName, '--criticality', '3 normal', '--type', 'Demonstration' );
# ---
$Self->Is(
    $ExitCode,
    1,
    "Minimum options ( service $ParentServiceName already exists )",
);

# invalid parent
# ---
# ITSM
# ---
#$ExitCode = $CommandObject->Execute( '--name', $ChildServiceName, '--parent-name', $ChildServiceName );
$ExitCode = $CommandObject->Execute( '--name', $ChildServiceName, '--parent-name', $ChildServiceName, '--criticality', '3 normal', '--type', 'Demonstration' );
# ---
$Self->Is(
    $ExitCode,
    1,
    "Parent service $ChildServiceName does not exist",
);

# valid parent
# ---
# ITSM
# ---
#$ExitCode = $CommandObject->Execute( '--name', $ChildServiceName, '--parent-name', $ParentServiceName );
$ExitCode = $CommandObject->Execute( '--name', $ChildServiceName, '--parent-name', $ParentServiceName, '--criticality', '3 normal', '--type', 'Demonstration' );
# ---
$Self->Is(
    $ExitCode,
    0,
    "Existing parent ( service is added - $ChildServiceName )",
);

# cleanup is done by RestoreDatabase

1;
