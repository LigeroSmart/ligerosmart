# --
# Kernel/Language/es_MX_OTRSMasterSlave.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_MX_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketBulk
    $Self->{Translation}->{'MasterTicket'} = 'Ticket Maestro';

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Manage Master/Slave'} = 'Gestión Maestro/Escalvo';

    # SysConfig
    $Self->{Translation}->{'Adds customers email addresses to recipients in the ticket compose screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Allows adding notes in the close ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Permite añadir notas en la pantalla de ticket Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Allows adding notes in the ticket note screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Allows to enable a special log for all communication between iPhone and otrs.'} =
        '';
    $Self->{Translation}->{'Allows to set a new ticket state in the move ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Allows to set a new ticket state in the new phone ticket ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'Modifica el estado Maestro-Esclavo del ticket.';
    $Self->{Translation}->{'Configure access restrictions to objects of iPhone handle.'} = '';
    $Self->{Translation}->{'Define dynamic field name for master ticket feature.'} = 'Define el nombre del campo dinámico para la funcionalidad de ticket maestro.';
    $Self->{Translation}->{'Defines if a ticket lock is required in the close ticket screen of the iPhone interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        '';
    $Self->{Translation}->{'Defines if a ticket lock is required in the move ticket screen of the iPhone interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        '';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Define el bloqueo requerido in la pantalla de ticket Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente (si el ticket no ha sido bloqueado aun, el ticket se bloquea y el agente actual se convertirá automáticamente en el dueño del mismo).';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket compose screen of the iPhone interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        '';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket note screen of the iPhone interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        '';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the close ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the move ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Define el siguiente estado del ticket después de añadir una nota, en la pantalla de ticket Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket note screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the default ticket priority in the close ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the default ticket priority in the move ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the default ticket priority in the new phone ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Define la prioridad por defecto en la pantalla de ticket Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket note screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the default type of the note in the close ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the default type of the note in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Define el tipo de nota por defecto en la pantalla de ticket Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Defines the default type of the note in the ticket note screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the default type of the ticket in the new phone ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the history comment for the close ticket screen action, which gets used for ticket history in the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the history comment for the new phone ticket screen action, which gets used for ticket history in the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Define el comentario del historial para la acción de la pantalla del ticket Maestro-Esclavo, que es usado para el historial del ticket en la interfaz del agente.';
    $Self->{Translation}->{'Defines the history comment for the ticket note screen action, which gets used for ticket history in the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the history type for the close ticket screen action, which gets used for ticket history in the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the history type for the new phone ticket screen action, which gets used for ticket history in the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Define el tipo de historial para la acción de la pantalla del ticket Maestro-Esclavo, que es usado para el historial del ticket en la interfaz del agente.';
    $Self->{Translation}->{'Defines the history type for the ticket note screen action, which gets used for ticket history in the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the close ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Define el siguiente estado después de añadir una nota, en la pantalla de ticket Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket note screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Defines the path and file name for the debug log file. This file will be automatically created by the system, if it doesn\'t exist.'} =
        '';
    $Self->{Translation}->{'Dynamic Fields Extension.'} = '';
    $Self->{Translation}->{'Dynamic fields shown in the new phone ticket screen of the iPhone interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the ticket close screen of the iPhone interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the ticket compose screen of the iPhone interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the ticket move screen of the iPhone interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the ticket note screen of the iPhone interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Enable the advanced MasterSlave part of the feature.'} = 'Activa el modo avanzado para la funcionalidad Maestro-Esclavo.';
    $Self->{Translation}->{'Enable the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'} =
        'Activa la funcionalidad para que tickets Esclavo acompañen a su ticket Maestro hacia uno nuevo en el modo avanzado para Maestro-Esclavo.';
    $Self->{Translation}->{'Enable the feature to change the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Activa la funcionalidad para cambiar el estado Maestro-Esclavo de un ticket en el modo avanzado para Maestro-Esclavo.';
    $Self->{Translation}->{'Enable the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Activa la funcionalidad para suprimir el estado Maestro-Esclavo de un ticket en el modo avanzado para Maestro-Esclavo.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket if it is composed / answered in the ticket compose screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Si una nota es añadida por un agente, fija el estado del ticket en en la pantalla de ticket Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Module to generate statistics about OTRS ITSM downloads.'} = '';
    $Self->{Translation}->{'Module to generate statistics about OTRS downloads.'} = '';
    $Self->{Translation}->{'Module to generate statistics about public extension downloads.'} =
        '';
    $Self->{Translation}->{'Module to generate statistics about tickets with defined OTRS systems.'} =
        '';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        '';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        '';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'Registro del móduo de evento para tickets.';
    $Self->{Translation}->{'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Required permissions to use the close ticket screen in the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Required permissions to use the move ticket screen in the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Permisos requeridos para usar la pantalla Maestro-Esclavo de un ticket, en la vista detallada de dicho ticket de la interfaz del agente.';
    $Self->{Translation}->{'Required permissions to use the ticket compose screen in the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Required permissions to use the ticket note screen in the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the customer id in the new phone ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the default body text for notes added in the close ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the default body text for notes added in the move ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the default body text for notes added in the new phone ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Fija el texto del cuerpo por defecto de las notas añadidas en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket note screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the default next state for new phone tickets in the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the default sender type for new phone ticket in the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the default subject for notes added in the close ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the default subject for notes added in the move ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Fija el asunto por defecto de las notas añadidas en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket note screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the close ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the new phone ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Fija el agente responsable de un ticket en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket note screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the service in the close ticket screen of the iPhone interface (Ticket::Service needs to be activated).'} =
        '';
    $Self->{Translation}->{'Sets the service in the new phone ticket screen of the iPhone interface (Ticket::Service needs to be activated).'} =
        '';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Fija el servicio de un ticket en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente (Ticket::Service require ser activado).';
    $Self->{Translation}->{'Sets the service in the ticket note screen of the iPhone interface (Ticket::Service needs to be activated).'} =
        '';
    $Self->{Translation}->{'Sets the ticket owner in the close ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the ticket owner in the move ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the ticket owner in the new phone ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Fija el dueño de un ticket en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Sets the ticket owner in the ticket note screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the ticket type in the close ticket screen of the iPhone interface (Ticket::Type needs to be activated).'} =
        '';
    $Self->{Translation}->{'Sets the ticket type in the new phone ticket screen on the iPhone interface (Ticket::Type needs to be activated).'} =
        '';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Fija el tipo de ticket en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente (Ticket::Type require ser activado).';
    $Self->{Translation}->{'Sets the ticket type in the ticket note screen of the iPhone interface (Ticket::Type needs to be activated).'} =
        '';
    $Self->{Translation}->{'Sets the time units in the close ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the time units in the move ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the time units in the new phone ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the time units in the ticket compose screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Sets the time units in the ticket note screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'Muestra un enlace en el menú para cambiar el estatus Maestro-Esclavo de un ticket, en la vista detallada de dicho ticket de la interfaz del agente.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Muestra una lista de todos los agentes involucrados con este ticket, en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket de la interfaz del agente.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Muestra una lista de todos los posibles agentes (todos los agentes con permisos "nota" en la fila/ticket) para determinar quién deberá ser informado acerca de esta nota, en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket de la interfaz del agente.';
    $Self->{Translation}->{'Shows the ticket priority options in the close ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Shows the ticket priority options in the move ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Muestra las opciones de prioridad de ticket en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket de la interfaz del agente.';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket note screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Shows the title fields in the close ticket screen of the iPhone interface.'} =
        '';
    $Self->{Translation}->{'Shows the title fields in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Muestra los campos título en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket de la interfaz del agente.';
    $Self->{Translation}->{'Shows the title fields in the ticket note screen of the iphone interface.'} =
        '';
    $Self->{Translation}->{'Specifies the different article types where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        '';
    $Self->{Translation}->{'Specify the different note types, that you want to use in your system.'} =
        '';
    $Self->{Translation}->{'This module is preparing master/slave pulldown in email and phone ticket.'} =
        'Este módulo prepara el contenido para el selector de Maestro-Eslcavo en las pantallas de ticket telefónico y de correo.';
    $Self->{Translation}->{'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the iPhone interface.'} =
        '';

}

1;
