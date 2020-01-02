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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # disable show invalid FAQ items SySConfig
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'FAQ::Frontend::AgentFAQExplorer###ShowInvalidFAQItems',
            Value => 0,
        );

        # get FAQ object
        my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

        my @FAQs;

        # create test FAQs
        for ( 1 .. 5 ) {
            my $FAQTitle = 'FAQ ' . $Helper->GetRandomID();
            my $ItemID   = $FAQObject->FAQAdd(
                Title       => $FAQTitle,
                CategoryID  => 1,
                StateID     => 1,
                LanguageID  => 1,
                ValidID     => 1,
                UserID      => 1,
                ContentType => 'text/html',
            );

            $Self->True(
                $ItemID,
                "FAQ is created - ID $ItemID",
            );

            my %FAQ = (
                ItemID   => $ItemID,
                FAQTitle => $FAQTitle,
            );

            push @FAQs, \%FAQ;
        }

        # set one FAQ as invalid see bug bug#11498 (http://bugs.otrs.org/show_bug.cgi?id=11498)ShowInvalidFAQItems
        my $InvalidFAQTitle = "Invalid $FAQs[0]->{FAQTitle}";
        my $Success         = $FAQObject->FAQUpdate(
            ItemID      => $FAQs[0]->{ItemID},
            Title       => $InvalidFAQTitle,
            CategoryID  => 1,
            StateID     => 1,
            LanguageID  => 1,
            Approved    => 1,
            ContentType => 'text/html',
            ValidID     => 2,
            UserID      => 1,
        );
        $FAQs[0]->{FAQTitle} = $InvalidFAQTitle;

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentFAQExplorer screen of created test FAQ
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQExplorer");

        # check AgentFAQExplorer screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # test data for explorer screen
        my @Tests = (
            {
                ScreenData => 'FAQ Explorer',
            },
            {
                ScreenData => 'Latest created FAQ articles',
            },
            {
                ScreenData => 'Latest updated FAQ articles',
            },
        );

        for my $Test (@Tests) {
            $Self->True(
                index( $Selenium->get_page_source(), $Test->{ScreenData} ) > -1,
                "$Test->{ScreenData} is found",
            );
        }

        # click on 'Misc', go on subcategory screen
        $Selenium->find_element( 'Misc', 'link_text' )->VerifiedClick();

        # order FAQ item per FAQID by Down
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQExplorer;CategoryID=1;SortBy=FAQID;OrderBy=Down");

        # verify Invalid FAQ is not visible on explorer screen
        $Self->True(
            index( $Selenium->get_page_source(), $FAQs[0]->{FAQTitle} ) == -1,
            "$FAQs[0]->{FAQTitle} is not found",
        );

        # enable show invalid FAQ items SySConfig
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'FAQ::Frontend::AgentFAQExplorer###ShowInvalidFAQItems',
            Value => 1,
        );

        # refresh screen
        $Selenium->VerifiedRefresh();
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.MasterAction.Invalid td div:eq(0)').text().trim()",
        );

        # check and delete test created FAQs
        for my $FAQ (@FAQs) {

            # check if there is test FAQ on screen
            $Self->Is(
                $Selenium->find_element( "tr#ItemID_" . $FAQ->{ItemID} . "_.MasterAction td div", 'css' )->get_text(),
                $FAQ->{FAQTitle},
                "$FAQ->{FAQTitle} is found",
            );

            $Success = $FAQObject->FAQDelete(
                ItemID => $FAQ->{ItemID},
                UserID => 1,
            );
            $Self->True(
                $Success,
                "FAQ is deleted - ID $FAQ->{ItemID}",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }
);

1;
