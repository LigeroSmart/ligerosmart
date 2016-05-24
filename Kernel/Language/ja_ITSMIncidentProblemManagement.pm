# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ja_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'チケットに決定を追加する';
    $Self->{Translation}->{'Decision Date'} = '決定日付';
    $Self->{Translation}->{'Decision Result'} = '決定結果';
    $Self->{Translation}->{'Due Date'} = '対応期限';
    $Self->{Translation}->{'Reason'} = '理由';
    $Self->{Translation}->{'Recovery Start Time'} = '回復開始時間';
    $Self->{Translation}->{'Repair Start Time'} = '修理開始時間';
    $Self->{Translation}->{'Review Required'} = 'レビュー必須';
    $Self->{Translation}->{'closed with workaround'} = 'ワークアラウンドで完了';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = 'チケットの変更決定';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'チケットのITSM項目を変更する';
    $Self->{Translation}->{'Service Incident State'} = 'サービスインシデント状況';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = 'チケットをリンクする';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = '重要度';
    $Self->{Translation}->{'Impact'} = '影響度';

}

1;
