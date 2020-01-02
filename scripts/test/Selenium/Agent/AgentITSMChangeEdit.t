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

        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');
        my $ChangeObject         = $Kernel::OM->Get('Kernel::System::ITSMChange');

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Get change state data.
        my $ChangeStateDataRef = $GeneralCatalogObject->ItemGet(
            Class => 'ITSM::ChangeManagement::Change::State',
            Name  => 'pending pir',
        );

        # Create test change.
        my $ChangeTitleRandom = 'ITSMChange ' . $Helper->GetRandomID();
        my $ChangeID          = $ChangeObject->ChangeAdd(
            ChangeTitle   => $ChangeTitleRandom,
            Description   => "Test Description",
            Justification => "Test Justification",
            ChangeStateID => $ChangeStateDataRef->{ItemID},
            UserID        => 1,
        );
        $Self->True(
            $ChangeID,
            "Change in Pending PIR state is created",
        );

        # Create and log in test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-builder', 'itsm-change-manager' ]
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentITSMChangeEdit of created test change.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMChangeEdit;ChangeID=$ChangeID");

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#ChangeTitle").length;' );

        # Get general catalog category, impact and priority ID for '3 normal'.
        my @StoredIDs;
        for my $GeneralCatalogStored (qw(Category Impact Priority)) {
            my $CatalogDataRef = $GeneralCatalogObject->ItemGet(
                Class => "ITSM::ChangeManagement::$GeneralCatalogStored",
                Name  => '3 normal',
            );
            push @StoredIDs, $CatalogDataRef->{ItemID};
        }

        # Get general catalog category, impact and priority ID for '4 high'.
        my @EditIDs;
        for my $GeneralCatalogEdit (qw(Category Impact Priority)) {
            my $CatalogDataRef = $GeneralCatalogObject->ItemGet(
                Class => "ITSM::ChangeManagement::$GeneralCatalogEdit",
                Name  => '4 high',
            );
            push @EditIDs, $CatalogDataRef->{ItemID};
        }

        # Check stored values.
        $Self->Is(
            $Selenium->find_element( '#ChangeTitle', 'css' )->get_value(),
            $ChangeTitleRandom,
            "#ChangeTitle stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#RichText1', 'css' )->get_value(),
            'Test Description',
            "#Description stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#RichText2', 'css' )->get_value(),
            'Test Justification',
            "#Justification stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#CategoryID', 'css' )->get_value(),
            $StoredIDs[0],
            "#CategoryID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ImpactID', 'css' )->get_value(),
            $StoredIDs[1],
            "#ImpactID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#PriorityID', 'css' )->get_value(),
            $StoredIDs[2],
            "#PriorityID stored value",
        );

        # Edit fields and submit.
        $Selenium->find_element( "#ChangeTitle", 'css' )->send_keys(" edit");
        $Selenium->find_element( "#RichText1",   'css' )->send_keys(" edit");
        $Selenium->find_element( "#RichText2",   'css' )->send_keys(" edit");
        $Selenium->execute_script(
            "\$('#CategoryID').val('$EditIDs[0]').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->execute_script("\$('#ImpactID').val('$EditIDs[1]').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script(
            "\$('#PriorityID').val('$EditIDs[2]').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # Navigate to AgentITSMChangeEdit of created test change.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMChangeEdit;ChangeID=$ChangeID");

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#ChangeTitle").length;' );

        # Check edited values.
        $Self->Is(
            $Selenium->find_element( '#ChangeTitle', 'css' )->get_value(),
            $ChangeTitleRandom . ' edit',
            "#ChangeTitle edited value",
        );
        $Self->Is(
            $Selenium->find_element( '#RichText1', 'css' )->get_value(),
            'Test Description edit',
            "#Description edited value",
        );
        $Self->Is(
            $Selenium->find_element( '#RichText2', 'css' )->get_value(),
            'Test Justification edit',
            "#Justification edited value",
        );
        $Self->Is(
            $Selenium->find_element( '#CategoryID', 'css' )->get_value(),
            $EditIDs[0],
            "#CategoryID edited value",
        );
        $Self->Is(
            $Selenium->find_element( '#ImpactID', 'css' )->get_value(),
            $EditIDs[1],
            "#ImpactID edited value",
        );
        $Self->Is(
            $Selenium->find_element( '#PriorityID', 'css' )->get_value(),
            $EditIDs[2],
            "#PriorityID edited value",
        );

        # Delete test created change.
        my $Success = $ChangeObject->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "$ChangeTitleRandom edit is deleted",
        );

        # Make sure cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'ITSMChange*' );
    }

);

1;
