# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Survey::RequestExtend;

use strict;
use warnings;

use Digest::MD5;
use Mail::Address;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::DB',
    'Kernel::System::HTMLUtils',
    'Kernel::System::Log',
    'Kernel::System::User',
    'Kernel::System::YAML',
    'Kernel::System::Encode',
    'Kernel::System::JSON',
);

=head1 NAME

Kernel::System::Survey::Request - sub module of Kernel::System::Survey

=head1 DESCRIPTION

All survey request functions.

=head1 PUBLIC INTERFACE

=head2 new()
create an object
    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');
=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get like escape string needed for some databases (e.g. oracle)
    $Self->{LikeEscapeString} = $Kernel::OM->Get('Kernel::System::DB')->GetDatabaseFunction('LikeEscapeString');

    return $Self;
}

=head2 RequestListByUserEmail()

to get an array list of request elements

    my %RequestData = $SurveyObject->RequestListByUserEmail(
        UserEmail => 'test@company.com',

        ValidID => '1' # (optional)
        RequestSendTimeNewerDate    => '2012-01-01 12:00:00',   # (optional)
        RequestSendTimeOlderDate    => '2012-01-31 12:00:00',   # (optional)
        RequestVoteTimeNewerDate    => '2012-01-01 12:00:00',   # (optional)
        RequestVoteTimeOlderDate    => '2012-12-31 12:00:00',   # (optional)
        RequestCreateTimeNewerDate  => '2012-01-01 12:00:00',   # (optional)
        RequestCreateTimeOlderDate  => '2012-12-31 12:00:00',   # (optional)
    );

returns:

    %RequestData = (
        RequestID       => 123,
        TicketID        => 123,
        SurveyID        => 123,
        ValidID         => 1,
        PublicSurveyKey => 'b4c14552919018b51ec792c9b812b691',
        SendTo          => 'mail@localhost.com',
        SendTime        => '2017-01-01 12:00:00',
        VoteTime        => '2017-01-02 12:00:00',
    );

=cut

sub RequestListByUserEmail {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserEmail} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserEmail!',
        );

        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # prepare sql
    my $SQLSelect = 'SELECT id, ticket_id, survey_id, valid_id, public_survey_key, send_to, send_time, vote_time';
    my $SQLFrom   = ' FROM survey_request';
    my $SQLWhere  = " WHERE send_to = '$Param{UserEmail}'";

    # set time params
    my %TimeParams = (

        RequestSendTimeNewerDate   => 'send_time >=',
        RequestSendTimeOlderDate   => 'send_time <=',
        RequestVoteTimeNewerDate   => 'vote_time >=',
        RequestVoteTimeOlderDate   => 'vote_time <=',
        RequestCreateTimeNewerDate => 'create_time >=',
        RequestCreateTimeOlderDate => 'create_time <=',
    );

    # check and add time params to WHERE
    TIMEPARAM:
    for my $TimeParam ( sort keys %TimeParams ) {

        next TIMEPARAM if !$Param{$TimeParam};

        # check format
        if ( $Param{$TimeParam} !~ m{ \A \d\d\d\d-\d\d-\d\d \s \d\d:\d\d:\d\d \z }xms ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "The parameter $TimeParam has an invalid date format!",
            );

            return;
        }

        $Param{$TimeParam} = $DBObject->Quote( $Param{$TimeParam} );

        # add time parameter to WHERE
        $SQLWhere .= " AND $TimeParams{$TimeParam} '$Param{$TimeParam}'";
    }

    if($Param{ValidID}){
         $SQLWhere .= " AND valid_id = '$Param{ValidID}'";
    }

    my $SQL = $SQLSelect .= $SQLFrom;
    $SQL .= $SQLWhere;

    # get request list
    return if !$DBObject->Prepare(
        SQL   => $SQL,
    );

    # fetch the result
    my @RequestData = ();

    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @RequestData,{
            RequestID => $Row[0],
            TicketID => $Row[1],
            SurveyID => $Row[2],
            ValidID => $Row[3],
            PublicSurveyKey => $Row[4],
            SendTo => $Row[5],
            SendTime => $Row[6],
            VoteTime => $Row[7]
        };
    }

    return @RequestData;
}

1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut