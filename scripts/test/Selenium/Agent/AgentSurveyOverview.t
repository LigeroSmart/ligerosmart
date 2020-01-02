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

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');

        # Create test survey.
        my $SurveyTitle = 'Survey ' . $Helper->GetRandomID();
        my $SurveyID    = $SurveyObject->SurveyAdd(
            UserID              => 1,
            Title               => $SurveyTitle,
            Introduction        => 'Survey Introduction',
            Description         => 'Survey Description',
            NotificationSender  => 'quality@example.com',
            NotificationSubject => 'Survey Notification Subject',
            NotificationBody    => 'Survey Notification Body',
            Queues              => [2],
        );
        $Self->True(
            $SurveyID,
            "Survey ID $SurveyID is created",
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

        # Navigate to AgentSurveyOverview of created test survey.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentSurveyOverview");

        # Check screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check for test created survey.
        $Self->True(
            index( $Selenium->get_page_source(), "$SurveyTitle" ) > -1,
            "$SurveyTitle is found",
        );

        # Click on test created survey.
        $Selenium->find_element("//div[\@title='$SurveyTitle']")->VerifiedClick();

        # Verify we are in AgentSurveyZoom screen.
        my $URLAction = $Selenium->get_current_url();
        $Self->Is(
            index( $URLAction, "Action=AgentSurveyZoom;SurveyID=$SurveyID" ) > -1,
            1,
            "Link from Overview to Zoom view - success",
        );

        # Navigate to AgentSurveyOverview of created test survey.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentSurveyOverview");

        $Selenium->find_element( '#SurveySearch', 'css' )->click();
        my $DialogFound = $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#SurveyOverviewSettingsDialog").length'
        );

        $Self->True(
            $DialogFound,
            'Dialog displayed.'
        );

        # Send SurveyID.
        $Selenium->find_element( '#SurveyOverviewSettingsDialog input[name="Fulltext"]', 'css' )->send_keys($SurveyID);

        # Make sure that following fields are displayed.
        $Selenium->find_element( '#SurveyOverviewSettingsDialog #States_Search', 'css' );
        $Selenium->find_element( '#SurveyOverviewSettingsDialog #NoTimeSet',     'css' );
        $Selenium->find_element( '#SurveyOverviewSettingsDialog #DateRange',     'css' );

        $Selenium->find_element( '#DialogButton1', 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return !$(".Dialog.Modal").length' );

        my $LinkSurveyID = $Selenium->find_element( '.MasterActionLink', 'css' )->get_attribute('innerHTML');
        my $LinkContent  = '';

        if ( $LinkSurveyID =~ m{^\s*(\d+)\s*$} ) {
            $LinkContent = $1;
        }

        $Self->Is(
            $LinkContent,
            $SurveyID + 10000,
            'Crated survey link found.'
        );

        # Check if change status dropdown is modernized.
        # See bug#13741 https://bugs.otrs.org/show_bug.cgi?id=13741
        my $Question   = 'Question ' . $Helper->GetRandomID();
        my $QuestionID = $SurveyObject->QuestionAdd(
            UserID         => 1,
            SurveyID       => $SurveyID,
            Question       => $Question,
            AnswerRequired => 1,
            Type           => 'YesNo',
        );

        # Go to AgentSurveyZoom screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentSurveyZoom;SurveyID=$SurveyID");

        $Selenium->WaitFor( JavaScript => "return \$('#NewStatus.Modernize').length === 1;" );

        $Self->True(
            $Selenium->execute_script("return \$('#NewStatus.Modernize').length === 1;"),
            "'Change Status' dropdown is modernized",
        );

        # Switch status of survey.
        for my $Status (qw(Master Valid)) {

            $Selenium->execute_script('window.Core.App.PageLoadComplete = false;');
            $Selenium->execute_script(
                "\$('#NewStatus').val('$Status').trigger('redraw.InputField').trigger('change');"
            );

            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
            );

            $Self->Is(
                $Selenium->execute_script("return \$('label:contains(Status)').next().text().trim();"),
                "$Status",
                "Survey status is set to $Status"
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete survey question.
        my $Success = $DBObject->Do(
            SQL  => "DELETE FROM survey_question WHERE survey_id = ?",
            Bind => [ \$SurveyID ],
        );
        $Self->True(
            $Success,
            "Survey-Queue for $SurveyTitle is deleted",
        );

        # Clean-up test created survey data.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM survey_queue WHERE survey_id = ?",
            Bind => [ \$SurveyID ],
        );
        $Self->True(
            $Success,
            "Survey-Queue for $SurveyTitle is deleted",
        );

        # Delete test created survey.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM survey WHERE id = ?",
            Bind => [ \$SurveyID ],
        );
        $Self->True(
            $Success,
            "$SurveyTitle is deleted",
        );
    }
);

1;
