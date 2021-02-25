# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

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

        # Disable Type feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0,
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

        # Make sure Note is enabled in AgentTicketMasterSlave screen.
        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Frontend::AgentTicketMasterSlave###Note',
            Value => 1,
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

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete;'
        );

        # Navigate to ticket history page of first created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketIDs[0]");

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

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete;'
        );

        # Navigate to ticket history page of first created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketIDs[1]");

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

        # Disable Note in AgentTicketMasterSlave screen and
        # check if MasterSlave dynamic field is shown in the screen (see bug#14780).
        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Frontend::AgentTicketMasterSlave###Note',
            Value => 0,
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketMasterSlave;TicketID=$TicketIDs[1]");

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#DynamicField_MasterSlave").length;'
        );

        $Self->True(
            $Selenium->execute_script('return $("#DynamicField_MasterSlave").length;'),
            "MasterSlave dynamic field is found"
        );

        # Create two more test tickets.
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
                "Ticket ID $TicketID is created.",
            );

            push @TicketIDs,     $TicketID;
            push @TicketNumbers, $TicketNumber;
        }

        # Set Master-Slave relation for test Tickets.
        my @TestCase = (
            {
                TicketID => $TicketIDs[2],
                Value    => "Master",
            },
            {
                TicketID => $TicketIDs[3],
                Value    => "SlaveOf:$TicketNumbers[2]",
            },
        );

        my $MasterSlaveDFName = $Kernel::OM->Get('Kernel::Config')->Get('MasterSlave::DynamicField') || '';
        my $DynamicField      = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
            Name => $MasterSlaveDFName,
        );
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
        my $Success;
        for my $Test (@TestCase) {
            $Success = $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicField,
                FieldID            => $DynamicField->{ID},
                ObjectID           => $Test->{TicketID},
                Value              => $Test->{Value},
                UserID             => 1,
            );
            $Self->True(
                $Success,
                "Value '$Test->{Value}' is set for TicketID $Test->{TicketID}.",
            );
        }

        # Verify Master Slave dynamic field value for Slave ticket.
        my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');
        my $Value                   = $DynamicFieldValueObject->ValueGet(
            FieldID  => $DynamicField->{ID},
            ObjectID => $TicketIDs[3],
        );
        $Self->Is(
            $Value->[0]->{ValueText},
            "SlaveOf:$TicketNumbers[2]",
            "Master Slave dynamic field value for Slave ticket"
        );

        # Verify there is Master-Slave relation between two test Tickets.
        my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');
        my $LinkList   = $LinkObject->LinkList(
            Object => 'Ticket',
            Key    => $TicketIDs[2],
            State  => 'Valid',
            UserID => 1,
        );
        $Self->True(
            IsHashRefWithData($LinkList),
            "MasterSlave link exists."
        );

        # Enable config "MasterSlave::UnsetMasterSlave".
        $Helper->ConfigSettingChange(
            Key   => 'MasterSlave::UnsetMasterSlave',
            Value => 1,
        );

        # Navigate to AgentTicketMasterSlave screen of Master Ticket.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketMasterSlave;TicketID=$TicketIDs[2]"
        );

        # UnsetMaster status of Master Ticket.
        $Selenium->execute_script(
            "\$('#DynamicField_MasterSlave').val('UnsetMaster').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element("//button[\@class='CallForAction Primary'][contains(.,'Submit')]")->VerifiedClick();

        # Make sure the cache is correct.
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        for my $Cache (qw( DynamicFieldValue LinkObject )) {
            $CacheObject->CleanUp( Type => $Cache );
        }

        # Check if link to Slave ticket is deleted. See bug#14781.
        $LinkList = $LinkObject->LinkList(
            Object => 'Ticket',
            Key    => $TicketIDs[2],
            State  => 'Valid',
            UserID => 1,
        );
        $Self->True(
            !IsHashRefWithData($LinkList),
            "MasterSlave link deleted."
        );

        # Check if Slave value for Master Slave field is deleted from Slave ticket after UnsetMaster.
        $Value = $DynamicFieldValueObject->ValueGet(
            FieldID  => $DynamicField->{ID},
            ObjectID => $TicketIDs[3],
        );

        $Self->IsDeeply(
            $Value,
            [],
            "Master Slave dynamic field value for Slave ticket"
        );

        # Check if there is MasterSlave error log during ticket creation. See bug#14899.
        my $RandomID = $Helper->GetRandomID();

        # Navigate to AgentTicketPhone and create test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#FromCustomer").length;' );

        my $TestCustomer = 'customer' . $RandomID . '@gmail.com';
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys($TestCustomer);
        $Selenium->WaitFor( JavaScript => 'return !$(".AJAXLoader:visible").length;' );

        # Lose the focus.
        $Selenium->find_element( 'body', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return $("#TicketCustomerContentFromCustomer input.CustomerTicketText").length;'
        );

        $Selenium->InputFieldValueSet(
            Element => '#Dest',
            Value   => '2||Raw',
        );
        $Selenium->WaitFor( JavaScript => 'return !$(".AJAXLoader:visible").length;' );

        $Selenium->find_element( "#Subject",  'css' )->clear();
        $Selenium->find_element( "#Subject",  'css' )->send_keys("Subject$RandomID");
        $Selenium->find_element( "#RichText", 'css' )->clear();
        $Selenium->find_element( "#RichText", 'css' )->send_keys("Text$RandomID");

        # Submit form.
        $Selenium->execute_script(
            "\$('#submitRichText')[0].scrollIntoView(true);",
        );
        $Self->True(
            $Selenium->execute_script("return \$('#submitRichText').length;"),
            "Element '#submitRichText' is found in screen"
        );
        $Selenium->find_element( '#submitRichText', 'css' )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".MessageBox a[href*=\'AgentTicketZoom;TicketID=\']").length;'
        );

        my @Ticket   = split( 'TicketID=', $Selenium->get_current_url() );
        my $TicketID = $Ticket[1];

        push @TicketIDs, $TicketID;

        # Navigate to AdminLog.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminLog");

        # Check if MasterSlave error log is created.
        my $Message = "Could not update field MasterSlave for Ticket ID $TicketID";
        $Self->True(
            $Selenium->execute_script("return \$('#LogEntries .Error:eq(0)').text().indexOf('$Message') == -1;"),
            "Error message is not created for update field MasterSlave for Ticket ID $TicketID",
        );

        # Delete created test tickets.
        for my $TicketID (@TicketIDs) {
            my $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
            $Self->True(
                $Success,
                "Ticket ID $TicketID is deleted."
            );
        }

        # Make sure the cache is correct.
        $CacheObject->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
