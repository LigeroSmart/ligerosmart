# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::bg_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'Добави решение към билета';
    $Self->{Translation}->{'Decision Date'} = 'Дата за решаване';
    $Self->{Translation}->{'Decision Result'} = 'Резултат от решението';
    $Self->{Translation}->{'Due Date'} = 'Крайна дата';
    $Self->{Translation}->{'Reason'} = 'Основание';
    $Self->{Translation}->{'Recovery Start Time'} = 'Време на стартиране на възстановяването';
    $Self->{Translation}->{'Repair Start Time'} = 'Време на стартиране на ремонта';
    $Self->{Translation}->{'Review Required'} = 'Изисква преглеждане';
    $Self->{Translation}->{'closed with workaround'} = 'приключен с обходно решение';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = '';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'Промени ITSM полетата на билета';
    $Self->{Translation}->{'Service Incident State'} = '';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = '';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'Критичност';
    $Self->{Translation}->{'Impact'} = 'Влияние';

}

1;
