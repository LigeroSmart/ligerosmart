# --
# Kernel/Language/cz_ITSMTicket.pm - the czech translation of ITSMTicket
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# Copyright (C) 2007-2008 Milen Koutev
# --
# $Id: cz_ITSMTicket.pm,v 1.6 2009-07-20 12:27:08 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cz_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Koneèní datum';
    $Lang->{'Decision'}                     = 'Øe¹ení';
    $Lang->{'Reason'}                       = 'Dùvod';
    $Lang->{'Decision Date'}                = 'Datum rozhodnutí';
    $Lang->{'Add decision to ticket'}       = 'Dodat øe¹ení k tiketu';
    $Lang->{'Decision Result'}              = 'Výsledek rozhodnutí';
    $Lang->{'Review Required'}              = 'Vy¾aduje pøehled';
    $Lang->{'closed with workaround'}       = 'Uzavøen s obchodním rozhodnutím';
    $Lang->{'Additional ITSM Fields'}       = 'Dodateèné ITSM pole';
    $Lang->{'Change ITSM fields of ticket'} = 'Zmìnit ITSM polí tiketu';
    $Lang->{'Repair Start Time'}            = 'Èas zahájení opravy';
    $Lang->{'Recovery Start Time'}          = 'Èas zahájení obnovení';
    $Lang->{'Change the ITSM fields!'}      = '';
    $Lang->{'Add a decision!'}              = '';

    return 1;
}

1;
