# --
# Kernel/System/Survey.pm - manage all survey module events
# Copyright (C) 2003-2006 OTRS GmbH, http://www.otrs.com/
# --
# $Id: Survey.pm,v 1.12 2006-03-16 23:55:15 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Survey;

use strict;
use Digest::MD5;
use Kernel::System::Email;
use Kernel::System::Ticket;
use Kernel::System::CustomerUser;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.12 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Survey - survey lib

=head1 SYNOPSIS

All survey functions. E. g. to add survey or and functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject TimeObject UserObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{SendmailObject} = Kernel::System::Email->new(%Param);
    $Self->{TicketObject} = Kernel::System::Ticket->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    return $Self;
}

=item SurveyList()

to get a array list of all survey items

    my @List = $Self->{SurveyObject}->SurveyList();

=cut

sub SurveyList {
    my $Self = shift;
    my %Param = @_;
    my @List = ();
    # check needed stuff
    foreach (qw()) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # sql for event
    my $SQL = "SELECT id FROM survey ORDER BY create_time DESC";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push(@List, $Row[0]);
    }

    return @List;
}

=item SurveyGet()

to get all attributes of a survey

    my %Survey = $Self->{SurveyObject}->SurveyGet(SurveyID => 123);

=cut

sub SurveyGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    my $SQL = "SELECT id, number, title, introduction, description, status, create_time, create_by, change_time, change_by ".
        " FROM survey WHERE id = $Param{SurveyID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);

    my %Data = ();
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{SurveyID} = $Row[0];
        $Data{SurveyNumber} = $Row[1];
        $Data{SurveyTitle} = $Row[2];
        $Data{SurveyIntroduction} = $Row[3];
        $Data{SurveyDescription} = $Row[4];
        $Data{SurveyStatus} = $Row[5];
        $Data{SurveyCreateTime} = $Row[6];
        $Data{SurveyCreateBy} = $Row[7];
        $Data{SurveyChangeTime} = $Row[8];
        $Data{SurveyChangeBy} = $Row[9];
    }
    if (%Data) {
        my %CreateUserInfo = $Self->{UserObject}->GetUserData(
            UserID => $Data{SurveyCreateBy},
            Cached => 1
        );

        $Data{SurveyCreateUserLogin} = $CreateUserInfo{UserLogin};
        $Data{SurveyCreateUserFirstname} = $CreateUserInfo{UserFirstname};
        $Data{SurveyCreateUserLastname} = $CreateUserInfo{UserLastname};

        my %ChangeUserInfo = $Self->{UserObject}->GetUserData(
            UserID => $Data{SurveyChangeBy},
            Cached => 1
        );

        $Data{SurveyChangeUserLogin} = $ChangeUserInfo{UserLogin};
        $Data{SurveyChangeUserFirstname} = $ChangeUserInfo{UserFirstname};
        $Data{SurveyChangeUserLastname} = $ChangeUserInfo{UserLastname};
        return %Data;
    }
    else {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No such SurveyID $Param{SurveyID}!");
        return ();
    }
}

sub SurveyStatusSet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID NewStatus)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(NewStatus)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    my $SQL = "SELECT status ".
        " FROM survey WHERE id = $Param{SurveyID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);

    my $Status = '';

    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Status = $Row[0];
    }

    if ($Status eq 'New' || $Status eq 'Invalid') {
        my $SQL = "SELECT id FROM survey_question WHERE survey_id = $Param{SurveyID}";
        $Self->{DBObject}->Prepare(SQL => $SQL);

        my $Quest = '';

        while (my @Row2 = $Self->{DBObject}->FetchrowArray()) {
            $Quest = $Row2[0];
        }

        if ($Quest > '0') {
            my $SQL = "SELECT id FROM survey_question".
                " WHERE survey_id = $Param{SurveyID} AND (type = 2 OR type = 3)";
            $Self->{DBObject}->Prepare(SQL => $SQL);

            my $AllQuestionsAnsers = 'Yes';
            my @QuestionIDs = ();
            my $Counter1 = 0;

            while (my @Row3 = $Self->{DBObject}->FetchrowArray()) {
                $QuestionIDs[$Counter1] = $Row3[0];
                $Counter1++;
            }

            foreach my $OneID(@QuestionIDs) {
                $Self->{DBObject}->Prepare(SQL => "SELECT id FROM survey_answer WHERE question_id = $OneID");

                my $Counter2 = '0';

                while (my @Row = $Self->{DBObject}->FetchrowArray()) {
                    $Counter2++;
                }

                if ($Counter2 < 2) {
                    $AllQuestionsAnsers = 'no';
                }
            }

            if ($AllQuestionsAnsers eq 'Yes')
            {
                if ($Param{NewStatus} eq 'Valid') {
                    $Self->{DBObject}->Do(
                        SQL => "UPDATE survey SET status = 'Valid' WHERE id = $Param{SurveyID}",
                    );
                }
                elsif ($Param{NewStatus} eq 'Master') {
                    $Self->{DBObject}->Do(
                        SQL => "UPDATE survey SET status = 'Master' WHERE id = $Param{SurveyID}",
                    );
                }
            }
        }
    }
    elsif ($Status eq 'Valid') {
        if ($Param{NewStatus} eq 'Master') {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = 'Valid' WHERE status = 'Master'",
            );
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = 'Master' WHERE id = $Param{SurveyID}",
            );
        }
        elsif ($Param{NewStatus} eq 'Invalid') {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = 'Invalid' WHERE id = $Param{SurveyID}",
            );
        }
    }
    elsif ($Status eq 'Master') {
        if ($Param{NewStatus} eq 'Valid') {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = 'Valid' WHERE id = $Param{SurveyID}",
            );
        }
        elsif ($Param{NewStatus} eq 'Invalid') {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey SET status = 'Invalid' WHERE id = $Param{SurveyID}",
            );
        }
    }
}

sub SurveySave {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID SurveyID SurveyTitle SurveyIntroduction SurveyDescription)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(SurveyTitle SurveyIntroduction SurveyDescription)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(UserID SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    $Self->{DBObject}->Do(
        SQL => "UPDATE survey SET ".
                         "title = '$Param{SurveyTitle}', ".
                         "introduction = '$Param{SurveyIntroduction}', ".
                         "description = '$Param{SurveyDescription}', ".
                         "change_time = current_timestamp, ".
                         "change_by = $Param{UserID} ".
                         "WHERE id = $Param{SurveyID}",
        );
}

sub SurveyNew {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID SurveyTitle SurveyIntroduction SurveyDescription)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(SurveyTitle SurveyIntroduction SurveyDescription)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    $Self->{DBObject}->Do(
        SQL => "INSERT INTO survey (title, introduction, description, status, create_time, create_by, change_time, change_by) VALUES (".
                                                         "'$Param{SurveyTitle}', ".
                                                         "'$Param{SurveyIntroduction}', ".
                                                         "'$Param{SurveyDescription}', ".
                                                         "'New', ".
                                                         "current_timestamp, ".
                                                         "$Param{UserID}, ".
                                                         "current_timestamp, ".
                                                         "$Param{UserID})"
        );

    my $SQL = "SELECT id FROM survey WHERE ".
                  "title = '$Param{SurveyTitle}' AND ".
                  "introduction = '$Param{SurveyIntroduction}' AND ".
                  "description = '$Param{SurveyDescription}' ".
                  "ORDER BY create_time DESC";
    $Self->{DBObject}->Prepare(SQL => $SQL);

    my $SurveyID = '';

    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $SurveyID = $Row[0];
    }

    $Self->{DBObject}->Do(
        SQL => "UPDATE survey SET ".
                         "number = '" . ($SurveyID + 10000) . "' ".
                         "WHERE id = $SurveyID",
        );

    return $SurveyID;
}

sub QuestionList {
    my $Self = shift;
    my %Param = @_;
    my @List = ();
    # check needed stuff
    foreach (qw(SurveyID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    my $SQL = "SELECT id, survey_id, question, type ".
        " FROM survey_question WHERE survey_id = $Param{SurveyID} ORDER BY position";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %Data = ();

        $Data{QuestionID} = $Row[0];
        $Data{SurveyID} = $Row[1];
        $Data{Question} = $Row[2];
        $Data{QuestionType} = $Row[3];

        push(@List,\%Data);
    }

    return @List;
}

sub QuestionAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID SurveyID Question QuestionType)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Question)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(UserID SurveyID QuestionType)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    $Self->{DBObject}->Do(
        SQL => "INSERT INTO survey_question (survey_id, question, type, position, create_time, create_by, change_time, change_by) VALUES (".
                    "$Param{SurveyID}, ".
                    "'$Param{Question}', ".
                    "'$Param{QuestionType}', ".
                    "255, ".
                    "current_timestamp, ".
                    "$Param{UserID}, ".
                    "current_timestamp, ".
                    "$Param{UserID})"
        );
}

sub QuestionDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID QuestionID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(SurveyID QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM survey_answer WHERE ".
                    "question_id = $Param{QuestionID}"
        );
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM survey_question WHERE ".
                    "id = $Param{QuestionID} AND ".
                    "survey_id = $Param{SurveyID}"
        );
}

sub QuestionSort {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    my $SQL = "SELECT id FROM survey_question".
        " WHERE survey_id = $Param{SurveyID} ORDER BY position";
    $Self->{DBObject}->Prepare(SQL => $SQL);

    my $Counter = 1;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Self->{DBObject}->Do(
            SQL => "UPDATE survey_question SET position = $Counter WHERE id = $Row[0]",
        );
        $Counter++;
    }
}

sub QuestionUp {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID QuestionID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(SurveyID QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    $Self->{DBObject}->Prepare(SQL => "SELECT position FROM survey_question".
        " WHERE id = $Param{QuestionID} AND survey_id = $Param{SurveyID}"
        );

    my $Position = '';

    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Position = $Row[0];
    }

    if ($Position > '1')
    {
        my $PositionUp = $Position - 1;

        $Self->{DBObject}->Prepare(SQL => "SELECT id FROM survey_question".
            " WHERE survey_id = $Param{SurveyID} AND position = $PositionUp"
            );

        my $QuestionIDDown = '';

        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $QuestionIDDown = $Row[0];
        }

        if ($QuestionIDDown ne '')
        {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_question SET ".
                            "position = $Position ".
                            "WHERE id = $QuestionIDDown"
                );
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_question SET ".
                            "position = $PositionUp ".
                            "WHERE id = $Param{QuestionID}"
                );
        }
    }
}

sub QuestionDown {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID QuestionID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(SurveyID QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    $Self->{DBObject}->Prepare(SQL => "SELECT position FROM survey_question".
        " WHERE id = $Param{QuestionID} AND survey_id = $Param{SurveyID}"
        );

    my $Position = '';

    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Position = $Row[0];
    }

    if ($Position > '0')
    {
        my $PositionDown = $Position + 1;

        $Self->{DBObject}->Prepare(SQL => "SELECT id FROM survey_question".
            " WHERE survey_id = $Param{SurveyID} AND position = $PositionDown"
            );

        my $QuestionIDUp = '';

        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $QuestionIDUp = $Row[0];
        }

        if ($QuestionIDUp ne '')
        {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_question SET ".
                            "position = $Position ".
                            "WHERE id = $QuestionIDUp"
                );
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_question SET ".
                            "position = $PositionDown ".
                            "WHERE id = $Param{QuestionID}"
                );
        }
    }
}

sub QuestionGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(QuestionID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    my $SQL = "SELECT id, survey_id, question, type, position, create_time, create_by, change_time, change_by ".
        " FROM survey_question WHERE id = $Param{QuestionID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);

    my %Data = ();
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{QuestionID} = $Row[0];
        $Data{SurveyID} = $Row[1];
        $Data{Question} = $Row[2];
        $Data{QuestionType} = $Row[3];
        $Data{QuestionPosition} = $Row[4];
        $Data{QuestionCreateTime} = $Row[5];
        $Data{QuestionCreateBy} = $Row[6];
        $Data{QuestionChangeTime} = $Row[7];
        $Data{QuestionChangeBy} = $Row[8];
    }

    return %Data;
}

sub QuestionSave {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID QuestionID SurveyID Question)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Question)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(UserID QuestionID SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    $Self->{DBObject}->Do(
        SQL => "UPDATE survey_question SET ".
                         "question = '$Param{Question}', ".
                         "change_time = current_timestamp, ".
                         "change_by = $Param{UserID} ".
                         "WHERE id = $Param{QuestionID} ",
                         "AND survey_id = $Param{SurveyID}",
        );
}

sub QuestionCount {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    my $SQL = "SELECT COUNT(id) FROM survey_question WHERE survey_id = $Param{SurveyID}";

    $Self->{DBObject}->Prepare(SQL => $SQL);

    my $CountQuestion = '';

    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $CountQuestion = $Row[0];
    }

    return $CountQuestion;
}

sub AnswerList {
    my $Self = shift;
    my %Param = @_;
    my @List = ();
    # check needed stuff
    foreach (qw(QuestionID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    my $SQL = "SELECT id, question_id, answer ".
        " FROM survey_answer WHERE question_id = $Param{QuestionID} ORDER BY position";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %Data = ();

        $Data{AnswerID} = $Row[0];
        $Data{QuestionID} = $Row[1];
        $Data{Answer} = $Row[2];

        push(@List,\%Data);
    }

    return @List;
}

sub AnswerAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID QuestionID Answer)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Answer)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(UserID QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    $Self->{DBObject}->Do(
        SQL => "INSERT INTO survey_answer (question_id, answer, position, create_time, create_by, change_time, change_by) VALUES (".
                    "$Param{QuestionID}, ".
                    "'$Param{Answer}', ".
                    "255, ".
                    "current_timestamp, ".
                    "$Param{UserID}, ".
                    "current_timestamp, ".
                    "$Param{UserID})"
        );
}

sub AnswerDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(QuestionID AnswerID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(QuestionID AnswerID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM survey_answer WHERE ".
                    "id = $Param{AnswerID} AND ".
                    "question_id = $Param{QuestionID}"
        );
}

sub AnswerSort {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(QuestionID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    my $SQL = "SELECT id FROM survey_answer".
        " WHERE question_id = $Param{QuestionID} ORDER BY position";
    $Self->{DBObject}->Prepare(SQL => $SQL);

    my $counter = 1;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Self->{DBObject}->Do(
            SQL => "UPDATE survey_answer SET position = $counter WHERE id = $Row[0]",
        );

        $counter++;
    }
}

sub AnswerUp {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(QuestionID AnswerID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(QuestionID AnswerID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    $Self->{DBObject}->Prepare(SQL => "SELECT position FROM survey_answer".
        " WHERE id = $Param{AnswerID} AND question_id = $Param{QuestionID}"
        );

    my $Position = '';

    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Position = $Row[0];
    }

    if ($Position > '1')
    {
        my $PositionUp = $Position - 1;

        $Self->{DBObject}->Prepare(SQL => "SELECT id FROM survey_answer".
            " WHERE question_id = $Param{QuestionID} AND position = $PositionUp"
            );

        my $AnswerIDDown = '';

        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $AnswerIDDown = $Row[0];
        }

        if ($AnswerIDDown ne '')
        {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_answer SET ".
                            "position = $Position ".
                            "WHERE id = $AnswerIDDown"
                );
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_answer SET ".
                            "position = $PositionUp ".
                            "WHERE id = $Param{AnswerID}"
                );
        }
    }
}

sub AnswerDown {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(QuestionID AnswerID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(QuestionID AnswerID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    $Self->{DBObject}->Prepare(SQL => "SELECT position FROM survey_answer".
        " WHERE id = $Param{AnswerID} AND question_id = $Param{QuestionID}"
        );

    my $Position = '';

    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Position = $Row[0];
    }

    if ($Position > '0')
    {
        my $PositionDown = $Position + 1;

        $Self->{DBObject}->Prepare(SQL => "SELECT id FROM survey_answer".
            " WHERE question_id = $Param{QuestionID} AND position = $PositionDown"
            );

        my $AnswerIDUp = '';

        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $AnswerIDUp = $Row[0];
        }

        if ($AnswerIDUp ne '')
        {
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_answer SET ".
                            "position = $Position ".
                            "WHERE id = $AnswerIDUp"
                );
            $Self->{DBObject}->Do(
                SQL => "UPDATE survey_answer SET ".
                            "position = $PositionDown ".
                            "WHERE id = $Param{AnswerID}"
                );
        }
    }
}

sub AnswerGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(AnswerID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(AnswerID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    my $SQL = "SELECT id, question_id, answer, position, create_time, create_by, change_time, change_by ".
        " FROM survey_answer WHERE id = $Param{AnswerID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);

    my %Data = ();
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{AnswerID} = $Row[0];
        $Data{QuestionID} = $Row[1];
        $Data{Answer} = $Row[2];
        $Data{AnswerPosition} = $Row[3];
        $Data{AnswerCreateTime} = $Row[4];
        $Data{AnswerCreateBy} = $Row[5];
        $Data{AnswerChangeTime} = $Row[6];
        $Data{AnswerChangeBy} = $Row[7];
    }

    return %Data;
}

sub AnswerSave {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID AnswerID QuestionID Answer)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Answer)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(UserID AnswerID QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    $Self->{DBObject}->Do(
        SQL => "UPDATE survey_answer SET ".
                         "answer = '$Param{Answer}', ".
                         "change_time = current_timestamp, ".
                         "change_by = $Param{UserID} ".
                         "WHERE id = $Param{AnswerID} ",
                         "AND question_id = $Param{QuestionID}",
        );
}

sub VoteList {
    my $Self = shift;
    my %Param = @_;
    my @List = ();
    # check needed stuff
    foreach (qw(SurveyID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    my $SQL = "SELECT id, ticket_id, send_time, vote_time ".
        " FROM survey_request WHERE survey_id = $Param{SurveyID} AND valid_id = 0 ORDER BY vote_time DESC";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %Data = ();

        $Data{RequestID} = $Row[0];
        $Data{TicketID} = $Row[1];
        $Data{SendTime} = $Row[2];
        $Data{VoteTime} = $Row[3];

        push(@List,\%Data);
    }

    return @List;
}

sub VoteGet {
    my $Self = shift;
    my %Param = @_;
    my @List = ();
    # check needed stuff
    foreach (qw(RequestID QuestionID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(RequestID QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    my $SQL = "SELECT id, vote_value FROM survey_vote".
        " WHERE request_id = $Param{RequestID} AND question_id = $Param{QuestionID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);

    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %Data = ();
        $Data{RequestID} = $Row[0];
        $Data{VoteValue} = $Row[1] || '-';
        push(@List, \%Data);
    }

    return @List;
}

sub CountVote {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(QuestionID VoteValue)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(VoteValue)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    my $SQL = "SELECT COUNT(vote_value) FROM survey_vote WHERE question_id = $Param{QuestionID} AND vote_value = '$Param{VoteValue}'";

    $Self->{DBObject}->Prepare(SQL => $SQL);

    my %Data = ();
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{CountVote} = $Row[0];
    }

    return $Data{CountVote};
}

sub CountRequestComplete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SurveyID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(SurveyID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    my $SQL = "SELECT COUNT(id) FROM survey_request WHERE survey_id = $Param{SurveyID} AND valid_id = 0";

    $Self->{DBObject}->Prepare(SQL => $SQL);

    my %Data = ();
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{CountRequestComplete} = $Row[0];
    }

    return $Data{CountRequestComplete};
}

sub RequestSend {
    my $Self = shift;
    my %Param = @_;
    my $MasterID = '';
    # check needed stuff
    foreach (qw(TicketID)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # create PublicSurveyKey
    my $md5 = Digest::MD5->new();
    $md5->add($Self->{TimeObject}->SystemTime() . int(rand(999999999)));
    my $PublicSurveyKey = $md5->hexdigest;

    # find master survey
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM survey WHERE status = 'Master'"
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $MasterID = $Row[0];
    }
    # if master survey exists
    if ($MasterID > 0) {
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
                $Self->{DBObject}->Prepare(
                    SQL => "SELECT send_time FROM ".
                        "survey_request WHERE send_to = '".$Self->{DBObject}->Quote($To)."'"
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
            $Self->{DBObject}->Do(
                SQL => "INSERT INTO survey_request ".
                    " (ticket_id, survey_id, valid_id, public_survey_key, send_to, send_time) ".
                    " VALUES (".
                    "$Param{TicketID}, ".
                    "$MasterID, ".
                    "1, ".
                    "'".$Self->{DBObject}->Quote($PublicSurveyKey)."', ".
                    "'".$Self->{DBObject}->Quote($To)."', ".
                    "current_timestamp)"
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
                Body => $Body
            );
        }
    }
    return 1;
}

sub PublicSurveyGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(PublicSurveyKey)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # sql for event
    $Self->{DBObject}->Prepare(SQL => "SELECT survey_id ".
        " FROM survey_request WHERE public_survey_key = '$Param{PublicSurveyKey}' AND valid_id = 1"
        );

    my $SurveyID = ();
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $SurveyID = $Row[0];
    }

    if ($SurveyID > '0')
    {
        my $SQL = "SELECT id, number, title, introduction ".
            " FROM survey WHERE id = $SurveyID AND (status = 'Master' OR status = 'Valid')";
        $Self->{DBObject}->Prepare(SQL => $SQL);

        my @Survey = $Self->{DBObject}->FetchrowArray();

        my %Data = ();
        if ($Survey[0] > '0') {
            $Data{SurveyID} = $Survey[0];
            $Data{SurveyNumber} = $Survey[1];
            $Data{SurveyTitle} = $Survey[2];
            $Data{SurveyIntroduction} = $Survey[3];

            return %Data;
        }
    }
}

sub PublicAnswerSave{
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(PublicSurveyKey QuestionID VoteValue)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(PublicSurveyKey VoteValue)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(QuestionID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql for event
    $Self->{DBObject}->Prepare(SQL => "SELECT id ".
        " FROM survey_request WHERE public_survey_key = '$Param{PublicSurveyKey}' AND valid_id = 1"
        );

    my $RequestID = ();
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $RequestID = $Row[0];
    }

    if ($RequestID > '0') {
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO survey_vote (request_id, question_id, vote_value, create_time) VALUES (".
                        "$RequestID, ".
                        "$Param{QuestionID}, ".
                        "'$Param{VoteValue}', ".
                        "current_timestamp)"
        );
    }
}

sub PublicSurveyInvalidSet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(PublicSurveyKey)) {
      if (!defined ($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(PublicSurveyKey)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # sql for event
    $Self->{DBObject}->Prepare(SQL => "SELECT id ".
        " FROM survey_request WHERE public_survey_key = '$Param{PublicSurveyKey}'"
        );

    my $RequestID = ();
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $RequestID = $Row[0];
    }

    if ($RequestID > '0') {
        $Self->{DBObject}->Do(
            SQL => "UPDATE survey_request SET ".
                         "valid_id = 0, ".
                         "vote_time = current_timestamp ".
                         "WHERE id = $RequestID"
            );
    }
}

1;
