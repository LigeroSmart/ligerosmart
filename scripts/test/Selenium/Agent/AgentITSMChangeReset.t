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

        # Get change reset menu module default config.
        my %ChangeResetMenu = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'ITSMChange::Frontend::MenuModule###110-ChangeReset',
            Default => 1,
        );

        $Helper->ConfigSettingChange(
            Key   => 'ITSMChange::Frontend::MenuModule###110-ChangeReset',
            Value => $ChangeResetMenu{EffectiveValue},
            Valid => 1,
        );

        # Get AgemtITSMChangeReset frontend module sysconfig.
        my %ChangeResetFrontendUpdate = (
            'Description' => 'Reset a change and its workorders',
            'GroupRo'     => [
                'itsm-change-builder'
            ],
            'NavBarName' => 'ITSM Change',
            'Title'      => 'Reset',
        );

        # Set AgemtITSMChangeReset frontend module on valid.
        $Helper->ConfigSettingChange(
            Key   => 'Frontend::Module###AgentITSMChangeReset',
            Value => \%ChangeResetFrontendUpdate,
            Valid => 1,
        );

        my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');

        # Get change state data.
        my @ChangeStateIDs;
        for my $ChangeState (qw(requested approved)) {
            my $ChangeStateDataRef = $GeneralCatalogObject->ItemGet(
                Class => 'ITSM::ChangeManagement::Change::State',
                Name  => $ChangeState,
            );
            push @ChangeStateIDs, $ChangeStateDataRef->{ItemID};
        }

        my $ChangeObject = $Kernel::OM->Get('Kernel::System::ITSMChange');

        # Create test change.
        my $ChangeTitleRandom = 'ITSMChange Approved ' . $Helper->GetRandomID();
        my $ChangeID          = $ChangeObject->ChangeAdd(
            ChangeTitle   => $ChangeTitleRandom,
            Description   => "Test Description",
            Justification => "Test Justification",
            ChangeStateID => $ChangeStateIDs[1],
            UserID        => 1,
        );
        $Self->True(
            $ChangeID,
            "$ChangeTitleRandom is created",
        );

        # Get work order state data.
        my @WorkOrderStateIDs;
        for my $WorkOrderState (qw(created accepted)) {
            my $WorkOrderStateDataRef = $GeneralCatalogObject->ItemGet(
                Class => 'ITSM::ChangeManagement::WorkOrder::State',
                Name  => $WorkOrderState,
            );
            push @WorkOrderStateIDs, $WorkOrderStateDataRef->{ItemID};
        }

        my $WorkOrderObject = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder');

        # Create test work order.
        my $WorkOrderTitleRandom = 'Selenium Work Order ' . $Helper->GetRandomID();
        my $WorkOrderID          = $WorkOrderObject->WorkOrderAdd(
            ChangeID         => $ChangeID,
            WorkOrderTitle   => $WorkOrderTitleRandom,
            Instruction      => 'Selenium Test Work Order',
            WorkOrderStateID => $WorkOrderStateIDs[1],
            PlannedStartTime => '2027-10-12 00:00:01',
            PlannedEndTime   => '2027-10-15 15:00:00',
            PlannedEffort    => 10,
            UserID           => 1,
        );
        $Self->True(
            $ChangeID,
            "$WorkOrderTitleRandom is created",
        );

        # Create and log in test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-builder', 'itsm-change-manager' ]
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentITSMChangeZoom of created test change.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMChangeZoom;ChangeID=$ChangeID");

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('a[href*=\"Action=AgentITSMChangeReset;ChangeID=$ChangeID\"]').length;"
        );

        # Click on 'Reset'.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMChangeReset;ChangeID=$ChangeID')]")->click();

        # Wait for confirm button to show up and confirm reset action.
        $Selenium->WaitFor( JavaScript => "return \$('.Dialog button.Primary.CallForAction:visible').length;" );
        $Selenium->find_element( ".Dialog button.Primary.CallForAction", 'css' )->VerifiedClick();

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('a[href*=\"Action=AgentITSMChangeReset;ChangeID=$ChangeID\"]').length;"
        );

        # Navigate to AgentITSMChangeHistory of created test change.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMChangeHistory;ChangeID=$ChangeID");

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length;' );

        # Verify that change state is reseted.
        my $WorkOrderResetMessage
            = "(ID=$WorkOrderID) Workorder State: (new=Created (ID=$WorkOrderStateIDs[0]), old=Accepted (ID=$WorkOrderStateIDs[1]))";
        my $ChangeResetMessage
            = "Change State: (new=Requested (ID=$ChangeStateIDs[0]), old=Approved (ID=$ChangeStateIDs[1]))";
        $Self->True(
            index( $Selenium->get_page_source(), $WorkOrderResetMessage ) > -1,
            "$WorkOrderResetMessage is found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $ChangeResetMessage ) > -1,
            "$ChangeResetMessage is found",
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
