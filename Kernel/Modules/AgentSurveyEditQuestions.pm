# --
# Kernel/Modules/AgentSurveyEditQuestions.pm - a survey module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentSurveyEditQuestions;

use strict;
use warnings;

use Kernel::System::Survey;

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
    # question add
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'QuestionAdd' ) {
        my $SurveyID = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $Question = $Self->{ParamObject}->GetParam( Param => "Question" );
        my $Type     = $Self->{ParamObject}->GetParam( Param => "Type" );

        my $AnswerRequired = $Self->{ParamObject}->GetParam( Param => 'AnswerRequired' );
        if ( $AnswerRequired && $AnswerRequired eq 'No' ) {
            $AnswerRequired = 0;
        }
        else {
            $AnswerRequired = 1;
        }

        # check if survey exists
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            )
        {
            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this survey!',
                WithHeader => 'yes',
            );
        }

        my %ServerError;
        if ($Question) {
            $Self->{SurveyObject}->QuestionAdd(
                SurveyID       => $SurveyID,
                Question       => $Question,
                Type           => $Type,
                AnswerRequired => $AnswerRequired,
                UserID         => $Self->{UserID},
            );
            $Self->{SurveyObject}->QuestionSort( SurveyID => $SurveyID );
        }
        else {
            $ServerError{Question} = 1;
        }

        return $Self->_MaskQuestionOverview(
            SurveyID    => $SurveyID,
            ServerError => \%ServerError,
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
            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this survey or question!',
                WithHeader => 'yes',
            );
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
            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this survey or question!',
                WithHeader => 'yes',
            );
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
            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this survey or question!',
                WithHeader => 'yes',
            );
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
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => 'SurveyID' );
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => 'QuestionID' );

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
            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this survey or question!',
                WithHeader => 'yes',
            );
        }

        return $Self->_MaskQuestionEdit(
            SurveyID   => $SurveyID,
            QuestionID => $QuestionID,
        );
    }

    # ------------------------------------------------------------ #
    # question save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionSave' ) {
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => 'QuestionID' );
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => 'SurveyID' );
        my $Question   = $Self->{ParamObject}->GetParam( Param => 'Question' );

        my $AnswerRequired = $Self->{ParamObject}->GetParam( Param => 'AnswerRequired' );
        if ( $AnswerRequired && $AnswerRequired eq 'No' ) {
            $AnswerRequired = 0;
        }
        else {
            $AnswerRequired = 1;
        }

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
            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this survey or question!',
                WithHeader => 'yes',
            );
        }

        my %ServerError;
        if ($Question) {
            $Self->{SurveyObject}->QuestionUpdate(
                QuestionID     => $QuestionID,
                SurveyID       => $SurveyID,
                Question       => $Question,
                AnswerRequired => $AnswerRequired,
                UserID         => $Self->{UserID},
            );

            return $Self->_MaskQuestionEdit(
                SurveyID   => $SurveyID,
                QuestionID => $QuestionID,
            );
        }
        else {
            $ServerError{QuestionServerError} = 'ServerError';
        }

        return $Self->_MaskQuestionEdit(
            SurveyID    => $SurveyID,
            QuestionID  => $QuestionID,
            ServerError => \%ServerError,
        );
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
            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this survey or question!',
                WithHeader => 'yes',
            );
        }

        my %ServerError;
        if ($Answer) {
            $Self->{SurveyObject}->AnswerAdd(
                SurveyID   => $SurveyID,
                QuestionID => $QuestionID,
                Answer     => $Answer,
                UserID     => $Self->{UserID},
            );

            return $Self->_MaskQuestionEdit(
                SurveyID   => $SurveyID,
                QuestionID => $QuestionID,
            );
        }
        else {
            $ServerError{AnswerServerError} = 'ServerError';
        }

        return $Self->_MaskQuestionEdit(
            SurveyID    => $SurveyID,
            QuestionID  => $QuestionID,
            ServerError => \%ServerError,
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
            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this survey, question or answer!',
                WithHeader => 'yes',
            );
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
            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this survey, question or answer!',
                WithHeader => 'yes',
            );
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
            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this survey, question or answer!',
                WithHeader => 'yes',
            );
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
        my $SurveyID   = $Self->{ParamObject}->GetParam( Param => 'SurveyID' );
        my $QuestionID = $Self->{ParamObject}->GetParam( Param => 'QuestionID' );
        my $AnswerID   = $Self->{ParamObject}->GetParam( Param => 'AnswerID' );

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
            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this survey, question or answer!',
                WithHeader => 'yes',
            );
        }

        return $Self->_MaskAnswerEdit(
            SurveyID   => $SurveyID,
            QuestionID => $QuestionID,
            AnswerID   => $AnswerID,
        );
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
            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this survey, question or answer!',
                WithHeader => 'yes',
            );
        }

        my %ServerError;
        if ($Answer) {
            $Self->{SurveyObject}->AnswerUpdate(
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
            $ServerError{AnswerServerError} = 'SeverError';
        }

        return $Self->_MaskAnswerEdit(
            SurveyID    => $SurveyID,
            QuestionID  => $QuestionID,
            AnswerID    => $AnswerID,
            ServerError => \%ServerError,
        );
    }

    # ------------------------------------------------------------ #
    # question overview
    # ------------------------------------------------------------ #
    my $SurveyID = $Self->{ParamObject}->GetParam( Param => 'SurveyID' );

    if ( !$SurveyID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No SurveyID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check if survey exists
    if (
        $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
        'Yes'
        )
    {
        return $Self->{LayoutObject}->NoPermission(
            Message    => 'You have no permission for this survey!',
            WithHeader => 'yes',
        );
    }

    return $Self->_MaskQuestionOverview( SurveyID => $SurveyID );
}

sub _MaskQuestionOverview {
    my ( $Self, %Param ) = @_;

    my %ServerError;
    if ( $Param{ServerError} ) {
        %ServerError = %{ $Param{ServerError} };
    }

    my $Output;

    if ( !$Param{SurveyID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No SurveyID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # output header
    $Output = $Self->{LayoutObject}->Header(
        Title     => 'Survey Edit Questions',
        Type      => 'Small',
        BodyClass => 'Popup',
    );

    # get all attributes of the survey
    my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $Param{SurveyID} );

    $Self->{LayoutObject}->Block(
        Name => 'SurveyEditQuestions',
        Data => \%Survey,
    );

    my @List = $Self->{SurveyObject}->QuestionList( SurveyID => $Param{SurveyID} );

    if ( $Survey{Status} && $Survey{Status} eq 'New' ) {

        my $ArrayHashRef = [
            {
                Key      => 'YesNo',
                Value    => 'YesNo',
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
            Data          => $ArrayHashRef,
            Name          => 'Type',
            ID            => 'Type',
            SelectedValue => 'Yes/No',
            Translation   => 1,
        );

        $ArrayHashRef = [
            {
                Key      => 'Yes',
                Value    => 'Yes',
                Selected => 1,
            },
            {
                Key   => 'No',
                Value => 'No',
            }
        ];

        my $AnswerRequiredSelect = $Self->{LayoutObject}->BuildSelection(
            Data          => $ArrayHashRef,
            Name          => 'AnswerRequired',
            ID            => 'AnswerRequired',
            SelectedValue => 'Yes',
            Translation   => 1,
        );

        my $QuestionErrorClass = '';
        if ( $ServerError{Question} ) {
            $QuestionErrorClass = 'ServerError';
        }

        $Self->{LayoutObject}->Block(
            Name => 'SurveyAddQuestion',
            Data => {
                SurveyID             => $Param{SurveyID},
                SelectionType        => $SelectionType,
                AnswerRequiredSelect => $AnswerRequiredSelect,
                QuestionErrorClass   => $QuestionErrorClass,
            },
        );

        $Self->{LayoutObject}->Block( Name => 'SurveyDeleteColumn' );
        if ( scalar @List ) {
            $Self->{LayoutObject}->Block( Name => 'SurveyStatusColumn' );
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

                my $Status = 'Complete';
                if ( $Question->{Type} eq 'Radio' || $Question->{Type} eq 'Checkbox' ) {
                    if ( $AnswerCount < 2 ) {
                        $Class  = 'Error';
                        $Status = 'Incomplete';
                    }
                }

                my $AnswerRequired = $Question->{AnswerRequired} ? 'Yes' : 'No';

                $Self->{LayoutObject}->Block(
                    Name => 'SurveyQuestionsRow',
                    Data => {
                        %{$Question},
                        Status         => $Status,
                        AnswerRequired => $AnswerRequired,
                        Class          => $Class,
                        ClassUp        => $ClassUp,
                        ClassDown      => $ClassDown,
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
        my $Counter;
        for my $Question (@List) {

            my $ClassUp;
            my $ClassDown;

            if ( !$Counter ) {
                $ClassUp = 'Disabled',
            }

            if ( $Counter && $Counter == $#List ) {
                $ClassDown = 'Disabled',
            }

            my $AnswerRequired = $Question->{AnswerRequired} ? 'Yes' : 'No';

            $Self->{LayoutObject}->Block(
                Name => 'SurveyQuestionsSaved',
                Data => {
                    %{$Question},
                    AnswerRequired => $AnswerRequired,
                    ClassUp        => $ClassUp,
                    ClassDown      => $ClassDown,
                },
            );

            $Counter++;
        }
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentSurveyEditQuestions',
        Data => { SurveyID => $Param{SurveyID} },
    );

    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
    return $Output;
}

sub _MaskQuestionEdit {
    my ( $Self, %Param ) = @_;

    my %ServerError;
    if ( $Param{ServerError} ) {
        %ServerError = %{ $Param{ServerError} };
    }

    my $Output;

    # output header
    $Output = $Self->{LayoutObject}->Header(
        Title     => 'Question Edit',
        Type      => 'Small',
        BodyClass => 'Popup',
    );
    my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $Param{SurveyID} );
    my %Question = $Self->{SurveyObject}->QuestionGet( QuestionID => $Param{QuestionID} );

    my $ArrayHashRef = [
        {
            Key   => 'Yes',
            Value => 'Yes',
        },
        {
            Key   => 'No',
            Value => 'No',
        }
    ];

    if ( $Question{AnswerRequired} ) {
        $ArrayHashRef->[0]{Selected} = 1;
    }
    else {
        $ArrayHashRef->[1]{Selected} = 1;
    }

    my $AnswerRequiredSelect = $Self->{LayoutObject}->BuildSelection(
        Data          => $ArrayHashRef,
        Name          => 'AnswerRequired',
        ID            => 'AnswerRequired',
        SelectedValue => 'Yes',
        Translation   => 1,
    );

    # print the main body
    $Self->{LayoutObject}->Block(
        Name => 'QuestionEdit',
        Data => {
            AnswerRequiredSelect => $AnswerRequiredSelect,
            %Question,
            %ServerError,
        },
    );

    if ( $Question{Type} eq 'YesNo' ) {
        $Self->{LayoutObject}->Block( Name => 'QuestionEditTable' );
        $Self->{LayoutObject}->Block( Name => 'QuestionEditYesno' );
    }
    elsif ( $Question{Type} eq 'Radio' || $Question{Type} eq 'Checkbox' ) {

        $Self->{LayoutObject}->Block( Name => 'QuestionEditTable' );

        my $Type = $Question{Type};
        my @List = $Self->{SurveyObject}->AnswerList( QuestionID => $Param{QuestionID} );
        if ( scalar @List ) {

            if ( $Survey{Status} eq 'New' ) {

                $Self->{LayoutObject}->Block( Name => 'QuestionEditTableDelete' );

                my $Counter = 0;
                for my $Answer2 (@List) {
                    $Answer2->{SurveyID} = $Param{SurveyID};

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
                        },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'QuestionEdit' . $Type . 'Delete',
                        Data => $Answer2,
                    );
                    $Counter++;
                }

                $Self->{LayoutObject}->Block(
                    Name => 'QuestionEditAddAnswer',
                    Data => {
                        %Question,
                        %ServerError,
                    },
                );
            }
            else {
                my $Counter;
                for my $Answer2 (@List) {
                    $Answer2->{SurveyID} = $Param{SurveyID};

                    my $ClassUp;
                    my $ClassDown;

                    if ( !$Counter ) {
                        $ClassUp = 'Disabled',
                    }

                    if ( $Counter && $Counter == $#List ) {
                        $ClassDown = 'Disabled',
                    }

                    $Self->{LayoutObject}->Block(
                        Name => "QuestionEdit" . $Type,
                        Data => {
                            %{$Answer2},
                            ClassUp   => $ClassUp,
                            ClassDown => $ClassDown,
                        },
                    );
                    $Counter++;
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

sub _MaskAnswerEdit {
    my ( $Self, %Param ) = @_;

    my %ServerError;
    if ( $Param{ServerError} ) {
        %ServerError = %{ $Param{ServerError} };
    }

    my $Output;
    $Output = $Self->{LayoutObject}->Header(
        Title     => 'Answer Edit',
        Type      => 'Small',
        BodyClass => 'Popup',
    );
    my %Answer = $Self->{SurveyObject}->AnswerGet( AnswerID => $Param{AnswerID} );
    $Answer{SurveyID} = $Param{SurveyID};

    # print the main table.
    $Self->{LayoutObject}->Block(
        Name => 'AnswerEdit',
        Data => {
            %Answer,
            %Param,
            %ServerError,
        },
    );

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentSurveyEditQuestions',
        Data         => {%Param},
    );

    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
    return $Output;
}

1;
