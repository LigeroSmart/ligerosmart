# --
# Kernel/System/Survey.pm - all survey funtions
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Survey.pm,v 1.34 2007-08-20 09:39:46 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Survey;

use strict;
use warnings;

use Digest::MD5;
use Kernel::System::Email;
use Kernel::System::Ticket;
use Kernel::System::CustomerUser;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.34 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Survey - survey lib

=head1 SYNOPSIS

All survey functions. E. g. to add survey or and functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::User;
    use Kernel::System::Survey;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $UserObject = Kernel::System::User->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
    );
    my $SurveyObject = Kernel::System::Survey->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        TimeObject => $TimeObject,
        DBObject => $DBObject,
        MainObject => $MainObject,
        UserObject => $UserObject,
    );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # check needed objects
    foreach (qw(ConfigObject LogObject TimeObject DBObject MainObject UserObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{SendmailObject} = Kernel::System::Email->new(%Param);
    $Self->{TicketObject} = Kernel::System::Ticket->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    return $Self;
}

=item SurveyList()

to get a array list of all survey items

    my @List = $SurveyObject->SurveyList();

=cut

sub SurveyList {
    my $Self = shift;
    my %Param = @_;
    # get survey list
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM survey ORDER BY create_time DESC",
    );
    my @List;
    # fetch the results
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@List, $Row[0]);
    }
    # return array
    return @List;
}

=item SurveyGet()

to get all attributes of a survey

    my %Survey = $SurveyObject->SurveyGet(
        SurveyID => 123
    );

=cut

sub SurveyGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get all attributes of a survey
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, surveynumber, title, introduction, description," .
            " status, create_time, create_by, change_time, change_by " .
            " FROM survey WHERE id = $Param{SurveyID}",
        Limit => 1,
    );
    # fetch the result
    my %Data;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{SurveyID} = $Row[0];
        $Data{SurveyNumber} = $Row[1];
        $Data{Title} = $Row[2];
        $Data{Introduction} = $Row[3];
        $Data{Description} = $Row[4];
        $Data{Status} = $Row[5];
        $Data{CreateTime} = $Row[6];
        $Data{CreateBy} = $Row[7];
        $Data{ChangeTime} = $Row[8];
        $Data{ChangeBy} = $Row[9];
    }
    if (%Data) {
        # added CreateBy
        my %CreateUserInfo = $Self->{UserObject}->GetUserData(
            UserID => $Data{CreateBy},
            Cached => 1,
        );
        $Data{CreateUserLogin} = $CreateUserInfo{UserLogin};
        $Data{CreateUserFirstname} = $CreateUserInfo{UserFirstname};
        $Data{CreateUserLastname} = $CreateUserInfo{UserLastname};
        # added ChangeBy
        my %ChangeUserInfo = $Self->{UserObject}->GetUserData(
            UserID => $Data{ChangeBy},
            Cached => 1,
        );
        $Data{ChangeUserLogin} = $ChangeUserInfo{UserLogin};
        $Data{ChangeUserFirstname} = $ChangeUserInfo{UserFirstname};
        $Data{ChangeUserLastname} = $ChangeUserInfo{UserLastname};
        # return hash
        return %Data;
    }
    else {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No such SurveyID $Param{SurveyID}!");
        return;
    }
}

=item SurveyStatusSet()

to set a new survey status (Valid, Invalid, Master)

    $StatusSet = $SurveyObject->SurveyStatusSet(
        SurveyID => 123,
        NewStatus => 'Master'
    );

=cut

sub SurveyStatusSet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID NewStatus)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(NewStatus)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get current status
    $Self->{DBObject}->Prepare(
        SQL => "SELECT status FROM survey WHERE id = $Param{SurveyID}",
        Limit => 1,
    );
    # fetch the result
    my $Status = '';
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Status = $Row[0];
    }
    # the curent status
    if ($Status eq 'New' || $Status eq 'Invalid') {
        # get the question ids
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id FROM survey_question WHERE survey_id = $Param{SurveyID}",
            Limit => 1,
        );
        # fetch the result
        my $Quest;
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Quest = $Row[0];
        }
        # if more then one question
        if ($Quest) {
            # get all questions (type radio and checkbox)
            $Self->{DBObject}->Prepare(
                SQL => "SELECT id FROM survey_question" .
                    " WHERE survey_id = $Param{SurveyID} AND (question_type = 'Radio' OR question_type = 'Checkbox')",
            );
            # init three vars
            my @QuestionIDs;
            # fetch the result
            while (my @Row = $Self->{DBObject}->FetchrowArray()) {
                push (@QuestionIDs, $Row[0]);
            }
            foreach my $OneID (@QuestionIDs) {
                # get all answer ids of a question
                $Self->{DBObject}->Prepare(
                    SQL => "SELECT id FROM survey_answer WHERE question_id = $OneID",
                );
                # fetch the result
                my $Counter = 0;
                while ($Self->{DBObject}->FetchrowArray()) {
                    $Counter++;
                }
                # its ok, if minimum two answers definied
                if ($Counter < 2) {
                    return 'IncompleteQuestion';
                }
            }
            # set new status if survey is complete
            if ($Param{NewStatus} eq 'Valid') {
                $Self->{DBObject}->Do(
                    SQL => "UPDATE survey SET status = 'Valid' WHERE id = $Param{SurveyID}",
                );
                return 'StatusSet';
            }
            # set status Master
            elsif ($Param{NewStatus} eq 'Master') {
                $Self->{DBObject}->Do(
                    SQL => "UPDATE survey SET status = 'Master' WHERE id = $Param{SurveyID}",
                );
                return 'StatusSet';
            }
        }
        else {
            return 'NoQuestion';
        }
    }
    elsif ($Status eq 'Valid') {
        # set status Master
        if ($Param{NewStatus} eq 'Master') {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = 'Valid' WHERE status = 'Master'",
            );
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = 'Master' WHERE id = $Param{SurveyID}",
            );
            return 'StatusSet';
        }
        # set status Invalid
        elsif ($Param{NewStatus} eq 'Invalid') {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = 'Invalid' WHERE id = $Param{SurveyID}",
            );
            return 'StatusSet';
        }
    }
    elsif ($Status eq 'Master') {
        # set status Valid
        if ($Param{NewStatus} eq 'Valid') {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = 'Valid' WHERE id = $Param{SurveyID}",
            );
            return 'StatusSet';
        }
        # set status Invalid
        elsif ($Param{NewStatus} eq 'Invalid') {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = 'Invalid' WHERE id = $Param{SurveyID}",
            );
            return 'StatusSet';
        }
    }
}

=item SurveySave()

to update an existing survey

    $SurveyObject->SurveySave(
        UserID => 1,
        SurveyID => 4,
        Title => 'A Title',
        Introduction => 'The introduction of the survey',
        Description => 'The internal description of the survey',
    );

=cut

sub SurveySave {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID SurveyID Title Introduction Description)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(Title Introduction Description)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(UserID SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    if ($Param{Title} && $Param{Introduction} && $Param{Description}) {
        my $CurrentTime = $Self->{TimeObject}->CurrentTimestamp();
        # update the survey
        $Self->{DBObject}->Do(
            SQL => "UPDATE survey SET " .
                "title = '$Param{Title}', " .
                "introduction = '$Param{Introduction}', " .
                "description = '$Param{Description}', " .
                "change_time = '$CurrentTime', " .
                "change_by = $Param{UserID} " .
                "WHERE id = $Param{SurveyID}",
        );
    }
    return 1;
}

=item SurveyNew()

to add a new survey

    my $SurveyID = $SurveyObject->SurveyNew(
        UserID => 1,
        Title => 'A Title',
        Introduction => 'The introduction of the survey',
        Description => 'The internal description of the survey',
    );

=cut

sub SurveyNew {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID Title Introduction Description)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(Title Introduction Description)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    if ($Param{Title} && $Param{Introduction} && $Param{Description}) {
        my $CurrentTime = $Self->{TimeObject}->CurrentTimestamp();
        # insert a new survey
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO survey (title, introduction, description," .
                " status, create_time, create_by, change_time, change_by) VALUES (" .
                "'$Param{Title}', " .
                "'$Param{Introduction}', " .
                "'$Param{Description}', " .
                "'New', " .
                "'$CurrentTime', " .
                "$Param{UserID}, " .
                "'$CurrentTime', " .
                "$Param{UserID})"
        );
        # get the id of the survey
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id FROM survey WHERE " .
                "title = '$Param{Title}' AND " .
                "introduction = '$Param{Introduction}' AND " .
                "description = '$Param{Description}' " .
                "ORDER BY create_time DESC",
            Limit => 1,
        );
        # fetch the result
        my $SurveyID;
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $SurveyID = $Row[0];
        }
        # set the survey number
        $Self->{DBObject}->Do(
            SQL => "UPDATE survey SET " .
                "surveynumber = '" . ($SurveyID + 10000) . "' " .
                "WHERE id = $SurveyID",
        );
        return $SurveyID;
    }
    else {
        return;
    }
}

=item QuestionList()

to get a array list of all question items

    my @List = $SurveyObject->QuestionList(
        SurveyID => 1
    );

=cut

sub QuestionList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get all questions of a survey
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, survey_id, question, question_type " .
            " FROM survey_question WHERE survey_id = $Param{SurveyID} ORDER BY position",
    );
    # fetch th result
    my @List;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %Data;
        $Data{QuestionID} = $Row[0];
        $Data{SurveyID} = $Row[1];
        $Data{Question} = $Row[2];
        $Data{Type} = $Row[3];
        push (@List, \%Data);
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID SurveyID Question Type)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(Question Type)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(UserID SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    if ($Param{Question}) {
        my $CurrentTime = $Self->{TimeObject}->CurrentTimestamp();
        # insert a new question
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO survey_question (survey_id, question, question_type, " .
                "position, create_time, create_by, change_time, change_by) VALUES (" .
                "$Param{SurveyID}, " .
                "'$Param{Question}', " .
                "'$Param{Type}', " .
                "255, " .
                "'$CurrentTime', " .
                "$Param{UserID}, " .
                "'$CurrentTime', " .
                "$Param{UserID})"
        );
    }
    return 1;
}

=item QuestionDelete()

to delete a question from a survey

    $SurveyObject->QuestionDelete(
        SurveyID => 1,
        QuestionID => 10,
    );

=cut

sub QuestionDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID QuestionID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(SurveyID QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # delete all answers of a question
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM survey_answer WHERE " .
            "question_id = $Param{QuestionID}"
    );
    # delete th question
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM survey_question WHERE " .
            "id = $Param{QuestionID} AND " .
            "survey_id = $Param{SurveyID}"
    );
    return 1;
}

=item QuestionSort()

to sort all questions from a survey

    $SurveyObject->QuestionSort(
        SurveyID => 1,
    );

=cut

sub QuestionSort {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get all question of a survey (sorted by position)
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM survey_question" .
            " WHERE survey_id = $Param{SurveyID} ORDER BY position",
    );
    my @List;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@List, $Row[0]);
    }
    my $Counter = 1;
    foreach my $QuestionID (@List) {
        $Self->{DBObject}->Do(
            SQL => "UPDATE survey_question SET position = $Counter WHERE id = $QuestionID",
        );
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID QuestionID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(SurveyID QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get position
    $Self->{DBObject}->Prepare(
        SQL => "SELECT position FROM survey_question" .
            " WHERE id = $Param{QuestionID} AND survey_id = $Param{SurveyID}",
        Limit => 1,
    );
    my $Position;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Position = $Row[0];
    }
    if ($Position && $Position > 1) {
        my $PositionUp = $Position - 1;
        # get question
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id FROM survey_question" .
                " WHERE survey_id = $Param{SurveyID} AND position = $PositionUp",
            Limit => 1,
        );
        my $QuestionIDDown;
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $QuestionIDDown = $Row[0];
        }
        if ($QuestionIDDown) {
            # update position
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_question SET " .
                    "position = $Position " .
                    "WHERE id = $QuestionIDDown",
            );
            # update position
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_question SET " .
                    "position = $PositionUp " .
                    "WHERE id = $Param{QuestionID}",
            );
        }
    }
    return 1;
}

=item QuestionDown()

to move a question down

    $SurveyObject->QuestionDown(
        SurveyID => 1,
        QuestionID => 4,
    );

=cut

sub QuestionDown {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID QuestionID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(SurveyID QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get position
    $Self->{DBObject}->Prepare(
        SQL => "SELECT position FROM survey_question" .
            " WHERE id = $Param{QuestionID} AND survey_id = $Param{SurveyID}",
        Limit => 1,
    );
    my $Position;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Position = $Row[0];
    }
    if ($Position) {
        my $PositionDown = $Position + 1;
        # get question
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id FROM survey_question" .
                " WHERE survey_id = $Param{SurveyID} AND position = $PositionDown",
            Limit => 1,
        );
        my $QuestionIDUp;
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $QuestionIDUp = $Row[0];
        }
        if ($QuestionIDUp) {
            # update position
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_question SET " .
                    "position = $Position " .
                    "WHERE id = $QuestionIDUp"
            );
            # update position
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_question SET " .
                    "position = $PositionDown " .
                    "WHERE id = $Param{QuestionID}"
            );
        }
    }
    return 1;
}

=item QuestionGet()

to get all attributes of a question

    my %Question = $SurveyObject->QuestionGet(
        QuestionID => 123
    );

=cut

sub QuestionGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(QuestionID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get question
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, survey_id, question, question_type, position, " .
            "create_time, create_by, change_time, change_by " .
            "FROM survey_question WHERE id = $Param{QuestionID}",
        Limit => 1,
    );
    my %Data;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{QuestionID} = $Row[0];
        $Data{SurveyID} = $Row[1];
        $Data{Question} = $Row[2];
        $Data{Type} = $Row[3];
        $Data{Position} = $Row[4];
        $Data{CreateTime} = $Row[5];
        $Data{CreateBy} = $Row[6];
        $Data{ChangeTime} = $Row[7];
        $Data{ChangeBy} = $Row[8];
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID QuestionID SurveyID Question)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(Question)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(UserID QuestionID SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $CurrentTime = $Self->{TimeObject}->CurrentTimestamp();
    # update question
    $Self->{DBObject}->Do(
        SQL => "UPDATE survey_question SET " .
            "question = '$Param{Question}', " .
            "change_time = '$CurrentTime', " .
            "change_by = $Param{UserID} " .
            "WHERE id = $Param{QuestionID} ",
            "AND survey_id = $Param{SurveyID}",
    );
    return 1;
}

=item QuestionCount()

to count all questions of a survey

    my $CountQuestion = $SurveyObject->QuestionCount(
        SurveyID => 123
    );

=cut

sub QuestionCount {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # count questions
    $Self->{DBObject}->Prepare(
        SQL => "SELECT COUNT(id) FROM survey_question WHERE survey_id = $Param{SurveyID}",
        Limit => 1,
    );
    my $CountQuestion;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(QuestionID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get answer list
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, question_id, answer " .
            " FROM survey_answer WHERE question_id = $Param{QuestionID} ORDER BY position",
    );
    my @List;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %Data;
        $Data{AnswerID} = $Row[0];
        $Data{QuestionID} = $Row[1];
        $Data{Answer} = $Row[2];
        push (@List, \%Data);
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID QuestionID Answer)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(Answer)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(UserID QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    if ($Param{Answer}) {
        my $CurrentTime = $Self->{TimeObject}->CurrentTimestamp();
        # insert answer
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO survey_answer (question_id, answer, position, " .
                "create_time, create_by, change_time, change_by) VALUES (" .
                "$Param{QuestionID}, " .
                "'$Param{Answer}', " .
                "255, " .
                "'$CurrentTime', " .
                "$Param{UserID}, " .
                "'$CurrentTime', " .
                "$Param{UserID})"
        );
    }
    return 1;
}

=item AnswerDelete()

to delete a answer from a question

    $SurveyObject->AnswerDelete(
        QuestionID => 10,
        AnswerID => 4,
    );

=cut

sub AnswerDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(QuestionID AnswerID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(QuestionID AnswerID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # delete answer
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM survey_answer WHERE " .
            "id = $Param{AnswerID} AND " .
            "question_id = $Param{QuestionID}"
    );
    return 1;
}

=item AnswerSort()

to sort all answers from a question

    $SurveyObject->AnswerSort(
        QuestionID => 1,
    );

=cut

sub AnswerSort {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(QuestionID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get answer list
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM survey_answer" .
            " WHERE question_id = $Param{QuestionID} ORDER BY position",
    );
    my @List;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@List, $Row[0]);
    }
    my $Counter = 1;
    foreach my $AnswerID (@List) {
        # update position
        $Self->{DBObject}->Do(
            SQL => "UPDATE survey_answer SET position = $Counter WHERE id = $AnswerID",
        );
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(QuestionID AnswerID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(QuestionID AnswerID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get position
    $Self->{DBObject}->Prepare(
        SQL => "SELECT position FROM survey_answer" .
            " WHERE id = $Param{AnswerID} AND question_id = $Param{QuestionID}",
        Limit => 1,
    );
    my $Position;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Position = $Row[0];
    }
    if ($Position && $Position > 1) {
        my $PositionUp = $Position - 1;
        # get answer
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id FROM survey_answer" .
                " WHERE question_id = $Param{QuestionID} AND position = $PositionUp",
            Limit => 1,
        );
        my $AnswerIDDown;
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $AnswerIDDown = $Row[0];
        }
        if ($AnswerIDDown) {
            # update position
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_answer SET " .
                    "position = $Position " .
                    "WHERE id = $AnswerIDDown"
            );
            # update position
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_answer SET " .
                    "position = $PositionUp " .
                    "WHERE id = $Param{AnswerID}"
            );
        }
    }
    return 1;
}

=item AnswerDown()

to move a answer down

    $SurveyObject->AnswerDown(
        QuestionID => 4,
        AnswerID => 1,
    );

=cut

sub AnswerDown {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(QuestionID AnswerID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(QuestionID AnswerID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get position
    $Self->{DBObject}->Prepare(
        SQL => "SELECT position FROM survey_answer" .
            " WHERE id = $Param{AnswerID} AND question_id = $Param{QuestionID}",
        Limit => 1,
    );
    my $Position;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Position = $Row[0];
    }
    if ($Position) {
        my $PositionDown = $Position + 1;
        # get answer
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id FROM survey_answer" .
                " WHERE question_id = $Param{QuestionID} AND position = $PositionDown",
            Limit => 1,
        );
        my $AnswerIDUp;
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $AnswerIDUp = $Row[0];
        }
        if ($AnswerIDUp) {
            # update position
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_answer SET " .
                    "position = $Position " .
                    "WHERE id = $AnswerIDUp"
            );
            # update position
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_answer SET " .
                    "position = $PositionDown " .
                    "WHERE id = $Param{AnswerID}"
            );
        }
    }
    return 1;
}

=item AnswerGet()

to get all attributes of a answer

    my %Answer = $SurveyObject->AnswerGet(
        AnswerID => 123
    );

=cut

sub AnswerGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(AnswerID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(AnswerID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get answer
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, question_id, answer, position, create_time, create_by, change_time, change_by " .
            "FROM survey_answer WHERE id = $Param{AnswerID}",
        Limit => 1,
    );
    my %Data;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{AnswerID} = $Row[0];
        $Data{QuestionID} = $Row[1];
        $Data{Answer} = $Row[2];
        $Data{Position} = $Row[3];
        $Data{CreateTime} = $Row[4];
        $Data{CreateBy} = $Row[5];
        $Data{ChangeTime} = $Row[6];
        $Data{ChangeBy} = $Row[7];
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID AnswerID QuestionID Answer)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(Answer)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(UserID AnswerID QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    if ($Param{Answer}) {
        my $CurrentTime = $Self->{TimeObject}->CurrentTimestamp();
        # update answer
        $Self->{DBObject}->Do(
            SQL => "UPDATE survey_answer SET " .
                "answer = '$Param{Answer}', " .
                "change_time = '$CurrentTime', " .
                "change_by = $Param{UserID} " .
                "WHERE id = $Param{AnswerID} ",
                "AND question_id = $Param{QuestionID}",
        );
    }
    return 1;
}

=item AnswerCount()

to count all answers of a question

    my $CountAnswer = $SurveyObject->AnswerCount(
        QuestionID => 123
    );

=cut

sub AnswerCount {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(QuestionID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # count answers
    $Self->{DBObject}->Prepare(
        SQL => "SELECT COUNT(id) FROM survey_answer WHERE question_id = $Param{QuestionID}",
        Limit => 1,
    );
    my $CountAnswer;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get vote list
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, ticket_id, send_time, vote_time " .
            "FROM survey_request WHERE survey_id = $Param{SurveyID} " .
            "AND valid_id = 0 ORDER BY vote_time DESC",
    );
    my @List;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %Data;
        $Data{RequestID} = $Row[0];
        $Data{TicketID} = $Row[1];
        $Data{SendTime} = $Row[2];
        $Data{VoteTime} = $Row[3];
        push (@List, \%Data);
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(RequestID QuestionID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(RequestID QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get vote
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, vote_value FROM survey_vote" .
            " WHERE request_id = $Param{RequestID} AND question_id = $Param{QuestionID}",
        Limit => 1,
    );
    my @List;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %Data;
        $Data{RequestID} = $Row[0];
        $Data{VoteValue} = $Row[1] || '-';
        push (@List, \%Data);
    }
    return @List;
}

=item CountVote()

to count all votes of a survey

    my $CountVote = $SurveyObject->CountVote(
        QuestionID => 123,
        VoteValue => 'The Value',
    );

=cut

sub CountVote {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(QuestionID VoteValue)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(VoteValue)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # count votes
    $Self->{DBObject}->Prepare(
        SQL => "SELECT COUNT(vote_value) FROM survey_vote WHERE " .
            "question_id = $Param{QuestionID} AND vote_value = '$Param{VoteValue}'",
        Limit => 1,
    );
    my $CountVote;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID ValidID)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # count requests
    my $SQL = "SELECT COUNT(id) FROM survey_request WHERE survey_id = $Param{SurveyID}";
    if (!$Param{ValidID}) {
        $SQL .= " AND valid_id = 0";
    }
    elsif ($Param{ValidID} eq 1) {
        $SQL .= " AND valid_id = 1";
    }
    $Self->{DBObject}->Prepare(
        SQL => $SQL,
        Limit => 1,
    );
    my $CountRequest;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ElementID Element)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(Element)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ElementID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $ElementExists = 'No';
    if ($Param{Element} eq 'Survey') {
        # count surveys
        $Self->{DBObject}->Prepare(
            SQL => "SELECT COUNT(id) FROM survey WHERE id = $Param{ElementID}",
            Limit => 1,
        );
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            if ($Row[0]) {
                $ElementExists = 'Yes';
            }
        }
    }
    elsif ($Param{Element} eq 'Question') {
        # count questions
        $Self->{DBObject}->Prepare(
            SQL => "SELECT COUNT(id) FROM survey_question WHERE id = $Param{ElementID}",
            Limit => 1,
        );
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            if ($Row[0]) {
                $ElementExists = 'Yes';
            }
        }
    }
    elsif ($Param{Element} eq 'Answer') {
        # count answers
        $Self->{DBObject}->Prepare(
            SQL => "SELECT COUNT(id) FROM survey_answer WHERE id = $Param{ElementID}",
            Limit => 1,
        );
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            if ($Row[0]) {
                $ElementExists = 'Yes';
            }
        }
    }
    elsif ($Param{Element} eq 'Request') {
        # count requests
        $Self->{DBObject}->Prepare(
            SQL => "SELECT COUNT(id) FROM survey_request WHERE id = $Param{ElementID}",
            Limit => 1,
        );
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            if ($Row[0]) {
                $ElementExists = 'Yes';
            }
        }
    }
    return $ElementExists;
}

=item RequestSend()

to send a request to a customer

    $SurveyObject->RequestSend(
        TicketID => 123,
    );

=cut

sub RequestSend {
    my $Self = shift;
    my %Param = @_;
    my $MasterID;
    # check needed stuff
    foreach (qw(TicketID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # create PublicSurveyKey
    my $md5 = Digest::MD5->new();
    $md5->add($Self->{TimeObject}->SystemTime() . int(rand(999999999)));
    my $PublicSurveyKey = $md5->hexdigest;
    # find master survey
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM survey WHERE status = 'Master'",
        Limit => 1,
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $MasterID = $Row[0];
    }
    # if master survey exists
    if ($MasterID) {
        my $Subject = $Self->{ConfigObject}->Get('Survey::NotificationSubject');
        my $Body = $Self->{ConfigObject}->Get('Survey::NotificationBody');
        # ticket data
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Param{TicketID});
        foreach (keys %Ticket) {
            if (defined($Ticket{$_})) {
                $Subject =~ s/<OTRS_TICKET_$_>/$Ticket{$_}/gi;
                $Body =~ s/<OTRS_TICKET_$_>/$Ticket{$_}/gi;
            }
        }
        # cleanup
        $Subject =~ s/<OTRS_TICKET_.+?>/-/gi;
        $Body =~ s/<OTRS_TICKET_.+?>/-/gi;
        # replace config options
        $Subject =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;
        $Body =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;
        # cleanup
        $Subject =~ s/<OTRS_CONFIG_.+?>/-/gi;
        $Body =~ s/<OTRS_CONFIG_.+?>/-/gi;
        # get customer data and replace it with <OTRS_CUSTOMER_DATA_...
        my %CustomerUser = ();
        if ($Ticket{CustomerUserID}) {
            %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $Ticket{CustomerUserID},
            );
            # replace customer stuff with tags
            foreach (keys %CustomerUser) {
                if ($CustomerUser{$_}) {
                    $Subject =~ s/<OTRS_CUSTOMER_DATA_$_>/$CustomerUser{$_}/gi;
                    $Body =~ s/<OTRS_CUSTOMER_DATA_$_>/$CustomerUser{$_}/gi;
                }
            }
        }
        # cleanup all not needed <OTRS_CUSTOMER_DATA_ tags
        $Subject =~ s/<OTRS_CUSTOMER_DATA_.+?>/-/gi;
        $Body =~ s/<OTRS_CUSTOMER_DATA_.+?>/-/gi;
        # replace key
        $Subject =~ s/<OTRS_PublicSurveyKey>/$PublicSurveyKey/gi;
        $Body =~ s/<OTRS_PublicSurveyKey>/$PublicSurveyKey/gi;
        my $To = $CustomerUser{UserEmail};
        if (!$To) {
            my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
                TicketID => $Param{TicketID},
            );
            $To = $Article{From};
        }
        if ($To) {
            # check if not survey should be send
            if ($Self->{ConfigObject}->Get('Survey::SendNoSurveyRegExp')) {
                if ($To =~ /$Self->{ConfigObject}->Get('Survey::SendNoSurveyRegExp')/i) {
                    return 1;
                }
            }
            # check if a survey is sent in the last time
            if ($Self->{ConfigObject}->Get('Survey::SendPeriod')) {
                my $LastSentTime = 0;
                # get send time
                $Self->{DBObject}->Prepare(
                    SQL => "SELECT send_time FROM " .
                        "survey_request WHERE send_to = '" . $Self->{DBObject}->Quote($To) . "'",
                    Limit => 1,
                );
                while (my @Row = $Self->{DBObject}->FetchrowArray()) {
                    $LastSentTime = $Row[0];
                }
                if ($LastSentTime) {
                    $LastSentTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                        String => $LastSentTime,
                    );
                    if (($LastSentTime+($Self->{ConfigObject}->Get('Survey::SendPeriod')*60*60*24)) >
                        $Self->{TimeObject}->SystemTime()) {
                        return 1;
                    }
                }
            }
            # create a survey_request entry
            my $CurrentTime = $Self->{TimeObject}->CurrentTimestamp();
            # insert request
            $Self->{DBObject}->Do(
                SQL => "INSERT INTO survey_request " .
                    " (ticket_id, survey_id, valid_id, public_survey_key, send_to, send_time) " .
                    " VALUES (" .
                    "$Param{TicketID}, " .
                    "$MasterID, " .
                    "1, " .
                    "'" . $Self->{DBObject}->Quote($PublicSurveyKey) . "', " .
                    "'" . $Self->{DBObject}->Quote($To) . "', " .
                    "'$CurrentTime')"
            );
            # log action on ticket
            $Self->{TicketObject}->HistoryAdd(
                TicketID => $Param{TicketID},
                CreateUserID => 1,
                HistoryType => 'Misc',
                Name => "Sent customer survey to $To.",
            );
            # send survey
            $Self->{SendmailObject}->Send(
                From => $Self->{ConfigObject}->Get('Survey::NotificationSender') || '',
                To => $To,
                Subject => $Subject,
                Type => 'text/plain',
                Charset => $Self->{ConfigObject}->Get('DefaultCharset'),
                Body => $Body,
            );
        }
    }
    return 1;
}

=item PublicSurveyGet()

to get all public attributes of a survey

    my %PublicSurvey = $SurveyObject->PublicSurveyGet(
        PublicSurveyKey => 'Aw5de3Xf5qA',
    );

=cut

sub PublicSurveyGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(PublicSurveyKey)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # get request
    $Self->{DBObject}->Prepare(
        SQL => "SELECT survey_id " .
            "FROM survey_request WHERE public_survey_key = '$Param{PublicSurveyKey}' AND valid_id = 1",
        Limit => 1,
    );
    my $SurveyID;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $SurveyID = $Row[0];
    }
    my %Data;
    if ($SurveyID) {
        # get survey
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id, surveynumber, title, introduction " .
                "FROM survey WHERE id = $SurveyID AND (status = 'Master' OR status = 'Valid')",
            Limit => 1,
        );
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Data{SurveyID} = $Row[0];
            $Data{SurveyNumber} = $Row[1];
            $Data{Title} = $Row[2];
            $Data{Introduction} = $Row[3];
        }
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(PublicSurveyKey QuestionID VoteValue)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(PublicSurveyKey VoteValue)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get request
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id " .
            " FROM survey_request WHERE public_survey_key = '$Param{PublicSurveyKey}' AND valid_id = 1",
        Limit => 1,
    );
    my $RequestID;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $RequestID = $Row[0];
    }
    if ($RequestID) {
        my $CurrentTime = $Self->{TimeObject}->CurrentTimestamp();
        # insert vote
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO survey_vote (request_id, question_id, vote_value, create_time) VALUES (" .
                "$RequestID, " .
                "$Param{QuestionID}, " .
                "'$Param{VoteValue}', " .
                "'$CurrentTime')"
        );
    }
    return 1;
}

=item PublicSurveyInvalidSet()

to set a request invalid

    $SurveyObject->PublicSurveyInvalidSet(
        PublicSurveyKey => 'aVkdE82Dw2qw6erCda',
    );

=cut

sub PublicSurveyInvalidSet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(PublicSurveyKey)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(PublicSurveyKey)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # get request
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id " .
            " FROM survey_request WHERE public_survey_key = '$Param{PublicSurveyKey}'",
        Limit => 1,
    );
    my $RequestID;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $RequestID = $Row[0];
    }
    if ($RequestID) {
        my $CurrentTime = $Self->{TimeObject}->CurrentTimestamp();
        # update request
        $Self->{DBObject}->Do(
            SQL => "UPDATE survey_request SET " .
                "valid_id = 0, " .
                "vote_time = '$CurrentTime' " .
                "WHERE id = $RequestID"
        );
    }
    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=head1 VERSION

$Revision: 1.34 $ $Date: 2007-08-20 09:39:46 $

=cut