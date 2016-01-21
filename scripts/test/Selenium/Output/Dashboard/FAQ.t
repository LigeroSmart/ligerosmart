# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
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
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # set FAQ dashboard SysConfig param
        my @FAQDashboard = (
            {
                Name => 'DashboardBackend###0398-FAQ-LastChange',
            },
            {
                Name => 'DashboardBackend###0399-FAQ-LastCreate',
            },
        );

        # get SysConfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # set FAQ dashboard modules on default settings
        for my $DefaultSysConfig (@FAQDashboard) {
            $SysConfigObject->ConfigItemReset(
                Name => $DefaultSysConfig->{Name},
            );
        }

        # get FAQ object
        my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

        # create test FAQ
        my $FAQTitle = 'FAQ ' . $Helper->GetRandomID();
        my $FAQID    = $FAQObject->FAQAdd(
            Title       => $FAQTitle,
            CategoryID  => 1,
            StateID     => 2,
            LanguageID  => 1,
            ValidID     => 1,
            Approved    => 1,
            UserID      => 1,
            ContentType => 'text/html',
        );
        $Self->True(
            $FAQID,
            "Test FAQ item is created - ID $FAQID",
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

        for my $Test (@FAQDashboard) {

            # disable all dashboard plug-ins
            my $Config = $Kernel::OM->Get('Kernel::Config')->Get('DashboardBackend');
            $SysConfigObject->ConfigItemUpdate(
                Valid => 0,
                Key   => 'DashboardBackend',
                Value => \%$Config,
            );

            # enable FAQ dashboard
            $SysConfigObject->ConfigItemReset(
                Name => $Test->{Name},
            );

            # navigate to dashboard screen
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

            # check title for test created FAQ
            $Self->True(
                index( $Selenium->get_page_source(), $FAQTitle ) > -1,
                "Test FAQ title is found",
            );

            # check link for test created FAQ
            $Self->True(
                index( $Selenium->get_page_source(), "${ScriptAlias}index.pl?Action=AgentFAQZoom;ItemID=$FAQID" ) > -1,
                "Test FAQ link is found",
            );
        }

        # delete test created FAQ
        my $Success = $FAQObject->FAQDelete(
            ItemID => $FAQID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "Test FAQ item is deleted - ID $FAQID",
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }
);

1;
