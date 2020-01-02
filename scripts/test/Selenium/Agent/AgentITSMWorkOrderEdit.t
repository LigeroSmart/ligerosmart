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

        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ChangeObject    = $Kernel::OM->Get('Kernel::System::ITSMChange');
        my $WorkOrderObject = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder');

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Get change state data.
        my $ChangeStateDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Change::State',
            Name  => 'requested',
        );

        # Create test change.
        my $ChangeTitleRandom = 'ITSMChange Requested ' . $Helper->GetRandomID();
        my $ChangeID          = $ChangeObject->ChangeAdd(
            ChangeTitle   => $ChangeTitleRandom,
            Description   => "Test Description",
            Justification => "Test Justification",
            ChangeStateID => $ChangeStateDataRef->{ItemID},
            UserID        => 1,
        );
        $Self->True(
            $ChangeID,
            "$ChangeTitleRandom is created",
        );

        # Create test work order.
        my $WorkOrderTitleRandom = 'Selenium Work Order ' . $Helper->GetRandomID();
        my $WorkOrderInstruction = 'Selenium Test Work Order';
        my $WorkOrderID          = $WorkOrderObject->WorkOrderAdd(
            ChangeID       => $ChangeID,
            WorkOrderTitle => $WorkOrderTitleRandom,
            Instruction    => $WorkOrderInstruction,
            PlannedEffort  => 10,
            UserID         => 1,
        );
        $Self->True(
            $ChangeID,
            "$WorkOrderTitleRandom is created",
        );

        # Create and log in test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-manager' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentITSMWorkOrderEdit for test created work order.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMWorkOrderEdit;WorkOrderID=$WorkOrderID");

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#WorkOrderTitle").length;' );

        # Check stored values.
        $Self->Is(
            $Selenium->find_element( '#WorkOrderTitle', 'css' )->get_value(),
            $WorkOrderTitleRandom,
            "#WorkOrderTitle stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#RichText', 'css' )->get_value(),
            $WorkOrderInstruction,
            "#Instruction stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#PlannedEffort', 'css' )->get_value(),
            '10.00',
            "#PlannedEffort stored value",
        );

        # Edit work order and submit.
        $Selenium->find_element( "#WorkOrderTitle",      'css' )->send_keys(" Edit");
        $Selenium->find_element( "#RichText",            'css' )->send_keys(" Edit");
        $Selenium->find_element( "#PlannedEffort",       'css' )->clear();
        $Selenium->find_element( "#PlannedEffort",       'css' )->send_keys("11.00");
        $Selenium->find_element( "#SubmitWorkOrderEdit", 'css' )->VerifiedClick();

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length;' );

        # Navigate to AgentITSMWorkOrderEdit for test created work order.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMWorkOrderEdit;WorkOrderID=$WorkOrderID");

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#WorkOrderTitle").length;' );

        # Check edited values.
        $Self->Is(
            $Selenium->find_element( '#WorkOrderTitle', 'css' )->get_value(),
            $WorkOrderTitleRandom . ' Edit',
            "#WorkOrderTitle edited value",
        );
        $Self->Is(
            $Selenium->find_element( '#RichText', 'css' )->get_value(),
            $WorkOrderInstruction . ' Edit',
            "#Instruction edited value",
        );
        $Self->Is(
            $Selenium->find_element( '#PlannedEffort', 'css' )->get_value(),
            '11.00',
            "#PlannedEffort edited value",
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
