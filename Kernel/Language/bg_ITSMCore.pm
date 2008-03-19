# --
# Kernel/Language/bg_ITSMCore.pm - the bulgarian translation of ITSMCore
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: bg_ITSMCore.pm,v 1.6 2008-03-19 15:19:40 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::bg_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

sub Data {
    my ($Self) = @_;
    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Priority Management'}                 = 'Управление на приоритетите';
    $Lang->{'Add a new Priority.'}                 = 'Добави нов приоритет.';
    $Lang->{'Add Priority'}                        = 'Добави приоритет';
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

    return 1;
}

1;
