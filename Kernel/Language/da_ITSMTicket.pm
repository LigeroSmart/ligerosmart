# --
# Kernel/Language/da_ITSMTicket.pm - provides da (Danish) language translation
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: da_ITSMTicket.pm,v 1.1 2010-06-25 09:02:37 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::da_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Forfaldsdato';
    $Lang->{'Decision'}                     = 'Beslutning';
    $Lang->{'Reason'}                       = 'Begrundelse';
    $Lang->{'Decision Date'}                = 'Beslutningsdato';
    $Lang->{'Add decision to ticket'}       = 'Tilføj beslutning til sag';
    $Lang->{'Decision Result'}              = 'Beslutningsresultat';
    $Lang->{'Review Required'}              = 'Anmeldelse kræves';
    $Lang->{'closed with workaround'}       = 'Lukket med workaround';
    $Lang->{'Additional ITSM Fields'}       = 'Yderlige ITSM felter';
    $Lang->{'Change ITSM fields of ticket'} = 'Ret sagens ITSM felter';
    $Lang->{'Repair Start Time'}            = 'Starttid for reperation';
    $Lang->{'Recovery Start Time'}          = 'Starttid for genetablering';
    $Lang->{'Change the ITSM fields!'}      = 'Ret ITSM felter!';
    $Lang->{'Add a decision!'}              = 'Tilføj en beslutning!';

    return 1;
}

1;
