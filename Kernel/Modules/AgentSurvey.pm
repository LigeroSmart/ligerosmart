# --
# Kernel/Modules/AgentSurvey.pm - a survey module
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentSurvey.pm,v 1.31 2007-10-15 11:23:26 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentSurvey;

use strict;
use warnings;

use Kernel::System::Survey;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.31 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common objects
    %{$Self} = %Param;

    # check needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }
    $Self->{SurveyObject} = Kernel::System::Survey->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # ------------------------------------------------------------ #
    # survey
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Survey' ) {

        # get params
        my $SurveyID = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $Message  = $Self->{ParamObject}->GetParam( Param => "Message" );

        # check if survey exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }

        # output header
        $Output = $Self->{LayoutObject}->Header( Title => 'Survey' );
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # output mesages if status was changed
        if ( defined($Message) && $Message eq 'NoQuestion' ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Info     => 'Can\'t set new Status! No Question definied.',
            );
        }
        elsif ( defined($Message) && $Message eq 'IncompleteQuestion' ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Info     => 'Can\'t set new Status! Question(s) incomplete.',
            );
        }
        elsif ( defined($Message) && $Message eq 'StatusSet' ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Notice',
                Info     => 'New Status aktiv!',
            );
        }

        # get all attributes of the survey
        my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $SurveyID );

        # konvert the textareas in html (\n --><br>)
        $Survey{Introduction} = $Self->{LayoutObject}->Ascii2Html(
            Text           => $Survey{Introduction},
            HTMLResultMode => 1,
        );
        $Survey{Description} = $Self->{LayoutObject}->Ascii2Html(
            Text           => $Survey{Description},
            HTMLResultMode => 1,
        );

        # get numbers of requests and votes
        my $SendRequest = $Self->{SurveyObject}->CountRequest(
            SurveyID => $SurveyID,
            ValidID  => 'all',
        );
        my $RequestComplete = $Self->{SurveyObject}->CountRequest(
            SurveyID => $SurveyID,
            ValidID  => 0,
        );
        $Survey{SendRequest}     = $SendRequest;
        $Survey{RequestComplete} = $RequestComplete;

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'Survey',
            Data => {%Survey},
        );

        # display stats if status Master, Valid or Invalid
        if (   $Survey{Status} eq 'Master'
            || $Survey{Status} eq 'Valid'
            || $Survey{Status} eq 'Invalid' )
        {
            $Self->{LayoutObject}->Block(
                Name => 'SurveyEditStats',
                Data => { SurveyID => $SurveyID },
            );

            # get all questions of the survey
            my @QuestionList = $Self->{SurveyObject}->QuestionList( SurveyID => $SurveyID );
            for my $Question (@QuestionList) {
                $Self->{LayoutObject}->Block(
                    Name => 'SurveyEditStatsQuestion',
                    Data => $Question,
                );
                my @Answers;

                # generate the answers of the question
                if (   $Question->{Type} eq 'YesNo'
                    || $Question->{Type} eq 'Radio'
                    || $Question->{Type} eq 'Checkbox' )
                {
                    my @AnswerList;

                    # set answers to Yes and No if type was YesNo
                    if ( $Question->{Type} eq 'YesNo' ) {
                        my %Data;
                        $Data{Answer}   = "Yes";
                        $Data{AnswerID} = "Yes";
                        push( @AnswerList, \%Data );
                        my %Data2;
                        $Data2{Answer}   = "No";
                        $Data2{AnswerID} = "No";
                        push( @AnswerList, \%Data2 );
                    }
                    else {

                        # get all answers of a question
                        @AnswerList = $Self->{SurveyObject}
                            ->AnswerList( QuestionID => $Question->{QuestionID} );
                    }
                    for my $Row (@AnswerList) {
                        my $CountVote = $Self->{SurveyObject}->CountVote(
                            QuestionID => $Question->{QuestionID},
                            VoteValue  => $Row->{AnswerID},
                        );
                        my $Percent = 0;

                        # calculate the percents
                        if ($RequestComplete) {
                            $Percent = 100 / $RequestComplete * $CountVote;
                            $Percent = sprintf( "%.0f", $Percent );
                        }
                        my %Data;
                        $Data{Answer}        = $Row->{Answer};
                        $Data{AnswerPercent} = $Percent;
                        push( @Answers, \%Data );
                    }
                }
                elsif ( $Question->{Type} eq 'Textarea' ) {
                    my $AnswerNo = $Self->{SurveyObject}->CountVote(
                        QuestionID => $Question->{QuestionID},
                        VoteValue  => '',
                    );
                    my $Percent = 0;

                    # calculate the percents
                    if ($RequestComplete) {
                        $Percent = 100 / $RequestComplete * $AnswerNo;
                        $Percent = sprintf( "%.0f", $Percent );
                    }
                    my %Data;
                    $Data{Answer} = "answered";
                    if ( !$RequestComplete ) {
                        $Data{AnswerPercent} = 0;
                    }
                    else {
                        $Data{AnswerPercent} = 100 - $Percent;
                    }
                    push( @Answers, \%Data );
                    my %Data2;
                    $Data2{Answer}        = "not answered";
                    $Data2{AnswerPercent} = $Percent;
                    push( @Answers, \%Data2 );
                }

                # output all answers of the survey
                for my $Row (@Answers) {
                    $Row->{AnswerPercentTable} = $Row->{AnswerPercent};
                    if ( !$Row->{AnswerPercent} ) {
                        $Row->{AnswerPercentTable} = 1;
                    }
                    $Self->{LayoutObject}->Block(
                        Name => 'SurveyEditStatsAnswer',
                        Data => $Row,
                    );
                }
            }
            if ($RequestComplete) {
                $Self->{LayoutObject}->Block(
                    Name => 'SurveyEditStatsDetails',
                    Data => { SurveyID => $SurveyID },
                );
            }
        }

        # output the possible status
        my %NewStatus;
        if ( $Survey{Status} eq 'New' || $Survey{Status} eq 'Invalid' ) {
            $NewStatus{Master} = 'Master';
            $NewStatus{Valid}  = 'Valid';
        }
        elsif ( $Survey{Status} eq 'Valid' ) {
            $NewStatus{Master}  = 'Master';
            $NewStatus{Invalid} = 'Invalid';
        }
        elsif ( $Survey{Status} eq 'Master' ) {
            $NewStatus{Valid}   = 'Valid';
            $NewStatus{Invalid} = 'Invalid';
        }
        my $NewStatusStr = $Self->{LayoutObject}->OptionStrgHashRef(
            Name => 'NewStatus',
            Data => \%NewStatus,
        );
        $Self->{LayoutObject}->Block(
            Name => 'SurveyStatus',
            Data => { NewStatusStr => $NewStatusStr },
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurvey',
            Data         => {%Param},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # survey status
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SurveyStatus' ) {
        my $SurveyID  = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $NewStatus = $Self->{ParamObject}->GetParam( Param => "NewStatus" );

        # check if survey exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }

        # set a new status
        my $StatusSet = $Self->{SurveyObject}->SurveyStatusSet(
            SurveyID  => $SurveyID,
            NewStatus => $NewStatus,
        );
        my $Message = '';
        if ( defined($StatusSet) && $StatusSet eq 'NoQuestion' ) {
            $Message = '&Message=NoQuestion';
        }
        elsif ( defined($StatusSet) && $StatusSet eq 'IncompleteQuestion' ) {
            $Message = '&Message=IncompleteQuestion';
        }
        elsif ( defined($StatusSet) && $StatusSet eq 'StatusSet' ) {
            $Message = '&Message=StatusSet';
        }
        return $Self->{LayoutObject}
            ->Redirect( OP => "Action=$Self->{Action}&Subaction=Survey&SurveyID=$SurveyID$Message",
            );
    }

    # ------------------------------------------------------------ #
    # survey edit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SurveyEdit' ) {
        my $SurveyID = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

        # check if survey exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }

        # output header
        $Output = $Self->{LayoutObject}->Header( Title => 'Survey' );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $SurveyID );

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'SurveyEdit',
            Data => {%Survey},
        );
        my @List = $Self->{SurveyObject}->QuestionList( SurveyID => $SurveyID );
        if ( $Survey{Status} eq 'New' ) {
            for my $Question (@List) {
                $Self->{LayoutObject}->Block(
                    Name => 'SurveyEditQuestions',
                    Data => $Question,
                );
                my $AnswerCount
                    = $Self->{SurveyObject}->AnswerCount( QuestionID => $Question->{QuestionID} );
                if ( $Question->{Type} eq 'Radio' || $Question->{Type} eq 'Checkbox' ) {
                    if ( $AnswerCount < 2 ) {
                        $Self->{LayoutObject}->Block(
                            Name => 'SurveyEditQuestionsIncomplete',
                            Data => $Question,
                        );
                    }
                    else {
                        $Self->{LayoutObject}->Block(
                            Name => 'SurveyEditQuestionsComplete',
                            Data => $Question,
                        );
                    }
                }
                else {
                    $Self->{LayoutObject}->Block(
                        Name => 'SurveyEditQuestionsComplete',
                        Data => $Question,
                    );
                }
            }
            $Self->{LayoutObject}->Block(
                Name => 'SurveyEditNewQuestion',
                Data => { SurveyID => $SurveyID },
            );
        }
        else {
            for my $Question (@List) {
                $Self->{LayoutObject}->Block(
                    Name => 'SurveyEditQuestionsValidOnce',
                    Data => $Question,
                );
            }
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurvey',
            Data         => {%Param},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # survey save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SurveySave' ) {
        my $SurveyID     = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $Title        = $Self->{ParamObject}->GetParam( Param => "Title" );
        my $Introduction = $Self->{ParamObject}->GetParam( Param => "Introduction" );
        my $Description  = $Self->{ParamObject}->GetParam( Param => "Description" );

        # check if survey exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        if ( $Title && $Introduction && $Description ) {
            $Self->{SurveyObject}->SurveySave(
                SurveyID     => $SurveyID,
                Title        => $Title,
                Introduction => $Introduction,
                Description  => $Description,
                UserID       => $Self->{UserID},
            );
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=$Self->{Action}&Subaction=Survey&SurveyID=$SurveyID#Question" );
        }
        else {
            return $Self->{LayoutObject}
                ->Redirect( OP => "Action=$Self->{Action}&Subaction=SurveyEdit&SurveyID=$SurveyID",
                );
        }
    }

    # ------------------------------------------------------------ #
    # survey add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SurveyAdd' ) {
        $Output = $Self->{LayoutObject}->Header( Title => 'Survey Add' );
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # print the main table.
        $Self->{LayoutObject}->Block( Name => 'SurveyAdd' );
        $Output .= $Self->{LayoutObject}->Output( TemplateFile => 'AgentSurvey' );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # survey new
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SurveyNew' ) {
        my $Title        = $Self->{ParamObject}->GetParam( Param => "Title" );
        my $Introduction = $Self->{ParamObject}->GetParam( Param => "Introduction" );
        my $Description  = $Self->{ParamObject}->GetParam( Param => "Description" );

        if ( $Title && $Introduction && $Description ) {
            my $SurveyID = $Self->{SurveyObject}->SurveyNew(
                Title        => $Title,
                Introduction => $Introduction,
                Description  => $Description,
                UserID       => $Self->{UserID},
            );
            return $Self->{LayoutObject}
                ->Redirect( OP => "Action=$Self->{Action}&Subaction=Survey&SurveyID=$SurveyID" );
        }
        else {
            return $Self->{LayoutObject}
                ->Redirect( OP => "Action=$Self->{Action}&Subaction=SurveyAdd" );
        }
    }

    # ------------------------------------------------------------ #
    # question add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionAdd' ) {
        my $SurveyID = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $Question = $Self->{ParamObject}->GetParam( Param => "Question" );
        my $Type     = $Self->{ParamObject}->GetParam( Param => "Type" );

        # check if survey exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        if ($Question) {
            $Self->{SurveyObject}->QuestionAdd(
                SurveyID => $SurveyID,
                Question => $Question,
                Type     => $Type,
                UserID   => $Self->{UserID},
            );
            $Self->{SurveyObject}->QuestionSort( SurveyID => $SurveyID );
        }
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action}&Subaction=SurveyEdit&SurveyID=$SurveyID#NewQuestion" );
    }

    # ------------------------------------------------------------ #
    # question delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionDelete' ) {
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => "QuestionID" );
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

        # check if survey and question exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}
            ->ElementExists( ElementID => $QuestionID, Element => 'Question' ) ne 'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Self->{SurveyObject}->QuestionDelete(
            SurveyID   => $SurveyID,
            QuestionID => $QuestionID,
        );
        $Self->{SurveyObject}->QuestionSort( SurveyID => $SurveyID );
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action}&Subaction=SurveyEdit&SurveyID=$SurveyID#Question" );
    }

    # ------------------------------------------------------------ #
    # question up
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionUp' ) {
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => "QuestionID" );
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

        # check if survey and question exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}
            ->ElementExists( ElementID => $QuestionID, Element => 'Question' ) ne 'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Self->{SurveyObject}->QuestionSort( SurveyID => $SurveyID );
        $Self->{SurveyObject}->QuestionUp(
            SurveyID   => $SurveyID,
            QuestionID => $QuestionID,
        );
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action}&Subaction=SurveyEdit&SurveyID=$SurveyID#Question" );
    }

    # ------------------------------------------------------------ #
    # question down
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionDown' ) {
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => "QuestionID" );
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

        # check if survey and question exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}
            ->ElementExists( ElementID => $QuestionID, Element => 'Question' ) ne 'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Self->{SurveyObject}->QuestionSort( SurveyID => $SurveyID );
        $Self->{SurveyObject}->QuestionDown(
            SurveyID   => $SurveyID,
            QuestionID => $QuestionID,
        );
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action}&Subaction=SurveyEdit&SurveyID=$SurveyID#Question" );
    }

    # ------------------------------------------------------------ #
    # question edit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionEdit' ) {
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => "QuestionID" );

        # check if survey and question exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}
            ->ElementExists( ElementID => $QuestionID, Element => 'Question' ) ne 'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }

        # output header
        $Output = $Self->{LayoutObject}->Header( Title => 'Question Edit' );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        my %Survey   = $Self->{SurveyObject}->SurveyGet( SurveyID     => $SurveyID );
        my %Question = $Self->{SurveyObject}->QuestionGet( QuestionID => $QuestionID );

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'QuestionEdit',
            Data => {%Question},
        );
        if ( $Question{Type} eq 'YesNo' ) {
            $Self->{LayoutObject}->Block( Name => 'QuestionEdit1' );
        }
        elsif ( $Question{Type} eq 'Radio' ) {
            my @List = $Self->{SurveyObject}->AnswerList( QuestionID => $QuestionID );
            if ( $Survey{Status} eq 'New' ) {
                for my $Answer2 (@List) {
                    $Answer2->{SurveyID} = $SurveyID;
                    $Self->{LayoutObject}->Block(
                        Name => 'QuestionEdit2',
                        Data => $Answer2,
                    );
                }
                $Self->{LayoutObject}->Block(
                    Name => 'QuestionEdit2b',
                    Data => {%Question},
                );
            }
            else {
                for my $Answer2 (@List) {
                    $Answer2->{SurveyID} = $SurveyID;
                    $Self->{LayoutObject}->Block(
                        Name => 'QuestionEdit2ValidOnce',
                        Data => $Answer2,
                    );
                }
            }
        }
        elsif ( $Question{Type} eq 'Checkbox' ) {
            my @List = $Self->{SurveyObject}->AnswerList( QuestionID => $QuestionID );
            if ( $Survey{Status} eq 'New' ) {
                for my $Answer3 (@List) {
                    $Answer3->{SurveyID} = $SurveyID;
                    $Self->{LayoutObject}->Block(
                        Name => 'QuestionEdit3',
                        Data => $Answer3,
                    );
                }
                $Self->{LayoutObject}->Block(
                    Name => 'QuestionEdit3b',
                    Data => {%Question},
                );
            }
            else {
                for my $Answer3 (@List) {
                    $Answer3->{SurveyID} = $SurveyID;
                    $Self->{LayoutObject}->Block(
                        Name => 'QuestionEdit3ValidOnce',
                        Data => $Answer3,
                    );
                }
            }
        }
        elsif ( $Question{Type} eq 'Textarea' ) {
            $Self->{LayoutObject}->Block( Name => 'QuestionEdit4' );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurvey',
            Data         => {%Param},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # question save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionSave' ) {
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => "QuestionID" );
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $Question   = $Self->{ParamObject}->GetParam( Param => "Question" );

        # check if survey and question exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}
            ->ElementExists( ElementID => $QuestionID, Element => 'Question' ) ne 'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        if ($Question) {
            $Self->{SurveyObject}->QuestionSave(
                QuestionID => $QuestionID,
                SurveyID   => $SurveyID,
                Question   => $Question,
                UserID     => $Self->{UserID},
            );
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=$Self->{Action}&Subaction=SurveyEdit&SurveyID=$SurveyID#Question" );
        }
        else {
            return $Self->{LayoutObject}->Redirect( OP =>
                    "Action=$Self->{Action}&Subaction=QuestionEdit&SurveyID=$SurveyID&QuestionID=$QuestionID",
            );
        }
    }

    # ------------------------------------------------------------ #
    # answer add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AnswerAdd' ) {
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => "QuestionID" );
        my $Answer     = $Self->{ParamObject}->GetParam( Param => "Answer" );

        # check if survey and question exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}
            ->ElementExists( ElementID => $QuestionID, Element => 'Question' ) ne 'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        if ($Answer) {
            $Self->{SurveyObject}->AnswerAdd(
                SurveyID   => $SurveyID,
                QuestionID => $QuestionID,
                Answer     => $Answer,
                UserID     => $Self->{UserID},
            );
            $Self->{SurveyObject}->AnswerSort( QuestionID => $QuestionID );
        }
        return $Self->{LayoutObject}->Redirect( OP =>
                "Action=$Self->{Action}&Subaction=QuestionEdit&SurveyID=$SurveyID&QuestionID=$QuestionID#NewAnswer",
        );
    }

    # ------------------------------------------------------------ #
    # answer delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AnswerDelete' ) {
        my $AnswerID   = $Self->{ParamObject}->GetParam( Param => "AnswerID" );
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => "QuestionID" );
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

        # check if survey, question and answer exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}
            ->ElementExists( ElementID => $QuestionID, Element => 'Question' ) ne 'Yes'
            || $Self->{SurveyObject}->ElementExists( ElementID => $AnswerID, Element => 'Answer' )
            ne 'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Self->{SurveyObject}->AnswerDelete(
            QuestionID => $QuestionID,
            AnswerID   => $AnswerID,
        );
        $Self->{SurveyObject}->AnswerSort( QuestionID => $QuestionID );
        return $Self->{LayoutObject}->Redirect( OP =>
                "Action=$Self->{Action}&Subaction=QuestionEdit&SurveyID=$SurveyID&QuestionID=$QuestionID#Answer",
        );
    }

    # ------------------------------------------------------------ #
    # answer up
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AnswerUp' ) {
        my $AnswerID   = $Self->{ParamObject}->GetParam( Param => "AnswerID" );
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => "QuestionID" );
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

        # check if survey, question and answer exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}
            ->ElementExists( ElementID => $QuestionID, Element => 'Question' ) ne 'Yes'
            || $Self->{SurveyObject}->ElementExists( ElementID => $AnswerID, Element => 'Answer' )
            ne 'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Self->{SurveyObject}->AnswerSort( QuestionID => $QuestionID );
        $Self->{SurveyObject}->AnswerUp(
            QuestionID => $QuestionID,
            AnswerID   => $AnswerID,
        );
        return $Self->{LayoutObject}->Redirect( OP =>
                "Action=$Self->{Action}&Subaction=QuestionEdit&SurveyID=$SurveyID&QuestionID=$QuestionID#Answer",
        );
    }

    # ------------------------------------------------------------ #
    # answer down
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AnswerDown' ) {
        my $AnswerID   = $Self->{ParamObject}->GetParam( Param => "AnswerID" );
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => "QuestionID" );
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

        # check if survey, question and answer exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}
            ->ElementExists( ElementID => $QuestionID, Element => 'Question' ) ne 'Yes'
            || $Self->{SurveyObject}->ElementExists( ElementID => $AnswerID, Element => 'Answer' )
            ne 'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Self->{SurveyObject}->AnswerSort( QuestionID => $QuestionID );
        $Self->{SurveyObject}->AnswerDown(
            QuestionID => $QuestionID,
            AnswerID   => $AnswerID,
        );
        return $Self->{LayoutObject}->Redirect( OP =>
                "Action=$Self->{Action}&Subaction=QuestionEdit&SurveyID=$SurveyID&QuestionID=$QuestionID#Answer",
        );
    }

    # ------------------------------------------------------------ #
    # answer edit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AnswerEdit' ) {
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => "QuestionID" );
        my $AnswerID   = $Self->{ParamObject}->GetParam( Param => "AnswerID" );

        # check if survey, question and answer exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}
            ->ElementExists( ElementID => $QuestionID, Element => 'Question' ) ne 'Yes'
            || $Self->{SurveyObject}->ElementExists( ElementID => $AnswerID, Element => 'Answer' )
            ne 'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Output = $Self->{LayoutObject}->Header( Title => 'Answer Edit' );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        my %Answer = $Self->{SurveyObject}->AnswerGet( AnswerID => $AnswerID );
        $Answer{SurveyID} = $SurveyID;

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'AnswerEdit',
            Data => {%Answer},
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurvey',
            Data         => {%Param},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # answer save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AnswerSave' ) {
        my $AnswerID   = $Self->{ParamObject}->GetParam( Param => "AnswerID" );
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => "QuestionID" );
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $Answer     = $Self->{ParamObject}->GetParam( Param => "Answer" );

        # check if survey, question and answer exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}
            ->ElementExists( ElementID => $QuestionID, Element => 'Question' ) ne 'Yes'
            || $Self->{SurveyObject}->ElementExists( ElementID => $AnswerID, Element => 'Answer' )
            ne 'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        if ($Answer) {
            $Self->{SurveyObject}->AnswerSave(
                AnswerID   => $AnswerID,
                QuestionID => $QuestionID,
                Answer     => $Answer,
                UserID     => $Self->{UserID},
            );
            return $Self->{LayoutObject}->Redirect( OP =>
                    "Action=$Self->{Action}&Subaction=QuestionEdit&SurveyID=$SurveyID&QuestionID=$QuestionID#Answer"
            );
        }
        else {
            return $Self->{LayoutObject}->Redirect( OP =>
                    "Action=$Self->{Action}&Subaction=AnswerEdit&SurveyID=$SurveyID&QuestionID=$QuestionID&AnswerID=$AnswerID"
            );
        }
    }

    # ------------------------------------------------------------ #
    # stats
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Stats' ) {
        my $SurveyID = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

        # check if survey exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Output = $Self->{LayoutObject}->Header( Title => 'Stats Overview' );
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'Stats',
            Data => { SurveyID => $SurveyID },
        );
        my @List = $Self->{SurveyObject}->VoteList( SurveyID => $SurveyID );
        for my $Vote (@List) {
            $Vote->{SurveyID} = $SurveyID;
            my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Vote->{TicketID} );
            $Vote->{TicketNumber} = $Ticket{TicketNumber};
            $Self->{LayoutObject}->Block(
                Name => 'StatsVote',
                Data => $Vote,
            );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurvey',
            Data         => {%Param},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # state detail
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'StatsDetail' ) {
        my $SurveyID  = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $RequestID = $Self->{ParamObject}->GetParam( Param => "RequestID" );

        # check if survey exists
        if ( $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}->ElementExists( ElementID => $RequestID, Element => 'Request' )
            ne 'Yes' )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Output = $Self->{LayoutObject}->Header( Title => 'Stats Detail' );
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'StatsDetail',
            Data => { SurveyID => $SurveyID },
        );
        my @QuestionList = $Self->{SurveyObject}->QuestionList( SurveyID => $SurveyID );
        for my $Question (@QuestionList) {
            $Self->{LayoutObject}->Block(
                Name => 'StatsDetailQuestion',
                Data => $Question,
            );
            my @Answers;
            if ( $Question->{Type} eq 'Radio' || $Question->{Type} eq 'Checkbox' ) {
                my @AnswerList;
                @AnswerList = $Self->{SurveyObject}->VoteGet(
                    RequestID  => $RequestID,
                    QuestionID => $Question->{QuestionID},
                );
                for my $Row (@AnswerList) {
                    my %Answer = $Self->{SurveyObject}->AnswerGet( AnswerID => $Row->{VoteValue} );
                    my %Data;
                    $Data{Answer} = $Answer{Answer};
                    push( @Answers, \%Data );
                }
            }
            elsif ( $Question->{Type} eq 'YesNo' || $Question->{Type} eq 'Textarea' ) {
                my @List = $Self->{SurveyObject}->VoteGet(
                    RequestID  => $RequestID,
                    QuestionID => $Question->{QuestionID},
                );
                my %Data;
                $Data{Answer} = $List[0]->{VoteValue};
                push( @Answers, \%Data );
            }
            for my $Row (@Answers) {
                $Self->{LayoutObject}->Block(
                    Name => 'StatsDetailAnswer',
                    Data => $Row,
                );
            }
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurvey',
            Data         => {%Param},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # show overview
    # ------------------------------------------------------------ #
    $Output = $Self->{LayoutObject}->Header( Title => 'Overview' );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # print the main table.
    $Self->{LayoutObject}->Block( Name => 'Overview' );
    my @List = $Self->{SurveyObject}->SurveyList();
    for my $SurveyID (@List) {

        # set output class
        if ( $Param{Class} && $Param{Class} eq 'searchpassive' ) {
            $Param{Class} = 'searchactive';
        }
        else {
            $Param{Class} = 'searchpassive';
        }
        my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $SurveyID );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewSurvey',
            Data => { %Survey, %Param },
        );
    }
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentSurvey',
        Data         => {%Param},
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
