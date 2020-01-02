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
        my $ChangeObject = $Kernel::OM->Get('Kernel::System::ITSMChange');
        my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

        # Get change state data.
        my $ChangeStateDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Change::State',
            Name  => 'successful',
        );

        # Create test change.
        my $ChangeTitleRandom = 'ITSMChange ' . $Helper->GetRandomID();
        my $ChangeID          = $ChangeObject->ChangeAdd(
            ChangeTitle   => $ChangeTitleRandom,
            Description   => "Test Description",
            Justification => "Test Justification",
            ChangeStateID => $ChangeStateDataRef->{ItemID},
            UserID        => 1,
        );
        $Self->True(
            $ChangeID,
            "Change in successful state is created",
        );

        # Create and login as test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-builder', 'itsm-change-manager' ]
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get test user ID.
        my $TestUserLoginID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create new test CAB users.
        my $TestCABUser = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-builder' ],
        ) || die "Did not get test user";

        # Get CAB user ID.
        my $TestCABUserID = $UserObject->UserLookup(
            UserLogin => $TestCABUser,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentITSMChangeZoom of created test change.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMChangeZoom;ChangeID=$ChangeID");

        # Click on 'Involved Persons' and switch screens.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMChangeInvolvedPersons;ChangeID=$ChangeID' )]")
            ->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => 'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        # Prepare CAB for test template.
        $Selenium->find_element( "#ChangeManager", 'css' )->send_keys("");
        $Selenium->find_element( "#ChangeManager", 'css' )->send_keys($TestUserLogin);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestUserLogin)').click()");

        $Selenium->find_element( "#NewCABMember", 'css' )->send_keys("");
        $Selenium->find_element( "#NewCABMember", 'css' )->send_keys($TestCABUser);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCABUser)').click()");

        $Selenium->find_element( "#AddCABMemberButton", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#CABAgents-$TestCABUserID').length"
        );

        # Verify CAB user.
        $Self->True(
            index( $Selenium->get_page_source(), $TestCABUser ) > -1,
            "$TestCABUser is found",
        );

        # Click 'Save this CAB as template'.
        $Selenium->find_element("//button[\@value='NewTemplate'][\@type='submit']")->VerifiedClick();

        # Check page.
        for my $ID (qw(TemplateName Comment ValidID SubmitAddTemplate))
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check client side validation.
        my $Element = $Selenium->find_element( "#TemplateName", 'css' );
        $Element->send_keys("");
        $Selenium->find_element( "#SubmitAddTemplate", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#TemplateName.Error").length' );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#TemplateName').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Create test CAB template.
        my $CABTemplateName = "CAB Template " . $Helper->GetRandomID();
        $Selenium->find_element( "#TemplateName",      'css' )->send_keys($CABTemplateName);
        $Selenium->find_element( "#Comment",           'css' )->send_keys("SeleniumTest");
        $Selenium->find_element( "#SubmitAddTemplate", 'css' )->VerifiedClick();

        # Delete previous CAB user first.
        $Selenium->find_element( "#ChangeManager", 'css' )->send_keys($TestUserLogin);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestUserLogin)').click()");

        $Selenium->execute_script("\$('#CABAgents-$TestCABUserID').click();");
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#CABAgents-$TestCABUserID').length === 0;"
        );

        # Verify CAB user deletion.
        $Self->True(
            index( $Selenium->get_page_source(), $TestCABUser ) == -1,
            "$TestCABUser is not found",
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Get test CAB template ID.
        my $CABTemplateQuoted = $DBObject->Quote($CABTemplateName);
        $DBObject->Prepare(
            SQL  => "SELECT id FROM change_template WHERE name = ?",
            Bind => [ \$CABTemplateQuoted ]
        );
        my $CABTemplateID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $CABTemplateID = $Row[0];
        }

        # Import CAB from template.
        $Selenium->execute_script(
            "\$('#TemplateID').val('$CABTemplateID').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element("//button[\@value='Apply Template'][\@type='submit']")->VerifiedClick();

        # Verify CAB user applied from template.
        $Self->True(
            index( $Selenium->get_page_source(), $TestCABUser ) > -1,
            "$TestCABUser is found",
        );

        # Close popup.
        $Selenium->find_element( ".CancelClosePopup", 'css' )->click();
        $Selenium->WaitFor( WindowCount => 1 );

        # Delete test created template.
        my $Success = $Kernel::OM->Get('Kernel::System::ITSMChange::Template')->TemplateDelete(
            TemplateID => $CABTemplateID,
            UserID     => 1,
        );
        $Self->True(
            $Success,
            "$CABTemplateName is deleted",
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

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'ITSMChange*' );
    }
);

1;
