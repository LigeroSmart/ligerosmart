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
use var::packagesetup::LinkedTicketsCount;

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

my $ZZZAAuto = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/Config/Files/ZZZAAuto.pm';
my $Before   = File::stat::stat($ZZZAAuto);
sleep 2;

# get command object
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Config::Rebuild');
my $ExitCode      = $CommandObject->Execute();

var::packagesetup::LinkedTicketsCount->new()->CodeInstall();

# Restore default setting values after testing, since overrides are deployed from external code.
my @Settings = (
    'Ticket::EventModulePost###041-TicketLinkCount',
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
    Comments      => 'ReinstallLinkedTicketsCount.t',
    UserID        => 1,
    Force         => 1,
    DirtySettings => \@Settings, #scripts/test/FAQ/ReinstallLinkedTicketsCount.t
);
$Self->True(
    $Success,
    'Restored default configuration'
);

1;