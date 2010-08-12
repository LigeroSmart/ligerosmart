# --
# Kernel/Language/ru_ITSMCore.pm - the russian translation of ITSMCore
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Egor Tsilenko <bg8s at symlink.ru>
# --
# $Id: ru_ITSMCore.pm,v 1.5 2010-08-12 21:08:44 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'Критичность';
    $Lang->{'Impact'}                              = 'Влияние';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Критичность <-> Влияние <-> Приоритет';
    $Lang->{'allocation'}                          = 'Назначение приоритетов ';
    $Lang->{'Priority allocation'}                 = '';
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
    $Lang->{'This setting controls the name of the application as is shown in the web interface as well as the tabs and title bar of your web browser.'} = '';
    $Lang->{'Determines the way the linked objects are displayed in each zoom mask.'} = '';
    $Lang->{'List of online repositories (for example you also can use other installations as repositoriy by using Key="http://example.com/otrs/public.pl?Action=PublicRepository&File=" and Content="Some Name").'} = '';

    return 1;
}

1;
