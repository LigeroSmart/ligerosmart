# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ms_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'Keputusan bergantung atas tiket';
    $Self->{Translation}->{'Decision Date'} = 'Tarikh Keputusan';
    $Self->{Translation}->{'Decision Result'} = 'Keputusan';
    $Self->{Translation}->{'Due Date'} = 'Tarikh disebabkan';
    $Self->{Translation}->{'Reason'} = 'Alasan';
    $Self->{Translation}->{'Recovery Start Time'} = 'Pemulihan Masa Mula';
    $Self->{Translation}->{'Repair Start Time'} = 'Perbaiki Masa Mula';
    $Self->{Translation}->{'Review Required'} = 'kerja semula diperlukan';
    $Self->{Translation}->{'closed with workaround'} = 'ditutup dengan kerja di sekitar';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = 'Ubah Keputusan Tiket';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'Perubahan bidang ITSM tiket';
    $Self->{Translation}->{'Service Incident State'} = 'Keadaan Insiden Perkhidmatan';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = 'Pautan tiket';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'Kritikal';
    $Self->{Translation}->{'Impact'} = 'Kesan';

}

1;
