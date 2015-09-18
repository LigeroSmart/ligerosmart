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

        # create and log in test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-manager' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # naviage to AgentITSMChangeAdd screen
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentITSMChangeAdd");

        # check page
        for my $ID (
            qw(ChangeTitle RichText1 RichText2 CategoryID ImpactID PriorityID RequestedTimeUsed
            RequestedTimeMonth RequestedTimeDay RequestedTimeYear RequestedTimeHour RequestedTimeMinute
            FileUpload SubmitChangeAdd)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # get category ID '5 very high'
        my $CategoryDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Category',
            Name  => '5 very high',
        );

        # get impact ID '4 very high'
        my $ImpactDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Impact',
            Name  => '4 high',
        );

        # create test change
        my $ChangeTitleRandom = "SeleniumChange " . $Helper->GetRandomID();
        $Selenium->find_element( "#ChangeTitle", 'css' )->send_keys($ChangeTitleRandom);
        $Selenium->find_element( "#RichText1",   'css' )->send_keys('SeleniumDescription');
        $Selenium->find_element( "#RichText2",   'css' )->send_keys('SeleniumJustification');
        $Selenium->execute_script(
            "\$('#CategoryID').val('$CategoryDataRef->{ItemID}').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script(
            "\$('#ImpactID').val('$ImpactDataRef->{ItemID}').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#SubmitChangeAdd", 'css' )->click();

        # check created test change values
        $Self->True(
            index( $Selenium->get_page_source(), $ChangeTitleRandom ) > -1,
            "$ChangeTitleRandom - found",
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('p:contains(5 very high)').length"
            ),
            "Test Change value category 5 very high - found",
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('p:contains(4 high)').length"
            ),
            "Test Change value impact 4 high - found",
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # get created test change ID
        my $ChangeQuoted = $DBObject->Quote($ChangeTitleRandom);
        $DBObject->Prepare(
            SQL  => "SELECT id FROM change_item WHERE title = ?",
            Bind => [ \$ChangeQuoted ]
        );
        my $ChangeID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $ChangeID = $Row[0];
        }

        # delete created test change
        my $Success = $Kernel::OM->Get('Kernel::System::ITSMChange')->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "$ChangeTitleRandom - deleted",
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'ITSMChange*' );
    }
);

1;
