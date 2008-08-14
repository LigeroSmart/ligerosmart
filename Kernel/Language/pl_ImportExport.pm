# --
# Kernel/Language/pl_ImportExport.pm - the polish translation of ImportExport
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Maciej Loszajc
# --
# $Id: pl_ImportExport.pm,v 1.3 2008-08-14 11:13:39 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::pl_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'}              = 'Import/Export';
    $Lang->{'Import/Export Management'}   = 'Zarz1dzanie Importem/Exportem';
    $Lang->{'Add mapping template'}       = '';
    $Lang->{'Start Import'}               = 'Rozpocznij Import';
    $Lang->{'Start Export'}               = 'Rozpocznij Export';
    $Lang->{'Step'}                       = '';
    $Lang->{'Edit common information'}    = '';
    $Lang->{'Edit object information'}    = '';
    $Lang->{'Edit format information'}    = '';
    $Lang->{'Edit mapping information'}   = '';
    $Lang->{'Edit search information'}    = '';
    $Lang->{'Import information'}         = '';
    $Lang->{'Column'}                     = 'Kolumna';
    $Lang->{'Restrict export per search'} = '';
    $Lang->{'Source File'}                = 'Plik Yród3owy';
    $Lang->{'Column Seperator'}           = 'Separator kolumny';
    $Lang->{'Tabulator (TAB)'}            = 'Tabulator (TAB)';
    $Lang->{'Semicolon (;)'}              = 'Orednik (;)';
    $Lang->{'Colon (:)'}                  = 'Dwukropek (:)';
    $Lang->{'Dot (.)'}                    = 'Kropka (.)';
    $Lang->{'Charset'}                    = 'Kodowanie';

    return 1;
}

1;
