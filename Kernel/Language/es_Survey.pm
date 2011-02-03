# --
# Kernel/Language/es_Survey.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: es_Survey.pm,v 1.2 2011-02-03 23:19:38 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_Survey;

use strict;

sub Data {
    my $Self = shift;

    # Template: AgentSurvey
    $Self->{Translation}->{'Create New Survey'} = 'Crear Nueva Encuesta';
    $Self->{Translation}->{'Introduction'} = 'Introducción';
    $Self->{Translation}->{'Internal Description'} = 'Descripción Interna';
    $Self->{Translation}->{'Survey Edit'} = 'Editar Encuesta';
    $Self->{Translation}->{'General Info'} = 'Información General';
    $Self->{Translation}->{'Stats Overview'} = 'resúmen Estadisticas';
    $Self->{Translation}->{'Requests Table'} = 'Tabla de Solicitudes';
    $Self->{Translation}->{'Send Time'} = 'Tiempo de Envío';
    $Self->{Translation}->{'Vote Time'} = 'Tiempo de Voto';
    $Self->{Translation}->{'Details'} = 'Detalles';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'No hay preguntas almacenadas para esta encuesta.';
    $Self->{Translation}->{'Survey Stat Details'} = 'Detalles de Estadisticas de Encuesta';
    $Self->{Translation}->{'go back to stats overview'} = 'regresar a resúmen de estadisticas';
    $Self->{Translation}->{'Go Back'} = 'Regresar';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Survey Edit Questions'} = 'Editar Preguntas de Estadística';
    $Self->{Translation}->{'Add Question'} = 'Agregar Pregunta';
    $Self->{Translation}->{'Type the question'} = 'Escriba la pregunta';
    $Self->{Translation}->{'Survey Questions'} = 'Preguntas de Estadistica';
    $Self->{Translation}->{'Question'} = 'Pregunta';
    $Self->{Translation}->{'Edit Question'} = 'Editar Pregunta';
    $Self->{Translation}->{'go back to questions'} = 'regresar a preguntas';
    $Self->{Translation}->{'Possible Answers For'} = 'Posibles respuestas para';
    $Self->{Translation}->{'Add Answer'} = 'Agregar Respuesta';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Esta pregunta no tiene varias respuestas, un area de texto será mostrada';
    $Self->{Translation}->{'Edit Answer'} = 'Editar Respuesta';
    $Self->{Translation}->{'go back to edit question'} = 'volver a editar pregunta';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Configuraciones de Contexto';
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Numero máximo de encuestas mostradas por página';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Remitente de Notificacion';
    $Self->{Translation}->{'Notification Subject'} = 'Asunto de Notificación';
    $Self->{Translation}->{'Notification Body'} = 'Cuerpo de Notificación';
    $Self->{Translation}->{'Created Time'} = 'Tiempo de Creación';
    $Self->{Translation}->{'Created By'} = 'Creado por';
    $Self->{Translation}->{'Changed Time'} = 'Tiempo de modificación';
    $Self->{Translation}->{'Changed By'} = 'Modificaco por';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Información de Encuesta';
    $Self->{Translation}->{'Sent requests'} = 'Solicitudes enviadas';
    $Self->{Translation}->{'Received surveys'} = 'Solicitudes recibidas';
    $Self->{Translation}->{'Edit General Info'} = 'Editar información General';
    $Self->{Translation}->{'Edit Questions'} = 'Editar Preguntas';
    $Self->{Translation}->{'Stats Details'} = 'Detalle de Estadísticas';
    $Self->{Translation}->{'Survey Details'} = 'Detalles de Encuesta';
    $Self->{Translation}->{'Survey Results Graph'} = 'Grafica de Resultados de Encuesta';
    $Self->{Translation}->{'No stat results.'} = 'No hay graficas de resultados.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Encuesta';
    $Self->{Translation}->{'Please answer the next questions'} = 'Por favor conteste las siguientes preguntas';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Un Módulo de Encuestas';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Un módulo para editar las preguntas de una encuesta';
    $Self->{Translation}->{'Days starting from the latest customer survey email between no customer survey email is sent, ( 0 means Always send it ) .'} =
        'Dias comenzando desde la última en cuesta enviada al cliente ( 0 significa enviala siempre ) .';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Cuerpo default para el email de notificación a los clientes sobre la encuesta.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Remitente default para el email de notificación a los clientes sobre la encuesta. ';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Asunto default para el email de notificación a los clientes sobre la encuesta.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Define una módulo resumen para mostrar la vista pequeña de la lista de encuestas.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the column.'} =
        'Define las columnas mostradas en la vista \'Resumen de Estadisticas\'';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        'Registro de módulo frontend SurveyZoom en la interface del agente.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        'Registro de módulo frontend PublicSurvey en la interface pública.';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} =
        'Si esta expresión regular concuerda, la encuesta no será enviada';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Parametros para las páginas (en que las encuestas son mostradas) de la vista de resumen pequeña.';
    $Self->{Translation}->{'Public Survey.'} =
        'Encuesta Pública';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Limite de la vista de resumen pequeña';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Modulo de Detalle de Encuesta';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} =
        'Limite de encuestas por página para la vista de resumen pequeña';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'El identificador para una encuesta, ejemplo Survey#, MySurvey#. Por defecto es Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket gets closed.'} =
        'Modulo de evento de Ticket para enviar automaticamente correos de solicitudes de encuesta a clientes si el ticket se ha cerrado';

}

1;
