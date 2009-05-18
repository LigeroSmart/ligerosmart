# --
# Kernel/Language/it_ITSMTicket.pm - the italian translation of ITSMTicket
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: it_ITSMTicket.pm,v 1.1 2009-05-18 09:55:09 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::it_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Data di Scadenza';
    $Lang->{'Decision'}                     = 'Risoluzione';
    $Lang->{'Reason'}                       = 'Motivo';
    $Lang->{'Decision Date'}                = 'Data di Risoluzione';
    $Lang->{'Add decision to ticket'}       = 'Aggiungi una Risoluzione al Ticket';
    $Lang->{'Decision Result'}              = 'Risultato della Risoluzione';
    $Lang->{'Review Required'}              = 'Richiesta Revisione';
    $Lang->{'closed with workaround'}       = 'chiuso con soluzione tampone (workaround)';
    $Lang->{'Additional ITSM Fields'}       = 'Campi ITSM aggiuntivi';
    $Lang->{'Change ITSM fields of ticket'} = 'Modifica campi ITSM del ticket';
    $Lang->{'Repair Start Time'}            = 'Data iniziale di riparazione';
    $Lang->{'Recovery Start Time'}          = 'Data iniziale di recupero';
    $Lang->{'Change the ITSM fields!'}      = 'Cambia i campi ITSM!';
    $Lang->{'Add a decision!'}              = 'Aggiungi una risoluzione!';

    return 1;
}

1;
