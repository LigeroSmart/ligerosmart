# --
# Kernel/Modules/PublicSurvey.pm - a survey module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: PublicSurvey.pm,v 1.20 2010-12-29 17:11:59 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::PublicSurvey;

use strict;
use warnings;

use Kernel::System::Survey;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.20 $) [1];

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
    $Self->{SurveyObject} = Kernel::System::Survey->new(%Param);

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
        $Self->{LayoutObject}->Block( Name => 'PublicSurveyComplete' );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'PublicSurvey',
            Data         => {%Param},
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

    $Survey{Introduction} = $Self->{LayoutObject}->Ascii2Html(
        Text           => $Survey{Introduction},
        HTMLResultMode => 1,
    );

    $Survey{PublicSurveyKey} = $PublicSurveyKey;

    if ($UsedSurveyKey) {
        $Self->{LayoutObject}->Block(
            Name => 'PublicSurveyError',
            Data => {
                Message => 'You have already answered the survey, Thank you for your feedbak!.',
            },
        );
    }
    elsif ( $Survey{SurveyID} && $Survey{SurveyID} > 0 ) {
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
            }
        }
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'PublicSurveyError',
            Data => {
                Message => 'Invalid survey key.',
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
