# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::it_SystemMonitoring;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run AFTER PostMasterFilter.'} =
        '';
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run BEFORE PostMasterFilter.'} =
        '';
    $Self->{Translation}->{'Define Nagios acknowledge type.'} = '';
    $Self->{Translation}->{'HTTP'} = '';
    $Self->{Translation}->{'Icinga API URL.'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement author.'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement comment.'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement enabled?'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement notify.'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement sticky.'} = '';
    $Self->{Translation}->{'Link an already opened incident ticket with the affected CI. This is only possible when a subsequent system monitoring email arrives.'} =
        '';
    $Self->{Translation}->{'Name of the Dynamic Field for Host.'} = '';
    $Self->{Translation}->{'Name of the Dynamic Field for Service.'} = '';
    $Self->{Translation}->{'Named pipe acknowledge command.'} = '';
    $Self->{Translation}->{'Named pipe acknowledge format for host.'} = '';
    $Self->{Translation}->{'Named pipe acknowledge format for service.'} = '';
    $Self->{Translation}->{'Set the incident state of a CI automatically when a system monitoring email arrives.'} =
        '';
    $Self->{Translation}->{'The HTTP acknowledge URL.'} = '';
    $Self->{Translation}->{'The HTTP acknowledge password.'} = '';
    $Self->{Translation}->{'The HTTP acknowledge user.'} = '';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Icinga2.'} = '';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Nagios.'} = '';
    $Self->{Translation}->{'pipe'} = '';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
