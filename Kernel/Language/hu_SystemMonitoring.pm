# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::hu_SystemMonitoring;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run AFTER PostMasterFilter.'} =
        'Alapszintű levelezési felület a rendszerfigyelő alkalmazáscsomagokhoz. Akkor használja ezt a blokkot, ha a szűrőt a levelezési szűrő UTÁN kell lefuttatni.';
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run BEFORE PostMasterFilter.'} =
        'Alapszintű levelezési felület a rendszerfigyelő alkalmazáscsomagokhoz. Akkor használja ezt a blokkot, ha a szűrőt a levelezési szűrő ELŐTT kell lefuttatni.';
    $Self->{Translation}->{'Define Nagios acknowledge type.'} = 'Nagios nyugtázási típus meghatározása.';
    $Self->{Translation}->{'HTTP'} = 'HTTP';
    $Self->{Translation}->{'Icinga API URL.'} = 'Icinga API URL.';
    $Self->{Translation}->{'Icinga2 acknowledgement author.'} = 'Icinga2 nyugtázás szerzője.';
    $Self->{Translation}->{'Icinga2 acknowledgement comment.'} = 'Icinga2 nyugtázás megjegyzése.';
    $Self->{Translation}->{'Icinga2 acknowledgement enabled?'} = 'Icinga2 nyugtázás engedélyezve?';
    $Self->{Translation}->{'Icinga2 acknowledgement notify.'} = 'Icinga2 nyugtázás értesítés.';
    $Self->{Translation}->{'Icinga2 acknowledgement sticky.'} = 'Icinga2 nyugtázás ragasztás.';
    $Self->{Translation}->{'Link an already opened incident ticket with the affected CI. This is only possible when a subsequent system monitoring email arrives.'} =
        'Egy már megnyitott incidensjegy összekapcsolása az érintett CI-vel. Ez csak akkor lehetséges, amikor egy következő rendszerfigyelő e-mail érkezik.';
    $Self->{Translation}->{'Name of the Dynamic Field for Host.'} = 'A dinamikus mező neve a gépnél.';
    $Self->{Translation}->{'Name of the Dynamic Field for Service.'} = 'A dinamikus mező neve a szolgáltatásnál.';
    $Self->{Translation}->{'Named pipe acknowledge command.'} = 'Elnevezett cső nyugtázási parancs.';
    $Self->{Translation}->{'Named pipe acknowledge format for host.'} = 'Elnevezett cső nyugtázási formátum a gépnél.';
    $Self->{Translation}->{'Named pipe acknowledge format for service.'} = 'Elnevezett cső nyugtázási formátum a szolgáltatásnál.';
    $Self->{Translation}->{'Set the incident state of a CI automatically when a system monitoring email arrives.'} =
        'Egy CI incidensállapotának automatikus beállítása, amikor egy rendszerfigyelő e-mail érkezik.';
    $Self->{Translation}->{'The HTTP acknowledge URL.'} = 'A HTTP nyugtázási URL.';
    $Self->{Translation}->{'The HTTP acknowledge password.'} = 'A HTTP nyugtázási jelszó.';
    $Self->{Translation}->{'The HTTP acknowledge user.'} = 'A HTTP nyugtázási felhasználó.';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Icinga2.'} = 'Jegyesemény modul egy nyugta küldéséhez a Icinga2 számára.';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Nagios.'} = 'Jegyesemény modul egy nyugta küldéséhez a Nagios számára.';
    $Self->{Translation}->{'pipe'} = 'cső';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
