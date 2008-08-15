# --
# Kernel/Language/ru_ITSMCore.pm - the russian translation of ITSMCore
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Egor Tsilenko <bg8s at symlink.ru>
# --
# $Id: ru_ITSMCore.pm,v 1.1 2008-08-15 14:47:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::ru_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'Критичность';
    $Lang->{'Impact'}                              = 'Влияние';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Критичность <-> Влияние <-> Приоритет';
    $Lang->{'allocate'}                            = 'Назначение приоритетов ';
    $Lang->{'Relevant to'}                         = 'Относится к';
    $Lang->{'Includes'}                            = 'Включает';
    $Lang->{'Part of'}                             = 'Состоит из';
    $Lang->{'Depends on'}                          = 'Зависит от';
    $Lang->{'Required for'}                        = 'Требуется для';
    $Lang->{'Connected to'}                        = 'Связан с';
    $Lang->{'Alternative to'}                      = 'Замена для';
    $Lang->{'Incident State'}                      = 'Состояние инцидента';
    $Lang->{'Current Incident State'}              = 'Текущее состояние инцидента';
    $Lang->{'Current State'}                       = 'Текущее состояние';
    $Lang->{'Service-Area'}                        = 'Обзор сервисов';
    $Lang->{'Minimum Time Between Incidents'}      = 'Минимальное время между инцидентами';
    $Lang->{'Service Overview'}                    = 'Обзор сервисов';
    $Lang->{'SLA Overview'}                        = 'Обзор SLA';
    $Lang->{'Associated Services'}                 = 'Связанные сервисы';
    $Lang->{'Associated SLAs'}                     = 'Связанные SLA';
    $Lang->{'Back End'}                            = 'Серверная часть';
    $Lang->{'Demonstration'}                       = 'Демонстрация';
    $Lang->{'End User Service'}                    = 'Конечный сервис пользователя';
    $Lang->{'Front End'}                           = 'Интерфейсная часть';
    $Lang->{'IT Management'}                       = 'Управление ИТ';
    $Lang->{'IT Operational'}                      = 'Эксплуатация ИТ';
    $Lang->{'Other'}                               = 'Другое';
    $Lang->{'Project'}                             = 'Планирование';
    $Lang->{'Reporting'}                           = 'Составление отчетов';
    $Lang->{'Training'}                            = 'Обучение';
    $Lang->{'Underpinning Contract'}               = 'Контракт поддержки';
    $Lang->{'Availability'}                        = 'Доступность';
    $Lang->{'Errors'}                              = 'Ошибки';
    $Lang->{'Other'}                               = 'Другое';
    $Lang->{'Recovery Time'}                       = 'Время восстановления';
    $Lang->{'Resolution Rate'}                     = 'Относительная скорость решения';
    $Lang->{'Response Time'}                       = 'Время реакции';
    $Lang->{'Transactions'}                        = 'Финансовые операции';

    return 1;
}

1;
