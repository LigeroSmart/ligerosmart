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

# Get Selenium object.
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ChangeObject = $Kernel::OM->Get('Kernel::System::ITSMChange');

        # Get change state data.
        my $ChangeDataRef = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
            Class => 'ITSM::ChangeManagement::Change::State',
            Name  => 'requested',
        );

        # Create test change.
        my $ChangeTitleRandom = 'ITSMChange Requested ' . $Helper->GetRandomID();
        my $ChangeID          = $ChangeObject->ChangeAdd(
            ChangeTitle   => $ChangeTitleRandom,
            Description   => 'Selenium Test Description',
            Justification => 'Selenium Test Justification',
            ChangeStateID => $ChangeDataRef->{ItemID},
            UserID        => 1,
        );
        $Self->True(
            $ChangeID,
            "$ChangeTitleRandom is created",
        );

        # Get test created change data.
        my $ChangeData = $ChangeObject->ChangeGet(
            ChangeID => $ChangeID,
            UserID   => 1,
        );

        # Create and login as test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-change', 'itsm-change-manager' ],
        ) || die "Did not get test builder user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get script alias.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentITSMChangeSearch.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMChangeSearch");

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # Check change search page.
        for my $ID (
            qw(SearchProfile SearchProfileNew Attribute ResultForm SearchFormSubmit)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Input change title and number as search param and run it.
        $Selenium->execute_script(
            "\$('#Attribute').val('ChangeTitle').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('input[name=\"ChangeTitle\"]').length"
        );

        # Check if ITSMChange Search form contain Excel output option, see bug#12769.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#ResultForm option:contains(\"Excel\")').length"
            ),
            '1',
            'ITSMChange Search contain Excel output',
        );

        $Selenium->find_element( "ChangeNumber",      'name' )->send_keys( $ChangeData->{ChangeNumber} );
        $Selenium->find_element( "ChangeTitle",       'name' )->send_keys( $ChangeData->{ChangeTitle} );
        $Selenium->find_element( "#SearchFormSubmit", 'css' )->VerifiedClick();

        # Check for expected result.
        $Self->True(
            index( $Selenium->get_page_source(), $ChangeTitleRandom ) > -1,
            "$ChangeTitleRandom is found",
        );

        # Navigate to AgentITSMChangeSearch.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMChangeSearch");

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # Input wrong search parameters, result should be 'No data found'.
        $Selenium->find_element( "ChangeNumber",      'name' )->send_keys("123455678");
        $Selenium->find_element( "#SearchFormSubmit", 'css' )->VerifiedClick();

        # Check for expected result.
        $Self->True(
            index( $Selenium->get_page_source(), "No data found." ) > -1,
            "Change is not found",
        );

        # Delete created test change.
        my $Success = $ChangeObject->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "$ChangeTitleRandom is deleted",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'ITSMChange*' );
    }
);

1;
