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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test survey.
        my $SurveyTitle = 'Survey ' . $Helper->GetRandomID();
        my $SurveyID    = $Kernel::OM->Get('Kernel::System::Survey')->SurveyAdd(
            UserID              => 1,
            Title               => $SurveyTitle,
            Introduction        => 'Survey Introduction',
            Description         => 'Survey Description',
            NotificationSender  => 'svik@example.com',
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

        # Navigate to AgentSurveyZoom of created test survey.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentSurveyZoom;SurveyID=$SurveyID");

        # Click on 'Edit Questions' and switch screen.
        $Selenium->find_element( "#Menu020-EditQuestions", 'css' )->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#AnswerRequired").length' );

        # Check page.
        for my $ID (
            qw(Question Type AnswerRequired)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Get test params.
        my @Test = (
            {
                Name => 'YesNoQuestion',
                Type => 'YesNo',
            },
            {
                Name    => 'RadioQuestion',
                Type    => 'Radio',
                Answer1 => 'Selenium one',
                Answer2 => 'Selenium two',
            },
            {
                Name    => 'CheckboxQuestion',
                Type    => 'Checkbox',
                Answer1 => 'Selenium one',
                Answer2 => 'Selenium two',
            },
            {
                Name => 'TextareaQuestion',
                Type => 'Textarea',
            },
            {
                Name    => 'NPSQuestion',
                Type    => 'NPS',
                Answer1 => 'Selenium one',
                Answer2 => 'Selenium two'
            },
        );

        # Create test questions.
        my $Success;
        for my $Questions (@Test) {

            # Add question.
            $Selenium->find_element( "#Question", 'css' )->send_keys( $Questions->{Name} );
            $Selenium->execute_script(
                "\$('#Type').val('$Questions->{Type}').trigger('redraw.InputField').trigger('change');"
            );
            $Selenium->find_element("//button[\@value='Add'][\@type='submit']")->VerifiedClick();

            # Add answers for radio, check-box and NPS questions.
            if (
                $Questions->{Name} eq 'RadioQuestion'
                || $Questions->{Name} eq 'CheckboxQuestion'
                || $Questions->{Name} eq 'NPSQuestion'
                )
            {

                # Verify question is in incomplete state.
                $Self->True(
                    index( $Selenium->get_text("//div[\@class='Content']"), 'Incomplete' ) > -1,
                    "$Questions->{Name} is incomplete",
                );

                # Click on test created question.
                $Selenium->find_element( $Questions->{Name}, 'link_text' )->VerifiedClick();

                $Selenium->find_element( "#Answer", 'css' )->send_keys( $Questions->{Answer1} );
                $Selenium->find_element("//button[\@value='Add'][\@type='submit']")->VerifiedClick();

                $Selenium->find_element( "#Answer", 'css' )->send_keys( $Questions->{Answer2} );
                $Selenium->find_element("//button[\@value='Add'][\@type='submit']")->VerifiedClick();

                # Return back to add question screen.
                $Selenium->find_element("//button[\@value='Go back'][\@type='submit']")->VerifiedClick();

            }

            # Verify question is in complete state.
            $Self->True(
                index( $Selenium->get_text("//div[\@class='Content']"), 'Complete' ) > -1,
                "$Questions->{Name} is completed",
            );

            # Delete test question.
            $Selenium->find_element( ".QuestionDelete", 'css' )->click();
            $Selenium->WaitFor( AlertPresent => 1 );
            $Selenium->accept_alert();

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && !\$('.DataTable tr:contains(\"$Questions->{Name}\")').length;"
            );

            $Self->True(
                $Selenium->execute_script("return !\$('.DataTable tr:contains(\"$Questions->{Name}\")').length;"),
                "$Questions->{Name} is deleted",
            );

        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Clean-up test created survey queue.
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
