# --
# Kernel/Language/cz_AgentSurvey.pm - the czech language for AgentSurvey
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: cz_AgentSurvey.pm,v 1.5 2009-10-30 08:28:52 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cz_AgentSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'} = 'Průzkum,';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'}
        = 'Nelze nastavit nový stav! Neexistují definovány dotazy.';
    $Self->{Translation}->{'Can\'t set new status! Questions incomplete.'}
        = 'Nelze nastavit nový stav!Dotazy nejsou kompletní.';
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

    return 1;
}

1;
