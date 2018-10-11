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

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create and log in test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-service' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test tickets.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => "Selenium Test Ticket",
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => "SeleniumCustomer\@localhost.com",
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('a[href*=\"Action=AgentTicketDecision;TicketID=$TicketID\"]').length;"
        );
        sleep 1;

        # Click 'Decision' and switch window.
        $Selenium->find_element("//a[contains(\@href, 'Action=AgentTicketDecision;TicketID=$TicketID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#DynamicField_ITSMDecisionResult").length;'
        );

        # Check screen.
        for my $ID (
            qw( Result DateUsed DateMonth DateDay DateYear DateHour DateMinute )
            )
        {
            my $Element = $Selenium->find_element( "#DynamicField_ITSMDecision$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Change decision result and date.
        $Selenium->execute_script(
            "\$('#DynamicField_ITSMDecisionResult').val('Rejected').trigger('redraw.InputField').trigger('change');"
        );
        sleep 1;
        $Selenium->find_element( "#DynamicField_ITSMDecisionDateUsed", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return $("#DynamicField_ITSMDecisionDateUsed").prop("checked") === true;' );

        $Selenium->find_element("//button[\@type='submit']")->click();

        # Switch back to zoom view.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        $Selenium->VerifiedRefresh();

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script(
            '$("#nav-Miscellaneous ul").css({ "height": "auto", "opacity": "100" });'
        );
        $Selenium->WaitFor(
            JavaScript =>
                'return $("#nav-Miscellaneous ul").css("opacity") == 1;'
        );

        # Click on 'History' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketHistory;TicketID=$TicketID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length;' );

        # Check for decision TicketDynamicFieldUpdates.
        for my $UpdateText (qw(Result Date)) {
            $Self->True(
                index( $Selenium->get_page_source(), "Changed dynamic field ITSMDecision$UpdateText" ) > -1,
                "DynamicFieldUpdate decision $UpdateText - found",
            );
        }

        # Delete created test tickets.
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );
        $Self->True(
            $Success,
            "Ticket is deleted - ID $TicketID"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
