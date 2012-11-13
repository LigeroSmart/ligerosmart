# --
# Kernel/System/Ticket/Event/SurveySendRequest.pm - send survey requests
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: SurveySendRequest.pm,v 1.16 2012-11-13 16:10:58 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

package Kernel::System::Ticket::Event::SurveySendRequest;

use strict;
use warnings;

use Kernel::System::Survey;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.16 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ConfigObject TicketObject LogObject UserObject DBObject MainObject TimeObject EncodeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }
    $Self->{SurveyObject} = Kernel::System::Survey->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TicketID Event Config)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # loop Protection, RequestSend calls HistoryAdd
    # so we can't listen on HistoryAdd Events in order to
    # prevent deep recursion
    return 1 if $Param{Event} eq 'HistoryAdd';

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID => $Param{TicketID},
    );

    return 1 if $Ticket{StateType} ne 'closed';

    # send also survey request on ticket creation (on first article)
    if ( $Param{Event} eq 'ArticleCreate' ) {

        my @ArticleIndex = $Self->{TicketObject}->ArticleIndex(
            TicketID => $Param{TicketID},
        );

        return 1 if scalar @ArticleIndex != 1;
    }

    # send request
    $Self->{SurveyObject}->RequestSend(
        TicketID => $Param{TicketID},
    );

    return 1;
}

1;
