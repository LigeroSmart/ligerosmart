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
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # do not check RichText
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # get change state data
        my $ChangeStateDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Change::State',
            Name  => 'pending pir',
        );

        # get change object
        my $ChangeObject = $Kernel::OM->Get('Kernel::System::ITSMChange');

        # create test change
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
            "Change in Pending PIR state - created",
        );

        # create and log in test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-builder', 'itsm-change-manager' ]
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentITSMChangeZoom of created test change
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentITSMChangeZoom;ChangeID=$ChangeID");

        # click on 'Edit' and switch screens
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMChangeEdit;ChangeID=$ChangeID' )]")->click();

        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # get general catalog object
        my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');

        # get general catalog category, impact and priority ID for '3 normal'
        my @StoredIDs;
        for my $GeneralCatalogStored (qw(Category Impact Priority)) {
            my $CatalogDataRef = $GeneralCatalogObject->ItemGet(
                Class => "ITSM::ChangeManagement::$GeneralCatalogStored",
                Name  => '3 normal',
            );
            push @StoredIDs, $CatalogDataRef->{ItemID};
        }

        # get general catalog category, impact and priority ID for '4 high'
        my @EditIDs;
        for my $GeneralCatalogEdit (qw(Category Impact Priority)) {
            my $CatalogDataRef = $GeneralCatalogObject->ItemGet(
                Class => "ITSM::ChangeManagement::$GeneralCatalogEdit",
                Name  => '4 high',
            );
            push @EditIDs, $CatalogDataRef->{ItemID};
        }

        # check stored values
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

        # edit fields and submit
        $Selenium->find_element( "#ChangeTitle",                            'css' )->send_keys(" edit");
        $Selenium->find_element( "#RichText1",                              'css' )->send_keys(" edit");
        $Selenium->find_element( "#RichText2",                              'css' )->send_keys(" edit");
        $Selenium->find_element( "#CategoryID option[value='$EditIDs[0]']", 'css' )->click();
        $Selenium->find_element( "#ImpactID option[value='$EditIDs[1]']",   'css' )->click();
        $Selenium->find_element( "#PriorityID option[value='$EditIDs[2]']", 'css' )->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        # switch back window
        $Selenium->switch_to_window( $Handles->[0] );

        # click on 'Edit' and switch screens
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMChangeEdit;ChangeID=$ChangeID' )]")->click();

        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # check edited values
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

        # delete test created change
        my $Success = $ChangeObject->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "$ChangeTitleRandom edit - deleted",
        );

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'ITSMChange*' );
    }

);

1;
