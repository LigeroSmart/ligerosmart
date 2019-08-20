# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

# Create local function for wait on AJAX update.
my $WaitForAJAX = sub {
    $Selenium->WaitFor(
        JavaScript =>
            'return typeof($) === "function" && !$("span.AJAXLoader:visible").length;'
    );
};

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Enable the advanced MasterSlave.
        $Helper->ConfigSettingChange(
            Key   => 'MasterSlave::AdvancedEnabled',
            Value => 1,
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Do not check service and type.
        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Service',
            Value => 0
        );
        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Type',
            Value => 0,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Do not send emails.
        $Helper->ConfigSettingChange(
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Test',
        );

        # Add test customer for testing.
        my $TestCustomerLoginPhone = $Helper->TestCustomerUserCreate();

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketPhone screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Dest").length;'
        );

        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");

        # Wait for AJAX to finish.
        $WaitForAJAX->();

        my $MasterTicketSubject = "Master Ticket";
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys($TestCustomerLoginPhone);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length;' );

        $Selenium->execute_script(
            "\$('li.ui-menu-item:nth-child(1) a').trigger('click');",
        );

        # Wait for AJAX to finish.
        $WaitForAJAX->();

        $Selenium->find_element( "#Subject",  'css' )->send_keys($MasterTicketSubject);
        $Selenium->find_element( "#RichText", 'css' )->send_keys('Selenium body test');
        $Selenium->execute_script(
            "\$('#DynamicField_MasterSlave').val('Master').trigger('redraw.InputField').trigger('change');"
        );

        # Wait for AJAX to finish.
        $WaitForAJAX->();

        $Selenium->execute_script(
            "\$('#submitRichText')[0].scrollIntoView(true);",
        );
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Get master test phone ticket data.
        my ( $MasterTicketID, $MasterTicketNumber ) = $TicketObject->TicketSearch(
            Result            => 'HASH',
            Limit             => 1,
            CustomerUserLogin => $TestCustomerLoginPhone,
            UserID            => 1,
        );

        $Self->True(
            $MasterTicketID,
            "Master TicketID - $MasterTicketID",
        );
        $Self->True(
            $MasterTicketNumber,
            "Master TicketNumber - $MasterTicketNumber",
        );

        # Add new test customer for testing.
        my $TestCustomerLoginsEmail = $Helper->TestCustomerUserCreate();

        # Navigate to AgentTicketEmail screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketEmail");

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Dest").length;'
        );

        # Create slave test email ticket.
        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");

        # Wait for AJAX to finish.
        $WaitForAJAX->();

        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys($TestCustomerLoginsEmail);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length;' );
        $Selenium->execute_script(
            "\$('li.ui-menu-item:nth-child(1) a').trigger('click');",
        );

        # Wait for AJAX to finish.
        $WaitForAJAX->();

        $Selenium->find_element( "#Subject",  'css' )->send_keys('Slave Ticket');
        $Selenium->find_element( "#RichText", 'css' )->send_keys('Selenium body test');
        $Selenium->execute_script(
            "\$('#DynamicField_MasterSlave').val('SlaveOf:$MasterTicketNumber').trigger('redraw.InputField').trigger('change');"
        );

        # Wait for AJAX to finish.
        $WaitForAJAX->();

        $Selenium->execute_script(
            "\$('#submitRichText')[0].scrollIntoView(true);",
        );
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # get slave test email ticket data
        my ( $SlaveTicketID, $SlaveTicketNumber ) = $TicketObject->TicketSearch(
            Result            => 'HASH',
            Limit             => 1,
            CustomerUserLogin => $TestCustomerLoginsEmail,
            UserID            => 1,
        );

        $Self->True(
            $SlaveTicketID,
            "Slave TicketID - $SlaveTicketID",
        );
        $Self->True(
            $SlaveTicketNumber,
            "Slave TicketNumber - $SlaveTicketNumber",
        );

        # Navigate to ticket zoom page of created master test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$MasterTicketID");

        # Verify master-slave ticket link.
        $Self->True(
            index( $Selenium->get_page_source(), $SlaveTicketNumber ) > -1,
            "Slave ticket number: $SlaveTicketNumber - found",
        );

        # Navigate to history view of created master test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$MasterTicketID");

        # Verify dynamic field master ticket update.
        $Self->True(
            index( $Selenium->get_page_source(), 'Changed dynamic field MasterSlave from "" to "Master".' ) > -1,
            "Master dynamic field update value - found",
        );

        # Navigate to ticket zoom page of created slave test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$SlaveTicketID");

        # Verify slave-master ticket link
        $Self->True(
            index( $Selenium->get_page_source(), $MasterTicketNumber ) > -1,
            "Master ticket number: $MasterTicketNumber - found",
        );

        # Navigate to history view of created slave test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$SlaveTicketID");

        # Verify dynamic field slave ticket update.
        $Self->True(
            index( $Selenium->get_page_source(), 'Changed dynamic field MasterSlave from "" to "SlaveOf:' ) > -1,
            "Slave dynamic field update value - found",
        );

        # Delete created test tickets.
        for my $TicketID ( $MasterTicketID, $SlaveTicketID ) {
            my $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
            $Self->True(
                $Success,
                "Ticket ID $TicketID - deleted"
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
