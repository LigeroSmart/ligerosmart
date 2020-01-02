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

use List::Util qw();
use vars qw($Self);
use var::packagesetup::FAQ;

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my $FAQObject       = $Kernel::OM->Get('Kernel::System::FAQ');

my $RandomGroup = $Helper->GetRandomID();

my @Tests = (
    {
        Name      => 'Restore permissions of AgentFAQLanguage frontend module',
        Settings  => ['Frontend::Module###AgentFAQLanguage'],
        OldConfig => {
            'Frontend::Module' => {
                'AgentFAQLanguage' => {
                    'Description' => 'FAQ Area.',
                    'Group'       => [
                        $RandomGroup,
                    ],
                    'NavBar' => [
                        {
                            'AccessKey'   => 'L',
                            'Block'       => '',
                            'Description' => 'Language Management',
                            'Group'       => [
                                $RandomGroup,
                            ],
                            'Link'   => 'Action=AgentFAQLanguage',
                            'Name'   => 'Language Management',
                            'NavBar' => 'FAQ',
                            'Prio'   => '940',
                            'Type'   => ''
                        }
                    ],
                },
            },
        },
    },

    {
        Name      => 'Restore permissions of AgentFAQAdd frontend module',
        Settings  => ['Frontend::Module###AgentFAQAdd'],
        OldConfig => {
            'Frontend::Module' => {
                'AgentFAQAdd' => {
                    'Description' => 'FAQ Area.',
                    'Group'       => [],
                    'NavBar'      => [
                        {
                            'AccessKey'   => 'A',
                            'Block'       => '',
                            'Description' => 'New FAQ Article',
                            'Group'       => [
                                'faq',
                            ],
                            'Link'   => 'Action=AgentFAQLanguage',
                            'Name'   => 'New',
                            'NavBar' => 'FAQ',
                            'Prio'   => '920',
                            'Type'   => ''
                        }
                    ],
                },
            },
        },
    },

    {
        Name      => 'Restore value of FAQ::ApprovalGroup',
        Settings  => ['FAQ::ApprovalGroup'],
        OldConfig => {
            'FAQ::ApprovalGroup' => $RandomGroup,
        },
    },

    {
        Name        => 'Restore permissions of Frontend::Module###AgentFAQExplorer to the old defaults',
        Settings    => ['Frontend::Module###AgentFAQExplorer'],
        OldConfig   => {},
        OldDefaults => {
            'Frontend::Module' => {
                'AgentFAQExplorer' => {
                    Group   => ['faq'],
                    GroupRo => ['faq'],
                    NavBar  => [
                        {
                            Name    => 'FAQ',
                            'Block' => 'ItemArea',
                            GroupRo => ['faq']
                        },
                        {
                            Name    => 'Explorer',
                            'Block' => '',
                            GroupRo => ['faq']
                        },
                    ],
                },
            },
        },
        Config => {
            'DashboardBackend###0398-FAQ-LastChange' => { Group => $RandomGroup },
        },
    },
);

my $GetConfig = sub {
    my $Source      = shift;
    my $SettingName = shift;

    my $Config = $Source;
    my @Keys   = split '###', $SettingName;
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

TEST:
for my $Test (@Tests) {

    # If the key 'Config' exists, lets set the new config before we do anything else.
    if ( $Test->{Config} ) {
        for my $Key ( sort keys %{ $Test->{Config} } ) {
            $Helper->ConfigSettingChange(
                Key   => $Key,
                Value => $Test->{Config}->{$Key},
            );
        }
    }

    # Check if it was restored to the old config.
    my $OldConfig = $Test->{OldConfig};
    local *var::packagesetup::FAQ::_GetOTRS5ConfigBackup = sub {    ## no critic
        return $OldConfig;
    };

    var::packagesetup::FAQ->new()->CodeUpgradeFromLowerThan_5_0_92();

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
                $Test->{Name},
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

            # Get the old navigation.
            my $OldNavigation = $SettingOldConfig->{NavBar} // $SettingOldDefaults->{NavBar};

            # Get the current navigation.
            my $NewNavigation
                = $GetConfig->( $Kernel::OM->Get('Kernel::Config'), 'Frontend::Navigation###' . $Frontend );

            # Check if the permission is the same as the old one.
            for my $Index ( sort keys %{$NewNavigation} ) {
                my $NewItems = $NewNavigation->{$Index};
                for my $NewItem ( @{$NewItems} ) {
                    my $OldItem
                        = List::Util::first { $_->{Name} eq $NewItem->{Name} && $_->{Block} eq $NewItem->{Block} }
                    @{$OldNavigation};
                    next NEW_ITEM if !$OldItem;

                    $CheckGroupGroupRo->(
                        Expected => $OldItem,
                        Result   => $NewItem,
                        TestName => sprintf(
                            $Test->{Name} . ' (Navigation %s)',
                            $NewItem->{Name},
                            $NewItem->{Block} ? '-' . $NewItem->{Block} : '',
                        ),
                    );
                }
            }
        }
    }
}

# Restore default setting values after testing, since overrides are deployed from external code.
my @Settings = (
    'Frontend::Module###AgentFAQExplorer',
    'Frontend::Module###AgentFAQLanguage',
    'Frontend::Module###AgentFAQEdit',
    'Frontend::Module###AgentFAQAdd',
    'Frontend::Module###AgentFAQCategory',
    'Frontend::Module###AgentFAQSearch',
    'Frontend::Module###AgentFAQSearchSmall',
    'Frontend::Module###AgentFAQZoom',
    'Frontend::Module###AgentFAQRichText',
    'Frontend::Module###AgentFAQPrint',
    'Frontend::Module###AgentFAQJournal',
    'Frontend::Module###AgentFAQHistory',
    'Frontend::Module###AgentFAQDelete',
    'DashboardBackend###0398-FAQ-LastChange',
    'DashboardBackend###0399-FAQ-LastCreate',
    'FAQ::ApprovalGroup',
    'Frontend::Navigation###AgentFAQExplorer###002-FAQ',
    'Frontend::Navigation###AgentFAQAdd###002-FAQ',
    'Frontend::Navigation###AgentFAQLanguage###002-FAQ',
    'Frontend::Navigation###AgentFAQCategory###002-FAQ',
    'Frontend::Navigation###AgentFAQSearch###002-FAQ',
    'Frontend::Navigation###AgentFAQJournal###002-FAQ',
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
        "Reset $SettingName",
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
