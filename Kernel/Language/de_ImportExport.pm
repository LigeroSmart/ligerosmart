# --
# Kernel/Language/de_ImportExport.pm - the german translation of ImportExport
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: de_ImportExport.pm,v 1.21 2010-09-07 21:29:15 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.21 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'}              = 'Import/Export';
    $Lang->{'Import/Export Management'}   = 'Import/Export Verwaltung';
    $Lang->{'Add mapping template'}       = 'Mapping-Template hinzuf�gen';
    $Lang->{'Start Import'}               = 'Import starten';
    $Lang->{'Start Export'}               = 'Export starten';
    $Lang->{'Step'}                       = 'Schritt';
    $Lang->{'Edit common information'}    = 'Allgemeine Informationen bearbeiten';
    $Lang->{'Edit object information'}    = 'Objekt-Informationen bearbeiten';
    $Lang->{'Edit format information'}    = 'Format-Informationen bearbeiten';
    $Lang->{'Edit mapping information'}   = 'Mapping-Informationen bearbeiten';
    $Lang->{'Edit search information'}    = 'Such-Informationen bearbeiten';
    $Lang->{'Import information'}         = 'Import Informationen';
    $Lang->{'Column'}                     = 'Spalte';
    $Lang->{'Restrict export per search'} = 'Export per Suche einschr�nken';
    $Lang->{'Source File'}                = 'Quell-Datei';
    $Lang->{'Column Separator'}           = 'Spaltentrenner';
    $Lang->{'Tabulator (TAB)'}            = 'Tabulator (TAB)';
    $Lang->{'Semicolon (;)'}              = 'Semicolon (;)';
    $Lang->{'Colon (:)'}                  = 'Doppelpunkt (:)';
    $Lang->{'Dot (.)'}                    = 'Punkt (.)';
    $Lang->{'Charset'}                    = 'Zeichensatz';
    $Lang->{'Frontend module registration for the AdminImportExport in the admin area.'} = 'Frontendmodul-Registration der AdminImportExport im Admin-Bereich.';
    $Lang->{'Format backend module registration for the import/export module.'} = 'Format-Backend Modul Registration des Import/Export Moduls.';
    return 1;
}

1;
