# --
# Kernel/Modules/PublicSurvey.pm - a survey module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

    my %Answers;
    my %Errors;
    my @QuestionList;

    # ------------------------------------------------------------ #
    # public survey vote
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'PublicSurveyVote' ) {
        my $PublicSurveyKey = $Self->{ParamObject}->GetParam( Param => 'PublicSurveyKey' );
        my %Survey = $Self->{SurveyObject}->PublicSurveyGet( PublicSurveyKey => $PublicSurveyKey );
        if ( $Survey{SurveyID} ) {
            @QuestionList = $Self->{SurveyObject}->QuestionList( SurveyID => $Survey{SurveyID} );

            for my $Question (@QuestionList) {
                if ( $Question->{Type} eq 'YesNo' ) {
                    my $PublicSurveyVote1 = $Self->{ParamObject}->GetParam(
                        Param => "PublicSurveyVote1[$Question->{QuestionID}]"
                    );

                    if (
                        $Question->{AnswerRequired}
                        &&
                        ( !$PublicSurveyVote1 || !length $PublicSurveyVote1 )
                        )
                    {
                        $Errors{ $Question->{QuestionID} }{'Answer required'} = 1;
                    }

                    $Answers{ $Question->{QuestionID} } = $PublicSurveyVote1;
                }
                elsif ( $Question->{Type} eq 'Radio' ) {
                    my $PublicSurveyVote2 = $Self->{ParamObject}->GetParam(
                        Param => "PublicSurveyVote2[$Question->{QuestionID}]"
                    );

                    if (
                        $Question->{AnswerRequired}
                        && ( !$PublicSurveyVote2 || !length $PublicSurveyVote2 )
                        )
                    {
                        $Errors{ $Question->{QuestionID} }{'Answer required'} = 1;
                    }

                    $Answers{ $Question->{QuestionID} } = $PublicSurveyVote2;
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
                            push @{ $Answers{ $Question->{QuestionID} } }, $Answer->{AnswerID};
                        }
                    }
                    if (
                        $Question->{AnswerRequired}
                        && (
                            !defined $Answers{ $Question->{QuestionID} }
                            || (
                                ref $Answers{ $Question->{QuestionID} } ne 'ARRAY'
                                && !@{ $Answers{ $Question->{QuestionID} } }
                            )
                        )
                        )
                    {
                        $Errors{ $Question->{QuestionID} }{'Answer required'} = 1;
                    }
                }
                elsif ( $Question->{Type} eq 'Textarea' ) {
                    my $PublicSurveyVote4 = $Self->{ParamObject}->GetParam(
                        Param => "PublicSurveyVote4[$Question->{QuestionID}]"
                    );

                    # check if rich text is enabled
                    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                        $PublicSurveyVote4
                            = ( length $PublicSurveyVote4 )
                            ? "\$html/text\$ $PublicSurveyVote4"
                            : '';
                    }
                    if (
                        $Question->{AnswerRequired}
                        &&
                        ( !$PublicSurveyVote4 || !length $PublicSurveyVote4 )
                        )
                    {
                        $Errors{ $Question->{QuestionID} }{'Answer required'} = 1;
                    }
                    $Answers{ $Question->{QuestionID} } = $PublicSurveyVote4;
                }
            }

            # If we didn't have errors, just save the answers
            if ( !scalar keys %Errors ) {
                for my $Question (@QuestionList) {
                    if ( $Question->{Type} eq 'YesNo' ) {
                        $Self->{SurveyObject}->PublicAnswerSet(
                            PublicSurveyKey => $PublicSurveyKey,
                            QuestionID      => $Question->{QuestionID},
                            VoteValue       => $Answers{ $Question->{QuestionID} },
                        );
                    }
                    elsif ( $Question->{Type} eq 'Radio' ) {
                        $Self->{SurveyObject}->PublicAnswerSet(
                            PublicSurveyKey => $PublicSurveyKey,
                            QuestionID      => $Question->{QuestionID},
                            VoteValue       => $Answers{ $Question->{QuestionID} },
                        );
                    }
                    elsif ( $Question->{Type} eq 'Checkbox' ) {
                        my @AnswerList = $Self->{SurveyObject}->AnswerList(
                            QuestionID => $Question->{QuestionID}
                        );
                        if (
                            $Answers{ $Question->{QuestionID} }
                            && ref $Answers{ $Question->{QuestionID} } eq 'ARRAY'
                            && @{ $Answers{ $Question->{QuestionID} } }
                            )
                        {
                            for my $Answer ( @{ $Answers{ $Question->{QuestionID} } } ) {
                                $Self->{SurveyObject}->PublicAnswerSet(
                                    PublicSurveyKey => $PublicSurveyKey,
                                    QuestionID      => $Question->{QuestionID},
                                    VoteValue       => $Answer,
                                );
                            }
                        }
                    }
                    elsif ( $Question->{Type} eq 'Textarea' ) {
                        $Self->{SurveyObject}->PublicAnswerSet(
                            PublicSurveyKey => $PublicSurveyKey,
                            QuestionID      => $Question->{QuestionID},
                            VoteValue       => $Answers{ $Question->{QuestionID} },
                        );
                    }
                }
                $Self->{SurveyObject}
                    ->PublicSurveyInvalidSet( PublicSurveyKey => $PublicSurveyKey );
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
        }
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

            my $HTMLContent = $1;
            if ( !$HTMLContent ) {
                $Survey{Introduction} = $Self->{LayoutObject}->Ascii2Html(
                    Text           => $Survey{Introduction},
                    HTMLResultMode => 1,
                );
            }
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

            my $RequiredText = '';
            if ( $Question->{AnswerRequired} ) {
                $Class .= ' Mandatory';
                $RequiredText = '* ';
            }

            $Self->{LayoutObject}->Block(
                Name => 'PublicSurveyVoteQuestion',
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

                    if ($1) {
                        $Data{Answer} =
                            $Self->{HTMLUtilsObject}->ToAscii( String => $Data{Answer} );
                    }
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
        my $HTMLContent = $1;
        if ( !$HTMLContent ) {
            $Survey{Introduction} = $Self->{LayoutObject}->Ascii2Html(
                Text           => $Survey{Introduction},
                HTMLResultMode => 1,
            );
        }
        $Self->{LayoutObject}->Block(
            Name => 'PublicSurvey',
            Data => {%Survey},
        );

        # If we had errors, @QuestionList is already filled, so let's save a SQL query
        if ( !@QuestionList ) {
            @QuestionList = $Self->{SurveyObject}->QuestionList( SurveyID => $Survey{SurveyID} );
        }

        for my $Question (@QuestionList) {

            $Self->{LayoutObject}->Block( Name => 'PublicQuestions' );

            my $Class        = '';
            my $RequiredText = '';
            my $ErrorText;
            if ( $Question->{AnswerRequired} ) {
                $Class .= 'Mandatory';
                $RequiredText = '* ';

            }
            if (
                $Errors{ $Question->{QuestionID} }
                && ref $Errors{ $Question->{QuestionID} } eq 'HASH'
                )
            {

                # %Errors holds a key for each QuestionID that had errors.
                # The value is a hashref who's keys are the ErrorType
                # The value is set to 1
                # Reason for this is, that the value may be used to display
                # a more specific Error Message containing text question specific error messages
                # or similar. So a type specific error message treatment would be possible here.

                # At the time of creation the only error type was 'Answer required'.
                # So a data structure looks like this:
                # %Errors = (
                #   1 => {
                #        'Answer required' => 1,
                #   },
                #   2 => {
                #        'Answer required' => 1,
                #    },
                # );

             # Later on a Datastructure like the following would be possible:
             # %Errors = (
             #   1 => {
             #        'Invalid text' => 'Your Text did not contain the Order number',
             #   },
             #   2 => {
             #        'Answer required' => 1,
             #    },
             # );
             # As soon as this is needed, the following $ErrorText stringbuilding has to be changed.

                # The stringbuilding works at the moment this way:
                # 1. Go through all keys of the %{ $Errors{ $Question->{QuestionID} } } hash
                # 2. Do a translation for each key (inside the "map {}"-clause)
                # 3. join the resulting Array by putting "</p>\n</p>" in between the Arraykeys
                # 4. add '<p>' at the beginning and '</p>' at the end.

                $ErrorText = '<p>'
                    . (
                    join "</p>\n<p>",
                    map { $Self->{LayoutObject}->{LanguageObject}->Get($_) }
                        keys %{ $Errors{ $Question->{QuestionID} } }
                    )
                    . '</p>';

                $ErrorText = <<END;
                <div class="TooltipError">
                <div class="Tooltip TongueLeft">
                    <div class="Tongue" ></div>
                    <div class="Content" role="tooltip" style="word-wrap: break-word;">
                            $ErrorText
                    </div>
                </div>
                </div>
END
                $Class .= ' Error';
            }

            if ( $Question->{Type} eq 'YesNo' ) {

                my %Selected = (
                    YesSelected => (
                        defined $Answers{ $Question->{QuestionID} }
                            && $Answers{ $Question->{QuestionID} } eq 'Yes'
                        )
                    ? 'checked="checked"'
                    : '',
                    NoSelected => (
                        defined $Answers{ $Question->{QuestionID} }
                            && $Answers{ $Question->{QuestionID} } eq 'No'
                        )
                    ? 'checked="checked"'
                    : '',
                );

                $Self->{LayoutObject}->Block(
                    Name => 'PublicAnswerYesNo',
                    Data => {
                        %{$Question},
                        %Selected,
                        ErrorText => $ErrorText || '',
                        Class => $Class,
                        RequiredText => $RequiredText,
                        }
                );
            }
            elsif ( $Question->{Type} eq 'Radio' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'PublicAnswerRadio',
                    Data => {
                        %{$Question},
                        ErrorText => $ErrorText || '',
                        Class => $Class,
                        RequiredText => $RequiredText,
                        }
                );
                my @AnswerList = $Self->{SurveyObject}->AnswerList(
                    QuestionID => $Question->{QuestionID},
                );
                for my $Answer (@AnswerList) {

                    my $Selected = '';
                    if (
                        defined $Answers{ $Question->{QuestionID} }
                        && $Answers{ $Question->{QuestionID} } eq $Answer->{AnswerID}
                        )
                    {
                        $Selected = 'checked="checked"';
                    }
                    $Self->{LayoutObject}->Block(
                        Name => 'PublicAnswerRadiob',
                        Data => {
                            %{$Answer},
                            AnswerSelected => $Selected,
                        },
                    );
                }
            }
            elsif ( $Question->{Type} eq 'Checkbox' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'PublicAnswerCheckbox',
                    Data => {
                        %{$Question},
                        ErrorText => $ErrorText || '',
                        Class => $Class,
                        RequiredText => $RequiredText,
                        }
                );
                my @AnswerList = $Self->{SurveyObject}->AnswerList(
                    QuestionID => $Question->{QuestionID},
                );
                for my $Answer (@AnswerList) {
                    my $Selected = '';
                    if (
                        defined $Answers{ $Question->{QuestionID} }
                        && ref $Answers{ $Question->{QuestionID} } eq 'ARRAY'
                        && @{ $Answers{ $Question->{QuestionID} } }
                        && scalar grep { $_ eq $Answer->{AnswerID} }
                        @{ $Answers{ $Question->{QuestionID} } }
                        )
                    {
                        $Selected = 'checked="checked"';
                    }
                    $Self->{LayoutObject}->Block(
                        Name => 'PublicAnswerCheckboxb',
                        Data => {
                            %{$Answer},
                            AnswerSelected => $Selected,
                        },
                    );
                }
            }
            elsif ( $Question->{Type} eq 'Textarea' ) {
                my $Value = $Answers{ $Question->{QuestionID} } || '';
                $Value =~ s/^\$html\/text\$\s//;
                $Self->{LayoutObject}->Block(
                    Name => 'PublicAnswerTextarea',
                    Data => {
                        %{$Question},
                        ErrorText => $ErrorText || '',
                        Class => $Class,
                        RequiredText => $RequiredText,
                        Value        => $Value,
                        }
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
