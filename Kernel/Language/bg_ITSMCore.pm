# --
# Kernel/Language/bg_ITSMCore.pm - the bulgarian translation of ITSMCore
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: bg_ITSMCore.pm,v 1.10 2008-08-11 07:48:37 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::bg_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'Критичност';
    $Lang->{'Impact'}                              = 'Влияние';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Критичност<->Влияние<->Приотитет';
    $Lang->{'allocate'}                            = 'определен';
    $Lang->{'Relevant to'}                         = 'Съответен с';
    $Lang->{'Includes'}                            = 'Включени';
    $Lang->{'Part of'}                             = 'Част от';
    $Lang->{'Depends on'}                          = 'Зависи от';
    $Lang->{'Required for'}                        = 'Необходим за';
    $Lang->{'Connected to'}                        = 'Свързан с';
    $Lang->{'Alternative to'}                      = 'Алтернативен на';
    $Lang->{'Incident State'}                      = '';
    $Lang->{'Current Incident State'}              = '';
    $Lang->{'Current State'}                       = '';
    $Lang->{'Service-Area'}                        = '';
    $Lang->{'Minimum Time Between Incidents'}      = 'Минимално време между инцидентите';
    $Lang->{'Service Overview'}                    = '';
    $Lang->{'SLA Overview'}                        = '';
    $Lang->{'Associated Services'}                 = '';
    $Lang->{'Associated SLAs'}                     = 'Свързани SLA договори';
    $Lang->{'Back End'}                            = 'Основна система/BackEnd';
    $Lang->{'Demonstration'}                       = 'Демонстрация';
    $Lang->{'End User Service'}                    = 'Услуги за крайни потребители';
    $Lang->{'Front End'}                           = 'Клиентска система/FrontEnd';
    $Lang->{'IT Management'}                       = 'Управление на ИТ';
    $Lang->{'IT Operational'}                      = 'ИТ Операции';
    $Lang->{'Other'}                               = 'Други';
    $Lang->{'Project'}                             = 'Проект';
    $Lang->{'Reporting'}                           = 'Отчетност';
    $Lang->{'Training'}                            = 'Обучение';
    $Lang->{'Underpinning Contract'}               = 'Основен договор';
    $Lang->{'Availability'}                        = 'Достъпност';
    $Lang->{'Errors'}                              = 'Грешки';
    $Lang->{'Other'}                               = 'Други';
    $Lang->{'Recovery Time'}                       = 'Време за възстановяване';
    $Lang->{'Resolution Rate'}                     = 'Време за разрешаване';
    $Lang->{'Response Time'}                       = 'Време за отговор';
    $Lang->{'Transactions'}                        = 'Сделки/транзакции';

    return 1;
}

1;
