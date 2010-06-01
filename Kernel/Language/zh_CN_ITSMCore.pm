# --
# Kernel/Language/zh_CN_ITSMCore.pm - the Chinese simple translation of ITSMCore
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: zh_CN_ITSMCore.pm,v 1.4 2010-06-01 19:25:22 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = '危急程度';
    $Lang->{'Impact'}                              = '影响度';
    $Lang->{'Criticality <-> Impact <-> Priority'} = '危急程度 <-> 影响度 <-> 优先级别';
    $Lang->{'allocation'}                          = '分配';
    $Lang->{'Priority allocation'}                 = '';
    $Lang->{'Relevant to'}                         = '相关';
    $Lang->{'Includes'}                            = '包括';
    $Lang->{'Part of'}                             = '部分于';
    $Lang->{'Depends on'}                          = '取决于';
    $Lang->{'Required for'}                        = '必需的';
    $Lang->{'Connected to'}                        = '连接到';
    $Lang->{'Alternative to'}                      = '选择对象';
    $Lang->{'Incident State'}                      = '事件状态';
    $Lang->{'Current Incident State'}              = '当前事件状态';
    $Lang->{'Current State'}                       = '现状';
    $Lang->{'Service-Area'}                        = '服务区';
    $Lang->{'Minimum Time Between Incidents'}      = '最短的时间与事件';
    $Lang->{'Service Overview'}                    = '服务概述';
    $Lang->{'SLA Overview'}                        = 'SLA 概述';
    $Lang->{'Associated Services'}                 = '关联的服务';
    $Lang->{'Associated SLAs'}                     = '关联的 SLAs';
    $Lang->{'Back End'}                            = '后端';
    $Lang->{'Demonstration'}                       = '示范';
    $Lang->{'End User Service'}                    = '最终用户服务';
    $Lang->{'Front End'}                           = '前端';
    $Lang->{'IT Management'}                       = 'IT 管理';
    $Lang->{'IT Operational'}                      = 'IT 运营';
    $Lang->{'Other'}                               = '其它';
    $Lang->{'Project'}                             = '项目';
    $Lang->{'Reporting'}                           = '报告';
    $Lang->{'Training'}                            = '训练';
    $Lang->{'Underpinning Contract'}               = '依据合同';
    $Lang->{'Availability'}                        = '供货情况';
    $Lang->{'Errors'}                              = '错误';
    $Lang->{'Other'}                               = '其它';
    $Lang->{'Recovery Time'}                       = '恢复时间';
    $Lang->{'Resolution Rate'}                     = '解决进度';
    $Lang->{'Response Time'}                       = '响应时间';
    $Lang->{'Transactions'}                        = '交易';

    return 1;
}

1;
