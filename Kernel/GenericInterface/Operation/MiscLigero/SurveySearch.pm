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