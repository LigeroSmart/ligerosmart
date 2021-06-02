# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::MiscLigero::SurveySearch;

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
=pod
@api {post} /survey/search Get survey results by customer.
@apiName Search
@apiGroup Survey
@apiVersion 1.0.0

@apiExample Example usage:
  {
    "SessionID": "aZxKNPbxPKhcZ7ww7atmICJOQK9nXgKw",
    "CustomerUserID": "ricardo.silva"
  }

@apiParam (Request body) {String} [UserLogin] User login to create sesssion.
@apiParam (Request body) {String} [Password] Password to create session.
@apiParam (Request body) {String} SessionID session id generated by session create method.
@apiParam (Request body) {String} CustomerUserID Customer user.

@apiErrorExample {json} Error example:
  HTTP/1.1 200 Success
  {
    "Error": {
      "ErrorCode": "GeneralCatalogGetValues.AuthFail",
      "ErrorMessage": "GeneralCatalogGetValues: Authorization failing!"
    }
  }
@apiSuccessExample {json} Success example:
  HTTP/1.1 200 Success
  {
    "Items": [
      {
        "PublicSurveyKey": "abcd",
        "RequestID": 1,
        "ValidID": 1,
        "SurveyID": 1,
        "TicketID": 1,
        "VoteTime": "2021-05-29 18:49:03",
        "SurveyData": {
          "SurveyID": 1,
          "SurveyNumber": "10001",
          "Title": "Teste",
          "Introduction": "$html/text$ Teste"
        },
        "SurveyQuestions": [
          {
            "QuestionID": 1,
            "SurveyID": 1,
            "Type": "YesNo",
            "AnswerList": [
              {
                "QuestionID": 1,
                "AnswerID": 1,
                "Answer": "1"
              }
            ],
            "AnswerRequired": 1,
            "Question": "Teste"
          }
        ],
        "SendTo": "ricardo.ara.silva@gmail.com",
        "SendTime": "2021-05-29 18:44:58"
      }
    ]
  }

@apiSuccess {Array} Items List of items found.
=cut
sub Run {
    my ( $Self, %Param ) = @_;

    my ( $UserID, $UserType ) = $Self->Auth(
        %Param,
    );

    my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');
    my $SurveyExtendObject = $Kernel::OM->Get('Kernel::System::Survey::RequestExtend');
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    return $Self->ReturnError(
        ErrorCode    => 'GeneralCatalogGetValues.AuthFail',
        ErrorMessage => "GeneralCatalogGetValues: Authorization failing!",
    ) if !$UserID;

    for my $Needed (qw( CustomerUserID )) {
        if ( !$Param{Data}->{$Needed} ) {

            return $Self->ReturnError(
                ErrorCode    => 'SessionCreate.MissingParameter',
                ErrorMessage => "SessionCreate: $Needed parameter is missing!",
            );
        }
    }

    my %User = $CustomerUserObject->CustomerUserDataGet(
        User => $Param{Data}->{"CustomerUserID"},
    );

    return $Self->ReturnError(
        ErrorCode    => 'GeneralCatalogGetValues.CustomerUserID',
        ErrorMessage => "GeneralCatalogGetValues: Invalid CustomerUserID!",
    ) if !%User;

    my @values = $SurveyExtendObject->RequestListByUserEmail(
       UserEmail => $User{UserEmail},
       ValidID => $Param{Data}->{"ValidID"}
   );

    if(@values){

        foreach my $rec (@values)
        {
            my %Survey = $SurveyObject->PublicSurveyGet(
                PublicSurveyKey => $rec->{PublicSurveyKey},
            );

            my @QuestionList = $SurveyObject->QuestionList(
                SurveyID => $rec->{SurveyID},
            );

            foreach my $quest (@QuestionList){
                my @AnswerList = $SurveyObject->AnswerList(
                    QuestionID => $quest->{QuestionID},
                );

                $quest->{AnswerList} = \@AnswerList;
            }

            $rec->{SurveyData} = \%Survey;

            $rec->{SurveyQuestions} = \@QuestionList;
        }

        return {
            Success => 1,
            Data    => {
                Items => \@values
            },
        };
    }

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