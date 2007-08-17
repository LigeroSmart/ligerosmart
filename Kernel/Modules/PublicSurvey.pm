# --
# Kernel/Modules/PublicSurvey.pm - a survey module
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: PublicSurvey.pm,v 1.13 2007-08-17 10:12:33 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::PublicSurvey;

use strict;
use warnings;

use Kernel::System::Survey;

use vars qw($VERSION);
$VERSION = '$Revision: 1.13 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed objects
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    $Self->{SurveyObject} = Kernel::System::Survey->new(%Param);

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;

    # ------------------------------------------------------------ #
    # public survey vote
    # ------------------------------------------------------------ #
    if ($Self->{Subaction} eq 'PublicSurveyVote') {
        my $PublicSurveyKey = $Self->{ParamObject}->GetParam(Param => "PublicSurveyKey");
        my %Survey = $Self->{SurveyObject}->PublicSurveyGet(
            PublicSurveyKey => $PublicSurveyKey,
        );
        if ($Survey{SurveyID} > 0 ) {
            my @QuestionList = $Self->{SurveyObject}->QuestionList(
                SurveyID => $Survey{SurveyID},
            );
            foreach my $Question(@QuestionList) {
                if ($Question->{Type} eq 'YesNo' ) {
                    my $PublicSurveyVote1 = $Self->{ParamObject}->GetParam(Param => "PublicSurveyVote1[$Question->{QuestionID}]");
                    $Self->{SurveyObject}->PublicAnswerSave(
                        PublicSurveyKey => $PublicSurveyKey,
                        QuestionID => $Question->{QuestionID},
                        VoteValue => $PublicSurveyVote1
                    );
                }
                elsif ($Question->{Type} eq 'Radio' ) {
                    my $PublicSurveyVote2 = $Self->{ParamObject}->GetParam(Param => "PublicSurveyVote2[$Question->{QuestionID}]");
                    $Self->{SurveyObject}->PublicAnswerSave(
                        PublicSurveyKey => $PublicSurveyKey,
                        QuestionID => $Question->{QuestionID},
                        VoteValue => $PublicSurveyVote2
                    );
                }
                elsif ($Question->{Type} eq 'Checkbox' ) {
                    my @AnswerList = $Self->{SurveyObject}->AnswerList(
                        QuestionID => $Question->{QuestionID},
                    );
                    foreach my $Answer(@AnswerList) {
                        my $PublicSurveyVote3 = $Self->{ParamObject}->GetParam(Param => "PublicSurveyVote3[$Answer->{AnswerID}]");
                        if ($PublicSurveyVote3 eq 'Yes') {
                            $Self->{SurveyObject}->PublicAnswerSave(
                                PublicSurveyKey => $PublicSurveyKey,
                                QuestionID => $Question->{QuestionID},
                                VoteValue => $Answer->{AnswerID}
                            );
                        }
                    }
                }
                elsif ($Question->{Type} eq 'Textarea' ) {
                    my $PublicSurveyVote4 = $Self->{ParamObject}->GetParam(Param => "PublicSurveyVote4[$Question->{QuestionID}]");
                    $Self->{SurveyObject}->PublicAnswerSave(
                        PublicSurveyKey => $PublicSurveyKey,
                        QuestionID => $Question->{QuestionID},
                        VoteValue => $PublicSurveyVote4
                    );
                }
            }
            $Self->{SurveyObject}->PublicSurveyInvalidSet(
                PublicSurveyKey => $PublicSurveyKey,
            );
        }
        $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Survey');
        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'PublicSurveyComplete',
            Data => {},
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'PublicSurvey',
            Data => {%Param},
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    # ------------------------------------------------------------ #
    # show survey
    # ------------------------------------------------------------ #
    my $PublicSurveyKey = $Self->{ParamObject}->GetParam(Param => "PublicSurveyKey");
    $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Survey');
    my %Survey = $Self->{SurveyObject}->PublicSurveyGet(
        PublicSurveyKey => $PublicSurveyKey,
    );
    $Survey{Introduction} = $Self->{LayoutObject}->Ascii2Html(
        Text => $Survey{Introduction},
        HTMLResultMode => 1,
    );
    $Survey{PublicSurveyKey} = $PublicSurveyKey;
    if($Survey{SurveyID} > 0 ) {
        $Self->{LayoutObject}->Block(
            Name => 'PublicSurvey',
            Data => {%Survey},
        );
        my @QuestionList = $Self->{SurveyObject}->QuestionList(
            SurveyID => $Survey{SurveyID},
        );
        foreach my $Question(@QuestionList) {
            $Self->{LayoutObject}->Block(
                Name => 'PublicQuestions',
                Data => {},
            );
            if ($Question->{Type} eq 'YesNo' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'PublicAnswerYesNo',
                    Data => $Question,
                );
            }
            elsif ($Question->{Type} eq 'Radio' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'PublicAnswerRadio',
                    Data => $Question,
                );
                my @AnswerList = $Self->{SurveyObject}->AnswerList(
                    QuestionID => $Question->{QuestionID},
                );
                my $Counter = 0;
                foreach my $Answer(@AnswerList) {
                    if ($Counter eq '0') {
                        $Self->{LayoutObject}->Block(
                            Name => 'PublicAnswerRadiobChecked',
                            Data => $Answer,
                        );
                    }
                    else {
                        $Self->{LayoutObject}->Block(
                            Name => 'PublicAnswerRadiob',
                            Data => $Answer,
                        );
                    }
                    $Counter++;
                }
            }
            elsif ($Question->{Type} eq 'Checkbox' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'PublicAnswerCheckbox',
                    Data => $Question,
                );
                my @AnswerList = $Self->{SurveyObject}->AnswerList(
                    QuestionID => $Question->{QuestionID},
                );
                foreach my $Answer(@AnswerList) {
                    $Self->{LayoutObject}->Block(
                        Name => 'PublicAnswerCheckboxb',
                        Data => $Answer,
                    );
                }
            }
            elsif ($Question->{Type} eq 'Textarea' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'PublicAnswerTextarea',
                    Data => $Question,
                );
            }
        }
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'PublicNoSurvey',
            Data => {},
        );
    }
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'PublicSurvey',
        Data => {%Param},
    );
    $Output .= $Self->{LayoutObject}->CustomerFooter();
    return $Output;
}

1;