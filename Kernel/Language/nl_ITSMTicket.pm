# --
# Kernel/Language/nl_ITSMTicket.pm - the Dutch translation of ITSMTicket
# Copyright (C) 2009 Michiel Beijen <michiel 'at' beefreeit.nl>
# --
# $Id: nl_ITSMTicket.pm,v 1.1 2009-07-20 14:00:49 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nl_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Vervaldatum';
    $Lang->{'Decision'}                     = 'Beslissing';
    $Lang->{'Reason'}                       = 'Reden';
    $Lang->{'Decision Date'}                = 'Beslissingsdatum';
    $Lang->{'Add decision to ticket'}       = 'Koppel beslissing aan ticket';
    $Lang->{'Decision Result'}              = 'Resultaat beslissing';
    $Lang->{'Review Required'}              = 'Review benodigd';
    $Lang->{'closed with workaround'}       = 'gesloten met workaround';
    $Lang->{'Additional ITSM Fields'}       = 'Extra ITSM velden';
    $Lang->{'Change ITSM fields of ticket'} = 'Veranderen van ITSM velden van ticket';
    $Lang->{'Repair Start Time'}            = 'Begintijd reparatie';
    $Lang->{'Recovery Start Time'}          = 'Begintijd herstel';
    $Lang->{'Change the ITSM fields!'}      = 'Veranderen van ITSM velden!';
    $Lang->{'Add a decision!'}              = 'Beslissing toevoegen!';

    return 1;
}

1;
