# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ja_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        '本当に該当日の情報を削除しますか？';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'タイムレコードの編集';
    $Self->{Translation}->{'Go to settings'} = '設定へ';
    $Self->{Translation}->{'Date Navigation'} = '日別ナビゲーション';
    $Self->{Translation}->{'Days without entries'} = 'エントリーのない日';
    $Self->{Translation}->{'Select all days'} = '全ての日を選択';
    $Self->{Translation}->{'Mass entry'} = '全体入力';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        '該当の日の欠勤理由を入力してください';
    $Self->{Translation}->{'On vacation'} = '休暇取得中';
    $Self->{Translation}->{'On sick leave'} = '病欠中';
    $Self->{Translation}->{'On overtime leave'} = '代休中';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = '* の項目は入力必須です。';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = '開始時間と終了時間、または期間を指定してください。';
    $Self->{Translation}->{'Project'} = 'プロジェクト';
    $Self->{Translation}->{'Task'} = 'タスク';
    $Self->{Translation}->{'Remark'} = '注釈';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = '8文字以上の注釈を追加してください。';
    $Self->{Translation}->{'Negative times are not allowed.'} = '－（マイナス）の時間は入力できません';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        '繰り返された時間は許可されません。開始時刻は別の間隔と一致します。';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = '不正なフォーマットです! 時間の入力はHH:MMのフォーマットに従ってください';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '24:00は終了時間としてのみ入力可能です';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = '不正な時間です! 1日は24時間です';
    $Self->{Translation}->{'End time must be after start time.'} = '終了時間の前に開始時間を設定することはできません。';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Diese Endzeit wurde bereits in einem anderen Eintrag angegeben.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = '「期間」の設定が不正です。（24時間以上は許可されません）';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = '「期間」の設定が不正です。（0は許可されません）';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = '「期間」の設定が不正です。（－（マイナス）は許可されません）';
    $Self->{Translation}->{'Add one row'} = '行の追加';
    $Self->{Translation}->{'You can only select one checkbox element!'} = '1項目のみ選択できます。';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = '病欠に設定された期間中に稼働しましたか？';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = '休暇に設定された期間中に稼働しましたか？';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        '代休に設定された期間中に稼働しましたか？';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = '16時間以上稼働しましたか？';

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
    $Self->{Translation}->{'Weekday'} = '曜日';
    $Self->{Translation}->{'Working Hours'} = '稼働時間';
    $Self->{Translation}->{'Total worked hours'} = '総稼働時間';
    $Self->{Translation}->{'User\'s project overview'} = 'ユーザーのプロジェクト一覧';
    $Self->{Translation}->{'Hours (monthly)'} = '時間（今月）';
    $Self->{Translation}->{'Hours (Lifetime)'} = '時間（通算）';
    $Self->{Translation}->{'Grand total'} = '合計';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = '時間会計レポート';
    $Self->{Translation}->{'Month Navigation'} = '月別ナビゲーション';
    $Self->{Translation}->{'Go to date'} = '日付に移動する';
    $Self->{Translation}->{'User reports'} = 'ユーザ・レポート';
    $Self->{Translation}->{'Monthly total'} = '月合計';
    $Self->{Translation}->{'Lifetime total'} = '通算合計';
    $Self->{Translation}->{'Overtime leave'} = '代休';
    $Self->{Translation}->{'Vacation'} = '休暇';
    $Self->{Translation}->{'Sick leave'} = '病欠';
    $Self->{Translation}->{'Vacation remaining'} = '休日残日数';
    $Self->{Translation}->{'Project reports'} = 'プロジェクト・レポート';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'プロジェクト・レポート';
    $Self->{Translation}->{'Go to reporting overview'} = '報告の概要に移動する';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        '本プロジェクトのアクティブユーザーのみ表示しています、変更するには設定を更新してください。';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'すべてのタイムアカウントユーザーを表示しています、変更するには設定を更新してください。';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = '時間会計 プロジェクト設定の編集';
    $Self->{Translation}->{'Add project'} = '新規プロジェクトの追加';
    $Self->{Translation}->{'Go to settings overview'} = '設定に移動する';
    $Self->{Translation}->{'Add Project'} = '新規プロジェクトの追加';
    $Self->{Translation}->{'Edit Project Settings'} = 'プロジェクトの編集';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        '同名のプロジェクトが存在します。名称を変更してください。';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = '設定の編集';
    $Self->{Translation}->{'Add task'} = '新規タスクの追加';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = 'プロジェクト、タスク、またはユーザーのフィルタリング';
    $Self->{Translation}->{'Time periods can not be deleted.'} = '時間は削除できません';
    $Self->{Translation}->{'Project List'} = 'プロジェクト一覧';
    $Self->{Translation}->{'Task List'} = 'タスク一覧';
    $Self->{Translation}->{'Add Task'} = '新規タスクの追加';
    $Self->{Translation}->{'Edit Task Settings'} = 'タスク設定';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        '同名のタスクが存在します。名称を変更してください。';
    $Self->{Translation}->{'User List'} = 'ユーザ一覧';
    $Self->{Translation}->{'User Settings'} = 'ユーザー設定';
    $Self->{Translation}->{'User is allowed to see overtimes'} = 'ユーザーはオーバータイムを見ることができます。';
    $Self->{Translation}->{'Show Overtime'} = '超過勤務を表示';
    $Self->{Translation}->{'User is allowed to create projects'} = 'ユーザーはプロジェクトを作成できます。';
    $Self->{Translation}->{'Allow project creation'} = 'プロジェクトの新規追加を許可する';
    $Self->{Translation}->{'Time Spans'} = '期間';
    $Self->{Translation}->{'Period Begin'} = '開始点';
    $Self->{Translation}->{'Period End'} = '終了点';
    $Self->{Translation}->{'Days of Vacation'} = '休暇';
    $Self->{Translation}->{'Hours per Week'} = '時間 / 週';
    $Self->{Translation}->{'Authorized Overtime'} = '承認済の超過勤務';
    $Self->{Translation}->{'Start Date'} = 'スタート日付';
    $Self->{Translation}->{'Please insert a valid date.'} = '正しい日付を入力してください';
    $Self->{Translation}->{'End Date'} = '終了時間';
    $Self->{Translation}->{'Period end must be after period begin.'} = '終了点の前に開始点を設定することはできません。';
    $Self->{Translation}->{'Leave Days'} = '休暇日数';
    $Self->{Translation}->{'Weekly Hours'} = '週あたりの時間';
    $Self->{Translation}->{'Overtime'} = '残業時間';
    $Self->{Translation}->{'No time periods found.'} = '期間が未設定です。';
    $Self->{Translation}->{'Add time period'} = '期間を追加してください。';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'タイム・レコードを表示';
    $Self->{Translation}->{'View of '} = '一覧';
    $Self->{Translation}->{'Previous day'} = '前の日';
    $Self->{Translation}->{'Next day'} = '次の日';
    $Self->{Translation}->{'No data found for this day.'} = '該当するデータがありません。';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = '工数を挿入できません！';
    $Self->{Translation}->{'Last Projects'} = '前プロジェクト';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = '不正な時間です! 1日は24時間です';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = '工数を削除できません！';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        '入力された日付は期間外ですので、挿入する事はできませんでした。もう一度(!)日付を入力してください。';
    $Self->{Translation}->{'Incomplete Working Days'} = '未完了の可動日';
    $Self->{Translation}->{'Please insert your working hours!'} = '勤務実績を入力してください';
    $Self->{Translation}->{'Successful insert!'} = '入力に成功しました!';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = '複数日を入力中にエラーが発生しました !';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = '複数日にわたる稼働実績の入力に成功しました !';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = '入力された日付は不正です ! 日付は本日に変更されました';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        '指定された期間が設定されていないか、または指定された日付が定義された期間外です。';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        '勤怠管理担当者に連絡して期間を更新してください！';
    $Self->{Translation}->{'Last Selected Projects'} = '前回選択されたプロジェクト';
    $Self->{Translation}->{'All Projects'} = '全プロジェクト';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = 'ReportingProject: プロジェクトIDの入力が必要です。';
    $Self->{Translation}->{'Reporting Project'} = 'プロジェクトを報告する';
    $Self->{Translation}->{'Reporting'} = '報告する';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = 'ユーザー設定を更新できません！';
    $Self->{Translation}->{'Project added!'} = 'プロジェクトを追加しました！';
    $Self->{Translation}->{'Project updated!'} = 'プロジェクトを更新しました！';
    $Self->{Translation}->{'Task added!'} = 'タスクを追加しました！';
    $Self->{Translation}->{'Task updated!'} = 'タスクを更新しました！';
    $Self->{Translation}->{'The UserID is not valid!'} = 'UserID が無効です！';
    $Self->{Translation}->{'Can\'t insert user data!'} = 'ユーザーデータが挿入できません！';
    $Self->{Translation}->{'Unable to add time period!'} = '期間を追加できません！';
    $Self->{Translation}->{'Setting'} = '設定';
    $Self->{Translation}->{'User updated!'} = 'ユーザーを更新しました！';
    $Self->{Translation}->{'User added!'} = 'ユーザーを追加しました！';
    $Self->{Translation}->{'Add a user to time accounting...'} = 'タイムアカウンティングにユーザーを追加...';
    $Self->{Translation}->{'New User'} = '新規ユーザー';
    $Self->{Translation}->{'Period Status'} = '期間の状態';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = '注目！： %s の入力が必要です。';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = '未完了の可動日';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = '少なくとも一日は選択してください';
    $Self->{Translation}->{'Mass Entry'} = '全体入力';
    $Self->{Translation}->{'Please choose a reason for absence!'} = '欠勤理由を選択してください';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'エントリーを削除';
    $Self->{Translation}->{'Confirm insert'} = '挿入の確認';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'ユーザの不完全な稼働日数をカウントし通知するエージェント・インターフェイスです。';
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
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        '「注釈」エントリーを必要とする項目を定義します。 もしプロジェクト名がここで設定した正規表現にマッチする場合、「注釈｝は必須項目となります。※正規表現にはSMXパラメータを使います。';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        '統計モジュールがタイムアカウンティング情報を生成するか選択してください';
    $Self->{Translation}->{'Edit time accounting settings.'} = '時間会計の設定を編集';
    $Self->{Translation}->{'Edit time record.'} = 'タイムレコードを編集';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = '何日前からワーキング・ユニットの新規登録が可能であるかの設定です。';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        '有効時には、該当のプロジェクトに稼働時間を投入しているユーザーのみ表示されます';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        '有効時には、編集画面のドロップダウンエレメントは自動フィールドに置き換えられます。';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        '有効時には以前のプロジェクトフィルターを選択することが可能です(通常は前回およびすべて)。この項目は TimeAccounting::EnableAutoCompletion が有効になっている時のみ利用可能';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        '有効時には「以前のプロジェクト」が存在する時は、以前のプロジェクトフィルターがデフォルト値になります。この項目は TimeAccounting::UseFilter が有効になっている時のみ利用可能';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        '有効にすれば一回の編集で、複数の日に渡り「休暇」「病欠」「代休」が選択できます';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        '1つ以上のワーキング・ユニットを設定すべき最大の稼働日数。';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        '警告が表示されることなくエントリ出来る、営業日の最大日数。';
    $Self->{Translation}->{'Overview.'} = '概要';
    $Self->{Translation}->{'Project time reporting.'} = 'プロジェクト別時間会計レポート';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'プロジェクトによって行動リストを絞り込むための正規表現。「鍵」ではプロジェクトに対する正規表現を、「内容」では`行動`に対する正規表現を指定する。';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'ユーザグループによってプロジェクトリストを絞り込むための正規表現。「鍵」ではプロジェクトに対する正規表現を、「内容」ではカンマ区切りのユーザリストを指定する。';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        '業務時間を「開始時間」と「終了時間」の指定ナシで新規登録できるかどうか指定する。';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'TimeAccountingモジュールと同等の項目が設定必須となります。';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'あまりにも多くの不完全な稼働日がある場合、この通知モジュールは警告を与えます。';
    $Self->{Translation}->{'Time Accounting'} = 'タイムアカウンティング';
    $Self->{Translation}->{'Time accounting edit.'} = 'タイムアカウンティングを編集する';
    $Self->{Translation}->{'Time accounting overview.'} = 'タイムアカウンティングの概要';
    $Self->{Translation}->{'Time accounting reporting.'} = 'タイムアカウンティングの報告';
    $Self->{Translation}->{'Time accounting settings.'} = 'タイムアカウンティングの設定';
    $Self->{Translation}->{'Time accounting view.'} = 'タイムアカウンティング ビュー';
    $Self->{Translation}->{'Time accounting.'} = '時間会計';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        '業務上の行動において、稼働時間として計上する時間を調整する必要がある場合に、この設定を使用します。（例：「移動時間」の50%のみ勤務時間相当とする場合「鍵」に`journey`、「内容」に`50`と設定)';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Confirm insert',
    'Delete Time Accounting Entry',
    'Mass Entry',
    'No',
    'Please choose a reason for absence!',
    'Please choose at least one day!',
    'Submit',
    'Yes',
    );

}

1;
