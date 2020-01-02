# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Get work order empty agent default config.
        my %WorkOrderEmptyAgent = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'ITSMWorkOrder::TakePermission###10-EmptyAgent',
            Default => 1,
        );

        $Helper->ConfigSettingChange(
            Key   => 'ITSMWorkOrder::TakePermission###10-EmptyAgent',
            Value => $WorkOrderEmptyAgent{EffectiveValue},
            Valid => 1,
        );

        # Get work order list agent default sysconfig.
        my %WorkOrderListAgent = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'ITSMWorkOrder::TakePermission###20-ListAgent',
            Default => 1,
        );

        $Helper->ConfigSettingChange(
            Key   => 'ITSMWorkOrder::TakePermission###20-ListAgent',
            Value => $WorkOrderListAgent{EffectiveValue},
            Valid => 1,
        );

        # Get change state data.
        my $ChangeStateDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Change::State',
            Name  => 'requested',
        );

        my $ChangeObject = $Kernel::OM->Get('Kernel::System::ITSMChange');

        # Create test change.
        my $ChangeTitleRandom = 'ITSMChange Requested ' . $Helper->GetRandomID();
        my $ChangeID          = $ChangeObject->ChangeAdd(
            ChangeTitle   => $ChangeTitleRandom,
            Description   => 'Selenium Test Description',
            Justification => 'Seleniun Test Justification',
            ChangeStateID => $ChangeStateDataRef->{ItemID},
            UserID        => 1,
        );
        $Self->True(
            $ChangeID,
            "$ChangeTitleRandom is created",
        );

        my $WorkOrderObject = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder');

        # Create test work order.
        my $WorkOrderTitleRandom = 'Selenium Work Order ' . $Helper->GetRandomID();
        my $WorkOrderID          = $WorkOrderObject->WorkOrderAdd(
            ChangeID       => $ChangeID,
            WorkOrderTitle => $WorkOrderTitleRandom,
            Instruction    => 'Selenium Test Work Order',
            PlannedEffort  => 10,
            UserID         => 1,
        );
        $Self->True(
            $ChangeID,
            "$WorkOrderTitleRandom is created",
        );

        # Create and log in test user.
        my $Language      = 'en';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'admin', 'itsm-change', 'itsm-change-builder', 'itsm-change-manager' ],
            Language => $Language,
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentITSMWorkOrderZoom for test created work order.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMWorkOrderZoom;WorkOrderID=$WorkOrderID");

        # Click on 'Take Workorder'.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMWorkOrderTake;WorkOrderID=$WorkOrderID')]")
            ->click();

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#DialogButton1',
        );
        $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

        # Navigate to AgentITSMWorkOrderHistory for test created work order.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMWorkOrderHistory;WorkOrderID=$WorkOrderID");

        # Check for take work order history message.
        my $WorkOrderAgent               = $LanguageObject->Translate('WorkOrderAgent');
        my $ExpectedTakeWorkOrderMessage = "$WorkOrderAgent: (new=$TestUserLogin";

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('td:contains(\"$ExpectedTakeWorkOrderMessage\")').length;"
        );

        $Self->True(
            $Selenium->execute_script("return \$('td:contains(\"$ExpectedTakeWorkOrderMessage\")').length;"),
            "'$ExpectedTakeWorkOrderMessage' is found",
        );

        # Delete test created work order.
        my $Success = $WorkOrderObject->WorkOrderDelete(
            WorkOrderID => $WorkOrderID,
            UserID      => 1,
        );
        $Self->True(
            $Success,
            "$WorkOrderTitleRandom is deleted",
        );

        # Delete test created change.
        $Success = $ChangeObject->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "$ChangeTitleRandom is deleted",
        );

        # Make sure cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'ITSMChange*' );
    }
);

1;
