# --
# Kernel/Modules/AgentSurveyEditQuestions.pm - a survey module
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AgentSurveyEditQuestions.pm,v 1.4 2011-01-11 04:07:19 dz Exp $
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
$VERSION = qw($Revision: 1.4 $) [1];

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
            OP => "Action=$Self->{Action};Subaction=SurveyEdit;SurveyID=$SurveyID#Question"
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
            OP => "Action=$Self->{Action};Subaction=SurveyEdit;SurveyID=$SurveyID#Question"
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
            OP => "Action=$Self->{Action};Subaction=SurveyEdit;SurveyID=$SurveyID#Question"
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
            OP => "Action=$Self->{Action};Subaction=SurveyEdit;SurveyID=$SurveyID#Question"
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
        $Output = $Self->{LayoutObject}->Header(
            Title => 'Question Edit',
            Type  => 'Small',
        );
        my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $SurveyID );
        my %Question = $Self->{SurveyObject}->QuestionGet( QuestionID => $QuestionID );

        # print the main body
        $Self->{LayoutObject}->Block(
            Name => 'QuestionEdit',
            Data => {%Question},
        );

        if ( $Question{Type} eq 'YesNo' ) {
            $Self->{LayoutObject}->Block( Name => 'QuestionEditTable' );
            $Self->{LayoutObject}->Block( Name => 'QuestionEditYesno' );
        }
        elsif ( $Question{Type} eq 'Radio' || $Question{Type} eq 'Checkbox' ) {

            $Self->{LayoutObject}->Block( Name => 'QuestionEditTable' );

            my $Type = $Question{Type};
            my @List = $Self->{SurveyObject}->AnswerList( QuestionID => $QuestionID );
            if ( scalar @List ) {
                if ( $Survey{Status} eq 'New' ) {
                    $Self->{LayoutObject}->Block( Name => 'QuestionEditTableDelete' );

                    my $Counter = 0;
                    for my $Answer2 (@List) {
                        $Answer2->{SurveyID} = $SurveyID;

                        my $ClassUp;
                        my $ClassDown;

                        # disable up action on first row
                        if ( !$Counter ) {
                            $ClassUp = 'Disabled';
                        }

                        # disable down action on last row
                        if ( $Counter == $#List ) {
                            $ClassDown = 'Disabled';
                        }

                        $Self->{LayoutObject}->Block(
                            Name => "QuestionEdit" . $Type,
                            Data => {
                                %{$Answer2},
                                ClassUp   => $ClassUp,
                                ClassDown => $ClassDown,
                                }
                        );
                        $Self->{LayoutObject}->Block(
                            Name => 'QuestionEdit' . $Type . 'Delete',
                            Data => $Answer2,
                        );
                        $Counter++;
                    }
                    $Self->{LayoutObject}->Block(
                        Name => 'QuestionEditAddAnswer',
                        Data => {%Question},
                    );
                }
                else {
                    for my $Answer2 (@List) {
                        $Answer2->{SurveyID} = $SurveyID;
                        $Self->{LayoutObject}->Block(
                            Name => "QuestionEditRadio" . $Type,
                            Data => $Answer2,
                        );
                    }
                }
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'NoAnswersSaved',
                    Data => {
                        Columns => 3,
                    },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'QuestionEditAddAnswer',
                    Data => {%Question},
                );
            }
        }
        elsif ( $Question{Type} eq 'Textarea' ) {
            $Self->{LayoutObject}->Block( Name => 'QuestionEditTextArea' );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurveyEditQuestions',
            Data         => {%Param},
        );
        $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
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
                OP =>
                    "Action=$Self->{Action};Subaction=QuestionEdit;SurveyID=$SurveyID;QuestionID=$QuestionID",
            );
        }
        else {
            return $Self->{LayoutObject}->Redirect(
                OP =>
                    "Action=$Self->{Action};Subaction=QuestionEdit;SurveyID=$SurveyID;QuestionID=$QuestionID",
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
                "Action=$Self->{Action};Subaction=QuestionEdit;SurveyID=$SurveyID;QuestionID=$QuestionID#NewAnswer",
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
                "Action=$Self->{Action};Subaction=QuestionEdit;SurveyID=$SurveyID;QuestionID=$QuestionID#Answer",
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
                "Action=$Self->{Action};Subaction=QuestionEdit;SurveyID=$SurveyID;QuestionID=$QuestionID#Answer",
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
                "Action=$Self->{Action};Subaction=QuestionEdit;SurveyID=$SurveyID;QuestionID=$QuestionID#Answer",
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
        $Output = $Self->{LayoutObject}->Header(
            Title => 'Answer Edit',
            Type  => 'Small',
        );
        my %Answer = $Self->{SurveyObject}->AnswerGet( AnswerID => $AnswerID );
        $Answer{SurveyID} = $SurveyID;

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'AnswerEdit',
            Data => {%Answer},
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurveyEditQuestions',
            Data         => {%Param},
        );
        $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
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
                    "Action=$Self->{Action};Subaction=QuestionEdit;SurveyID=$SurveyID;QuestionID=$QuestionID#Answer"
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

        my $ArrayHashRef = [
            {
                Key      => 'Yes/No',
                Value    => 'Yes/No',
                Selected => 1,
            },
            {
                Key   => 'Radio',
                Value => 'Radio (List)',
            },
            {
                Key   => 'Checkbox',
                Value => 'Checkbox (List)',
            },
            {
                Key   => 'Textarea',
                Value => 'Textarea',
            },
        ];

        my $SelectionType = $Self->{LayoutObject}->BuildSelection(
            Data => $ArrayHashRef,    # use $HashRef, $ArrayRef or $ArrayHashRef (see below)
            Name => 'Type',           # name of element
            ID   => 'HTMLID'
            , # (optional) the HTML ID for this element, if not provided, the name will be used as ID as well
            Class => 'class',    # (optional) a css class
            SelectedValue =>
                'test',    # (optional) use string or arrayref (unable to use with ArrayHashRef)
            Translation => 1,    # (optional) default 1 (0|1) translate value
        );

        $Self->{LayoutObject}->Block(
            Name => 'SurveyAddQuestion',
            Data => {
                SurveyID      => $SurveyID,
                SelectionType => $SelectionType,
            },
        );

        $Self->{LayoutObject}->Block( Name => 'SurveyDeleteColumn' );
        if ( scalar @List ) {

            my $Counter = 0;

            for my $Question (@List) {
                my $AnswerCount = $Self->{SurveyObject}->AnswerCount(
                    QuestionID => $Question->{QuestionID},
                );

                my $Class;
                my $ClassUp;
                my $ClassDown;

                if ( !$Counter ) {
                    $ClassUp = 'Disabled',
                }

                if ( $Counter == $#List ) {
                    $ClassDown = 'Disabled',
                }

                if ( $Question->{Type} eq 'Radio' || $Question->{Type} eq 'Checkbox' ) {
                    if ( $AnswerCount < 2 ) {
                        $Class = 'Error';
                    }
                }

                $Self->{LayoutObject}->Block(
                    Name => 'SurveyQuestionsRow',
                    Data => {
                        %{$Question},
                        Class     => $Class,
                        ClassUp   => $ClassUp,
                        ClassDown => $ClassDown,
                    },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'SurveyQuestionsDeleteButton',
                    Data => $Question,
                );
                $Counter++;
            }
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'SurveyNoQuestionsSaved',
                Data => { Columns => 5, }
            );
        }

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

    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
    return $Output;

}

1;
