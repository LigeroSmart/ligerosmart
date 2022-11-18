# --
# Kernel/Language/de_DynamicFieldITSMConfigItem.pm - provides german language translation for DynamicFieldITSMConfigItem package
# Copyright (C) 2006-2014 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/changed by:
# * Stefan(dot)Mehlig(at)cape(dash)it(dot)de
# * Anna(dot)Litvinova(at)cape(dash)it(dot)de
# --
# $Id: de_DynamicFieldITSMConfigItem.pm,v 1.13 2016/01/14 14:07:19 millinger Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::de_DynamicFieldITSMConfigItem;
use strict;
use warnings;
use utf8;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

sub Data {
    my $Self = shift;
    my $Lang = $Self->{Translation};
    return 0 if ref $Lang ne 'HASH';

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    
    # $$START$$

    # Options

    $Lang->{'Config item classes'} = 'Config Item Klassen';
    $Lang->{'Deployment states'}   = 'Verwendungsstatus';
    $Lang->{'Key type'}            = 'Schlüsseltyp';
    $Lang->{'Display pattern'}     = 'Anzeigevorlage';
    $Lang->{'MinQueryLength'}      = 'Mindeste Querylänge';
    $Lang->{'QueryDelay'}          = 'Queryverzögerung';
    $Lang->{'MaxQueryResult'}      = 'Maximale Queryergebnisse';
    $Lang->{'for Agent'}           = 'für Agent';
    $Lang->{'for Customer'}        = 'für Kunde';
    $Lang->{'MaxArraySize'}        = 'Anzahl Einträge';
    $Lang->{'ItemSeparator'}       = 'Anzeigetrenner';
    $Lang->{'Default values'}      = 'Standardwerte';

    # Descriptions...
    $Lang->{'Select relevant config item classes.'}
        = 'Relevante Config Item Klassen auswählen.';
    $Lang->{'Select relevant deployment states.'}
        = 'Relevante Verwendungsstatus auswählen.';
    $Lang->{'Specify Constrictions for CI-search. [CI-Attribute]::[Object]::[Attribute/Value]::[Mandatory]'}
        = 'Einschränkungen für die CI-Suche angeben. [CI-Attribut]::[Objekt]::[Attribut/Wert]::[Pflichtattribut].';
    $Lang->{'Specify pattern used for display.'}
        = 'Vorlage für die Anzeige angeben.';
    $Lang->{'Following placeholders can be used:'}
        = 'Folgende Platzhalter können verwendet werden:';
    $Lang->{'Same placeholders as for display pattern available.'}
        = 'Gleiche Platzhalter wie für Anzeigevorlage verfügbar.';
    $Lang->{'Addtional available:'}
        = 'Zusätzlich verfügbar:';
    $Lang->{'Specify the MinQueryLength. 0 deactivates the autocomplete.'}
        = 'Gibt die Mindestzahl von Zeichen an, bevor die Autovervollständigung aktiv wird. 0 deaktiviert die Autovervollständigung.';
    $Lang->{'Specify the QueryDelay.'}
        = 'Gibt die Verzögerung für die Autovervollständigung an';
    $Lang->{'Specify the MaxQueryResult.'}
        = 'Gibt die Maximalzahl an Vorschlägen für die Autovervollständigung an.';
    $Lang->{'Specify which display type is used.'}
        = 'Gibt an, welcher Anzeigetyp genutzt wird';
    $Lang->{'Create link between ticket and config item on DynamicFieldUpdate (This event only create link, links can only be deleted manually).'}
        = 'Erzeugt bei einem DynamicFieldUpdate einen Link zwischen Ticket und Config Item (Dieses Event erstellt nur Links - Links müssen manuell entfernt werden).';
    $Lang->{'Specify the separator of displayed values for this field.'}
        = 'Gibt den Trenner für die angezeigten Werte an.';
    $Lang->{'Specify the maximum number of entries.'}
        = 'Gibt die maximale Anzahl möglicher Einträge an.';
    
    # Other
    $Lang->{'ITSMConfigItemReference'}               = 'ITSM-CMDB Auswahl';
    $Lang->{'Config Item ID'}                        = 'Config Item ID';
    $Lang->{'Config Item Name'}                      = 'Config Item Name';
    $Lang->{'Config Item Number'}                    = 'Config Item Nummer';
    $Lang->{'Config Item Name (Config Item Number)'} = 'Config Item Name (Config Item Nummer)';
    $Lang->{'Config Item Number (Config Item Name)'} = 'Config Item Nummer (Config Item Name)';

    $Lang->{'Comma (,)'}                             = 'Komma (,)';
    $Lang->{'Semicolon (;)'}                         = 'Semikolon (;)';
    $Lang->{'Whitespace ( )'}                        = 'Leerzeichen ( )';

    return 0;

    # $$STOP$$
}
1;
