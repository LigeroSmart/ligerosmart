# --
# Kernel/Language/cs_Survey.pm - the czech language for AgentSurvey
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# Copyright (C) 2010 O2BS.com, s r.o. Jakub Hanus
# --
# $Id: cs_Survey.pm,v 1.1 2011-04-12 05:23:21 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cs_AgentSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;
    $Self->{Translation}->{'Survey'} = 'Prùzkum';
    $Self->{Translation}->{'Questions'} = 'Dotazy';
    $Self->{Translation}->{'Question'} = 'Dotaz';
    $Self->{Translation}->{'Finish'} = 'Ukonèit';
    $Self->{Translation}->{'finished'} = 'ukonèeno';
    $Self->{Translation}->{'This Survey-Key is invalid!'}
    = 'Tento klíè je nevhodný pro prùzkum!';
    $Self->{Translation}->{'Thank you for your feedback.'}
    = 'Dìkujeme Vám za zpìtnou vazbu';
    $Self->{Translation}->{'Need to select question:'} = 'Nutno vybrat dotaz:';
    $Self->{Translation}->{'Survey'} = 'Prùzkum,';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'}
    = 'Nelze nastavit nový stav! Nejsou definovány dotazy.';
    $Self->{Translation}->{'Can\'t set new status! Questions incomplete.'}
    = 'Nelze nastavit nový stav! Dotazy nejsou kompletní.';
    $Self->{Translation}->{'Status changed.'} = 'Nový aktivní stav!';
    $Self->{Translation}->{'Change Status'} = 'Zmìny stavu';
    $Self->{Translation}->{'Sent requests'} = 'Zaslány po¾adavky';
    $Self->{Translation}->{'Received surveys'} = 'Obdr¾eny hlasy';
    $Self->{Translation}->{'answered'} = 'Odpovìdli';
    $Self->{Translation}->{'not answered'} = 'Neodpovìdli';
    $Self->{Translation}->{'Surveys'} = 'Prùzkumy';
    $Self->{Translation}->{'Invalid'} = 'Neplatné';
    $Self->{Translation}->{'Introduction'} = 'Úvod';
    $Self->{Translation}->{'Internal'} = 'Interní';
    $Self->{Translation}->{'Questions'} = 'Dotazy';
    $Self->{Translation}->{'Question'} = 'Dotaz';
    $Self->{Translation}->{'Posible Answers'} = 'Pøípadné odpovìdy';
    $Self->{Translation}->{'YesNo'} = 'Ano anebo Ne';
    $Self->{Translation}->{'List'} = 'seznam';
    $Self->{Translation}->{'Textarea'} = 'textové pole';
    
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

    return 1;
}

1;
