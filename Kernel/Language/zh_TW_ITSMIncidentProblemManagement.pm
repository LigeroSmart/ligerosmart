# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_TW_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = '增加決定';
    $Self->{Translation}->{'Decision Date'} = '決定日期';
    $Self->{Translation}->{'Decision Result'} = '決定结果';
    $Self->{Translation}->{'Due Date'} = '截止日期';
    $Self->{Translation}->{'Reason'} = '理由';
    $Self->{Translation}->{'Recovery Start Time'} = '恢復開始時間';
    $Self->{Translation}->{'Repair Start Time'} = '修復開始時間';
    $Self->{Translation}->{'Review Required'} = '需要複審';
    $Self->{Translation}->{'closed with workaround'} = '關閉(變通)';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = '修改工單決定';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = '修改ITSM字段';
    $Self->{Translation}->{'Service Incident State'} = '服務故障狀態';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = '鏈接工單';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = '重要';
    $Self->{Translation}->{'Impact'} = '影響';

}

1;
