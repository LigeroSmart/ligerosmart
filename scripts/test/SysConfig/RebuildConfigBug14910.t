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

use Kernel::System::VariableCheck qw( IsHashRefWithData );

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $ConfigurationDeploy = sub {
    my %Param = @_;

    # Remove remains of previous runs to ensure proper testing.
    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::System::SysConfig'],
    );
    delete $INC{'Kernel/Config/Files/ZZZAAuto.pm'};

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my $ConfigurationXML2DBOk = $SysConfigObject->ConfigurationXML2DB(
        UserID  => 1,
        Force   => 1,
        CleanUp => 1,
    );
    $Self->True(
        $ConfigurationXML2DBOk,
        'Succcessfully converted configuration',
    );

    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments    => "Configuration Rebuild",
        AllSettings => 1,
        UserID      => 1,
        Force       => 1,
    );
    $Self->Is(
        $DeploymentResult{Success} ? 1 : 0,
        $Param{Success},
        $Param{Success} ? 'Succcessfully deployed configuration' : 'Unsuccessful configuration deployment',
    );
};

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Create file whose existence will be validated.
my $TestFileLocation = $ConfigObject->Get('Home') . '/var/tmp/UnitTest' . $HelperObject->GetRandomNumber();
my $TestFileContent  = 'UnitTest';
my $TestFileWriteOk  = $MainObject->FileWrite(
    Location => $TestFileLocation,
    Content  => \$TestFileContent,
);
$Self->True(
    $TestFileWriteOk,
    'Succcessfully wrote test file',
);

# Prepare two new file-type config settings.
my $ValidSettingXML = <<EOF,
<?xml version="1.0" encoding="utf-8" ?>
<otrs_config version="2.0" init="Framework">
    <Setting Name="Test1" Required="1" Valid="1">
        <Description Translatable="1">Test 1.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="File">$TestFileLocation</Item>
        </Value>
    </Setting>
    <Setting Name="Test2" Required="1" Valid="1">
        <Description Translatable="1">Test 2.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="File">$TestFileLocation</Item>
        </Value>
    </Setting>
</otrs_config>
EOF

    my $ConfigFileLocation
    = $ConfigObject->Get('Home') . '/Kernel/Config/Files/XML/UnitTest' . $HelperObject->GetRandomNumber() . '.xml';
my $ConfigFileWriteOk = $MainObject->FileWrite(
    Location => $ConfigFileLocation,
    Content  => \$ValidSettingXML,
);
$Self->True(
    $ConfigFileWriteOk,
    'Succcessfully wrote configuration file',
);

# Verify successful deployment.
$ConfigurationDeploy->( Success => 1 );

# Remove file and verify failed deployment.
my $TestFileDeleteOk = $MainObject->FileDelete(
    Location => $TestFileLocation,
);
$Self->True(
    $TestFileDeleteOk,
    'Succcessfully removed test file',
);

$ConfigurationDeploy->( Success => 0 );

# Add override file with correct configuration (implicitly by using helper object).
$HelperObject->ConfigSettingChange(
    Valid => 1,
    Key   => 'Test1',
    Value => $ConfigObject->Get('Home') . '/Kernel/System/UnitTest/Helper.pm',    # This should always exist.
);
$HelperObject->ConfigSettingChange(
    Valid => 1,
    Key   => 'Test2',
    Value => $ConfigObject->Get('Home') . '/Kernel/System/UnitTest/Helper.pm',    # This should always exist.
);

# Discard SysConfig object to ensure clean state. Then delete ZZZAAuto.pm to force regeneration.
my $ZZZAAutoFileDeleteOk = $MainObject->FileDelete(
    Location => $ConfigObject->Get('Home') . '/Kernel/Config/Files/ZZZAAuto.pm',
);
$Self->True(
    $ZZZAAutoFileDeleteOk,
    'Succcessfully removed ZZZAAuto.pm',
);

# During the next deployment there will be two requests to OverriddenFileNameGet().
# The first one takes the current database state as no ZZZAAuto.pm exists, the second one uses the cached values.
$ConfigurationDeploy->( Success => 1 );

# Run deployment again.
# Now the first request to OverriddenFileNameGet() will use ZZZAAuto.pm (which was regenerated by previous deployment)
#   and the second one the cached values.
$ConfigurationDeploy->( Success => 1 );

# Cleanup config file, deploy and verify result.
my $ConfigFileDeleteOk = $MainObject->FileDelete(
    Location => $ConfigFileLocation,
);
$Self->True(
    $ConfigFileDeleteOk,
    'Succcessfully removed configuration file',
);

$ConfigurationDeploy->( Success => 1 );

1;
