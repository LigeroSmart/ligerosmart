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

        # create test survey
        my $SurveyTitle = 'Survey ' . $Helper->GetRandomID();
        my $SurveyID    = $Kernel::OM->Get('Kernel::System::Survey')->SurveyAdd(
            UserID              => 1,
            Title               => $SurveyTitle,
            Introduction        => 'Survey Introduction',
            Description         => 'Survey Description',
            NotificationSender  => 'svik@example.com',
            NotificationSubject => 'Survey Notification Subject',
            NotificationBody    => 'Survey Notifiation Body',
            Queues              => [2],
        );
        $Self->True(
            $SurveyID,
            "Survey ID $SurveyID - created",
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentSurveyZoom of created test survey
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentSurveyZoom;SurveyID=$SurveyID");

        # click on 'Edit Questions' and switch screen
        $Selenium->find_element( "#Menu020-EditQuestions", 'css' )->click();

        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # check page
        for my $ID (
            qw(Question Type AnswerRequired)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # get test params
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
        );

        # create test questions
        my $Success;
        for my $Questions (@Test) {

            # add question
            $Selenium->find_element( "#Question", 'css' )->send_keys( $Questions->{Name} );
            $Selenium->execute_script(
                "\$('#Type').val('$Questions->{Type}').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element("//button[\@value='Add'][\@type='submit']")->click();

            # add answers for radio and checkbox questions
            if (
                $Questions->{Name} eq 'RadioQuestion'
                || $Questions->{Name} eq 'CheckboxQuestion'
                )
            {

                # verify question is in incomplete state
                $Self->True(
                    index( $Selenium->get_text("//div[\@class='Content']"), 'Incomplete' ) > -1,
                    "$Questions->{Name} - incomplete",
                );

                # click on test created question
                $Selenium->find_element( $Questions->{Name}, 'link_text' )->click();
                $Selenium->find_element( "#Answer",          'css' )->send_keys( $Questions->{Answer1} );
                $Selenium->find_element("//button[\@value='Add'][\@type='submit']")->click();
                $Selenium->find_element( "#Answer", 'css' )->send_keys( $Questions->{Answer2} );
                $Selenium->find_element("//button[\@value='Add'][\@type='submit']")->click();

                # return back to add question screen
                $Selenium->find_element("//button[\@value='Go back'][\@type='submit']")->click();

            }

            # verify question is in complete state
            $Self->True(
                index( $Selenium->get_text("//div[\@class='Content']"), 'Complete' ) > -1,
                "$Questions->{Name} - completed",
            );

            # click on delete icon
            my $CheckConfirmJS = <<"JAVASCRIPT";
(function () {
    var lastConfirm = undefined;
    window.confirm = function (message) {
        lastConfirm = message;
        return true;
    };
}());
JAVASCRIPT
            $Selenium->execute_script($CheckConfirmJS);

            # delete test question
            $Selenium->find_element( ".QuestionDelete", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return $(".Dialog:visible").length === 0;' );

            $Self->True(
                index( $Selenium->get_page_source(), $Questions->{Name} ) == -1,
                "$Questions->{Name} - deleted",
            );

        }

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # clean-up test created survey queue
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM survey_queue WHERE survey_id = ?",
            Bind => [ \$SurveyID ],
        );
        $Self->True(
            $Success,
            "Survey-Queue for $SurveyTitle- deleted",
        );

        # delete test created survey
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM survey WHERE id = ?",
            Bind => [ \$SurveyID ],
        );
        $Self->True(
            $Success,
            "$SurveyTitle - deleted",
        );
    }
);

1;
