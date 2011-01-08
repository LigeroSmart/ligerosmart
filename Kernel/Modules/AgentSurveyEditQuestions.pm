# --
# Kernel/Modules/AgentSurveyEditQuestions.pm - a survey module
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AgentSurveyEditQuestions.pm,v 1.1 2011-01-08 07:51:23 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentSurveyEditQuestions;

use strict;
use warnings;

use Kernel::System::Survey;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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
    my $SurveyID = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

    # ------------------------------------------------------------ #
    # question add
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'QuestionAdd' ) {
        my $SurveyID = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $Question = $Self->{ParamObject}->GetParam( Param => "Question" );
        my $Type     = $Self->{ParamObject}->GetParam( Param => "Type" );

        # check if survey exists
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            )
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
            OP => "Action=$Self->{Action};Subaction=SurveyEdit&SurveyID=$SurveyID#Question"
        );
    }

    # ------------------------------------------------------------ #
    # question delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionDelete' ) {
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => "QuestionID" );
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

        # check if survey and question exists
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Self->{SurveyObject}->QuestionDelete(
            SurveyID   => $SurveyID,
            QuestionID => $QuestionID,
        );
        $Self->{SurveyObject}->QuestionSort( SurveyID => $SurveyID );
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action}&Subaction=SurveyEdit&SurveyID=$SurveyID#Question"
        );
    }

    # ------------------------------------------------------------ #
    # question up
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionUp' ) {
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => "QuestionID" );
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

        # check if survey and question exists
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Self->{SurveyObject}->QuestionSort( SurveyID => $SurveyID );
        $Self->{SurveyObject}->QuestionUp(
            SurveyID   => $SurveyID,
            QuestionID => $QuestionID,
        );

        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action}&Subaction=SurveyEdit&SurveyID=$SurveyID#Question"
        );
    }

    # ------------------------------------------------------------ #
    # question down
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionDown' ) {
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => "QuestionID" );
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

        # check if survey and question exists
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Self->{SurveyObject}->QuestionSort( SurveyID => $SurveyID );
        $Self->{SurveyObject}->QuestionDown(
            SurveyID   => $SurveyID,
            QuestionID => $QuestionID,
        );
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action}&Subaction=SurveyEdit&SurveyID=$SurveyID#Question"
        );
    }

    # ------------------------------------------------------------ #
    # question edit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionEdit' ) {
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => "QuestionID" );

        # check if survey and question exists
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }

        # output header
        $Output = $Self->{LayoutObject}->Header( Title => 'Question Edit' );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $SurveyID );
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
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            )
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
                OP => "Action=$Self->{Action}&Subaction=SurveyEdit&SurveyID=$SurveyID#Question"
            );
        }
        else {
            return $Self->{LayoutObject}->Redirect(
                OP =>
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
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            )
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
        return $Self->{LayoutObject}->Redirect(
            OP =>
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
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            || $Self->{SurveyObject}->ElementExists( ElementID => $AnswerID, Element => 'Answer' )
            ne 'Yes'
            )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Self->{SurveyObject}->AnswerDelete(
            QuestionID => $QuestionID,
            AnswerID   => $AnswerID,
        );
        $Self->{SurveyObject}->AnswerSort( QuestionID => $QuestionID );
        return $Self->{LayoutObject}->Redirect(
            OP =>
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
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            || $Self->{SurveyObject}->ElementExists( ElementID => $AnswerID, Element => 'Answer' )
            ne 'Yes'
            )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Self->{SurveyObject}->AnswerSort( QuestionID => $QuestionID );
        $Self->{SurveyObject}->AnswerUp(
            QuestionID => $QuestionID,
            AnswerID   => $AnswerID,
        );
        return $Self->{LayoutObject}->Redirect(
            OP =>
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
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            || $Self->{SurveyObject}->ElementExists( ElementID => $AnswerID, Element => 'Answer' )
            ne 'Yes'
            )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Self->{SurveyObject}->AnswerSort( QuestionID => $QuestionID );
        $Self->{SurveyObject}->AnswerDown(
            QuestionID => $QuestionID,
            AnswerID   => $AnswerID,
        );
        return $Self->{LayoutObject}->Redirect(
            OP =>
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
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            || $Self->{SurveyObject}->ElementExists( ElementID => $AnswerID, Element => 'Answer' )
            ne 'Yes'
            )
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
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            || $Self->{SurveyObject}->ElementExists( ElementID => $AnswerID, Element => 'Answer' )
            ne 'Yes'
            )
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
            return $Self->{LayoutObject}->Redirect(
                OP =>
                    "Action=$Self->{Action}&Subaction=QuestionEdit&SurveyID=$SurveyID&QuestionID=$QuestionID#Answer"
            );
        }
        else {
            return $Self->{LayoutObject}->Redirect(
                OP =>
                    "Action=$Self->{Action};Subaction=AnswerEdit;SurveyID=$SurveyID;QuestionID=$QuestionID;AnswerID=$AnswerID"
            );
        }
    }

    # ------------------------------------------------------------ #
    # question overview
    # ------------------------------------------------------------ #

    if ( !$SurveyID ) {
        return $Self->{LayoutObject}->Redirect( OP => "Action=AgentSurvey" );
    }

    # output header
    $Output = $Self->{LayoutObject}->Header(
        Title => 'Survey Edit Questions',
        Type  => 'Small',
    );

    # get all attributes of the survey
    my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $SurveyID );

    $Self->{LayoutObject}->Block(
        Name => 'SurveyEditQuestions',
        Data => \%Survey,
    );

    my @List = $Self->{SurveyObject}->QuestionList( SurveyID => $SurveyID );

    if ( $Survey{Status} && $Survey{Status} eq 'New' ) {

        $Self->{LayoutObject}->Block( Name => 'SurveyDeleteColumn' );
        if ( scalar @List ) {
            for my $Question (@List) {
                my $AnswerCount = $Self->{SurveyObject}->AnswerCount(
                    QuestionID => $Question->{QuestionID},
                );

                my $Class;
                if ( $Question->{Type} eq 'Radio' || $Question->{Type} eq 'Checkbox' ) {
                    if ( $AnswerCount < 2 ) {
                        $Class = 'Error';
                    }
                }

                $Self->{LayoutObject}->Block(
                    Name => 'SurveyQuestionsRow',
                    Data => {
                        %{$Question},
                        Class => $Class
                    },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'SurveyQuestionsDeleteButton',
                    Data => $Question,
                );
            }
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'SurveyNoQuestionsSaved',
                Data => { Columns => 5, }
            );
        }

        $Self->{LayoutObject}->Block(
            Name => 'SurveyAddQuestion',
            Data => { SurveyID => $SurveyID },
        );
    }
    else {
        for my $Question (@List) {
            $Self->{LayoutObject}->Block(
                Name => 'SurveyQuestionsSaved',
                Data => $Question,
            );
        }
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentSurveyEditQuestions',
        Data => { SurveyID => $SurveyID },
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;

}

1;
