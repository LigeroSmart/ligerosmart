# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentSurveyStats;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common objects
    %{$Self} = %Param;

    # get config of frontend module
    $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get("Survey::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # get needed object
    my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');

    my $SurveyID  = $ParamObject->GetParam( Param => "SurveyID" )  || '';
    my $RequestID = $ParamObject->GetParam( Param => "RequestID" ) || '';

    my $SurveyExists = 'no';
    if ($SurveyID) {
        $SurveyExists = $SurveyObject->ElementExists(
            ElementID => $SurveyID,
            Element   => 'Survey'
        );
    }

    my $RequestExists = 'no';
    if ($RequestID) {
        $RequestExists = $SurveyObject->ElementExists(
            ElementID => $RequestID,
            Element   => 'Request'
        );
    }

    # ------------------------------------------------------------ #
    # stats
    # ------------------------------------------------------------ #
    if ( !$Self->{Subaction} ) {

        # check if survey exists
        if ( $SurveyExists ne 'Yes' ) {

            return $LayoutObject->NoPermission(
                Message    => Translatable('You have no permission for this survey!'),
                WithHeader => 'yes',
            );
        }
        $Output = $LayoutObject->Header(
            Title     => Translatable('Stats Overview'),
            Type      => 'Small',
            BodyClass => 'Popup',
        );

        my %Survey = $SurveyObject->SurveyGet(
            SurveyID => $SurveyID,
        );

        # get config of AgentSurveyStats
        my $ShowDeleteArray = $Kernel::OM->Get('Kernel::Config')->Get('SurveyStats::ShowDelete');
        my $ShowDelete      = 0;

        if ( IsArrayRefWithData($ShowDeleteArray) ) {

            # get user groups, where the user has the rw privilege
            my %Groups = $GroupObject->PermissionUserGet(
                UserID => $Self->{UserID},
                Type   => 'rw',
            );

            # reverse groups
            %Groups = reverse %Groups;

            if ( grep { $Groups{$_} } @{$ShowDeleteArray} ) {
                $ShowDelete = 1;
            }
        }

        # print the main table.
        $LayoutObject->Block(
            Name => 'Stats',
            Data => {
                %Survey,
                ShowDelete => $ShowDelete,
            }
        );
        my @List = $SurveyObject->VoteList(
            SurveyID => $SurveyID,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my $Count     = 0;
        my $LastIndex = scalar @List - 1;

        for my $Vote (@List) {
            my $CountPlus  = $Count + 1;
            my $CountMinus = $Count - 1;
            if ( $Count != 0 ) {
                $Vote->{Prev} = $List[$CountMinus]->{RequestID};
            }
            if ( $Count != $LastIndex ) {
                $Vote->{Next} = $List[$CountPlus]->{RequestID};
            }
            $Vote->{SurveyID} = $SurveyID;
            my %Ticket = $TicketObject->TicketGet(
                TicketID => $Vote->{TicketID},
            );
            $Vote->{TicketNumber} = $Ticket{TicketNumber};
            $Vote->{ShowDelete}   = $ShowDelete;
            $LayoutObject->Block(
                Name => 'StatsVote',
                Data => $Vote,
            );
            $Count++;
        }

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentSurveyStats',
            Data         => {%Param},
        );

        $Output .= $LayoutObject->Footer(
            Type => 'Small',
        );

        return $Output;
    }

    # ------------------------------------------------------------ #
    # stats details
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'StatsDetail' ) {
        my $TicketNumber = $ParamObject->GetParam( Param => "TicketNumber" );

        my ( $Prev, $Next, %Results );

        # check if survey exists
        if ( $SurveyExists ne 'Yes' || $RequestExists ne 'Yes' ) {

            return $LayoutObject->NoPermission(
                Message    => Translatable('You have no permission for this survey or stats detail!'),
                WithHeader => 'yes',
            );
        }
        $Output = $LayoutObject->Header(
            Title     => Translatable('Stats Detail'),
            Type      => 'Small',
            BodyClass => 'Popup',
        );

        my %Survey = $SurveyObject->SurveyGet(
            SurveyID => $SurveyID,
        );

        # print the main table.
        $LayoutObject->Block(
            Name => 'StatsDetail',
            Data => {
                %Survey,
                TicketNumber => $TicketNumber,
            },
        );

        # Get Survey vote list.
        my @List = $SurveyObject->VoteList(
            SurveyID => $SurveyID,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Get parameters for url (previous and next vote and their ticket number).
        my $Count     = 0;
        my $LastIndex = scalar @List - 1;

        for my $ResultVote (@List) {

            #Finds vote that is viewed.
            if ( $ResultVote->{RequestID} == $RequestID ) {
                my $CountPlus  = $Count + 1;
                my $CountMinus = $Count - 1;

                my %Ticket = $TicketObject->TicketGet(
                    TicketID => $ResultVote->{TicketID},
                );
                $Results{TicketNumber} = $Ticket{TicketNumber};

                if ( $Count != 0 ) {
                    $Prev ? $Results{Prev} = $Prev : $Results{Prev} = $List[$CountMinus]->{RequestID};
                    $Results{PrevTicketNumber} = $TicketObject->TicketNumberLookup(
                        TicketID => $List[$CountMinus]->{TicketID},
                    );
                }
                if ( $Count != $LastIndex ) {
                    $Next ? $Results{Next} = $Next : $Results{Next} = $List[$CountPlus]->{RequestID};
                    $Results{NextTicketNumber} = $TicketObject->TicketNumberLookup(
                        TicketID => $List[$CountPlus]->{TicketID},
                    );
                }
            }
            $Count++;
        }

        $LayoutObject->Block(
            Name => 'NavArrows',
            Data => {
                SurveyID => $SurveyID,
                %Results,
            },
        );

        my @QuestionList = $SurveyObject->QuestionList(
            SurveyID => $SurveyID,
        );
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

            $LayoutObject->Block(
                Name => 'StatsDetailQuestion',
                Data => {
                    %{$Question},
                    Class        => $Class,
                    RequiredText => $RequiredText,
                },
            );
            my @Answers;
            if ( $Question->{Type} eq 'Radio' || $Question->{Type} eq 'Checkbox' || $Question->{Type} eq 'NPS' ) {
                my @AnswerList;
                @AnswerList = $SurveyObject->VoteGet(
                    RequestID  => $RequestID,
                    QuestionID => $Question->{QuestionID},
                );
                for my $Row (@AnswerList) {
                    my %Answer = $SurveyObject->AnswerGet(
                        AnswerID => $Row->{VoteValue},
                    );
                    my %Data;
                    $Data{Answer} = $Answer{Answer};
                    push( @Answers, \%Data );
                }
            }
            elsif ( $Question->{Type} eq 'YesNo' || $Question->{Type} eq 'Textarea' ) {
                my @List = $SurveyObject->VoteGet(
                    RequestID  => $RequestID,
                    QuestionID => $Question->{QuestionID},
                );

                my %Data;
                $Data{Answer} = $List[0]->{VoteValue};

                # clean HTML
                if ( $Question->{Type} eq 'Textarea' && $Data{Answer} ) {
                    $Data{Answer} =~ s{\A\$html\/text\$\s(.*)}{$1}xms;
                    $Data{Answer} = $LayoutObject->Ascii2Html(
                        Text           => $Data{Answer},
                        HTMLResultMode => 1,
                    );
                    $Data{Answer} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
                        String => $Data{Answer},
                    );
                }
                push( @Answers, \%Data );
            }
            for my $Row (@Answers) {
                $LayoutObject->Block(
                    Name => 'StatsDetailAnswer',
                    Data => {
                        %{$Row},
                        Class => $Class,
                    },
                );
            }
        }
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentSurveyStats',
            Data         => {%Param},
        );
        $Output .= $LayoutObject->Footer(
            Type => 'Small',
        );

        return $Output;
    }
    elsif ( $Self->{Subaction} eq 'StatsView' ) {

        if ( $ParamObject->GetParam( Param => 'SubmitDelete' ) ) {

            # get survey id
            my $SurveyID = $ParamObject->GetParam( Param => 'SurveyID' );

            # get the stats delete keys and target object
            my @RequestDeleteIdentifier = $ParamObject->GetArray(
                Param => 'RequestDeleteIdentifier',
            );

            # delete vote data and request from database
            for my $RequestID (@RequestDeleteIdentifier) {

                # delete vote data
                my $VoteDelete = $SurveyObject->VoteDelete(
                    RequestID => $RequestID,
                );

                # delete request
                my $RequestDelete = $SurveyObject->RequestDelete(
                    RequestID => $RequestID,
                );
            }

            # redirect to survey stats
            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action};SurveyID=$SurveyID",
            );
        }
    }
}

1;
