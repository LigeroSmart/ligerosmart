# --
# Kernel/Modules/PublicSurvey.pm - a survey module
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: PublicSurvey.pm,v 1.21 2011-01-11 20:01:09 dz Exp $
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
$VERSION = qw($Revision: 1.21 $) [1];

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
        $Self->{LayoutObject}->Block(
            Name => 'PublicSurveyMessage',
            Data => {
                MessageType   => 'Information',
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
            Name => 'PublicSurveyMessage',
            Data => {
                MessageType   => 'Information',
                MessageHeader => 'Thank you for your feedback.',
                Message       => 'You have already answered the survey.',
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
            Name => 'PublicSurveyMessage',
            Data => {
                MessageType   => 'Error!',
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

sub _MaskShowSurvey {
    my ( $Self, %Param ) = @_;

    my %ServerError;
    if ( $Param{ServerError} ) {
        %ServerError = %{ $Param{ServerError} };
    }

    my %FormElements;
    if ( $Param{FormElements} ) {
        %FormElements = %{ $Param{FormElements} };
    }

    my $Output;

    # if SurveyID the SurveyEdit should be loaded (popup)
    my $Title;
    my $Type;
    if ( $Param{SurveyID} ) {
        $Title = 'Survey Edit';

        # for header and footer
        $Type = 'Small';
    }
    else {
        $Title = 'Add New Survey';
    }

    $Output .= $Self->{LayoutObject}->Header(
        Title => $Title,
        Type  => $Type,
    );

    my $SelectedQueues;
    if ( !$Param{SurveyID} ) {
        $Output .= $Self->{LayoutObject}->NavigationBar();

    }
    else {
        my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $Param{SurveyID} );

        # get selected queues
        $SelectedQueues = $Survey{Queues};
    }

    my %Queues      = $Self->{QueueObject}->GetAllQueues();
    my $QueueString = $Self->{LayoutObject}->BuildSelection(
        Data         => \%Queues,
        Name         => 'Queues',
        Size         => 6,
        Multiple     => 1,
        PossibleNone => 0,
        Sort         => 'AlphanumericValue',
        Translation  => 0,
        SelectedID   => $FormElements{Queues} || $SelectedQueues,
    );

    my $Block;
    if ( !$Param{SurveyID} ) {
        $Block = 'SurveyAdd';
    }
    else {
        $Block = 'SurveyEdit';
    }

    # print the form
    $Self->{LayoutObject}->Block(
        Name => $Block,
        Data => {
            %Param,
            QueueString        => $QueueString,
            NotificationSender => $FormElements{NotificationSender}
                || $Self->{ConfigObject}->Get('Survey::NotificationSender'),
            NotificationSubject => $FormElements{NotificationSubject}
                || $Self->{ConfigObject}->Get('Survey::NotificationSubject'),
            NotificationBody => $FormElements{NotificationBody}
                || $Self->{ConfigObject}->Get('Survey::NotificationBody'),
            %ServerError,
            %FormElements,
        },
    );

    # generates generic errors for javascript
    for my $NeededItem (
        qw( Title Introduction Description NotificationSender NotificationSubject NotificationBody )
        )
    {
        $Self->{LayoutObject}->Block(
            Name => $Block . 'GenericError',
            Data => {
                ItemName => $NeededItem . 'Error',
            },
        );
    }

    for my $Item ( keys %ServerError ) {
        $Self->{LayoutObject}->Block(
            Name => $Block . 'GenericServerError',
            Data => {
                ItemName => $Item,
            },
        );
    }

    $Output .= $Self->{LayoutObject}->Output( TemplateFile => 'AgentSurvey' );
    $Output .= $Self->{LayoutObject}->Footer( Type => $Type );

    return $Output;
}

1;
