# --
# Kernel/Language/cz_AgentSurvey.pm - the czech language for AgentSurvey
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: cz_AgentSurvey.pm,v 1.1 2007-12-10 15:00:03 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::cz_AgentSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my ($Self) = @_;

    $Self->{Translation}->{'Survey'} = 'Průzkum,';
    $Self->{Translation}->{'Can\'t set new Status! No Question definied.'} = 'Nelze nastavit nový stav! Neexistují definovány dotazy.';
    $Self->{Translation}->{'Can\'t set new Status! Question(s) incomplete.'} = 'Nelze nastavit nový stav!Dotazy nejsou kompletní.';
    $Self->{Translation}->{'New Status aktiv!'} = 'Nový aktivní stav!';
    $Self->{Translation}->{'Change Status'} = 'Změny stavu';
    $Self->{Translation}->{'Sended Requests'} = 'Zaslány požadavky';
    $Self->{Translation}->{'Received Votes'} = 'Obdrženy hlasy';
    $Self->{Translation}->{'answered'} = 'Odpovědli';
    $Self->{Translation}->{'not answered'} = 'Neodpovědli';
    $Self->{Translation}->{'Surveys'} = 'Průzkumy';
    $Self->{Translation}->{'Invalid'} = 'Neplatné';
    $Self->{Translation}->{'Introduction'} = 'Úvod';
    $Self->{Translation}->{'Internal'} = 'Interní';
    $Self->{Translation}->{'Questions'} = 'Dotazy';
    $Self->{Translation}->{'Question'} = 'Dotaz';
    $Self->{Translation}->{'Posible Answers'} = 'Případné odpovědy';
    $Self->{Translation}->{'YesNo'} = 'Ano anebo Ne';
    $Self->{Translation}->{'List'} = 'seznam';
    $Self->{Translation}->{'Textarea'} = 'textové pole';

    return 1;
}

1;