# --
# Kernel/Language/cz_PublicSurvey.pm - the czech language for PublicSurvey
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: cz_PublicSurvey.pm,v 1.3 2008-05-16 13:29:36 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::cz_PublicSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'}    = 'Průzkum';
    $Self->{Translation}->{'Questions'} = 'Dotazy';
    $Self->{Translation}->{'Question'}  = 'Dotaz';
    $Self->{Translation}->{'Finish'}    = 'Ukončit';
    $Self->{Translation}->{'finished'}  = 'ukončeno';
    $Self->{Translation}->{'This Survey-Key is invalid!'}
        = 'Tento klíč je nevhodný pro průzkum!';
    $Self->{Translation}->{'Thank you for your feedback.'}
        = 'Děkujeme Vám za zpětnou vazbu';

    return 1;
}

1;
