# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::MiscLigero::SurveyVote;

use strict;
use warnings;

use Kernel::System::VariableCheck qw( :all );

use base qw(
    Kernel::GenericInterface::Operation::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::TicketLigero::StateSearch - GenericInterface Queues List

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(DebuggerObject WebserviceID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!",
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # get config for this screen
    #$Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Operation::GeneralCatalogGetValues');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my ( $UserID, $UserType ) = $Self->Auth(
        %Param,
    );

    my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');

    return $Self->ReturnError(
        ErrorCode    => 'GeneralCatalogGetValues.AuthFail',
        ErrorMessage => "GeneralCatalogGetValues: Authorization failing!",
    ) if !$UserID;

    for my $Needed (qw( SurveyID PublicSurveyKey Answers )) {
        if ( !$Param{Data}->{$Needed} ) {

            return $Self->ReturnError(
                ErrorCode    => 'SessionCreate.MissingParameter',
                ErrorMessage => "SessionCreate: $Needed parameter is missing!",
            );
        }
    }

    my @QuestionList = $SurveyObject->QuestionList(
        SurveyID => $Param{Data}->{SurveyID},
    );

    #Valid Answers
    VALID_ANSWER:
    foreach my $quest (@QuestionList){
        if($quest->{AnswerRequired} == 0 && !$Param{Data}->{Answers}->{$quest->{QuestionID}}){
            next VALID_ANSWER;
        }

        return $Self->ReturnError(
            ErrorCode    => 'GeneralCatalogGetValues.RequiredAnswer',
            ErrorMessage => "GeneralCatalogGetValues: Answer for QuestionID $quest->{QuestionID} is required!",
        ) if $quest->{AnswerRequired} == 1 && !$Param{Data}->{Answers}->{$quest->{QuestionID}};

        if($quest->{Type} eq 'YesNo'){
            return $Self->ReturnError(
                ErrorCode    => 'GeneralCatalogGetValues.WrongAnswer',
                ErrorMessage => "GeneralCatalogGetValues: Answer for QuestionID $quest->{QuestionID} is wrong! Just 'Yes' or 'No' is accepted! Value sent $Param{Data}->{Answers}->{$quest->{QuestionID}}.",
            ) if $Param{Data}->{Answers}->{$quest->{QuestionID}} ne 'Yes' && $Param{Data}->{Answers}->{$quest->{QuestionID}} ne 'No';
        }

        if($quest->{Type} eq 'Radio'){
            my @AnswerList = $SurveyObject->AnswerList(
                QuestionID => $quest->{QuestionID},
            );

            my $exists = 0;

            foreach my $ans (@AnswerList){
                if($Param{Data}->{Answers}->{$quest->{QuestionID}} eq $ans->{Answer}){
                    $exists = 1;
                }
            }

            return $Self->ReturnError(
                ErrorCode    => 'GeneralCatalogGetValues.RequiredWrongAnswer',
                ErrorMessage => "GeneralCatalogGetValues: Answer for QuestionID $quest->{QuestionID} is wrong! Check options are accepted!",
            ) if !$exists;

        }

        if($quest->{Type} eq 'Checkbox'){

            return $Self->ReturnError(
                ErrorCode    => 'GeneralCatalogGetValues.RequiredWrongAnswer',
                ErrorMessage => "GeneralCatalogGetValues: Answer for QuestionID $quest->{QuestionID} is wrong! Checkbox needs a Array value.",
            ) if ref $Param{Data}->{Answers}->{$quest->{QuestionID}} ne 'ARRAY';

            my @AnswerList = $SurveyObject->AnswerList(
                QuestionID => $quest->{QuestionID},
            );

            for my $Answer ( @{ $Param{Data}->{Answers}->{$quest->{QuestionID}} } ) {
                my $exists = 0;

                foreach my $ans (@AnswerList){
                    if($Answer eq $ans->{Answer}){
                        $exists = 1;
                    }
                }

                return $Self->ReturnError(
                    ErrorCode    => 'GeneralCatalogGetValues.RequiredWrongAnswer',
                    ErrorMessage => "GeneralCatalogGetValues: Answer for QuestionID $quest->{QuestionID} is wrong! Check options are accepted! Value sent $Answer.",
                ) if !$exists;
            }

        }
    }

    SAVE:
    foreach my $Question (@QuestionList){
        my $PublicSurveyKey = $Param{Data}->{PublicSurveyKey};
        my $Answers = $Param{Data}->{Answers};

        if($Question->{AnswerRequired} == 0 && !$Param{Data}->{Answers}->{$Question->{QuestionID}}){
            next SAVE;
        }
        
        if ( $Question->{Type} eq 'YesNo' ) {
            $SurveyObject->PublicAnswerSet(
                PublicSurveyKey => $PublicSurveyKey,
                QuestionID      => $Question->{QuestionID},
                VoteValue       => $Answers->{ $Question->{QuestionID} },
            );
        }
        elsif ( $Question->{Type} eq 'Radio' ) {
            $SurveyObject->PublicAnswerSet(
                PublicSurveyKey => $PublicSurveyKey,
                QuestionID      => $Question->{QuestionID},
                VoteValue       => $Answers->{ $Question->{QuestionID} },
            );
        }
        elsif ( $Question->{Type} eq 'Checkbox' ) {
            my @AnswerList = $SurveyObject->AnswerList(
                QuestionID => $Question->{QuestionID}
            );
            if (
                $Answers->{ $Question->{QuestionID} }
                && ref $Answers->{ $Question->{QuestionID} } eq 'ARRAY'
                && @{ $Answers->{ $Question->{QuestionID} } }
                )
            {
                for my $Answer ( @{ $Answers->{ $Question->{QuestionID} } } ) {
                    $SurveyObject->PublicAnswerSet(
                        PublicSurveyKey => $PublicSurveyKey,
                        QuestionID      => $Question->{QuestionID},
                        VoteValue       => $Answer,
                    );
                }
            }
        }
        elsif ( $Question->{Type} eq 'Textarea' ) {
            $SurveyObject->PublicAnswerSet(
                PublicSurveyKey => $PublicSurveyKey,
                QuestionID      => $Question->{QuestionID},
                VoteValue       => $Answers->{ $Question->{QuestionID} },
            );
        }
        elsif ( $Question->{Type} eq 'NPS' ) {
            $SurveyObject->PublicAnswerSet(
                PublicSurveyKey => $PublicSurveyKey,
                QuestionID      => $Question->{QuestionID},
                VoteValue       => $Answers->{ $Question->{QuestionID} },
            );
        }
    }

    $SurveyObject->PublicSurveyInvalidSet(
        PublicSurveyKey => $Param{Data}->{PublicSurveyKey},
    );

    return {
        Success => 1,
        Data    => {},
    };
    
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut