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

use vars qw($Self);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $SurveyObject         = $Kernel::OM->Get('Kernel::System::Survey');
my $QueueObject          = $Kernel::OM->Get('Kernel::System::Queue');
my $DBObject             = $Kernel::OM->Get('Kernel::System::DB');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

$HelperObject->ConfigSettingChange(
    Valid => 1,
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

$HelperObject->ConfigSettingChange(
    Valid => 1,
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

$HelperObject->ConfigSettingChange(
    Valid => 1,
    Key   => 'Survey::SendInHoursAfterClose',
    Value => 0,
);

my $QueueRand = 'SomeQueue' . $HelperObject->GetRandomID();
my $QueueID   = $QueueObject->QueueAdd(
    Name            => $QueueRand,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    UserID          => 1,
    Comment         => 'Some Comment',
);

$Self->True(
    $QueueID,
    "QueueAdd() - $QueueRand, $QueueID",
);

# Create a ticket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    QueueID      => $QueueID,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'unittest@otrs.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()',
);

my %ArticleTemplate = (
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    UserID               => 1,
    ContentType          => 'text/plain; charset=ISO-8859-1',
    HistoryType          => 'AddNote',
    HistoryComment       => 'Some free text!',
    NoAgentNotify        => 1,                                  # if you don't want to send agent notifications

);

my @AddedArticleIDs;

my $ArticleID = $ArticleBackendObject->ArticleCreate(
    %ArticleTemplate,
    IsVisibleForCustomer => 0,
    From                 => 'Some Agent <agent@example.com>',
    To                   => 'Some Customer A <aaa@example.com>',
    Cc                   => 'Some Customer B <bbb@example.com>',
    Bcc                  => 'Some Customer C <ccc@example.com>',
    ReplyTo              => 'Some Customer D <ddd@example.com>',
    Subject              => "One1",
    Body                 => "Body Uno",
    MessageID            => '<abc.123@example.com>',
    InReplyTo            => '<abc.12@example.com>',
    References           => '<abc.1@example.com> <abc.12@example.com>',
);

# Create survey.
my %SurveyData = (
    Title               => 'A Title',
    Introduction        => 'The introduction of the survey',
    Description         => 'The internal description of the survey',
    NotificationSender  => 'quality@unittest.com',
    NotificationSubject => 'Help us with your feedback! ÄÖÜ',
    NotificationBody    => 'Dear customer... äöü',
);

my $SurveyID = $SurveyObject->SurveyAdd(
    UserID => 1,
    %SurveyData,
);
$Self->True(
    $SurveyID,
    "SurveyAdd()",
);

for ( 1 .. 3 ) {
    my $QuestionAdd = $SurveyObject->QuestionAdd(
        UserID   => 1,
        SurveyID => $SurveyID,
        Question => 'The Question',
        Type     => 'Radio',
    );
}
my @List = $SurveyObject->QuestionList(
    SurveyID => $SurveyID,
);
for my $Question (@List) {
    for ( 1 .. 3 ) {
        $SurveyObject->AnswerAdd(
            UserID         => 1,
            QuestionID     => $Question->{QuestionID},
            Answer         => 'The Answer',
            AnswerRequired => 1,
        );
    }
}

my $StatusSet = $SurveyObject->SurveyStatusSet(
    SurveyID  => $SurveyID,
    NewStatus => 'Master'
);
$Self->Is(
    $StatusSet,
    'StatusSet',
    "SurveyStatusSet()",
);

my $Success = $SurveyObject->RequestSend(
    TicketID => $TicketID,
);
$Self->True(
    $Success,
    "RequestSend()",
);

# Get the RequestID.
return if !$DBObject->Prepare(
    SQL => '
        SELECT id, public_survey_key
        FROM survey_request
        WHERE ticket_id = ?
            AND survey_id = ?',
    Bind  => [ \$TicketID, \$SurveyID ],
    Limit => 1,
);
my $RequestID;
my $RequestKey;
while ( my @Row = $DBObject->FetchrowArray() ) {
    $RequestID  = $Row[0];
    $RequestKey = $Row[1];
}

# Add some answers to the questions
my @QuestionList = $SurveyObject->QuestionList(
    SurveyID => $SurveyID,
);

for my $Count ( 1 .. 10 ) {

    # Simulate votes.
    for my $Question (@QuestionList) {
        my $Success = $SurveyObject->PublicAnswerSet(
            PublicSurveyKey => $RequestKey,
            QuestionID      => $Question->{QuestionID},
            VoteValue       => 'The Value',
        );
        $Self->True(
            $Success,
            "PublicAnswerSet() $Count for Question $Question->{QuestionID}",
        );
    }

    my @VotesList = $SurveyObject->VoteGetAll(
        RequestID => $RequestID,
    );
    $Self->Is(
        scalar @VotesList,
        scalar @QuestionList * $Count,
        "VoteGetAll() $Count records",
    );

    my $RecordNumber = 1;
    for my $Vote (@VotesList) {

        for my $Attribute (qw(VoteID VoteValue QuestionID Question QuestionType)) {
            $Self->IsNot(
                $Vote->{$Attribute} // '',
                '',
                "VoteGetAll() $Count vote $RecordNumber $Attribute",
            );
        }
        $RecordNumber++;
    }
}

1;
