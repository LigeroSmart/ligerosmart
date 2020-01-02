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

        my $Helper    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

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

        # Navigate to AgentFAQLanguage screen of created test FAQ.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQLanguage");

        # Check add button.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentFAQLanguage;Subaction=Add' )]");

        # Check AgentFAQLanguage screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check English language - 'en'.
        $Selenium->find_element( 'en', 'link_text' );

        # Check German Language - 'de'.
        $Selenium->find_element( 'de', 'link_text' );

        # Add test language - Spanish (es).
        my $FAQLanguage = 'es';

        # Check if there is 'es - Language' has been added before.
        my $Exists = $FAQObject->LanguageDuplicateCheck(
            Name   => $FAQLanguage,
            UserID => 1,
        );

        $Selenium->find_element("//a[contains(\@href, \'Action=AgentFAQLanguage;Subaction=Add' )]")->VerifiedClick();

        if ($Exists) {
            $Selenium->find_element( "#Name", 'css' )->send_keys($FAQLanguage);
            $Selenium->find_element("//button[\@type='submit']")->click();
            $Selenium->WaitFor( JavaScript => 'return $(".Dialog.Modal.Alert").length && $("#Name.Error").length' );

            # Close alert dialog.
            $Selenium->find_element( "#DialogButton1", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return !$(".Dialog.Modal.Alert").length' );

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#Name').hasClass('ServerError')"
                ),
                '1',
                'This language already exists!',
            );

            # Go back on Language overview screen.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQLanguage");

        }
        else {
            $Selenium->find_element( "#Name", 'css' )->send_keys($FAQLanguage);
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();
        }

        $Selenium->WaitFor( JavaScript => 'return $(".DataTable").length' );

        # Get ID for test language.
        my $LanguageID = $FAQObject->LanguageLookup(
            Name => $FAQLanguage,
        );

        # Verify test FAQ has been created.
        $Self->True(
            index( $Selenium->get_page_source(), "AgentFAQLanguage;Subaction=Change;LanguageID=$LanguageID" ) > -1,
            "Test language is created - $FAQLanguage",
        );

        # Check added 'test' language.
        $Selenium->find_element( "$FAQLanguage", 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $FAQLanguage,
            "Stored language name $FAQLanguage - found",
        );

        # Go back on Language overview screen.
        $Selenium->find_element( 'Cancel', 'link_text' )->VerifiedClick();

        # If test language was created in the test, delete it.
        if ( !$Exists ) {

            # Delete 'test' language.
            $Selenium->find_element( "#DeleteLanguageID$LanguageID", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return $("#DialogButton1").length' );

            # Verify delete message.
            $Self->True(
                index( $Selenium->get_page_source(), 'Do you really want to delete this language?' ) > -1,
                "Delete message - found",
            );

            # Execute delete.
            $Selenium->find_element( "#DialogButton1", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return !$(".Dialog.Modal").length' );

            $Selenium->VerifiedRefresh();

            # Verify test FAQ has been deleted.
            $Self->True(
                index( $Selenium->get_page_source(), "AgentFAQLanguage;Subaction=Change;LanguageID=$LanguageID" ) == -1,
                "Test language is deleted - $FAQLanguage",
            );
        }
    }
);

1;
