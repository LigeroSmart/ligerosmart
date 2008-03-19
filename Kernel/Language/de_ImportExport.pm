# --
# Kernel/Language/de_ImportExport.pm - the german translation of ImportExport
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: de_ImportExport.pm,v 1.14 2008-03-19 15:10:04 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::de_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

sub Data {
    my ($Self) = @_;
    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'}                 = 'Import/Export';
    $Lang->{'Import/Export Management'}      = 'Import/Export Verwaltung';
    $Lang->{'Add mapping template'}          = 'Mapping-Template hinzufügen';
    $Lang->{'Start Import'}                  = 'Import starten';
    $Lang->{'Start Export'}                  = 'Export starten';
    $Lang->{'Step'}                          = 'Schritt';
    $Lang->{'Edit common information'}       = 'Allgemeine Informationen bearbeiten';
    $Lang->{'Edit object information'}       = 'Objekt-Informationen bearbeiten';
    $Lang->{'Edit format information'}       = 'Format-Informationen bearbeiten';
    $Lang->{'Edit mapping information'}      = 'Mapping-Informationen bearbeiten';
    $Lang->{'Edit search information'}       = 'Such-Informationen bearbeiten';
    $Lang->{'Import information'}            = 'Import Informationen';
    $Lang->{'Column'}                        = 'Spalte';
    $Lang->{'Column Seperator'}              = 'Spaltentrenner';
    $Lang->{'Maximum number of one element'} = 'Maximale Anzahl eines Elements';
    $Lang->{'Only import changed datasets'}  = 'Nur geänderte Datensätze importieren';
    $Lang->{'Tabulator (TAB)'}               = 'Tabulator (TAB)';
    $Lang->{'Semicolon (;)'}                 = 'Semicolon (;)';
    $Lang->{'Colon (:)'}                     = 'Doppelpunkt (:)';
    $Lang->{'Dot (.)'}                       = 'Punkt (.)';
    $Lang->{'Identifier'}                    = 'Identifikator';
    $Lang->{'Restrict export per search'}    = 'Export per Suche eischränken';
    $Lang->{'Source File'}                   = 'Quell-Datei';

    return 1;
}

1;
