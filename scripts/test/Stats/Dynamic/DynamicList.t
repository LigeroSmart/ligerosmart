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

use Data::Dumper;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Create local config object.
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Set send period to always send survey.
$HelperObject->ConfigSettingChange(
    Key   => 'Survey::SendPeriod',
    Value => 0,
);

# Disable email check.
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# Set send period to send immediately after ticket close.
$ConfigObject->Set(
    Key   => 'Survey::SendInHoursAfterClose',
    Value => 0,
);

# Freeze Time.
$HelperObject->FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2018-06-20 12:00:00',
        },
    )->ToEpoch()
);

my $RandomID = $HelperObject->GetRandomID();

# Creating Queue.
my $QueueRand = "SomeQueue$RandomID ";
my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
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

# Setup survey.
my $SurveyTitle = "A Title$RandomID ";
my %SurveyData  = (
    Title               => $SurveyTitle,
    Introduction        => 'The introduction of the survey',
    Description         => 'The internal description of the survey',
    NotificationSender  => 'quality@unittest.com',
    NotificationSubject => 'Help us with your feedback!',
    NotificationBody    => 'Dear customer...',
    Queues              => [$QueueID],
);

# Get survey object.
my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');

# Create survey.
my $SurveyID = $SurveyObject->SurveyAdd(
    UserID => 1,
    %SurveyData,
);
$Self->True(
    $SurveyID,
    "SurveyAdd()",
);

# Add question to survey.
my $QuestionAdd = $SurveyObject->QuestionAdd(
    UserID         => 1,
    SurveyID       => $SurveyID,
    Question       => 'The Question',
    AnswerRequired => 0,
    Type           => 'Textarea',
);

# Setup survey to Master.
my $StatusSet = $SurveyObject->SurveyStatusSet(
    SurveyID  => $SurveyID,
    NewStatus => 'Master',
);
$Self->Is(
    $StatusSet,
    'StatusSet',
    "SurveyStatusSet()",
);

# Get list of questions.
my @List = $SurveyObject->QuestionList(
    SurveyID => $SurveyID,
);

# Get created survey.
my %SurveyGet = $SurveyObject->SurveyGet(
    SurveyID => $SurveyID,
);

# Generate Dynamic list test statistic.
my $StatsObject  = $Kernel::OM->Get('Kernel::System::Stats');
my $SurveyStatID = $StatsObject->StatsAdd(
    UserID => 1,
);
$Self->True(
    $SurveyStatID,
    'StatsAdd()',
);

# Creating ticket.
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');

my $TicketID = $TicketObject->TicketCreate(
    Title        => "Some Ticket Title$RandomID",
    QueueID      => $QueueID,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    "TicketCreate() for TicketID $TicketID",
);

my $ArticleObject                = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleInternalBackendObject = $ArticleObject->BackendForChannel(
    ChannelName => 'Phone',
);

my $ArticleID = $ArticleInternalBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 1,
    SenderType           => 'customer',
    From                 => 'Some Customer <email@example.com>',
    To                   => 'Some Agent <agent@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'AddNote',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
);
$Self->True(
    $ArticleID,
    "ArticleCreate() for ArticleID $ArticleID",
);

# Set ticket state to close.
my $Success = $TicketObject->TicketStateSet(
    State    => 'closed successful',
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Success,
    "Ticket is closed successfully.",
);

# Send survey request.
$Success = $SurveyObject->RequestSend(
    TicketID => $TicketID,
);
$Self->True(
    $Success,
    "Request is sent successfully.",
);

# Set survey public answer.
$DBObject->Prepare(
    SQL => '
        SELECT public_survey_key
        FROM survey_request
        WHERE ticket_id = ?',
    Bind  => [ \$TicketID ],
    Limit => 1,
);

my $PublicSurveyKey;
while ( my @Row = $DBObject->FetchrowArray() ) {
    $PublicSurveyKey = $Row[0];
}

$Success = $SurveyObject->PublicAnswerSet(
    PublicSurveyKey => $PublicSurveyKey,
    QuestionID      => $List[0]{QuestionID},
    VoteValue       => 'Some answer',
);

$Self->True(
    $Success,
    "Public answer is set successfully.",
);

# Update created survey stat.
my $UpdateSuccess = $StatsObject->StatsUpdate(
    StatID => $SurveyStatID,
    Hash   => {
        Title        => "Title for result tests$RandomID",
        Description  => 'some Description',
        TimeZone     => 'UTC',
        TimeStamp    => '2018-06-20 12:00:00',
        Object       => 'SurveyList',
        ObjectName   => 'SurveyList',
        Format       => 'CSV',
        ObjectModule => 'Kernel::System::Stats::Dynamic::SurveyList',
        StatType     => 'dynamic',
        Cache        => 1,
        Valid        => 1,
        Permission   => [
            '3'
        ],
        UseAsXvalue => [
            {
                Sort           => 'IndividualKey',
                Block          => 'MultiSelectField',
                Selected       => 1,
                Element        => 'SurveyAttributes',
                Name           => 'Attributes to be printed',
                SortIndividual => [
                    'Created',
                ],
                Values => {

                    Created => 'Create Time',

                },
                Translation    => 1,
                SelectedValues => [
                    'Created',
                ]
            }
        ],
        UseAsValueSeries => [
            {
                Name           => 'Sort sequence',
                Translation    => 1,
                SelectedValues => [
                    'Up'
                ],
                Block    => 'SelectField',
                Selected => 1,
                Element  => 'SortSequence',
                Values   => {
                    'Up' => 'ascending'
                }
            }
        ],
        UseAsRestriction => [
            {
                Values => {
                    $SurveyID => $SurveyTitle,

                },
                Selected       => 1,
                SelectedValues => [
                    $SurveyID
                ],
                Translation => 1,
                Block       => 'SelectField',
                Element     => 'SurveyIDs',
                Fixed       => 1,
                Name        => 'Survey List'
            }
        ],
    },
    UserID => 1,
);
$Self->True(
    $UpdateSuccess,
    'StatsUpdate()',
);

# Setup of test cases.
my @Tests = (
    {
        TimeZone  => 'UTC',
        TimeStamp => '2018-06-20 12:00:00 (UTC)',
    },
    {
        TimeZone  => 'Europe/Belgrade',
        TimeStamp => '2018-06-20 14:00:00 (Europe/Belgrade)',
    },
    {
        TimeZone  => 'America/New_York',
        TimeStamp => '2018-06-20 08:00:00 (America/New_York)',
    },
);

# Setup dynamic statistic with SurveyList object.
for my $Time (@Tests) {
    my $UpdateSuccess = $StatsObject->StatsUpdate(
        StatID => $SurveyStatID,
        Hash   => {
            TimeZone => $Time->{TimeZone},
        },
        UserID => 1,
    );
    $Self->True(
        $UpdateSuccess,
        'StatsUpdate()',
    );

    # Get all the stat data.
    my $Stat = $StatsObject->StatsGet(
        StatID => $SurveyStatID,
    );

    my @ResultData = $StatsObject->StatsRun(
        StatID   => $SurveyStatID,
        GetParam => $Stat,
        UserID   => 1,
    );

    $Self->Is(
        $ResultData[0][2][0],
        $Time->{TimeStamp},
        "Time zone is set correctly to: $Time->{TimeStamp}",
    );
}

1;
