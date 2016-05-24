# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::sw_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'Ongeza tiketi ya uamuzi';
    $Self->{Translation}->{'Decision Date'} = 'Tarehe ya uamuzi';
    $Self->{Translation}->{'Decision Result'} = 'Matokeo ya uamuzi';
    $Self->{Translation}->{'Due Date'} = 'Tarehe ukomo';
    $Self->{Translation}->{'Reason'} = 'Sababu';
    $Self->{Translation}->{'Recovery Start Time'} = 'Muda wa kuanza wa urejeshi';
    $Self->{Translation}->{'Repair Start Time'} = 'Muda wa kuanza wa matengenezo';
    $Self->{Translation}->{'Review Required'} = 'mapitio yanahitajika';
    $Self->{Translation}->{'closed with workaround'} = 'Fungwa na mkusanyiko kazi';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = 'Badilisha tiketi ya uamuzi';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'Badili tiketi ya uga wa ITSM';
    $Self->{Translation}->{'Service Incident State'} = 'Hali ya tukio ya huduma';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = 'Tiketi kiungo';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'Kwa kina';
    $Self->{Translation}->{'Impact'} = 'Madhara';

}

1;
