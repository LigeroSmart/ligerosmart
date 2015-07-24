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
        my $FAQTitle = 'FAQ ' . $Helper->GetRandomID();
        my $FAQID    = $FAQObject->FAQAdd(
            Title      => $FAQTitle,
            CategoryID => 1,
            StateID    => 3,
            LanguageID => 1,
            Approved   => 1,
            ValidID    => 1,
            UserID     => 1,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to public screen
        $Selenium->get("${ScriptAlias}public.pl?");

        # check for 'Advanced Search' button
        $Self->True(
            index( $Selenium->get_page_source(), "Action=PublicFAQSearch;" ) > -1,
            "Advanced Search button - found",
        );

        # search test created FAQ in quicksearch
        $Selenium->find_element("//input[\@id='Search']")->send_keys($FAQTitle);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->click();

        # check for quicksearch result
        $Self->True(
            index( $Selenium->get_page_source(), "$FAQTitle" ) > -1,
            "$FAQTitle - found",
        );

        # delete test created FAQ
        my $Success = $FAQObject->FAQDelete(
            ItemID => $FAQID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "$FAQTitle - deleted",
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }
);

1;
