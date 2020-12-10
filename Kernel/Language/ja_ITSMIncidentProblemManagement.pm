# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ja_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketOverviewMedium
    $Self->{Translation}->{'Criticality'} = '重要度';
    $Self->{Translation}->{'Impact'} = '影響度';

    # JS Template: ServiceIncidentState
    $Self->{Translation}->{'Service Incident State'} = 'サービスインシデント状況';

    # Perl Module: Kernel/Output/HTML/FilterElementPost/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Link ticket'} = 'チケットをリンクする';
    $Self->{Translation}->{'Change Decision of %s%s%s'} = '%s%s%sの決定を変更';
    $Self->{Translation}->{'Change ITSM fields of %s%s%s'} = '%s%s%sのITSMフィールドを変更';

    # Perl Module: var/packagesetup/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Review Required'} = 'レビュー必須';
    $Self->{Translation}->{'Decision Result'} = '決定結果';
    $Self->{Translation}->{'Approved'} = '承認';
    $Self->{Translation}->{'Postponed'} = '延期';
    $Self->{Translation}->{'Pre-approved'} = '事前承認済み';
    $Self->{Translation}->{'Rejected'} = '拒否';
    $Self->{Translation}->{'Repair Start Time'} = '修理開始時間';
    $Self->{Translation}->{'Recovery Start Time'} = '回復開始時間';
    $Self->{Translation}->{'Decision Date'} = '決定日付';
    $Self->{Translation}->{'Due Date'} = '対応期限';

    # Database XML Definition: ITSMIncidentProblemManagement.sopm
    $Self->{Translation}->{'closed with workaround'} = 'ワークアラウンドで完了';

    # SysConfig
    $Self->{Translation}->{'Add a decision!'} = '決定を追加する！';
    $Self->{Translation}->{'Additional ITSM Fields'} = '追加のITSM項目';
    $Self->{Translation}->{'Additional ITSM ticket fields.'} = '追加の ITSM チケット･フィールド';
    $Self->{Translation}->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} =
        'エージェントインターフェイスのアディショナルITSM項目画面で追加のノートを許可する';
    $Self->{Translation}->{'Allows adding notes in the decision screen of the agent interface.'} =
        '担当者インタフェースの決定 画面で、メモの追加を許可します。';
    $Self->{Translation}->{'Allows defining new types for ticket (if ticket type feature is enabled).'} =
        'チケットに関して新規タイプを定義することを許可します（チケット責任者機能が有効となっている場合）。';
    $Self->{Translation}->{'Change the ITSM fields!'} = 'ITSM項目を変更する！';
    $Self->{Translation}->{'Decision'} = '決定';
    $Self->{Translation}->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        '';
    $Self->{Translation}->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        '';
    $Self->{Translation}->{'Defines if the service incident state should be shown during service selection in the agent interface.'} =
        '担当者インターフェイスでサービス選択時にサービスインシデント状況を表示するか定義するする';
    $Self->{Translation}->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} =
        '担当者インタフェースの追加のITSMのフィールド画面で用いるデフォルトのメモ本文を定義します。';
    $Self->{Translation}->{'Defines the default body of a note in the decision screen of the agent interface.'} =
        '担当者インタフェースの決定画面で用いるデフォルトのメモ本文を定義します。';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        '担当者インタフェースの追加のITSMのフィールド画面で、メモ追加後の「次の状態」についてデフォルトの選択肢を定義します。';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        '担当者インタフェースの決定画面で、メモ追加後の「次の状態」についてデフォルトの選択肢を定義します。';
    $Self->{Translation}->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} =
        '担当者インターフェイスの追加 ITSMフィールド画面で用いるデフォルトのメモの件名を定義します。';
    $Self->{Translation}->{'Defines the default subject of a note in the decision screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the default ticket priority in the decision screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} =
        '';
    $Self->{Translation}->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} =
        '';
    $Self->{Translation}->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} =
        '';
    $Self->{Translation}->{'Defines the history type for the decision screen action, which gets used for ticket history.'} =
        '';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        '担当者インターフェイスの追加 ITSMフィールド画面で、メモ追加後のチケットの次の状態について選択肢を定義します。';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        '担当者インターフェイスの決定画面で、メモ追加後のチケットの次の状態について選択肢を定義します。';
    $Self->{Translation}->{'Dynamic fields shown in the additional ITSM field screen of the agent interface.'} =
        '担当者インターフェイスの追加 ITSMフィールド画面に表示するダイナミック・フィールド';
    $Self->{Translation}->{'Dynamic fields shown in the decision screen of the agent interface.'} =
        '担当者インターフェイスの決定画面に表示するダイナミック・フィールド';
    $Self->{Translation}->{'Dynamic fields shown in the ticket zoom screen of the agent interface.'} =
        '担当者インターフェイスのチケットズーム画面に表示するダイナミック・フィールド';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} =
        '';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} =
        '';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Modifies the display order of the dynamic field ITSMImpact and other things.'} =
        '';
    $Self->{Translation}->{'Module to dynamically show the service incident state and to calculate the priority.'} =
        '';
    $Self->{Translation}->{'Required permissions to use the additional ITSM field screen in the agent interface.'} =
        '';
    $Self->{Translation}->{'Required permissions to use the decision screen in the agent interface.'} =
        '';
    $Self->{Translation}->{'Service Incident State and Priority Calculation'} = '';
    $Self->{Translation}->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} =
        '';
    $Self->{Translation}->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} =
        '';
    $Self->{Translation}->{'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        '';
    $Self->{Translation}->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Sets the ticket owner in the decision screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Sets the ticket responsible in the decision screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} =
        '';
    $Self->{Translation}->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} =
        '';
    $Self->{Translation}->{'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} =
        '担当者インターフェイスの追加 ITSMフィールド画面で、そのチケットに関与する全担当者のリストです。';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} =
        '担当者インターフェイスの決定画面で、そのチケットに関与する全ての担当者のリストを表示します。';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} =
        '担当者Webインターフェイスの追加ITSMフィールド画面にチケットの優先度オプションを表示します。';
    $Self->{Translation}->{'Shows the ticket priority options in the decision screen of the agent interface.'} =
        '担当者Webインターフェイスの決定画面にチケット優先度オプションを表示します。';
    $Self->{Translation}->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the title fields in the decision screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Ticket decision.'} = 'チケットの決定';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Service Incident State',
    );

}

1;
