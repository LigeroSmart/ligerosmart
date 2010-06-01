# --
# Kernel/Language/it_ITSMCore.pm - the italian translation of ITSMCore
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: it_ITSMCore.pm,v 1.3 2010-06-01 19:25:22 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::it_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'Urgenzia';
    $Lang->{'Impact'}                              = 'Impatto';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Urgenza <-> Impatto <-> Priorità';
    $Lang->{'allocation'}                          = 'assegnare';
    $Lang->{'Priority allocation'}                 = '';
    $Lang->{'Relevant to'}                         = 'Rilevante per';
    $Lang->{'Includes'}                            = 'Include';
    $Lang->{'Part of'}                             = 'Parte di';
    $Lang->{'Depends on'}                          = 'Depende da';
    $Lang->{'Required for'}                        = 'Richiesto per';
    $Lang->{'Connected to'}                        = 'Connesso a';
    $Lang->{'Alternative to'}                      = 'Alternativo a';
    $Lang->{'Incident State'}                      = 'Stato dell\'Incidente';
    $Lang->{'Current Incident State'}              = 'Stato Attuale dell\'Incidente';
    $Lang->{'Current State'}                       = 'Stato Attuale';
    $Lang->{'Service-Area'}                        = 'Area-di-Servizio';
    $Lang->{'Minimum Time Between Incidents'}      = 'Minimo Tempo Tra Incidenti';
    $Lang->{'Service Overview'}                    = 'Descrizione del Servizio';
    $Lang->{'SLA Overview'}                        = 'Descrizione dello SLA';
    $Lang->{'Associated Services'}                 = 'Servizi Associati';
    $Lang->{'Associated SLAs'}                     = 'SLAs Associati';
    $Lang->{'Back End'}                            = 'Back End';
    $Lang->{'Demonstration'}                       = 'Dimostrazione';
    $Lang->{'End User Service'}                    = 'Servizio Utente Finale';
    $Lang->{'Front End'}                           = 'Front End';
    $Lang->{'IT Management'}                       = 'IT Management';
    $Lang->{'IT Operational'}                      = 'IT Operational';
    $Lang->{'Other'}                               = 'Altro';
    $Lang->{'Project'}                             = 'Progetto';
    $Lang->{'Reporting'}                           = 'Rapporti';
    $Lang->{'Training'}                            = 'Formazione';
    $Lang->{'Underpinning Contract'}               = 'Underpinning Contract';
    $Lang->{'Availability'}                        = 'Disponibilità';
    $Lang->{'Errors'}                              = 'Errori';
    $Lang->{'Other'}                               = 'Altro';
    $Lang->{'Recovery Time'}                       = 'Tempo di Recupero';
    $Lang->{'Resolution Rate'}                     = 'Tasso di Risoluzione';
    $Lang->{'Response Time'}                       = 'Tempo di Risposta';
    $Lang->{'Transactions'}                        = 'Transazioni';

    return 1;
}

1;
