# --
# Kernel/Language/bg_ITSMService.pm - the bulgarian translation of ITSMService
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: bg_ITSMService.pm,v 1.1 2008-06-21 12:45:18 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::bg_ITSMService;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Current State'}                  = '';
    $Lang->{'Service-Area'}                   = '';
    $Lang->{'Minimum Time Between Incidents'} = 'Минимално време между инцидентите';
    $Lang->{'Associated SLAs'}                = 'Свързани SLA договори';
    $Lang->{'Back End'}                       = 'Основна система/BackEnd';
    $Lang->{'Demonstration'}                  = 'Демонстрация';
    $Lang->{'End User Service'}               = 'Услуги за крайни потребители';
    $Lang->{'Front End'}                      = 'Клиентска система/FrontEnd';
    $Lang->{'IT Management'}                  = 'Управление на ИТ';
    $Lang->{'IT Operational'}                 = 'ИТ Операции';
    $Lang->{'Other'}                          = 'Други';
    $Lang->{'Project'}                        = 'Проект';
    $Lang->{'Reporting'}                      = 'Отчетност';
    $Lang->{'Training'}                       = 'Обучение';
    $Lang->{'Underpinning Contract'}          = 'Основен договор';
    $Lang->{'Availability'}                   = 'Достъпност';
    $Lang->{'Errors'}                         = 'Грешки';
    $Lang->{'Other'}                          = 'Други';
    $Lang->{'Recovery Time'}                  = 'Време за възстановяване';
    $Lang->{'Resolution Rate'}                = 'Време за разрешаване';
    $Lang->{'Response Time'}                  = 'Време за отговор';
    $Lang->{'Transactions'}                   = 'Сделки/транзакции';

    return 1;
}

1;
