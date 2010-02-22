# --
# Kernel/Language/nl_PublicSurvey.pm - the Dutch language for PublicSurvey
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: nl_PublicSurvey.pm,v 1.1 2010-02-22 11:55:12 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nl_PublicSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'}    = 'Enquête';
    $Self->{Translation}->{'Questions'} = 'Vragen';
    $Self->{Translation}->{'Question'}  = 'Vraag';
    $Self->{Translation}->{'Finish'}    = 'Voltooien';
    $Self->{Translation}->{'finished'}  = 'voltooid';
    $Self->{Translation}->{'This Survey-Key is invalid!'}
        = 'Deze enquête is ongeldig.';
    $Self->{Translation}->{'Thank you for your feedback.'}
        = 'Bedankt voor uw tijd.';
    $Self->{Translation}->{'Need to select question:'}  = 'Selecteer eerst een vraag:';

    return 1;
}

1;
