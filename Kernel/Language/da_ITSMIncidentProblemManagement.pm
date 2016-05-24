# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::da_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'Tilføj beslutning til sag';
    $Self->{Translation}->{'Decision Date'} = 'Beslutningsdato';
    $Self->{Translation}->{'Decision Result'} = 'Beslutningsresultat';
    $Self->{Translation}->{'Due Date'} = 'Forfaldsdato';
    $Self->{Translation}->{'Reason'} = 'Begrundelse';
    $Self->{Translation}->{'Recovery Start Time'} = 'Starttid for genetablering';
    $Self->{Translation}->{'Repair Start Time'} = 'Starttid for reperation';
    $Self->{Translation}->{'Review Required'} = 'Anmeldelse kræves';
    $Self->{Translation}->{'closed with workaround'} = 'Lukket med workaround';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = '';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'Ret sagens ITSM felter';
    $Self->{Translation}->{'Service Incident State'} = '';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = '';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'Kritikalitet';
    $Self->{Translation}->{'Impact'} = 'Påvirkning';

}

1;
