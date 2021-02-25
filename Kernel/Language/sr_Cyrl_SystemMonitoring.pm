# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sr_Cyrl_SystemMonitoring;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run AFTER PostMasterFilter.'} =
        'Основни имејл интерфејс за системски надзор. Користите овај блок ако филтер треба да буде пуштен ПОСЛЕ PostMasterFilter.';
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run BEFORE PostMasterFilter.'} =
        'Основни имејл интерфејс за системски надзор. Користите овај блок ако филтер треба да буде пуштен ПРЕ PostMasterFilter.';
    $Self->{Translation}->{'Define Nagios acknowledge type.'} = 'Одређује Nagios тип потврде.';
    $Self->{Translation}->{'HTTP'} = 'HTTP';
    $Self->{Translation}->{'Icinga API URL.'} = 'Адреса Icinga API.';
    $Self->{Translation}->{'Icinga2 acknowledgement author.'} = 'Icinga2 аутор потврде.';
    $Self->{Translation}->{'Icinga2 acknowledgement comment.'} = 'Icinga2 коментар потврде.';
    $Self->{Translation}->{'Icinga2 acknowledgement enabled?'} = 'Icinga2 потврда омогућена?';
    $Self->{Translation}->{'Icinga2 acknowledgement notify.'} = 'Icinga2 обавештење потврде.';
    $Self->{Translation}->{'Icinga2 acknowledgement sticky.'} = 'Icinga2 маркирање потврде.';
    $Self->{Translation}->{'Link an already opened incident ticket with the affected CI. This is only possible when a subsequent system monitoring email arrives.'} =
        'Повежи већ отворени тикет инцидента са погођеном конфигурационом ставком. Ово је једино могуће када стигне следећи имејл од системског надзора.';
    $Self->{Translation}->{'Name of the Dynamic Field for Host.'} = 'Назив динамичког поља за сервер.';
    $Self->{Translation}->{'Name of the Dynamic Field for Service.'} = 'Назив динамичког поља за сервис.';
    $Self->{Translation}->{'Named pipe acknowledge command.'} = 'Команда потврде именованог канала.';
    $Self->{Translation}->{'Named pipe acknowledge format for host.'} = 'Формат потврде за хост именованог канала.';
    $Self->{Translation}->{'Named pipe acknowledge format for service.'} = 'Формат потврде за сервис именованог канала.';
    $Self->{Translation}->{'Set the incident state of a CI automatically when a system monitoring email arrives.'} =
        'Постави аутоматски стање инцидента конфигурационе ставке када стигне имејл од системског надзора.';
    $Self->{Translation}->{'The HTTP acknowledge URL.'} = 'Адреса HTTP потврде.';
    $Self->{Translation}->{'The HTTP acknowledge password.'} = 'Лозинка HTTP потврде.';
    $Self->{Translation}->{'The HTTP acknowledge user.'} = 'Корисник HTTP потврде.';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Icinga2.'} = 'Модул догађаја тикета за слање потврде за Icinga2.';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Nagios.'} = 'Модул догађаја тикета за слање потврде за Nagios.';
    $Self->{Translation}->{'pipe'} = 'канал';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
