# --
# Kernel/Language/de_PublicSurvey.pm - the de language for PublicSurvey
# Copyright (C) 2003-2006 OTRS GmbH, http://otrs.com/
# --
# $Id: de_PublicSurvey.pm,v 1.4 2006-11-21 23:15:17 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::de_PublicSurvey;

use strict;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'} = 'Umfrage';
    $Self->{Translation}->{'Questions'} = 'Fragen';
    $Self->{Translation}->{'Question'} = 'Frage';
    $Self->{Translation}->{'Finish'} = 'Fertigstellen';
    $Self->{Translation}->{'finished'} = 'fertiggestellt';
    $Self->{Translation}->{'This Survey-Key is invalid!'} = 'Dieser Umfrage-Schlüssel ist nicht (mehr) gültig!';
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Sie haben diese Umfrage abgeschlossen. Vielen Dank.';
}

1;