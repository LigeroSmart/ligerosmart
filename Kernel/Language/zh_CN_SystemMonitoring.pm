# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_SystemMonitoring;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run AFTER PostMasterFilter.'} =
        '系统监控套件的基本邮件接口。仅当此过滤器在邮件管理员过滤器之后运行时使用。';
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run BEFORE PostMasterFilter.'} =
        '系统监控套件的基本邮件接口。仅当此过滤器在邮件管理员过滤器之前运行时使用。';
    $Self->{Translation}->{'Define Nagios acknowledge type.'} = '定义Nagios已知问题的类型。';
    $Self->{Translation}->{'HTTP'} = 'HTTP';
    $Self->{Translation}->{'Icinga API URL .'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement author.'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement comment.'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement enabled?'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement notify.'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement sticky.'} = '';
    $Self->{Translation}->{'Link an already opened incident ticket with the affected CI. This is only possible when a subsequent system monitoring email arrives.'} =
        '将受影响的配置项链接到已打开的故障工单。此功能只在配置项随后的系统监控邮件到达时才可用。';
    $Self->{Translation}->{'Name of the Dynamic Field for Host.'} = '用于主机的动态字段名称。';
    $Self->{Translation}->{'Name of the Dynamic Field for Service.'} = '用于服务的动态字段名称。';
    $Self->{Translation}->{'Named pipe acknowledge command.'} = '命名管道已知问题的指令。';
    $Self->{Translation}->{'Named pipe acknowledge format for host.'} = '命名管道已知问题的主机格式。';
    $Self->{Translation}->{'Named pipe acknowledge format for service.'} = '命名管道已知问题的服务格式。';
    $Self->{Translation}->{'Set the incident state of a CI automatically when a system monitoring email arrives.'} =
        '当配置项的系统监控邮件到达时自动设置它的故障状态。';
    $Self->{Translation}->{'The HTTP acknowledge URL.'} = 'HTTP已知问题的URL。';
    $Self->{Translation}->{'The HTTP acknowledge password.'} = 'HTTP已知问题的密码。';
    $Self->{Translation}->{'The HTTP acknowledge user.'} = 'HTTP已知问题的用户名。';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Icinga2.'} = '';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Nagios.'} = '发送一个已知问题到Nagios的工单事件模块。';
    $Self->{Translation}->{'pipe'} = '管道';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
