# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create test user.
        my $TestUserLogin = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->TestUserCreate(
            Groups => [ 'admin', 'itsm-service' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test ticket.
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
            "TicketID $TicketID is created",
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketDecision screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketDecision;TicketID=$TicketID");

        # Check screen.
        for my $ID (
            qw( Result DateUsed DateMonth DateDay DateYear DateHour DateMinute )
            )
        {
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('#DynamicField_ITSMDecision$ID').length;"
            );
            my $Element = $Selenium->find_element( "#DynamicField_ITSMDecision$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Change decision result and date.
        $Selenium->execute_script(
            "\$('#DynamicField_ITSMDecisionResult').val('Rejected').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( "#DynamicField_ITSMDecisionDateUsed", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return $("#DynamicField_ITSMDecisionDateUsed").prop("checked") === true;' );
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # Navigate to AgentTicketHistory screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length;' );

        # Check for decision TicketDynamicFieldUpdates.
        for my $UpdateText (qw(Result Date)) {
            $Self->True(
                index( $Selenium->get_page_source(), "Updated: FieldName=ITSMDecision$UpdateText" ) > -1,
                "DynamicFieldUpdate decision $UpdateText - found",
            );
        }

        # Delete test tickets.
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
        }
        $Self->True(
            $Success,
            "TicketID $TicketID is deleted"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
