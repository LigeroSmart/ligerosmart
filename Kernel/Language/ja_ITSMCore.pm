# --
# Kernel/Language/ja_ITSMCore.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ja_ITSMCore;

use strict;
use warnings;

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

    # Template: AgentITSMCustomerSearch

    # Template: AgentITSMSLA

    # Template: AgentITSMSLAPrint
    $Self->{Translation}->{'SLA-Info'} = 'SLA情報';
    $Self->{Translation}->{'Last changed'} = '最終変更時刻';
    $Self->{Translation}->{'Last changed by'} = '最終変更者';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'SLA情報';
    $Self->{Translation}->{'Associated Services'} = '関連するサービス';

    # Template: AgentITSMService

    # Template: AgentITSMServicePrint
    $Self->{Translation}->{'Service-Info'} = 'サービス情報';
    $Self->{Translation}->{'Current Incident State'} = 'インシデントの状態';
    $Self->{Translation}->{'Associated SLAs'} = '関連するSLA';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'サービス情報';
    $Self->{Translation}->{'Current incident state'} = 'インシデントの状態';

    # SysConfig
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        '';
    $Self->{Translation}->{'Manage priority matrix.'} = '優先度の関連性を管理';
    $Self->{Translation}->{'Module to show back link in service menu.'} = '';
    $Self->{Translation}->{'Module to show back link in sla menu.'} = '';
    $Self->{Translation}->{'Module to show print link in service menu.'} = '';
    $Self->{Translation}->{'Module to show print link in sla menu.'} = '';
    $Self->{Translation}->{'Module to show the link link in service menu.'} = '';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = '';
    $Self->{Translation}->{'Set the type of link to be used to calculate the incident state.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'Width of ITSM textareas.'} = '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
