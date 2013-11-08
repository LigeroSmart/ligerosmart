# --
# Kernel/Language/es_Survey.pm - translation file
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_Survey;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAASurvey
    $Self->{Translation}->{'- Change Status -'} = '';
    $Self->{Translation}->{'Add New Survey'} = '';
    $Self->{Translation}->{'Survey Edit'} = 'Editar Encuesta';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Editar Preguntas de Estadística';
    $Self->{Translation}->{'Question Edit'} = '';
    $Self->{Translation}->{'Answer Edit'} = '';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = '';
    $Self->{Translation}->{'Status changed.'} = '';
    $Self->{Translation}->{'Thank you for your feedback.'} = '';
    $Self->{Translation}->{'The survey is finished.'} = '';
    $Self->{Translation}->{'Complete'} = 'Completa';
    $Self->{Translation}->{'Incomplete'} = 'Incompleta';
    $Self->{Translation}->{'Checkbox (List)'} = '';
    $Self->{Translation}->{'Radio'} = '';
    $Self->{Translation}->{'Radio (List)'} = '';
    $Self->{Translation}->{'Stats Overview'} = 'Resumen de Estadisticas';
    $Self->{Translation}->{'Survey Description'} = 'Descripción de la Encuesta';
    $Self->{Translation}->{'Survey Introduction'} = 'Introducción de la Encuesta';
    $Self->{Translation}->{'Yes/No'} = '';
    $Self->{Translation}->{'YesNo'} = '';
    $Self->{Translation}->{'answered'} = '';
    $Self->{Translation}->{'not answered'} = '';
    $Self->{Translation}->{'Stats Detail'} = '';
    $Self->{Translation}->{'You have already answered the survey.'} = '';

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Crear Nueva Encuesta';
    $Self->{Translation}->{'Introduction'} = 'Introducción';
    $Self->{Translation}->{'Internal Description'} = 'Descripción Interna';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Editar información General';
    $Self->{Translation}->{'Survey#'} = 'Encuesta#';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Editar Preguntas';
    $Self->{Translation}->{'Add Question'} = 'Agregar Pregunta';
    $Self->{Translation}->{'Type the question'} = 'Escriba la pregunta';
    $Self->{Translation}->{'Answer required'} = '';
    $Self->{Translation}->{'Survey Questions'} = 'Preguntas de Estadistica';
    $Self->{Translation}->{'Question'} = 'Pregunta';
    $Self->{Translation}->{'Answer Required'} = '';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'No hay preguntas almacenadas para esta encuesta.';
    $Self->{Translation}->{'Edit Question'} = 'Editar Pregunta';
    $Self->{Translation}->{'go back to questions'} = 'regresar a preguntas';
    $Self->{Translation}->{'Possible Answers For'} = 'Posibles respuestas para';
    $Self->{Translation}->{'Add Answer'} = 'Agregar Respuesta';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Esta pregunta no tiene varias respuestas, un area de texto será mostrada';
    $Self->{Translation}->{'Go back'} = 'Regresar';
    $Self->{Translation}->{'Edit Answer'} = 'Editar Respuesta';
    $Self->{Translation}->{'go back to edit question'} = 'volver a editar pregunta';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Configuraciones de Contexto';
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Numero máximo de encuestas mostradas por página';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Remitente de Notificacion';
    $Self->{Translation}->{'Notification Subject'} = 'Asunto de Notificación';
    $Self->{Translation}->{'Notification Body'} = 'Cuerpo de Notificación';
    $Self->{Translation}->{'Changed By'} = 'Modificaco por';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = '';
    $Self->{Translation}->{'Requests Table'} = 'Tabla de Solicitudes';
    $Self->{Translation}->{'Send Time'} = 'Tiempo de Envío';
    $Self->{Translation}->{'Vote Time'} = 'Tiempo de Voto';
    $Self->{Translation}->{'Survey Stat Details'} = 'Detalles de Estadisticas de Encuesta';
    $Self->{Translation}->{'go back to stats overview'} = 'regresar a resúmen de estadisticas';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Información de Encuesta';
    $Self->{Translation}->{'Sent requests'} = 'Solicitudes enviadas';
    $Self->{Translation}->{'Received surveys'} = 'Solicitudes recibidas';
    $Self->{Translation}->{'Survey Details'} = 'Detalles de Encuesta';
    $Self->{Translation}->{'Survey Results Graph'} = 'Grafica de Resultados de Encuesta';
    $Self->{Translation}->{'No stat results.'} = 'No hay graficas de resultados.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Encuesta';
    $Self->{Translation}->{'Please answer these questions'} = '';
    $Self->{Translation}->{'Show my answers'} = '';
    $Self->{Translation}->{'These are your answers'} = '';
    $Self->{Translation}->{'Survey Title'} = '';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Un Módulo de Encuestas.';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Un módulo para editar las preguntas de una encuesta.';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        'Todos los parametros para el objeto Encuesta en la interfase de agente.';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        '';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Cuerpo default para el email de notificación a los clientes sobre la encuesta.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Remitente default para el email de notificación a los clientes sobre la encuesta.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Asunto default para el email de notificación a los clientes sobre la encuesta.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Define una módulo resumen para mostrar la vista pequeña de la lista de encuestas.';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        '';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ).'} =
        '';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        'Define la altura predefinida para la vista de texto enriquecido para los elementos de la pantall de detalle de estadisticas.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        '';
    $Self->{Translation}->{'Edit Survey General Information'} = '';
    $Self->{Translation}->{'Edit Survey Questions'} = '';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        'Registro de módulo frontend SurveyZoom en la interface del agente.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        'Registro de módulo frontend PublicSurvey en la interface pública.';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Si esta expresión regular concuerda, la encuesta no será enviada.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Parametros para las páginas (en que las encuestas son mostradas) de la vista de resumen pequeña.';
    $Self->{Translation}->{'Public Survey.'} = 'Encuesta Pública.';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Survey Edit Module.'} = '';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Limite de la vista de resumen pequeña.';
    $Self->{Translation}->{'Survey Stats Module.'} = '';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Modulo de Detalle de Encuesta.';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = '';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = '';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'El identificador para una encuesta, ejemplo Survey#, MySurvey#. Por defecto es Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        '';
    $Self->{Translation}->{'Zoom Into Statistics Details'} = '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Changed Time'} = 'Tiempo de modificación';
    $Self->{Translation}->{'Created By'} = 'Creado por';
    $Self->{Translation}->{'Created Time'} = 'Tiempo de Creación';
    $Self->{Translation}->{'Days starting from the latest customer survey email between no customer survey email is sent, ( 0 means Always send it ) .'} =
        'Dias comenzando desde la última en cuesta enviada al cliente ( 0 significa enviala siempre ) .';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the column.'} =
        'Define las columnas mostradas en la vista \'Resumen de Estadisticas\'.';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen on public interface to show data of an specific votation when customer tries to answer a survey by second time.'} =
        'Habilitar o deshabilitar la pantalla de ShowVoteData screen en la interfase publica para mostrar los datos de un voteo cuando el cliente intenta contestar la encuesta por segunda vez.';
    $Self->{Translation}->{'General Info'} = 'Información General';
    $Self->{Translation}->{'Please answer the next questions'} = 'Por favor conteste las siguientes preguntas';
    $Self->{Translation}->{'Stats Details'} = 'Detalle de Estadísticas';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small".'} = 'Limite de encuestas por página para la vista de resumen pequeña.';
    $Self->{Translation}->{'This field is required'} = 'Este campo es requerido';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket gets closed.'} =
        'Modulo de evento de Ticket para enviar automaticamente correos de solicitudes de encuesta a clientes si el ticket se ha cerrado.';

}

1;
