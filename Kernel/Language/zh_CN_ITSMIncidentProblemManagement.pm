# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = '给工单添加决定';
    $Self->{Translation}->{'Decision Date'} = '决定日期';
    $Self->{Translation}->{'Decision Result'} = '决定结果';
    $Self->{Translation}->{'Due Date'} = '到期日';
    $Self->{Translation}->{'Reason'} = '理由';
    $Self->{Translation}->{'Recovery Start Time'} = '恢复开始时间';
    $Self->{Translation}->{'Repair Start Time'} = '修复开始时间';
    $Self->{Translation}->{'Review Required'} = '需要复审';
    $Self->{Translation}->{'closed with workaround'} = '通过权变措施关闭';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = '变更工单决定';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = '修改ITSM字段';
    $Self->{Translation}->{'Service Incident State'} = '服务故障状态';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = '链接工单';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = '紧急度';
    $Self->{Translation}->{'Impact'} = '影响度';

}

1;
