# --
# Kernel/System/Ticket/Event/SurveySendRequest.pm - send survey requests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: SurveySendRequest.pm,v 1.11 2008-12-22 10:01:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Ticket::Event::SurveySendRequest;

use strict;
use warnings;

use Kernel::System::Survey;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    my @NeededObjects = (
        'ConfigObject',       'TicketObject',   'LogObject',  'UserObject',
        'CustomerUserObject', 'SendmailObject', 'TimeObject', 'EncodeObject'
    );

    # check needed objects
    for my $Object (@NeededObjects) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }
    $Self->{SurveyObject} = Kernel::System::Survey->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TicketID Event Config)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );

    # return if ticket is not closed
    return 1 if $Ticket{StateType} ne 'closed';

    # send also survey request on ticket creation (on first article)
    if ( $Param{Event} eq 'ArticleCreate' ) {
        my @ArticleIndex = $Self->{TicketObject}->ArticleIndex( TicketID => $Param{TicketID} );
        return 1 if scalar @ArticleIndex != 1;
    }

    # send request
    $Self->{SurveyObject}->RequestSend( TicketID => $Param{TicketID} );

    return 1;
}

1;
