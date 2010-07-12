# --
# Kernel/Language/da_AgentSurvey.pm - provides da (Danish) language translation
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: da_AgentSurvey.pm,v 1.1 2010-07-12 12:28:53 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::da_AgentSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'} = 'Undersøgelse';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'}
        = 'Kan ikke sætte ny status! Der er ikke defineret nogen spørgsmål.';
    $Self->{Translation}->{'Can\'t set new status! Questions incomplete.'}
        = 'Kan ikke sætte ny status! Spørgsmål er ikke afsluttet.';
    $Self->{Translation}->{'Status changed.'}  = 'Status ændret!';
    $Self->{Translation}->{'Change Status'}    = 'Ændre status';
    $Self->{Translation}->{'Sent requests'}    = 'Sendt forespørgsel';
    $Self->{Translation}->{'Received surveys'} = 'Modtaget undersøgelser';
    $Self->{Translation}->{'answered'}         = 'besvaret';
    $Self->{Translation}->{'not answered'}     = 'ikke besvaret';
    $Self->{Translation}->{'Surveys'}          = 'Undersøgelser';
    $Self->{Translation}->{'Invalid'}          = 'Ugyldig';
    $Self->{Translation}->{'Introduction'}     = 'Introduktion';
    $Self->{Translation}->{'Internal'}         = 'Intern';
    $Self->{Translation}->{'Questions'}        = 'Spørgsmål';
    $Self->{Translation}->{'Question'}         = 'Spørgsmål';
    $Self->{Translation}->{'Posible Answers'}  = 'Mulige svar';
    $Self->{Translation}->{'YesNo'}            = 'JaNej';
    $Self->{Translation}->{'List'}             = 'Liste';
    $Self->{Translation}->{'Textarea'}         = 'Tekstområde';
    $Self->{Translation}->{'A Survey Module'}  = 'Et undersøgelsesmodul';
    $Self->{Translation}->{'Survey Title is required!'}
        = 'Undersøgelsestitel kræves udfyldt!';
    $Self->{Translation}->{'Survey Introduction is required!'}
        = 'Undersøgelsesintrodution kræves udfyldt!';
    $Self->{Translation}->{'Survey Description is required!'}
        = 'Undersøgelsesbeskrivelse kræves udfyldt!';
    $Self->{Translation}->{'Survey NotificationSender is required!'}
        = 'Undersøgelse kræver at afsenderadresse er udfyldt!';
    $Self->{Translation}->{'Survey NotificationSubject is required!'}
        = 'Undersøgelse kræver at emne er udfyldt!';
    $Self->{Translation}->{'Survey NotificationBody is required!'}
        = 'Undersøgelse kræver at tekstfeltet er udfyldt!';

    return 1;
}

1;
