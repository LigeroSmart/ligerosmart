# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get change state data
        my $ChangeDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Change::State',
            Name  => 'requested',
        );

        # get change object
        my $ChangeObject = $Kernel::OM->Get('Kernel::System::ITSMChange');

        # create test change
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
            "$ChangeTitleRandom - created",
        );

        # get work order object
        my $WorkOrderObject = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder');

        # create test work order
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
            "$WorkOrderTitleRandom - created",
        );

        # create and log in test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-manager' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentITSMChangeZoom for test created change
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentITSMChangeZoom;ChangeID=$ChangeID");

        # click on 'Move Time Slot' and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMChangeTimeSlot;ChangeID=$ChangeID')]")->click();

        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # check page
        for my $ID (
            qw(MoveTimeType MoveTimeMonth MoveTimeDay MoveTimeYear MoveTimeHour MoveTimeMinute SubmitMoveTimeSlot)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # submit default selected value
        $Selenium->find_element( "#SubmitMoveTimeSlot", 'css' )->click();
        $Selenium->switch_to_window( $Handles->[0] );

        # click on 'History' and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMChangeHistory;ChangeID=$ChangeID')]")->click();

        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # verify move time slot change
        my $ExpectedStartMessage
            = "(ID=\"$WorkOrderID\", \"Planned Start\", \"2010-10-12 00:00:00\", \"2009-10-12 00:00:01)";
        my $ExpectedEndMessage
            = "(ID=\"$WorkOrderID\", \"Planned End\", \"2010-10-15 14:59:59\", \"2009-10-15 15:00:00)";
        $Self->True(
            index( $Selenium->get_page_source(), $ExpectedStartMessage ) > -1,
            "$ExpectedStartMessage - found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $ExpectedEndMessage ) > -1,
            "$ExpectedEndMessage - found",
        );

        # delete test created work order
        my $Success = $WorkOrderObject->WorkOrderDelete(
            WorkOrderID => $WorkOrderID,
            UserID      => 1,
        );
        $Self->True(
            $Success,
            "$WorkOrderTitleRandom - deleted",
        );

        # delete created test change
        $Success = $ChangeObject->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "$ChangeTitleRandom - deleted",
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'ITSMChange*' );
        }

);

1;
