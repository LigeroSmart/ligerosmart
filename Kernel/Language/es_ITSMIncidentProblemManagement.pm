# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'Añadir decisión al ticket';
    $Self->{Translation}->{'Decision Date'} = 'Fecha de Decisión';
    $Self->{Translation}->{'Decision Result'} = 'Resultado de Decisión';
    $Self->{Translation}->{'Due Date'} = 'Fecha de vencimiento';
    $Self->{Translation}->{'Reason'} = 'Motivo';
    $Self->{Translation}->{'Recovery Start Time'} = 'Fecha Inicial de Recuperación';
    $Self->{Translation}->{'Repair Start Time'} = 'Fecha Inicial de Reparación';
    $Self->{Translation}->{'Review Required'} = 'Revisión Requerida';
    $Self->{Translation}->{'closed with workaround'} = 'Cerrado con solución provisional';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = 'Cambiar Decisión del Ticket';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'Modificar campos ITSM del ticket';
    $Self->{Translation}->{'Service Incident State'} = 'Estado de Incidente del Servicio';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = 'Vincular ticket';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'Urgencia';
    $Self->{Translation}->{'Impact'} = 'Impacto';

}

1;
