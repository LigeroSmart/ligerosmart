# --
# Kernel/Language/cz_Survey.pm - the czech language for AgentSurvey
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# Copyright (C) 2010 O2BS.com, s r.o. Jakub Hanus
# --
# $Id: cz_Survey.pm,v 1.2 2011-02-16 22:15:11 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cz_AgentSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;
    $Self->{Translation}->{'Survey'}    = 'Průzkum';
    $Self->{Translation}->{'Questions'} = 'Dotazy';
    $Self->{Translation}->{'Question'}  = 'Dotaz';
    $Self->{Translation}->{'Finish'}    = 'Ukončit';
    $Self->{Translation}->{'finished'}  = 'ukončeno';
    $Self->{Translation}->{'This Survey-Key is invalid!'}
        = 'Tento klíč je nevhodný pro průzkum!';
    $Self->{Translation}->{'Thank you for your feedback.'}
        = 'Děkujeme Vám za zpětnou vazbu';
    $Self->{Translation}->{'Need to select question:'}  = 'Nutno vybrat dotaz:';
    $Self->{Translation}->{'Survey'} = 'Průzkum,';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'}
        = 'Nelze nastavit nový stav! Nejsou definovány dotazy.';
    $Self->{Translation}->{'Can\'t set new status! Questions incomplete.'}
        = 'Nelze nastavit nový stav! Dotazy nejsou kompletní.';
    $Self->{Translation}->{'Status changed.'} = 'Nový aktivní stav!';
    $Self->{Translation}->{'Change Status'}     = 'Změny stavu';
    $Self->{Translation}->{'Sent requests'}   = 'Zaslány požadavky';
    $Self->{Translation}->{'Received surveys'}    = 'Obdrženy hlasy';
    $Self->{Translation}->{'answered'}          = 'Odpovědli';
    $Self->{Translation}->{'not answered'}      = 'Neodpovědli';
    $Self->{Translation}->{'Surveys'}           = 'Průzkumy';
    $Self->{Translation}->{'Invalid'}           = 'Neplatné';
    $Self->{Translation}->{'Introduction'}      = 'Úvod';
    $Self->{Translation}->{'Internal'}          = 'Interní';
    $Self->{Translation}->{'Questions'}         = 'Dotazy';
    $Self->{Translation}->{'Question'}          = 'Dotaz';
    $Self->{Translation}->{'Posible Answers'}   = 'Případné odpovědy';
    $Self->{Translation}->{'YesNo'}             = 'Ano anebo Ne';
    $Self->{Translation}->{'List'}              = 'seznam';
    $Self->{Translation}->{'Textarea'}          = 'textové pole';

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
