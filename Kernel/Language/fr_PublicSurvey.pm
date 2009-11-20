# --
# Kernel/Language/fr_PublicSurvey.pm - the fr language for PublicSurvey
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: fr_PublicSurvey.pm,v 1.1 2009-11-20 13:40:52 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr_PublicSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'}    = 'Questionnaire';
    $Self->{Translation}->{'Questions'} = 'Questions';
    $Self->{Translation}->{'Question'}  = 'Question';
    $Self->{Translation}->{'Finish'}    = 'Terminer';
    $Self->{Translation}->{'Need to select question:'}  = 'La question suivante doit être remplie:';
    $Self->{Translation}->{'finished'}  = 'terminé';
    $Self->{Translation}->{'This Survey-Key is invalid!'} = 'La clé du questionnaire est invalide!';
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Vous avez terminé cette enquête. Merci beaucoup.';

    return 1;
}

1;
