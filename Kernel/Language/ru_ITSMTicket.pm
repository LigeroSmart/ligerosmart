# --
# Kernel/Language/ru_ITSMTicket.pm - the russian translation of ITSMTicket
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Egor Tsilenko <bg8s at symlink.ru>
# --
# $Id: ru_ITSMTicket.pm,v 1.3 2009-05-18 09:55:54 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Дата исполнения';
    $Lang->{'Decision'}                     = 'Решение';
    $Lang->{'Reason'}                       = 'Причина';
    $Lang->{'Decision Date'}                = 'Дата решения';
    $Lang->{'Add decision to ticket'}       = 'Вынести решение по заявке';
    $Lang->{'Decision Result'}              = 'Результат решения';
    $Lang->{'Review Required'}              = 'Необходим просмотр';
    $Lang->{'closed with workaround'}       = 'закрыто с обходным решением';
    $Lang->{'Additional ITSM Fields'}       = 'Дополнительные ITSM поля';
    $Lang->{'Change ITSM fields of ticket'} = 'Изменить ITSM поля заявки';
    $Lang->{'Repair Start Time'}            = 'Дата начала работ';
    $Lang->{'Recovery Start Time'}          = 'Дата восстановления сервиса';
    $Lang->{'Change the ITSM fields!'}      = '';
    $Lang->{'Add a decision!'}              = '';

    return 1;
}

1;
