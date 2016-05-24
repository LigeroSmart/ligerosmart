# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nb_NO_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'Legg til beslutning for sak';
    $Self->{Translation}->{'Decision Date'} = 'Beslutningsdato';
    $Self->{Translation}->{'Decision Result'} = 'Beslutningsresultat';
    $Self->{Translation}->{'Due Date'} = 'Forfallsdato';
    $Self->{Translation}->{'Reason'} = 'Begrunnelse';
    $Self->{Translation}->{'Recovery Start Time'} = 'Starttid for gjenoppretting';
    $Self->{Translation}->{'Repair Start Time'} = 'Starttid for reparasjon';
    $Self->{Translation}->{'Review Required'} = 'Evaluering kreves';
    $Self->{Translation}->{'closed with workaround'} = 'Lukket med midlertidig løsning';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = 'Endre sakens beslutning';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'Endre sakens ITSM-felter';
    $Self->{Translation}->{'Service Incident State'} = '';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = 'Koble sak';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'Kritikalitet';
    $Self->{Translation}->{'Impact'} = 'Omfang';

}

1;
