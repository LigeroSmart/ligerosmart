# --
# Kernel/Language/pt_BR_ComplementoView.pm - translation file
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_ComplementoKanboard;

use strict;
use warnings;

use utf8;
sub Data {
    my $Self = shift;

    # Template: AgentTicketComplementoView
    $Self->{Translation}->{'Escalated on'} = 'Escalado em';
    $Self->{Translation}->{'Escalation in'} = 'Escalação em';
    $Self->{Translation}->{'Could not move this ticket.'} = 'Não foi possível mover esse ticket.';
    $Self->{Translation}->{'Unable to change priority of this ticket.'} = 'Não foi possível mudar a prioridade desse ticket.';
}

1;
