# --
# Survey.t - Survey tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Survey.t,v 1.7 2008-09-25 01:10:20 martin Exp $
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
        Name   => '1# try',
        'Survey::SendPeriod' => 100,
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
        Name   => '#2 try',
        'Survey::SendPeriod' => 100,
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
        Name   => '#3 try',
        'Survey::SendPeriod' => 100,
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
        Name   => '#4 try',
        Sleep  => 80,
        'Survey::SendPeriod' => 1 / 24 / 60,
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
            1,
            0,
        ],
    },
    {
        Name   => '#5 try',
        Sleep  => 30,
        'Survey::SendPeriod' => 1 / 24 / 60,
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

    # send survey first time
    my ( $HeaderRef, $BodyRef ) = $Self->{SurveyObject}->RequestSend(
        TicketID => $TicketID,
    );

    # check if survey got sent
    if ( $Test->{Result}->[0] ) {
        $Self->True(
            ${ $HeaderRef },
            "$Test->{Name} RequestSend() - survey got sent",
        );

        ${ $HeaderRef } =~ m{ ^ Subject: [ ] ( .+? ) \n \S+: [ ] }xms;
        $Self->Is(
            $1,
            'Help us with your feedback! =?UTF-8?Q?=C3=84=C3=96=C3=9C?=',
            "$Test->{Name} Test special characters in email subject",
        );

        $Self->Is(
            ${ $BodyRef },
            "Dear customer... =C3=A4=C3=B6=C3=BC=\n",
            "$Test->{Name} Test special characters in email body",
        );
    }
    else {
        $Self->False(
            ${ $HeaderRef },
            "$Test->{Name} RequestSend() - no survey got sent",
        );
    }

    # send survey second time
    ( $HeaderRef, $BodyRef ) = $Self->{SurveyObject}->RequestSend(
        TicketID => $TicketID,
    );

    # check if survey got sent
    if ( $Test->{Result}->[1] ) {
        $Self->True(
            ${ $HeaderRef },
            "$Test->{Name} 2 RequestSend() - survey got sent",
        );
    }
    else {
        $Self->False(
            ${ $HeaderRef },
            "$Test->{Name} 2 RequestSend() - no survey got sent",
        );
    }

    my $Delete = $Self->{TicketObject}->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
}

$Self->{DBObject}->Do(
    SQL => "DELETE FROM survey_request WHERE send_to LIKE '\%\@example.com\%'",
);

# restore original sendmail config
$Self->{ConfigObject}->Set(
    Key   => 'SendmailModule',
    Value => $SendmailModule,
);

1;
