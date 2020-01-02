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

        # Get change state data.
        my $ChangeDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Change::State',
            Name  => 'requested',
        );

        my $ChangeObject = $Kernel::OM->Get('Kernel::System::ITSMChange');

        # Create test change.
        my $ChangeTitleRandom = 'ITSMChange Requested ' . $Helper->GetRandomID();
        my $ChangeID          = $ChangeObject->ChangeAdd(
            ChangeTitle   => $ChangeTitleRandom,
            Description   => 'Selenium Test Description',
            Justification => 'Selenium Test Justification',
            ChangeStateID => $ChangeDataRef->{ItemID},
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
            ChangeID         => $ChangeID,
            WorkOrderTitle   => $WorkOrderTitleRandom,
            Instruction      => 'Selenium Test Work Order',
            PlannedStartTime => '2009-10-12 00:00:01',
            PlannedEndTime   => '2009-10-15 15:00:00',
            PlannedEffort    => 10,
            UserID           => 1,
        );
        $Self->True(
            $ChangeID,
            "$WorkOrderTitleRandom is created",
        );

        # Create and log in test user.
        my $Language      = 'en';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'admin', 'itsm-change', 'itsm-change-manager' ],
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

        # Navigate to AgentITSMChangeZoom for test created change.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMChangeZoom;ChangeID=$ChangeID");

        # Click on 'Move Time Slot' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMChangeTimeSlot;ChangeID=$ChangeID')]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#MoveTimeType").length' );

        # Check page.
        for my $ID (
            qw(MoveTimeType MoveTimeMonth MoveTimeDay MoveTimeYear MoveTimeHour MoveTimeMinute SubmitMoveTimeSlot)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Submit default selected value.
        $Selenium->find_element( "#SubmitMoveTimeSlot", 'css' )->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMChangeHistory;ChangeID=$ChangeID");

        # Verify move time slot change.
        my $ExpectedStartMessage = "(ID=$WorkOrderID) "
            . $LanguageObject->Translate('PlannedStartTime')
            . ": (new=2009-10-12 00:00:01, old=)";
        my $ExpectedEndMessage
            = "(ID=$WorkOrderID) " . $LanguageObject->Translate('PlannedEndTime') . ": (new=2009-10-15 15:00:00, old=)";
        $Self->True(
            index( $Selenium->get_page_source(), $ExpectedStartMessage ) > -1,
            "$ExpectedStartMessage is found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $ExpectedEndMessage ) > -1,
            "$ExpectedEndMessage is found",
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

        # Delete created test change.
        $Success = $ChangeObject->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "$ChangeTitleRandom is deleted",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'ITSMChange*' );
    }

);

1;
