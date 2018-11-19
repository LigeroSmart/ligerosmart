# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Enable the advanced MasterSlave.
        $Helper->ConfigSettingChange(
            Key   => 'MasterSlave::AdvancedEnabled',
            Value => 1,
        );

        # Enable change the MasterSlave state of a ticket.
        $Helper->ConfigSettingChange(
            Key   => 'MasterSlave::UpdateMasterSlave',
            Value => 1,
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Do not send emails.
        $Helper->ConfigSettingChange(
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Test',
        );

        # Make sure InvovedAgent and InformAgent are disabled, otherwise it uses part of the visible
        # Screen making the submit button not visible and then not click-able.
        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Frontend::AgentTicketMasterSlave###InvolvedAgent',
            Value => 0,
        );
        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Frontend::AgentTicketMasterSlave###InformAgent',
            Value => 0,
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create two test tickets.
        my @TicketIDs;
        my @TicketNumbers;
        for my $TicketCreate ( 1 .. 2 ) {
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN           => $TicketNumber,
                Title        => 'Selenium test Ticket',
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                StateID      => 1,
                TypeID       => 1,
                CustomerID   => 'SeleniumCustomer',
                CustomerUser => 'SeleniumCustomer@localhost.com',
                OwnerID      => $TestUserID,
                UserID       => $TestUserID,
            );
            $Self->True(
                $TicketID,
                "Ticket ID $TicketID - created",
            );

            push @TicketIDs,     $TicketID;
            push @TicketNumbers, $TicketNumber;
        }

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to ticket zoom page of first created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[0]");

        # Click on MasterSlave and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketMasterSlave;TicketID=$TicketIDs[0]' )]")
            ->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # Open collapsed widgets, if necessary.
        $Selenium->execute_script(
            "\$('.WidgetSimple.Collapsed .WidgetAction > a').trigger('click');"
        );

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple.Expanded").length;'
        );

        # Check page.
        for my $ID (
            qw(DynamicField_MasterSlave Subject RichText FileUpload IsVisibleForCustomer submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Set first test ticket as master ticket.
        $Selenium->execute_script(
            "\$('#DynamicField_MasterSlave').val('Master').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( "#Subject",  'css' )->send_keys('Selenium Master Ticket');
        $Selenium->find_element( "#RichText", 'css' )->send_keys('Selenium Master Ticket');
        $Selenium->find_element("//button[\@class='CallForAction Primary'][contains(.,'Submit')]")->click();

        # Switch window back to agent ticket zoom view of the first created test ticket.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Expand Miscellaneous dropdown menu.
        $Selenium->execute_script(
            '$("#nav-Miscellaneous ul").css({ "height": "auto", "opacity": "100" });'
        );

        # Click on 'History' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketHistory;TicketID=$TicketIDs[0]' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # Verify dynamic field master ticket update.
        $Self->True(
            index( $Selenium->get_page_source(), 'Changed dynamic field MasterSlave from "" to "Master".' ) > -1,
            "Master dynamic field update value - found",
        );

        # Close history window.
        $Selenium->close();

        # Switch window back to agent ticket zoom view of the first created test ticket.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Navigate to ticket zoom page of second created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[1]");

        # Click on MasterSlave and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketMasterSlave;TicketID=$TicketIDs[1]' )]")
            ->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#submitRichText').length"
        );

        sleep 1;
        $Selenium->VerifiedRefresh();

        $Selenium->execute_script(
            "\$('#DynamicField_MasterSlave').val('SlaveOf:$TicketNumbers[0]').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( "#Subject",  'css' )->send_keys('Selenium Slave Ticket');
        $Selenium->find_element( "#RichText", 'css' )->send_keys('Selenium Slave Ticket');
        $Selenium->find_element("//button[\@class='CallForAction Primary'][contains(.,'Submit')]")->click();

        $Selenium->switch_to_window( $Handles->[0] );
        $Selenium->WaitFor( WindowCount => 1 );

        # Expand Miscellaneous dropdown menu.
        $Selenium->execute_script(
            '$("#nav-Miscellaneous ul").css({ "height": "auto", "opacity": "100" });'
        );

        # Click on 'History' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketHistory;TicketID=$TicketIDs[1]' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # Verify dynamic field slave ticket update.
        $Self->True(
            index(
                $Selenium->get_page_source(),
                'Changed dynamic field MasterSlave from "" to "SlaveOf:' . $TicketNumbers[0]
            ) > -1,
            "Slave dynamic field update value - found",
        );

        # Close history window.
        $Selenium->close();

        # Delete created test tickets.
        for my $TicketID (@TicketIDs) {
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
