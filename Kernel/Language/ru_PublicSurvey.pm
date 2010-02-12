# --
# Kernel/Language/ru_PublicSurvey.pm - the ru language for PublicSurvey
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: ru_PublicSurvey.pm,v 1.1 2010-02-12 10:42:15 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_PublicSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'}    = 'Опрос';
    $Self->{Translation}->{'Questions'} = 'Вопросы';
    $Self->{Translation}->{'Question'}  = 'Вопрос';
    $Self->{Translation}->{'Reset'}     = 'Очистить';
    $Self->{Translation}->{'Finish'}    = 'Отправить';
    $Self->{Translation}->{'finished'}  = 'отправлено';
    $Self->{Translation}->{'Need to select question:'}     = 'Для завершения, нужно ответить на вопрос: ';
    $Self->{Translation}->{'This Survey-Key is invalid!'}  = 'Ошибочный ключ опроса!';
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Спасибо за Ваш отзыв.';

    return 1;
}

1;
