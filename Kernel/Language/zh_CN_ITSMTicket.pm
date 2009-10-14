# --
# Kernel/Language/zh_CN_ITSMTicket.pm - the Chinese simple translation of ITSMTicket
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: zh_CN_ITSMTicket.pm,v 1.2 2009-10-14 20:46:19 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = '截止日期';
    $Lang->{'Decision'}                     = '决定';
    $Lang->{'Reason'}                       = '理由';
    $Lang->{'Decision Date'}                = '决定日期';
    $Lang->{'Add decision to ticket'}       = '增加决定到 Ticket';
    $Lang->{'Decision Result'}              = '决定结果';
    $Lang->{'Review Required'}              = '审查申请';
    $Lang->{'closed with workaround'}       = '替代方法而关闭';
    $Lang->{'Additional ITSM Fields'}       = '额外的 ITSM 域';
    $Lang->{'Change ITSM fields of ticket'} = '为该 Ticket 更改 ITSM 域';
    $Lang->{'Repair Start Time'}            = '修复开始时间';
    $Lang->{'Recovery Start Time'}          = '恢复运作时间';
    $Lang->{'Change the ITSM fields!'}      = '更改 ITSM 域!';
    $Lang->{'Add a decision!'}              = '增加一个决议!';
# Add by Never
    $Lang->{'Approved'}                     = '批准';
    $Lang->{'Pending'}                      = '待定';
    $Lang->{'Postponed'}                    = '推迟';
    $Lang->{'Pre-approved'}                 = '预先核准';
    $Lang->{'Rejected'}                     = '拒绝';

    return 1;
}

1;
