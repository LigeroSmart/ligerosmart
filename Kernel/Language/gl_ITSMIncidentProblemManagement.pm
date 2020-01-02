# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::gl_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketOverviewMedium
    $Self->{Translation}->{'Criticality'} = 'Criticidad';
    $Self->{Translation}->{'Impact'} = 'Impacto';

    # JS Template: ServiceIncidentState
    $Self->{Translation}->{'Service Incident State'} = 'Estado de Incidente de Servizo';

    # Perl Module: Kernel/Output/HTML/FilterElementPost/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Link ticket'} = 'Vincule ticket';
    $Self->{Translation}->{'Change Decision of %s%s%s'} = '';
    $Self->{Translation}->{'Change ITSM fields of %s%s%s'} = '';

    # Perl Module: var/packagesetup/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Review Required'} = 'Precisa revisión';
    $Self->{Translation}->{'Decision Result'} = 'Resultado da decisión';
    $Self->{Translation}->{'Approved'} = '';
    $Self->{Translation}->{'Postponed'} = '';
    $Self->{Translation}->{'Pre-approved'} = '';
    $Self->{Translation}->{'Rejected'} = '';
    $Self->{Translation}->{'Repair Start Time'} = 'Hora de inicio da reparación';
    $Self->{Translation}->{'Recovery Start Time'} = 'Tempo de Inicio de Recuperación';
    $Self->{Translation}->{'Decision Date'} = 'Data da decisión';
    $Self->{Translation}->{'Due Date'} = 'Data de vencemento';

    # Database XML Definition: ITSMIncidentProblemManagement.sopm
    $Self->{Translation}->{'closed with workaround'} = 'pechado con apaño';

    # SysConfig
    $Self->{Translation}->{'Add a decision!'} = 'Engada unha decisión!';
    $Self->{Translation}->{'Additional ITSM Fields'} = 'Campos ITSM Adicionáis';
    $Self->{Translation}->{'Additional ITSM ticket fields.'} = '';
    $Self->{Translation}->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} =
        'Permite engadir notas na pantalla campo adicional ITSM da interface de axente.';
    $Self->{Translation}->{'Allows adding notes in the decision screen of the agent interface.'} =
        'Permite engadir notas na pantalla decisión da interface de axente.';
    $Self->{Translation}->{'Allows defining new types for ticket (if ticket type feature is enabled).'} =
        'Permitir á definición de novos tipos de ticket (se a función tipo de ticket está habilitada).';
    $Self->{Translation}->{'Change the ITSM fields!'} = 'Cambie os campos ITSM!';
    $Self->{Translation}->{'Decision'} = 'Decisión';
    $Self->{Translation}->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Define se un bloqueo de ticket é requirido na pantalla de campo adicional ITSM da interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).';
    $Self->{Translation}->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Define se un bloqueo de ticket é requirido na pantalla de sdecisión da interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).';
    $Self->{Translation}->{'Defines if the service incident state should be shown during service selection in the agent interface.'} =
        'Define se o estado de incidente de servizo debe ser mostrado durante a selección de servizo na interface de axente.';
    $Self->{Translation}->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} =
        'Define o corpo por defecto dunha nota na pantalla campo ITSM adicional da interface de axente.';
    $Self->{Translation}->{'Defines the default body of a note in the decision screen of the agent interface.'} =
        'Define o corpo por defecto dunha nota na pantalla dedecisión da interface de axente.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Define o próximo estado por defecto dun ticket despois de engadir unha nota, na pantalla campo ITSM adicional da interface de axente.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Define o próximo estado por defecto dun ticket despois de engadir unha nota, na pantalla de decisión da interface de axente.';
    $Self->{Translation}->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} =
        'Define o tema por defecto dunha nota na pantalla campo ITSM adicional da interface de axente.';
    $Self->{Translation}->{'Defines the default subject of a note in the decision screen of the agent interface.'} =
        'Define o tema por defecto dunha nota na pantalla de decisión da interface de axente.';
    $Self->{Translation}->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} =
        'Define a prioridade do ticket por defecto na pantalla campo ITSM adicional da interface de axente.';
    $Self->{Translation}->{'Defines the default ticket priority in the decision screen of the agent interface.'} =
        'Define a prioridade do ticket por defecto na pantalla de decisión da interface de axente.';
    $Self->{Translation}->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Define o histórico dos comentarios para a acción da pantalla campo ITSM adicional, o cal é usado para o histórico do ticket.';
    $Self->{Translation}->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} =
        'Define o histórico dos comentarios para a acción da pantalla de decisión, o cal é usado para o histórico do ticket.';
    $Self->{Translation}->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Define o histórico dos tipos para a acción da pantalla campo ITSM adicional, o cal é usado para o histórico do ticket.';
    $Self->{Translation}->{'Defines the history type for the decision screen action, which gets used for ticket history.'} =
        'Define o histórico dos tipos para a acción da pantalla de decisión, o cal é usado para o histórico do ticket.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Define o seguinte estado dun ticket despois de engadir unha nota, na pantalla campo ITSM adicional da interface de axente.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Define o seguinte estado dun ticket despois de engadir unha nota, na pantalla de decisión da interface de axente.';
    $Self->{Translation}->{'Dynamic fields shown in the additional ITSM field screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the decision screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the ticket zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} =
        'Activar módulo estatístico para xerar estatísticas sobre a media da taxa de resolución en primeiro nivel de tickets ITSM.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} =
        'Activar módulo estatístico para xerar estatísticas sobre a media da resolución de tickets ITSM.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} =
        'Se unha nota é engadida por un axente, establece o estado dun ticket na pantalla campo ITSM adicional da interface de axente.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} =
        'Se unha nota é engadida por un axente, establece o estado dun ticket na pantalla de decisión da interface de axente.';
    $Self->{Translation}->{'Modifies the display order of the dynamic field ITSMImpact and other things.'} =
        '';
    $Self->{Translation}->{'Module to dynamically show the service incident state and to calculate the priority.'} =
        '';
    $Self->{Translation}->{'Required permissions to use the additional ITSM field screen in the agent interface.'} =
        'Permisos requiridos para usar a pantalla campo ITSM adicional na interface de axente.';
    $Self->{Translation}->{'Required permissions to use the decision screen in the agent interface.'} =
        'Permisos requiridos para usar a pantalla de decisión na interface de axente.';
    $Self->{Translation}->{'Service Incident State and Priority Calculation'} = '';
    $Self->{Translation}->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Establece o servizo na pantalla de campo ITSM adicional da interface de axente (Ticket::Servizo debe ser activado).';
    $Self->{Translation}->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Establece o servizo na pantalla de decisión da interface de axente (Ticket::Servizo debe ser activado).';
    $Self->{Translation}->{'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Establece o servizo na pantalla prioridade de ticketdun ticket zoom na interface de axente (Ticket::Service necesita ser activado).';
    $Self->{Translation}->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} =
        'Establece o propietario de ticket na pantalla campo ITSM adicional da interface de axente.';
    $Self->{Translation}->{'Sets the ticket owner in the decision screen of the agent interface.'} =
        'Establece o propietario de ticket na pantalla de decisión da interface de axente.';
    $Self->{Translation}->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} =
        'Establece o responsable de ticket na pantalla campo ITSM adicional da interface de axente.';
    $Self->{Translation}->{'Sets the ticket responsible in the decision screen of the agent interface.'} =
        'Establece o propietario de ticket na pantalla de decisión da interface de axente.';
    $Self->{Translation}->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Establece o tipo de ticket na pantalla campo ITSM adicional da interface de axente (Ticket::Tipo ten que ser activado).';
    $Self->{Translation}->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Establece o tipo de ticket na pantalla de decisión da interface de axente (Ticket::Tipo ten que ser activado).';
    $Self->{Translation}->{'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Establece o tipo de ticket na pantalla prioridade de ticket dun ticket zoom na interface de axente (Ticket::Type necesita estar activo).';
    $Self->{Translation}->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} =
        'Mostra un enlace no menu para cambiar a decisión dun ticket na súa vista zoom da interface de axente.';
    $Self->{Translation}->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} =
        'Mostra un enlace no menu para cambiar campos ITSM adicionáis na vista zoom de ticket da interface de axente.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} =
        'Mostra unha lista de tódolos axentes implicados neste ticket, na pantalla campo ITSM adicional da interface de axente.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} =
        'Mostra unha lista de tódolos axentes implicados neste ticket, na pantalla de decisión da interface de axente.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} =
        'Mostra unha lista de tódolos posibles axentes (tódolos axentes con permisos de nota nesta cola/ticket) para determinar quen debe ser informado sobre esta nota, na pantalla campo ITSM adicional da interface de axente.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} =
        'Mostra unha lista de tódolos posibles axentes (tódolos axentes con permisos de nota nesta cola/ticket) para determinar quen debe ser informado sobre esta nota, na pantalla de decisión da interface de axente.';
    $Self->{Translation}->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} =
        'Mostra as opcións de prioridade de ticket na pantalla campo ITSM adicional da interface de axente.';
    $Self->{Translation}->{'Shows the ticket priority options in the decision screen of the agent interface.'} =
        'Mostra as opcións de prioridade de ticket na pantalla de decisión da interface de axente.';
    $Self->{Translation}->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} =
        'Mostra campos de título na pantalla campo ITSM adicional da interface de axente.';
    $Self->{Translation}->{'Shows the title fields in the decision screen of the agent interface.'} =
        'Mostra os campos de título na pantalla de decisións da interface do axente.';
    $Self->{Translation}->{'Ticket decision.'} = '';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Service Incident State',
    );

}

1;
