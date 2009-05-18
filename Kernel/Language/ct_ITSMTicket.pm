# --
# Kernel/Language/ct_ITSMTicket.pm - the catalan translation of ITSMTicket
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Sistemes OTIC (ibsalut) - Antonio Linde
# --
# $Id: ct_ITSMTicket.pm,v 1.4 2009-05-18 09:55:54 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ct_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Data de venciment';
    $Lang->{'Decision'}                     = 'Decisió';
    $Lang->{'Reason'}                       = 'Raó';
    $Lang->{'Decision Date'}                = 'Data de decisió';
    $Lang->{'Add decision to ticket'}       = 'Afegir decisió al tiquet';
    $Lang->{'Decision Result'}              = 'Resultat de la decisió';
    $Lang->{'Review Required'}              = 'Revisió requerida';
    $Lang->{'closed with workaround'}       = 'Tancat amb solució temporal';
    $Lang->{'Additional ITSM Fields'}       = 'Camps ITSM addicionals';
    $Lang->{'Change ITSM fields of ticket'} = 'Caviar Camps ITSM addicionals del tiquet';
    $Lang->{'Repair Start Time'}            = 'Temps d\'inici de la reparació';
    $Lang->{'Recovery Start Time'}          = 'Temps d\'inici de la recuperació';
    $Lang->{'Change the ITSM fields!'}      = '';
    $Lang->{'Add a decision!'}              = '';

    return 1;
}

1;
