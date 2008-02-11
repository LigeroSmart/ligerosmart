# --
# Kernel/Language/de_ImportExport.pm - the german translation of ImportExport
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: de_ImportExport.pm,v 1.12 2008-02-11 16:34:29 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::de_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.12 $) [1];

sub Data {
    my ($Self) = @_;

    $Self->{Translation}->{'Import/Export'}                 = 'Import/Export';
    $Self->{Translation}->{'Import/Export Management'}      = 'Import/Export Verwaltung';
    $Self->{Translation}->{'Add mapping template'}          = 'Mapping-Template hinzufügen';
    $Self->{Translation}->{'Start Import'}                  = 'Import starten';
    $Self->{Translation}->{'Start Export'}                  = 'Export starten';
    $Self->{Translation}->{'Step'}                          = 'Schritt';
    $Self->{Translation}->{'Edit common information'}       = 'Allgemeine Informationen bearbeiten';
    $Self->{Translation}->{'Edit object information'}       = 'Objekt-Informationen bearbeiten';
    $Self->{Translation}->{'Edit format information'}       = 'Format-Informationen bearbeiten';
    $Self->{Translation}->{'Edit mapping information'}      = 'Mapping-Informationen bearbeiten';
    $Self->{Translation}->{'Edit search information'}       = 'Such-Informationen bearbeiten';
    $Self->{Translation}->{'Import information'}            = 'Import Informationen';
    $Self->{Translation}->{'Column'}                        = 'Spalte';
    $Self->{Translation}->{'Column Seperator'}              = 'Spaltentrenner';
    $Self->{Translation}->{'Maximum number of one element'} = 'Maimale Anzahl eines Elements';
    $Self->{Translation}->{'Only import changed datasets'} = 'Nur geänderte Datensätze importieren';
    $Self->{Translation}->{'Tabulator (TAB)'}              = 'Tabulator (TAB)';
    $Self->{Translation}->{'Semicolon (;)'}                = 'Semicolon (;)';
    $Self->{Translation}->{'Colon (:)'}                    = 'Doppelpunkt (:)';
    $Self->{Translation}->{'Dot (.)'}                      = 'Punkt (.)';
    $Self->{Translation}->{'Identifier'}                   = 'Identifikator';
    $Self->{Translation}->{'Restrict export per search'}   = 'Export per Suche eischränken';
    $Self->{Translation}->{'Source File'}                  = 'Quell-Datei';
    $Self->{Translation}->{''}                             = '';
    $Self->{Translation}->{''}                             = '';
    $Self->{Translation}->{''}                             = '';

    return 1;
}

1;
