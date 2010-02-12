# --
# Kernel/Language/ru_AgentSurvey.pm - the ru language for AgentSurvey
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: ru_AgentSurvey.pm,v 1.1 2010-02-12 10:42:15 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_AgentSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Introduction'} = 'Вступление';
    $Self->{Translation}->{'Internal'} = 'Внутреннее';
    $Self->{Translation}->{'Change Status'} = 'Изменить статус';
    $Self->{Translation}->{'Sent requests'} = 'Отправлено запросов';
    $Self->{Translation}->{'Received surveys'} = 'Получено ответов';
    $Self->{Translation}->{'Send Time'} = 'Время отправки';
    $Self->{Translation}->{'Vote Time'} = 'Время ответа';
    $Self->{Translation}->{'Details'} = 'Подробно';
    $Self->{Translation}->{'New'} = 'Новый';
    $Self->{Translation}->{'Master'} = 'Основной';
    $Self->{Translation}->{'Valid'} = 'Действительный';
    $Self->{Translation}->{'Invalid'} = 'Не действительный';
    $Self->{Translation}->{'answered'} = 'ответили';
    $Self->{Translation}->{'not answered'} = 'не ответили';

    return 1;
}

1;
