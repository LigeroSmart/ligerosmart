# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'Ajouter une décision au ticket';
    $Self->{Translation}->{'Decision Date'} = 'Date de décision';
    $Self->{Translation}->{'Decision Result'} = 'Résultat de la Décision';
    $Self->{Translation}->{'Due Date'} = 'Engagenent de date';
    $Self->{Translation}->{'Reason'} = 'Raison';
    $Self->{Translation}->{'Recovery Start Time'} = 'Date de début de retour à la normale';
    $Self->{Translation}->{'Repair Start Time'} = 'Date de début de réparation';
    $Self->{Translation}->{'Review Required'} = 'Revue requise';
    $Self->{Translation}->{'closed with workaround'} = 'Fermé avec contournement';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = '';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'Modifier les champs ITSM du ticket';
    $Self->{Translation}->{'Service Incident State'} = '';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = '';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'Criticité';
    $Self->{Translation}->{'Impact'} = 'Impact';

}

1;
