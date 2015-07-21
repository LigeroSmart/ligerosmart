# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

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

        # get FAQ object
        my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

        # create test FAQ
        # test params
        my $FAQTitle    = 'FAQ ' . $Helper->GetRandomID();
        my $FAQSymptom  = 'Selenium Sypmtom';
        my $FAQProblem  = 'Selenium Problem';
        my $FAQSolution = 'Selenium Solution';
        my $FAQComment  = 'Selenium Comment';

        my $FAQID = $FAQObject->FAQAdd(
            Title      => $FAQTitle,
            CategoryID => 1,
            StateID    => 1,
            LanguageID => 1,
            Keywords   => 'some keywords',
            Field1     => $FAQSymptom,
            Field2     => $FAQProblem,
            Field3     => $FAQSolution,
            Field6     => $FAQComment,
            ValidID    => 1,
            UserID     => 1,
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', 'faq', 'faq_admin' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentFAQPrint screen of created test FAQ
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentFAQPrint;ItemID=$FAQID");

        # wait until print screen is loaded
        ACTIVESLEEP:
        for my $Second ( 1 .. 20 ) {
            if ( index( $Selenium->get_page_source(), $FAQComment ) > -1, ) {
                last ACTIVESLEEP;
            }
            sleep 1;
        }

        my @Tests = (
            {
                FAQData => $FAQSymptom,
            },
            {
                FAQData => $FAQProblem,
            },
            {
                FAQData => $FAQSolution,
            },
            {
                FAQData => $FAQComment,
            },

        );
        for my $Test (@Tests) {
            $Self->True(
                index( $Selenium->get_page_source(), $Test->{FAQData} ) > -1,
                "$Test->{FAQData} - found on print screen",
            );
        }

        my $Success = $FAQObject->FAQDelete(
            ItemID => $FAQID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "FAQ is deleted - $FAQID",
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );

    }

);

1;
