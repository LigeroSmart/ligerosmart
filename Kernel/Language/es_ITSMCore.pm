# --
# Kernel/Language/es_ITSMCore.pm - the spanish translation of ITSMCore
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Aquiles Cohen
# --
# $Id: es_ITSMCore.pm,v 1.9 2010-08-12 22:58:07 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

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
    $Lang->{'This setting controls the name of the application as is shown in the web interface as well as the tabs and title bar of your web browser.'} = 'Esta configuración controla el nombre de la aplicación, tal y como se muestra en la interfaz web, así como en las tabs y en la brra de título del explorador web.';
    $Lang->{'Determines the way the linked objects are displayed in each zoom mask.'} = 'Determina la manera en que los objetos vinculados se despliegan en cada máscara de zoom.';
    $Lang->{'List of online repositories (for example you also can use other installations as repositoriy by using Key="http://example.com/otrs/public.pl?Action=PublicRepository&File=" and Content="Some Name").'} = 'Lista de los repositorios disponibles (por ejemplo, también se pueden usar otras instalaciones como respositorio, usando Key="http://example.com/otrs/public.pl?Action=PublicRepository&File=" y Content="Algún nombre").';
    $Lang->{'Frontend module registration for the AgentITSMService object in the agent interface.'} = 'Registro de módulo frontend para el objeto AgentITSMService en la interfaz del agente.';
    $Lang->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} = 'Registro de módulo frontend para el objeto AgentITSMSLA en la interfaz del agente.';
    $Lang->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} = 'Registro de módulo frontend para el objeto AgentITSMServiceZoom en la interfaz del agente.';
    $Lang->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} = 'Registro de módulo frontend para el objeto AgentITSMServicePrint en la interfaz del agente.';
    $Lang->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} = 'Registro de módulo frontend para el objeto AgentITSMSLAZoom en la interfaz del agente.';
    $Lang->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} = 'Registro de módulo frontend para el objeto AgentITSMSLAPrint en la interfaz del agente.';
    $Lang->{'Module to show back link in service menu.'} = 'Módulo para mostar un vínculo para regresar en el menú de servicio.';
    $Lang->{'Module to show print link in service menu.'} = 'Módulo para mostar un vínculo para imprimir en el menú de servicio.';
    $Lang->{'Module to show the link link in service menu.'} = 'Módulo para mostar el vínculo "Vincular" en el menú de servicio.';
    $Lang->{'Module to show back link in sla menu.'} = 'Módulo para mostar un vínculo para regresar en el menú de SLA.';
    $Lang->{'Module to show print link in sla menu.'} = 'Módulo para mostar un vínculo para imprimir en el menú de SLA.';
    $Lang->{'If ticket service/SLA feature is enabled, you can define ticket services and SLAs for tickets (e. g. email, desktop, network, ...).'} = 'Si la funcionalidad del ticket servicio-SLA está habilitada, es posible definir servicios y SLAs para los tickets (por ejemplo: email, escritorio, red, ...).';

    return 1;
}

1;
