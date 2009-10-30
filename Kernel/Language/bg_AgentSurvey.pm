# --
# Kernel/Language/bg_AgentSurvey.pm - the bulgarian language for AgentSurvey
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: bg_AgentSurvey.pm,v 1.6 2009-10-30 08:28:52 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::bg_AgentSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'} = 'Анкета';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'}
        = 'Не мога да установя нов статус! Няма дефинирани въпроси.';
    $Self->{Translation}->{'Can\'t set new status! Questions incomplete.'}
        = 'Не мога да установя нов статус! Въпросите са непълни.';
    $Self->{Translation}->{'Status changed.'} = 'Нов Активен статус!';
    $Self->{Translation}->{'Change Status'}     = 'Промени статуса';
    $Self->{Translation}->{'Sent requests'}   = 'Изпратени заявки';
    $Self->{Translation}->{'Received surveys'}    = 'Получени гласувания';
    $Self->{Translation}->{'answered'}          = 'отговорили';
    $Self->{Translation}->{'not answered'}      = 'неотговорили';
    $Self->{Translation}->{'Surveys'}           = 'Проучвания';
    $Self->{Translation}->{'Invalid'}           = 'Невалидни';
    $Self->{Translation}->{'Introduction'}      = 'Въведение';
    $Self->{Translation}->{'Internal'}          = 'Вътрешен';
    $Self->{Translation}->{'Questions'}         = 'Въпроси';
    $Self->{Translation}->{'Question'}          = 'Въпрос';
    $Self->{Translation}->{'Posible Answers'}   = 'Възможни отговори';
    $Self->{Translation}->{'YesNo'}             = 'ДА или НЕ';
    $Self->{Translation}->{'List'}              = 'Списък';
    $Self->{Translation}->{'Textarea'}          = 'Зона за текст';

    return 1;
}

1;
