# --
# Kernel/Modules/PublicSurvey.pm - a survey module
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: PublicSurvey.pm,v 1.23 2011-01-31 22:46:34 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::PublicSurvey;

use strict;
use warnings;

use Kernel::System::Survey;
use Kernel::System::HTMLUtils;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.23 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common objects
    %{$Self} = %Param;

    # check needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject)) {
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
    # public survey vote
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'PublicSurveyVote' ) {
        my $PublicSurveyKey = $Self->{ParamObject}->GetParam( Param => 'PublicSurveyKey' );
        my %Survey = $Self->{SurveyObject}->PublicSurveyGet( PublicSurveyKey => $PublicSurveyKey );
        if ( $Survey{SurveyID} ) {
            my @QuestionList = $Self->{SurveyObject}->QuestionList( SurveyID => $Survey{SurveyID} );
            for my $Question (@QuestionList) {
                if ( $Question->{Type} eq 'YesNo' ) {
                    my $PublicSurveyVote1 = $Self->{ParamObject}->GetParam(
                        Param => "PublicSurveyVote1[$Question->{QuestionID}]"
                    );
                    $Self->{SurveyObject}->PublicAnswerSave(
                        PublicSurveyKey => $PublicSurveyKey,
                        QuestionID      => $Question->{QuestionID},
                        VoteValue       => $PublicSurveyVote1,
                    );
                }
                elsif ( $Question->{Type} eq 'Radio' ) {
                    my $PublicSurveyVote2 = $Self->{ParamObject}->GetParam(
                        Param => "PublicSurveyVote2[$Question->{QuestionID}]"
                    );
                    $Self->{SurveyObject}->PublicAnswerSave(
                        PublicSurveyKey => $PublicSurveyKey,
                        QuestionID      => $Question->{QuestionID},
                        VoteValue       => $PublicSurveyVote2,
                    );
                }
                elsif ( $Question->{Type} eq 'Checkbox' ) {
                    my @AnswerList = $Self->{SurveyObject}->AnswerList(
                        QuestionID => $Question->{QuestionID}
                    );
                    for my $Answer (@AnswerList) {
                        my $PublicSurveyVote3 = $Self->{ParamObject}->GetParam(
                            Param => "PublicSurveyVote3[$Answer->{AnswerID}]"
                        );
                        if ( $PublicSurveyVote3 && $PublicSurveyVote3 eq 'Yes' ) {
                            $Self->{SurveyObject}->PublicAnswerSave(
                                PublicSurveyKey => $PublicSurveyKey,
                                QuestionID      => $Question->{QuestionID},
                                VoteValue       => $Answer->{AnswerID},
                            );
                        }
                    }
                }
                elsif ( $Question->{Type} eq 'Textarea' ) {
                    my $PublicSurveyVote4 = $Self->{ParamObject}->GetParam(
                        Param => "PublicSurveyVote4[$Question->{QuestionID}]"
                    );

                    # check if rich text is enabled
                    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                        $PublicSurveyVote4 = "\$html/text\$ $PublicSurveyVote4";
                    }

                    $Self->{SurveyObject}->PublicAnswerSave(
                        PublicSurveyKey => $PublicSurveyKey,
                        QuestionID      => $Question->{QuestionID},
                        VoteValue       => $PublicSurveyVote4,
                    );
                }
            }
            $Self->{SurveyObject}->PublicSurveyInvalidSet( PublicSurveyKey => $PublicSurveyKey );
        }
        $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Survey' );

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'PublicSurveyMessage',
            Data => {
                MessageType   => 'Survey Information',
                MessageHeader => 'Thank you for your feedback.',
                Message       => 'The survey is finished.',
            },
        );

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'PublicSurvey',
            Data         => {%Param},
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # show survey vote data
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ShowVoteData' ) {
        my $PublicSurveyKey = $Self->{ParamObject}->GetParam( Param => 'PublicSurveyKey' );

        # return if feature not enabled
        if ( !$Self->{ConfigObject}->Get("Survey::ShowVoteData") ) {
            $Output .= $Self->{LayoutObject}->CustomerHeader();

            $Self->{LayoutObject}->Block(
                Name => 'PublicSurveyMessage',
                Data => {
                    MessageType   => 'Survey Message!',
                    MessageHeader => 'Module not enabled.',
                    Message =>
                        'This functionality is not enabled, please contact your administrator.',
                },
            );

            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'PublicSurvey',
            );

            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }

        # Get the request data and start showing the data
        my %RequestData = $Self->{SurveyObject}->RequestGet(
            PublicSurveyKey => $PublicSurveyKey,
        );

        my $SurveyID  = $RequestData{SurveyID};
        my $TicketID  = $RequestData{TicketID};
        my $RequestID = $RequestData{RequestID};

        # check if survey exists
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}->ElementExists( ElementID => $RequestID, Element => 'Request' )
            ne 'Yes'
            )
        {
            $Self->{LogObject}->Log(
                Message  => "Wrong public survey key: $PublicSurveyKey!",
                Priority => 'info',
            );

            $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Survey' );

            $Self->{LayoutObject}->Block(
                Name => 'PublicSurveyMessage',
                Data => {
                    MessageType   => 'Survey Error!',
                    MessageHeader => 'Invalid survey key.',
                    Message =>
                        'The inserted survey key is invalid, if you followed a link maybe this is obsolete or broken.',
                },
            );

            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'PublicSurvey',
            );

            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }

        $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Survey Vote' );

        my %Survey = $Self->{SurveyObject}->SurveyGet(
            SurveyID => $SurveyID,
            Public   => 1,
        );

        # clean html
        if ( $Survey{Introduction} ) {
            $Survey{Introduction} =~ s{\A\$html\/text\$\s(.*)}{$1}xms;
            $Survey{Introduction} = $Self->{LayoutObject}->Ascii2Html(
                Text           => $Survey{Introduction},
                HTMLResultMode => 1,
            );
            $Survey{Introduction} =
                $Self->{HTMLUtilsObject}->ToAscii( String => $Survey{Introduction} );
        }

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'PublicSurveyVoteData',
            Data => {
                %Survey,
                MessageType => 'Survey Vote Data',
            },
        );
        my @QuestionList = $Self->{SurveyObject}->QuestionList( SurveyID => $SurveyID );
        for my $Question (@QuestionList) {

            my $Class = '';
            if ( $Question->{Type} eq 'Textarea' ) {
                $Class = 'Textarea';
            }

            $Self->{LayoutObject}->Block(
                Name => 'PublicSurveyVoteQuestion',
                Data => {
                    %{$Question},
                    Class => $Class,
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
                    Name => 'PublicSurveyVoteAnswer',
                    Data => {
                        %{$Row},
                        Class => $Class,
                        }
                );
            }
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'PublicSurvey',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # show survey
    # ------------------------------------------------------------ #
    my $PublicSurveyKey = $Self->{ParamObject}->GetParam( Param => 'PublicSurveyKey' );
    $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Survey' );

    my $UsedSurveyKey = $Self->{SurveyObject}->PublicSurveyGet(
        PublicSurveyKey => $PublicSurveyKey,
        Invalid         => 1,
    );

    my %Survey = $Self->{SurveyObject}->PublicSurveyGet( PublicSurveyKey => $PublicSurveyKey );

    $Survey{PublicSurveyKey} = $PublicSurveyKey;

    if ($UsedSurveyKey) {
        $Self->{LayoutObject}->Block(
            Name => 'PublicSurveyMessage',
            Data => {
                MessageType   => 'Survey Information',
                MessageHeader => 'Thank you for your feedback.',
                Message       => 'You have already answered the survey.',
            },
        );

        if ( $Self->{ConfigObject}->Get("Survey::ShowVoteData") ) {
            $Self->{LayoutObject}->Block(
                Name => 'ShowAnswersButton',
                Data => {
                    PublicSurveyKey => $PublicSurveyKey,
                    }
            );
        }
    }
    elsif ( $Survey{SurveyID} ) {

        # clean html and proccess introduction text
        $Survey{Introduction} =~ s{\A\$html\/text\$\s(.*)}{$1}xms;
        $Survey{Introduction} = $Self->{LayoutObject}->Ascii2Html(
            Text           => $Survey{Introduction},
            HTMLResultMode => 1,
        );

        $Survey{Introduction}
            = $Self->{HTMLUtilsObject}->ToAscii( String => $Survey{Introduction} );

        $Self->{LayoutObject}->Block(
            Name => 'PublicSurvey',
            Data => {%Survey},
        );

        my @QuestionList = $Self->{SurveyObject}->QuestionList( SurveyID => $Survey{SurveyID} );
        for my $Question (@QuestionList) {
            $Self->{LayoutObject}->Block( Name => 'PublicQuestions' );
            if ( $Question->{Type} eq 'YesNo' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'PublicAnswerYesNo',
                    Data => $Question,
                );
            }
            elsif ( $Question->{Type} eq 'Radio' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'PublicAnswerRadio',
                    Data => $Question,
                );
                my @AnswerList = $Self->{SurveyObject}->AnswerList(
                    QuestionID => $Question->{QuestionID},
                );
                for my $Answer (@AnswerList) {
                    $Self->{LayoutObject}->Block(
                        Name => 'PublicAnswerRadiob',
                        Data => $Answer,
                    );
                }
            }
            elsif ( $Question->{Type} eq 'Checkbox' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'PublicAnswerCheckbox',
                    Data => $Question,
                );
                my @AnswerList = $Self->{SurveyObject}->AnswerList(
                    QuestionID => $Question->{QuestionID},
                );
                for my $Answer (@AnswerList) {
                    $Self->{LayoutObject}->Block(
                        Name => 'PublicAnswerCheckboxb',
                        Data => $Answer,
                    );
                }
            }
            elsif ( $Question->{Type} eq 'Textarea' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'PublicAnswerTextarea',
                    Data => $Question,
                );

                # check if rich text is enabled
                if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                    $Self->{LayoutObject}->Block( Name => 'RichText' );
                }
            }
        }
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'PublicSurveyMessage',
            Data => {
                MessageType   => 'Survey Error!',
                MessageHeader => 'Invalid survey key.',
                Message =>
                    'The inserted survey key is invalid, if you followed a link maybe this is obsolete or broken.',
            },
        );
    }
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'PublicSurvey',
        Data         => {%Param},
    );
    $Output .= $Self->{LayoutObject}->CustomerFooter();
    return $Output;
}

1;
