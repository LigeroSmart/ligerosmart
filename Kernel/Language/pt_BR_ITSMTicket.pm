# --
# Kernel/Language/pt_BR_ITSMTicket.pm - the Brazilian translation of ITSMTicket
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2010 Cristiano Korndörfer, http://www.dorfer.com.br/
# --
# $Id: pt_BR_ITSMTicket.pm,v 1.1 2010-03-01 09:53:14 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_ITSMTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Due Date'}                     = 'Data Vencimento';
    $Lang->{'Decision'}                     = 'Decisão';
    $Lang->{'Reason'}                       = 'Razão';
    $Lang->{'Decision Date'}                = 'Data de Decisão';
    $Lang->{'Add decision to ticket'}       = 'Adicionar Decisão à Solicitação';
    $Lang->{'Decision Result'}              = 'Decisão Resultante';
    $Lang->{'Review Required'}              = 'Revisão Requisitada';
    $Lang->{'closed with workaround'}       = 'fechada com solução de contorno';
    $Lang->{'Additional ITSM Fields'}       = 'Campos adicionais ITSM';
    $Lang->{'Change ITSM fields of ticket'} = 'Mudar os campos ITSM da solicitação';
    $Lang->{'Repair Start Time'}            = 'Hora Inicial do Reparo';
    $Lang->{'Recovery Start Time'}          = 'Hora Inicial da Recuperação';
    $Lang->{'Change the ITSM fields!'}      = 'Mudar os campos ITSM!';
    $Lang->{'Add a decision!'}              = 'Adicionar uma decisão!';

    return 1;
}

1;
