# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ja_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = '重要度↔影響度↔優先度';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        '重要度↔影響を組み合わせた優先度の結果を管理します。';
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

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = '影響';

    # Perl Module: Kernel/Modules/AgentITSMSLAPrint.pm
    $Self->{Translation}->{'No SLAID is given!'} = 'SLAIDが与えられていません！';
    $Self->{Translation}->{'SLAID %s not found in database!'} = 'SLAID %s はデータベースにありません！';
    $Self->{Translation}->{'Calendar Default'} = 'カレンダー・デフォルト';

    # Perl Module: Kernel/Modules/AgentITSMSLAZoom.pm
    $Self->{Translation}->{'operational'} = '通常運用';
    $Self->{Translation}->{'warning'} = '警告';
    $Self->{Translation}->{'incident'} = 'インシデント';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'No ServiceID is given!'} = 'ServiceIDは指定されていません！';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = 'ServiceID %s はデータベースにありません！';
    $Self->{Translation}->{'Current Incident State'} = 'インシデントの状態';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'インシデントの状態';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = '通常運用';
    $Self->{Translation}->{'Incident'} = 'インシデント';
    $Self->{Translation}->{'End User Service'} = 'エンドユーザ・サービス';
    $Self->{Translation}->{'Front End'} = 'フロントエンド';
    $Self->{Translation}->{'Back End'} = 'バックエンド';
    $Self->{Translation}->{'IT Management'} = 'ITマネージメント';
    $Self->{Translation}->{'Reporting'} = 'レポート';
    $Self->{Translation}->{'IT Operational'} = 'ITオペレーション';
    $Self->{Translation}->{'Demonstration'} = 'デモンストレーション';
    $Self->{Translation}->{'Project'} = 'プロジェクト';
    $Self->{Translation}->{'Underpinning Contract'} = '支持する契約';
    $Self->{Translation}->{'Other'} = 'その他';
    $Self->{Translation}->{'Availability'} = '可用性';
    $Self->{Translation}->{'Response Time'} = 'レスポンスタイム';
    $Self->{Translation}->{'Recovery Time'} = 'リカバリ・タイム';
    $Self->{Translation}->{'Resolution Rate'} = '解像度レート';
    $Self->{Translation}->{'Transactions'} = '取引';
    $Self->{Translation}->{'Errors'} = 'エラー';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = '代替：';
    $Self->{Translation}->{'Both'} = '両方';
    $Self->{Translation}->{'Connected to'} = '接続：';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'リンクオブジェクトウィジェット（LinkObject :: ViewMode = "complex"）で設定ボタンを使用できるアクションを定義します。 これらのアクションは、次のJSおよびCSSファイルを登録している必要があります。Core.AllocationList.css、Core.UI.AllocationList.js、Core.UI.Table.Sort.js、Core.Agent.TableFilters.js、及びCore.Agent .LinkObject.js';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'リンクされたサービスウィジェットに表示される列を定義します（LinkObject :: ViewMode = "complex"）。 注：DefaultColumnsにはサービス属性のみが許可されています。 可能な設定：0 =使用不可、1 =使用可能、2 =デフォルトで使用可能。';
    $Self->{Translation}->{'Depends on'} = '依存：';
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        '管理エリアでのAdminITSMCIPAllocateのフロントエンドモジュールの登録';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        '担当者インタフェースのAgentITSMSLAオブジェクト　フロントエンド・モジュールの登録です。';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        '担当者インタフェースのAgentITSMSLAPrintオブジェクト　フロントエンド・モジュールの登録です。';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        '担当者インタフェースのAgentITSMSLAZoomオブジェクト　フロントエンド・モジュールの登録です。';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        '担当者インタフェースのAgentITSMServiceオブジェクト　フロントエンド・モジュールの登録です。';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        '担当者インタフェースのAgentITSMServicePrintオブジェクト　フロントエンド・モジュールの登録です。';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        '担当者インタフェースのAgentITSMServiceZoomオブジェクト　フロントエンド・モジュールの登録です。';
    $Self->{Translation}->{'ITSM SLA Overview.'} = 'ITSM SLA の概要';
    $Self->{Translation}->{'ITSM Service Overview.'} = 'ITSM サービスの概要';
    $Self->{Translation}->{'Incident State Type'} = 'インシデント状態のタイプ';
    $Self->{Translation}->{'Includes'} = '含む：';
    $Self->{Translation}->{'Manage priority matrix.'} = '優先度の関連性を管理';
    $Self->{Translation}->{'Manage the criticality - impact - priority matrix.'} = '重要度↔影響度↔優先度の関連性を管理';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'SLAメニューに戻るメニュー項目を表示するモジュール';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = 'サービスメニューに戻るメニュー項目を表示するモジュール';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = 'サービスメニューにリンクメニュー項目を表示するモジュール';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'SLAメニューに印刷メニュー項目を表示するモジュール';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = 'サービスメニューに印刷メニュー項目を表示するモジュール';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = '設定ビューでのインシデントステータスのパラメーター';
    $Self->{Translation}->{'Part of'} = '一部：';
    $Self->{Translation}->{'Relevant to'} = '関連項目：';
    $Self->{Translation}->{'Required for'} = '必須：';
    $Self->{Translation}->{'SLA Overview'} = 'SLAの概観';
    $Self->{Translation}->{'SLA Print.'} = 'SLA の印刷';
    $Self->{Translation}->{'SLA Zoom.'} = 'SLA ズーム';
    $Self->{Translation}->{'Service Overview'} = 'サービスの概観';
    $Self->{Translation}->{'Service Print.'} = 'サービスの印刷';
    $Self->{Translation}->{'Service Zoom.'} = 'サービス・ズーム';
    $Self->{Translation}->{'Service-Area'} = 'サービス・エリア';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        'インシデント状態の計算に使用するリンクのタイプと方向を設定します。 キーはリンクタイプの名前（LinkObject :: Typeで定義されている）であり、値はインシデントステータスを計算するために従うべきIncidentLinkTypeの方向です。 たとえば、IncidentLinkTypeが \'DependsOn\'に設定されており、Directionが \'Source\'の場合、インシデントのステータスを計算するために、 \'依存する\'リンクのみが表示されます（反対のリンクは \'Required for\'ではありません）。 広告タイプのリンクタイプを追加できます（例： 方向 \'Target\'を含む \'Includes\'。 sysconfigオプションLinkObject :: Typeで定義されているすべてのリンクタイプが可能で、方向は \'Source\'、 \'Target\'、または \'Both\'です。 重要：このSYSCONFIGオプションに変更を加えたら、コンソールコマンドbin/otrs.Console.plを実行する必要があります。Admin :: ITSM :: IncidentState :: Recalculateしたがって、すべての事態は新しい設定に基づいて再計算されます！';
    $Self->{Translation}->{'Source'} = 'ソース';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        '‘Normal’リンク・タイプを使用して、‘ITSMChange’オブジェクトが他の‘Ticket’オブジェクトとリンクされるように、定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        '‘Normal’リンク・タイプを使用して、‘ITSMChange’オブジェクトが‘FAQ’オブジェクトとリンクされるように、定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '‘親子’リンク・タイプを使用して、‘ITSMChange’オブジェクトが‘FAQ’オブジェクトとリンクされるように、定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        '‘関連した’リンク・タイプを使用して、‘ITSMChange’オブジェクトが‘FAQ’オブジェクトとリンクされるように、定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        'この設定は、「ITSMConfigItem」オブジェクトが「AlternativeTo/~の代替」リンクタイプを使用して、「サービス」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'この設定は、「ITSMConfigItem」オブジェクトが「DependsOn/~に依存する」リンクタイプを使用して、「サービス」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        'この設定は、「ITSMConfigItem」オブジェクトが「RelevantTo/~と関連する」リンクタイプを使用して、「サービス」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        'この設定は、「ITSMConfigItem」オブジェクトが「AlternativeTo/~の代替」リンクタイプを使用して、「チケット」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        'この設定は、「ITSMConfigItem」オブジェクトが「DependsOn/~に依存する」リンクタイプを使用して、「チケット」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        'この設定は、「ITSMConfigItem」オブジェクトが「RelevantTo/~と関連する」リンクタイプを使用して、「チケット」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        'この設定は、「ITSMConfigItem」オブジェクトが「AlternativeTo/~の代替」リンクタイプを使用して、他の「ITSMConfigItem」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        'この設定は、「ITSMConfigItem」オブジェクトが「ConnectedTo/~とつながっている」リンクタイプを使用して、他の「ITSMConfigItem」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'この設定は、「ITSMConfigItem」オブジェクトが「DependsOn/~に依存する」リンクタイプを使用して、他の「ITSMConfigItem」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        'この設定は、「ITSMConfigItem」オブジェクトが「Includes/~を含む」リンクタイプを使用して、他の「ITSMConfigItem」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        'この設定は、「ITSMConfigItem」オブジェクトが「RelevantTo/~と関連する」リンクタイプを使用して、他の「ITSMConfigItem」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'この設定は、「ITSMWorkOrder」オブジェクトが「DependsOn/~に依存する」リンクタイプを使用して、「ITSMConfigItem」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        'この設定は、「ITSMWorkOrder」オブジェクトが「Normal/通常」リンクタイプを使用して、「ITSMConfigItem」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'この設定は、「ITSMWorkOrder」オブジェクトが「DependsOn/~に依存する」リンクタイプを使用して、「Service」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        'この設定は、「ITSMWorkOrder」オブジェクトが「Normal/通常」リンクタイプを使用して、「Service」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'この設定は、「ITSMWorkOrder」オブジェクトが「Normal/通常」リンクタイプを使用して、「Ticket」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'この設定は、「Service」オブジェクトが「Normal/通常」リンクタイプを使用して、「FAQ」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'この設定は、「Service」オブジェクトが「ParentChild/親子」リンクタイプを使用して、「FAQ」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'この設定は、「Service」オブジェクトが「RelevantTo/~と関連する」リンクタイプを使用して、「FAQ」オブジェクトとリンクできることを定義します。';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'リンク・タイプ\'AlternativeTo\'の定義です。もしソース名およびターゲット名が同じ値を含んでいる場合、結果のリンクは非直接リンクになり、そうでない結果は直接リンクになります。';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'リンク・タイプ\'ConnectedTo\'の定義です。もしソース名およびターゲット名が同じ値を含んでいる場合、結果のリンクは非直接リンクになり、そうでない結果は直接リンクになります。';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'リンク・タイプ\'DependsOn\'の定義です。もしソース名およびターゲット名が同じ値を含んでいる場合、結果のリンクは非直接リンクになり、そうでない結果は直接リンクになります。';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'リンク・タイプ\'Includes\'の定義です。もしソース名およびターゲット名が同じ値を含んでいる場合、結果のリンクは非直接リンクになり、そうでない結果は直接リンクになります。';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'リンク・タイプ\'RelevantTo\'の定義です。もしソース名およびターゲット名が同じ値を含んでいる場合、結果のリンクは非直接リンクになり、そうでない結果は直接リンクになります。';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'ITSM テキストエリア幅';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
