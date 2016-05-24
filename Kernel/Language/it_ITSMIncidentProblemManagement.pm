# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::it_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'Aggiungi approvazione al ticket';
    $Self->{Translation}->{'Decision Date'} = 'Data di approvazione';
    $Self->{Translation}->{'Decision Result'} = 'Risultato approvazione';
    $Self->{Translation}->{'Due Date'} = 'Data di scadenza';
    $Self->{Translation}->{'Reason'} = 'Motivo';
    $Self->{Translation}->{'Recovery Start Time'} = 'Data iniziale di recupero';
    $Self->{Translation}->{'Repair Start Time'} = 'Data iniziale di riparazione';
    $Self->{Translation}->{'Review Required'} = 'Richiesta revisione';
    $Self->{Translation}->{'closed with workaround'} = 'chiuso con soluzione tampone (workaround)';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = '';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'Modifica campi ITSM del ticket';
    $Self->{Translation}->{'Service Incident State'} = '';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = 'Collega ticket';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'Urgenzia';
    $Self->{Translation}->{'Impact'} = 'Impatto';

}

1;
