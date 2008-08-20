# --
# Kernel/Language/es_ITSMTicket.pm - the spanish translation of ITSMTicket
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Aquiles Cohen
# --
# $Id: es_ITSMTicket.pm,v 1.4 2008-08-20 11:04:58 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::es_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Fecha de Vencimiento';
    $Lang->{'Decision'}                     = 'Desición';
    $Lang->{'Reason'}                       = 'Motivo';
    $Lang->{'Decision Date'}                = 'Fecha de Desición';
    $Lang->{'Add decision to ticket'}       = 'Añadir desición al ticket';
    $Lang->{'Decision Result'}              = 'Resultado de Desición';
    $Lang->{'Review Required'}              = 'Revisión requerida';
    $Lang->{'closed with workaround'}       = 'Cerrado con solución provisional';
    $Lang->{'Additional ITSM Fields'}       = 'Campos ITSM adicionales';
    $Lang->{'Change ITSM fields of ticket'} = 'Modificar campos ITSM del ticket';
    $Lang->{'Repair Start Time'}            = 'Fecha inicial de reparación';
    $Lang->{'Recovery Start Time'}          = 'Fecha inicial de recuperación';

    return 1;
}

1;
