# --
# Kernel/Language/nl_AgentSurvey.pm - the nl language for AgentSurvey
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: nl_AgentSurvey.pm,v 1.1 2009-09-17 17:49:20 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nl_AgentSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'} = 'Enquête';
    $Self->{Translation}->{'Can\'t set new Status! No Question definied.'}
        = 'Kan status niet aanpassen! Definieer eerst vragen voor deze enquête.';
    $Self->{Translation}->{'Can\'t set new Status! Question(s) incomplete.'}
        = 'Kan status niet aanpassen! Er zijn incomplete vragen in deze enquête.';
    $Self->{Translation}->{'New Status aktiv!'} = 'Status aangepast';
    $Self->{Translation}->{'Change Status'}     = 'Status aanpassen';
    $Self->{Translation}->{'Sended Requests'}   = 'Verzonden enquêtes';
    $Self->{Translation}->{'Received Votes'}    = 'Ontvangen stemmen';
    $Self->{Translation}->{'answered'}          = 'beantwoord';
    $Self->{Translation}->{'not answered'}      = 'niet beantwoord';
    $Self->{Translation}->{'Surveys'}           = 'Enquêtes';
    $Self->{Translation}->{'Invalid'}           = 'Ongeldig';
    $Self->{Translation}->{'Introduction'}      = 'Introductie';
    $Self->{Translation}->{'Internal'}          = 'Interne';
    $Self->{Translation}->{'Questions'}         = 'Vragen';
    $Self->{Translation}->{'Question'}          = 'Vraag';
    $Self->{Translation}->{'Posible Answers'}   = 'Mogelijke antwoorden';
    $Self->{Translation}->{'YesNo'}             = 'ja/nee';
    $Self->{Translation}->{'List'}              = 'Overzicht';
    $Self->{Translation}->{'Textarea'}          = 'Vrije tekst';
    $Self->{Translation}->{'A Survey Module'}   = 'Een enquête-module';
    $Self->{Translation}->{'Survey Title is required!'}
        = 'Geef een titel op voor deze enquête.';
    $Self->{Translation}->{'Survey Introduction is required!'}
        = 'Maak een introductietekst voor deze enquête.';
    $Self->{Translation}->{'Survey Description is required!'}
        = 'Geef een omschrijving op voor deze enquête!';
    $Self->{Translation}->{'Survey NotificationSender is required!'}
        = 'Vul een adres in voor de afzender';
    $Self->{Translation}->{'Survey NotificationSubject is required!'}
        = 'Vul een onderwerp in voor de notificatie';
    $Self->{Translation}->{'Survey NotificationBody is required!'}
        = 'Geef een berichttekst op voor de notificatie';

    return 1;
}

1;
