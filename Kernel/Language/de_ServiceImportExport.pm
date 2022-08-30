# --
# Kernel/Language/de_ServiceImportExport - provides german language
# translation for ServiceImportExport module
# Copyright (C) 2006-2015 c.a.p.e. IT GmbH, http://www.cape-it.de
# 
# written/edited by:
# * Anna(dot)Litvinova(at)cape(dash)it(dot)de
# * Thomas(dot)Lange(at)cape(dash)it(dot)de
# --
# $Id: de_ServiceImportExport.pm,v 1.8 2015/11/17 09:45:51 tlange Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::de_ServiceImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    
    # $$START$$

    # translations missing in ImportExport...
    $Lang->{'Column Seperator'}           = 'Spaltentrenner';
    $Lang->{'Charset'}                    = 'Zeichensatz';
    $Lang->{'Restrict export per search'} = 'Export mittels Suche einschränken';

    # service2customeruser ex-/import...
    $Lang->{'Service available for CU'} = 'Service für Kundennutzer verfügbar';
    $Lang->{'Customer User Login'}      = 'Kundennutzerlogin';
    $Lang->{'Validity of service assignment for CU'} =
        'Gültigkeit der Servicezuordnung zu Kundennutzer';

    # service ex-/import...
    $Lang->{'Full Service Name'}                  = 'Vollstündiger Servicename';
    $Lang->{'Short Service Name'}                 = 'Kurzservicename';
    $Lang->{'Service Type (ITSM only)'}           = 'Servicetyp (nur ITSM)';
    $Lang->{'Criticality (ITSM only)'}            = 'Kritikalität (nur ITSM)';
    $Lang->{'Current Incident State (ITSM only)'} = 'Akt. Störungsstatus (nur ITSM)';
    $Lang->{'Current Incident State Type (ITSM only)'}
        = 'Akt. Störungsstatustyp (nur ITSM)';
    $Lang->{'Default Service Type'} = 'Standard-Servicetyp';
    $Lang->{'Validity'}             = 'Gültigkeit';
    $Lang->{'Default Validity'}     = 'Standard-Gültigkeit';
    $Lang->{'Default Criticality'}  = 'Standard-Kritikalität';

    # SLA ex-/import...
    $Lang->{'Default SLA Type'}                       = 'Standard-SLA-Typ';
    $Lang->{'Default Minimum Time Between Incidents'} = 'Standard Minimumzeit zwischen Störungen';
    $Lang->{'Max. number of columns which may contain assigned services'}
        = 'Max. Anzahl von Spalten die zugewiesene Services enthalten können';
    $Lang->{'Max. number of assigned services columns'} = 'Max. Spaltenanzahl zugew. Services';

    $Lang->{'SLA Type (ITSM only)'} = 'SLA Typ (nur ITSM)';
    $Lang->{'Min. Time Between Incidents (ITSM only)'}
        = 'Standard Minimumzeit zwischen Störungen (nur ITSM)';
    $Lang->{'SolutionNotify (percent)'}        = 'SolutionNotify (Prozent)';
    $Lang->{'SolutionTime (business minutes)'} = 'SolutionTime (Geschäftsminuten)';
    $Lang->{'UpdateNotify (percent)'}          = 'UpdateNotify (Prozent)';
    $Lang->{'UpdateTime (business minutes)'}   = 'UpdateTime (Geschäftsminuten)';
    $Lang->{'FirstResponseNotify (percent)'}   = 'FirstResponseNotify (Prozent)';
    $Lang->{'FirstResponseTime (business minutes)'}
        = 'FirstResponseTime (Geschäftsminuten)';
    $Lang->{'Calendar Name'} = 'Kalendername';

    $Lang->{'Export with labels'} = 'Mit Beschriftung exportieren';

    # SysConfig descriptions
    $Lang->{'Object backend module registration for the import/export moduls.'} =
        'Objekt-Backend Modul Registration des Import/Export Moduls.';

    #   $Lang->{''} = '';

    return 0;

    # $$STOP$$
}

1;