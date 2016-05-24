# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ja_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = '代替：';
    $Self->{Translation}->{'Availability'} = '可用性';
    $Self->{Translation}->{'Back End'} = 'バックエンド';
    $Self->{Translation}->{'Connected to'} = '接続：';
    $Self->{Translation}->{'Current State'} = '状態';
    $Self->{Translation}->{'Demonstration'} = 'デモンストレーション';
    $Self->{Translation}->{'Depends on'} = '依存：';
    $Self->{Translation}->{'End User Service'} = 'エンドユーザ・サービス';
    $Self->{Translation}->{'Errors'} = 'エラー';
    $Self->{Translation}->{'Front End'} = 'フロントエンド';
    $Self->{Translation}->{'IT Management'} = 'ITマネージメント';
    $Self->{Translation}->{'IT Operational'} = 'ITオペレーション';
    $Self->{Translation}->{'Impact'} = '影響';
    $Self->{Translation}->{'Incident State'} = 'インシデントの状態';
    $Self->{Translation}->{'Includes'} = '含む：';
    $Self->{Translation}->{'Other'} = 'その他';
    $Self->{Translation}->{'Part of'} = '一部：';
    $Self->{Translation}->{'Project'} = 'プロジェクト';
    $Self->{Translation}->{'Recovery Time'} = 'リカバリ・タイム';
    $Self->{Translation}->{'Relevant to'} = '関連項目：';
    $Self->{Translation}->{'Reporting'} = 'レポート';
    $Self->{Translation}->{'Required for'} = '必須：';
    $Self->{Translation}->{'Resolution Rate'} = '解像度レート';
    $Self->{Translation}->{'Response Time'} = 'レスポンスタイム';
    $Self->{Translation}->{'SLA Overview'} = 'SLAの概観';
    $Self->{Translation}->{'Service Overview'} = 'サービスの概観';
    $Self->{Translation}->{'Service-Area'} = 'サービス・エリア';
    $Self->{Translation}->{'Training'} = 'トレーニング';
    $Self->{Translation}->{'Transactions'} = '取引';
    $Self->{Translation}->{'Underpinning Contract'} = '支持する契約';
    $Self->{Translation}->{'allocation'} = '配分';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = '重要度 <-> 影響度 <-> 優先度';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        '重要度<->影響度を結びつけた際の優先度結果を管理する';
    $Self->{Translation}->{'Priority allocation'} = '優先順位の割り当て';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'インシデント間の最小時間';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = '重要度';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'SLA情報';
    $Self->{Translation}->{'Last changed'} = '最終変更時刻';
    $Self->{Translation}->{'Last changed by'} = '最終変更者';
    $Self->{Translation}->{'Associated Services'} = '関連するサービス';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'サービス情報';
    $Self->{Translation}->{'Current incident state'} = 'インシデントの状態';
    $Self->{Translation}->{'Associated SLAs'} = '関連するSLA';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'Current Incident State'} = 'インシデントの状態';

}

1;
