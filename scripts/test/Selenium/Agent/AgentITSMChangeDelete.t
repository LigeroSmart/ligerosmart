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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get change delete menu module default config
        my %ChangeDeleteMenu = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'ITSMChange::Frontend::MenuModule###100-ChangeDelete',
            Default => 1,
        );

        $Helper->ConfigSettingChange(
            Key   => 'ITSMChange::Frontend::MenuModule###100-ChangeDelete',
            Value => $ChangeDeleteMenu{EffectiveValue},
            Valid => 1,
        );

        # get AgentITSMChangeDelete frontend module sysconfig
        my %ChangeDeleteFrontendUpdate = (
            'Description' => 'Delete a change',
            'GroupRo'     => [
                'itsm-change-manager'
            ],
            'NavBarName' => 'ITSM Change',
            'Title'      => 'Delete'
        );

        # set AgentITSMChangeDelete frontend module on valid
        $Helper->ConfigSettingChange(
            Key   => 'Frontend::Module###AgentITSMChangeDelete',
            Value => \%ChangeDeleteFrontendUpdate,
            Valid => 1,
        );

        # get general catalog object
        my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');

        # get change state data
        my $ChangeStateDataRef = $GeneralCatalogObject->ItemGet(
            Class => 'ITSM::ChangeManagement::Change::State',
            Name  => 'requested',
        );

        # get change object
        my $ChangeObject = $Kernel::OM->Get('Kernel::System::ITSMChange');

        # create test change
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

        # navigate to AgentITSMChange screen with requested filter and ordered down
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentITSMChange;SortBy=ChangeNumber;OrderBy=Down;View=;Filter=requested"
        );

        # verify that test created change is present
        $Self->True(
            index( $Selenium->get_page_source(), $ChangeTitleRandom ) > -1,
            "$ChangeTitleRandom is found",
        );

        # click on test created change
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMChangeZoom;ChangeID=$ChangeID')]")
            ->VerifiedClick();

        # click on 'Delete'
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMChangeDelete;ChangeID=$ChangeID')]")->click();

        # wait for server side error
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('div.Dialog button#DialogButton1').length"
        );

        # click ok to dismiss
        $Selenium->find_element( 'div.Dialog button#DialogButton1', 'css' )->VerifiedClick();

        # verify that test created change is not present
        $Self->True(
            index( $Selenium->get_page_source(), $ChangeTitleRandom ) == -1,
            "$ChangeTitleRandom is not found",
        );

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'ITSMChange*' );
    }
);

1;
