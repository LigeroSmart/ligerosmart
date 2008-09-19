# --
# Survey.t - Survey tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Survey.t,v 1.5 2008-09-19 14:04:43 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

use Kernel::System::User;
use Kernel::System::Survey;
use Kernel::System::Ticket;

$Self->{UserObject}   = Kernel::System::User->new( %{$Self} );
$Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );
$Self->{SurveyObject} = Kernel::System::Survey->new( %{$Self} );

# save original sendmail config
my $SendmailModule = $Self->{ConfigObject}->Get('SendmailModule');

# set config to not send emails
$Self->{ConfigObject}->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

# create survey
my %SurveyData = (
    Title               => 'A Title',
    Introduction        => 'The introduction of the survey',
    Description         => 'The internal description of the survey',
    NotificationSender  => 'quality@example.com',
    NotificationSubject => 'Help us with your feedback! ÄÖÜ',
    NotificationBody    => 'Dear customer... äöü',
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
    {
        'Survey::SendPeriod' => 1 / 24 / 60,
        Sleep  => 80,
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
    if ( $Test->{'Survey::SendPeriod'} ) {
        $Self->{ConfigObject}->Set(
            Key   => 'Survey::SendPeriod',
            Value => $Test->{'Survey::SendPeriod'},
        );
    }
    if ( $Test->{Sleep} ) {
        sleep $Test->{Sleep};
    }
    my $TicketID = $Self->{TicketObject}->TicketCreate(
        %{ $Test->{Ticket} },
    );
    my $ArticleID = $Self->{TicketObject}->ArticleCreate(
        TicketID => $TicketID,
        %{ $Test->{Article} },
    );

    my ( $HeaderRef, $BodyRef ) = $Self->{SurveyObject}->RequestSend(
        TicketID => $TicketID,
    );

    if ( $Test->{Result}->[0] ) {
        $Self->True(
            ${ $HeaderRef },
            "RequestSend()",
        );

        ${ $HeaderRef } =~ m{ ^ Subject: [ ] ( .+? ) \n \S+: [ ] }xms;
        $Self->Is(
            $1,
            'Help us with your feedback! =?UTF-8?Q?=C3=84=C3=96=C3=9C?=',
            "Test special characters in email subject",
        );

        $Self->Is(
            ${ $BodyRef },
            "Dear customer... =C3=A4=C3=B6=C3=BC=\n",
            "Test special characters in email body",
        );
    }
    else {
        $Self->False(
            ${ $HeaderRef },
            "RequestSend()",
        );
    }

    ( $HeaderRef, $BodyRef ) = $Self->{SurveyObject}->RequestSend(
        TicketID => $TicketID,
    );
    if ( $Test->{Result}->[1] ) {
        $Self->True(
            ${ $HeaderRef },
            "RequestSend()",
        );
    }
    else {
        $Self->False(
            ${ $HeaderRef },
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

# restore original sendmail config
$Self->{ConfigObject}->Set(
    Key   => 'SendmailModule',
    Value => $SendmailModule,
);

1;
