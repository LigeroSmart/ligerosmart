# --
# Kernel/Modules/AgentSurveyStats.pm - survey stats module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentSurveyStats;

use strict;
use warnings;

use Kernel::System::Survey;
use Kernel::System::HTMLUtils;

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

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("Survey::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # ------------------------------------------------------------ #
    # stats
    # ------------------------------------------------------------ #
    if ( !$Self->{Subaction} ) {
        my $SurveyID = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

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
        $Output = $Self->{LayoutObject}->Header(
            Title     => 'Stats Overview',
            Type      => 'Small',
            BodyClass => 'Popup',
        );

        my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $SurveyID );

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'Stats',
            Data => {%Survey},
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
            TemplateFile => 'AgentSurveyStats',
            Data         => {%Param},
        );

        $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
        return $Output;
    }

    # ------------------------------------------------------------ #
    # stats details
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'StatsDetail' ) {
        my $SurveyID     = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $RequestID    = $Self->{ParamObject}->GetParam( Param => "RequestID" );
        my $TicketNumber = $Self->{ParamObject}->GetParam( Param => "TicketNumber" );

        # check if survey exists
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}->ElementExists( ElementID => $RequestID, Element => 'Request' )
            ne 'Yes'
            )
        {
            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this survey or stats detail!',
                WithHeader => 'yes',
            );
        }
        $Output = $Self->{LayoutObject}->Header(
            Title     => 'Stats Detail',
            Type      => 'Small',
            BodyClass => 'Popup',
        );

        my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $SurveyID );

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'StatsDetail',
            Data => {
                %Survey,
                TicketNumber => $TicketNumber,
            },
        );
        my @QuestionList = $Self->{SurveyObject}->QuestionList( SurveyID => $SurveyID );
        for my $Question (@QuestionList) {

            my $Class = '';
            if ( $Question->{Type} eq 'Textarea' ) {
                $Class = 'Textarea';
            }

            my $RequiredText = '';
            if ( $Question->{AnswerRequired} ) {
                $Class .= ' Mandatory';
                $RequiredText = '* ';
            }

            $Self->{LayoutObject}->Block(
                Name => 'StatsDetailQuestion',
                Data => {
                    %{$Question},
                    Class        => $Class,
                    RequiredText => $RequiredText,
                },
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

                # clean html
                if ( $Question->{Type} eq 'Textarea' && $Data{Answer} ) {
                    $Data{Answer} =~ s{\A\$html\/text\$\s(.*)}{$1}xms;
                    $Data{Answer} = $Self->{LayoutObject}->Ascii2Html(
                        Text           => $Data{Answer},
                        HTMLResultMode => 1,
                    );
                    $Data{Answer} =
                        $Self->{HTMLUtilsObject}->ToAscii( String => $Data{Answer} );
                }
                push( @Answers, \%Data );
            }
            for my $Row (@Answers) {
                $Self->{LayoutObject}->Block(
                    Name => 'StatsDetailAnswer',
                    Data => {
                        %{$Row},
                        Class => $Class,
                        }
                );
            }
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurveyStats',
            Data         => {%Param},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;
