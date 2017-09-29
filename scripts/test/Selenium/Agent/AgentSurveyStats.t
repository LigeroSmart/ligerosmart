# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # do not really send emails
        $Helper->ConfigSettingChange(
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::DoNotSendEmail',
        );

        # Do not check email adresses in this test.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # set send period to always send survey
        $Helper->ConfigSettingChange(
            Key   => 'Survey::SendPeriod',
            Value => 0,
        );

        # Set no send condition check in normal tests.
        $Helper->ConfigSettingChange(
            Key   => 'Survey::CheckSendConditionTicketType',
            Value => 0,
        );

        # Create test Survey.
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
            "Survey ID $SurveyID is created",
        );

        # Add question to test Survey.
        my $QuestionName = 'Question ' . $Helper->GetRandomID();
        $SurveyObject->QuestionAdd(
            UserID         => 1,
            SurveyID       => $SurveyID,
            Question       => $QuestionName,
            AnswerRequired => 1,
            Type           => 'YesNo',
        );

        # Get QuestionID from the test Survey.
        my @QuestionList = $SurveyObject->QuestionList(
            SurveyID => $SurveyID,
        );
        my $QuestionID = $QuestionList[0]->{QuestionID};

        # Set test Survey on master status.
        my $StatusSet = $SurveyObject->SurveyStatusSet(
            SurveyID  => $SurveyID,
            NewStatus => 'Master'
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
        my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
        my $ScriptAlias  = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
        #     ChannelName => 'Email',
        # );

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
                "Ticket ID $TicketID is created",
            );
            push @TicketIDs,     $TicketID;
            push @TicketNumbers, $TicketNumber;

            my $ArticleInternalBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
                ChannelName => 'Internal',
            );

            # Add article to test created ticket.
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
                "Article ID $ArticleID is created",
            );

            # Send Survey request.
            my $Request = $SurveyObject->RequestSend(
                TicketID => $TicketID,
            );

            $Self->True(
                $Request,
                "Survey request is sent",
            );

            # get DB object
            my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

            # Get public Survey key from test Survey request
            $DBObject->Prepare(
                SQL  => "SELECT public_survey_key FROM survey_request WHERE survey_id = ?",
                Bind => [ \$SurveyID ],
            );
            my $PublicSurveyKey;
            while ( my @Row = $DBObject->FetchrowArray() ) {
                $PublicSurveyKey = $Row[0];
            }

            $Kernel::OM->Get('Kernel::System::Log')
                ->Dumper( 'Debug - ModuleName', '$PublicSurveyKey', \$PublicSurveyKey );

            # Create public answer votes.
            if ( $Count == '1' ) {

                # Navigate to PublicSurvey of created test Survey, add public answer via frontend.
                $Selenium->VerifiedGet("${ScriptAlias}public.pl?Action=PublicSurvey;PublicSurveyKey=$PublicSurveyKey");

                # Select 'Yes' as answer.
                $Selenium->find_element("//input[\@value='Yes'][\@type='radio']")->VerifiedClick();
                $Selenium->find_element("//button[\@value='Finish'][\@type='submit']")->VerifiedClick();
            }
            else {

                # Sleep one second between public answer.
                sleep 1;

                # Add public vote via backend.
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

        # Navigate to AgentSurveyZoom of created test Survey.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentSurveyZoom;SurveyID=$SurveyID");

        # Click on Survey 'Stats Details' and switch window.
        $Selenium->find_element( "#Menu030-StatsDetails", 'css' )->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until popup is completely loaded.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete',
        );

        # Wait until details are present.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".SeeDetails").length' );

        # Check screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Verify stats are for right ticket.
        for my $TicketNumber (@TicketNumbers) {
            $Self->True(
                index( $Selenium->get_page_source(), $TicketNumber ) > -1,
                "Ticket number $TicketNumber is found",
            );
        }

        # Click to see details of Survey.
        $Selenium->find_element("//a[contains(\@href, 'TicketNumber=$TicketNumbers[2]' )]")->VerifiedClick();

        # Verify question values.
        $Self->True(
            index( $Selenium->get_page_source(), $QuestionName ) > -1,
            "$QuestionName is found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), 'Yes' ) > -1,
            "Answer 'Yes' is found",
        );

        # Check if 'Previous Vote' exists.
        $Self->False(
            $Selenium->execute_script("return \$('.SurveyArrowLeft').length"),
            "'Previous Vote' is not found for first answer",
        );

        # Check if 'next Vote' exist.
        $Self->True(
            $Selenium->execute_script("return \$('.SurveyArrowRight').length"),
            "'Next Vote' is found for first answer",
        );

        # Click on the Next Vote link.
        $Selenium->find_element("//a[contains(\@href, 'TicketNumber=$TicketNumbers[1]' )]")->VerifiedClick();

        # Check if Ticket number is correct, and links to 'Previous Vote' and 'Next Vote' exist.
        $Self->True(
            index( $Selenium->get_page_source(), "$TicketNumbers[1]" ) > -1,
            "Ticket number $TicketNumbers[1] is found",
        );

        $Self->True(
            $Selenium->execute_script("return \$('.SurveyArrowLeft').length"),
            "'Previous Vote' is found for second answer",
        );
        $Self->True(
            $Selenium->execute_script("return \$('.SurveyArrowRight').length"),
            "'Next Vote' is found for second answer",
        );

        # Go to next vote.
        $Selenium->find_element("//a[contains(\@href, 'TicketNumber=$TicketNumbers[0]' )]")->VerifiedClick();

        # Check if Ticket number is correct, 'Previous Vote' exists, and 'Next Vote' does not exists.
        $Self->True(
            index( $Selenium->get_page_source(), "$TicketNumbers[0]" ) > -1,
            "Ticket number $TicketNumbers[0] is found",
        );
        $Self->True(
            $Selenium->execute_script("return \$('.SurveyArrowLeft').length"),
            "'Previous Vote' is found for third answer",
        );
        $Self->False(
            $Selenium->execute_script("return \$('.SurveyArrowRight').length"),
            "'Next Vote' is not found for third answer",
        );

        # Get clean-up data.
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

        # Delete test created tickets.
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

        # Delete test data from DB.
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
