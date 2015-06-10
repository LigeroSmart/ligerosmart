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
                }
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # disable PDF output
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'PDF',
            Value => 0
        );

        # create and log in test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-service' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # create test SLA
        my $SLAName = "SLA" . $Helper->GetRandomID();
        my $SLAID   = $Kernel::OM->Get('Kernel::System::SLA')->SLAAdd(
            Name              => $SLAName,
            ValidID           => 1,
            FirstResponseTime => 120,
            UpdateTime        => 180,
            SolutionTime      => 580,
            Comment           => 'Selenium test SLA',
            TypeID            => 2,
            UserID            => 1,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentITSMSLAZoom screen
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentITSMSLAZoom;SLAID=$SLAID");

        # click on print
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMSLAPrint;SLAID=$SLAID\' )]");

        # switch to another window
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # check for printed values of test SLA
        $Self->True(
            index( $Selenium->get_page_source(), "SLA: $SLAName" ) > -1,
            "Service: $SLAName - found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Calendar Default" ) > -1,
            "Calendar: Calendar Default - found",
        );

        my @RespondTime = ( 120, 180, 580 );
        for my $Time (@RespondTime) {
            $Self->True(
                index( $Selenium->get_page_source(), $Time . " minutes" ) > -1,
                "Respond $Time minutes - found",
            );
        }

        # delete test SLA
        my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "DELETE FROM sla WHERE id = $SLAID",
        );
        $Self->True(
            $Success,
            "Deleted SLA - $SLAID",
        );

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'SLA'
        );

    }
);

1;
