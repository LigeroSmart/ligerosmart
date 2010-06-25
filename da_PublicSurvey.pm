# --
# Kernel/Language/da_PublicSurvey.pm - provides da (Danish) language translation
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: da_PublicSurvey.pm,v 1.1 2010-06-25 08:48:01 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::da_PublicSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'}                   = 'Undersøgelse';
    $Self->{Translation}->{'Questions'}                = 'Spørgsmål';
    $Self->{Translation}->{'Question'}                 = 'Spørgsmål';
    $Self->{Translation}->{'Finish'}                   = 'Færdig';
    $Self->{Translation}->{'Need to select question:'} = 'Følgende spørgsmål skal udfyldes:';
    $Self->{Translation}->{'finished'}                 = 'afsluttet';
    $Self->{Translation}->{'This Survey-Key is invalid!'}
        = 'Denne undersøgelsesnøgle er ugyldig!';
    $Self->{Translation}->{'Thank you for your feedback.'}
        = 'Tak for din besvarelse.';

    return 1;
}

1;
