# --
# Kernel/Language/es_MX_OTRSMasterSlave.pm - provides de language translation
# Copyright (C) 2003-2012 OTRS AG, http://otrs.com/
# --
# $Id: es_MX_OTRSMasterSlave.pm,v 1.1 2012-02-21 05:32:56 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::es_MX_OTRSMasterSlave;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'New Master Ticket'}      = 'Nuevo Ticket Maestro';
    $Self->{Translation}->{'Unset Master Ticket'}      = 'Suprimir Ticket Maestro';
    $Self->{Translation}->{'Unset Slave Ticket'}      = 'Suprimir Ticket Detalle';
    $Self->{Translation}->{'Slave of Ticket#'}      = 'Detalle de Ticket#';
    $Self->{Translation}->{'MasterSlave'}    = 'Maestro-Detalle';
    $Self->{Translation}->{'Manage Master/Slave'} = 'Gestion Maestro/Detalle';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'}           = 'Modifica el estado Maestro-Detalle del ticket.';
    $Self->{Translation}->{'Define free text field for master ticket feature.'}                   = 'Define campos FreeField para la funcionalidad Maestro-Detalle.';
    $Self->{Translation}->{'Enable the advanced MasterSlave part of the feature.'}             = 'Activa el modo avanzado para esta funcionalidad.';
    $Self->{Translation}->{'Enable the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'}               = 'Activa la funcionalidad para suprimir el estado Maestro-Detalle de un ticket en el modo avanzado para Maestro-Detalle.';
    $Self->{Translation}->{'Enable the feature to update the MasterSlave state of a ticket in the advanced MasterSlave mode.'}                   = 'Activa la funcionalidad para actualizar el estado Maestro-Detalle de un ticket en el modo avanzado para Maestro-Detalle.';
    $Self->{Translation}->{'Enable the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'}                = 'Activa la funcionalidad para que tickets detalle acompañen a su ticket Maestro hacia uno nuevo en el modo avanzado para Maestro-Detalle.';
    $Self->{Translation}->{'This module is preparing master/slave pulldown in email and phone ticket.'}             = 'Este modulo prepara el contenido para el selector de Maestro-Detalle en las pantallas de ticket telefónico y de correo.';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'}       = 'Muestra un enlace en el menú para cambiar el estatus Maestro-Detalle de un ticket, en la vista detallada de dicho ticket de la interfaz del agente.';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'}              = 'Permisos requeridos para usar la pantalla Maestro-Detalle de un ticket, en la vista detallada de dicho ticket de la interfaz del agente.';

    return 1;
}

1;
