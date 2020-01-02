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

# get needed objects
my $DBObject      = $Kernel::OM->Get('Kernel::System::DB');
my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $SurveyObject  = $Kernel::OM->Get('Kernel::System::Survey');
my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Survey::RequestsDelete');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get random
my $RandomName = $Helper->GetRandomID() . '_testuser';

# set config
$ConfigObject->Set(
    Valid => 1,
    Key   => 'Survey::DeletePeriod',
    Value => 50,                       # older 50 days
);

# create ticket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
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

# add survey
my $SurveyID = $SurveyObject->SurveyAdd(
    UserID              => 1,
    Title               => 'A Title',
    Introduction        => 'The introduction of the survey',
    Description         => 'The internal description of the survey',
    NotificationSender  => 'quality@example.com',
    NotificationSubject => 'Help us with your feedback!',
    NotificationBody    => 'Dear customer...',
);
$Self->True(
    $SurveyID,
    'SurveyAdd()',
);

# add question
my $QuestionID = $SurveyObject->QuestionAdd(
    UserID         => 1,
    SurveyID       => $SurveyID,
    Question       => 'The Question',
    AnswerRequired => 1,
    Type           => 'Radio',
);
$Self->True(
    $QuestionID,
    'QuestionAdd()',
);

my $OlderDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
$OlderDateTimeObject->Subtract(
    Days => 50,
);
$OlderDateTimeObject->Set(
    Hour   => '23',
    Minute => '59',
    Second => '59',
);

my $RequestCreateTimeOlderDate = $OlderDateTimeObject->ToString();

# add requests
for ( 1 ... 10 ) {

    # insert data
    my $InsertRequests = $DBObject->Do(
        SQL => '
            INSERT INTO survey_request (ticket_id, survey_id, valid_id, public_survey_key,
                send_to, send_time, vote_time, create_time)
            VALUES (?, ?, 1, ?, ?, current_timestamp, current_timestamp, ?)',
        Bind => [ \$TicketID, \$SurveyID, \$Helper->GetRandomID(), \$RandomName, \$RequestCreateTimeOlderDate ],
    );
    $Self->True(
        $InsertRequests,
        "Survey requests added.",
    );
}

# init request id array
# select latest request ids
my @RequestIDs;

$DBObject->Prepare(
    SQL => "SELECT id FROM survey_request WHERE create_time = '$RequestCreateTimeOlderDate' ",
);

while ( my @Row = $DBObject->FetchrowArray() ) {
    push @RequestIDs, $Row[0];
}

for my $RequestID (@RequestIDs) {

    # insert data
    my $InsertVotes = $DBObject->Do(
        SQL => '
            INSERT INTO survey_vote (request_id, question_id, vote_value, create_time)
            VALUES (?, ?, 1, ?)',
        Bind => [ \$RequestID, \$QuestionID, \$RequestCreateTimeOlderDate ],
    );
    $Self->True(
        $InsertVotes,
        "Survey votes added.",
    );
}

# init vote id array
# select latest vote ids
my @VoteIDs;

$DBObject->Prepare(
    SQL => "SELECT id FROM survey_vote WHERE create_time = '$RequestCreateTimeOlderDate' ",
);

while ( my @Row = $DBObject->FetchrowArray() ) {
    push @VoteIDs, $Row[0];
}

# store ids
my %DeletedIDs = (
    RequestIDs => \@RequestIDs,
    VoteIDs    => \@VoteIDs,
);

# execute command
my $ExitCode = $CommandObject->Execute('--force');

# check if delete done
for my $Check ( sort keys %DeletedIDs ) {

    for my $DeletedRequestID ( @{ $DeletedIDs{RequestIDs} } ) {

        $DBObject->Prepare(
            SQL  => "SELECT COUNT(id) FROM survey_request WHERE id = ? ",
            Bind => [ \$DeletedRequestID ]
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Self->Is(
                $Row[0],
                0,
                "Requests deleted",
            );
        }
    }

    for my $DeletedVoteID ( @{ $DeletedIDs{VoteIDs} } ) {

        $DBObject->Prepare(
            SQL  => "SELECT COUNT(id) FROM survey_vote WHERE id = ? ",
            Bind => [ \$DeletedVoteID ]
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Self->Is(
                $Row[0],
                0,
                "Votes deleted",
            );
        }
    }
}

$Self->Is(
    $ExitCode,
    0,
    "Requests delete - ExitCode",
);

1;
