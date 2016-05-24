# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ja_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMChangeManagement
    $Self->{Translation}->{'ITSMChange'} = 'ITSM変更管理';
    $Self->{Translation}->{'ITSMChanges'} = 'ITSM変更管理';
    $Self->{Translation}->{'ITSM Changes'} = 'ITSM変更管理';
    $Self->{Translation}->{'workorder'} = '作業オーダー';
    $Self->{Translation}->{'A change must have a title!'} = '「タイトル」は入力必須です。';
    $Self->{Translation}->{'A condition must have a name!'} = '「名前」は入力必須です。';
    $Self->{Translation}->{'A template must have a name!'} = '「名前」は入力必須です。';
    $Self->{Translation}->{'A workorder must have a title!'} = '「タイトル」は入力必須です。';
    $Self->{Translation}->{'Add CAB Template'} = 'CABテンプレートを追加';
    $Self->{Translation}->{'Add Workorder'} = '作業オーダーを追加';
    $Self->{Translation}->{'Add a workorder to the change'} = '変更用作業オーダーを追加';
    $Self->{Translation}->{'Add new condition and action pair'} = '新しいアクションと条件のペアを追加';
    $Self->{Translation}->{'Agent interface module to show the ChangeManager overview icon.'} =
        'エージェントインターフェイスモジュールは、ChangeManager概要アイコンを表示する。';
    $Self->{Translation}->{'Agent interface module to show the MyCAB overview icon.'} = 'エージェントインターフェイスモジュールは、MyCAB概要アイコンを表示する。';
    $Self->{Translation}->{'Agent interface module to show the MyChanges overview icon.'} = 'エージェントインターフェイスモジュールは、MyChanges概要アイコンを表示する。';
    $Self->{Translation}->{'Agent interface module to show the MyWorkOrders overview icon.'} =
        'エージェントインターフェイスモジュールは、MyWorkOrders概要アイコンを表示する。';
    $Self->{Translation}->{'CABAgents'} = 'CABエージェント';
    $Self->{Translation}->{'CABCustomers'} = 'CAB顧客';
    $Self->{Translation}->{'Change Overview'} = '変更 概要';
    $Self->{Translation}->{'Change Schedule'} = '変更 スケジュール';
    $Self->{Translation}->{'Change involved persons of the change'} = '変更管理関係者の変更';
    $Self->{Translation}->{'ChangeHistory::ActionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ActionAddID'} = '(暫定)ChangeHistory::ActionAddID (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ActionDelete'} = '(暫定)ChangeHistory::ActionDelete (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ActionDeleteAll'} = '(暫定)ChangeHistory::ActionDeleteAll(ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ActionExecute'} = '(暫定)ChangeHistory::ActionExecute(ID=%s) : %s';
    $Self->{Translation}->{'ChangeHistory::ActionUpdate'} = '(暫定)ChangeHistory::ActionUpdate %s (%s):: %s -> %s';
    $Self->{Translation}->{'ChangeHistory::ChangeActualEndTimeReached'} = '(暫定)ChangeHistory::ChangeActualEndTimeReached(ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeActualStartTimeReached'} = '(暫定)ChangeHistory::ChangeActualStartTimeReached(ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeAdd'} = '(暫定)ChangeHistory::ChangeAdd(ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentAdd'} = '(暫定)ChangeHistory::ChangeAttachmentAdd: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentDelete'} = '(暫定)ChangeHistory::ChangeAttachmentDelete %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABDelete'} = '(暫定)ChangeHistory::ChangeCABDelete %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABUpdate'} = '(暫定)ChangeHistory::ChangeCABUpdate %s: : %s -> : %s';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkAdd'} = '(暫定)ChangeHistory::ChangeLinkAdd %s (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkDelete'} = '(暫定)ChangeHistory::ChangeLinkDelete %s (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeNotificationSent'} = '(暫定)ChangeHistory::ChangeNotificationSent %s (%s)';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedEndTimeReached'} = '(暫定)ChangeHistory::ChangePlannedEndTimeReached (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedStartTimeReached'} = '(暫定)ChangeHistory::ChangePlannedStartTimeReached (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeRequestedTimeReached'} = '(暫定)ChangeHistory::ChangeRequestedTimeReached(ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeUpdate'} = '(暫定)ChangeHistory::ChangeUpdate %s: %s -> %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAdd'} = '(暫定)ChangeHistory::ConditionAdd %s: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAddID'} = '(暫定)ChangeHistory::ConditionAddID (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ConditionDelete'} = '(暫定)ChangeHistory::ConditionDelete (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ConditionDeleteAll'} = '(暫定)ChangeHistory::ConditionDeleteAll (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ConditionUpdate'} = '(暫定)ChangeHistory::ConditionUpdate (%s): : %s -> %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAdd'} = '(暫定)ChangeHistory::ExpressionAdd %s: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAddID'} = '(暫定)ChangeHistory::ExpressionAddID (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ExpressionDelete'} = '(暫定)ChangeHistory::ExpressionDelete (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ExpressionDeleteAll'} = '(暫定)ChangeHistory::ExpressionDeleteAll (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ExpressionUpdate'} = '(暫定)ChangeHistory::ExpressionUpdate %s (%s):: %s -> %s';
    $Self->{Translation}->{'ChangeNumber'} = '変更番号';
    $Self->{Translation}->{'Condition Edit'} = '条件の編集';
    $Self->{Translation}->{'Create Change'} = '変更を作成';
    $Self->{Translation}->{'Create a change from this ticket!'} = 'このチケットの変更を作成';
    $Self->{Translation}->{'Delete Workorder'} = '作業オーダーを削除';
    $Self->{Translation}->{'Edit the change'} = '変更の編集';
    $Self->{Translation}->{'Edit the conditions of the change'} = '変更の条件を編集';
    $Self->{Translation}->{'Edit the workorder'} = '作業オーダーを編集';
    $Self->{Translation}->{'Expression'} = '期限';
    $Self->{Translation}->{'Full-Text Search in Change and Workorder'} = '変更・作業オーダーの全文字検索';
    $Self->{Translation}->{'ITSMCondition'} = 'ITSM条件';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'ITSM業務指示';
    $Self->{Translation}->{'Link another object to the change'} = '';
    $Self->{Translation}->{'Link another object to the workorder'} = '';
    $Self->{Translation}->{'Move all workorders in time'} = '';
    $Self->{Translation}->{'My CABs'} = '作成済み　CAB';
    $Self->{Translation}->{'My Changes'} = '作成済み 変更';
    $Self->{Translation}->{'My Workorders'} = '作成済み ワークオーダー';
    $Self->{Translation}->{'No XXX settings'} = '.... ....... \'%s\'';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = '事後レビュー';
    $Self->{Translation}->{'PSA (Projected Service Availability)'} = 'PSA(プロジェクトサービス可用性)';
    $Self->{Translation}->{'Please select first a catalog class!'} = '';
    $Self->{Translation}->{'Print the change'} = '変更を印刷';
    $Self->{Translation}->{'Print the workorder'} = 'ワークオーダーを印刷';
    $Self->{Translation}->{'RequestedTime'} = '';
    $Self->{Translation}->{'Save Change CAB as Template'} = 'CABの修正をテンプレートとして保存する';
    $Self->{Translation}->{'Save change as a template'} = '変更をテンプレートとして保存する';
    $Self->{Translation}->{'Save workorder as a template'} = 'ワークオーダーをテンプレートとして保存する';
    $Self->{Translation}->{'Search Changes'} = '変更を検索';
    $Self->{Translation}->{'Set the agent for the workorder'} = 'ワークオーダーを担当するエージェントを設定する';
    $Self->{Translation}->{'Take Workorder'} = 'ワークオーダーを受け取る';
    $Self->{Translation}->{'Take the workorder'} = 'ワークオーダーを受け取る';
    $Self->{Translation}->{'Template Overview'} = 'テンプレート概要';
    $Self->{Translation}->{'The planned end time is invalid!'} = '計画されている終了時間が不正です!';
    $Self->{Translation}->{'The planned start time is invalid!'} = '計画されている開始時間が不正です!';
    $Self->{Translation}->{'The planned time is invalid!'} = '計画されている時間が不正です!';
    $Self->{Translation}->{'The requested time is invalid!'} = 'リクエストされた時間が不正です!';
    $Self->{Translation}->{'New (from template)'} = '新規(テンプレートから)';
    $Self->{Translation}->{'Add from template'} = 'テンプレートから追加する';
    $Self->{Translation}->{'Add Workorder (from template)'} = 'ワークオーダーを追加する(テンプレートから)';
    $Self->{Translation}->{'Add a workorder (from template) to the change'} = '変更にワークオーダー(テンプレートから)を追加する';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReached'} = '(暫定)WorkOrderHistory::WorkOrderActualEndTimeReached (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'} =
        '(暫定)WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReached'} = '(暫定)WorkOrderHistory::WorkOrderActualStartTimeReached(ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'} =
        '(暫定)WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID(ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAdd'} = '(暫定)WorkOrderHistory::WorkOrderAdd(ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'} = '(暫定)WorkOrderHistory::WorkOrderAddWithWorkOrderID(ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAdd'} = '(暫定)WorkOrderHistory::WorkOrderAttachmentAdd: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'} = '(暫定)WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID(ID=%s): %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = '(暫定)WorkOrderHistory::WorkOrderAttachmentDelete: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(暫定)WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID(ID=%s) : %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAdd'} = 'WorkOrderHistory::WorkOrderReportAttachmentAdd';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID'} =
        'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDelete'} = 'WorkOrderHistory::WorkOrderReportAttachmentDelete';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID'} =
        'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDelete'} = '(暫定)WorkOrderHistory::WorkOrderDelete (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'} = '(暫定)WorkOrderHistory::WorkOrderDeleteWithWorkOrderID(ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAdd'} = '(暫定)WorkOrderHistory::WorkOrderLinkAdd %s (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'} = '(暫定)WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID(ID=%s) %s (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDelete'} = '(暫定)WorkOrderHistory::WorkOrderLinkDelete %s (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'} = '(暫定)WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID (ID=%s) %s (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSent'} = '(暫定)WorkOrderHistory::WorkOrderNotificationSent %s ): %s(';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '(暫定)WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID (ID=%s)  %s (%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'} = '(暫定)WorkOrderHistory::WorkOrderPlannedEndTimeReached (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'} =
        '(暫定)WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'} = '(暫定)WorkOrderHistory::WorkOrderPlannedStartTimeReached(ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} =
        '(暫定)WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID(ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdate'} = '(暫定)WorkOrderHistory::WorkOrderUpdate %s:: %s -> :%s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'} = '(暫定)WorkOrderHistory::WorkOrderUpdateWithWorkOrderID(ID=%s) %s:: %s -> : %s';
    $Self->{Translation}->{'WorkOrderNumber'} = 'ワークオーダー番号';
    $Self->{Translation}->{'accepted'} = '承認済み';
    $Self->{Translation}->{'any'} = 'すべて';
    $Self->{Translation}->{'approval'} = '認証';
    $Self->{Translation}->{'approved'} = '承認済み';
    $Self->{Translation}->{'backout'} = 'バックアウト';
    $Self->{Translation}->{'begins with'} = 'で始まる';
    $Self->{Translation}->{'canceled'} = 'キャンセル';
    $Self->{Translation}->{'contains'} = '含んでいる';
    $Self->{Translation}->{'created'} = '作成済み';
    $Self->{Translation}->{'decision'} = '決定';
    $Self->{Translation}->{'ends with'} = 'で終了';
    $Self->{Translation}->{'failed'} = '失敗';
    $Self->{Translation}->{'in progress'} = '進行中';
    $Self->{Translation}->{'is'} = 'である';
    $Self->{Translation}->{'is after'} = 'の後である';
    $Self->{Translation}->{'is before'} = 'の前である';
    $Self->{Translation}->{'is empty'} = 'は空である';
    $Self->{Translation}->{'is greater than'} = 'より大きい';
    $Self->{Translation}->{'is less than'} = 'より小さい';
    $Self->{Translation}->{'is not'} = 'ではない';
    $Self->{Translation}->{'is not empty'} = 'は空ではない';
    $Self->{Translation}->{'not contains'} = 'を含まない';
    $Self->{Translation}->{'pending approval'} = '承認待ち';
    $Self->{Translation}->{'pending pir'} = '保留中のPIR';
    $Self->{Translation}->{'pir'} = 'PIR';
    $Self->{Translation}->{'ready'} = '準備完了';
    $Self->{Translation}->{'rejected'} = '却下';
    $Self->{Translation}->{'requested'} = '要求されている';
    $Self->{Translation}->{'retracted'} = '取消済み';
    $Self->{Translation}->{'set'} = 'セット';
    $Self->{Translation}->{'successful'} = '成功した';

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category <-> Impact <-> Priority'} = 'カテゴリ  <-> 影響度 <-> 優先度';
    $Self->{Translation}->{'Manage the priority result of combinating Category <-> Impact.'} =
        'カテゴリと影響度の組み合わせによって優先度を管理します。';
    $Self->{Translation}->{'Priority allocation'} = '優先度の割り当て';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'ITSM 変更管理の通知管理';
    $Self->{Translation}->{'Add Notification Rule'} = '通知ルールを追加';
    $Self->{Translation}->{'Rule'} = 'ルール';
    $Self->{Translation}->{'A notification should have a name!'} = '通知には名称が必須です。';
    $Self->{Translation}->{'Name is required.'} = '名称は入力必須です。';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'マシンの管理状況';
    $Self->{Translation}->{'Select a catalog class!'} = 'カタログクラスの選択は必須です。';
    $Self->{Translation}->{'A catalog class is required!'} = 'カタログクラスの選択は必須です。';
    $Self->{Translation}->{'Add a state transition'} = '状態遷移を追加';
    $Self->{Translation}->{'Catalog Class'} = 'カタログ・クラス';
    $Self->{Translation}->{'Object Name'} = 'オブジェクト名';
    $Self->{Translation}->{'Overview over state transitions for'} = 'ステータスの概要：';
    $Self->{Translation}->{'Delete this state transition'} = 'この状態遷移を削除する';
    $Self->{Translation}->{'Add a new state transition for'} = '新しいステータスを追加：';
    $Self->{Translation}->{'Please select a state!'} = '状態を選択してください。';
    $Self->{Translation}->{'Please select a next state!'} = '新しい状態を選択してください。';
    $Self->{Translation}->{'Edit a state transition for'} = 'ステータスの編集：';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'ステータスを削除しますか？';
    $Self->{Translation}->{'from'} = 'フロム';
    $Self->{Translation}->{'to'} = '';

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = '変更を追加';
    $Self->{Translation}->{'ITSM Change'} = 'ITSM Change';
    $Self->{Translation}->{'Justification'} = '正当化';
    $Self->{Translation}->{'Input invalid.'} = '入力は無効です';
    $Self->{Translation}->{'Impact'} = 'インパクト';
    $Self->{Translation}->{'Requested Date'} = '要求日';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = '変更テンプレートを選択';
    $Self->{Translation}->{'Time type'} = '時間タイプ';
    $Self->{Translation}->{'Invalid time type.'} = '不正な時間タイプ';
    $Self->{Translation}->{'New time'} = '新規の時間';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = '変更CABをテンプレートとして保存する';
    $Self->{Translation}->{'go to involved persons screen'} = '関係者画面に遷移する';
    $Self->{Translation}->{'Invalid Name'} = '不正な名称です';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = '条件とアクション';
    $Self->{Translation}->{'Delete Condition'} = '条件を削除する';
    $Self->{Translation}->{'Add new condition'} = '新しい条件を追加する';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = '有効な名称が必要です';
    $Self->{Translation}->{'A valid name is needed.'} = '';
    $Self->{Translation}->{'Duplicate name:'} = '名前を複製';
    $Self->{Translation}->{'This name is already used by another condition.'} = '';
    $Self->{Translation}->{'Matching'} = '';
    $Self->{Translation}->{'Any expression (OR)'} = '';
    $Self->{Translation}->{'All expressions (AND)'} = '';
    $Self->{Translation}->{'Expressions'} = '期限';
    $Self->{Translation}->{'Selector'} = '';
    $Self->{Translation}->{'Operator'} = '';
    $Self->{Translation}->{'Delete Expression'} = '';
    $Self->{Translation}->{'No Expressions found.'} = '';
    $Self->{Translation}->{'Add new expression'} = '';
    $Self->{Translation}->{'Delete Action'} = 'アクションの削除';
    $Self->{Translation}->{'No Actions found.'} = '';
    $Self->{Translation}->{'Add new action'} = '新しいアクションの追加';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = '';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of'} = '';
    $Self->{Translation}->{'Workorder'} = '作業オーダー';
    $Self->{Translation}->{'Show details'} = '詳細を表示';
    $Self->{Translation}->{'Show workorder'} = '作業オーダーを表示';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of'} = '詳細な履歴情報：';
    $Self->{Translation}->{'Modified'} = '更新';
    $Self->{Translation}->{'Old Value'} = '古い値';
    $Self->{Translation}->{'New Value'} = '新しい値';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Involved Persons'} = '関係者';
    $Self->{Translation}->{'ChangeManager'} = '変更マネージャ';
    $Self->{Translation}->{'User invalid.'} = '不正なユーザ';
    $Self->{Translation}->{'ChangeBuilder'} = '変更実施者';
    $Self->{Translation}->{'Change Advisory Board'} = '諮問委員を変更';
    $Self->{Translation}->{'CAB Template'} = 'CABテンプレート';
    $Self->{Translation}->{'Apply Template'} = 'テンプレートを適用';
    $Self->{Translation}->{'NewTemplate'} = '新テンプレート';
    $Self->{Translation}->{'Save this CAB as template'} = 'このCABをテンプレートとして保存する';
    $Self->{Translation}->{'Add to CAB'} = 'CABに追加する';
    $Self->{Translation}->{'Invalid User'} = '不正なユーザ';
    $Self->{Translation}->{'Current CAB'} = '現在のCAB';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = '設定';
    $Self->{Translation}->{'Changes per page'} = '';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'WorkOrderTitle'} = '業務指示名';
    $Self->{Translation}->{'ChangeTitle'} = '変更名';
    $Self->{Translation}->{'WorkOrderAgent'} = '業務指示者';
    $Self->{Translation}->{'Workorders'} = '業務指示';
    $Self->{Translation}->{'ChangeState'} = '変更状況';
    $Self->{Translation}->{'WorkOrderState'} = '業務指示の状態';
    $Self->{Translation}->{'WorkOrderType'} = '';
    $Self->{Translation}->{'Requested Time'} = '';
    $Self->{Translation}->{'PlannedStartTime'} = '予定開始時刻';
    $Self->{Translation}->{'PlannedEndTime'} = '予定終了日時';
    $Self->{Translation}->{'ActualStartTime'} = '実績開始時刻';
    $Self->{Translation}->{'ActualEndTime'} = '実績終了日時';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = '';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '例: 10*5155 または 105658*';
    $Self->{Translation}->{'CABAgent'} = 'CABエージェント';
    $Self->{Translation}->{'e.g.'} = '例: ';
    $Self->{Translation}->{'CABCustomer'} = 'CAB顧客';
    $Self->{Translation}->{'ITSM Workorder'} = '作業オーダー';
    $Self->{Translation}->{'Instruction'} = '';
    $Self->{Translation}->{'Report'} = 'レポート';
    $Self->{Translation}->{'Change Category'} = 'カテゴリを変更';
    $Self->{Translation}->{'(before/after)'} = '(前／後)';
    $Self->{Translation}->{'(between)'} = '(期間中)';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = '変更をテンプレートとして保存する';
    $Self->{Translation}->{'A template should have a name!'} = '「テンプレート名」は必須項目です。';
    $Self->{Translation}->{'The template name is required.'} = 'テンプレート名は入力必須です。';
    $Self->{Translation}->{'Reset States'} = '状態をリセット';
    $Self->{Translation}->{'Overwrite original template'} = '';
    $Self->{Translation}->{'Delete original change'} = '';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = '';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = '変更情報';
    $Self->{Translation}->{'PlannedEffort'} = '計画的な取り組み';
    $Self->{Translation}->{'Change Initiator(s)'} = 'イニシエータを変更';
    $Self->{Translation}->{'Change Manager'} = 'マネージャーを変更';
    $Self->{Translation}->{'Change Builder'} = 'ビルダーを変更';
    $Self->{Translation}->{'CAB'} = '変更承認者';
    $Self->{Translation}->{'Last changed'} = '最終変更時刻';
    $Self->{Translation}->{'Last changed by'} = '最終変更者';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        '(一部のOSにおいては)下記のリンクをオープンするためにクリック時に、Ctrl あるいは Cmd または Shiftキーを押下する必要がる場合があります。';
    $Self->{Translation}->{'Download Attachment'} = '添付ファイルのダウンロード';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = '';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = 'CABテンプレートを編集';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        '';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        '';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        '';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        '';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        '';
    $Self->{Translation}->{'Do you want to proceed?'} = '';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = 'テンプレートID';
    $Self->{Translation}->{'Edit Content'} = '';
    $Self->{Translation}->{'CreateBy'} = '変更作成者';
    $Self->{Translation}->{'CreateTime'} = '変更作成日時';
    $Self->{Translation}->{'ChangeBy'} = 'ChangeBy';
    $Self->{Translation}->{'ChangeTime'} = 'ChangeTime';
    $Self->{Translation}->{'Edit Template Content'} = '';
    $Self->{Translation}->{'Delete Template'} = 'テンプレートを削除';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = '';
    $Self->{Translation}->{'Invalid workorder type.'} = '';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = '';
    $Self->{Translation}->{'Invalid format.'} = '不正なフォーマットです';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = '';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = '';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        '';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = '';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = '';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        '';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = '';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        '';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = '';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = '';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = '';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = '';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = '';

    # Perl Module: Kernel/Modules/AdminITSMChangeNotification.pm
    $Self->{Translation}->{'Unknown notification %s!'} = '';
    $Self->{Translation}->{'There was an error creating the notification.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChange.pm
    $Self->{Translation}->{'Overview: ITSM Changes'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeAdd.pm
    $Self->{Translation}->{'Ticket with TicketID %s does not exist!'} = '';
    $Self->{Translation}->{'Missing sysconfig option "ITSMChange::AddChangeLinkTicketTypes"!'} =
        '';
    $Self->{Translation}->{'Was not able to add change!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeAddFromTemplate.pm
    $Self->{Translation}->{'Was not able to create change from template!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeCABTemplate.pm
    $Self->{Translation}->{'No ChangeID is given!'} = '';
    $Self->{Translation}->{'No change found for changeID %s.'} = '';
    $Self->{Translation}->{'The CAB of change "%s" could not be serialized.'} = '';
    $Self->{Translation}->{'Could not add the template.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeCondition.pm
    $Self->{Translation}->{'Change "%s" not found in database!'} = '';
    $Self->{Translation}->{'Could not delete ConditionID %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeConditionEdit.pm
    $Self->{Translation}->{'No %s is given!'} = '';
    $Self->{Translation}->{'Could not create new condition!'} = '';
    $Self->{Translation}->{'Could not update ConditionID %s!'} = '';
    $Self->{Translation}->{'Could not update ExpressionID %s!'} = '';
    $Self->{Translation}->{'Could not add new Expression!'} = '';
    $Self->{Translation}->{'Could not update ActionID %s!'} = '';
    $Self->{Translation}->{'Could not add new Action!'} = '';
    $Self->{Translation}->{'Could not delete ExpressionID %s!'} = '';
    $Self->{Translation}->{'Could not delete ActionID %s!'} = '';
    $Self->{Translation}->{'Error: Unknown field type "%s"!'} = '';
    $Self->{Translation}->{'ConditionID %s does not belong to the given ChangeID %s!'} = '';
    $Self->{Translation}->{'Please contact the administrator.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeDelete.pm
    $Self->{Translation}->{'Change "%s" does not have an allowed change state to be deleted!'} =
        '';
    $Self->{Translation}->{'Was not able to delete the changeID %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeEdit.pm
    $Self->{Translation}->{'Was not able to update Change!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ChangeID is given!'} = '';
    $Self->{Translation}->{'Change "%s" not found in the database!'} = '';
    $Self->{Translation}->{'Unknown type "%s" encountered!'} = '';
    $Self->{Translation}->{'Change History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistoryZoom.pm
    $Self->{Translation}->{'Can\'t show history zoom, no HistoryEntryID is given!'} = '';
    $Self->{Translation}->{'HistoryEntry "%s" not found in database!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeInvolvedPersons.pm
    $Self->{Translation}->{'Was not able to update Change CAB for Change %s!'} = '';
    $Self->{Translation}->{'Was not able to update Change %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeManager.pm
    $Self->{Translation}->{'Overview: ChangeManager'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyCAB.pm
    $Self->{Translation}->{'Overview: My CAB'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyChanges.pm
    $Self->{Translation}->{'Overview: My Changes'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyWorkOrders.pm
    $Self->{Translation}->{'Overview: My Workorders'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePIR.pm
    $Self->{Translation}->{'Overview: PIR'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePSA.pm
    $Self->{Translation}->{'Overview: PSA'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePrint.pm
    $Self->{Translation}->{'WorkOrder "%s" not found in database!'} = '';
    $Self->{Translation}->{'Can\'t create output, as the workorder is not attached to a change!'} =
        '';
    $Self->{Translation}->{'Can\'t create output, as no ChangeID is given!'} = '';
    $Self->{Translation}->{'unknown change title'} = '';
    $Self->{Translation}->{'unknown workorder title'} = '';
    $Self->{Translation}->{'ITSM Workorder Overview (%s)'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeReset.pm
    $Self->{Translation}->{'Was not able to reset WorkOrder %s of Change %s!'} = '';
    $Self->{Translation}->{'Was not able to reset Change %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSchedule.pm
    $Self->{Translation}->{'Overview: Change Schedule'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSearch.pm
    $Self->{Translation}->{'Change Search'} = '';
    $Self->{Translation}->{'WorkOrders'} = '作業オーダー';
    $Self->{Translation}->{'Change Search Result'} = '';
    $Self->{Translation}->{'Change Number'} = '';
    $Self->{Translation}->{'Change Title'} = '';
    $Self->{Translation}->{'Work Order Title'} = '';
    $Self->{Translation}->{'CAB Agent'} = '';
    $Self->{Translation}->{'CAB Customer'} = '';
    $Self->{Translation}->{'Change Description'} = '';
    $Self->{Translation}->{'Change Justification'} = '';
    $Self->{Translation}->{'WorkOrder Instruction'} = '';
    $Self->{Translation}->{'WorkOrder Report'} = '';
    $Self->{Translation}->{'Change Priority'} = '';
    $Self->{Translation}->{'Change Impact'} = '';
    $Self->{Translation}->{'Change State'} = '';
    $Self->{Translation}->{'Created By'} = '';
    $Self->{Translation}->{'WorkOrder State'} = '';
    $Self->{Translation}->{'WorkOrder Type'} = '';
    $Self->{Translation}->{'WorkOrder Agent'} = '';
    $Self->{Translation}->{'Planned Start Time'} = '';
    $Self->{Translation}->{'Planned End Time'} = '';
    $Self->{Translation}->{'Actual Start Time'} = '';
    $Self->{Translation}->{'Actual End Time'} = '';
    $Self->{Translation}->{'Change Time'} = '';
    $Self->{Translation}->{'before'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeTemplate.pm
    $Self->{Translation}->{'The change "%s" could not be serialized.'} = '';
    $Self->{Translation}->{'Could not update the template "%s".'} = '';
    $Self->{Translation}->{'Could not delete change "%s".'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeTimeSlot.pm
    $Self->{Translation}->{'The change can\'t be moved, as it has no workorders.'} = '';
    $Self->{Translation}->{'Add a workorder first.'} = '';
    $Self->{Translation}->{'Can\'t move a change which already has started!'} = '';
    $Self->{Translation}->{'Please move the individual workorders instead.'} = '';
    $Self->{Translation}->{'The current %s could not be determined.'} = '';
    $Self->{Translation}->{'The %s of all workorders has to be defined.'} = '';
    $Self->{Translation}->{'Was not able to move time slot for workorder #%s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateDelete.pm
    $Self->{Translation}->{'You need %s permission!'} = '';
    $Self->{Translation}->{'No TemplateID is given!'} = '';
    $Self->{Translation}->{'Template "%s" not found in database!'} = '';
    $Self->{Translation}->{'Was not able to delete the template %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEdit.pm
    $Self->{Translation}->{'Was not able to update Template %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditCAB.pm
    $Self->{Translation}->{'Was not able to update Template "%s"!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditContent.pm
    $Self->{Translation}->{'Was not able to create change!'} = '';
    $Self->{Translation}->{'Was not able to create workorder from template!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateOverview.pm
    $Self->{Translation}->{'Overview: Template'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAdd.pm
    $Self->{Translation}->{'You need %s permissions on the change!'} = '';
    $Self->{Translation}->{'Was not able to add workorder!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAgent.pm
    $Self->{Translation}->{'No WorkOrderID is given!'} = '';
    $Self->{Translation}->{'Was not able to set the workorder agent of the workorder "%s" to empty!'} =
        '';
    $Self->{Translation}->{'Was not able to update the workorder "%s"!'} = '';
    $Self->{Translation}->{'Could not find Change for WorkOrder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderDelete.pm
    $Self->{Translation}->{'Was not able to delete the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderEdit.pm
    $Self->{Translation}->{'Was not able to update WorkOrder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no WorkOrderID is given!'} = '';
    $Self->{Translation}->{'WorkOrder "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrderHistory::'} = '';
    $Self->{Translation}->{'WorkOrder History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistoryZoom.pm
    $Self->{Translation}->{'History entry "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrder History Zoom'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTake.pm
    $Self->{Translation}->{'Was not able to take the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTemplate.pm
    $Self->{Translation}->{'The workorder "%s" could not be serialized.'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyWorkOrders.pm
    $Self->{Translation}->{'My Work Orders'} = '';

}

1;
