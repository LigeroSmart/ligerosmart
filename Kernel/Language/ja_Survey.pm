# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ja_Survey;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = '新規アンケートの作成';
    $Self->{Translation}->{'Introduction'} = '紹介文';
    $Self->{Translation}->{'Survey Introduction'} = 'アンケートの紹介文';
    $Self->{Translation}->{'Notification Body'} = '通知の本文';
    $Self->{Translation}->{'Ticket Types'} = 'チケットタイプ';
    $Self->{Translation}->{'Internal Description'} = '内部向け説明';
    $Self->{Translation}->{'Customer conditions'} = 'お客様の条件';
    $Self->{Translation}->{'Please choose a Customer property to add a condition.'} = '条件を追加するには、顧客プロパティを選択して下さい。';
    $Self->{Translation}->{'Public survey key'} = '公開アンケートキー';
    $Self->{Translation}->{'Example survey'} = 'アンケート例';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = '一般情報の編集';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = '質問の編集';
    $Self->{Translation}->{'You are here'} = 'あなたの現在地';
    $Self->{Translation}->{'Survey Questions'} = 'アンケート質問';
    $Self->{Translation}->{'Add Question'} = '質問の追加';
    $Self->{Translation}->{'Type the question'} = '質問の入力';
    $Self->{Translation}->{'Answer required'} = '回答必須です';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'このアンケートに対する質問が保存されていません。';
    $Self->{Translation}->{'Question'} = '質問';
    $Self->{Translation}->{'Answer Required'} = '回答が必須の項目です';
    $Self->{Translation}->{'When you finish to edit the survey questions just close this screen.'} =
        'このアンケートの設問を編集したら、画面を閉じて下さい。';
    $Self->{Translation}->{'Close this window'} = 'このウインドウを閉じて下さい。';
    $Self->{Translation}->{'Edit Question'} = '質問編集';
    $Self->{Translation}->{'go back to questions'} = '質問へ戻る';
    $Self->{Translation}->{'Question:'} = '設問:';
    $Self->{Translation}->{'Possible Answers For'} = '選択肢';
    $Self->{Translation}->{'Add Answer'} = '回答の追加';
    $Self->{Translation}->{'No answers saved for this question.'} = 'この質問への回答はまだありません';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'この質問には選択肢がありません。テキストエリアが表示されます。';
    $Self->{Translation}->{'Edit Answer'} = '回答の編集';
    $Self->{Translation}->{'go back to edit question'} = '質問の編集に戻る';
    $Self->{Translation}->{'Answer:'} = '回答:';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Survey overview options'} = 'アンケートの概要オプション';
    $Self->{Translation}->{'Searches in the attributes Number, Title, Introduction, Description, NotificationSender, NotificationSubject and NotificationBody, overriding other attributes with the same name.'} =
        'Number、Title、Introduction、Description、NotificationSender、NotificationSubject、NotificationBodyの各属性を検索し、同じ名前の他の属性をオーバーライドします。';
    $Self->{Translation}->{'Survey Create Time'} = 'アンケート作成時間';
    $Self->{Translation}->{'No restriction'} = '制限なし';
    $Self->{Translation}->{'Only surveys created between'} = '期間に作成されたアンケートのみ';
    $Self->{Translation}->{'Max. shown surveys per page'} = 'ページあたりの最大数';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = '通知の送信者';
    $Self->{Translation}->{'Notification Subject'} = '通知の件名';
    $Self->{Translation}->{'Changed By'} = '更新者';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = '統計一覧';
    $Self->{Translation}->{'Requests Table'} = '回答一覧';
    $Self->{Translation}->{'Select all requests'} = '全てのリクエストを選択して下さい。';
    $Self->{Translation}->{'Send Time'} = '送信日時';
    $Self->{Translation}->{'Vote Time'} = '返信日時';
    $Self->{Translation}->{'Select this request'} = 'このリクエストを選択して下さい。';
    $Self->{Translation}->{'See Details'} = '詳細を確認';
    $Self->{Translation}->{'Delete stats'} = '統計を削除';
    $Self->{Translation}->{'Survey Stat Details'} = 'アンケート統計の詳細';
    $Self->{Translation}->{'go back to stats overview'} = '統計一覧に戻る';
    $Self->{Translation}->{'Previous vote'} = '前の投票';
    $Self->{Translation}->{'Next vote'} = '次の投票';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'アンケートの情報';
    $Self->{Translation}->{'Sent requests'} = '送信数';
    $Self->{Translation}->{'Received surveys'} = '返信数';
    $Self->{Translation}->{'Survey Details'} = 'アンケートの詳細';
    $Self->{Translation}->{'Ticket Services'} = 'チケット・サービス';
    $Self->{Translation}->{'Survey Results Graph'} = 'アンケート結果のグラフ';
    $Self->{Translation}->{'No stat results.'} = '統計結果がありません。';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'アンケート';
    $Self->{Translation}->{'Please answer these questions'} = 'これらの質問に回答してください。';
    $Self->{Translation}->{'Show my answers'} = '過去の回答を表示';
    $Self->{Translation}->{'These are your answers'} = 'これらは過去に回答されたものです。';
    $Self->{Translation}->{'Survey Title'} = 'アンケートのタイトル';

    # Perl Module: Kernel/Modules/AgentSurveyAdd.pm
    $Self->{Translation}->{'Add New Survey'} = '新規アンケートの追加';

    # Perl Module: Kernel/Modules/AgentSurveyEdit.pm
    $Self->{Translation}->{'You have no permission for this survey!'} = 'あなたはこのアンケートの権限がありません！';
    $Self->{Translation}->{'No SurveyID is given!'} = 'SurveyIDが指定されていません！';
    $Self->{Translation}->{'Survey Edit'} = 'アンケートの編集';

    # Perl Module: Kernel/Modules/AgentSurveyEditQuestions.pm
    $Self->{Translation}->{'You have no permission for this survey or question!'} = 'あなたはこのアンケートや質問の権限がありません！';
    $Self->{Translation}->{'You have no permission for this survey, question or answer!'} = 'あなたはこのアンケート、質問、または回答の権限がありません！';
    $Self->{Translation}->{'Survey Edit Questions'} = 'アンケートの質問を編集';
    $Self->{Translation}->{'Yes/No'} = 'はい/いいえ';
    $Self->{Translation}->{'Radio (List)'} = 'ラジオボタン (一覧)';
    $Self->{Translation}->{'Checkbox (List)'} = 'チェックボックス (一覧)';
    $Self->{Translation}->{'Net Promoter Score'} = 'ネット・プロモーター・スコア';
    $Self->{Translation}->{'Question Type'} = '質問タイプ';
    $Self->{Translation}->{'Complete'} = '完成';
    $Self->{Translation}->{'Incomplete'} = '未完成';
    $Self->{Translation}->{'Question Edit'} = '質問の編集';
    $Self->{Translation}->{'Answer Edit'} = '回答の編集';

    # Perl Module: Kernel/Modules/AgentSurveyStats.pm
    $Self->{Translation}->{'Stats Overview'} = '統計一覧';
    $Self->{Translation}->{'You have no permission for this survey or stats detail!'} = 'あなたは、このアンケートまたは詳細ステータスへの権限がありません！';
    $Self->{Translation}->{'Stats Detail'} = '統計の詳細';

    # Perl Module: Kernel/Modules/AgentSurveyZoom.pm
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = '新しい状態を設定できません! 質問が定義されていません。';
    $Self->{Translation}->{'Can\'t set new status! Questions incomplete.'} = '新しい状態を設定できません! 設問が不完全です。';
    $Self->{Translation}->{'Status changed.'} = '状態が変更されました。';
    $Self->{Translation}->{'- No queue selected -'} = 'キューが選択されていません';
    $Self->{Translation}->{'- No ticket type selected -'} = '- チケットタイプを選択してください -';
    $Self->{Translation}->{'- No ticket service selected -'} = '- チケットサービスを選択してください -';
    $Self->{Translation}->{'- Change Status -'} = '- ステータス変更 -';
    $Self->{Translation}->{'Master'} = 'マスター';
    $Self->{Translation}->{'Invalid'} = '無効';
    $Self->{Translation}->{'New Status'} = '新しい状況';
    $Self->{Translation}->{'Survey Description'} = 'アンケートの説明';
    $Self->{Translation}->{'answered'} = '回答あり';
    $Self->{Translation}->{'not answered'} = '回答なし';

    # Perl Module: Kernel/Modules/PublicSurvey.pm
    $Self->{Translation}->{'Thank you for your feedback.'} = 'フィードバックいただきありがとうございました。';
    $Self->{Translation}->{'The survey is finished.'} = 'アンケートが完了しました。';
    $Self->{Translation}->{'Survey Message!'} = 'アンケートのメッセージ!';
    $Self->{Translation}->{'Module not enabled.'} = 'モジュールが有効になっていません。';
    $Self->{Translation}->{'This functionality is not enabled, please contact your administrator.'} =
        'この機能は有効になっていません。管理者に連絡して下さい。';
    $Self->{Translation}->{'Survey Error!'} = '調査のエラー！';
    $Self->{Translation}->{'Invalid survey key.'} = 'アンケート・キーが無効です。';
    $Self->{Translation}->{'The inserted survey key is invalid, if you followed a link maybe this is obsolete or broken.'} =
        '挿入されたアンケート・キーは無効です。リンクをたどった場合、これは時代遅れであるか破損している可能性があります。';
    $Self->{Translation}->{'Survey Vote'} = 'アンケート投票';
    $Self->{Translation}->{'Survey Vote Data'} = 'アンケート投票データ';
    $Self->{Translation}->{'You have already answered the survey.'} = 'アンケートに回答済みです。';

    # Perl Module: Kernel/System/Stats/Dynamic/SurveyList.pm
    $Self->{Translation}->{'Survey List'} = 'アンケート・リスト';

    # JS File: Survey.Agent.SurveyEditQuestions
    $Self->{Translation}->{'Do you really want to delete this question? ALL associated data will be LOST!'} =
        'この質問を本当に削除してもいいですか？　関連しているすべてのデーターが失われます!';
    $Self->{Translation}->{'Do you really want to delete this answer?'} = '本当にこの答えを削除してもいいですか？';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'アンケート・モジュール';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'アンケート質問を編集するモジュール';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        '担当者インタフェースにおけるアンケート・オブジェクトに対する全てのパラメータ';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        'アンケートメールを送信した後、同じ顧客に新しい調査要求が送信されない日数。';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        '新しいアンケートについて顧客に通知するメールの本文のデフォルト';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        '新しいアンケートをについて顧客に通知するメールの送信者のデフォルト';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        '新しいアンケートをについて顧客に通知するメールの件名のデフォルト';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'アンケート一覧(S)を表示するための一覧モジュールの定義';
    $Self->{Translation}->{'Defines groups which have a permission to change survey status. Array is empty by default and agents from all groups can change survey status.'} =
        'アンケートのステータスを変更する権限を持つグループを定義します。 アレイはデフォルトでは空で、全てのグループの担当者がアンケートのステータスを変更できます。';
    $Self->{Translation}->{'Defines if survey requests will be only send to real customers.'} =
        'アンケートが実際の顧客に送信されるかどうかを定義します。';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        '30日の間に顧客に送信する調査の最大数を定義します。(0は無制限を意味し、全ての調査要求が送信されます)';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ). Note: delayed survey sending is done by the OTRS Daemon, prior activation of \'Daemon::SchedulerCronTaskManager::Task###SurveyRequestsSend\' setting.'} =
        'アンケートの送信をトリガーするためにチケットをクローズする時間数を定義します（0はクローズ直後に送信されます）。 注：遅延アンケート送信は、OTRSデーモンによって実行され、事前に \'Daemon :: SchedulerCronTaskManager :: Task ### SurveyRequestsSend\'の設定が有効になっています。';
    $Self->{Translation}->{'Defines the columns for the dropdown list for building send conditions (0 => inactive, 1 => active).'} =
        '送信条件を作成するためのドロップダウンリストの列を定義します。（0 =>無効、1 =>有効）';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        '調査拡大画面の要素に対してリッチテキストに対するデフォルトの高さを定義します。';
    $Self->{Translation}->{'Defines the groups (rw) which can delete survey stats.'} = 'アンケート統計を削除できるグループ（rw）を定義します。';
    $Self->{Translation}->{'Defines the maximum height for Richtext views for SurveyZoom elements.'} =
        'SurveyZoom要素のリッチテキストビューの最大高さを定義します。';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        'アンケート一覧で表示される列数を定義します。このオプションは列の位置には作用しません。';
    $Self->{Translation}->{'Determines if the statistics module may generate survey lists.'} =
        '統計モジュールが調査リストを生成するかどうかを決定します。';
    $Self->{Translation}->{'Edit survey general information.'} = 'アンケート一般情報を編集';
    $Self->{Translation}->{'Edit survey questions.'} = 'アンケートの質問を修正';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        '公開インターフェースにおいて、顧客が2度回答しようとした際に、これまでの回答データを表示するShowVoteData画面を有効にするか否か';
    $Self->{Translation}->{'Enable or disable the send condition check for the service.'} = 'サービスの送信条件を有効または無効にする。';
    $Self->{Translation}->{'Enable or disable the send condition check for the ticket type.'} =
        'ティケットタイプの送信条件を有効または無効にする。';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        '担当者インタフェースの統計フロントエンド・モジュールの登録です。';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        '担当者インタフェースの統計の変更画面フロントエンド・モジュールの登録です。';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        '担当者インタフェースの統計状況フロントエンド・モジュールの登録です。';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        '担当者インターフェースの調査拡大に対するフロントエンド・モジュールの登録です。';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        '公開インターフェースのPublicSurveyオブジェクトに対するフロントエンド・モジュールの登録です。';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'この正規表現にマッチする場合、調査は顧客に送信されません。';
    $Self->{Translation}->{'Limit.'} = 'リミット';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'アンケート一覧 (Small) の (アンケートが表示される) ページに対するパラメータ';
    $Self->{Translation}->{'Public Survey.'} = '公開インターフェースのPublicSurveyオブジェクトに対するフロントエンドモジュール登録です。';
    $Self->{Translation}->{'Results older than the configured amount of days will be deleted. Note: delete results done by the OTRS Daemon, prior activation of \'Task###SurveyRequestsDelete\' setting.'} =
        '設定された日数より古い結果は削除されます。 注： \'Task ### SurveyRequestsDelete\'設定を有効にする前に、OTRSデーモンによって行われた結果を削除して下さい。';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        '担当者インタフェースの統計ズームビューで編集リンクをメニューを表示する。';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        '担当者インタフェースの統計質問ズームビューでの編集リンクをメニューに表示する。';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        '担当者インタフェースのズームビューで表示している統計の編集リンクをメニューを表示する。';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        '担当者インタフェースのズームビューで表示している統計の編集リンクをメニューを表示する。';
    $Self->{Translation}->{'Stats Details'} = '統計の詳細';
    $Self->{Translation}->{'Survey Add Module.'} = 'アンケートモジュール追加';
    $Self->{Translation}->{'Survey Edit Module.'} = 'アンケート編集モジュール';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'アンケート一覧(S)の表示数';
    $Self->{Translation}->{'Survey Stats Module.'} = 'アンケート統計モジュール';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'アンケート・ズーム・モジュール';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small".'} = 'アンケートの一覧「小」に関する1ページあたりのアンケートの上限';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = 'アンケートは設定された電子メールアドレスには送信されません。';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        '例えばSurvey#, MySurvey#などのチケットの識別子です。デフォルトはSurvey#です。';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        'チケットが完了した際に、顧客に自動的に調査メールを送信するチケットイベントモジュール。';
    $Self->{Translation}->{'Trigger delete results (including vote data and requests).'} = '（投票データとリクエストを含む）結果を削除する。';
    $Self->{Translation}->{'Trigger sending delayed survey requests.'} = '追ってのアンケート要求を送信するトリガ';
    $Self->{Translation}->{'Zoom into statistics details.'} = '統計情報の詳細をズームインする。';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Do you really want to delete this answer?',
    'Do you really want to delete this question? ALL associated data will be LOST!',
    'Settings',
    'Submit',
    );

}

1;
