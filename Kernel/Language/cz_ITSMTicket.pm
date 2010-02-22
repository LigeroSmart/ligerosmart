# --
# Kernel/Language/cz_ITSMTicket.pm - the czech translation of ITSMTicket
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2007-2008 Milen Koutev
# Copyright (C) 2010 O2BS.com, s r.o. Jakub Hanus
# --
# $Id: cz_ITSMTicket.pm,v 1.7 2010-02-22 12:21:15 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cz_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Nejzaz¹í Termín';
    $Lang->{'Decision'}                     = 'Øe¹ení';
    $Lang->{'Reason'}                       = 'Pøíèina';
    $Lang->{'Decision Date'}                = 'Datum Øe¹ení';
    $Lang->{'Add decision to ticket'}       = 'Pøidat øe¹ení k tiketu';
    $Lang->{'Decision Result'}              = 'Výsledek Øe¹ení';
    $Lang->{'Review Required'}              = 'Vy¾aduje Pøehled';
    $Lang->{'closed with workaround'}       = 'uzavøeno doèasným øe¹ením';
    $Lang->{'Additional ITSM Fields'}       = 'Doplòková ITSM pole';
    $Lang->{'Change ITSM fields of ticket'} = 'Zmìna ITSM polí v tiketu';
    $Lang->{'Repair Start Time'}            = 'Èas zahájení opravy';
    $Lang->{'Recovery Start Time'}          = 'Èas zahájení obnovení';
    $Lang->{'Change the ITSM fields!'}      = 'Zmìòte ITMS pole!';
    $Lang->{'Add a decision!'}              = 'Doplòte øe¹ení!';

    return 1;
}

1;
