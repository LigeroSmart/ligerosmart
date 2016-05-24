# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'Dodaj decyzję do zgłoszenia';
    $Self->{Translation}->{'Decision Date'} = 'Data decyzji';
    $Self->{Translation}->{'Decision Result'} = 'Rezultat decyzji';
    $Self->{Translation}->{'Due Date'} = 'Czas zakończenia';
    $Self->{Translation}->{'Reason'} = 'Powód';
    $Self->{Translation}->{'Recovery Start Time'} = 'Czas rozpoczęcia odzyskiwania';
    $Self->{Translation}->{'Repair Start Time'} = 'Czas rozpoczęcia naprawy';
    $Self->{Translation}->{'Review Required'} = 'Wymagany przegląd';
    $Self->{Translation}->{'closed with workaround'} = 'rozwiązane z obejściem';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = 'Zmień decyzję w zgłoszeniu';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'Zmień pola ITSM zgłoszenia';
    $Self->{Translation}->{'Service Incident State'} = '';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = 'Połącz zgłoszenie';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'Krytyczność';
    $Self->{Translation}->{'Impact'} = 'Wpływ';

}

1;
