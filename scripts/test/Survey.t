# --
# Survey.t - Survey tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Survey.t,v 1.3 2008-07-30 16:47:00 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use Kernel::System::User;
use Kernel::System::Survey;
use Kernel::System::Ticket;

$Self->{UserObject}   = Kernel::System::User->new( %{$Self} );
$Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );
$Self->{SurveyObject} = Kernel::System::Survey->new( %{$Self} );

# create servey
my %SurveyData = (
    Title               => 'A Title',
    Introduction        => 'The introduction of the survey',
    Description         => 'The internal description of the survey',
    NotificationSender  => 'quality@example.com',
    NotificationSubject => 'Help us with your feedback!',
    NotificationBody    => 'Dear customer...',
);
my $SurveyID = $Self->{SurveyObject}->SurveyNew(
    UserID => 1,
    %SurveyData,
);
$Self->True(
    $SurveyID,
    "SurveyNew()",
);

for ( 1 .. 3 ) {
    my $QuestionAdd = $Self->{SurveyObject}->QuestionAdd(
        UserID   => 1,
        SurveyID => $SurveyID,
        Question => 'The Question',
        Type     => 'Radio',
    );
}
my @List = $Self->{SurveyObject}->QuestionList(
    SurveyID => $SurveyID,
);
for my $Question (@List) {
    for ( 1 .. 3 ) {
        $Self->{SurveyObject}->AnswerAdd(
            UserID     => 1,
            QuestionID => $Question->{QuestionID},
            Answer     => 'The Answer',
        );
    }
}

my $StatusSet = $Self->{SurveyObject}->SurveyStatusSet(
    SurveyID  => $SurveyID,
    NewStatus => 'Master'
);
$Self->Is(
    $StatusSet,
    'StatusSet',
    "SurveyStatusSet()",
);

my %SurveyGet = $Self->{SurveyObject}->SurveyGet(
    SurveyID => $SurveyID,
);

for my $Key ( sort keys %SurveyGet ) {
    next if !defined $SurveyData{$Key};
    $Self->Is(
        $SurveyGet{$Key},
        $SurveyData{$Key},
        "SurveyGet()",
    );
}

my @Tests = (
    {
        Ticket => {
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'closed successful',
            CustomerNo   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
        Article => {
            ArticleType    => 'email-external',
            SenderType     => 'customer',
            From           => 'Some Customer <some@example.com>',
            To             => 'Some To <to@example.com>',
            Subject        => 'Some Subject',
            Body           => 'the message text',
            MessageID      => '<asdasdasd.123@example.com>',
            ContentType    => 'text/plain; charset=ISO-8859-15',
            HistoryType    => 'OwnerUpdate',
            HistoryComment => 'Some free text!',
            UserID         => 1,
            NoAgentNotify => 1,    # if you don't want to send agent notifications
        },
        Result => [
            1,
            0,
        ],
    },
    {
        Ticket => {
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'closed successful',
            CustomerNo   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
        Article => {
            ArticleType    => 'email-external',
            SenderType     => 'customer',
            From           => 'Some Customer <SOME@example.com>',
            To             => 'Some To <to@example.com>',
            Subject        => 'Some Subject',
            Body           => 'the message text',
            MessageID      => '<asdasdasd.123@example.com>',
            ContentType    => 'text/plain; charset=ISO-8859-15',
            HistoryType    => 'OwnerUpdate',
            HistoryComment => 'Some free text!',
            UserID         => 1,
            NoAgentNotify => 1,    # if you don't want to send agent notifications
        },
        Result => [
            0,
            0,
        ],
    },
    {
        Ticket => {
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'closed successful',
            CustomerNo   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
        Article => {
            ArticleType    => 'email-external',
            SenderType     => 'customer',
            From           => 'SOME@example.com',
            To             => 'Some To <to@example.com>',
            Subject        => 'Some Subject',
            Body           => 'the message text',
            MessageID      => '<asdasdasd.123@example.com>',
            ContentType    => 'text/plain; charset=ISO-8859-15',
            HistoryType    => 'OwnerUpdate',
            HistoryComment => 'Some free text!',
            UserID         => 1,
            NoAgentNotify => 1,    # if you don't want to send agent notifications
        },
        Result => [
            0,
            0,
        ],
    },
);

for my $Test (@Tests) {
    my $TicketID = $Self->{TicketObject}->TicketCreate(
        %{ $Test->{Ticket} },
    );
    my $ArticleID = $Self->{TicketObject}->ArticleCreate(
        TicketID => $TicketID,
        %{ $Test->{Article} },
    );

    my $RequestSend = $Self->{SurveyObject}->RequestSend(
        TicketID => $TicketID,
    );
    if ( $Test->{Result}->[0] ) {
        $Self->True(
            $RequestSend,
            "RequestSend()",
        );
    }
    else {
        $Self->False(
            $RequestSend,
            "RequestSend()",
        );
    }

    $RequestSend = $Self->{SurveyObject}->RequestSend(
        TicketID => $TicketID,
    );
    if ( $Test->{Result}->[1] ) {
        $Self->True(
            $RequestSend,
            "RequestSend()",
        );
    }
    else {
        $Self->False(
            $RequestSend,
            "RequestSend()",
        );
    }

    my $Delete = $Self->{TicketObject}->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
}

$Self->{DBObject}->Do(
    SQL => "DELETE FROM survey_request WHERE send_to LIKE '\%some\@example.com\%'",
);

1;
