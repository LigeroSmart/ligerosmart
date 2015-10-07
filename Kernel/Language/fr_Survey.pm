# --
# Kernel/Language/fr_Survey.pm - translation file
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr_Survey;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAASurvey
    $Self->{Translation}->{'- Change Status -'} = 'Changement du status';
    $Self->{Translation}->{'Add New Survey'} = 'Ajouter un sondage';
    $Self->{Translation}->{'Survey Edit'} = 'Modifier Sondage';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Modifier questionnaire du sondage';
    $Self->{Translation}->{'Question Edit'} = 'Modifier Questions';
    $Self->{Translation}->{'Answer Edit'} = 'Modifier Réponses';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'Impossible de mettre à jour ! aucune question de définis';
    $Self->{Translation}->{'Status changed.'} = 'Le status a été changé.';
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Merci pour votre retour.';
    $Self->{Translation}->{'The survey is finished.'} = 'Le sondage est terminé.';
    $Self->{Translation}->{'Complete'} = 'Terminé';
    $Self->{Translation}->{'Incomplete'} = 'Incomplet';
    $Self->{Translation}->{'Checkbox (List)'} = 'Case à cocher (Liste)';
    $Self->{Translation}->{'Radio'} = 'Bouton Radio';
    $Self->{Translation}->{'Radio (List)'} = 'Bouton Radio (Liste)';
    $Self->{Translation}->{'Stats Overview'} = 'Aperçu des stats';
    $Self->{Translation}->{'Survey Description'} = 'Description du sondage';
    $Self->{Translation}->{'Survey Introduction'} = 'Présentation du sondage';
    $Self->{Translation}->{'Yes/No'} = 'Oui/Non';
    $Self->{Translation}->{'YesNo'} = 'OuiNon';
    $Self->{Translation}->{'answered'} = 'Répondu';
    $Self->{Translation}->{'not answered'} = 'Non répondu';
    $Self->{Translation}->{'Stats Detail'} = 'Détail Stats';
    $Self->{Translation}->{'Stats Details'} = 'Détails Stats';
    $Self->{Translation}->{'You have already answered the survey.'} = 'Vous avez déjà répondu à cette Enquête';
    $Self->{Translation}->{'Survey#'} = 'Enquête#';
    $Self->{Translation}->{'- No queue selected -'} = '- Aucune file sélectionnée -';
    $Self->{Translation}->{'Master'} = 'Principale';
    $Self->{Translation}->{'New Status'} = 'Nouveau Statut';
    $Self->{Translation}->{'Question Type'} = 'Type de Question';

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Créer nouveau sondage';
    $Self->{Translation}->{'Introduction'} = 'Présentation';
    $Self->{Translation}->{'Internal Description'} = 'Description Interne';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Modifier Info générale';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Modifier Questions';
    $Self->{Translation}->{'Add Question'} = 'Ajouter Questions';
    $Self->{Translation}->{'Type the question'} = 'Entrer la question';
    $Self->{Translation}->{'Answer required'} = 'Réponse requise';
    $Self->{Translation}->{'Survey Questions'} = 'Questions Enquêtes';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Aucune question sauvegardée pour cette Enquête';
    $Self->{Translation}->{'Question'} = 'Question';
    $Self->{Translation}->{'Answer Required'} = 'Réponse requise';
    $Self->{Translation}->{'When you finish to edit the survey questions just close this window.'} =
        'Après avoir terminé le sondage vous pouvez fermer la fenêtre.';
    $Self->{Translation}->{'Do you really want to delete this question? ALL associated data will be LOST!'} =
        'Etes vous sur de vouloir supprimer cette question ? Toutes les données associées seront perdues.';
    $Self->{Translation}->{'Edit Question'} = 'Modifier Question';
    $Self->{Translation}->{'go back to questions'} = 'Retour aux Questions';
    $Self->{Translation}->{'Possible Answers For'} = 'Possible réponses pour';
    $Self->{Translation}->{'Add Answer'} = 'Ajouter Réponses';
    $Self->{Translation}->{'No answers saved for this question.'} = 'Pas de réponse trouvé pour cette question.';
    $Self->{Translation}->{'Do you really want to delete this answer?'} = 'Etes vous sur de vouloir supprimer cette question ?';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'il n\'y a pas de réponses possible, une zone de texte sera affiché.';
    $Self->{Translation}->{'Go back'} = 'Retour';
    $Self->{Translation}->{'Edit Answer'} = 'Modifier Réponse';
    $Self->{Translation}->{'go back to edit question'} = 'Retour à la modification des questions.';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Maximum Sondage affiché par page';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Expéditeur de la notification  ';
    $Self->{Translation}->{'Notification Subject'} = 'Sujet de la notification';
    $Self->{Translation}->{'Notification Body'} = 'Corps de la notification';
    $Self->{Translation}->{'Changed By'} = 'Changé pars';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = 'Statistiques vue d\'ensemble ';
    $Self->{Translation}->{'Requests Table'} = 'Tableau des demandes';
    $Self->{Translation}->{'Send Time'} = 'Temps de l\'envoi';
    $Self->{Translation}->{'Vote Time'} = 'Temps de vote';
    $Self->{Translation}->{'See Details'} = 'Voir les détails';
    $Self->{Translation}->{'Survey Stat Details'} = 'Détail statistique sondage';
    $Self->{Translation}->{'go back to stats overview'} = 'Retour vue d\'ensemble statistique';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Information sondage';
    $Self->{Translation}->{'Sent requests'} = 'Envoyé demande';
    $Self->{Translation}->{'Received surveys'} = 'Sondage reçu';
    $Self->{Translation}->{'Survey Details'} = 'Détails sondage';
    $Self->{Translation}->{'Ticket Services'} = 'Service Ticket';
    $Self->{Translation}->{'Survey Results Graph'} = 'Graphique résultat sondage';
    $Self->{Translation}->{'No stat results.'} = 'Pas de statistique sondage.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Enquête';
    $Self->{Translation}->{'Please answer these questions'} = 'Merci de répondre à ces questions';
    $Self->{Translation}->{'Show my answers'} = 'Voir mes réponses';
    $Self->{Translation}->{'These are your answers'} = 'Voici vos réponses';
    $Self->{Translation}->{'Survey Title'} = 'Titre Enquête';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Un module d\'Enquête';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Un module pour modifier les questions d\'un sondage.';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        'Tous les paramètres pour le sondage dans l\'interface de l\'agent.';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        'Nombre de jours après avoir envoyé un mail de sondage, pendant lequel aucun nouveau sondage ne sera renvoyé au même utilisateur. En choisissant 0 un mail de sondage sera envoyé à chaque fois.';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Corps par défaut de la notification Client par mail à propos d\'une nouvelle enquête.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Expéditeur par défaut pour la notification Client par mail à propos d\'une nouvelle enquête.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Sujet par défaut pour la notification Client par mail à propos d\'une nouvelle enquête.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        '';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        'Défini le nombre maximum d\'enquêtes qui seront envoyées a un Client par période de 30 jours. (0 signifie pas de maximum, toutes les enquêtes seront expédiées).';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ).'} =
        'Défini le nombre d\'heure pour déclencher l\'envoi d\'une enquête après la clôture d\'un ticket (0 signifie un envoi immédiat après clôture).';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        '';
    $Self->{Translation}->{'Edit Survey General Information'} = 'Editer les informations générales de l\'enquête';
    $Self->{Translation}->{'Edit Survey Questions'} = 'Editer les Questions d\'Enquêtes';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        '';
    $Self->{Translation}->{'Enable or disable the send condition check for the service.'} = '';
    $Self->{Translation}->{'Enable or disable the send condition check for the ticket type.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        '';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Si cette expression régulière est vérifiée, aucune enquête Client ne sera envoyée.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        '';
    $Self->{Translation}->{'Public Survey.'} = 'Enquête publique';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Survey Edit Module.'} = 'Module d\'édition d\'enquête.';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = '';
    $Self->{Translation}->{'Survey Stats Module.'} = 'Module statistique d\'enquêtes.';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Module de la vue détaillée d\'enquêtes.';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = '';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = 'Les enquête ne seront pas envoyées aux adresses email configurées.';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'L\'identifiant pour une enquête. par ex. Survey#, MySurvey#. par défaut : Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        '';
    $Self->{Translation}->{'Zoom Into Statistics Details'} = '';

}

1;
