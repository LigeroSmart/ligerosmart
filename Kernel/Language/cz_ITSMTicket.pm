# --
# Kernel/Language/cz_ITSMTicket.pm - the czech translation of ITSMTicket
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# Copyright (C) 2007-2008 Milen Koutev
# --
# $Id: cz_ITSMTicket.pm,v 1.4 2008-08-25 17:05:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::cz_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Koneční datum';
    $Lang->{'Decision'}                     = 'Řešení';
    $Lang->{'Reason'}                       = 'Důvod';
    $Lang->{'Decision Date'}                = 'Datum rozhodnutí';
    $Lang->{'Add decision to ticket'}       = 'Dodat řešení k tiketu';
    $Lang->{'Decision Result'}              = 'Výsledek rozhodnutí';
    $Lang->{'Review Required'}              = 'Vyžaduje přehled';
    $Lang->{'closed with workaround'}       = 'Uzavřen s obchodním rozhodnutím';
    $Lang->{'Additional ITSM Fields'}       = 'Dodatečné ITSM pole';
    $Lang->{'Change ITSM fields of ticket'} = 'Změnit ITSM polí tiketu';
    $Lang->{'Repair Start Time'}            = 'Čas zahájení opravy';
    $Lang->{'Recovery Start Time'}          = 'Čas zahájení obnovení';
    $Lang->{'Change the ITSM fields!'}      = '';
    $Lang->{'Add a decision!'}              = '';

    return 1;
}

1;
