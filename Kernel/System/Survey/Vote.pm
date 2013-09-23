# --
# Kernel/System/Survey/Vote.pm - survey vote functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Survey::Vote;

use strict;
use warnings;

=head1 NAME

Kernel::System::Survey::Vote - sub module of Kernel::System::Survey

=head1 SYNOPSIS

All survey vote functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item VoteGet()

to get all attributes of a vote

    my @Vote = $SurveyObject->VoteGet(
        RequestID => 13,
        QuestionID => 23
    );

=cut

sub VoteGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(RequestID QuestionID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get vote
    $Self->{DBObject}->Prepare(
        SQL => '
            SELECT id, vote_value
            FROM survey_vote
            WHERE request_id = ?
                AND question_id = ?',
        Bind => [ \$Param{RequestID}, \$Param{QuestionID}, ],
    );

    # fetch the result
    my @List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Data;
        $Data{RequestID} = $Row[0];
        $Data{VoteValue} = $Row[1] || '-';

        push @List, \%Data;
    }

    return @List;
}

=item VoteList()

to get a array list of all vote items

    my @List = $SurveyObject->VoteList(
        SurveyID => 1
    );

=cut

sub VoteList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SurveyID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need SurveyID!',
        );
        return;
    }

    # get vote list
    $Self->{DBObject}->Prepare(
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
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Data;
        $Data{RequestID} = $Row[0];
        $Data{TicketID}  = $Row[1];
        $Data{SendTime}  = $Row[2];
        $Data{VoteTime}  = $Row[3];

        push @List, \%Data;
    }

    return @List;
}

=item VoteAttributeGet()

to get all attributes of a vote

    my $VoteAttributeContent = $SurveyObject->VoteAttributeGet(
        VoteID => 13,
    );

=cut

sub VoteAttributeGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(VoteID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get vote attribute
    $Self->{DBObject}->Prepare(
        SQL => '
            SELECT vote_value
            FROM survey_vote
            WHERE id = ?',
        Bind  => [ \$Param{VoteID} ],
        Limit => 1,
    );

    # fetch the result
    my $VoteAttributeContent = ${ $Self->{DBObject}->FetchrowArray() }[0];
    return $VoteAttributeContent;
}

=item VoteCount()

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
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # count votes
    $Self->{DBObject}->Prepare(
        SQL => '
            SELECT COUNT(vote_value)
            FROM survey_vote
            WHERE question_id = ? AND vote_value = ?',
        Bind => [ \$Param{QuestionID}, \$Param{VoteValue}, ],
        Limit => 1,
    );

    # fetch the result
    my $VoteCount;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $VoteCount = $Row[0];
    }

    return $VoteCount;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
