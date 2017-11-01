# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;

use vars qw($Self);

use var::packagesetup::TimeAccounting;

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomGroup = $Helper->GetRandomID();

my @Tests = (
    {
        Name      => 'Restore permissions of AgentTimeAccountingEdit frontend module',
        Settings  => ['Frontend::Module###AgentTimeAccountingEdit'],
        OldConfig => {
            'Frontend::Module' => {
                'AgentTimeAccountingEdit' => {
                    'Description' => 'Time accounting edit.',
                    'Group'       => [
                        $RandomGroup,
                    ],
                    'GroupRo' => [
                        $RandomGroup,
                    ],
                    'NavBar' => [
                        {
                            'AccessKey'   => '',
                            'Block'       => 'ItemArea',
                            'Description' => 'Time accounting.',
                            'Link'        => 'Action=AgentTimeAccountingEdit',
                            'Name'        => 'Time Accounting',
                            'NavBar'      => 'TimeAccounting',
                            'Prio'        => '6000',
                            'Type'        => 'Menu'
                        },
                        {
                            'AccessKey'   => '',
                            'Block'       => '',
                            'Description' => 'Edit time record.',
                            'GroupRo'     => [
                                $RandomGroup,
                            ],
                            'Link'   => 'Action=AgentTimeAccountingEdit',
                            'Name'   => 'Edit',
                            'NavBar' => 'TimeAccounting',
                            'Prio'   => '200',
                            'Type'   => ''
                        },
                    ],
                },
            },
        },
    },

    {
        Name        => 'Restore permissions of Frontend::Module###AgentTimeAccountingView to the old defaults',
        Settings    => ['Frontend::Module###AgentTimeAccountingView'],
        OldConfig   => {},
        OldDefaults => {
            'Frontend::Module' => {
                'AgentTimeAccountingView' => {
                    Group   => ['time_accounting'],
                    GroupRo => ['time_accounting'],
                },
            },
        },
        Config => {},
    },
);

my $GetConfig = sub {
    my $Source      = shift;
    my $SettingName = shift;

    my $Config = $Source;
    my @Keys = split '###', $SettingName;
    while ( my $Key = shift @Keys ) {
        $Config = $Config->{$Key};
    }

    return $Config;
};

my $CheckGroupGroupRo = sub {
    my %Param    = @_;
    my $Expected = $Param{Expected};
    my $Result   = $Param{Result};
    my $TestName = $Param{TestName};

    if ( $Expected->{Group} || $Expected->{GroupRo} ) {

        # Check for Key Group and GroupRo.
        for my $Key (qw(Group GroupRo)) {
            $Self->IsDeeply(
                $Result->{$Key},
                $Expected->{$Key} // [],
                $TestName . ", '${ Key }' fixed!"
            );
        }
    }
};

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

TEST:
for my $Test (@Tests) {

    # If the key 'Config' exists, lets set the new config before do anything else
    if ( $Test->{Config} ) {
        for my $Key ( sort keys %{ $Test->{Config} } ) {
            $Helper->ConfigSettingChange(
                Key   => $Key,
                Value => $Test->{Config}->{$Key},
            );
        }
    }

    # Check if it was restored to the old config
    my $OldConfig = $Test->{OldConfig};
    local *var::packagesetup::TimeAccounting::_GetOTRS5ConfigBackup = sub {    ## no critic
        return $OldConfig;
    };
    var::packagesetup::TimeAccounting->new()->CodeUpgradeFromLowerThan_5_0_92();

    # Check if the new config is according to the old one.
    my @Settings = @{ $Test->{Settings} };
    SETTING_NAME:
    for my $SettingName (@Settings) {
        my $SettingOldConfig   = $GetConfig->( $OldConfig,           $SettingName );
        my $SettingOldDefaults = $GetConfig->( $Test->{OldDefaults}, $SettingName );
        my %Config             = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );
        my $EffectiveValue = $Config{EffectiveValue};

        # It's not a complex value, check only if the value was restored.
        if ( !( ref $EffectiveValue ) ) {
            $Self->Is(
                $EffectiveValue,
                $SettingOldConfig // $SettingOldDefaults,
                $Test->{Name}
            );

            next SETTING_NAME;
        }

        $CheckGroupGroupRo->(
            Expected => $SettingOldConfig // $SettingOldDefaults,
            Result   => $EffectiveValue,
            TestName => $Test->{Name},
        );

        if ( $SettingOldConfig->{NavBar} || $SettingOldDefaults->{NavBar} ) {

            # Check for navigation permissions.
            my ( undef, $Frontend ) = split '###', $SettingName;

            # First, get all the navigation items.
            my $NavBar     = $SettingOldConfig->{NavBar} // $SettingOldDefaults->{NavBar};
            my %Navigation = ();
            my $Index      = 0;
            ITEM:
            for my $Item ( @{$NavBar} ) {
                $Index += 1;
                my %NavigationConfig
                    = $SysConfigObject->SettingGet( Name => "Frontend::Navigation###${ Frontend }###${ Index }" );
                next ITEM if !%NavigationConfig;

                my $EffectiveValue = $NavigationConfig{EffectiveValue};
                my $Key = $EffectiveValue->{Name} . '-' . $EffectiveValue->{Block} || '';
                $Navigation{$Key} = $EffectiveValue;
            }

            # Check permission of the naviagation items.
            for my $Item ( @{$NavBar} ) {
                my $Key = $Item->{Name} . '-' . $Item->{Block};
                my $NavigationConfig = $Navigation{$Key} || {};

                $CheckGroupGroupRo->(
                    Expected => $Item,
                    Result   => $NavigationConfig,
                    TestName => sprintf(
                        $Test->{Name} . ' (Navigation %s)',
                        $Item->{Name},
                        $Item->{Block} ? '-' . $Item->{Block} : '',
                    ),
                );
            }
        }
    }
}

# Restore default setting values after testing, since overrides are deployed from external code.
my @Settings = (
    'Frontend::Module###AgentTimeAccountingEdit',
    'Frontend::Module###AgentTimeAccountingOverview',
    'Frontend::Module###AgentTimeAccountingSetting',
    'Frontend::Module###AgentTimeAccountingReporting',
    'Frontend::Module###AgentTimeAccountingView',
    'Frontend::Navigation###AgentTimeAccountingEdit###1',
    'Frontend::Navigation###AgentTimeAccountingEdit###2',
    'Frontend::Navigation###AgentTimeAccountingOverview###1',
    'Frontend::Navigation###AgentTimeAccountingSetting###1',
    'Frontend::Navigation###AgentTimeAccountingReporting###1',
);

for my $SettingName (@Settings) {
    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        Name   => $SettingName,
        UserID => 1,
    );
    $Self->True(
        $ExclusiveLockGUID,
        "Locked $SettingName"
    );

    my $Success = $SysConfigObject->SettingReset(
        Name              => $SettingName,
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );
    $Self->True(
        $Success,
        "Reset $SettingName"
    );
}

my $Success = $SysConfigObject->ConfigurationDeploy(
    Comments      => 'UpgradeLowerThan5092.t',
    UserID        => 1,
    Force         => 1,
    DirtySettings => \@Settings,
);
$Self->True(
    $Success,
    'Restored default configuration'
);

1;
