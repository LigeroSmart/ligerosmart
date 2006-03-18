
package Kernel::Language::de_AgentSurvey;

use strict;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'} = 'Umfrage';
    $Self->{Translation}->{'Can\'t set new Status! No Question definied.'} = 'Neuer Status kann nicht gesetzt werden! Keine Fragen definiert.';
    $Self->{Translation}->{'Can\'t set new Status! Question(s) incomplete.'} = 'Neuer Status kann nicht gesetzt werden! Frage(n) unvollständig.';
    $Self->{Translation}->{'New Status aktiv!'} = 'Neuer Status aktiv!';
    $Self->{Translation}->{'Surveys'} = 'Umfragen';
    $Self->{Translation}->{'Invalid'} = 'Ungültig';
    $Self->{Translation}->{'Introduction'} = 'Einleitungstext';
    $Self->{Translation}->{'Internal'} = 'Interne';
    $Self->{Translation}->{'Questions'} = 'Fragen';
    $Self->{Translation}->{'Question'} = 'Frage';
    $Self->{Translation}->{'Posible Answers'} = 'Mögliche Antworten';
    $Self->{Translation}->{'List'} = 'Liste';
    $Self->{Translation}->{'Textarea'} = 'Freitext';
}
1;
