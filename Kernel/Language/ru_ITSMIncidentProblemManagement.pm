# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'Вынести решение по заявке';
    $Self->{Translation}->{'Decision Date'} = 'Дата решения';
    $Self->{Translation}->{'Decision Result'} = 'Результат решения';
    $Self->{Translation}->{'Due Date'} = 'Дата исполнения';
    $Self->{Translation}->{'Reason'} = 'Причина';
    $Self->{Translation}->{'Recovery Start Time'} = 'Дата восстановления сервиса';
    $Self->{Translation}->{'Repair Start Time'} = 'Дата начала работ';
    $Self->{Translation}->{'Review Required'} = 'Необходим просмотр';
    $Self->{Translation}->{'closed with workaround'} = 'закрыто с обходным решением';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = 'Изменить решение по заявке';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'Изменить ITSM поля заявки';
    $Self->{Translation}->{'Service Incident State'} = 'Состояние Сервиса';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = 'Связать заявку';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'Критичность';
    $Self->{Translation}->{'Impact'} = 'Степень влияния';

}

1;
