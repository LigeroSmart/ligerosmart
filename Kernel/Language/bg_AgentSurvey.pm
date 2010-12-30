# --
# Kernel/Language/bg_AgentSurvey.pm - the bulgarian language for AgentSurvey
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: bg_AgentSurvey.pm,v 1.8 2010-12-30 20:56:16 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::bg_AgentSurvey;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

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

    $Self->{Translation}->{'A Survey Module.'} = '';
    $Self->{Translation}->{'Public Survey.'} = '';
    $Self->{Translation}->{'Days starting from the latest customer survey email between no customer survey email is sent, ( 0 means: Always send it ) .'} = '';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} = '';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} = '';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} = '';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} = '';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = '';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket gets closed.'} = '';

    $Self->{Translation}->{'Create New Survey'} = '';
    $Self->{Translation}->{'Internal Description'} = '';

    return 1;
}

1;
