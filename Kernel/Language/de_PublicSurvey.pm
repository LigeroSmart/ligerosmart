# --
# Kernel/Language/de_PublicSurvey.pm - the de language for PublicSurvey
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: de_PublicSurvey.pm,v 1.7 2007-12-10 15:00:48 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::de_PublicSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub Data {
    my ($Self) = @_;

    $Self->{Translation}->{'Survey'}    = 'Umfrage';
    $Self->{Translation}->{'Questions'} = 'Fragen';
    $Self->{Translation}->{'Question'}  = 'Frage';
    $Self->{Translation}->{'Finish'}    = 'Fertigstellen';
    $Self->{Translation}->{'finished'}  = 'fertiggestellt';
    $Self->{Translation}->{'This Survey-Key is invalid!'}
        = 'Dieser Umfrage-Schlüssel ist nicht (mehr) gültig!';
    $Self->{Translation}->{'Thank you for your feedback.'}
        = 'Sie haben diese Umfrage abgeschlossen. Vielen Dank.';

    return 1;
}

1;
