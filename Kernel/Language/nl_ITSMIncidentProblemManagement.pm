# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nl_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'Koppel beslissing aan ticket';
    $Self->{Translation}->{'Decision Date'} = 'Beslissingsdatum';
    $Self->{Translation}->{'Decision Result'} = 'Resultaat beslissing';
    $Self->{Translation}->{'Due Date'} = 'Vervaldatum';
    $Self->{Translation}->{'Reason'} = 'Reden';
    $Self->{Translation}->{'Recovery Start Time'} = 'Begintijd herstel';
    $Self->{Translation}->{'Repair Start Time'} = 'Begintijd reparatie';
    $Self->{Translation}->{'Review Required'} = 'Review benodigd';
    $Self->{Translation}->{'closed with workaround'} = 'gesloten met workaround';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = '';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'Veranderen van ITSM velden van ticket';
    $Self->{Translation}->{'Service Incident State'} = '';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = '';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'Urgentie';
    $Self->{Translation}->{'Impact'} = 'Impact';

}

1;
