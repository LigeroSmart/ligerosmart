# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'Entscheidung an Ticket hängen';
    $Self->{Translation}->{'Decision Date'} = 'Entscheidung';
    $Self->{Translation}->{'Decision Result'} = 'Entscheidung';
    $Self->{Translation}->{'Due Date'} = 'Fälligkeitsdatum';
    $Self->{Translation}->{'Reason'} = 'Begründung';
    $Self->{Translation}->{'Recovery Start Time'} = 'Wiederherstellung Startzeit';
    $Self->{Translation}->{'Repair Start Time'} = 'Reparatur Startzeit';
    $Self->{Translation}->{'Review Required'} = 'Nachbearbeitung erforderlich';
    $Self->{Translation}->{'closed with workaround'} = 'provisorisch geschlossen';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = 'Die Entscheidung des Tickets ändern';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'Ändern der ITSM Felder des Tickets';
    $Self->{Translation}->{'Service Incident State'} = 'Service Vorfallsstatus';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = 'Ticket verknüpfen';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'Kritikalität';
    $Self->{Translation}->{'Impact'} = 'Auswirkung';

}

1;
