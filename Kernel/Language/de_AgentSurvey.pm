# --
# Kernel/Language/de_AgentSurvey.pm - the de language for AgentSurvey
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: de_AgentSurvey.pm,v 1.18 2009-10-30 08:28:52 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_AgentSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.18 $) [1];

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'} = 'Umfrage';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'}
        = 'Neuer Status kann nicht gesetzt werden! Keine Fragen definiert.';
    $Self->{Translation}->{'Can\'t set new status! Questions incomplete.'}
        = 'Neuer Status kann nicht gesetzt werden! Frage(n) unvollständig.';
    $Self->{Translation}->{'Status changed.'} = 'Neuer Status aktiv!';
    $Self->{Translation}->{'Change Status'}     = 'Status ändern';
    $Self->{Translation}->{'Sent requests'}   = 'Gesendete Anfragen';
    $Self->{Translation}->{'Received surveys'}    = 'Erhaltene Antworten';
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
    $Self->{Translation}->{'A Survey Module'}   = 'Ein Umfrage-Modul';
    $Self->{Translation}->{'Survey Title is required!'}
        = 'Bitte geben Sie einen Titel für die Umfrage ein!';
    $Self->{Translation}->{'Survey Introduction is required!'}
        = 'Bitte geben Sie einen Einleitungstext ein!';
    $Self->{Translation}->{'Survey Description is required!'}
        = 'Bitte geben Sie eine Interne Beschreibung ein!';
    $Self->{Translation}->{'Survey NotificationSender is required!'}
        = 'Bitte geben Sie eine Absender-Adresse ein!';
    $Self->{Translation}->{'Survey NotificationSubject is required!'}
        = 'Bitte geben Sie einen Betreff ein!';
    $Self->{Translation}->{'Survey NotificationBody is required!'}
        = 'Bitte geben Sie einen Text ein!';

    return 1;
}

1;
