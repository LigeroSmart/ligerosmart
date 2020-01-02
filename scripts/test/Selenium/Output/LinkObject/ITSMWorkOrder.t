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
        my $TicketObject    = $Kernel::OM->Get('Kernel::System::Ticket');

        # Get change state data.
        my $ChangeStateDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Change::State',
            Name  => 'requested',
        );

        # Create test change.
        my $ChangeTitleRandom = 'ITSMChange Requested ' . $Helper->GetRandomID();
        my $ChangeID          = $ChangeObject->ChangeAdd(
            ChangeTitle   => $ChangeTitleRandom,
            Description   => 'Selenium Test Description',
            Justification => 'Selenium Test Justification',
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

        # Create test ticket.
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => 'Selenium Test Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => 'Test Selenium Customer',
            CustomerUser => 'Test Selenium Customer',
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket ID $TicketID is created",
        );

        # Create and log in test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', 'itsm-change', 'itsm-change-builder', 'itsm-change-manager' ]
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentITSMWorkOrderZoom of created test work order.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMWorkOrderZoom;WorkOrderID=$WorkOrderID");

        # Click on 'Link' and switch screens.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentLinkObject;SourceObject=ITSMWorkOrder' )]")
            ->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#SubmitSearch").length;' );
        sleep 2;

        # Select test created ticket to link with test created work order.
        $Selenium->execute_script(
            "\$('#TargetIdentifier').val('Ticket').trigger('redraw.InputField').trigger('change');"
        );
        sleep 2;
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' &&  \$('input[name*=TicketNumber').length;"
        );

        $Selenium->find_element("//input[\@name='SEARCH::TicketNumber']")->send_keys($TicketNumber);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->click();
        $Selenium->WaitFor( JavaScript => "return \$('input#LinkTargetKeys').length;" );
        sleep 1;

        $Selenium->find_element( "#LinkTargetKeys", 'css' )->click();
        $Selenium->find_element( "#AddLinks",       'css' )->VerifiedClick();
        sleep 1;
        $Selenium->find_element( "#LinkAddCloseLink", 'css' )->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        $Selenium->VerifiedRefresh();

        # Verify test work order is linked with test ticket.
        sleep 1;
        $Self->Is(
            $Selenium->execute_script('return $(".LinkObjectLink").text();'),
            $TicketNumber,
            "Test ticket number $TicketNumber is found",
        );

        # Click on 'Link' and switch screens.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentLinkObject;SourceObject=ITSMWorkOrder' )]")
            ->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#SubmitSearch").length;' );

        # Delete link relation.
        $Selenium->find_element("//a[\@href='#ManageLinks']")->click();
        $Selenium->execute_script('$("#LinkDeleteIdentifier").click();');
        sleep 1;
        $Selenium->execute_script('$("button[title=\'Delete links\']").click();');

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('.MessageBox.Info p').length;" );
        $Self->Is(
            $Selenium->execute_script('return $(".MessageBox.Info p").text().trim();'),
            "1 Link(s) deleted successfully.",
            "Check if link is deleted successfully",
        );

        $Selenium->close();
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Verify that link has been removed.
        $Selenium->VerifiedRefresh();
        $Self->False(
            $Selenium->execute_script('return $(".LinkObjectLink").text();'),
            "Test ticket number $TicketNumber is found",
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

        # Delete test created ticket.
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket ID $TicketID is deleted",
        );

        # Make sure cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'ITSMChange*' );
    }
);

1;
