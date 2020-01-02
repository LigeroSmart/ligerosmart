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

        # get FAQ object
        my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

        # create test FAQ
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

        # navigate to AgentFAQZoom of created FAQ
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQZoom;ItemID=$ItemID");

        # create menu module test params
        my @MenuModule = (
            {
                Name   => "Edit",
                Action => "AgentFAQEdit;ItemID=$ItemID",
            },
            {
                Name   => "History",
                Action => "AgentFAQHistory;ItemID=$ItemID",
            },
            {
                Name   => "Print",
                Action => "AgentFAQPrint;ItemID=$ItemID",
            },
            {
                Name   => "Link",
                Action => "AgentLinkObject;SourceObject=FAQ",
            },
            {
                Name   => "Delete",
                Action => "AgentFAQDelete;ItemID=$ItemID",
            },
        );

        # check FAQ menu modules
        for my $FAQZoomMenuModule (@MenuModule) {
            $Self->True(
                $Selenium->find_element("//a[contains(\@href, \'Action=$FAQZoomMenuModule->{Action}' )]"),
                "FAQ menu $FAQZoomMenuModule->{Name} is found"
            );
        }

        # delete test created FAQ
        my $Success = $FAQObject->FAQDelete(
            ItemID => $ItemID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "Test FAQ item is deleted - ID $ItemID",
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }
);

1;
