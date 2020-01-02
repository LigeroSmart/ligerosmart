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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Do not really send emails.
        $Helper->ConfigSettingChange(
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::DoNotSendEmail',
        );

        # Do not check email addresses in this test.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Set send period to zero to always send survey.
        $Helper->ConfigSettingChange(
            Key   => 'Survey::SendPeriod',
            Value => 0,
        );

        # Set no send condition check in normal tests.
        $Helper->ConfigSettingChange(
            Key   => 'Survey::CheckSendConditionTicketType',
            Value => 0,
        );

        # Create test survey.
        my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');
        my $SurveyTitle  = 'Survey ' . $Helper->GetRandomID();
        my $SurveyID     = $SurveyObject->SurveyAdd(
            UserID              => 1,
            Title               => $SurveyTitle,
            Introduction        => 'Survey Introduction',
            Description         => 'Survey Description',
            NotificationSender  => 'quality@unittest.com',
            NotificationSubject => 'Survey Notification Subject',
            NotificationBody    => 'Survey Notification Body',
            Queues              => [2],
        );
        $Self->True(
            $SurveyID,
            "Survey ID $SurveyID is created"
        );

        # Add question to test survey.
        my $QuestionName = 'Question ' . $Helper->GetRandomID();
        $SurveyObject->QuestionAdd(
            UserID         => 1,
            SurveyID       => $SurveyID,
            Question       => $QuestionName,
            AnswerRequired => 1,
            Type           => 'YesNo',
        );

        # Get question ID from the test survey.
        my @QuestionList = $SurveyObject->QuestionList(
            SurveyID => $SurveyID,
        );
        my $QuestionID = $QuestionList[0]->{QuestionID};

        # Set test survey on master status.
        my $StatusSet = $SurveyObject->SurveyStatusSet(
            SurveyID  => $SurveyID,
            NewStatus => 'Master',
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
        my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');

        my $ArticleInternalBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Internal',
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        my @TicketNumbers;
        my @TicketIDs;
        for my $Count ( 1 .. 3 ) {

            # Create test ticket.
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN           => $TicketNumber,
                Title        => "Selenium Test Ticket",
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'new',
                CustomerID   => 'SeleniumCustomer',
                CustomerUser => 'test@localhost.com',
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "Ticket ID $TicketID is created"
            );
            push @TicketIDs,     $TicketID;
            push @TicketNumbers, $TicketNumber;

            # Add article to test ticket.
            my $ArticleID = $ArticleInternalBackendObject->ArticleCreate(
                TicketID             => $TicketID,
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                From                 => 'Some Agent <email@example.com>',
                To                   => 'Customer<customer-a@example.com>',
                Cc                   => 'Customer<customer-b@example.com>',
                ReplyTo              => 'Customer B <customer-b@example.com>',
                Subject              => 'some short description',
                Body                 => 'the message text Perl modules provide a range of',
                ContentType          => 'text/plain; charset=ISO-8859-15',
                HistoryType          => 'OwnerUpdate',
                HistoryComment       => 'Some free text!',
                UserID               => 1,
                NoAgentNotify        => 1,
                Charset              => 'utf8',
                MimeType             => 'text/plain',
            );

            $Self->True(
                $TicketID,
                "Article ID $ArticleID is created"
            );

            # Send survey request.
            my $Request = $SurveyObject->RequestSend(
                TicketID => $TicketID,
            );

            $Self->True(
                $Request,
                'Survey request is sent'
            );

            # Get public survey key from test survey request.
            $DBObject->Prepare(
                SQL  => "SELECT public_survey_key FROM survey_request WHERE survey_id = ? AND ticket_id = ?",
                Bind => [ \$SurveyID, \$TicketID ],
            );
            my $PublicSurveyKey;
            while ( my @Row = $DBObject->FetchrowArray() ) {
                $PublicSurveyKey = $Row[0];
            }

            # Create public answer votes.
            if ( $Count == '1' ) {

                # Navigate to public page of created test survey and add public answer via frontend.
                $Selenium->VerifiedGet("${ScriptAlias}public.pl?Action=PublicSurvey;PublicSurveyKey=$PublicSurveyKey");

                # Select 'Yes' as an answer.
                $Selenium->find_element("//input[\@value='Yes'][\@type='radio']")->click();
                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('input[value=Yes][type=radio]:checked').length"
                );

                $Selenium->find_element("//button[\@value='Finish'][\@type='submit']")->VerifiedClick();
            }

            # Add public vote via backend.
            else {

                # Sleep one second between public answer.
                sleep 1;

                $SurveyObject->PublicAnswerSet(
                    PublicSurveyKey => $PublicSurveyKey,
                    QuestionID      => $QuestionID,
                    VoteValue       => 'Yes',
                );

                $SurveyObject->PublicSurveyInvalidSet(
                    PublicSurveyKey => $PublicSurveyKey,
                );
            }
        }

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Navigate to zoom screen of created test survey.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentSurveyZoom;SurveyID=$SurveyID");

        # Click on survey 'Stats Details' and switch window.
        $Selenium->find_element( "#Menu030-StatsDetails", 'css' )->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until details are present.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".SeeDetails").length' );

        # Check screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Verify stats are present for all tickets.
        for my $TicketNumber (@TicketNumbers) {
            $Self->True(
                index( $Selenium->get_page_source(), $TicketNumber ) > -1,
                "Ticket number $TicketNumber is found"
            );
        }

        # Click to see details of survey.
        $Selenium->find_element("//a[contains(\@href, 'TicketNumber=$TicketNumbers[2]' )]")->click();
        $Selenium->WaitFor( JavaScript => "return \$('.Header h1:contains($TicketNumbers[2])').length" );

        # Verify question values.
        $Self->True(
            index( $Selenium->get_page_source(), $QuestionName ) > -1,
            "$QuestionName is found"
        );
        $Self->True(
            index( $Selenium->get_page_source(), 'Yes' ) > -1,
            "Answer 'Yes' is found"
        );

        # Check if 'Previous Vote' exists.
        $Self->False(
            $Selenium->execute_script("return \$('.SurveyArrowLeft').length"),
            "'Previous Vote' is not found for first answer"
        );

        # Check if 'Next Vote' exists.
        $Self->True(
            $Selenium->execute_script("return \$('.SurveyArrowRight').length"),
            "'Next Vote' is found for first answer"
        );

        # Click on the 'Next Vote' link.
        $Selenium->find_element("//a[contains(\@href, 'TicketNumber=$TicketNumbers[1]' )]")->click();
        $Selenium->WaitFor( JavaScript => "return \$('.Header h1:contains($TicketNumbers[1])').length" );

        # Check if ticket number is correct, and links to 'Previous Vote' and 'Next Vote' exist.
        $Self->True(
            index( $Selenium->get_page_source(), "$TicketNumbers[1]" ) > -1,
            "Ticket number $TicketNumbers[1] is found"
        );

        $Self->True(
            $Selenium->execute_script("return \$('.SurveyArrowLeft').length"),
            "'Previous Vote' is found for second answer"
        );
        $Self->True(
            $Selenium->execute_script("return \$('.SurveyArrowRight').length"),
            "'Next Vote' is found for second answer"
        );

        # Go to next vote.
        $Selenium->find_element("//a[contains(\@href, 'TicketNumber=$TicketNumbers[0]' )]")->click();
        $Selenium->WaitFor( JavaScript => "return \$('.Header h1:contains($TicketNumbers[0])').length" );

        # Check if ticket number is correct, 'Previous Vote' exists and 'Next Vote' does not exist.
        $Self->True(
            index( $Selenium->get_page_source(), "$TicketNumbers[0]" ) > -1,
            "Ticket number $TicketNumbers[0] is found"
        );
        $Self->True(
            $Selenium->execute_script("return \$('.SurveyArrowLeft').length"),
            "'Previous Vote' is found for third answer"
        );
        $Self->False(
            $Selenium->execute_script("return \$('.SurveyArrowRight').length"),
            "'Next Vote' is not found for third answer"
        );

        # Define data for cleanup.
        my @CleanData = (
            {
                Name  => 'Queue',
                Table => 'survey_queue',
                SQLID => 'survey_id',
                ID    => $SurveyID,
            },
            {
                Name  => 'Answer',
                Table => 'survey_answer',
                SQLID => 'question_id',
                ID    => $QuestionID,
            },
            {
                Name  => 'Question',
                Table => 'survey_question',
                SQLID => 'survey_id',
                ID    => $SurveyID,
            },
            {
                Name  => 'Request',
                Table => 'survey_request',
                SQLID => 'survey_id',
                ID    => $SurveyID,
            },
            {
                Name  => 'Vote',
                Table => 'survey_vote',
                SQLID => 'question_id',
                ID    => $QuestionID,
            },
            {
                Name  => 'Survey',
                Table => 'survey',
                SQLID => 'id',
                ID    => $SurveyID,
            },
        );

        # Delete created test tickets.
        my $Success;
        for my $TicketID (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
            $Self->True(
                $Success,
                "TicketID $TicketID is deleted"
            );
        }

        # Delete test survey data from DB.
        for my $Delete (@CleanData) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM $Delete->{Table} WHERE $Delete->{SQLID} = ?",
                Bind => [ \"$Delete->{ID}" ],
            );
            $Self->True(
                $Success,
                "$Delete->{Name} for $SurveyTitle is deleted",
            );
        }
    }
);

1;
