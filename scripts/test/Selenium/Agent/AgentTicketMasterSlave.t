# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

        # enable change the MasterSlave state of a ticket
        $Helper->ConfigSettingChange(
            Key   => 'MasterSlave::UpdateMasterSlave',
            Value => 1,
        );

        # do not check RichText
        $Helper->ConfigSettingChange(
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # do not send emails
        $Helper->ConfigSettingChange(
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Test',
        );

        # Make sure InvovedAgent and InformAgent are disabled, otherwise it uses part of the visible
        # screen making the submit button not visible and then not click-able
        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Frontend::AgentTicketMasterSlave###InvolvedAgent',
            Value => 0,
        );
        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Frontend::AgentTicketMasterSlave###InformAgent',
            Value => 0,
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

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create two test tickets
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

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to ticket zoom page of first created test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[0]");

        # click on MasterSlave and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketMasterSlave;TicketID=$TicketIDs[0]' )]")
            ->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # open collapsed widgets, if necessary
        $Selenium->execute_script(
            "\$('.WidgetSimple.Collapsed .WidgetAction > a').trigger('click');"
        );

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple.Expanded").length;'
        );

        # check page
        for my $ID (
            qw(DynamicField_MasterSlave Subject RichText FileUpload IsVisibleForCustomer submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # set first test ticket as master ticket
        $Selenium->execute_script(
            "\$('#DynamicField_MasterSlave').val('Master').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( "#RichText",       'css' )->send_keys('Selenium Master Ticket');
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # switch window back to agent ticket zoom view of the first created test ticket
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # expand Miscellaneous dropdown menu
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#nav-Miscellaneous ul").css({ "height": "auto", "opacity": "100" });'
        );

        # click on 'History' and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketHistory;TicketID=$TicketIDs[0]' )]")
            ->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # verify dynamic field master ticket update
        $Self->True(
            index( $Selenium->get_page_source(), 'Changed dynamic field MasterSlave from "" to "Master".' ) > -1,
            "Master dynamic field update value - found",
        );

        # close history window
        $Selenium->find_element( ".CancelClosePopup", 'css' )->click();

        # switch window back to agent ticket zoom view of the first created test ticket
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # navigate to ticket zoom page of second created test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[1]");

        # click on MasterSlave and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketMasterSlave;TicketID=$TicketIDs[1]' )]")
            ->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until form has loaded, if necessary
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#DynamicField_MasterSlave').length"
        );

        $Selenium->execute_script(
            "\$('#DynamicField_MasterSlave').val('SlaveOf:$TicketNumbers[0]').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( "#RichText",       'css' )->send_keys('Selenium Slave Ticket');
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        $Selenium->switch_to_window( $Handles->[0] );
        $Selenium->WaitFor( WindowCount => 1 );

        # expand Miscellaneous dropdown menu
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#nav-Miscellaneous ul").css({ "height": "auto", "opacity": "100" });'
        );

        # click on 'History' and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketHistory;TicketID=$TicketIDs[1]' )]")
            ->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # verify dynamic field slave ticket update
        $Self->True(
            index(
                $Selenium->get_page_source(),
                'Changed dynamic field MasterSlave from "" to "SlaveOf:' . $TicketNumbers[0]
                ) > -1,
            "Slave dynamic field update value - found",
        );

        # close history window
        $Selenium->find_element( ".CancelClosePopup", 'css' )->click();

        # switch window back to agent ticket zoom view of the first created test ticket
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # delete created test tickets
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

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
