# --
# Kernel/Modules/AgentSurvey.pm - a survey module
# Copyright (C) 2003-2006 OTRS GmbH, http://www.otrs.com/
# --
# $Id: AgentSurvey.pm,v 1.1 2006-03-11 09:46:25 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentSurvey;

use strict;
use Kernel::System::Survey;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }
    $Self->{SurveyObject}=Kernel::System::Survey->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;

    if ($Self->{Subaction} eq 'Survey') {
        my $SurveyID = $Self->{ParamObject}->GetParam(Param => "SurveyID");

        $Output = $Self->{LayoutObject}->Header(Title => 'Survey');
        $Output .= $Self->{LayoutObject}->NavigationBar();

        my %Survey=$Self->{SurveyObject}->SurveyGet(SurveyID=>$SurveyID);
        my $ValidOnce = $Self->{SurveyObject}->ValidOnce(SurveyID=>$SurveyID);

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'Survey',
            Data => {%Survey},
        );

        if ($Survey{SurveyValid} eq 'No')
        {
            $Self->{LayoutObject}->Block(
                Name => 'SurveyMasterNo',
                Data => {%Survey},
            );
            $Self->{LayoutObject}->Block(
                Name => 'SurveyValidYes',
                Data => {%Survey},
            );

        }
        else
        {
            $Self->{LayoutObject}->Block(
                Name => 'SurveyMasterYes',
                Data => {%Survey},
            );

            if ($Survey{SurveyMaster} eq 'No') {
                $Self->{LayoutObject}->Block(
                    Name => 'SurveyValidYes',
                    Data => {%Survey},
                );
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'SurveyValidNo',
                    Data => {%Survey},
                );
            }
        }

        if ($ValidOnce eq 'Yes')
        {
            my $RequestComplete = $Self->{SurveyObject}->CountRequestComplete(SurveyID=>$SurveyID);

            $Self->{LayoutObject}->Block(
                Name => 'SurveyEditStats',
                Data => {SurveyID=>$SurveyID},
            );

            my @QuestionList=$Self->{SurveyObject}->QuestionList(SurveyID=>$SurveyID);

            foreach my $Question(@QuestionList) {
                $Self->{LayoutObject}->Block(
                    Name => 'SurveyEditStatsQuestion',
                    Data => $Question,
                );

                my @Answers = ();

                if ($Question->{QuestionType} eq '1' || $Question->{QuestionType} eq '2' || $Question->{QuestionType} eq '3' ) {
                    my @AnswerList = ();

                    if ($Question->{QuestionType} eq '1') {
                        my %Data = ();
                        $Data{Answer} = "Yes";
                        $Data{AnswerID} = "Yes";
                        push(@AnswerList,\%Data);

                        %Data = ();
                        $Data{Answer} = "No";
                        $Data{AnswerID} = "No";
                        push(@AnswerList,\%Data);
                    }
                    else {
                        @AnswerList = $Self->{SurveyObject}->AnswerList(QuestionID=>$Question->{QuestionID});
                    }

                    foreach my $Row(@AnswerList) {
                        my $CountVote = $Self->{SurveyObject}->CountVote(QuestionID=>$Question->{QuestionID}, VoteValue=>$Row->{AnswerID});
                        my $Percent = 0;

                        if ($RequestComplete ne '0') {
                            $Percent = 100 / $RequestComplete * $CountVote;
                            $Percent = sprintf ("%.0f", $Percent);
                        }

                        my %Data = ();
                        $Data{Answer} = $Row->{Answer};
                        $Data{AnswerPercent} = $Percent;

                        push(@Answers,\%Data);
                    }
                }
                elsif ($Question->{QuestionType} eq '4' ) {
                    my $AnswerNo = $Self->{SurveyObject}->CountVote(QuestionID=>$Question->{QuestionID}, VoteValue=>'');
                    my $Percent = 0;

                    if ($RequestComplete ne '0') {
                        $Percent = 100 / $RequestComplete * $AnswerNo;
                        $Percent = sprintf ("%.0f", $Percent);
                    }

                    my %Data = ();
                    $Data{Answer} = "answered";

                    if ($RequestComplete eq '0') {
                        $Data{AnswerPercent} = 0;
                    } else {
                        $Data{AnswerPercent} = 100 - $Percent;
                    }

                    push(@Answers,\%Data);

                    %Data = ();
                    $Data{Answer} = "not answered";
                    $Data{AnswerPercent} = $Percent;

                    push(@Answers,\%Data);
                }

                foreach my $Row(@Answers) {
                    $Row->{AnswerPercentTable} = $Row->{AnswerPercent};

                    if ($Row->{AnswerPercent} eq 0) {
                        $Row->{AnswerPercentTable} = 1;
                    }

                    $Self->{LayoutObject}->Block(
                        Name => 'SurveyEditStatsAnswer',
                        Data => $Row,
                    );
                }
            }

            if ($RequestComplete > 0) {
                $Self->{LayoutObject}->Block(
                    Name => 'SurveyEditStatsDetails',
                    Data => {},
                );
            }
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurvey',
            Data => {
                %Param,
            }
        );

        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    elsif ($Self->{Subaction} eq 'SurveyChangeMaster') {
       my $SurveyID = $Self->{ParamObject}->GetParam(Param => "SurveyID");
       $Self->{SurveyObject}->SurveyChangeMaster(SurveyID=>$SurveyID);

       return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=Survey&SurveyID=$SurveyID");
    }

    elsif ($Self->{Subaction} eq 'SurveyChangeValid') {
       my $SurveyID = $Self->{ParamObject}->GetParam(Param => "SurveyID");
       $Self->{SurveyObject}->SurveyChangeValid(SurveyID=>$SurveyID);

       return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=Survey&SurveyID=$SurveyID");
    }

    elsif ($Self->{Subaction} eq 'SurveyEdit') {
        my $SurveyID = $Self->{ParamObject}->GetParam(Param => "SurveyID");

        $Output = $Self->{LayoutObject}->Header(Title => 'Survey');
        $Output .= $Self->{LayoutObject}->NavigationBar();

        my %Survey = $Self->{SurveyObject}->SurveyGet(SurveyID=>$SurveyID);

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'SurveyEdit',
            Data => {%Survey},
        );

        my $ValidOnce = $Self->{SurveyObject}->ValidOnce(SurveyID=>$SurveyID);
        my @List=$Self->{SurveyObject}->QuestionList(SurveyID=>$SurveyID);


        if ($ValidOnce eq 'Yes')
        {
            foreach my $Question(@List) {
                $Self->{LayoutObject}->Block(
                    Name => 'SurveyEditQuestionsValidOnce',
                    Data => $Question,
                );
            }
        }
        else
        {
            foreach my $Question(@List) {
                $Self->{LayoutObject}->Block(
                    Name => 'SurveyEditQuestions',
                    Data => $Question,
                );
            }
            $Self->{LayoutObject}->Block(
                Name => 'SurveyEditNewQuestion',
                Data => {},
            );
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurvey',
            Data => {
                %Param,
            }
        );

        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    elsif ($Self->{Subaction} eq 'SurveySave') {
       my $SurveyID           = $Self->{ParamObject}->GetParam(Param => "SurveyID");
       my $SurveyNumber       = $Self->{ParamObject}->GetParam(Param => "SurveyNumber");
       my $SurveyTitle        = $Self->{ParamObject}->GetParam(Param => "SurveyTitle");
       my $SurveyIntroduction = $Self->{ParamObject}->GetParam(Param => "SurveyIntroduction");
       my $SurveyDescription  = $Self->{ParamObject}->GetParam(Param => "SurveyDescription");

       $Self->{SurveyObject}->SurveySave(
                                         SurveyID=>$SurveyID,
                                         SurveyNumber=>$SurveyNumber,
                                         SurveyTitle=>$SurveyTitle,
                                         SurveyIntroduction=>$SurveyIntroduction,
                                         SurveyDescription=>$SurveyDescription,
                                         UserID => $Self->{UserID},
                                         );

       return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=Survey&SurveyID=$SurveyID");
    }

    elsif ($Self->{Subaction} eq 'SurveyAdd') {
        $Output = $Self->{LayoutObject}->Header(Title => 'Survey Add');
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'SurveyAdd',
        );

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurvey',
        );

        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    elsif ($Self->{Subaction} eq 'SurveyNew') {
       my $SurveyNumber       = $Self->{ParamObject}->GetParam(Param => "SurveyNumber");
       my $SurveyTitle        = $Self->{ParamObject}->GetParam(Param => "SurveyTitle");
       my $SurveyIntroduction = $Self->{ParamObject}->GetParam(Param => "SurveyIntroduction");
       my $SurveyDescription  = $Self->{ParamObject}->GetParam(Param => "SurveyDescription");

       my $SurveyID = $Self->{SurveyObject}->SurveyNew(
                                         SurveyNumber=>$SurveyNumber,
                                         SurveyTitle=>$SurveyTitle,
                                         SurveyIntroduction=>$SurveyIntroduction,
                                         SurveyDescription=>$SurveyDescription,
                                         UserID => $Self->{UserID},
                                         );

       return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=Survey&SurveyID=$SurveyID");
    }

    elsif ($Self->{Subaction} eq 'QuestionAdd') {
       my $SurveyID          = $Self->{ParamObject}->GetParam(Param => "SurveyID");
       my $Question          = $Self->{ParamObject}->GetParam(Param => "Question");
       my $QuestionType      = $Self->{ParamObject}->GetParam(Param => "QuestionType");

       if ($Question ne '') {
           $Self->{SurveyObject}->QuestionAdd(
                                         SurveyID=>$SurveyID,
                                         Question=>$Question,
                                         QuestionType=>$QuestionType,
                                         UserID => $Self->{UserID},
                                         );

           $Self->{SurveyObject}->QuestionSort(SurveyID=>$SurveyID);
       }

       return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=SurveyEdit&SurveyID=$SurveyID");
    }

    elsif ($Self->{Subaction} eq 'QuestionDelete') {
       my $QuestionID        = $Self->{ParamObject}->GetParam(Param => "QuestionID");
       my $SurveyID          = $Self->{ParamObject}->GetParam(Param => "SurveyID");

       $Self->{SurveyObject}->QuestionDelete(
                                     SurveyID=>$SurveyID,
                                     QuestionID=>$QuestionID,
                                     );

       $Self->{SurveyObject}->QuestionSort(SurveyID=>$SurveyID);

       return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=SurveyEdit&SurveyID=$SurveyID");
    }

    elsif ($Self->{Subaction} eq 'QuestionUp') {
       my $QuestionID        = $Self->{ParamObject}->GetParam(Param => "QuestionID");
       my $SurveyID          = $Self->{ParamObject}->GetParam(Param => "SurveyID");

       $Self->{SurveyObject}->QuestionSort(SurveyID=>$SurveyID);

       $Self->{SurveyObject}->QuestionUp(
                                     SurveyID=>$SurveyID,
                                     QuestionID=>$QuestionID,
                                     );

       return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=SurveyEdit&SurveyID=$SurveyID");
    }

    elsif ($Self->{Subaction} eq 'QuestionDown') {
       my $QuestionID        = $Self->{ParamObject}->GetParam(Param => "QuestionID");
       my $SurveyID          = $Self->{ParamObject}->GetParam(Param => "SurveyID");

       $Self->{SurveyObject}->QuestionSort(SurveyID=>$SurveyID);

       $Self->{SurveyObject}->QuestionDown(
                                     SurveyID=>$SurveyID,
                                     QuestionID=>$QuestionID,
                                     );

       return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=SurveyEdit&SurveyID=$SurveyID");
    }

    elsif ($Self->{Subaction} eq 'QuestionEdit') {
        my $SurveyID = $Self->{ParamObject}->GetParam(Param => "SurveyID");
        my $QuestionID = $Self->{ParamObject}->GetParam(Param => "QuestionID");

        $Output = $Self->{LayoutObject}->Header(Title => 'Question Edit');
        $Output .= $Self->{LayoutObject}->NavigationBar();

        my %Question=$Self->{SurveyObject}->QuestionGet(QuestionID=>$QuestionID);

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'QuestionEdit',
            Data => {%Question},
        );

        my $ValidOnce = $Self->{SurveyObject}->ValidOnce(SurveyID=>$SurveyID);

        if ($Question{QuestionType} eq 1) {
            $Self->{LayoutObject}->Block(
                Name => 'QuestionEdit1',
            );
        }
        elsif ($Question{QuestionType} eq 2) {
            my @List=$Self->{SurveyObject}->AnswerList(QuestionID=>$QuestionID);

            if ($ValidOnce eq 'Yes')
            {
                foreach my $Answer2(@List) {
                    $Answer2->{SurveyID} = $SurveyID;

                    $Self->{LayoutObject}->Block(
                        Name => 'QuestionEdit2ValidOnce',
                        Data => $Answer2,
                    );
                }
            }
            else
            {
                foreach my $Answer2(@List) {
                    $Answer2->{SurveyID} = $SurveyID;

                    $Self->{LayoutObject}->Block(
                        Name => 'QuestionEdit2',
                        Data => $Answer2,
                    );
                }
                $Self->{LayoutObject}->Block(
                    Name => 'QuestionEdit2b',
                );
            }
        }
        elsif ($Question{QuestionType} eq 3) {
            my @List=$Self->{SurveyObject}->AnswerList(QuestionID=>$QuestionID);

            if ($ValidOnce eq 'Yes')
            {
                foreach my $Answer3(@List) {
                    $Answer3->{SurveyID} = $SurveyID;

                    $Self->{LayoutObject}->Block(
                        Name => 'QuestionEdit3ValidOnce',
                        Data => $Answer3,
                    );
                }
            }
            else
            {
                foreach my $Answer3(@List) {
                    $Answer3->{SurveyID} = $SurveyID;

                    $Self->{LayoutObject}->Block(
                        Name => 'QuestionEdit3',
                        Data => $Answer3,
                    );
                }
                $Self->{LayoutObject}->Block(
                    Name => 'QuestionEdit3b',
                );
            }
        }
        elsif ($Question{QuestionType} eq 4) {
            $Self->{LayoutObject}->Block(
                Name => 'QuestionEdit4',
            );
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurvey',
            Data => {
                %Param,
            }
        );

        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    elsif ($Self->{Subaction} eq 'QuestionSave') {
       my $QuestionID        = $Self->{ParamObject}->GetParam(Param => "QuestionID");
       my $SurveyID          = $Self->{ParamObject}->GetParam(Param => "SurveyID");
       my $Question          = $Self->{ParamObject}->GetParam(Param => "Question");

       $Self->{SurveyObject}->QuestionSave(
                                         QuestionID=>$QuestionID,
                                         SurveyID=>$SurveyID,
                                         Question=>$Question,
                                         UserID => $Self->{UserID},
                                         );

       return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=SurveyEdit&SurveyID=$SurveyID");
    }

    elsif ($Self->{Subaction} eq 'AnswerAdd') {
       my $SurveyID          = $Self->{ParamObject}->GetParam(Param => "SurveyID");
       my $QuestionID        = $Self->{ParamObject}->GetParam(Param => "QuestionID");
       my $Answer            = $Self->{ParamObject}->GetParam(Param => "Answer");

       if ($Answer ne '') {
           $Self->{SurveyObject}->AnswerAdd(
                                         SurveyID=>$SurveyID,
                                         QuestionID=>$QuestionID,
                                         Answer=>$Answer,
                                         UserID => $Self->{UserID},
                                         );

           $Self->{SurveyObject}->AnswerSort(QuestionID=>$QuestionID);
       }

       return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=QuestionEdit&SurveyID=$SurveyID&QuestionID=$QuestionID");
    }

    elsif ($Self->{Subaction} eq 'AnswerDelete') {
       my $AnswerID          = $Self->{ParamObject}->GetParam(Param => "AnswerID");
       my $QuestionID        = $Self->{ParamObject}->GetParam(Param => "QuestionID");
       my $SurveyID          = $Self->{ParamObject}->GetParam(Param => "SurveyID");

       $Self->{SurveyObject}->AnswerDelete(
                                     QuestionID=>$QuestionID,
                                     AnswerID=>$AnswerID,
                                     );

       $Self->{SurveyObject}->AnswerSort(QuestionID=>$QuestionID);

       return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=QuestionEdit&SurveyID=$SurveyID&QuestionID=$QuestionID");
    }

    elsif ($Self->{Subaction} eq 'AnswerUp') {
       my $AnswerID          = $Self->{ParamObject}->GetParam(Param => "AnswerID");
       my $QuestionID        = $Self->{ParamObject}->GetParam(Param => "QuestionID");
       my $SurveyID          = $Self->{ParamObject}->GetParam(Param => "SurveyID");

       $Self->{SurveyObject}->AnswerSort(QuestionID=>$QuestionID);

       $Self->{SurveyObject}->AnswerUp(
                                     QuestionID=>$QuestionID,
                                     AnswerID=>$AnswerID,
                                     );

       return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=QuestionEdit&SurveyID=$SurveyID&QuestionID=$QuestionID");
    }

    elsif ($Self->{Subaction} eq 'AnswerDown') {
       my $AnswerID          = $Self->{ParamObject}->GetParam(Param => "AnswerID");
       my $QuestionID        = $Self->{ParamObject}->GetParam(Param => "QuestionID");
       my $SurveyID          = $Self->{ParamObject}->GetParam(Param => "SurveyID");

       $Self->{SurveyObject}->AnswerSort(QuestionID=>$QuestionID);

       $Self->{SurveyObject}->AnswerDown(
                                     QuestionID=>$QuestionID,
                                     AnswerID=>$AnswerID,
                                     );

       return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=QuestionEdit&SurveyID=$SurveyID&QuestionID=$QuestionID");
    }

    elsif ($Self->{Subaction} eq 'AnswerEdit') {
        my $SurveyID = $Self->{ParamObject}->GetParam(Param => "SurveyID");
        my $QuestionID = $Self->{ParamObject}->GetParam(Param => "QuestionID");
        my $AnswerID = $Self->{ParamObject}->GetParam(Param => "AnswerID");

        $Output = $Self->{LayoutObject}->Header(Title => 'Answer Edit');
        $Output .= $Self->{LayoutObject}->NavigationBar();

        my %Answer=$Self->{SurveyObject}->AnswerGet(AnswerID=>$AnswerID);
        $Answer{SurveyID} = $SurveyID;

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'AnswerEdit',
            Data => {%Answer},
        );

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurvey',
            Data => {
                %Param,
            }
        );

        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    elsif ($Self->{Subaction} eq 'AnswerSave') {
       my $AnswerID          = $Self->{ParamObject}->GetParam(Param => "AnswerID");
       my $QuestionID        = $Self->{ParamObject}->GetParam(Param => "QuestionID");
       my $SurveyID          = $Self->{ParamObject}->GetParam(Param => "SurveyID");
       my $Answer            = $Self->{ParamObject}->GetParam(Param => "Answer");

       $Self->{SurveyObject}->AnswerSave(
                                         AnswerID=>$AnswerID,
                                         QuestionID=>$QuestionID,
                                         Answer=>$Answer,
                                         UserID => $Self->{UserID},
                                         );

       return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=QuestionEdit&SurveyID=$SurveyID&QuestionID=$QuestionID");
    }

    elsif ($Self->{Subaction} eq 'StatsOverview') {
        my $SurveyID = $Self->{ParamObject}->GetParam(Param => "SurveyID");

        $Output = $Self->{LayoutObject}->Header(Title => 'Stats Overview');
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'StatsOverview',
            Data => {SurveyID=>$SurveyID},
        );

        my @List=$Self->{SurveyObject}->VoteList(SurveyID=>$SurveyID);

        foreach my $Vote(@List) {
            $Vote->{SurveyID} = $SurveyID;

            $Self->{LayoutObject}->Block(
                Name => 'StatsOverviewVote',
                Data => $Vote,
            );
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurvey',
            Data => {
                %Param,
            }
        );

        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    elsif ($Self->{Subaction} eq 'StatsDetail') {
        my $SurveyID = $Self->{ParamObject}->GetParam(Param => "SurveyID");
        my $RequestID = $Self->{ParamObject}->GetParam(Param => "RequestID");

        $Output = $Self->{LayoutObject}->Header(Title => 'Stats Detail');
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'StatsDetail',
            Data => {SurveyID=>$SurveyID},
        );

        my @QuestionList=$Self->{SurveyObject}->QuestionList(SurveyID=>$SurveyID);

        foreach my $Question(@QuestionList) {
           $Self->{LayoutObject}->Block(
                Name => 'StatsDetailQuestion',
                Data => $Question,
           );

           my @Answers = ();

           if ($Question->{QuestionType} eq '2' || $Question->{QuestionType} eq '3' ) {
               my @AnswerList = ();

               @AnswerList = $Self->{SurveyObject}->VoteGet(RequestID=>$RequestID, QuestionID=>$Question->{QuestionID});

               foreach my $Row(@AnswerList) {
                   my %Answer = $Self->{SurveyObject}->AnswerGet(AnswerID=>$Row->{VoteValue});
                   my %Data = ();
                   $Data{Answer} = $Answer{Answer};

                   push(@Answers,\%Data);
               }
            }
            elsif ($Question->{QuestionType} eq '1' || $Question->{QuestionType} eq '4' ) {
                my @List = $Self->{SurveyObject}->VoteGet(RequestID=>$RequestID, QuestionID=>$Question->{QuestionID});
                my %Data = ();

                $Data{Answer} = $List[0]->{VoteValue};

                push(@Answers,\%Data);
            }

            foreach my $Row(@Answers) {
                $Self->{LayoutObject}->Block(
                    Name => 'StatsDetailAnswer',
                    Data => $Row,
                );
            }
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurvey',
            Data => {
                %Param,
            }
        );

        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # show overview
    # ------------------------------------------------------------ #

    $Output = $Self->{LayoutObject}->Header(Title => 'Overview');
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # print the main table.
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => { },
    );
    my @List=$Self->{SurveyObject}->SurveyList();

    foreach my $Survey(@List) {
       $Self->{LayoutObject}->Block(
           Name => 'OverviewSurvey',
           Data => $Survey,
        );
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentSurvey',
        Data => {
            %Param,
        }
    );

    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
