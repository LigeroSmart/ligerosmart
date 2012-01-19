# --
# Kernel/System/Survey.pm - all survey funtions
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: Survey.pm,v 1.64 2012-01-19 15:55:23 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Survey;

use strict;
use warnings;

use Digest::MD5;
use Kernel::System::CustomerUser;
use Kernel::System::Email;
use Kernel::System::HTMLUtils;
use Kernel::System::Ticket;
use Mail::Address;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.64 $) [1];

=head1 NAME

Kernel::System::Survey - survey lib

=head1 SYNOPSIS

All survey functions. E. g. to add survey or and functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::User;
    use Kernel::System::Survey;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $UserObject = Kernel::System::User->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
        EncodeObject => $EncodeObject,
    );
    my $SurveyObject = Kernel::System::Survey->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
        UserObject   => $UserObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ConfigObject LogObject TimeObject DBObject MainObject EncodeObject UserObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{HTMLUtilsObject} = $Param{HTMLUtilsObject}
        || Kernel::System::HTMLUtils->new( %{$Self} );

    $Self->{SendmailObject} = $Param{SendmailObject} || Kernel::System::Email->new( %{$Self} );

    $Self->{CustomerUserObject} = $Param{CustomerUserObject}
        || Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{TicketObject} = $Param{TicketObject} || Kernel::System::Ticket->new( %{$Self} );

    return $Self;
}

=item SurveyList()

to get a array list of all survey items

    my @List = $SurveyObject->SurveyList();

=cut

sub SurveyList {
    my ( $Self, %Param ) = @_;

    # get survey list
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM survey ORDER BY create_time DESC',
    );

    # fetch the results
    my @List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @List, $Row[0];
    }

    return @List;
}

=item SurveyGet()

to get all attributes of a survey

    my %Survey = $SurveyObject->SurveyGet(
        SurveyID => 123
    );

=cut

sub SurveyGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SurveyID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need SurveyID!',
        );
        return;
    }

    # quote
    $Param{SurveyID} = $Self->{DBObject}->Quote( $Param{SurveyID}, 'Integer' );

    # get all attributes of a survey
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, surveynumber, title, introduction, description,"
            . " notification_sender, notification_subject, notification_body, "
            . " status, create_time, create_by, change_time, change_by "
            . " FROM survey WHERE id = $Param{SurveyID}",
        Limit => 1,
    );

    # fetch the result
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{SurveyID}            = $Row[0];
        $Data{SurveyNumber}        = $Row[1];
        $Data{Title}               = $Row[2];
        $Data{Introduction}        = $Row[3];
        $Data{Description}         = $Row[4];
        $Data{NotificationSender}  = $Row[5];
        $Data{NotificationSubject} = $Row[6];
        $Data{NotificationBody}    = $Row[7];
        $Data{Status}              = $Row[8];
        $Data{CreateTime}          = $Row[9];
        $Data{CreateBy}            = $Row[10];
        $Data{ChangeTime}          = $Row[11];
        $Data{ChangeBy}            = $Row[12];
    }

    if ( !%Data ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such SurveyID $Param{SurveyID}!",
        );
        return;
    }

    # set default values
    $Data{NotificationSender}  ||= $Self->{ConfigObject}->Get('Survey::NotificationSender');
    $Data{NotificationSubject} ||= $Self->{ConfigObject}->Get('Survey::NotificationSubject');
    $Data{NotificationBody}    ||= $Self->{ConfigObject}->Get('Survey::NotificationBody');

    # get queues
    $Data{Queues} = $Self->SurveyQueueGet(
        SurveyID => $Param{SurveyID},
    );

    # added CreateBy
    if ( !$Param{Public} ) {
        my %CreateUserInfo = $Self->{UserObject}->GetUserData(
            UserID => $Data{CreateBy},
            Cached => 1,
        );
        $Data{CreateUserLogin}     = $CreateUserInfo{UserLogin};
        $Data{CreateUserFirstname} = $CreateUserInfo{UserFirstname};
        $Data{CreateUserLastname}  = $CreateUserInfo{UserLastname};

        # added ChangeBy
        my %ChangeUserInfo = $Self->{UserObject}->GetUserData(
            UserID => $Data{ChangeBy},
            Cached => 1,
        );
        $Data{ChangeUserLogin}     = $ChangeUserInfo{UserLogin};
        $Data{ChangeUserFirstname} = $ChangeUserInfo{UserFirstname};
        $Data{ChangeUserLastname}  = $ChangeUserInfo{UserLastname};
    }

    return %Data;
}

=item SurveyStatusSet()

to set a new survey status (Valid, Invalid, Master)

    $StatusSet = $SurveyObject->SurveyStatusSet(
        SurveyID  => 123,
        NewStatus => 'Master'
    );

=cut

sub SurveyStatusSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(SurveyID NewStatus)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    $Param{NewStatus} = $Self->{DBObject}->Quote( $Param{NewStatus} );
    $Param{SurveyID} = $Self->{DBObject}->Quote( $Param{SurveyID}, 'Integer' );

    # get current status
    $Self->{DBObject}->Prepare(
        SQL   => "SELECT status FROM survey WHERE id = $Param{SurveyID}",
        Limit => 1,
    );

    # fetch the result
    my $Status = '';
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Status = $Row[0];
    }

    # the curent status
    if ( $Status eq 'New' || $Status eq 'Invalid' ) {

        # get the question ids
        $Self->{DBObject}->Prepare(
            SQL   => "SELECT id FROM survey_question WHERE survey_id = $Param{SurveyID}",
            Limit => 1,
        );

        # fetch the result
        my $Quest;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Quest = $Row[0];
        }

        return 'NoQuestion' if !$Quest;

        # get all questions (type radio and checkbox)
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id FROM survey_question"
                . " WHERE survey_id = $Param{SurveyID} AND "
                . "(question_type = 'Radio' OR question_type = 'Checkbox')",
        );

        # fetch the result
        my @QuestionIDs;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            push( @QuestionIDs, $Row[0] );
        }
        for my $OneID (@QuestionIDs) {

            # get all answer ids of a question
            $Self->{DBObject}->Prepare(
                SQL   => "SELECT COUNT(id) FROM survey_answer WHERE question_id = $OneID",
                Limit => 1,
            );

            # fetch the result
            my $Counter;
            while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                $Counter = $Row[0];
            }

            return 'IncompleteQuestion' if $Counter < 2;
        }

        # set new status
        if ( $Param{NewStatus} eq 'Master' ) {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = 'Valid' WHERE status = 'Master'",
            );
        }
        if ( $Param{NewStatus} eq 'Valid' || $Param{NewStatus} eq 'Master' ) {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = '$Param{NewStatus}' "
                    . "WHERE id = $Param{SurveyID}",
            );
            return 'StatusSet';
        }
    }
    elsif ( $Status eq 'Valid' ) {

        # set status Master
        if ( $Param{NewStatus} eq 'Master' ) {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = 'Valid' WHERE status = 'Master'",
            );
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = 'Master' WHERE id = $Param{SurveyID}",
            );
            return 'StatusSet';
        }

        # set status Invalid
        elsif ( $Param{NewStatus} eq 'Invalid' ) {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = 'Invalid' WHERE id = $Param{SurveyID}",
            );
            return 'StatusSet';
        }
    }
    elsif ( $Status eq 'Master' ) {

        # set status Valid
        if ( $Param{NewStatus} eq 'Valid' || $Param{NewStatus} eq 'Invalid' ) {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = '$Param{NewStatus}' "
                    . "WHERE id = $Param{SurveyID}",
            );
            return 'StatusSet';
        }
    }
}

=item SurveySave()

to update an existing survey

    $SurveyObject->SurveySave(
        UserID              => 1,
        SurveyID            => 4,
        Title               => 'A Title',
        Introduction        => 'The introduction of the survey',
        Description         => 'The internal description of the survey',
        NotificationSender  => 'quality@example.com',
        NotificationSubject => 'Help us with your feedback!',
        NotificationBody    => 'Dear customer...',
        Queues              => [2, 5, 9],  # (optional) survey is valid for these queues
    );

=cut

sub SurveySave {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (
        qw(
        UserID SurveyID Title Introduction Description
        NotificationSender NotificationSubject NotificationBody
        )
        )
    {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check queues
    if ( $Param{Queues} && ref $Param{Queues} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Queues must be an array reference.',
        );
        return;
    }

    # set default value
    $Param{Queues} ||= [];

    # quote
    for my $Argument (
        qw(
        Title Introduction Description
        NotificationSender NotificationSubject NotificationBody
        )
        )
    {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    for my $Argument (qw(UserID SurveyID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # update the survey
    return if !$Self->{DBObject}->Do(
        SQL => "UPDATE survey SET "
            . "title = '$Param{Title}', "
            . "introduction = '$Param{Introduction}', "
            . "description = '$Param{Description}', "
            . "notification_sender = '$Param{NotificationSender}', "
            . "notification_subject = '$Param{NotificationSubject}', "
            . "notification_body = '$Param{NotificationBody}', "
            . "change_time = current_timestamp, "
            . "change_by = $Param{UserID} "
            . "WHERE id = $Param{SurveyID}",
    );

    # insert new survey-queue relations
    return $Self->SurveyQueueSave(
        SurveyID => $Param{SurveyID},
        QueueIDs => $Param{Queues},
    );
}

=item SurveyNew()

to add a new survey

    my $SurveyID = $SurveyObject->SurveyNew(
        UserID              => 1,
        Title               => 'A Title',
        Introduction        => 'The introduction of the survey',
        Description         => 'The internal description of the survey',
        NotificationSender  => 'quality@example.com',
        NotificationSubject => 'Help us with your feedback!',
        NotificationBody    => 'Dear customer...',
        Queues              => [2, 5, 9],  # (optional) survey is valid for these queues
    );

=cut

sub SurveyNew {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (
        qw(
        UserID Title Introduction Description
        NotificationSender NotificationSubject NotificationBody
        )
        )
    {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    for my $Argument (
        qw(
        Title Introduction Description
        NotificationSender NotificationSubject NotificationBody
        )
        )
    {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    $Param{UserID} = $Self->{DBObject}->Quote( $Param{UserID}, 'Integer' );

    # insert a new survey
    $Self->{DBObject}->Do(
        SQL => "INSERT INTO survey (title, introduction, description,"
            . " notification_sender, notification_subject, notification_body,"
            . " status, create_time, create_by, change_time, change_by"
            . ") VALUES ("
            . "'$Param{Title}', "
            . "'$Param{Introduction}', "
            . "'$Param{Description}', "
            . "'$Param{NotificationSender}', "
            . "'$Param{NotificationSubject}', "
            . "'$Param{NotificationBody}', "
            . "'New', "
            . "current_timestamp, "
            . "$Param{UserID}, "
            . "current_timestamp, "
            . "$Param{UserID})",
    );

    # get the id of the survey
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM survey WHERE "
            . "title = '$Param{Title}' AND "
            . "introduction = '$Param{Introduction}' AND "
            . "description = '$Param{Description}' "
            . "ORDER BY id DESC",
        Limit => 1,
    );

    # fetch the result
    my $SurveyID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $SurveyID = $Row[0];
    }

    # set the survey number
    $Self->{DBObject}->Do(
        SQL => "UPDATE survey SET "
            . "surveynumber = '"
            . ( $SurveyID + 10000 ) . "' "
            . "WHERE id = $SurveyID"
    );

    return $SurveyID if !$Param{Queues};
    return $SurveyID if ref $Param{Queues} ne 'ARRAY';

    # insert new survey-queue relations
    $Self->SurveyQueueSave(
        SurveyID => $SurveyID,
        QueueIDs => $Param{Queues},
    );

    return $SurveyID;
}

=item QuestionList()

to get a array list of all question items

    my @List = $SurveyObject->QuestionList(
        SurveyID => 1
    );

=cut

sub QuestionList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SurveyID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need SurveyID!',
        );
        return;
    }

    # quote
    $Param{SurveyID} = $Self->{DBObject}->Quote( $Param{SurveyID}, 'Integer' );

    # get all questions of a survey
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, survey_id, question, question_type "
            . " FROM survey_question WHERE survey_id = $Param{SurveyID} ORDER BY position",
    );

    # fetch the result
    my @List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Data;
        $Data{QuestionID} = $Row[0];
        $Data{SurveyID}   = $Row[1];
        $Data{Question}   = $Row[2];
        $Data{Type}       = $Row[3];

        push @List, \%Data;
    }

    return @List;
}

=item QuestionAdd()

to add a new question to a survey

    $SurveyObject->QuestionAdd(
        UserID => 1,
        SurveyID => 10,
        Question => 'The Question',
        Type => 'Radio',
    );

=cut

sub QuestionAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID SurveyID Question Type)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    for my $Argument (qw(Question Type)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    for my $Argument (qw(UserID SurveyID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    return if !$Param{Question};

    # insert a new question
    return $Self->{DBObject}->Do(
        SQL => "INSERT INTO survey_question (survey_id, question, question_type, "
            . "position, create_time, create_by, change_time, change_by) VALUES ("
            . "$Param{SurveyID}, "
            . "'$Param{Question}', "
            . "'$Param{Type}', 255, "
            . "current_timestamp, "
            . "$Param{UserID}, "
            . "current_timestamp, "
            . "$Param{UserID})",
    );
}

=item QuestionDelete()

to delete a question from a survey

    $SurveyObject->QuestionDelete(
        SurveyID => 1,
        QuestionID => 10,
    );

=cut

sub QuestionDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(SurveyID QuestionID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    for my $Argument (qw(SurveyID QuestionID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # delete all answers of a question
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM survey_answer WHERE question_id = $Param{QuestionID}",
    );

    # delete the question
    return $Self->{DBObject}->Do(
        SQL => "DELETE FROM survey_question WHERE "
            . "id = $Param{QuestionID} AND "
            . "survey_id = $Param{SurveyID}",
    );
}

=item QuestionSort()

to sort all questions from a survey

    $SurveyObject->QuestionSort(
        SurveyID => 1,
    );

=cut

sub QuestionSort {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SurveyID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need SurveyID!'
        );
        return;
    }

    # quote
    $Param{SurveyID} = $Self->{DBObject}->Quote( $Param{SurveyID}, 'Integer' );

    # get all question of a survey (sorted by position)
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM survey_question"
            . " WHERE survey_id = $Param{SurveyID} ORDER BY position",
    );

    my @List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @List, $Row[0];
    }

    my $Counter = 1;
    for my $QuestionID (@List) {
        $Self->{DBObject}->Do(
            SQL => "UPDATE survey_question SET position = $Counter WHERE id = $QuestionID",
        );
    }
    continue {
        $Counter++;
    }

    return 1;
}

=item QuestionUp()

to move a question up

    $SurveyObject->QuestionUp(
        SurveyID => 1,
        QuestionID => 4,
    );

=cut

sub QuestionUp {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(SurveyID QuestionID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    for my $Argument (qw(SurveyID QuestionID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # get position
    $Self->{DBObject}->Prepare(
        SQL => "SELECT position FROM survey_question"
            . " WHERE id = $Param{QuestionID} AND survey_id = $Param{SurveyID}",
        Limit => 1,
    );

    # fetch the result
    my $Position = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Position = $Row[0];
    }

    return if $Position < 2;

    my $PositionUp = $Position - 1;

    # get question
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM survey_question"
            . " WHERE survey_id = $Param{SurveyID} AND position = $PositionUp",
        Limit => 1,
    );

    # fetch the result
    my $QuestionIDDown;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $QuestionIDDown = $Row[0];
    }

    return if !$QuestionIDDown;

    # update position
    $Self->{DBObject}->Do(
        SQL => "UPDATE survey_question SET "
            . "position = $Position "
            . "WHERE id = $QuestionIDDown",
    );

    # update position
    return $Self->{DBObject}->Do(
        SQL => "UPDATE survey_question SET "
            . "position = $PositionUp "
            . "WHERE id = $Param{QuestionID}",
    );
}

=item QuestionDown()

to move a question down

    $SurveyObject->QuestionDown(
        SurveyID => 1,
        QuestionID => 4,
    );

=cut

sub QuestionDown {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(SurveyID QuestionID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    for my $Argument (qw(SurveyID QuestionID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # get position
    $Self->{DBObject}->Prepare(
        SQL => "SELECT position FROM survey_question"
            . " WHERE id = $Param{QuestionID} AND survey_id = $Param{SurveyID}",
        Limit => 1,
    );

    # fetch the result
    my $Position;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Position = $Row[0];
    }

    return if !$Position;

    my $PositionDown = $Position + 1;

    # get question
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM survey_question"
            . " WHERE survey_id = $Param{SurveyID} AND position = $PositionDown",
        Limit => 1,
    );

    # fetch the result
    my $QuestionIDUp;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $QuestionIDUp = $Row[0];
    }

    return if !$QuestionIDUp;

    # update position
    $Self->{DBObject}->Do(
        SQL => "UPDATE survey_question SET "
            . "position = $Position "
            . "WHERE id = $QuestionIDUp",
    );

    # update position
    return $Self->{DBObject}->Do(
        SQL => "UPDATE survey_question SET "
            . "position = $PositionDown "
            . "WHERE id = $Param{QuestionID}",
    );
}

=item QuestionGet()

to get all attributes of a question

    my %Question = $SurveyObject->QuestionGet(
        QuestionID => 123
    );

=cut

sub QuestionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{QuestionID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need QuestionID!',
        );
        return;
    }

    # quote
    $Param{QuestionID} = $Self->{DBObject}->Quote( $Param{QuestionID}, 'Integer' );

    # get question
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, survey_id, question, question_type, position, "
            . "create_time, create_by, change_time, change_by "
            . "FROM survey_question WHERE id = $Param{QuestionID}",
        Limit => 1,
    );

    # fetch the result
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{QuestionID} = $Row[0];
        $Data{SurveyID}   = $Row[1];
        $Data{Question}   = $Row[2];
        $Data{Type}       = $Row[3];
        $Data{Position}   = $Row[4];
        $Data{CreateTime} = $Row[5];
        $Data{CreateBy}   = $Row[6];
        $Data{ChangeTime} = $Row[7];
        $Data{ChangeBy}   = $Row[8];
    }

    return %Data;
}

=item QuestionSave()

to update an existing question

    $SurveyObject->QuestionSave(
        UserID => 1,
        QuestionID => 4,
        SurveyID => 3,
        Question => 'The Question',
    );

=cut

sub QuestionSave {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID QuestionID SurveyID Question)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    for my $Argument (qw(Question)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    for my $Argument (qw(UserID QuestionID SurveyID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # update question
    return $Self->{DBObject}->Do(
        SQL => "UPDATE survey_question SET "
            . "question = '$Param{Question}', "
            . "change_time = current_timestamp, "
            . "change_by = $Param{UserID} "
            . "WHERE id = $Param{QuestionID} "
            . "AND survey_id = $Param{SurveyID}",
    );
}

=item QuestionCount()

to count all questions of a survey

    my $CountQuestion = $SurveyObject->QuestionCount(
        SurveyID => 123
    );

=cut

sub QuestionCount {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SurveyID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need SurveyID!',
        );
        return;
    }

    # quote
    $Param{SurveyID} = $Self->{DBObject}->Quote( $Param{SurveyID}, 'Integer' );

    # count questions
    $Self->{DBObject}->Prepare(
        SQL   => "SELECT COUNT(id) FROM survey_question WHERE survey_id = $Param{SurveyID}",
        Limit => 1,
    );

    # fetch the result
    my $CountQuestion;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $CountQuestion = $Row[0];
    }

    return $CountQuestion;
}

=item AnswerList()

to get a array list of all answer items

    my @List = $SurveyObject->AnswerList(
        QuestionID => 1
    );

=cut

sub AnswerList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{QuestionID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need QuestionID!',
        );
        return;
    }

    # quote
    $Param{QuestionID} = $Self->{DBObject}->Quote( $Param{QuestionID}, 'Integer' );

    # get answer list
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, question_id, answer "
            . " FROM survey_answer WHERE question_id = $Param{QuestionID} ORDER BY position",
    );

    # fetcht the result
    my @List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Data;
        $Data{AnswerID}   = $Row[0];
        $Data{QuestionID} = $Row[1];
        $Data{Answer}     = $Row[2];

        push @List, \%Data;
    }

    return @List;
}

=item AnswerAdd()

to add a new answer to a question

    $SurveyObject->AnswerAdd(
        UserID => 1,
        QuestionID => 10,
        Answer => 'The Answer',
    );

=cut

sub AnswerAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID QuestionID Answer)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    for my $Argument (qw(Answer)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    for my $Argument (qw(UserID QuestionID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    return if !$Param{Answer};

    # insert answer
    return $Self->{DBObject}->Do(
        SQL => "INSERT INTO survey_answer (question_id, answer, position, "
            . "create_time, create_by, change_time, change_by) VALUES ("
            . "$Param{QuestionID}, "
            . "'$Param{Answer}', 255, "
            . "current_timestamp, "
            . "$Param{UserID}, "
            . "current_timestamp, "
            . "$Param{UserID})",
    );
}

=item AnswerDelete()

to delete a answer from a question

    $SurveyObject->AnswerDelete(
        QuestionID => 10,
        AnswerID => 4,
    );

=cut

sub AnswerDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(QuestionID AnswerID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    for my $Argument (qw(QuestionID AnswerID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # delete answer
    return $Self->{DBObject}->Do(
        SQL => "DELETE FROM survey_answer WHERE "
            . "id = $Param{AnswerID} AND question_id = $Param{QuestionID}",
    );
}

=item AnswerSort()

to sort all answers from a question

    $SurveyObject->AnswerSort(
        QuestionID => 1,
    );

=cut

sub AnswerSort {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{QuestionID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need QuestionID!',
        );
        return;
    }

    # quote
    $Param{QuestionID} = $Self->{DBObject}->Quote( $Param{QuestionID}, 'Integer' );

    # get answer list
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM survey_answer"
            . " WHERE question_id = $Param{QuestionID} ORDER BY position",
    );

    # fetch the result
    my @List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @List, $Row[0];
    }

    my $Counter = 1;
    for my $AnswerID (@List) {

        # update position
        $Self->{DBObject}->Do(
            SQL => "UPDATE survey_answer SET position = $Counter WHERE id = $AnswerID",
        );
    }
    continue {
        $Counter++;
    }

    return 1;
}

=item AnswerUp()

to move a answer up

    $SurveyObject->AnswerUp(
        QuestionID => 4,
        AnswerID => 1,
    );

=cut

sub AnswerUp {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(QuestionID AnswerID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    for my $Argument (qw(QuestionID AnswerID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # get position
    $Self->{DBObject}->Prepare(
        SQL => "SELECT position FROM survey_answer"
            . " WHERE id = $Param{AnswerID} AND question_id = $Param{QuestionID}",
        Limit => 1,
    );

    # fetch the result
    my $Position;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Position = $Row[0];
    }

    return if $Position < 2;

    my $PositionUp = $Position - 1;

    # get answer
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM survey_answer"
            . " WHERE question_id = $Param{QuestionID} AND position = $PositionUp",
        Limit => 1,
    );

    # fetch the result
    my $AnswerIDDown;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $AnswerIDDown = $Row[0];
    }

    return if !$AnswerIDDown;

    # update position
    $Self->{DBObject}->Do(
        SQL => "UPDATE survey_answer SET position = $Position WHERE id = $AnswerIDDown",
    );

    # update position
    return $Self->{DBObject}->Do(
        SQL => "UPDATE survey_answer SET "
            . "position = $PositionUp "
            . "WHERE id = $Param{AnswerID}",
    );
}

=item AnswerDown()

to move a answer down

    $SurveyObject->AnswerDown(
        QuestionID => 4,
        AnswerID => 1,
    );

=cut

sub AnswerDown {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(QuestionID AnswerID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    for my $Argument (qw(QuestionID AnswerID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # get position
    $Self->{DBObject}->Prepare(
        SQL => "SELECT position FROM survey_answer"
            . " WHERE id = $Param{AnswerID} AND question_id = $Param{QuestionID}",
        Limit => 1,
    );

    # fetch the result
    my $Position;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Position = $Row[0];
    }

    return if !$Position;

    my $PositionDown = $Position + 1;

    # get answer
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM survey_answer"
            . " WHERE question_id = $Param{QuestionID} AND position = $PositionDown",
        Limit => 1,
    );

    # fetch the result
    my $AnswerIDUp;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $AnswerIDUp = $Row[0];
    }

    return if !$AnswerIDUp;

    # update position
    $Self->{DBObject}->Do(
        SQL => "UPDATE survey_answer SET position = $Position WHERE id = $AnswerIDUp",
    );

    # update position
    return $Self->{DBObject}->Do(
        SQL => "UPDATE survey_answer SET "
            . "position = $PositionDown "
            . "WHERE id = $Param{AnswerID}",
    );
}

=item AnswerGet()

to get all attributes of a answer

    my %Answer = $SurveyObject->AnswerGet(
        AnswerID => 123
    );

=cut

sub AnswerGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{AnswerID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need QuestionID!',
        );
        return;
    }

    # quote
    $Param{AnswerID} = $Self->{DBObject}->Quote( $Param{AnswerID}, 'Integer' );

    # get answer
    $Self->{DBObject}->Prepare(
        SQL =>
            "SELECT id, question_id, answer, position, create_time, create_by, change_time, change_by "
            . "FROM survey_answer WHERE id = $Param{AnswerID}",
        Limit => 1,
    );

    # fetch the result
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{AnswerID}   = $Row[0];
        $Data{QuestionID} = $Row[1];
        $Data{Answer}     = $Row[2];
        $Data{Position}   = $Row[3];
        $Data{CreateTime} = $Row[4];
        $Data{CreateBy}   = $Row[5];
        $Data{ChangeTime} = $Row[6];
        $Data{ChangeBy}   = $Row[7];
    }

    return %Data;
}

=item AnswerSave()

to update an existing answer

    $SurveyObject->AnswerSave(
        UserID => 1,
        AnswerID => 6,
        QuestionID => 4,
        Answer => 'The Answer',
    );

=cut

sub AnswerSave {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID AnswerID QuestionID Answer)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    for my $Argument (qw(Answer)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    for my $Argument (qw(UserID AnswerID QuestionID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    return if !$Param{Answer};

    # update answer
    return $Self->{DBObject}->Do(
        SQL => "UPDATE survey_answer SET "
            . "answer = '$Param{Answer}', "
            . "change_time = current_timestamp, "
            . "change_by = $Param{UserID} "
            . "WHERE id = $Param{AnswerID} "
            . "AND question_id = $Param{QuestionID}",
    );
}

=item AnswerCount()

to count all answers of a question

    my $CountAnswer = $SurveyObject->AnswerCount(
        QuestionID => 123
    );

=cut

sub AnswerCount {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{QuestionID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need QuestionID!',
        );
        return;
    }

    # quote
    $Param{QuestionID} = $Self->{DBObject}->Quote( $Param{QuestionID}, 'Integer' );

    # count answers
    $Self->{DBObject}->Prepare(
        SQL   => "SELECT COUNT(id) FROM survey_answer WHERE question_id = $Param{QuestionID}",
        Limit => 1,
    );

    # fetch the result
    my $CountAnswer;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $CountAnswer = $Row[0];
    }

    return $CountAnswer;
}

=item VoteList()

to get a array list of all vote items

    my @List = $SurveyObject->VoteList(
        SurveyID => 1
    );

=cut

sub VoteList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SurveyID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need SurveyID!',
        );
        return;
    }

    # quote
    $Param{SurveyID} = $Self->{DBObject}->Quote( $Param{SurveyID}, 'Integer' );

    # get vote list
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, ticket_id, send_time, vote_time "
            . "FROM survey_request WHERE survey_id = $Param{SurveyID} "
            . "AND valid_id = 0 ORDER BY vote_time DESC",
    );

    # fetch the result
    my @List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Data;
        $Data{RequestID} = $Row[0];
        $Data{TicketID}  = $Row[1];
        $Data{SendTime}  = $Row[2];
        $Data{VoteTime}  = $Row[3];

        push @List, \%Data;
    }

    return @List;
}

=item VoteGet()

to get all attributes of a vote

    my @Vote = $SurveyObject->VoteGet(
        RequestID => 13,
        QuestionID => 23
    );

=cut

sub VoteGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(RequestID QuestionID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    for my $Argument (qw(RequestID QuestionID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # get vote
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, vote_value FROM survey_vote"
            . " WHERE request_id = $Param{RequestID} AND question_id = $Param{QuestionID}",
    );

    # fetch the result
    my @List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Data;
        $Data{RequestID} = $Row[0];
        $Data{VoteValue} = $Row[1] || '-';

        push @List, \%Data;
    }

    return @List;
}

=item VoteAttributeGet()

to get all attributes of a vote

    my $VoteAttributeContent = $SurveyObject->VoteAttributeGet(
        VoteID => 13,
    );

=cut

sub VoteAttributeGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(VoteID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    for my $Argument (qw(VoteID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # get vote attribute
    $Self->{DBObject}->Prepare(
        SQL => "SELECT vote_value FROM survey_vote"
            . " WHERE id = $Param{VoteID}",
        Limit => 1,
    );

    # fetch the result
    my $VoteAttributeContent = ${ $Self->{DBObject}->FetchrowArray() }[0];
    return $VoteAttributeContent;
}

=item CountVote()

to count all votes of a survey

    my $CountVote = $SurveyObject->CountVote(
        QuestionID => 123,
        VoteValue => 'The Value',
    );

=cut

sub CountVote {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(QuestionID VoteValue)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    $Param{VoteValue} = $Self->{DBObject}->Quote( $Param{VoteValue} );
    $Param{QuestionID} = $Self->{DBObject}->Quote( $Param{QuestionID}, 'Integer' );

    # count votes
    $Self->{DBObject}->Prepare(
        SQL => "SELECT COUNT(vote_value) FROM survey_vote WHERE "
            . "question_id = $Param{QuestionID} AND vote_value = '$Param{VoteValue}'",
        Limit => 1,
    );

    # fetch the result
    my $CountVote;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $CountVote = $Row[0];
    }

    return $CountVote;
}

=item CountRequest()

to count all requests of a survey

    my $CountRequest = $SurveyObject->CountRequest(
        QuestionID => 123,
        ValidID => 0,       # (0|1|all)
    );

=cut

sub CountRequest {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(SurveyID ValidID)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    $Param{SurveyID} = $Self->{DBObject}->Quote( $Param{SurveyID}, 'Integer' );

    # count requests
    my $SQL = "SELECT COUNT(id) FROM survey_request WHERE survey_id = $Param{SurveyID}";

    # add valid part
    if ( !$Param{ValidID} ) {
        $SQL .= " AND valid_id = 0";
    }
    elsif ( $Param{ValidID} eq 1 ) {
        $SQL .= " AND valid_id = 1";
    }

    # ask database
    $Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Limit => 1,
    );

    # fetch the result
    my $CountRequest;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $CountRequest = $Row[0];
    }

    return $CountRequest;
}

=item ElementExists()

exists an survey-, question-, answer- or request-element

    my $CountRequest = $SurveyObject->ElementExists(
        ID => 123,           # SurveyID, QuestionID, AnswerID, RequestID
        Element => 'Survey'  # Survey, Question, Answer, Request
    );

=cut

sub ElementExists {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ElementID Element)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    $Param{Element} = $Self->{DBObject}->Quote( $Param{Element} );
    $Param{ElementID} = $Self->{DBObject}->Quote( $Param{ElementID}, 'Integer' );

    my %LookupTable = (
        Survey   => 'survey',
        Question => 'survey_question',
        Answer   => 'survey_answer',
        Request  => 'survey_request',
    );

    # count element
    $Self->{DBObject}->Prepare(
        SQL   => "SELECT COUNT(id) FROM $LookupTable{$Param{Element}} WHERE id = $Param{ElementID}",
        Limit => 1,
    );

    # fetch the result
    my $ElementExists = 'No';
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        if ( $Row[0] ) {
            $ElementExists = 'Yes';
        }
    }

    return $ElementExists;
}

=item RequestSend()

to send a request to a customer (if master survey is set)

    $SurveyObject->RequestSend(
        TicketID => 123,
    );

=cut

sub RequestSend {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need TicketID!',
        );
        return;
    }

    # create PublicSurveyKey
    my $md5 = Digest::MD5->new();
    $md5->add( $Self->{TimeObject}->SystemTime() . int( rand(999999999) ) );
    my $PublicSurveyKey = $md5->hexdigest;

    # find master survey
    $Self->{DBObject}->Prepare(
        SQL   => "SELECT id FROM survey WHERE status = 'Master'",
        Limit => 1,
    );

    # fetch the result
    my $SurveyID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $SurveyID = $Row[0];
    }

    # return, no master survey found
    return if !$SurveyID;

    # get the survey
    my %Survey = $Self->SurveyGet(
        SurveyID => $SurveyID,
    );
    my $Subject = $Survey{NotificationSubject};
    my $Body    = $Survey{NotificationBody};

    # fix new lines
    $Body =~ s/(\n\r|\r\r\n|\r\n)/\n/g;

    # ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID => $Param{TicketID},
    );

    # check if ticket is in a send queue
    if ( $Survey{Queues} && ref $Survey{Queues} eq 'ARRAY' && @{ $Survey{Queues} } ) {
        my $Found;

        QUEUE:
        for my $QueueID ( @{ $Survey{Queues} } ) {
            next QUEUE if $Ticket{QueueID} != $QueueID;
            $Found = 1;
            last QUEUE;
        }

        return if !$Found;
    }

    for my $Data ( keys %Ticket ) {
        if ( defined $Ticket{$Data} ) {
            $Subject =~ s/<OTRS_TICKET_$Data>/$Ticket{$Data}/gi;
            $Body    =~ s/<OTRS_TICKET_$Data>/$Ticket{$Data}/gi;

            # filter for new rich text content
            $Body =~ s/&lt;OTRS_TICKET_$Data&gt;/$Ticket{$Data}/g;
        }
    }

    # cleanup
    $Subject =~ s/<OTRS_TICKET_.+?>/-/gi;
    $Body    =~ s/<OTRS_TICKET_.+?>/-/gi;

    # replace config options
    $Subject =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;
    $Body    =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;

    # filter for new rich text content
    $Body =~ s{&lt;OTRS_CONFIG_(.+?)&gt;}{$Self->{ConfigObject}->Get($1)}egx;

    # cleanup
    $Subject =~ s/<OTRS_CONFIG_.+?>/-/gi;
    $Body    =~ s/<OTRS_CONFIG_.+?>/-/gi;

    # filter for new rich text content
    $Body =~ s/&lt;OTRS_CONFIG_.+?&gt;/-/gi;

    # get customer data and replace it with <OTRS_CUSTOMER_DATA_...
    my %CustomerUser;
    if ( $Ticket{CustomerUserID} ) {
        %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Ticket{CustomerUserID},
        );

        # replace customer stuff with tags
        for my $Data ( keys %CustomerUser ) {
            next if !$CustomerUser{$Data};

            $Subject =~ s/<OTRS_CUSTOMER_DATA_$Data>/$CustomerUser{$Data}/gi;
            $Body    =~ s/<OTRS_CUSTOMER_DATA_$Data>/$CustomerUser{$Data}/gi;

            # filter for new rich text content
            $Body =~ s/&lt;OTRS_CUSTOMER_DATA_$Data&gt;/$CustomerUser{$Data}/gi;
        }
    }

    # cleanup all not needed <OTRS_CUSTOMER_DATA_ tags
    $Subject =~ s/<OTRS_CUSTOMER_DATA_.+?>/-/gi;
    $Body    =~ s/<OTRS_CUSTOMER_DATA_.+?>/-/gi;

    # filter for new rich text content
    $Body =~ s/&lt;OTRS_CUSTOMER_DATA_.+?&gt;/-/gi;

    # replace key
    $Subject =~ s/<OTRS_PublicSurveyKey>/$PublicSurveyKey/gi;
    $Body    =~ s/<OTRS_PublicSurveyKey>/$PublicSurveyKey/gi;

    # filter for new rich text content
    $Body =~ s/&lt;OTRS_PublicSurveyKey&gt;/$PublicSurveyKey/gi;

    my $ToString = $CustomerUser{UserEmail};

    if ( !$ToString ) {
        my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
            TicketID => $Param{TicketID},
        );
        if ( $Article{SenderType} eq 'agent' ) {
            $ToString = $Article{To};
        }
        else {
            $ToString = $Article{From};
        }
    }

    # parse the to string
    my $To;
    for my $ToParser ( Mail::Address->parse($ToString) ) {
        $To = $ToParser->address();
    }

    # return if no to is found
    return if !$To;

    # check if it's a valid email addedss (min is needed)
    return if $To !~ /@/;

    # convert to lower cases
    $To = lc $To;

    # check if not survey should be send
    my $SendNoSurveyRegExp = $Self->{ConfigObject}->Get('Survey::SendNoSurveyRegExp');

    return if $SendNoSurveyRegExp && $To =~ /$SendNoSurveyRegExp/i;

    # quote
    $To = $Self->{DBObject}->Quote($To);

    # Only if we haven't been called by cron
    if ( !$Param{TriggerSendRequests} ) {
        my $AmountOfSurveysPer30Days
            = $Self->{ConfigObject}->Get('Survey::AmountOfSurveysPer30Days');

        # if we should just send a certain amount of surveys per 30 days & recipient
        if ($AmountOfSurveysPer30Days) {
            my $Now = $Self->{TimeObject}->SystemTime();

            # Find all surveys that were created in the last 30 days
            my $ThirtyDaysAgo = $Now - 30 * 86400;
            $ThirtyDaysAgo
                = $Self->{TimeObject}->SystemTime2TimeStamp( SystemTime => $ThirtyDaysAgo );
            my $LastSentTime = 0;

            $Self->{DBObject}->Prepare(
                SQL => "SELECT create_time FROM survey_request WHERE LOWER(send_to) = '$To' "
                    . "AND create_time >= '$ThirtyDaysAgo' ORDER BY create_time DESC"
            );

            # fetch the result
            my @Rows;
            while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                push @Rows, $Row[0];
            }

            # If we have reached the maximum amount of surveys per month
            if ( scalar @Rows >= $AmountOfSurveysPer30Days ) {
                return;
            }
        }
    }

    # check if a survey is sent in the last time
    my $SendPeriod = $Self->{ConfigObject}->Get('Survey::SendPeriod');
    if ($SendPeriod) {
        my $LastSentTime = 0;

        # get send time
        $Self->{DBObject}->Prepare(
            SQL => "SELECT send_time FROM survey_request WHERE LOWER(send_to) = '$To' "
                . "ORDER BY send_time DESC",
            Limit => 1,
        );

        # fetch the result
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $LastSentTime = $Row[0];
        }
        if ($LastSentTime) {
            my $Now = $Self->{TimeObject}->SystemTime();
            $LastSentTime = $Self->{TimeObject}->TimeStamp2SystemTime( String => $LastSentTime );

            return if ( $LastSentTime + $SendPeriod * 60 * 60 * 24 ) > $Now;

        }
    }
    my $SendInHoursAfterClose = $Self->{ConfigObject}->Get('Survey::SendInHoursAfterClose');
    $Param{TicketID} = $Self->{DBObject}->Quote( $Param{TicketID}, 'Integer' );

    # If no Delayed Sending is configured
    # send immediately, log it to Ticket History and insert it to survey_requests
    # including sent_time
    if ( !$SendInHoursAfterClose && !$Param{TriggerSendRequests} ) {

        # insert request
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO survey_request "
                . " (ticket_id, survey_id, valid_id, public_survey_key, send_to, send_time, create_time) "
                . " VALUES ($Param{TicketID}, $SurveyID, 1, '"
                . $Self->{DBObject}->Quote($PublicSurveyKey) . "', "
                . "'$To', current_timestamp, current_timestamp)",
        );

        # log action on ticket
        $Self->{TicketObject}->HistoryAdd(
            TicketID     => $Param{TicketID},
            CreateUserID => 1,
            HistoryType  => 'Misc',
            Name         => "Sent customer survey to '$To'.",
        );
    }

    # If we should send delayed just cronjobs deliver "TriggerSendRequests",
    # so we were called by a closed ticket
    # and have to create the survey_request record with no send_time
    # (will be filled in by cronjob as soon as it really got delivered)
    # additionally no Ticket History yet, cause no send has happened
    elsif ( $SendInHoursAfterClose && !$Param{TriggerSendRequests} ) {

        # insert request
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO survey_request "
                . " (ticket_id, survey_id, valid_id, public_survey_key, send_to, create_time) "
                . " VALUES ($Param{TicketID}, $SurveyID, 1, '"
                . $Self->{DBObject}->Quote($PublicSurveyKey) . "', "
                . "'$To', current_timestamp)",
        );

    }

    # here we got called by cron, and no matter if SendInHoursAfterClose is configured
    # or not, we have to send the survey requests that weren't sent yet
    # this time we have to update the survey_request line
    # to fill in the send_time and create the Ticket History entry
    elsif (
        $Param{TriggerSendRequests}
        && $Param{SurveyRequestID}
        && $Param{SurveyRequestID} =~ /^\d+$/
        )
    {
        $Self->{DBObject}->Do(
            SQL => "UPDATE survey_request "
                . "SET send_time = current_timestamp WHERE id = $Param{SurveyRequestID}",
        );

        # log action on ticket
        $Self->{TicketObject}->HistoryAdd(
            TicketID     => $Param{TicketID},
            CreateUserID => 1,
            HistoryType  => 'Misc',
            Name         => "Sent customer survey to '$To'.",
        );
    }

    # get charset
    my $Charset = $Self->{ConfigObject}->Get('DefaultCharset') || 'uft-8';

    # clean html and convert the Field in html (\n --><br>)
    $Body =~ s{\A\$html\/text\$\s(.*)}{$1}xms;
    if ( !$1 ) {

        # convert body to html
        $Body = $Self->{HTMLUtilsObject}->ToHTML(
            String => $Body,
        );
    }

    # prepare html links
    $Self->{HTMLUtilsObject}->LinkQuote(
        String => \$Body,
    );

    # complete html document
    $Body = $Self->{HTMLUtilsObject}->DocumentComplete(
        String  => $Body,
        Charset => $Charset,
    );

    # send survey
    return $Self->{SendmailObject}->Send(
        From     => $Survey{NotificationSender},
        To       => $To,
        Subject  => $Subject,
        MimeType => 'text/html',
        Charset  => $Charset,
        Body     => $Body,
    ) if ( !$SendInHoursAfterClose || $Param{TriggerSendRequests} );
}

=item RequestGet()

to get an array list of request elements

    my %RequestData = $SurveyObject->RequestGet(
        PublicSurveyKey => 'Aw5de3Xf5qA',
    );

=cut

sub RequestGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{PublicSurveyKey} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need PublicSurveyKey!',
        );
        return;
    }

    # quote
    $Param{PublicSurveyKey} = $Self->{DBObject}->Quote( $Param{PublicSurveyKey} );

    # get vote list
    $Self->{DBObject}->Prepare(
        SQL =>
            "SELECT id, ticket_id, survey_id, valid_id, public_survey_key, send_to, send_time, vote_time "
            . "FROM survey_request WHERE public_survey_key = '$Param{PublicSurveyKey}' ",
        Limit => 1,
    );

    # fetch the result
    my %RequestData;

    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $RequestData{RequestID}       = $Row[0];
        $RequestData{TicketID}        = $Row[1];
        $RequestData{SurveyID}        = $Row[2];
        $RequestData{ValidID}         = $Row[3];
        $RequestData{PublicSurveyKey} = $Row[4];
        $RequestData{SendTo}          = $Row[5];
        $RequestData{SendTime}        = $Row[6];
        $RequestData{VoteTime}        = $Row[7];
    }

    return %RequestData;
}

=item PublicSurveyGet()

to get all public attributes of a survey

    my %PublicSurvey = $SurveyObject->PublicSurveyGet(
            PublicSurveyKey => 'Aw5de3Xf5qA',
            Invalid         => 1, # optional to know if one key was already used.
    );

=cut

sub PublicSurveyGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{PublicSurveyKey} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need SurveyID!',
        );
        return;
    }

    # quote
    $Param{PublicSurveyKey} = $Self->{DBObject}->Quote( $Param{PublicSurveyKey} );

    my $ValidID = 'AND valid_id = 1';

    # if not invalid show just valid keys
    if ( $Param{Invalid} ) {
        $ValidID = 'AND valid_id = 0';
    }

    # get request
    $Self->{DBObject}->Prepare(
        SQL => "SELECT survey_id FROM survey_request "
            . "WHERE public_survey_key = '$Param{PublicSurveyKey}' $ValidID ",
        Limit => 1,
    );

    # fetch the result
    my $SurveyID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $SurveyID = $Row[0];
    }

    return () if !$SurveyID;

    # get survey
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, surveynumber, title, introduction "
            . "FROM survey WHERE id = $SurveyID AND (status = 'Master' OR status = 'Valid')",
        Limit => 1,
    );

    # fetch the result
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{SurveyID}     = $Row[0];
        $Data{SurveyNumber} = $Row[1];
        $Data{Title}        = $Row[2];
        $Data{Introduction} = $Row[3];
    }

    return %Data;
}

=item PublicAnswerSave()

to save a public vote

    $SurveyObject->PublicAnswerSave(
        PublicSurveyKey => 'aVkdE82Dw2qw6erCda',
        QuestionID => 4,
        VoteValue => 'The Value',
    );

=cut

sub PublicAnswerSave {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(PublicSurveyKey QuestionID VoteValue)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # quote
    for my $Argument (qw(PublicSurveyKey VoteValue)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    $Param{QuestionID} = $Self->{DBObject}->Quote( $Param{QuestionID}, 'Integer' );

    # get request
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id "
            . " FROM survey_request WHERE public_survey_key = '$Param{PublicSurveyKey}' AND valid_id = 1",
        Limit => 1,
    );

    # fetch the result
    my $RequestID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $RequestID = $Row[0];
    }

    return if !$RequestID;

    # insert vote
    return $Self->{DBObject}->Do(
        SQL => "INSERT INTO survey_vote (request_id, question_id, vote_value, create_time) VALUES ("
            . "$RequestID, "
            . "$Param{QuestionID}, "
            . "'$Param{VoteValue}', "
            . "current_timestamp)",
    );
}

=item PublicSurveyInvalidSet()

to set a request invalid

    $SurveyObject->PublicSurveyInvalidSet(
        PublicSurveyKey => 'aVkdE82Dw2qw6erCda',
    );

=cut

sub PublicSurveyInvalidSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{PublicSurveyKey} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need SurveyID!'
        );
        return;
    }

    # quote
    $Param{PublicSurveyKey} = $Self->{DBObject}->Quote( $Param{PublicSurveyKey} );

    # get request
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id "
            . " FROM survey_request WHERE public_survey_key = '$Param{PublicSurveyKey}'",
        Limit => 1,
    );

    # fetch the result
    my $RequestID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $RequestID = $Row[0];
    }

    return if !$RequestID;

    # update request
    return $Self->{DBObject}->Do(
        SQL => "UPDATE survey_request SET "
            . "valid_id = 0, "
            . "vote_time = current_timestamp "
            . "WHERE id = $RequestID",
    );
}

=item SurveyQueueSave()

add a survey_queue relation

my $Result = $SurveyObject->SurveyQueueSave(
    SurveyID => 3,
    QueueIDs => [1, 7],
);

=cut

sub SurveyQueueSave {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(SurveyID QueueIDs)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Argument!" );
            return;
        }
    }

    # quote
    for my $QueueID ( @{ $Param{QueueIDs} } ) {
        $QueueID = $Self->{DBObject}->Quote( $QueueID, 'Integer' );
    }
    $Param{SurveyID} = $Self->{DBObject}->Quote( $Param{SurveyID}, 'Integer' );

    # remove all existing relations
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM survey_queue WHERE survey_id = $Param{SurveyID}",
    );

    # add all survey_queue relations to database
    for my $QueueID ( @{ $Param{QueueIDs} } ) {

        # add survey_queue relation to database
        return if !$Self->{DBObject}->Do(
            SQL => "INSERT INTO survey_queue"
                . " (survey_id, queue_id) VALUES"
                . " ($Param{SurveyID}, $QueueID)",
        );
    }

    return 1;
}

=item SurveyQueueGet()

get a survey_queue relation as an array reference

my $QueuesRef = $SurveyObject->SurveyQueueGet(
    SurveyID => 3,
);

=cut

sub SurveyQueueGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SurveyID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need SurveyID!',
        );
        return;
    }

    # quote
    $Param{SurveyID} = $Self->{DBObject}->Quote( $Param{SurveyID}, 'Integer' );

    # get queue ids from database
    $Self->{DBObject}->Prepare(
        SQL => "SELECT queue_id FROM survey_queue"
            . " WHERE survey_id = $Param{SurveyID} ORDER BY queue_id ASC",
    );

    # fetch the result
    my @QueueList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @QueueList, $Row[0];
    }

    return \@QueueList;
}

=item SurveySearch()

search in surveys

    my @IDs = $SurveyObject->SurveySearch(

        Number              => '*134*',                                         # (optional)
        Title               => '*some title*',                                  # (optional)
        Introduction        => '*some introduction*',                           # (optional)
        Description         => '*some desription*',                             # (optional)
        NotificationSender  => '*user@domain*',                                 # (optional)
        NotificationSubject => '*some notification subject*',                   # (optional)
        NotificationBody    => '*some notification body*',                      # (optional)

        # is searching in Number, Title, Introduction, Description, NotificationSender,
        # NotificationSubject and NotificationBody
        What   => '*some text*',                                                # (optional)

        Status => '*some status*',                                              # (optional)

        CreateTime          => 's.create_time',
        CreateBy            => 's.create_by',
        ChangeTime          => 's.change_time',
        ChangeBy            => 's.change_by',

        OrderBy => [ 'SurveyID', 'Title' ],                                     # (optional)
        # default: [ 'SurveyID' ],
        # ()SurveyID, Number, Title, Introduction, Description,
        # NotificationSender, NotificationSubject, NotificationBody,
        # Status, CreateTime, CreateBy, ChangeTime, ChangeBy)

        # Additional information for OrderBy:
        # The OrderByDirection can be specified for each OrderBy attribute.
        # The pairing is made by the array indices.

        OrderByDirection => [ 'Down', 'Up' ],                                   # (optional)
        # default: [ 'Down' ]
        # (Down | Up)

        Limit     => 150,                                                       # (optional)
        UserID    => 1,
    );

=cut

sub SurveySearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # verify that all passed array parameters contain an arrayref
    ARGUMENT:
    for my $Argument (qw(OrderBy OrderByDirection)) {

        if ( !defined $Param{$Argument} ) {
            $Param{$Argument} ||= [];

            next ARGUMENT;
        }

        if ( ref $Param{$Argument} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$Argument must be an array reference!",
            );
            return;
        }
    }

    # define order table
    my %OrderByTable = (

        # Survey item attributes
        SurveyID            => 's.id',
        Number              => 's.surveynumber',
        Title               => 's.title',
        Introduction        => 's.introduction',
        Description         => 's.description',
        NotificationSender  => 's.notification_sender',
        NotificationSubject => 's.notification_subject',
        NotificationBody    => 's.notification_body',
        Status              => 's.status',
        CreateTime          => 's.create_time',
        CreateBy            => 's.create_by',
        ChangeTime          => 's.change_time',
        ChangeBy            => 's.change_by',
    );

    # check if OrderBy contains only unique valid values
    my %OrderBySeen;
    for my $OrderBy ( @{ $Param{OrderBy} } ) {

        if ( !$OrderBy || !$OrderByTable{$OrderBy} || $OrderBySeen{$OrderBy} ) {

            # found an error
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "OrderBy contains invalid value '$OrderBy' "
                    . 'or the value is used more than once!',
            );
            return;
        }

        # remember the value to check if it appears more than once
        $OrderBySeen{$OrderBy} = 1;

    }

    # check if OrderByDirection array contains only 'Up' or 'Down'
    DIRECTION:
    for my $Direction ( @{ $Param{OrderByDirection} } ) {

        # only 'Up' or 'Down' allowed
        next DIRECTION if $Direction eq 'Up';
        next DIRECTION if $Direction eq 'Down';

        # found an error
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "OrderByDirection can only contain 'Up' or 'Down'!",
        );
        return;
    }

    # assemble the ORDER BY clause
    my @SQLOrderBy;
    my @OrderByFields;
    my $Count = 0;
    for my $OrderBy ( @{ $Param{OrderBy} } ) {

        # set the default order direction
        my $Direction = 'DESC';

        # add the given order direction
        if ( $Param{OrderByDirection}->[$Count] ) {
            if ( $Param{OrderByDirection}->[$Count] eq 'Up' ) {
                $Direction = 'ASC';
            }
            elsif ( $Param{OrderByDirection}->[$Count] eq 'Down' ) {
                $Direction = 'DESC';
            }
        }

        # add SQL
        push @SQLOrderBy,    "$OrderByTable{$OrderBy} $Direction";
        push @OrderByFields, $OrderByTable{$OrderBy};
    }
    continue {
        $Count++;
    }

    # if there is a possibility that the ordering is not determined
    # we add an descending ordering by id
    if ( !grep { $_ eq 'SurveyID' } ( @{ $Param{OrderBy} } ) ) {
        push @SQLOrderBy, "$OrderByTable{SurveyID} DESC";
    }

    # sql
    my $SQL = 'SELECT s.id ';

    # extended SQL
    my $Ext = '';

    # fulltext search
    if ( $Param{What} && $Param{What} ne '*' ) {

        # define the search fields for fulltext search
        my @SearchFields = (
            's.surveynumber',
            's.title',
            's.introduction',
            's.description',
            's.notification_sender',
            's.notification_subject',
            's.notification_body',
            's.status',
        );

        # add the SQL for the fulltext search
        $Ext .= $Self->{DBObject}->QueryCondition(
            Key          => \@SearchFields,
            Value        => $Param{What},
            SearchPrefix => '*',
            SearchSuffix => '*',
        );
    }

    # search for the number
    if ( $Param{Number} ) {
        $Param{Number} =~ s/\*/%/g;
        $Param{Number} =~ s/%%/%/g;
        $Param{Number} = $Self->{DBObject}->Quote( $Param{Number}, 'Like' );
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= " LOWER(s.number) LIKE LOWER('" . $Param{Number} . "') $Self->{LikeEscapeString}";
    }

    # search for the title
    if ( $Param{Title} ) {
        $Param{Title} = "\%$Param{Title}\%";
        $Param{Title} =~ s/\*/%/g;
        $Param{Title} =~ s/%%/%/g;
        $Param{Title} = $Self->{DBObject}->Quote( $Param{Title}, 'Like' );
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= " LOWER(s.title) LIKE LOWER('" . $Param{Title} . "') $Self->{LikeEscapeString}";
    }

    # search for the introduction
    if ( $Param{Introduction} ) {
        $Param{Introduction} = "\%$Param{Introduction}\%";
        $Param{Introduction} =~ s/\*/%/g;
        $Param{Introduction} =~ s/%%/%/g;
        $Param{Introduction} = $Self->{DBObject}->Quote( $Param{Introduction}, 'Like' );
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext
            .= " LOWER(s.introduction) LIKE LOWER('"
            . $Param{Introduction}
            . "') $Self->{LikeEscapeString}";
    }

    # search for the description
    if ( $Param{Description} ) {
        $Param{Description} = "\%$Param{Description}\%";
        $Param{Description} =~ s/\*/%/g;
        $Param{Description} =~ s/%%/%/g;
        $Param{Description} = $Self->{DBObject}->Quote( $Param{Description}, 'Like' );
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext
            .= " LOWER(s.description) LIKE LOWER('"
            . $Param{Description}
            . "') $Self->{LikeEscapeString}";
    }

    # search for the notification sender
    if ( $Param{NotificationSender} ) {
        $Param{NotificationSender} = "\%$Param{NotificationSender}\%";
        $Param{NotificationSender} =~ s/\*/%/g;
        $Param{NotificationSender} =~ s/%%/%/g;
        $Param{NotificationSender} = $Self->{DBObject}->Quote( $Param{NotificationSender}, 'Like' );
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext
            .= " LOWER(s.notification_sender) LIKE LOWER('"
            . $Param{NotificationSender}
            . "') $Self->{LikeEscapeString}";
    }

    # search for the notification subject
    if ( $Param{NotificationSubject} ) {
        $Param{NotificationSubject} = "\%$Param{NotificationSubject}\%";
        $Param{NotificationSubject} =~ s/\*/%/g;
        $Param{NotificationSubject} =~ s/%%/%/g;
        $Param{NotificationSubject}
            = $Self->{DBObject}->Quote( $Param{NotificationSubject}, 'Like' );
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext
            .= " LOWER(s.notification_subject) LIKE LOWER('"
            . $Param{NotificationSubject}
            . "') $Self->{LikeEscapeString}";
    }

    # search for the notification body
    if ( $Param{NotificationBody} ) {
        $Param{NotificationBody} = "\%$Param{NotificationBody}\%";
        $Param{NotificationBody} =~ s/\*/%/g;
        $Param{NotificationBody} =~ s/%%/%/g;
        $Param{NotificationBody} = $Self->{DBObject}->Quote( $Param{NotificationBody}, 'Like' );
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext
            .= " LOWER(s.notification_body) LIKE LOWER('"
            . $Param{NotificationBody}
            . "') $Self->{LikeEscapeString}";
    }

    # search for the status
    if ( $Param{Status} ) {
        $Param{Status} = "\%$Param{Status}\%";
        $Param{Status} =~ s/\*/%/g;
        $Param{Status} =~ s/%%/%/g;
        $Param{Status} = $Self->{DBObject}->Quote( $Param{Status}, 'Like' );
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= " LOWER(s.status) LIKE LOWER('" . $Param{Status} . "') $Self->{LikeEscapeString}";
    }

    # search for the create by
    if ( $Param{CreateBy} ) {
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= " s.create_by = " . $Param{CreateBy};
    }

    # search for the create by
    if ( $Param{ChangeBy} ) {
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= " s.create_by = " . $Param{ChangeBy};
    }

    # set time params
    my %TimeParams = (

        # times in change_item
        CreateTimeNewerDate => 's.create_time >=',
        CreateTimeOlderDate => 's.create_time <=',
        ChangeTimeNewerDate => 's.change_time >=',
        ChangeTimeOlderDate => 's.change_time <=',
    );

    # check and add time params to WHERE
    TIMEPARAM:
    for my $TimeParam ( keys %TimeParams ) {

        next TIMEPARAM if !$Param{$TimeParam};

        # check format
        if ( $Param{$TimeParam} !~ m{ \A \d\d\d\d-\d\d-\d\d \s \d\d:\d\d:\d\d \z }xms ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter $TimeParam has an invalid date format!",
            );

            return;
        }

        $Param{$TimeParam} = $Self->{DBObject}->Quote( $Param{$TimeParam} );

        # add time parameter to WHERE
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= "$TimeParams{$TimeParam} '$Param{$TimeParam}'";
    }

    # add WHERE statement
    if ($Ext) {
        $Ext = ' WHERE ' . $Ext;
    }

    # add the ORDER BY clause
    if (@SQLOrderBy) {
        $Ext .= 'ORDER BY ';
        $Ext .= join ', ', @SQLOrderBy;
        $Ext .= ' ';
        $SQL .= ', ' . join ', ', @OrderByFields;
    }

    # add extended SQL
    $SQL .= ' FROM survey s ';
    $SQL .= $Ext;

    # ask database
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Limit => $Param{Limit},
    );

    # fetch the result
    my @List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @List, $Row[0];
    }
    return @List;
}

=item GetRichTextDocumentComplete()

get some text ready to show as richtext attachment inline

    my $RichTextDocumentComplete = $SurveyObject->GetRichTextDocumentComplete(
        Text => $RichText,
    );

=cut

sub GetRichTextDocumentComplete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Text)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument parameter!",
            );
            return;
        }
    }

    # clean html string
    my $Text = $Param{Text};
    $Text =~ s{\A\$html\/text\$\s(.*)}{$1}xms;

    # get document complete
    my $HTMLDocumentComplete = $Self->{HTMLUtilsObject}->DocumentComplete(
        String  => $Text,
        Charset => 'utf-8',
    );

    return $HTMLDocumentComplete;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=head1 VERSION

$Revision: 1.64 $ $Date: 2012-01-19 15:55:23 $

=cut
