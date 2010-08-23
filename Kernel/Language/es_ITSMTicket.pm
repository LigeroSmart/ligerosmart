# --
# Kernel/Language/es_ITSMTicket.pm - the spanish translation of ITSMTicket
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Aquiles Cohen
# --
# $Id: es_ITSMTicket.pm,v 1.7 2010-08-23 18:58:35 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Fecha de Vencimiento';
    $Lang->{'Decision'}                     = 'Decisión';
    $Lang->{'Reason'}                       = 'Motivo';
    $Lang->{'Decision Date'}                = 'Fecha de Decisión';
    $Lang->{'Add decision to ticket'}       = 'Añadir decisión al ticket';
    $Lang->{'Decision Result'}              = 'Resultado de Decisión';
    $Lang->{'Review Required'}              = 'Revisión Requerida';
    $Lang->{'closed with workaround'}       = 'Cerrado con solución provisional';
    $Lang->{'Additional ITSM Fields'}       = 'Campos ITSM Adicionales';
    $Lang->{'Change ITSM fields of ticket'} = 'Modificar campos ITSM del ticket';
    $Lang->{'Repair Start Time'}            = 'Fecha Inicial de Reparación';
    $Lang->{'Recovery Start Time'}          = 'Fecha Inicial de Recuperación';
    $Lang->{'Change the ITSM fields!'}      = 'Modificar los campos ITSM';
    $Lang->{'Add a decision!'}              = '¡Agregue una decisión!';
    $Lang->{'Allows defining new types for ticket (if ticket type feature is enabled), e.g. incident, problem, change, ...'} = 'Permite definir tipos de ticket nuevos (si la funcionalidad tipo del ticket está habilitada), por ejemplo: incidente, problema, cambio, ...';
    $Lang->{'Defines the the free key field number 13 for tickets to add a new ticket attribute.'} = 'Define el campo free key número 13 para agregar un atributo nuevo a los tickets.';
    $Lang->{'Defines the free text field number 13 for tickets to add a new ticket attribute.'} = 'Define el campo free text número 13 para agregar un atributo nuevo a los tickets.';
    $Lang->{'Defines the the free key field number 14 for tickets to add a new ticket attribute.'} = 'Define el campo free key número 14 para agregar un atributo nuevo a los tickets.';
    $Lang->{'Defines the free text field number 14 for tickets to add a new ticket attribute.'} = 'Define el campo free text número 14 para agregar un atributo nuevo a los tickets.';
    $Lang->{'Defines the default selection of the free text field number 14 for tickets (if more than one option is provided).'} = 'Define el valor seleccionado por default (si existe más de una opción) del campo free text número 14 de los tickets.';
    $Lang->{'Defines the the free key field number 15 for tickets to add a new ticket attribute.'} = 'Define el campo free key número 15 para agregar un atributo nuevo a los tickets.';
    $Lang->{'Defines the free text field number 15 for tickets to add a new ticket attribute.'} = 'Define el campo free text número 15 para agregar un atributo nuevo a los tickets.';
    $Lang->{'Defines the default selection of the free text field number 15 for tickets (if more than one option is provided).'} = 'Define el valor seleccionado por default (si existe más de una opción) del campo free text número 15 de los tickets.';
    $Lang->{'Defines the the free key field number 16 for tickets to add a new ticket attribute.'} = 'Define el campo free key número 16 para agregar un atributo nuevo a los tickets.';
    $Lang->{'Defines the free text field number 16 for tickets to add a new ticket attribute.'} = 'Define el campo free text número 16 para agregar un atributo nuevo a los tickets.';
    $Lang->{'Defines the default selection of the free text field number 16 for tickets (if more than one option is provided).'} = 'Define el valor seleccionado por default (si existe más de una opción) del campo free text número 16 de los tickets.';
    $Lang->{'Defines the free time key field number 3 for tickets.'} = 'Define el campo free time key número 3 para los tickets.';
    $Lang->{'Defines the years (in future and in past) which can get selected in free time field number 3.'} = 'Define los años (en futuro y pasado) que pueden ser seleccionados en el campo free time número 3.';
    $Lang->{'Defines the free time key field number 4 for tickets.'} = 'Define el campo free time key número 4 para los tickets.';
    $Lang->{'Defines the years (in future and in past) which can get selected in free time field number 4.'} = 'Define los años (en futuro y pasado) que pueden ser seleccionados en el campo free time número 4.';
    $Lang->{'Defines the free time key field number 5 for tickets.'} = 'Define el campo free time key número 5 para los tickets.';
    $Lang->{'Defines the years (in future and in past) which can get selected in free time field number 5.'} = 'Define los años (en futuro y pasado) que pueden ser seleccionados en el campo free time número 5.';
    $Lang->{'Defines the free time key field number 6 for tickets.'} = 'Define el campo free time key número 6 para los tickets.';
    $Lang->{'Defines the years (in future and in past) which can get selected in free time field number 6.'} = 'Define los años (en futuro y pasado) que pueden ser seleccionados en el campo free time número 6.';
    $Lang->{'Defines the difference from now (in seconds) of the free time field number 6\'s default value.'} = 'Define la diferencia (en segundos) entre el tiempo actual y el valor definido como default para el campo free time número 6.';
    $Lang->{'Frontend module registration for the agent interface.'} = 'Registro de módulo frontend para la interfaz del agente.';
    $Lang->{'Ticket free text options shown in the close ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = 'Opciones del atributo free text de los tickets, mostradas en la ventana de cerrar ticket de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.';
    $Lang->{'Ticket free text options shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = 'Opciones del atributo free text de los tickets, mostradas en la ventana de redactar ticket de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.';
    $Lang->{'Ticket free text options shown in the email ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = 'Opciones del atributo free text de los tickets, mostradas en la ventana de ticket de e-mail de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.';
    $Lang->{'Ticket free text options shown in the phone ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = 'Opciones del atributo free text de los tickets, mostradas en la ventana de ticket telefónico de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.';
    $Lang->{'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} = 'Mediante la interfaz de agente, establece un tipo para el ticket actual en la ventana de prioridad, accedida a través del detalle de dicho ticket (Ticket::Type tiene que estar habilitado).';
    $Lang->{'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} = 'Mediante la interfaz de agente, establece un servicio para el ticket actual en la ventana de prioridad, accedida a través del detalle de dicho ticket (Ticket::Type tiene que estar habilitado).';
    $Lang->{'Ticket free text options shown in the ticket search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = 'Opciones del atributo free text de los tickets, mostradas en la ventana de búsqueda de tickets de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.';
    $Lang->{'Ticket free time options shown in the ticket search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = 'Opciones del atributo free time de los tickets, mostradas en la ventana de búsqueda de tickets de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.';
    $Lang->{'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.'} = 'Muesta un vínculo en el menú para agregar al ticket un campo free text, en el detalle de dicho ticket de la interfaz del agente.';

    return 1;
}

1;
