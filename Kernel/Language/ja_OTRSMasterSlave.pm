# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ja_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Manage Master/Slave status for %s%s%s'} = '%s%s%sのマスタ/スレーブステータスを管理する';

    # Perl Module: Kernel/Modules/AgentTicketMasterSlave.pm
    $Self->{Translation}->{'New Master Ticket'} = '新しいマスターチケット';
    $Self->{Translation}->{'Unset Master Ticket'} = 'マスターチケットを解除する';
    $Self->{Translation}->{'Unset Slave Ticket'} = 'スレーブチケットを解除する';
    $Self->{Translation}->{'Slave of %s%s%s: %s'} = '%s%s%sのスレーブ: %s';

    # Perl Module: Kernel/Output/HTML/TicketBulk/MasterSlave.pm
    $Self->{Translation}->{'Unset Master Tickets'} = 'マスターチケットを解除する';
    $Self->{Translation}->{'Unset Slave Tickets'} = 'スレーブチケットを解除する';

    # Perl Module: Kernel/System/DynamicField/Driver/MasterSlave.pm
    $Self->{Translation}->{'Master'} = 'マスター';
    $Self->{Translation}->{'Slave of %s%s%s'} = '';
    $Self->{Translation}->{'Master Ticket'} = 'マスター チケット';

    # SysConfig
    $Self->{Translation}->{'All master tickets'} = 'すべてのマスターチケット';
    $Self->{Translation}->{'All slave tickets'} = 'すべてのスレーブチケット';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'エージェントインタフェースのズームされたチケットのマスタースレイブ画面で、注釈の追加を許可します。';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'チケットのマスター・スレーブ状況を変更する';
    $Self->{Translation}->{'Defines dynamic field name for master ticket feature.'} = 'マスター・スレーブ動的フィールド名を設定する';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        '';
    $Self->{Translation}->{'Defines if the MasterSlave note is visible for the customer by default.'} =
        '';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '担当者インターフェイス のズームされたチケットのマスター・スレーブ画面で、デフォルトの チケット 優先度を定義します。';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        '担当者インタフェースのチケット履歴で使用される、チケット・マスター・スレーブ画面アクションに関する履歴コメントを定義します。';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        '担当者インタフェースのチケット履歴で使用される、チケット・マスター・スレーブ画面アクションに関する履歴タイプを定義します。';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Enables the advanced MasterSlave part of the feature.'} = '';
    $Self->{Translation}->{'Enables the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'Enables the feature to change the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'Enables the feature to forward articles from type \'forward\' of a master ticket to the customers of the slave tickets. By default (disabled) it will not forward articles from type \'forward\' to the slave tickets.'} =
        '';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after change of the MasterSlave state in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after unset of the MasterSlave state in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'Enables the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Master / Slave'} = 'マスター / スレーブ';
    $Self->{Translation}->{'Master Tickets'} = 'マスターチケット';
    $Self->{Translation}->{'MasterSlave'} = 'マスター・スレーブ';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = 'MasterSlave モジュールのチケット一括処理機能';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        '';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        '';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'チケットイベントモジュールの登録';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '担当者インタフェースで、ズームされたチケットのマスター・スレーブ画面を使用するための必要な許可です。';
    $Self->{Translation}->{'Sets if Master / Slave field must be selected by the agent.'} = '';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '担当者インタフェースのズームされたチケットのマスター・スレーブ画面で、追加されたメモのデフォルトの本文を設定します。';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '担当者インタフェースのズームされたチケットのマスター・スレーブ画面で、追加されたメモのデフォルトの件名を設定します。';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '担当者インタフェースのズームされたチケットのマスター・スレーブ画面で、チケットの責任を有する担当者を設定します。';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        '担当者インタフェースのズームされたチケットのチケットのマスター・スレーブ画面で、サービスを設定します (Ticket::Serviceを有効とする必要があります)。';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '担当者インタフェースのズームされたチケットのマスター・スレーブ画面で、チケット所有者を設定します。';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        '担当者インタフェースのズームされたチケットのチケットのマスター・スレーブ画面で、チケット・タイプを設定します(Ticket::Typeを有効とする必要があります)。';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the title field in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Slave Tickets'} = 'スレーブチケット';
    $Self->{Translation}->{'Specifies the different article communication channels where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        '';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        'このモジュールは、新規メール/電話チケットに、マスター/スレーブチケット欄を追加します。';
    $Self->{Translation}->{'This setting is deprecated and will be removed in further versions of OTRSMasterSlave.'} =
        '';
    $Self->{Translation}->{'Ticket MasterSlave.'} = 'マスター・スレーブチケット';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
