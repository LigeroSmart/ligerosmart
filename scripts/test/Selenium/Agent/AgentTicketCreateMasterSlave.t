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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable the advanced MasterSlave
        $Helper->ConfigSettingChange(
            Key   => 'MasterSlave::AdvancedEnabled',
            Value => 1,
        );

        # do not check RichText
        $Helper->ConfigSettingChange(
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # do not check service and type
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

        # do not send emails
        $Helper->ConfigSettingChange(
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Test',
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # add test customer for testing
        my $TestCustomerLoginPhone = $Helper->TestCustomerUserCreate();

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentTicketPhone screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        my $MasterTicketSubject = "Master Ticket";
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys($TestCustomerLoginPhone);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );

        $Selenium->execute_script(
            "\$('li.ui-menu-item:nth-child(1) a').trigger('click')",
        );

        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject",  'css' )->send_keys($MasterTicketSubject);
        $Selenium->find_element( "#RichText", 'css' )->send_keys('Selenium body test');
        $Selenium->execute_script(
            "\$('#DynamicField_MasterSlave').val('Master').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # get master test phone ticket data
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

        # add new test customer for testing
        my $TestCustomerLoginsEmail = $Helper->TestCustomerUserCreate();

        # navigate to AgentTicketEmail screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketEmail");

        # create slave test email ticket
        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys($TestCustomerLoginsEmail);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script(
            "\$('li.ui-menu-item:nth-child(1) a').trigger('click')",
        );
        $Selenium->find_element( "#Subject",  'css' )->send_keys('Slave Ticket');
        $Selenium->find_element( "#RichText", 'css' )->send_keys('Selenium body test');
        $Selenium->execute_script(
            "\$('#DynamicField_MasterSlave').val('SlaveOf:$MasterTicketNumber').trigger('redraw.InputField').trigger('change');"
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

        # navigate to ticket zoom page of created master test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$MasterTicketID");

        # verify master-slave ticket link
        $Self->True(
            index( $Selenium->get_page_source(), $SlaveTicketNumber ) > -1,
            "Slave ticket number: $SlaveTicketNumber - found",
        );

        # navigate to history view of created master test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$MasterTicketID");

        # verify dynamic field master ticket update
        $Self->True(
            index( $Selenium->get_page_source(), 'Changed dynamic field MasterSlave from "" to "Master".' ) > -1,
            "Master dynamic field update value - found",
        );

        # navigate to ticket zoom page of created slave test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$SlaveTicketID");

        # verify slave-master ticket link
        $Self->True(
            index( $Selenium->get_page_source(), $MasterTicketNumber ) > -1,
            "Master ticket number: $MasterTicketNumber - found",
        );

        # navigate to history view of created slave test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$SlaveTicketID");

        # verify dynamic field slave ticket update
        $Self->True(
            index( $Selenium->get_page_source(), 'Changed dynamic field MasterSlave from "" to "SlaveOf:' ) > -1,
            "Slave dynamic field update value - found",
        );

        # delete created test tickets
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

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
