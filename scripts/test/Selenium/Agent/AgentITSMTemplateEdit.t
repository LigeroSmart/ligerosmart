# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Get change state data.
        my $ChangeStateDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Change::State',
            Name  => 'requested',
        );

        my $ChangeObject = $Kernel::OM->Get('Kernel::System::ITSMChange');

        # Create test change.
        my $ChangeTitleRandom = 'ITSMChange Requested ' . $Helper->GetRandomID();
        my $ChangeID          = $ChangeObject->ChangeAdd(
            ChangeTitle   => $ChangeTitleRandom,
            Description   => "Test Description",
            Justification => "Test Justification",
            ChangeStateID => $ChangeStateDataRef->{ItemID},
            UserID        => 1,
        );
        $Self->True(
            $ChangeID,
            "$ChangeTitleRandom is created",
        );

        my $TemplateObject = $Kernel::OM->Get('Kernel::System::ITSMChange::Template');

        # Create simple change template.
        my $TemplateNameRandom = 'Template ' . $Helper->GetRandomID();
        my $ChangeContent      = $TemplateObject->TemplateSerialize(
            Name         => $TemplateNameRandom,
            TemplateType => 'ITSMChange',
            ChangeID     => $ChangeID,
            Comment      => 'Selenium Test Comment',
            ValidID      => 1,
            UserID       => 1
        );

        # Create test template from test change.
        my $TemplateID = $TemplateObject->TemplateAdd(
            Name         => $TemplateNameRandom,
            TemplateType => 'ITSMChange',
            ChangeID     => $ChangeID,
            Content      => $ChangeContent,
            Comment      => 'Selenium Test Comment',
            ValidID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TemplateID,
            "Change Template ID $TemplateID is created",
        );

        # Create and log in test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-manager' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentITSMTemplateOverview screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentITSMTemplateOverview;SortBy=TemplateID;OrderBy=Down;Filter=ITSMChange"
        );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            ElementExists => "//a[contains(\@href, \'AgentITSMTemplateEdit;TemplateID=$TemplateID' )]"
        );

        # Navigate to AgentITSMTemplateEdit screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentITSMTemplateEdit;TemplateID=$TemplateID"
        );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#TemplateName").length' );

        # Check stored values.
        $Self->Is(
            $Selenium->find_element( '#TemplateName', 'css' )->get_value(),
            $TemplateNameRandom,
            "#TemplateName stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            'Selenium Test Comment',
            "#Comment stored value",
        );

        # Edit values and submit.
        $Selenium->find_element( "#TemplateName", 'css' )->send_keys(" Edit");
        $Selenium->find_element( "#Comment",      'css' )->send_keys(" Edit");
        $Selenium->find_element("//button[\@id='submitEditTemplate'][\@type='submit']")->VerifiedClick();

        # Navigate to AgentITSMTemplateEdit screen in ordr to check edited ITSM tamplete.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentITSMTemplateEdit;TemplateID=$TemplateID"
        );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#TemplateName").length' );

        # Check edited values.
        $Self->Is(
            $Selenium->find_element( '#TemplateName', 'css' )->get_value(),
            $TemplateNameRandom . ' Edit',
            "#TemplateName edited value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            'Selenium Test Comment Edit',
            "#Comment edited value",
        );

        # Delete test template.
        my $Success = $TemplateObject->TemplateDelete(
            TemplateID => $TemplateID,
            UserID     => 1,
        );
        $Self->True(
            $Success,
            "$TemplateNameRandom edit is deleted",
        );

        # Delete test created change.
        $Success = $ChangeObject->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "$ChangeTitleRandom is deleted",
        );

        # Make sure cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'ITSMChange*' );
    }
);

1;
