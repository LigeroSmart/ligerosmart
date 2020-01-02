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

        # Get change state data.
        my $ChangeDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Change::State',
            Name  => 'requested',
        );

        my $ChangeObject = $Kernel::OM->Get('Kernel::System::ITSMChange');

        # Create test change.
        my $ChangeTitleRandom = 'ITSMChange Requested ' . $Helper->GetRandomID();
        my $ChangeID          = $ChangeObject->ChangeAdd(
            ChangeTitle   => $ChangeTitleRandom,
            Description   => 'Selenium Test Description',
            Justification => 'Selenium Test Justification',
            ChangeStateID => $ChangeDataRef->{ItemID},
            UserID        => 1,
        );
        $Self->True(
            $ChangeID,
            "$ChangeTitleRandom is created",
        );

        # Create and log in builder user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-manager' ],
        ) || die "Did not get test builder user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

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

        # Create test customer user.
        my $TestCustomerCAB = $Helper->TestCustomerUserCreate();

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
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#ChangeManager").length;' );
        sleep 2;

        # Input change manager.
        my $AutoCompleteStringManager
            = "\"$TestUserLogin $TestUserLogin\" <$TestUserLogin\@localunittest.com> ($TestUserID)";
        $Selenium->find_element( "#ChangeManager", 'css' )->send_keys($TestUserLogin);
        $Selenium->WaitFor( JavaScript => 'return $("li.ui-menu-item:visible").length;' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($AutoCompleteStringManager)').click();");

        # Input change agent CAB.
        my $AutoCompleteStringCAB = "\"$TestUserCAB $TestUserCAB\" <$TestUserCAB\@localunittest.com> ($TestUserCABID)";
        $Selenium->find_element( "#NewCABMember", 'css' )->send_keys($TestUserCAB);
        $Selenium->WaitFor( JavaScript => 'return $("li.ui-menu-item:visible").length;' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($AutoCompleteStringCAB)').click();");
        $Selenium->find_element("//button[\@type='submit'][\@name='AddCABMemberButton']")->click();

        $Selenium->WaitFor( JavaScript => 'return $("#NewTemplateButton").length;' );

        # Input change customer CAB.
        my $AutoCompleteStringCustomer
            = "\"$TestCustomerCAB $TestCustomerCAB\" <$TestCustomerCAB\@localunittest.com> ($TestCustomerCAB)";
        $Selenium->find_element( "#NewCABMember", 'css' )->send_keys($TestCustomerCAB);
        $Selenium->WaitFor( JavaScript => 'return $("li.ui-menu-item:visible").length;' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($AutoCompleteStringCustomer)').click();");
        $Selenium->find_element("//button[\@type='submit'][\@name='AddCABMemberButton']")->click();

        # Search if data is in the table.
        $Self->True(
            $Selenium->execute_script(
                "return \$('table.DataTable tr td:contains($TestUserCAB)').length;"
            ),
            "CAB autocompleted $TestUserCAB is found",
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('table.DataTable tr td:contains($TestCustomerCAB)').length;"
            ),
            "CAB autocompleted $TestCustomerCAB is found",
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
