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

        my $Helper         = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ChangeObject   = $Kernel::OM->Get('Kernel::System::ITSMChange');
        my $TemplateObject = $Kernel::OM->Get('Kernel::System::ITSMChange::Template');
        my $UserObject     = $Kernel::OM->Get('Kernel::System::User');

        # Get change state data.
        my $ChangeStateDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Change::State',
            Name  => 'requested',
        );

        # Create test change.
        my $ChangeTitleRandom = 'ITSMChange Requested ' . $Helper->GetRandomID();
        my $ChangeID          = $ChangeObject->ChangeAdd(
            ChangeTitle   => $ChangeTitleRandom,
            Description   => "Test Description",
            Justification => "Test Justification",
            ChangeStateID => $ChangeStateDataRef->{ItemID},
            UserID        => 1,
        );
        $Self->True(
            $ChangeID,
            "$ChangeTitleRandom is created",
        );

        # Create simple change template.
        my $TemplateNameRandom = 'CAB Template ' . $Helper->GetRandomID();
        my $ChangeContent      = $TemplateObject->TemplateSerialize(
            Name         => $TemplateNameRandom,
            TemplateType => 'CAB',
            ChangeID     => $ChangeID,
            Comment      => 'Selenium Test Comment',
            ValidID      => 1,
            UserID       => 1,
        );

        # Create test template from test change.
        my $TemplateID = $TemplateObject->TemplateAdd(
            Name         => $TemplateNameRandom,
            TemplateType => 'CAB',
            ChangeID     => $ChangeID,
            Content      => $ChangeContent,
            Comment      => 'Selenium Test Comment',
            ValidID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TemplateID,
            "Change Template ID $TemplateID is created",
        );

        # Create test CAB user.
        my $TestUserCAB = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-manager' ],
        );

        # Get test CAB user ID.
        my $TestUserCABID = $UserObject->UserLookup(
            UserLogin => $TestUserCAB,
        );

        # Create test CAB customer user.
        my $TestCustomerCAB = $Helper->TestCustomerUserCreate();

        # Create and log in test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-manager' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get test user ID.
        my $TestUserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentITSMTemplateOverview screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentITSMTemplateOverview;SortBy=TemplateID;OrderBy=Down;Filter=CAB"
        );

        # Click on 'Edit Content' for test created CAB template and switch window
        $Selenium->find_element("//a[contains(\@href, \'AgentITSMTemplateEditCAB;TemplateID=$TemplateID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#NewCABMember").length;' );
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#NewCABMember',
            Event       => 'change',
        );

        # Add test created CAB user to test CAB template.
        my $AutoCompleteStringCABUser
            = "\"$TestUserCAB $TestUserCAB\" <$TestUserCAB\@localunittest.com> ($TestUserCABID)";
        $Selenium->find_element( "#NewCABMember", 'css' )->send_keys($TestUserCAB);
        $Selenium->WaitFor( JavaScript => 'return $("li.ui-menu-item:visible").length;' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($AutoCompleteStringCABUser)').click();");
        $Selenium->execute_script("\$('#BtnAddCABMember').click();");

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#CABAgents$TestUserCABID').length;"
        );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#CABAgents$TestUserCABID.DeleteCABMember",
            Event       => 'click',
        );

        # Add test created CAB customer to test CAB template.
        my $AutoCompleteStringCABCustomer
            = "\"$TestCustomerCAB $TestCustomerCAB\" <$TestCustomerCAB\@localunittest.com> ($TestCustomerCAB)";
        $Selenium->find_element( "#NewCABMember", 'css' )->send_keys($TestCustomerCAB);
        $Selenium->WaitFor( JavaScript => 'return $("li.ui-menu-item:visible").length;' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($AutoCompleteStringCABCustomer)').click();");
        $Selenium->execute_script("\$('#BtnAddCABMember').click();");

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#CABCustomers$TestCustomerCAB').length;"
        );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#CABCustomers$TestCustomerCAB.DeleteCABMember",
            Event       => 'click',
        );

        # Save edited CAB template and switch window.
        $Selenium->find_element("//button[\@type='submit'][\@name='Submit']")->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Navigate to created test change.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMChangeZoom;ChangeID=$ChangeID");

        # Click on 'Involed Persons' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'AgentITSMChangeInvolvedPersons;ChangeID=$ChangeID' )]")
            ->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#ChangeManager").length;' );
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#ChangeManager',
            Event       => 'change',
        );

        # Input change manager.
        my $AutoCompleteStringManager
            = "\"$TestUserLogin $TestUserLogin\" <$TestUserLogin\@localunittest.com> ($TestUserID)";
        $Selenium->find_element( "#ChangeManager", 'css' )->send_keys($TestUserLogin);
        $Selenium->WaitFor( JavaScript => 'return $("li.ui-menu-item:visible").length;' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($AutoCompleteStringManager)').click();");

        # Test edited CAB template.
        $Selenium->execute_script(
            "\$('#TemplateID').val('$TemplateID').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element("//button[\@type='submit'][\@name='AddCABTemplateButton']")->click();

        # Verify that both user and customer are loaded from edited test CAB template.
        $Self->True(
            index( $Selenium->get_page_source(), "$TestUserCAB" ) > -1,
            "CAB user loaded from edited template - success",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "$TestCustomerCAB" ) > -1,
            "CAB customer user loaded from edited template - success",
        );

        # Delete test template.
        my $Success = $TemplateObject->TemplateDelete(
            TemplateID => $TemplateID,
            UserID     => 1,
        );
        $Self->True(
            $Success,
            "$TemplateNameRandom edit is deleted",
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

        # Make sure cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'ITSMChange*' );
    }
);

1;
