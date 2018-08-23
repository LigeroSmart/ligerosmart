# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');
        my $ChangeObject         = $Kernel::OM->Get('Kernel::System::ITSMChange');
        my $WorkOrderObject      = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder');

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Get change state data.
        my $ChangeStateDataRef = $GeneralCatalogObject->ItemGet(
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
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-manager' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentITSMWorkOrderZoom for test created work order.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMWorkOrderZoom;WorkOrderID=$WorkOrderID");

        # Get work order states.
        my @WorkOrderStates = ( 'accepted', 'ready', 'in progress', 'closed' );

        for my $WorkOrderState (@WorkOrderStates) {

            # Click on 'Report' and switch window.
            $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentITSMWorkOrderReport;WorkOrderID=$WorkOrderID')]"
            )->click();

            $Selenium->WaitFor( WindowCount => 2 );
            my $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            # Wait until page has loaded, if necessary.
            $Selenium->WaitFor(
                JavaScript => 'return typeof($) === "function" && $("#SubmitWorkOrderEditReport").length;'
            );

            # Get work order state data.
            my $ItemGetState          = lc $WorkOrderState;
            my $WorkOrderStateDataRef = $GeneralCatalogObject->ItemGet(
                Class => 'ITSM::ChangeManagement::WorkOrder::State',
                Name  => $ItemGetState,
            );

            # Input text in report and select next work order state.
            $Selenium->find_element( "#RichText", 'css' )->clear();
            $Selenium->find_element( "#RichText", 'css' )->send_keys("$WorkOrderState");
            $Selenium->execute_script(
                "\$('#WorkOrderStateID').val('$WorkOrderStateDataRef->{ItemID}').trigger('redraw.InputField').trigger('change');"
            );

            # Submit and switch back window.
            $Selenium->find_element( "#SubmitWorkOrderEditReport", 'css' )->click();

            $Selenium->WaitFor( WindowCount => 1 );
            $Selenium->switch_to_window( $Handles->[0] );

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('a[href*=\"Action=AgentITSMWorkOrderHistory;WorkOrderID=$WorkOrderID\"]').length"
            );

            # Click on 'History' and switch window.
            $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentITSMWorkOrderHistory;WorkOrderID=$WorkOrderID')]"
            )->click();

            $Selenium->WaitFor( WindowCount => 2 );
            $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            # Wait until page has loaded, if necessary.
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length;' );

            # Verify report change.
            my $ReportUpdateMessage
                = "WorkOrderState: (new=$WorkOrderState (ID=$WorkOrderStateDataRef->{ItemID}), old=";
            $Self->True(
                index( $Selenium->get_page_source(), $ReportUpdateMessage ) > -1,
                "$ReportUpdateMessage is found",
            );

            # Close history pop up and switch window.
            $Selenium->find_element( ".CancelClosePopup", 'css' )->click();

            $Selenium->WaitFor( WindowCount => 1 );
            $Selenium->switch_to_window( $Handles->[0] );

            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );
        }

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
