# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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
        'Interfaccia di posta elettronica di base per Suite di monitoraggio del sistema. Utilizzare questo blocco se il filtro deve essere eseguito DOPO PostMasterFilter.';
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run BEFORE PostMasterFilter.'} =
        'Interfaccia di posta elettronica di base per Suite di monitoraggio del sistema. Utilizzare questo blocco se il filtro deve essere eseguito PRIMA di PostMasterFilter.';
    $Self->{Translation}->{'Define Nagios acknowledge type.'} = 'Definisci il tipo di riconoscimento Nagios.';
    $Self->{Translation}->{'HTTP'} = 'HTTP';
    $Self->{Translation}->{'Icinga API URL.'} = 'Icinga API URL.';
    $Self->{Translation}->{'Icinga2 acknowledgement author.'} = 'Autore del riconoscimento Icinga2.';
    $Self->{Translation}->{'Icinga2 acknowledgement comment.'} = 'Commento di riconoscimento Icinga2.';
    $Self->{Translation}->{'Icinga2 acknowledgement enabled?'} = 'Riconoscimento Icinga2 abilitato?';
    $Self->{Translation}->{'Icinga2 acknowledgement notify.'} = 'Riconoscimento Icinga2 notifica.';
    $Self->{Translation}->{'Icinga2 acknowledgement sticky.'} = 'Riconoscimento Icinga2 sticky.';
    $Self->{Translation}->{'Link an already opened incident ticket with the affected CI. This is only possible when a subsequent system monitoring email arrives.'} =
        'Collegare un ticket incidente già aperto con l\'elemento della configurazione interessato. Questo è possibile solo quando arriva una successiva e-mail di monitoraggio del sistema.';
    $Self->{Translation}->{'Name of the Dynamic Field for Host.'} = 'Nome del campo dinamico per Host.';
    $Self->{Translation}->{'Name of the Dynamic Field for Service.'} = 'Nome del campo dinamico per servizio.';
    $Self->{Translation}->{'Named pipe acknowledge command.'} = 'Comando di riconoscimento pipe denominato.';
    $Self->{Translation}->{'Named pipe acknowledge format for host.'} = 'Formato di riconoscimento pipe denominato per l\'host.';
    $Self->{Translation}->{'Named pipe acknowledge format for service.'} = 'Formato di riconoscimento della pipe denominato per il servizio.';
    $Self->{Translation}->{'Set the incident state of a CI automatically when a system monitoring email arrives.'} =
        'Imposta automaticamente lo stato dell\'incident di un CI quando arriva una mail di system monitoring.';
    $Self->{Translation}->{'The HTTP acknowledge URL.'} = 'L\'indirizzo URL HTTP riconosciuto.';
    $Self->{Translation}->{'The HTTP acknowledge password.'} = 'Password HTTP riconosciuta.';
    $Self->{Translation}->{'The HTTP acknowledge user.'} = 'L\'utente HTTP riconosciuto.';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Icinga2.'} = 'Modulo evento Ticket per inviare un riconoscimento a Icinga2.';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Nagios.'} = 'Modulo evento Ticket per inviare un riconoscimento a Nagios.';
    $Self->{Translation}->{'pipe'} = 'pipe';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
