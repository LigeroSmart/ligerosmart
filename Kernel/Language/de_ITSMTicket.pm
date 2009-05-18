# --
# Kernel/Language/de_ITSMTicket.pm - the german translation of ITSMTicket
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: de_ITSMTicket.pm,v 1.3 2009-05-18 09:55:54 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Fälligkeitsdatum';
    $Lang->{'Decision'}                     = 'Entscheidung';
    $Lang->{'Reason'}                       = 'Begründung';
    $Lang->{'Decision Date'}                = 'Entscheidungsdatum';
    $Lang->{'Add decision to ticket'}       = 'Entscheidung an Ticket hängen';
    $Lang->{'Decision Result'}              = 'Entscheidung';
    $Lang->{'Review Required'}              = 'Nachbearbeitung erforderlich';
    $Lang->{'closed with workaround'}       = 'provisorisch geschlossen';
    $Lang->{'Additional ITSM Fields'}       = 'Zusätzliche ITSM Felder';
    $Lang->{'Change ITSM fields of ticket'} = 'Ändern der ITSM Felder des Tickets';
    $Lang->{'Repair Start Time'}            = 'Reparatur Startzeit';
    $Lang->{'Recovery Start Time'}          = 'Wiederherstellung Startzeit';
    $Lang->{'Change the ITSM fields!'}      = 'Ändern der ITSM-Felder!';
    $Lang->{'Add a decision!'}              = 'Hinzufügen einer Entscheidung!';

    return 1;
}

1;
