# --
# Kernel/Language/de_ITSMCore.pm - the german translation of ITSMCore
# Copyright (C) 2003-2007 OTRS GmbH, http://otrs.com/
# --
# $Id: de_ITSMCore.pm,v 1.2 2007-02-24 13:21:50 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::de_ITSMCore;

use strict;

sub Data {
    my $Self = shift;

    # AdminTicketPriority
    $Self->{Translation}->{'Priority Management'} = 'Priorität Verwaltung';
    $Self->{Translation}->{'Add new priority failed! See System Log for details.'} = 'Hinzufügen der neuen Priorität fehlgeschlagen! Im System Log finden Sie weitere Informationen.';
    $Self->{Translation}->{'Update priority faild! See System Log for details.'} = 'Updaten der Priority fehlgeschlagen! Im System Log finden Sie weitere Informationen.';

    # AdminCIPAllocate
    $Self->{Translation}->{'Criticality'} = 'Kritikalität';
    $Self->{Translation}->{'Impact'} = 'Auswirkung';
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Kritikalität <-> Auswirkung <-> Priorität';
    $Self->{Translation}->{'Priority Allocation'} = 'Prioritätszuweisung';
    $Self->{Translation}->{'allocate'} = 'zuordnen';

    $Self->{Translation}->{''} = '';
}

1;