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

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
        my $ChangeObject = $Kernel::OM->Get('Kernel::System::ITSMChange');

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-manager' ],
        ) || die "Did not get test builder user";

        # Get test user ID.
        my $TestUserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test CAB user.
        my $TestUserCAB = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-manager' ],
        ) || die "Did not get test builder user";

        # Get test CAB user ID.
        my $TestUserCABID = $UserObject->UserLookup(
            UserLogin => $TestUserCAB,
        );

        # Get change state data.
        my $ChangeDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Change::State',
            Name  => 'requested',
        );

        # Create test change.
        my $ChangeTitleRandom = 'ITSMChange Requested ' . $Helper->GetRandomID();
        my $ChangeID          = $ChangeObject->ChangeAdd(
            ChangeTitle   => $ChangeTitleRandom,
            Description   => 'Selenium Test Description',
            Justification => 'Selenium Test Justification',
            ChangeStateID => $ChangeDataRef->{ItemID},
            UserID        => $TestUserID,
        );
        $Self->True(
            $ChangeID,
            "$ChangeTitleRandom is created",
        );

        # Create test customer user.
        my $TestCustomer = $Helper->TestCustomerUserCreate();

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentITSMChangeZoom screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMChangeZoom;ChangeID=$ChangeID");

        # Click on 'Involved Persons' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMChangeInvolvedPersons;ChangeID=$ChangeID')]")
            ->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#ChangeManager").length' );

        # Check page.
        for my $ID (
            qw( ChangeManager ChangeBuilder TemplateID NewCABMember )
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        for my $Button (
            qw ( AddCABMemberButton SubmitButton AddCABTemplateButton )
            )
        {
            my $Element = $Selenium->find_element("//button[\@name='$Button']");
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check client validation.
        $Selenium->find_element( "#ChangeManager", 'css' )->clear();
        $Selenium->find_element( "#SubmitButton",  'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#ChangeManager.Error").length' );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#ChangeManager').hasClass('Error')"
            ),
            '1',
            'Validation correctly detected missing input value',
        );

        # Input change manager.
        $Selenium->find_element( "#ChangeManager", 'css' )->clear();
        $Selenium->find_element( "#ChangeManager", 'css' )->send_keys($TestUserLogin);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestUserLogin)').click()");

        # Input change agent CAB.
        $Selenium->find_element( "#NewCABMember", 'css' )->clear();
        $Selenium->find_element( "#NewCABMember", 'css' )->send_keys($TestUserCAB);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestUserCAB)').click()");

        $Selenium->find_element( "#AddCABMemberButton", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#CABAgents-$TestUserCABID').length"
        );

        # Input change customer CAB.
        $Selenium->find_element( "#NewCABMember", 'css' )->clear();
        $Selenium->find_element( "#NewCABMember", 'css' )->send_keys($TestCustomer);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomer)').click()");

        $Selenium->find_element( "#AddCABMemberButton", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#CABCustomers-$TestCustomer').length"
        );

        # Search if data is in the table.
        $Self->True(
            $Selenium->execute_script(
                "return \$('table.DataTable tr td:contains($TestUserCAB)').length"
            ),
            "$TestUserCAB is found",
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('table.DataTable tr td:contains($TestCustomer)').length"
            ),
            "$TestCustomer is found",
        );

        # Test delete CAB button.
        $Selenium->find_element( "#CABAgents-$TestUserCABID", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && !\$('#CABAgents-$TestUserCABID').length"
        );

        $Self->False(
            $Selenium->execute_script(
                "return \$('table.DataTable tr td:contains($TestUserCAB)').length"
            ),
            "$TestUserCAB is not found",
        );

        # Submit.
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        # Back to previous window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMChangeHistory;ChangeID=$ChangeID");

        # Check history log to verify change involved persons.
        $Self->True(
            index( $Selenium->get_page_source(), "CABAgents: (new=$TestUserCAB" ) > -1,
            "Change in agent CAB - success",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "CABCustomers: (new=$TestCustomer" ) > -1,
            "Change in customer CAB - success",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Change Manager: (new=$TestUserLogin" ) > -1,
            "Change in manager - success",
        );

        # Delete created test change.
        my $Success = $ChangeObject->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "$ChangeTitleRandom is deleted",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'ITSMChange*' );
    }

);

1;
