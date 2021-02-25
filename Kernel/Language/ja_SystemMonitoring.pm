# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ja_SystemMonitoring;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run AFTER PostMasterFilter.'} =
        'System Monitoring Suiteへの基本的なメールインターフェース。 ポストマスターフィルターの後にフィルタを実行する必要がある場合は、このブロックを使用します。';
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run BEFORE PostMasterFilter.'} =
        'System Monitoring Suiteへの基本的なメールインターフェース。 ポストマスターフィルターの前にフィルタを実行する必要がある場合は、このブロックを使用します。';
    $Self->{Translation}->{'Define Nagios acknowledge type.'} = 'Nagiosの確認タイプを定義します。';
    $Self->{Translation}->{'HTTP'} = 'HTTP';
    $Self->{Translation}->{'Icinga API URL.'} = 'Icinga API の URL';
    $Self->{Translation}->{'Icinga2 acknowledgement author.'} = 'Icinga2承認著者';
    $Self->{Translation}->{'Icinga2 acknowledgement comment.'} = 'Icinga2承認コメント';
    $Self->{Translation}->{'Icinga2 acknowledgement enabled?'} = 'Icinga2確認応答が有効になっていますか？';
    $Self->{Translation}->{'Icinga2 acknowledgement notify.'} = 'Icinga2承認通知';
    $Self->{Translation}->{'Icinga2 acknowledgement sticky.'} = 'Icinga2の応答はスティッキーです。';
    $Self->{Translation}->{'Link an already opened incident ticket with the affected CI. This is only possible when a subsequent system monitoring email arrives.'} =
        '既に開かれているインシデントチケットを影響を受けるCIにリンクします。 これは、後続のシステム監視電子メールが到着したときにのみ可能です。';
    $Self->{Translation}->{'Name of the Dynamic Field for Host.'} = 'ホストのダイナミック・フィールドの名前。';
    $Self->{Translation}->{'Name of the Dynamic Field for Service.'} = 'サービスのダイナミック・フィールドの名前。';
    $Self->{Translation}->{'Named pipe acknowledge command.'} = 'コマンドパイプ承認形式';
    $Self->{Translation}->{'Named pipe acknowledge format for host.'} = 'ホストの名前付きパイプ承認形式';
    $Self->{Translation}->{'Named pipe acknowledge format for service.'} = 'サービスの名前付きパイプ承認形式';
    $Self->{Translation}->{'Set the incident state of a CI automatically when a system monitoring email arrives.'} =
        'システム監視メールを受信すると、CIのインシデント・ステータスを自動的に設定します。';
    $Self->{Translation}->{'The HTTP acknowledge URL.'} = 'HTTP認証URL';
    $Self->{Translation}->{'The HTTP acknowledge password.'} = 'HTTP認証パスワード';
    $Self->{Translation}->{'The HTTP acknowledge user.'} = 'HTTP認証ユーザー';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Icinga2.'} = 'チケットイベントモジュールは、Icinga2に確認応答を送信します。';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Nagios.'} = 'Nagiosに認証を送信するチケットイベントモジュール';
    $Self->{Translation}->{'pipe'} = 'パイプ';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
