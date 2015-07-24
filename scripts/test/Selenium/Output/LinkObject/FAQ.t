# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

        # get FAQ object
        my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

        # create two test FAQ
        my @FAQIDs;
        my @FAQTitles;
        for my $FAQ ( 1 .. 2 ) {
            my $FAQTitle = 'FAQ ' . $Helper->GetRandomID();
            my $FAQID    = $FAQObject->FAQAdd(
                Title      => $FAQTitle,
                CategoryID => 1,
                StateID    => 2,
                LanguageID => 1,
                ValidID    => 1,
                UserID     => 1,
            );
            push @FAQIDs,    $FAQID;
            push @FAQTitles, $FAQTitle;
        }

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my $TicketTitle = 'Ticket ' . $Helper->GetRandomID();
        my $TicketID    = $TicketObject->TicketCreate(
            Title        => $TicketTitle,
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
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

        # navigate to AgentFAQZoom of created FAQ
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentFAQZoom;ItemID=$FAQIDs[0]");

        # click on 'Link' and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentLinkObject;SourceObject=FAQ' )]")->click();

        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # link FAQ with test created FAQ
        $Selenium->find_element("//input[\@name='SEARCH::Title']")->send_keys( $FAQTitles[1] );
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->click();
        $Selenium->WaitFor( JavaScript => "return \$('input#LinkTargetKeys').length" );

        $Selenium->find_element("//input[\@id='LinkTargetKeys']")->click();
        $Selenium->find_element("//button[\@id='AddLinks'][\@type='submit']")->click();

        # link FAQ with test created Ticket
        $Selenium->find_element("//input[\@id='TargetIdentifier_Search']")->clear();
        $Selenium->find_element("//input[\@id='TargetIdentifier_Search']")->send_keys('Ticket');
        $Selenium->find_element("//*[text()='Ticket']")->click();
        $Selenium->find_element("//input[\@name='SEARCH::Title']")->clear();
        $Selenium->find_element("//input[\@name='SEARCH::Title']")->send_keys($TicketTitle);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->click();
        $Selenium->WaitFor( JavaScript => "return \$('input#LinkTargetKeys').length" );

        $Selenium->find_element("//input[\@id='LinkTargetKeys']")->click();
        $Selenium->find_element("//button[\@id='AddLinks'][\@type='submit']")->click();
        $Selenium->find_element( "#LinkAddCloseLink", 'css' )->click();

        $Selenium->switch_to_window( $Handles->[0] );

        # verify FAQ and ticket is linked with test FAQ
        $Self->True(
            index( $Selenium->get_page_source(), $TicketTitle ) > -1,
            "Test ticket title $TicketTitle - found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $FAQTitles[1] ) > -1,
            "Test ticket title $FAQTitles[1] - found",
        );

        # click on 'Link' and switch screens
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentLinkObject;SourceObject=FAQ' )]")->click();

        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # delete link relation
        $Selenium->find_element("//a[contains(\@href, \'Subaction=LinkDelete' )]")->click();
        $Selenium->find_element("//input[\@id='SelectAllLinks0']")->click();
        $Selenium->find_element("//input[\@id='SelectAllLinks1']")->click();
        $Selenium->find_element("//button[\@type='submit']")->click();
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentLinkObject;Subaction=Close' )]")->click();
        $Selenium->switch_to_window( $Handles->[0] );

        # verify that link has been removed
        $Self->True(
            index( $Selenium->get_page_source(), $TicketTitle ) == -1,
            "Test ticket title $TicketTitle - not found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $FAQTitles[1] ) == -1,
            "Test ticket title $FAQTitles[1] - not found",
        );

        # delete test created FAQs
        my $Success;
        for my $FAQDelete (@FAQIDs) {
            $Success = $FAQObject->FAQDelete(
                ItemID => $FAQDelete,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "FAQ ID $FAQDelete - deleted",
            );
        }

        # delete test created ticket
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket ID $TicketID - deleted",
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );

    }
);

1;
