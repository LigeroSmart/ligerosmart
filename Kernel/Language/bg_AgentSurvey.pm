# --
# Kernel/Language/bg_AgentSurvey.pm - the bulgarian language for AgentSurvey
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: bg_AgentSurvey.pm,v 1.2 2007-12-10 15:00:48 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::bg_AgentSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my ($Self) = @_;

    $Self->{Translation}->{'Survey'} = 'Анкета';
    $Self->{Translation}->{'Can\'t set new Status! No Question definied.'}
        = 'Не мога да установя нов статус! Няма дефинирани въпроси.';
    $Self->{Translation}->{'Can\'t set new Status! Question(s) incomplete.'}
        = 'Не мога да установя нов статус! Въпросите са непълни.';
    $Self->{Translation}->{'New Status aktiv!'} = 'Нов Активен статус!';
    $Self->{Translation}->{'Change Status'}     = 'Промени статуса';
    $Self->{Translation}->{'Sended Requests'}   = 'Изпратени заявки';
    $Self->{Translation}->{'Received Votes'}    = 'Получени гласувания';
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
