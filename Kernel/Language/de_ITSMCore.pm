# --
# Kernel/Language/de_ITSMCore.pm - the german translation of ITSMCore
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: de_ITSMCore.pm,v 1.6 2007-07-02 13:29:20 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::de_ITSMCore;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Priority Management'} = 'Priorität Verwaltung';
    $Self->{Translation}->{'Add a new Priority.'} = 'Eine neue Priorität hinzufügen.';
    $Self->{Translation}->{'Add Priority'} = 'Priorität hinzufügen';

    $Self->{Translation}->{'Criticality'} = 'Kritikalität';
    $Self->{Translation}->{'Impact'} = 'Auswirkung';
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Kritikalität <-> Auswirkung <-> Priorität';
    $Self->{Translation}->{'allocate'} = 'zuordnen';

    $Self->{Translation}->{'Relevant to'} = 'Relevant für';
    $Self->{Translation}->{'Includes'} = 'Beinhaltet';
    $Self->{Translation}->{'Part of'} = 'Teil von';
    $Self->{Translation}->{'Depends on'} = 'Hängt ab von';
    $Self->{Translation}->{'Required for'} = 'Benötigt für';
    $Self->{Translation}->{'Connected to'} = 'Verbunden mit';
    $Self->{Translation}->{'Alternative to'} = 'Alternativ zu';

    return 1;
}

1;