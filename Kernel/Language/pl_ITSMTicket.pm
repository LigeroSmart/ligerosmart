# --
# Kernel/Language/pl_ITSMTicket.pm - the polish translation of ITSMTicket
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: pl_ITSMTicket.pm,v 1.2 2008-08-13 14:26:27 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::pl_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Czas przybycia';
    $Lang->{'Decision'}                     = 'Decyzja';
    $Lang->{'Reason'}                       = 'Powód';
    $Lang->{'Decision Date'}                = 'Data decyzji';
    $Lang->{'Add decision to ticket'}       = 'Dodaj decyzje do biletu';
    $Lang->{'Decision Result'}              = 'Rezultat decyzji';
    $Lang->{'Review Required'}              = '';
    $Lang->{'closed with workaround'}       = 'Rozwi±zane z obej¶ciem';
    $Lang->{'Additional ITSM Fields'}       = 'Dodatkowe pola ITSM';
    $Lang->{'Change ITSM fields of ticket'} = 'Zmieñ pola ITSM dla biletu';
    $Lang->{'Repair Start Time'}            = 'Czas rozpoczêcia naprawy';
    $Lang->{'Recovery Start Time'}          = 'Czas rozpoczêcia odzyskiwania';

    return 1;
}

1;
