# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Survey::Vote;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::System::Survey::Vote - sub module of Kernel::System::Survey

=head1 SYNOPSIS

All survey vote functions.

=head1 PUBLIC INTERFACE

=head2 VoteGet()

to get all attributes of a vote

    my @Vote = $SurveyObject->VoteGet(
        RequestID => 13,
        QuestionID => 23
    );

returns:

    @Vote = (
        {
            RequestID => 123,
            VoteValue => 'Yes',
        },
        ...
    );

=cut

sub VoteGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(RequestID QuestionID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get vote
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, vote_value
            FROM survey_vote
            WHERE request_id = ?
                AND question_id = ?',
        Bind => [ \$Param{RequestID}, \$Param{QuestionID}, ],
    );

    # fetch the result
    my @List;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my %Data;
        $Data{RequestID} = $Row[0];
        $Data{VoteValue} = $Row[1] || '-';

        push @List, \%Data;
    }

    return @List;
}

=head2 VoteGetAll()

to get all votes for a request id, including question data

    my @List = $SurveyObject->VoteGetAll(
        RequestID => 1,
    );

    Returns:
        [
            {
                'VoteID'       => 1,
                'VoteValue'    => 'Testvalue',
                'QuestionID'   => 1,
                'Question'     => 'Funny question #1',
                'QuestionType' => 'Checkbox',
            },
            ...
        ]

=cut

sub VoteGetAll {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(RequestID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => '
            SELECT
                svote.id, svote.question_id, svote.vote_value,
                squestion.question, squestion.question_type
            FROM
                survey_vote svote,
                survey_question squestion
            WHERE
                svote.request_id = ? AND svote.question_id = squestion.id
            ORDER BY svote.question_id ASC',
        Bind => [ \$Param{RequestID}, ],
    );

    my @List;

    while ( my @Row = $DBObject->FetchrowArray() ) {

        my %VoteData = (
            VoteID       => $Row[0],
            VoteValue    => $Row[2] || '-',
            QuestionID   => $Row[1],
            Question     => $Row[3],
            QuestionType => $Row[4],
        );

        push @List, \%VoteData;
    }

    return @List;
}

=head2 VoteList()

to get a array list of all vote items

    my @List = $SurveyObject->VoteList(
        SurveyID => 1
    );

returns:

    @List = (
        {
            RequestID => 123,
            TicketID  => 123,
            SendTime  => '2017-01-01 12:00:00',
            VoteTime  => '2017-01-02 12:00:00',
        },
        ...
    );

=cut

sub VoteList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SurveyID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need SurveyID!',
        );

        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get vote list
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, ticket_id, send_time, vote_time
            FROM survey_request
            WHERE survey_id = ?
                AND valid_id = 0
            ORDER BY vote_time DESC',
        Bind => [ \$Param{SurveyID} ],
    );

    # fetch the result
    my @List;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my %Data;
        $Data{RequestID} = $Row[0];
        $Data{TicketID}  = $Row[1];
        $Data{SendTime}  = $Row[2];
        $Data{VoteTime}  = $Row[3];

        push @List, \%Data;
    }

    return @List;
}

=head2 VoteAttributeGet()

to get all attributes of a vote

    my $VoteAttributeContent = $SurveyObject->VoteAttributeGet(
        VoteID => 13,
    );

returns:
    $VoteAttributeContent = 'Yes';

=cut

sub VoteAttributeGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(VoteID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get vote attribute
    return if !$DBObject->Prepare(
        SQL => '
            SELECT vote_value
            FROM survey_vote
            WHERE id = ?',
        Bind  => [ \$Param{VoteID} ],
        Limit => 1,
    );

    # fetch the result
    my $VoteAttributeContent = ${ $DBObject->FetchrowArray() }[0];

    return $VoteAttributeContent;
}

=head2 VoteCount()

to count all votes of a survey

    my $VoteCount = $SurveyObject->VoteCount(
        QuestionID => 123,
        VoteValue => 'The Value',
    );

=cut

sub VoteCount {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(QuestionID VoteValue)) {
        if ( !defined $Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # count votes
    return if !$DBObject->Prepare(
        SQL => '
            SELECT COUNT(vote_value)
            FROM survey_vote
            WHERE question_id = ? AND vote_value = ?',
        Bind  => [ \$Param{QuestionID}, \$Param{VoteValue}, ],
        Limit => 1,
    );

    # fetch the result
    my $VoteCount;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $VoteCount = $Row[0];
    }

    return $VoteCount;
}

=head2 VoteDelete()

delete vote by request id

    my $VoteDelete = $SurveyObject->VoteDelete(
        RequestID => 123,
    );

=cut

sub VoteDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(RequestID)) {
        if ( !defined $Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # count votes
    return if !$DBObject->Do(
        SQL   => 'DELETE FROM survey_vote WHERE request_id = ?',
        Bind  => [ \$Param{RequestID} ],
        Limit => 1,
    );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
