# --
# Kernel/System/Ticket/Event/SurveySendRequest.pm - send survey requests
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SurveySendRequest.pm,v 1.1 2006-03-11 10:35:03 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Event::SurveySendRequest;

use strict;
use Kernel::System::Survey;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject TicketObject LogObject UserObject CustomerUserObject SendmailObject TimeObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{SurveyObject} = Kernel::System::Survey->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID Event Config)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    if ($Param{Event} eq 'StateSet') {
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Param{TicketID});
        if ($Ticket{StateType} eq 'closed'){
            $Self->{SurveyObject}->RequestSend(TicketID => $Param{TicketID});
        }
    }
    return 1;
}
# --
1;

