# --
# Kernel/Language/nl_ImportExport.pm - the Dutch translation of ImportExport
# Copyright (C) 2009 Michiel Beijen <michiel 'at' beefreeit.nl>
# --
# $Id: nl_ImportExport.pm,v 1.7 2010-09-24 08:58:15 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nl_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'}              = 'Import/Export';
    $Lang->{'Import/Export Management'}   = 'Import/Export beheer';
    $Lang->{'Add mapping template'}       = 'Mappingtemplate toevoegen';
    $Lang->{'Start Import'}               = 'Import starten';
    $Lang->{'Start Export'}               = 'Export starten';
    $Lang->{'Step'}                       = 'Stap';
    $Lang->{'Edit common information'}    = 'Algemene informatie bewerken';
    $Lang->{'Edit object information'}    = 'Object-informatie bewerken';
    $Lang->{'Edit format information'}    = 'Format-informationen bewerken';
    $Lang->{'Edit mapping information'}   = 'Mapping-informatie bewerken';
    $Lang->{'Edit search information'}    = 'Zoek-informatie bewerken';
    $Lang->{'Import information'}         = 'Import-informatie';
    $Lang->{'Column'}                     = 'Kolom';
    $Lang->{'Restrict export per search'} = 'Beperk export tot zoekopdracht';
    $Lang->{'Source File'}                = 'Bronbestand';
    $Lang->{'Column Separator'}           = 'Kolomscheidingsteken';
    $Lang->{'Tabulator (TAB)'}            = 'Tab';
    $Lang->{'Semicolon (;)'}              = 'Puntkomma (;)';
    $Lang->{'Colon (:)'}                  = 'Dubbele punt (:)';
    $Lang->{'Dot (.)'}                    = 'Punt (.)';
    $Lang->{'Charset'}                    = 'Karakterset';
    $Lang->{'Frontend module registration for the agent interface.'} = '';
    $Lang->{'Format backend module registration for the import/export module.'} = '';
    $Lang->{'Import and export object information.'} = 'Import en export objectinformatie';
    $Lang->{'Object is required!'} = 'Object is verplicht.';
    $Lang->{'Format is required!'} = 'Formaat is verplicht.';
    $Lang->{'Class is required!'} = 'Klasse is verplicht.';
    $Lang->{'Column Separator is required!'} = 'Scheidingsteken is verplicht';
    $Lang->{'No map elements found.'} = 'Geen elementen gevonden.';
    $Lang->{'Empty fields indicate that the current values are kept'} = 'Bij lege velden wordt de huidige waarde behouden';
    $Lang->{'Create a template in order to can import and export object information.'} = 'Maak een template aan om objecten te importeren of exporteren.';

    return 1;
}

1;
