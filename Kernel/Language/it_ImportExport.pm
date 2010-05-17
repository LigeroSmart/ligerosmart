# --
# Kernel/Language/it_ImportExport.pm - the italian translation of ImportExport
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: it_ImportExport.pm,v 1.2 2010-05-17 13:49:43 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::it_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'}              = 'Importare/Esportare';
    $Lang->{'Import/Export Management'}   = 'Gestione Importazione/Esportazione';
    $Lang->{'Add mapping template'}       = 'Aggiungi mappatura modello';
    $Lang->{'Start Import'}               = 'Iniziare Importazione';
    $Lang->{'Start Export'}               = 'Iniziare Esportazione';
    $Lang->{'Step'}                       = 'Passo';
    $Lang->{'Edit common information'}    = 'Modifica informazioni comuni';
    $Lang->{'Edit object information'}    = 'Modifica informazioni oggetto';
    $Lang->{'Edit format information'}    = 'Modifica formato informazione';
    $Lang->{'Edit mapping information'}   = 'Modifica mappatura informazioni';
    $Lang->{'Edit search information'}    = 'Modifica informazioni di ricerca';
    $Lang->{'Import information'}         = 'Importare informazione';
    $Lang->{'Column'}                     = 'Colonna';
    $Lang->{'Restrict export per search'} = 'Restringere esportazione per ricerca';
    $Lang->{'Source File'}                = 'Archivio origine';
    $Lang->{'Column Separator'}           = 'Separatore di colonna';
    $Lang->{'Tabulator (TAB)'}            = 'Tabulatore (TAB)';
    $Lang->{'Semicolon (;)'}              = 'Punto e virgola (;)';
    $Lang->{'Colon (:)'}                  = 'Due punti (:)';
    $Lang->{'Dot (.)'}                    = 'Punto (.)';
    $Lang->{'Charset'}                    = 'Charset';

    return 1;
}

1;
