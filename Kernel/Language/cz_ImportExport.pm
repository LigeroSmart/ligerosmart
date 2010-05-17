# --
# Kernel/Language/cz_ImportExport.pm - the czech translation of ImportExport
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2010 O2BS.com, s r.o. Jakub Hanus
# --
# $Id: cz_ImportExport.pm,v 1.9 2010-05-17 13:49:17 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cz_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'}              = 'Import/Export';
    $Lang->{'Import/Export Management'}   = 'Import/Export Správa';
    $Lang->{'Add mapping template'}       = 'Nová ¹ablona zobrazení';
    $Lang->{'Start Import'}               = 'Zahájit Import';
    $Lang->{'Start Export'}               = 'Zahájit Export';
    $Lang->{'Step'}                       = 'Krok';
    $Lang->{'Edit common information'}    = 'Editace obecnıch informací';
    $Lang->{'Edit object information'}    = 'Editace informací o objektu';
    $Lang->{'Edit format information'}    = 'Editace formátu';
    $Lang->{'Edit mapping information'}   = 'Editace mapování';
    $Lang->{'Edit search information'}    = 'Editace vyhledávání';
    $Lang->{'Import information'}         = 'Informace o Importu';
    $Lang->{'Column'}                     = 'Sloupec';
    $Lang->{'Restrict export per search'} = 'Omezit Export vyhledáváním';
    $Lang->{'Source File'}                = 'Zdrojovı Soubor';
    $Lang->{'Column Separator'}           = 'Oddìlovaè Sloupcù';
    $Lang->{'Tabulator (TAB)'}            = 'Tabulátor (TAB)';
    $Lang->{'Semicolon (;)'}              = 'Støedník (;)';
    $Lang->{'Colon (:)'}                  = 'Dvojteèka (:)';
    $Lang->{'Dot (.)'}                    = 'Teèka (.)';
    $Lang->{'Charset'}                    = 'Znaková sada';

    return 1;
}

1;
