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

        # create and log in test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-manager' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # create and test change for each state in AgentITSMChangePIR screen
        for my $WorkOrderState ( 'accepted', 'ready', 'in progress', 'closed', 'canceled' ) {

            # get change object
            my $ChangeObject = $Kernel::OM->Get('Kernel::System::ITSMChange');

            # get change state data
            my $ChangeStateDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
                Class => 'ITSM::ChangeManagement::Change::State',
                Name  => 'requested',
            );

            # create test change
            my $ChangeTitleRandom = 'ITSMChange Requested ' . $Helper->GetRandomID();
            my $ChangeID          = $ChangeObject->ChangeAdd(
                ChangeTitle   => $ChangeTitleRandom,
                Description   => 'Selenium Test Description',
                Justification => 'Selenium Test Justification',
                ChangeStateID => $ChangeStateDataRef->{ItemID},
                UserID        => $TestUserID,
            );
            $Self->True(
                $ChangeID,
                "$ChangeTitleRandom - created",
            );

            # create test workorder for test change
            my $WorkOrderTitleRandom = 'WorkOrder ' . $WorkOrderState . ' ' . $Helper->GetRandomID();
            my $WorkOrderID          = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder')->WorkOrderAdd(
                ChangeID         => $ChangeID,
                WorkOrderTitle   => $WorkOrderTitleRandom,
                Instruction      => 'Selenium Instruction',
                Report           => 'Selenium Report',
                WorkOrderState   => $WorkOrderState,
                WorkOrderType    => 'pir',
                WorkOrderAgentID => $TestUserID,
                UserID           => $TestUserID,
            );
            $Self->True(
                $WorkOrderID,
                "$WorkOrderTitleRandom - created",
            );

            # navigate to AgentITSMChangePIR screen
            $Selenium->get("${ScriptAlias}index.pl?Action=AgentITSMChangePIR;SortBy=ChangeNumber;OrderBy=Down");

            if ( $WorkOrderState eq 'in progress' ) {

                # click on appropriate filter
                $Selenium->find_element("//a[contains(\@href, \'Filter=in%20progress' )]")->click();

            }
            else {

                # click on appropriate filter
                $Selenium->find_element("//a[contains(\@href, \'Filter=$WorkOrderState' )]")->click();
            }

            # check screen
            $Selenium->find_element( "table",             'css' );
            $Selenium->find_element( "table thead tr th", 'css' );
            $Selenium->find_element( "table tbody tr td", 'css' );

            # check for test created change
            $Self->True(
                index( $Selenium->get_page_source(), $WorkOrderTitleRandom ) > -1,
                "$WorkOrderTitleRandom - found",
            );

            # delete created test change
            my $Success = $ChangeObject->ChangeDelete(
                ChangeID => $ChangeID,
                UserID   => 1,
            );
            $Self->True(
                $Success,
                "$ChangeTitleRandom - deleted",
            );
        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'ITSMChange*' );
    }

);

1;
