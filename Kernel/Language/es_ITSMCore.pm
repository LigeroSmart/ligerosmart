# --
# Kernel/Language/es_ITSMCore.pm - the spanish translation of ITSMCore
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Aquiles Cohen
# --
# $Id: es_ITSMCore.pm,v 1.6 2010-06-01 19:25:22 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'Urgencia';
    $Lang->{'Impact'}                              = 'Impacto';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Urgencia <-> Impacto <-> Prioridad';
    $Lang->{'allocation'}                          = 'Asignar';
    $Lang->{'Priority allocation'}                 = 'Asignar prioridad';
    $Lang->{'Relevant to'}                         = 'Relevante a';
    $Lang->{'Includes'}                            = 'Incluye';
    $Lang->{'Part of'}                             = 'Parte de';
    $Lang->{'Depends on'}                          = 'Depende en';
    $Lang->{'Required for'}                        = 'Requerido para';
    $Lang->{'Connected to'}                        = 'Conectado a';
    $Lang->{'Alternative to'}                      = 'Alterantiva a';
    $Lang->{'Incident State'}                      = 'Estado del Incidente';
    $Lang->{'Current Incident State'}              = 'Estado Actual del Incidente';
    $Lang->{'Current State'}                       = 'Estado Actual';
    $Lang->{'Service-Area'}                        = 'Area-Servicio';
    $Lang->{'Minimum Time Between Incidents'}      = 'Mínimo Tiempo entre Incidentes';
    $Lang->{'Service Overview'}                    = 'Descripción de Servicios';
    $Lang->{'SLA Overview'}                        = 'Descripción de SLA';
    $Lang->{'Associated Services'}                 = 'Servicios Asociados';
    $Lang->{'Associated SLAs'}                     = 'SLAs Asociados';
    $Lang->{'Back End'}                            = '';
    $Lang->{'Demonstration'}                       = 'Demostración';
    $Lang->{'End User Service'}                    = 'Servicio de Usuario Final';
    $Lang->{'Front End'}                           = '';
    $Lang->{'IT Management'}                       = 'Administración de TI';
    $Lang->{'IT Operational'}                      = 'Operación de TI';
    $Lang->{'Other'}                               = 'Otro';
    $Lang->{'Project'}                             = 'Proyecto';
    $Lang->{'Reporting'}                           = 'Informes';
    $Lang->{'Training'}                            = 'Entrenamiento';
    $Lang->{'Underpinning Contract'}               = '';
    $Lang->{'Availability'}                        = 'Disponibilidad';
    $Lang->{'Errors'}                              = 'Errores';
    $Lang->{'Other'}                               = 'Otro';
    $Lang->{'Recovery Time'}                       = 'Tiempo de Recuperación';
    $Lang->{'Resolution Rate'}                     = 'Tasa de Resolución';
    $Lang->{'Response Time'}                       = 'Tiempo de Respuesta';
    $Lang->{'Transactions'}                        = 'Transacciones';

    return 1;
}

1;
