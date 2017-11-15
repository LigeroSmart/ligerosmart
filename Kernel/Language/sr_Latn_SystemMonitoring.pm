# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::sr_Latn_SystemMonitoring;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run AFTER PostMasterFilter.'} =
        'Osnovni imejl interfejs za sistemski nadzor. Koristite ovaj blok ako filter treba da bude pušten POSLE PostMasterFilter.';
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run BEFORE PostMasterFilter.'} =
        'Osnovni imejl interfejs za sistemski nadzor. Koristite ovaj blok ako filter treba da bude pušten PRE PostMasterFilter.';
    $Self->{Translation}->{'Define Nagios acknowledge type.'} = 'Određuje „Nagios” tip potvrde.';
    $Self->{Translation}->{'HTTP'} = 'HTTP';
    $Self->{Translation}->{'Icinga API URL .'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement author.'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement comment.'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement enabled?'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement notify.'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement sticky.'} = '';
    $Self->{Translation}->{'Link an already opened incident ticket with the affected CI. This is only possible when a subsequent system monitoring email arrives.'} =
        'Poveži već otvoreni tiket incidenta sa pogođenom konfiguracionom stavkom. Ovo je jedino moguće kada stigne sledeći imejl od sistemskog nadzora.';
    $Self->{Translation}->{'Name of the Dynamic Field for Host.'} = 'Naziv dinamičkog polja za host.';
    $Self->{Translation}->{'Name of the Dynamic Field for Service.'} = 'Naziv dinamičkog polja za servis.';
    $Self->{Translation}->{'Named pipe acknowledge command.'} = 'Komanda potvrde imenovanog kanala.';
    $Self->{Translation}->{'Named pipe acknowledge format for host.'} = 'Format potvrde za host imenovanog kanala.';
    $Self->{Translation}->{'Named pipe acknowledge format for service.'} = 'Format potvrde za servis imenovanog kanala.';
    $Self->{Translation}->{'Set the incident state of a CI automatically when a system monitoring email arrives.'} =
        'Postavi automatski stanje incidenta konfiguracione stavke kada stigne imejl od sistemskog nadzora.';
    $Self->{Translation}->{'The HTTP acknowledge URL.'} = 'Adresa HTTP potvrde.';
    $Self->{Translation}->{'The HTTP acknowledge password.'} = 'Lozinka HTTP potvrde.';
    $Self->{Translation}->{'The HTTP acknowledge user.'} = 'Korisnik HTTP potvrde.';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Icinga2.'} = '';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Nagios.'} = 'Modul događaja tiketa za slanje potvrde za „Nagios”.';
    $Self->{Translation}->{'pipe'} = 'kanal';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
