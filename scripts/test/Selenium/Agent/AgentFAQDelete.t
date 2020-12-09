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

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test FAQ.
        my $FAQTitle = 'FAQ ' . $Helper->GetRandomID();
        my $ItemID   = $Kernel::OM->Get('Kernel::System::FAQ')->FAQAdd(
            Title       => $FAQTitle,
            CategoryID  => 1,
            StateID     => 1,
            LanguageID  => 1,
            ValidID     => 1,
            UserID      => 1,
            ContentType => 'text/plain',
        );

        $Self->True(
            $ItemID,
            "FAQ item is created - ID $ItemID",
        );

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

        # Navigate to AgentFAQZoom screen of created test FAQ.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQZoom;ItemID=$ItemID;Nav=");

        # Verify its right screen.
        $Self->True(
            index( $Selenium->get_page_source(), $FAQTitle ) > -1,
            "$FAQTitle is found",
        );

        # Click on 'Delete'.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentFAQDelete;ItemID=$ItemID' )]")->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#DialogButton1").length' );

        # Verify delete message.
        $Self->True(
            index( $Selenium->get_page_source(), 'Do you really want to delete this FAQ article?' ) > -1,
            "Delete message is found",
        );

        # Execute delete.
        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return !$(".Dialog.Modal").length' );

        # Verify delete action.
        # Try to navigate to the AgetnFAQZoom of deleted test FAQ.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQZoom;ItemID=$ItemID;Nav=");
        $Self->True(
            index( $Selenium->get_page_source(), "No such ItemID $ItemID!" ) > -1,
            "Delete action - success",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }
);

1;
