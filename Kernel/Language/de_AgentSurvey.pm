# --
# Kernel/Language/de_AgentSurvey.pm - the de language for AgentSurvey
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: de_AgentSurvey.pm,v 1.12 2008-01-23 17:43:25 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::de_AgentSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.12 $) [1];

sub Data {
    my ($Self) = @_;

    $Self->{Translation}->{'Survey'} = 'Umfrage';
    $Self->{Translation}->{'Can\'t set new Status! No Question definied.'}
        = 'Neuer Status kann nicht gesetzt werden! Keine Fragen definiert.';
    $Self->{Translation}->{'Can\'t set new Status! Question(s) incomplete.'}
        = 'Neuer Status kann nicht gesetzt werden! Frage(n) unvollständig.';
    $Self->{Translation}->{'New Status aktiv!'} = 'Neuer Status aktiv!';
    $Self->{Translation}->{'Change Status'}     = 'Status ändern';
    $Self->{Translation}->{'Sended Requests'}   = 'Gesendete Anfragen';
    $Self->{Translation}->{'Received Votes'}    = 'Erhaltene Antworten';
    $Self->{Translation}->{'answered'}          = 'beantwortet';
    $Self->{Translation}->{'not answered'}      = 'nicht beantwortet';
    $Self->{Translation}->{'Surveys'}           = 'Umfragen';
    $Self->{Translation}->{'Invalid'}           = 'Ungültig';
    $Self->{Translation}->{'Introduction'}      = 'Einleitungstext';
    $Self->{Translation}->{'Internal'}          = 'Interne';
    $Self->{Translation}->{'Questions'}         = 'Fragen';
    $Self->{Translation}->{'Question'}          = 'Frage';
    $Self->{Translation}->{'Posible Answers'}   = 'Mögliche Antworten';
    $Self->{Translation}->{'YesNo'}             = 'JaNein';
    $Self->{Translation}->{'List'}              = 'Liste';
    $Self->{Translation}->{'Textarea'}          = 'Freitext';

    return 1;
}

1;
