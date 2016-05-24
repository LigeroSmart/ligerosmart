# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_TW_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = '可供選擇';
    $Self->{Translation}->{'Availability'} = '可用性';
    $Self->{Translation}->{'Back End'} = '後端';
    $Self->{Translation}->{'Connected to'} = '連接';
    $Self->{Translation}->{'Current State'} = '當前狀態';
    $Self->{Translation}->{'Demonstration'} = '演示';
    $Self->{Translation}->{'Depends on'} = '依賴';
    $Self->{Translation}->{'End User Service'} = '最終用戶服務';
    $Self->{Translation}->{'Errors'} = '錯誤';
    $Self->{Translation}->{'Front End'} = '前端';
    $Self->{Translation}->{'IT Management'} = 'IT管理';
    $Self->{Translation}->{'IT Operational'} = 'IT運營';
    $Self->{Translation}->{'Impact'} = '影響';
    $Self->{Translation}->{'Incident State'} = '故障狀態';
    $Self->{Translation}->{'Includes'} = '包括';
    $Self->{Translation}->{'Other'} = '其它';
    $Self->{Translation}->{'Part of'} = '屬於';
    $Self->{Translation}->{'Project'} = '項目';
    $Self->{Translation}->{'Recovery Time'} = '恢復時間';
    $Self->{Translation}->{'Relevant to'} = '相關';
    $Self->{Translation}->{'Reporting'} = '報告';
    $Self->{Translation}->{'Required for'} = '需要';
    $Self->{Translation}->{'Resolution Rate'} = '解決率';
    $Self->{Translation}->{'Response Time'} = '響應時間';
    $Self->{Translation}->{'SLA Overview'} = 'SLA概述';
    $Self->{Translation}->{'Service Overview'} = '服務概述';
    $Self->{Translation}->{'Service-Area'} = '服務區';
    $Self->{Translation}->{'Training'} = '培訓';
    $Self->{Translation}->{'Transactions'} = '交易';
    $Self->{Translation}->{'Underpinning Contract'} = '依據合同';
    $Self->{Translation}->{'allocation'} = '分配';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = '重要 <-> 影響 <-> 優先級';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        '"重要 <-> 影響"之間的組合決定優先級';
    $Self->{Translation}->{'Priority allocation'} = '優先級分配';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = '故障間最短時間';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = '重要';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'SLA信息';
    $Self->{Translation}->{'Last changed'} = '上次修改於';
    $Self->{Translation}->{'Last changed by'} = '上次修改人';
    $Self->{Translation}->{'Associated Services'} = '關聯的服務';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = '服務信息';
    $Self->{Translation}->{'Current incident state'} = '當前故障狀態';
    $Self->{Translation}->{'Associated SLAs'} = '關聯的SLAs';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'Current Incident State'} = '當前故障狀態';

}

1;
