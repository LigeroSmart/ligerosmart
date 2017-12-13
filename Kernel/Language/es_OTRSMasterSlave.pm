# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminDynamicFieldMasterSlave
    $Self->{Translation}->{'Field'} = 'Campo';

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Manage Master/Slave status for %s%s%s'} = 'Gestionar el estado Maestro/Esclavo para  %s%s%s';

    # Perl Module: Kernel/Modules/AgentTicketMasterSlave.pm
    $Self->{Translation}->{'New Master Ticket'} = 'Nuevo ticket maestro';
    $Self->{Translation}->{'Unset Master Ticket'} = 'Desactivar ticket maestro';
    $Self->{Translation}->{'Unset Slave Ticket'} = 'Desactivar ticket esclavo';
    $Self->{Translation}->{'Slave of %s%s%s: %s'} = 'Esclavo de %s%s%s: %s';

    # Perl Module: Kernel/Output/HTML/TicketBulk/MasterSlave.pm
    $Self->{Translation}->{'Unset Master Tickets'} = 'Desactivar tickets maestros';
    $Self->{Translation}->{'Unset Slave Tickets'} = 'Desactivar tickets esclavos';

    # Perl Module: Kernel/System/DynamicField/Driver/MasterSlave.pm
    $Self->{Translation}->{'Master Ticket'} = 'Ticket Maestro';

    # SysConfig
    $Self->{Translation}->{'All master tickets'} = 'Todos los Tickets maestros';
    $Self->{Translation}->{'All slave tickets'} = 'Todos los Tickets esclavos';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Permite añadir notas en la pantalla de ticket Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'Modifica el estado Maestro-Esclavo del ticket.';
    $Self->{Translation}->{'Defines dynamic field name for master ticket feature.'} = 'Define el nombre del campo dinámico para la función de ticket maestro.';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Define el bloqueo requerido in la pantalla de ticket Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente (si el ticket no ha sido bloqueado aun, el ticket se bloquea y el agente actual se convertirá automáticamente en el dueño del mismo).';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Define el siguiente estado del ticket después de añadir una nota, en la pantalla de ticket Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Define la prioridad por defecto en la pantalla de ticket Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Defines the default type of the note in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Define el tipo de nota por defecto en la pantalla de ticket Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Define el comentario del historial para la acción de la pantalla del ticket Maestro-Esclavo, que es usado para el historial del ticket en la interfaz del agente.';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Define el tipo de historial para la acción de la pantalla del ticket Maestro-Esclavo, que es usado para el historial del ticket en la interfaz del agente.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Define el siguiente estado después de añadir una nota, en la pantalla de ticket Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Enables the advanced MasterSlave part of the feature.'} = 'Activa la parte Maestro-Esclavo avanzada de la función.';
    $Self->{Translation}->{'Enables the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'} =
        'Activa la función de que los tickets esclavos siguen el ticket maestro a un nuevo maestro en el modo Maestro-Esclavo avanzado.';
    $Self->{Translation}->{'Enables the feature to change the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Activa la función que cambie el estado Maestro-Esclavo de un ticket en el modo Maestro-Esclavo avanzado.';
    $Self->{Translation}->{'Enables the feature to forward articles from type \'forward\' of a master ticket to the customers of the slave tickets. By default (disabled) it will not forward articles from type \'forward\' to the slave tickets.'} =
        'Habilita la característica para reenviar artículos desde el tipo \'reenviar\' de un ticket maestro a los clientes de los tickets esclavos. Por defecto (deshabilitado) no reenviará artículos del tipo \'reenviar\' a los tickets esclavos.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after change of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Permite que la característica para mantener el enlace padre-hijo después del cambio de estado MaestroEsclavo en el modo avanzado MaestroEsclavo.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after unset of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Habilita la característica para mantener el enlace padre-hijo después de desactivar el estado MaestroEsclavo en el avanzado de MaestroEsclavo.';
    $Self->{Translation}->{'Enables the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Habilita la característica para desactivar el estado de MaestroEsclado de un ticket en el modo avanzado de MaestroEsclavo.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Si una nota es añadida por un agente, fija el estado del ticket en en la pantalla de ticket Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Master / Slave'} = 'Maestro / Esclavo';
    $Self->{Translation}->{'Master Tickets'} = 'Tickets Maestros';
    $Self->{Translation}->{'MasterSlave'} = 'Maestro-Esclavo';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = 'Módulo Esclavo Maestro para mayor características de entradas.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parámetros de el dashboard backend de la vista de los tickets maestros de la interfaz del agente. "Limite" es el numero de entradas a mostrar por defecto. "Grupo" es usado para restringir el acceso a el plugin (E.J. Grupo: admin;grupo1;grupo2;). "Defecto" determina si el plugin es activado por defecto ó si el usuario necesita activarlo manualmente. "CacheTTLLocal" es hora cache en minutos para el plugin.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parametros del backend del panel principal de la vista del ticket esclavo del interface del agente. "Limite" es el número de entrada mostradas por defecto. "Grupo"es usado para restringir el acceso al plugin (Ejm. Grupo: admin;group1;group2;). "Defecto" determina si el plugin es habilitado por defecto o si el usuario necesita habilitarlo manualmente. "CacheTTLLocal" es el tiempo de cache en minutos para el plugin';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'Registro del módulo de evento de tickets.';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Permisos requeridos para usar la pantalla Maestro-Esclavo de un ticket, en la vista detallada de dicho ticket de la interfaz del agente.';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Fija el texto del cuerpo por defecto de las notas añadidas en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Fija el asunto por defecto de las notas añadidas en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Fija el agente responsable de un ticket en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Fija el servicio de un ticket en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente (Ticket::Service require ser activado).';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Fija el dueño de un ticket en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente.';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Fija el tipo de ticket en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket en la interfaz del agente (Ticket::Type require ser activado).';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'Muestra un enlace en el menú para cambiar el estatus Maestro-Esclavo de un ticket, en la vista detallada de dicho ticket de la interfaz del agente.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Muestra una lista de todos los agentes involucrados con este ticket, en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket de la interfaz del agente.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Muestra una lista de todos los posibles agentes (todos los agentes con permisos "nota" en la fila/ticket) para determinar quién deberá ser informado acerca de esta nota, en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket de la interfaz del agente.';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Muestra las opciones de prioridad de ticket en la pantalla Maestro-Esclavo en la vista detallada de dicho ticket de la interfaz del agente.';
    $Self->{Translation}->{'Shows the title field in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Slave Tickets'} = 'Tickets esclavo';
    $Self->{Translation}->{'Specifies the different article types where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        'Especificar los diferentes tipos de artículos donde el verdadero nombre del tickey maestro será reemplazado con el del ticket esclavo.';
    $Self->{Translation}->{'Specifies the different note types that will be used in the system.'} =
        'Especifica los diferentes tipos de notas que se usarán en el sistema.';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        'Este módulo activa el campo Maestro-Esclavo en la pantalla de un nuevo ticket de email o de teléfono.';
    $Self->{Translation}->{'Ticket MasterSlave.'} = 'Ticket Maestro-Esclavo.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
