# --
# Kernel/Modules/AgentSurveyZoom.pm - a survey module
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AgentSurveyZoom.pm,v 1.4 2011-01-17 17:22:58 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentSurveyZoom;

use strict;
use warnings;

use Kernel::System::Survey;
use Kernel::System::HTMLUtils;

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
    $Self->{SurveyObject}    = Kernel::System::Survey->new(%Param);
    $Self->{HTMLUtilsObject} = Kernel::System::HTMLUtils->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # ------------------------------------------------------------ #
    # survey zoom
    # ------------------------------------------------------------ #

    # get params
    my $SurveyID = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
    my $Message  = $Self->{ParamObject}->GetParam( Param => "Message" );

    # check if survey exists
    if (
        !$SurveyID ||
        $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
        'Yes'
        )
    {
        $Message = ';Message=NoSurveyID';
        return $Self->{LayoutObject}->Redirect( OP => "Action=AgentSurvey$Message" );
    }

    # output header
    $Output = $Self->{LayoutObject}->Header( Title => 'Survey' );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # output mesages if status was changed
    if ( defined($Message) && $Message eq 'NoQuestion' ) {
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Info     => 'Can\'t set new status! No questions defined.',
        );
    }
    elsif ( defined($Message) && $Message eq 'IncompleteQuestion' ) {
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Info     => 'Can\'t set new status! Questions incomplete.',
        );
    }
    elsif ( defined($Message) && $Message eq 'StatusSet' ) {
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => 'Notice',
            Info     => 'Status changed.',
        );
    }

    # get all attributes of the survey
    my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $SurveyID );

    # convert the textareas in html (\n --><br>)
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

    # get selected queues
    my %Queues = $Self->{QueueObject}->GetAllQueues();
    my @QueueList = map { $Queues{$_} } @{ $Survey{Queues} };
    @QueueList = sort { lc $a cmp lc $b } @QueueList;
    my $QueueListString = join q{, }, @QueueList;

    my $NoQueueMessage = '';
    if ( !$QueueListString ) {
        $QueueListString = '- No queue selected -';
    }

    # convert introduction field to ascii
    $Survey{IntroductionASCII}
        = $Self->{HTMLUtilsObject}->ToAscii( String => $Survey{Introduction} );

    # print the main table.
    $Self->{LayoutObject}->Block(
        Name => 'SurveyZoom',
        Data => {
            %Survey,
            NoQueueMessage  => $NoQueueMessage,
            QueueListString => $QueueListString,
        },
    );

    # display stats if status Master, Valid or Invalid
    if (
        $Survey{Status}    eq 'Master'
        || $Survey{Status} eq 'Valid'
        || $Survey{Status} eq 'Invalid'
        )
    {
        $Self->{LayoutObject}->Block(
            Name => 'SurveyEditStats',
            Data => {
                SurveyID => $SurveyID,
            },
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
            if (
                $Question->{Type}    eq 'YesNo'
                || $Question->{Type} eq 'Radio'
                || $Question->{Type} eq 'Checkbox'
                )
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
                    @AnswerList = $Self->{SurveyObject}->AnswerList(
                        QuestionID => $Question->{QuestionID},
                    );
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

    if ( $Survey{Status} eq 'New' ) {
        $Self->{LayoutObject}->Block( Name => 'NoStatResults' );
    }

    # output the possible status
    my %NewStatus;
    $NewStatus{ChangeStatus} = '- Change Status -';

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

    my $NewStatusStr = $Self->{LayoutObject}->BuildSelection(
        Name       => 'NewStatus',
        ID         => 'NewStatus',
        Data       => \%NewStatus,
        SelectedID => 'ChangeStatus',
    );

    $Self->{LayoutObject}->Block(
        Name => 'SurveyStatus',
        Data => {
            NewStatusStr => $NewStatusStr,
            SurveyID     => $SurveyID,
        },
    );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentSurveyZoom',
        Data         => {%Param},
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;

}

1;
