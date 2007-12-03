# --
# Kernel/Language/bg_ITSMCore.pm - the bulgarian translation of ITSMCore
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: bg_ITSMCore.pm,v 1.3 2007-12-03 16:46:37 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::bg_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my ($Self) = @_;

    $Self->{Translation}->{'Priority Management'}
        = 'Управление на приоритетите';
    $Self->{Translation}->{'Add a new Priority.'} = 'Добави нов приоритет.';
    $Self->{Translation}->{'Add Priority'}        = 'Добави приоритет';
    $Self->{Translation}->{'Criticality'}         = 'Критичност';
    $Self->{Translation}->{'Impact'}              = 'Влияние';
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'}
        = 'Критичност<->Влияние<->Приотитет';
    $Self->{Translation}->{'allocate'}       = 'определен';
    $Self->{Translation}->{'Relevant to'}    = 'Съответен с';
    $Self->{Translation}->{'Includes'}       = 'Включени';
    $Self->{Translation}->{'Part of'}        = 'Част от';
    $Self->{Translation}->{'Depends on'}     = 'Зависи от';
    $Self->{Translation}->{'Required for'}   = 'Необходим за';
    $Self->{Translation}->{'Connected to'}   = 'Свързан с';
    $Self->{Translation}->{'Alternative to'} = 'Алтернативен на';

    return 1;
}

1;
