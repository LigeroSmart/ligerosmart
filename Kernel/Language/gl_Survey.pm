# --
# Kernel/Language/gl_Survey.pm - translation file
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::gl_Survey;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAASurvey
    $Self->{Translation}->{'- Change Status -'} = '- Cambiar o estado -';
    $Self->{Translation}->{'Add New Survey'} = 'Engadir unha enquisa nova';
    $Self->{Translation}->{'Survey Edit'} = 'Editar enquisa';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Editar Preguntas da Enquisa';
    $Self->{Translation}->{'Question Edit'} = 'Editar Pregunta';
    $Self->{Translation}->{'Answer Edit'} = 'Editar Resposta';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'Non se pode establecer o novo status!Non hai preguntas definidas.';
    $Self->{Translation}->{'Status changed.'} = 'Estado cambiado.';
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Grazas pola súa opinión.';
    $Self->{Translation}->{'The survey is finished.'} = 'A enquisa está rematada.';
    $Self->{Translation}->{'Complete'} = 'Completa';
    $Self->{Translation}->{'Incomplete'} = 'Incompleta';
    $Self->{Translation}->{'Checkbox (List)'} = 'Opción non excluínte (lista)';
    $Self->{Translation}->{'Radio'} = 'Opción excluínte';
    $Self->{Translation}->{'Radio (List)'} = 'Opción excluínte (lista)';
    $Self->{Translation}->{'Stats Overview'} = 'Vista xeral das estatísticas';
    $Self->{Translation}->{'Survey Description'} = 'Descrición da enquisa';
    $Self->{Translation}->{'Survey Introduction'} = 'Introdución á enquisa';
    $Self->{Translation}->{'Yes/No'} = 'Si/Non';
    $Self->{Translation}->{'YesNo'} = 'SiNon';
    $Self->{Translation}->{'answered'} = 'respondida';
    $Self->{Translation}->{'not answered'} = 'non respondida';
    $Self->{Translation}->{'Stats Detail'} = 'Detalle das estatísticas';
    $Self->{Translation}->{'Stats Details'} = 'Detalles das estatísticas';
    $Self->{Translation}->{'You have already answered the survey.'} = 'Xa respondeu a esta enquisa.';
    $Self->{Translation}->{'Survey#'} = 'EnquisaNº';
    $Self->{Translation}->{'- No queue selected -'} = '- Non hai ningunha fila seleccionada -';
    $Self->{Translation}->{'Master'} = 'Principal';
    $Self->{Translation}->{'New Status'} = 'Novo estado';
    $Self->{Translation}->{'Question Type'} = 'Tipo de pregunta';

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Crear unha enquisa nova';
    $Self->{Translation}->{'Introduction'} = 'Introdución';
    $Self->{Translation}->{'Internal Description'} = 'Descrición interna';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Editar a información xeral';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Editar as preguntas';
    $Self->{Translation}->{'Add Question'} = 'Engadir unha pregunta';
    $Self->{Translation}->{'Type the question'} = 'Escriba a pregunta';
    $Self->{Translation}->{'Answer required'} = 'Requírese unha resposta';
    $Self->{Translation}->{'Survey Questions'} = 'Preguntas da enquisa';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Non hai preguntas gardadas para esta enquisa.';
    $Self->{Translation}->{'Question'} = 'Pregunta';
    $Self->{Translation}->{'Answer Required'} = 'Requírese unha resposta';
    $Self->{Translation}->{'When you finish to edit the survey questions just close this window.'} =
        'Cando remate de editar as preguntas da enquisa simplemente peche esta xanela.';
    $Self->{Translation}->{'Do you really want to delete this question? ALL associated data will be LOST!'} =
        'Confirma que desexa eliminar esta pregunta. Hanse PERDER TODOS os datos asociados!';
    $Self->{Translation}->{'Edit Question'} = 'Editar pregunta';
    $Self->{Translation}->{'go back to questions'} = 'retornar ás preguntas';
    $Self->{Translation}->{'Possible Answers For'} = 'Respostas posíbeis a';
    $Self->{Translation}->{'Add Answer'} = 'Engadir unha resposta';
    $Self->{Translation}->{'No answers saved for this question.'} = 'Non hai respostas gardadas para esta pregunta.';
    $Self->{Translation}->{'Do you really want to delete this answer?'} = 'Confirma que desexa eliminar esta pregunta?';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Isto non ten varias respostas; móstrase un cadro para escribir texto.';
    $Self->{Translation}->{'Go back'} = 'Retornar';
    $Self->{Translation}->{'Edit Answer'} = 'Editar a resposta';
    $Self->{Translation}->{'go back to edit question'} = 'retornar á edición da pregunta';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Número máximo de enquisas por páxina';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Remitente da notificación';
    $Self->{Translation}->{'Notification Subject'} = 'Asunto da notificación';
    $Self->{Translation}->{'Notification Body'} = 'Texto da notificación';
    $Self->{Translation}->{'Changed By'} = 'Cambiado por';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = 'Vista xeral das estatísticas de';
    $Self->{Translation}->{'Requests Table'} = 'Táboa de solicitudes';
    $Self->{Translation}->{'Send Time'} = 'Hora de envío';
    $Self->{Translation}->{'Vote Time'} = 'Hora de votación';
    $Self->{Translation}->{'See Details'} = 'Ver os detalles';
    $Self->{Translation}->{'Survey Stat Details'} = 'Detalles Estatísticos Enquisa';
    $Self->{Translation}->{'go back to stats overview'} = 'volte a vista xeral das estatísticas';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Información da enquisa';
    $Self->{Translation}->{'Sent requests'} = 'Enviar solicitudes';
    $Self->{Translation}->{'Received surveys'} = 'Enquisas recibidas';
    $Self->{Translation}->{'Survey Details'} = 'Detalles da enquisa';
    $Self->{Translation}->{'Ticket Services'} = 'Servizos Ticket';
    $Self->{Translation}->{'Survey Results Graph'} = 'Gráfico Resultados Enquisa';
    $Self->{Translation}->{'No stat results.'} = 'No resultados estatística';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Enquisa';
    $Self->{Translation}->{'Please answer these questions'} = 'Responda a estas preguntas, se fai o favor';
    $Self->{Translation}->{'Show my answers'} = 'Mostrar as miñas respostas';
    $Self->{Translation}->{'These are your answers'} = 'Estas son as súas respostas';
    $Self->{Translation}->{'Survey Title'} = 'Título da enquisa';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Un módulo de enquisas.';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Un módulo para editar preguntas de enquisas.';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        'Tódolos parametros para ó obxeto Enquisa na interface de axente.';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        'Cantidade de días despois de enviar unha enquisa de correo no que non se envían novas peticións de enquisa ao mesmo cliente. Seleccionando 0 enviará sempre o correo de enquisa.';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Corpo por defecto para o correo electrónico de notificación a clientes sobre nova enquisa.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Remitente por defecto para o correo electrónico de notificación a clientes sobre nova enquisa.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Tema por defecto para o correo electrónico de notificación a clientes sobre nova enquisa.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Define un módulo de vista xeral para mostrar a vista pequena dunha lista de enquisas.';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        'Define a cantidade máxima de enquisas que envíanse aos clientes por 30 días. (0 significa no máximo, tódalas peticións de enquisa serán enviadas).';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ).'} =
        'Define a cantidade en horas que un ticket debe estar pechado para disparar o envío dunha enquisa, (0 significa enviado inmediatamente despois do peche).';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        'Define a altura por defecto para vistas texto enriquecido para elementos de ZoomEnquisa.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        'Define as columnas mostradas na visión xeral de enquisa. Esta opción non ten ningún efecto sobre a posición das columnas.';
    $Self->{Translation}->{'Edit Survey General Information'} = 'Edite Información Xeral Enquisa';
    $Self->{Translation}->{'Edit Survey Questions'} = 'Edite Preguntas Enquisa';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        'Active ou desactive a pantalla MostrarDatosVoto na interface pública para mostrar datos dun resultado de enquisa especifica cando o cliente intenta responder a enquisa por segunda vez.';
    $Self->{Translation}->{'Enable or disable the send condition check for the service.'} = 'Active ou desactive a condicion de comprobacion enviar para o servizo.';
    $Self->{Translation}->{'Enable or disable the send condition check for the ticket type.'} =
        'Active ou desactive a comprobación enviar condición para o tipo de ticket.';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        'Rexistro módulo frontend para engadir enquisa na interface de axente.';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        'Rexistro módulo frontend para editar enquisa na interface de axente.';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        'Rexistro módulo frontend para estatísticas de enquisa na interface de axente.';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        'Rexistro módulo frontend para zoom de enquisa na interface de axente.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        'Rexistro módulo frontend para obxecto EnquisaPublica na área Enquisa pública.';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Se a expresión regular coincide, non enviaráse enquisa ao cliente.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Parámetros para as páxinas (nas cales as enquisas son mostradas) da vista xeral pequena da enquisa.';
    $Self->{Translation}->{'Public Survey.'} = 'Enquisa pública.';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        'Mostra un enlace no menu para editar unha enquisa na súa vista zoom da interface de axente.';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        'Mostra un enlace no menu para editar preguntas de enquisa na súa vista zoom da interface de axente.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        'Mostra un enlace no menu para voltar atrás na vista zoom de enquisa da interface de axente.';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        'Mostra un enlace no menu para facer zoom nos detalles das estatísticas da enquisa na súa vista zoom da interface de axente.';
    $Self->{Translation}->{'Survey Edit Module.'} = 'Módulo Editar Enquisa.';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Límite "Pequeno" Vista Xeral Enquisa';
    $Self->{Translation}->{'Survey Stats Module.'} = 'Módulo Estatísticas Enquisa.';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Módulo Zoom Enquisa.';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = 'Límite enquisa por páxina para Vista Xeral "Pequena" de Enquisa';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = 'Enquisas non serán enviadas aos enderezos de correo electrónico configurados.';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'O identificador para unha enquisa, ex. Enquisa#, MiñaEnquisa#, Por defecto é Enquisa#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        'Módulo evento ticket para enviar automaticamente peticións de enquisa de correo electrónico se un ticket é pechado.';
    $Self->{Translation}->{'Zoom Into Statistics Details'} = 'Zoom Nos Detalles Estatísticos';

}

1;
