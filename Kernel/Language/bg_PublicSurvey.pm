# --
# Kernel/Language/bg_PublicSurvey.pm - the bulgarian language for PublicSurvey
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: bg_PublicSurvey.pm,v 1.6 2009-04-02 16:22:19 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::bg_PublicSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'}    = 'Анкета';
    $Self->{Translation}->{'Questions'} = 'Въпроси';
    $Self->{Translation}->{'Question'}  = 'Въпрос';
    $Self->{Translation}->{'Finish'}    = 'Завърши';
    $Self->{Translation}->{'finished'}  = 'завършено';
    $Self->{Translation}->{'This Survey-Key is invalid!'}
        = 'Този ключ е невалиден за проучването!';
    $Self->{Translation}->{'Thank you for your feedback.'}
        = 'Благодарим ви за обратната информация';
    $Self->{Translation}->{'Need to select question:'}  = '';

    return 1;
}

1;
