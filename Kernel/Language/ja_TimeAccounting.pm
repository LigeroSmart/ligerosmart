# --
# Kernel/Language/ja_TimeAccounting.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# Copyright (C) 2011/12/08 Kaoru Hayama TIS Inc.
# --
# $Id: ja_TimeAccounting.pm,v 1.1 2011-12-19 12:14:41 mn Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ja_TimeAccounting;

use strict;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} = '本当に該当日の情報を削除しますか？';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'タイムレコードの編集';
    $Self->{Translation}->{'Project settings'} = 'プロジェクトの編集';
    $Self->{Translation}->{'Date Navigation'} = '日別ナビゲーション';
    $Self->{Translation}->{'Previous day'} = '前の日';
    $Self->{Translation}->{'Next day'} = '次の日';
    $Self->{Translation}->{'Days without entries'} = 'エントリーのない日';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = '* の項目は入力必須です。';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = '開始時間と終了時間、または期間を指定してください。';
    $Self->{Translation}->{'Project'} = 'プロジェクト';
    $Self->{Translation}->{'Task'} = 'タスク';
    $Self->{Translation}->{'Remark'} = '注釈';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!.'} = '8文字以上の注釈を追加してください。';
    $Self->{Translation}->{'Negative times are not allowed.'} = '－（マイナス）の時間は入力できません';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} = '繰り返された時間は許可されません。開始時刻は別の間隔と一致します。';
    $Self->{Translation}->{'End time must be after start time.'} = '終了時間の前に開始時間を設定することはできません。';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} = 'Diese Endzeit wurde bereits in einem anderen Eintrag angegeben.';
    $Self->{Translation}->{'Period is bigger than the interval between start and end times!'} = '「期間」の設定が不正です。開始時間と終了時間の範囲を超過しています。';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = '「期間」の設定が不正です。（24時間以上は許可されません）';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = '「期間」の設定が不正です。（0は許可されません）';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = '「期間」の設定が不正です。（－（マイナス）は許可されません）';
    $Self->{Translation}->{'Add one row'} = '行の追加';
    $Self->{Translation}->{'Total'} = '計';
    $Self->{Translation}->{'On vacation'} = '休暇取得中';
    $Self->{Translation}->{'You can only select one checkbox element!'} = '1項目のみ選択できます。';
    $Self->{Translation}->{'On sick leave'} = '病欠中';
    $Self->{Translation}->{'On overtime leave'} = '代休中';
    $Self->{Translation}->{'Show all items'} = 'すべてのアイテムを表示';
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'エントリーを削除';
    $Self->{Translation}->{'Confirm insert'} = '挿入の確認';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = '病欠に設定された期間中に稼働しましたか？';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = '休暇に設定された期間中に稼働しましたか？';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} = '代休に設定された期間中に稼働しましたか？';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = '16時間以上稼働しましたか？';
    $Self->{Translation}->{'Select all days'} = '全ての日を選択';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = '月別一覧';
    $Self->{Translation}->{'Overtime (Hours)'} = '超過勤務（：時間）';
    $Self->{Translation}->{'Overtime (this month)'} = '超過勤務（今月）';
    $Self->{Translation}->{'Overtime (total)'} = '超過勤務（累計）';
    $Self->{Translation}->{'Remaining overtime leave'} = '超過勤務可能残（時間）';
    $Self->{Translation}->{'Vacation (Days)'} = '休暇（日数）';
    $Self->{Translation}->{'Vacation taken (this month)'} = '休暇取得日数（今月）';
    $Self->{Translation}->{'Vacation taken (total)'} = '休暇取得日数（累計）';
    $Self->{Translation}->{'Remaining vacation'} = '休暇取得残日数';
    $Self->{Translation}->{'Sick Leave (Days)'} = '病欠（日数）';
    $Self->{Translation}->{'Sick leave taken (this month)'} = '病欠日数（今月）';
    $Self->{Translation}->{'Sick leave taken (total)'} = '病欠日数（累計）';
    $Self->{Translation}->{'Previous month'} = '前月';
    $Self->{Translation}->{'Next month'} = '次月';
    $Self->{Translation}->{'Day'} = '日';
    $Self->{Translation}->{'Weekday'} = '曜日';
    $Self->{Translation}->{'Working Hours'} = '稼働時間';
    $Self->{Translation}->{'Total worked hours'} = '総稼働時間';
    $Self->{Translation}->{'User\'s project overview'} = 'ユーザのプロジェクト一覧';
    $Self->{Translation}->{'Hours (monthly)'} = '時間（今月）';
    $Self->{Translation}->{'Hours (Lifetime)'} = '時間（通算）';
    $Self->{Translation}->{'Grand total'} = '合計';

    # Template: AgentTimeAccountingProjectReporting
    $Self->{Translation}->{'Project report'} = 'プロジェクト・レポート';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = '時間会計レポート';
    $Self->{Translation}->{'Month Navigation'} = '月別ナビゲーション';
    $Self->{Translation}->{'User reports'} = 'ユーザ・レポート';
    $Self->{Translation}->{'Monthly total'} = '月合計';
    $Self->{Translation}->{'Lifetime total'} = '通算合計';
    $Self->{Translation}->{'Overtime leave'} = '代休';
    $Self->{Translation}->{'Vacation'} = '休暇';
    $Self->{Translation}->{'Sick leave'} = '病欠';
    $Self->{Translation}->{'LeaveDay Remaining'} = '休日残日数';
    $Self->{Translation}->{'Project reports'} = 'プロジェクト・レポート';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = '時間会計 プロジェクト設定の編集';
    $Self->{Translation}->{'Add Project'} = '新規プロジェクトの追加';
    $Self->{Translation}->{'Add project'} = '新規プロジェクトの追加';
    $Self->{Translation}->{'Edit Project Settings'} = 'プロジェクトの編集';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} = '同名のプロジェクトが存在します。名称を変更してください。';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = '設定の編集';
    $Self->{Translation}->{'Add Task'} = '新規タスクの追加';
    $Self->{Translation}->{'Add task'} = '新規タスクの追加';
    $Self->{Translation}->{'New user'} = '新規ユーザ';
    $Self->{Translation}->{'Filter for Projects'} = 'プロジェクトの絞り込み';
    $Self->{Translation}->{'Filter for Tasks'} = 'タスクの絞り込み';
    $Self->{Translation}->{'Filter for Users'} = 'ユーザの絞り込み';
    $Self->{Translation}->{'Project List'} = 'プロジェクト一覧';
    $Self->{Translation}->{'Task List'} = 'タスク一覧';
    $Self->{Translation}->{'Edit Task Settings'} = 'タスク設定';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} = '同名のタスクが存在します。名称を変更してください。';
    $Self->{Translation}->{'User List'} = 'ユーザ一覧';
    $Self->{Translation}->{'New User Settings'} = '新規ユーザ設定';
    $Self->{Translation}->{'Edit User Settings'} = 'ユーザ設定の編集';
    $Self->{Translation}->{'Comments'} = 'コメント';
    $Self->{Translation}->{'Show Overtime'} = '超過勤務を表示';
    $Self->{Translation}->{'Allow project creation'} = 'プロジェクトの新規追加を許可する';
    $Self->{Translation}->{'Period Begin'} = '開始点';
    $Self->{Translation}->{'Period End'} = '終了点';
    $Self->{Translation}->{'Days of Vacation'} = '休暇';
    $Self->{Translation}->{'Hours per Week'} = '時間 / 週';
    $Self->{Translation}->{'Authorized Overtime'} = '承認済の超過勤務';
    $Self->{Translation}->{'Period end must be after period begin.'} = '終了点の前に開始点を設定することはできません。';
    $Self->{Translation}->{'No time periods found.'} = '期間が未設定です。';
    $Self->{Translation}->{'Add time period'} = '期間を追加してください。';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'タイム・レコードを表示';
    $Self->{Translation}->{'View of '} = '一覧';
    $Self->{Translation}->{'No data found for this day.'} = '該当するデータがありません。';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} = 'ユーザの不完全な稼働日数をカウントし通知するエージェント・インターフェイスです。';
    $Self->{Translation}->{'Default name for new actions.'} = '新規操作に対するデフォルトの名称';
    $Self->{Translation}->{'Default name for new projects.'} = '新規プロジェクトに対するデフォルトの名称';
    $Self->{Translation}->{'Default setting for date end.'} = '「終了日」のデフォルト値';
    $Self->{Translation}->{'Default setting for date start.'} = '「開始日」のデフォルト値';

    $Self->{Translation}->{'Default setting for description.'} = '「説明文」のデフォルト値';

    $Self->{Translation}->{'Default setting for leave days.'} = '「休暇」のデフォルト値';
    $Self->{Translation}->{'Default setting for overtime.'} = '「超過勤務」のデフォルト値';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = '週あたり基本稼働時間のデフォルト値';
    $Self->{Translation}->{'Default status for new actions.'} = '新規操作に対するデフォルトのステータス';
    $Self->{Translation}->{'Default status for new projects.'} = '新規プロジェクトに対するデフォルトのステータス';
    $Self->{Translation}->{'Default status for new users.'} = '新規ユーザに対するデフォルトのステータス';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} = '「注釈」エントリーを必要とする項目を定義します。 もしプロジェクト名がここで設定した正規表現にマッチする場合、「注釈｝は必須項目となります。※正規表現にはSMXパラメータを使います。';
    $Self->{Translation}->{'Edit time accounting settings'} = '時間会計の設定を編集';
    $Self->{Translation}->{'Edit time record'} = 'タイムレコードを編集';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = '何日前からワーキング・ユニットの新規登録が可能であるかの設定です。';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to autocompletion fields.'} = 'この項目を「許可」にすると、編集画面内のプルダウンメニューをオートコンプリート機能付きのフォームに変更します。';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave'} = 'この項目を「許可」にすると、ユーザが休暇申請できるようになります。';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} = '1つ以上のワーキング・ユニットを設定すべき最大の稼働日数。';
    $Self->{Translation}->{'Maximum number of working days withouth working units entry after which a warning will be shown.'} = '1つ以上のワーキング・ユニットが設定されていない場合、アラートを発するべき最大の稼働日数。';
    $Self->{Translation}->{'Project time reporting'} = 'プロジェクト別時間会計レポート';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} = 'プロジェクトによって行動リストを絞り込むための正規表現。「鍵」ではプロジェクトに対する正規表現を、「内容」では`行動`に対する正規表現を指定する。';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} = 'ユーザグループによってプロジェクトリストを絞り込むための正規表現。「鍵」ではプロジェクトに対する正規表現を、「内容」ではカンマ区切りのユーザリストを指定する。';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} = '業務時間を「開始時間」と「終了時間」の指定ナシで新規登録できるかどうか指定する。';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'TimeAccountingモジュールと同等の項目が設定必須となります。';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} = 'あまりにも多くの不完全な稼働日がある場合、この通知モジュールは警告を与えます。';
    $Self->{Translation}->{'Time accounting.'} = '時間会計';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} = '業務上の行動において、稼働時間として計上する時間を調整する必要がある場合に、この設定を使用します。（例：「移動時間」の50%のみ勤務時間相当とする場合「鍵」に`journey`、「内容」に`50`と設定)';

    $Self->{Translation}->{'Mon'} = '月';
    $Self->{Translation}->{'Tue'} = '火';
    $Self->{Translation}->{'Wed'} = '水';
    $Self->{Translation}->{'Thu'} = '木';
    $Self->{Translation}->{'Fri'} = '金';
    $Self->{Translation}->{'Sat'} = '土';
    $Self->{Translation}->{'Sun'} = '日';
    $Self->{Translation}->{'January'} = '1月';
    $Self->{Translation}->{'February'} = '2月';
    $Self->{Translation}->{'March'} = '3月';
    $Self->{Translation}->{'April'} = '4月';
    $Self->{Translation}->{'May'} = '5月';
    $Self->{Translation}->{'June'} = '6月';
    $Self->{Translation}->{'July'} = '7月';
    $Self->{Translation}->{'August'} = '8月';
    $Self->{Translation}->{'September'} = '9月';
    $Self->{Translation}->{'October'} = '10月';
    $Self->{Translation}->{'November'} = '11月';
    $Self->{Translation}->{'December'} = '12月';

    $Self->{Translation}->{'Show all projects'} = 'すべてのプロジェクトを表示';
    $Self->{Translation}->{'Show valid projects'} = '有効なプロジェクトを表示';
    $Self->{Translation}->{'TimeAccounting'} = '時間会計';
    $Self->{Translation}->{'Actions'} = '操作';
    $Self->{Translation}->{'User updated!'} = 'ユーザ情報が更新されました';
    $Self->{Translation}->{'User added!'} = 'ユーザ情報が追加されました';
    $Self->{Translation}->{'Project added!'} = 'プロジェクトが追加されました';
    $Self->{Translation}->{'Project updated!'} = 'プロジェクトが更新されました';
    $Self->{Translation}->{'Task added!'} = 'タスクが追加されました';
    $Self->{Translation}->{'Task updated!'} = 'タスクが更新されました';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Can\'t delete Working Units!'} = 'ワーキング・ユニットを削除できません';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = '時間指定が不正です。設定を保存できませんでした。';
    $Self->{Translation}->{'Please insert your working hours!'} = '稼働時間を入力してください。';
    $Self->{Translation}->{'Reporting'} = '結果表示';
    $Self->{Translation}->{'Successful insert!'} = '挿入が成功しました。';

}

1;
