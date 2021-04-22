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

        my $FAQTitle    = 'FAQ ' . $Helper->GetRandomID();
        my $FAQSymptom  = 'Selenium Symptom';
        my $FAQProblem  = 'Selenium Problem';
        my $FAQSolution = 'Selenium Solution';
        my $FAQComment  = 'Selenium Comment';

        # Create test FAQ.
        my $ItemID = $FAQObject->FAQAdd(
            Title       => $FAQTitle,
            CategoryID  => 1,
            StateID     => 1,
            LanguageID  => 1,
            Keywords    => 'some keywords',
            Field1      => $FAQSymptom,
            Field2      => $FAQProblem,
            Field3      => $FAQSolution,
            Field6      => $FAQComment,
            ValidID     => 1,
            UserID      => 1,
            ContentType => 'text/html',
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
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQZoom;ItemID=$ItemID");

        # Check page.
        for my $ID (
            qw(Menu000-Back Menu010-Edit Menu020-History Menu030-Print Menu040-Link Menu050-Delete FAQBody FAQVoting)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        my $LinkTableViewMode = $Kernel::OM->Get('Kernel::Config')->Get('LinkObject::ViewMode');

        my @FAQWidgets = ('FAQ Information');

        # Only check the linked objects widget for the simple view mode here.
        if ( $LinkTableViewMode eq 'Simple' ) {
            push @FAQWidgets, 'Linked Objects';
        }

        for my $Source (@FAQWidgets) {
            $Self->True(
                index( $Selenium->get_page_source(), $Source ) > -1,
                "FAQ data is found on screen- $Source",
            );
        }

        # Verify test FAQ is created.
        $Self->True(
            index( $Selenium->get_page_source(), $FAQTitle ) > -1,
            "$FAQTitle is found",
        );

        my @Tests = (
            {
                Iframe  => 'IframeFAQField1',
                FAQData => $FAQSymptom,
            },
            {
                Iframe  => 'IframeFAQField2',
                FAQData => $FAQProblem,
            },
            {
                Iframe  => 'IframeFAQField3',
                FAQData => $FAQSolution,
            },
            {
                Iframe  => 'IframeFAQField6',
                FAQData => $FAQComment,
            },

        );

        for my $Test (@Tests) {

            # Switch to FAQ symptom iframe and verify its values.
            $Selenium->SwitchToFrame(
                FrameSelector => "#$Test->{Iframe}",
            );

            # Wait to switch on iframe.
            sleep 2;

            $Self->True(
                index( $Selenium->get_page_source(), $Test->{FAQData} ) > -1,
                "$Test->{FAQData} is found",
            );
            $Selenium->switch_to_frame();
        }

        my $Success = $FAQObject->FAQDelete(
            ItemID => $ItemID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "FAQ is deleted - ID $ItemID",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }

);

1;
