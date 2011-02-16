# --
# Kernel/Language/nb_NO_Survey.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: nb_NO_Survey.pm,v 1.2 2011-02-16 22:15:11 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nb_NO_Survey;

use strict;

sub Data {
    my $Self = shift;

    # Template: AgentSurvey
    $Self->{Translation}->{'Create New Survey'} = 'Lag ny spørreundersøkelse';
    $Self->{Translation}->{'Introduction'} = 'Introduksjon';
    $Self->{Translation}->{'Internal Description'} = 'Intern beskrivelse';
    $Self->{Translation}->{'Survey Edit'} = 'Rediger spørreundersøkelse';
    $Self->{Translation}->{'General Info'} = 'Generell informasjon';
    $Self->{Translation}->{'Stats Overview'} = 'Statistikkoversikt';
    $Self->{Translation}->{'Requests Table'} = 'Tabellforespørsel';
    $Self->{Translation}->{'Send Time'} = 'Tid sendt';
    $Self->{Translation}->{'Vote Time'} = 'Tid svart';
    $Self->{Translation}->{'Details'} = 'Detaljer';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Ingen spørsmål lagret for denne spørreundersøkelsen.';
    $Self->{Translation}->{'Survey Stat Details'} = 'Detaljstatistikk for spørreundersøkelse';
    $Self->{Translation}->{'go back to stats overview'} = 'gå tilbake til statistikkoversikten';
    $Self->{Translation}->{'Go Back'} = 'Gå tilbake';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Survey Edit Questions'} = 'Rediger spørsmål til spørreundersøkelsen';
    $Self->{Translation}->{'Add Question'} = 'Legg til spørsmål';
    $Self->{Translation}->{'Type the question'} = 'Skriv inn spørsmålet';
    $Self->{Translation}->{'Survey Questions'} = 'Spørsmål til spørreundersøkelsen';
    $Self->{Translation}->{'Question'} = 'Spørsmål';
    $Self->{Translation}->{'Edit Question'} = 'Rediger spørsmål';
    $Self->{Translation}->{'go back to questions'} = 'tilbake til spørsmålene';
    $Self->{Translation}->{'Possible Answers For'} = 'Mulige svaralternativer for';
    $Self->{Translation}->{'Add Answer'} = 'Legg til svaralternativer';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} = 'Dette spørsmålet har ikke mulighet for svaralternativer. Her vil det kun bli vist en tekstboks.';
    $Self->{Translation}->{'Edit Answer'} = 'Rediger svar';
    $Self->{Translation}->{'go back to edit question'} = 'gå tilbake for å redigere spørsmål';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = '';
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Max antall spørreundersøkelser pr side';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Avsender av varsel-e-post';
    $Self->{Translation}->{'Notification Subject'} = 'Tittel i varsel-e-post';
    $Self->{Translation}->{'Notification Body'} = 'Melding i varsel-e-post';
    $Self->{Translation}->{'Created Time'} = 'Tid opprettet';
    $Self->{Translation}->{'Created By'} = 'Opprettet av';
    $Self->{Translation}->{'Changed Time'} = 'Tid endret';
    $Self->{Translation}->{'Changed By'} = 'Endret av';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Informasjon om spørreundersøkelsen';
    $Self->{Translation}->{'Sent requests'} = 'Sendte forespørsler';
    $Self->{Translation}->{'Received surveys'} = 'Mottatte spørreundersøkelser';
    $Self->{Translation}->{'Edit General Info'} = 'Rediger generell informasjon';
    $Self->{Translation}->{'Edit Questions'} = 'Rediger spørsmål';
    $Self->{Translation}->{'Stats Details'} = 'Detaljer om statistikken';
    $Self->{Translation}->{'Survey Details'} = 'Detaljer om spørreundersøkelsen';
    $Self->{Translation}->{'Survey Results Graph'} = 'Grafisk fremstilling av svarene i spørreundersøkelsen';
    $Self->{Translation}->{'No stat results.'} = 'Ingen resultater';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Spørreundersøkelse';
    $Self->{Translation}->{'Please answer the next questions'} = 'Vennligst svar på de neste spørsmålene';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'En modul for spørreundersøkelser';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'En modul for å redigere spørreundersøkelser';
    $Self->{Translation}->{'Days starting from the latest customer survey email between no customer survey email is sent, ( 0 means Always send it ) .'} = '';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} = 'Standard melding i varsel-e-post til kunder om en ny spørreundersøkelse.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} = 'Standard avsender i varsel-e-post til kunder om en ny spørreundersøkelse.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} = 'Standard overskrift i varsel-e-post til kunder om en ny spørreundersøkelse.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} = '';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the column.'} = '';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} = '';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} = '';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Hvis denne regexen stemmer, vil det ikke bli sendt ut en spørreundersøkelse til kunden.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} = '';
    $Self->{Translation}->{'Public Survey.'} = '';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = '';
    $Self->{Translation}->{'Survey Zoom Module.'} = '';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = '';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} = 'Standard identifikator for en undersøklse, f.eks. Spørreundersøkelse#, MinSpørreundersøkelse#. Standard er Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket gets closed.'} = '';

    $Self->{Translation}->{'Survey Introduction'} = '';
    $Self->{Translation}->{'Survey Description'} = '';
    $Self->{Translation}->{'This field is required'} = '';
    $Self->{Translation}->{'Survey Introduction'} = '';
    $Self->{Translation}->{'Survey Description'} = '';
    $Self->{Translation}->{'Complete'} = '';
    $Self->{Translation}->{'Incomplete'} = '';
    $Self->{Translation}->{'Survey#'} = '';
    $Self->{Translation}->{'Default value'} = '';

    $Self->{Translation}->{'Enable or disable the ShowVoteData screen on public interface to show data of an specific votation when customer tries to answer a survey by second time.'} = '';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} = '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
