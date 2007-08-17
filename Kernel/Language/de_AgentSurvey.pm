# --
# Kernel/Language/de_AgentSurvey.pm - the de language for AgentSurvey
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: de_AgentSurvey.pm,v 1.9 2007-08-17 10:12:33 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::de_AgentSurvey;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'} = 'Umfrage';
    $Self->{Translation}->{'Can\'t set new Status! No Question definied.'} = 'Neuer Status kann nicht gesetzt werden! Keine Fragen definiert.';
    $Self->{Translation}->{'Can\'t set new Status! Question(s) incomplete.'} = 'Neuer Status kann nicht gesetzt werden! Frage(n) unvollständig.';
    $Self->{Translation}->{'New Status aktiv!'} = 'Neuer Status aktiv!';
    $Self->{Translation}->{'Change Status'} = 'Status ändern';
    $Self->{Translation}->{'Sended Requests'} = 'Gesendete Anfragen';
    $Self->{Translation}->{'Received Votes'} = 'Erhaltene Antworten';
    $Self->{Translation}->{'answered'} = 'beantwortet';
    $Self->{Translation}->{'not answered'} = 'nicht beantwortet';
    $Self->{Translation}->{'Surveys'} = 'Umfragen';
    $Self->{Translation}->{'Invalid'} = 'Ungültig';
    $Self->{Translation}->{'Introduction'} = 'Einleitungstext';
    $Self->{Translation}->{'Internal'} = 'Interne';
    $Self->{Translation}->{'Questions'} = 'Fragen';
    $Self->{Translation}->{'Question'} = 'Frage';
    $Self->{Translation}->{'Posible Answers'} = 'Mögliche Antworten';
    $Self->{Translation}->{'YesNo'} = 'JaNein';
    $Self->{Translation}->{'List'} = 'Liste';
    $Self->{Translation}->{'Textarea'} = 'Freitext';

    return 1;
}

1;