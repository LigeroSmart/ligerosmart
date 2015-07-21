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

        # click on 'Conditions' and switch screens
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMChangeCondition;ChangeID=$ChangeID' )]")
            ->click();

        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # click 'Add new condition'
        $Selenium->find_element("//button[\@name='AddCondition'][\@type='submit']")->click();

        # create test condition
        my $ConditionNameRandom = "Condition " . $Helper->GetRandomID();
        $Selenium->find_element( "#Name",    'css' )->send_keys($ConditionNameRandom);
        $Selenium->find_element( "#Comment", 'css' )->send_keys("SeleniumCondition");

        # get condition object
        my $ConditionObject = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMCondition');

        # get needed IDs
        my $ExpresionAttributeID = $ConditionObject->AttributeLookup(
            Name => 'ImpactID',
        );
        my $ImpactDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Impact',
            Name  => '4 high',
        );
        my $ActionAttributeID = $ConditionObject->AttributeLookup(
            Name => 'ChangeStateID'
        );
        my $ActionOperatorID = $ConditionObject->OperatorLookup(
            Name => 'set',
        );
        my $ConditionChangeStateDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Change::State',
            Name  => 'successful',
        );

        # add new expresion
        # in change object for test change, look for impact value of '4 high'
        $Selenium->find_element("//button[\@name='AddExpression'][\@type='submit']")->click();
        $Selenium->find_element( "#ExpressionID-NEW-ObjectID option[value='1']",         'css' )->click();
        $Selenium->find_element( "#ExpressionID-NEW-Selector option[value='$ChangeID']", 'css' )->click();
        $Selenium->find_element( "#ExpressionID-NEW-AttributeID option[value='$ExpresionAttributeID']", 'css' )
            ->click();
        $Selenium->find_element( "#ExpressionID-NEW-OperatorID option[value='1']", 'css' )->click();
        $Selenium->find_element( "#ExpressionID-NEW-CompareValue option[value='$ImpactDataRef->{ItemID}']", 'css' )
            ->click();

        # add new action
        # in change object for test change, set change state on successful
        $Selenium->find_element("//button[\@name='AddAction'][\@type='submit']")->click();
        $Selenium->find_element( "#ActionID-NEW-ObjectID option[value='1']",                     'css' )->click();
        $Selenium->find_element( "#ActionID-NEW-Selector option[value='$ChangeID']",             'css' )->click();
        $Selenium->find_element( "#ActionID-NEW-AttributeID option[value='$ActionAttributeID']", 'css' )->click();
        $Selenium->find_element( "#ActionID-NEW-OperatorID option[value='$ActionOperatorID']",   'css' )->click();
        $Selenium->find_element(
            "#ActionID-NEW-ActionValue option[value='$ConditionChangeStateDataRef->{ItemID}']",
            'css'
        )->click();

        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        # check screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # verify created condition name value
        $Self->True(
            index( $Selenium->get_page_source(), $ConditionNameRandom ) > -1,
            "$ConditionNameRandom - found",
        );

        # close and switch window
        $Selenium->find_element( ".CancelClosePopup", 'css' )->click();
        $Selenium->switch_to_window( $Handles->[0] );

        # check test change state
        $Self->True(
            index( $Selenium->get_page_source(), 'Pending PIR' ) > -1,
            "Pending PIR state - found",
        );

        # get general catalog impact ID '4 very high'
        my $CatalogImpactDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Impact',
            Name  => '4 high',
        );

        # click to edit change and set its impact on '4 high' to trigger condition
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMChangeEdit;ChangeID=$ChangeID' )]")->click();

        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        $Selenium->find_element( "#ImpactID option[value='$CatalogImpactDataRef->{ItemID}']", 'css' )->click();

        # submit and change window
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();
        $Selenium->switch_to_window( $Handles->[0] );

        # check for expected chage state to verify test condition
        $Self->True(
            index( $Selenium->get_page_source(), 'Successful' ) > -1,
            "Successful state - found",
        );

        # click on 'Conditions' and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMChangeCondition;ChangeID=$ChangeID' )]")
            ->click();

        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # click to delete test condition
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMChangeCondition;ChangeID=$ChangeID' )]")
            ->click();

        # delete test created change
        my $Success = $ChangeObject->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "$ChangeTitleRandom - deleted",
        );

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'ITSMChange*' );

    }
);

1;
