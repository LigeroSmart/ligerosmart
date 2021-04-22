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

        # Create two test FAQ.
        my @ItemIDs;
        my @FAQTitles;
        for my $FAQ ( 1 .. 2 ) {
            my $FAQTitle = 'FAQ ' . $Helper->GetRandomID();
            my $ItemID   = $FAQObject->FAQAdd(
                Title       => $FAQTitle,
                CategoryID  => 1,
                StateID     => 2,
                LanguageID  => 1,
                ValidID     => 1,
                UserID      => 1,
                ContentType => 'text/html',
            );

            $Self->True(
                $ItemID,
                "Test FAQ item is created - ID $ItemID",
            );

            push @ItemIDs,   $ItemID;
            push @FAQTitles, $FAQTitle;
        }

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

        # Navigate to link object screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentLinkObject;SourceObject=FAQ;SourceKey=$ItemIDs[0]");

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("input[name=\'SEARCH::Title\']").length && $("button[type=submit]").length;'
        );

        # Link two test created FAQs.
        $Selenium->find_element("//input[\@name='SEARCH::Title']")->send_keys( $FAQTitles[1] );
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#LinkTargetKeys",
            Event       => 'click',
        );
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#LinkTargetKeys",
            Event       => 'change',
        );

        $Selenium->find_element( "#LinkTargetKeys", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return $("#LinkTargetKeys:checked").length;' );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#AddLinks",
        );

        $Selenium->find_element( "#AddLinks", 'css' )->VerifiedClick();

        # Navigate to AgentFAQZoom of created FAQ.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQZoom;ItemID=$ItemIDs[0]");

        $Self->True(
            index( $Selenium->get_page_source(), $FAQTitles[1] ) > -1,
            "Test ticket title $FAQTitles[1] is found",
        );

        # Navigate to link object screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentLinkObject;SourceObject=FAQ;SourceKey=$ItemIDs[0]");

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("div[data-id=ManageLinks]").length;'
        );
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "a[href='#ManageLinks']",
        );

        # Delete link relation.
        $Selenium->find_element("//a[contains(\@href, \'#ManageLinks' )]")->click();
        $Selenium->WaitFor( JavaScript => 'return $("div[data-id=ManageLinks].Active").length;' );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#SelectAllLinks0",
        );

        $Selenium->find_element( "#SelectAllLinks0", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return $("#FAQ .DataTable input[type=checkbox]:checked").length;' );

        $Selenium->find_element("//button[\@title='Delete links']")->VerifiedClick();

        # Navigate to AgentFAQZoom of created FAQ.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQZoom;ItemID=$ItemIDs[0]");

        # Verify that link has been removed.
        $Self->True(
            index( $Selenium->get_page_source(), $FAQTitles[1] ) == -1,
            "$FAQTitles[1] is not found",
        );

        # Delete test created FAQs.
        my $Success;
        for my $ItemID (@ItemIDs) {
            $Success = $FAQObject->FAQDelete(
                ItemID => $ItemID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "Test FAQ item is deleted - ID $ItemID",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }
);

1;
