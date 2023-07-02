# --
# Kernel/Language/de_DynamicFieldRemoteDB.pm - provides german language translation for DynamicFieldRemoteDB package
# Copyright (C) 2006-2016 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/changed by:
# * Mario(dot)Illinger(at)cape(dash)it(dot)de
# * Stefan(dot)Mehlig(at)cape(dash)it(dot)de
# * Anna(dot)Litvinova(at)cape(dash)it(dot)de
# --
# $Id: de_DynamicFieldRemoteDB.pm,v 1.13 2016/03/01 13:08:09 millinger Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::de_DynamicFieldRemoteDB;
use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;
    my $Lang = $Self->{Translation};
    return 0 if ref $Lang ne 'HASH';

    # possible charsets
    $Self->{Charset} = ['utf-8', ];

    # $$START$$

    # Options
    $Lang->{'MaxArraySize'}  = 'Anzahl Einträge';
    $Lang->{'ItemSeparator'} = 'Anzeigetrenner';

    $Lang->{'DatabaseDSN'}         = 'Datenbank DSN';
    $Lang->{'DatabaseUser'}        = 'Datenbank Benutzer';
    $Lang->{'DatabasePw'}          = 'Datenbank Passwort';
    $Lang->{'DatabaseTable'}       = 'Datenbank Tabelle';
    $Lang->{'DatabaseFieldKey'}    = 'Datenbank Schlüsselspalte';
    $Lang->{'DatabaseFieldValue'}  = 'Datenbank Wertspalte';
    $Lang->{'DatabaseFieldSearch'} = 'Datenbank Suchspalte';

    $Lang->{'SearchPrefix'} = 'Suchprefix';
    $Lang->{'SearchSuffix'} = 'Suchsuffix';

    $Lang->{'CachePossibleValues'} = 'Cache für mögliche Werte';

    $Lang->{'Constrictions'} = 'Einschränkungen';

    $Lang->{'ShowKeyInTitle'}     = 'Zeige Schlüssel in Tooltip';
    $Lang->{'ShowKeyInSearch'}    = 'Zeige Schlüssel in Sucheinträgen';
    $Lang->{'ShowKeyInSelection'} = 'Zeige Schlüssel in Auswahl';
    $Lang->{'ShowMatchInResult'}  = 'Zeige Treffer in Ergebnis';

    $Lang->{'EditorMode'} = 'Editormodus';

    $Lang->{'MinQueryLength'} = 'Mindeste Querylänge';
    $Lang->{'QueryDelay'}     = 'Queryverzögerung';
    $Lang->{'MaxQueryResult'} = 'Maximale Queryergebnisse';

    # Descriptions...
    $Lang->{'Specify the maximum number of entries.'}
        = 'Gibt die maximale Anzahl möglicher Einträge an.';
    $Lang->{'Specify the DSN for used database.'}      = 'Gibt die DSN der Datenbank an.';
    $Lang->{'Specify the user for used database.'}     = 'Gibt den Benutzer der Datenbank an.';
    $Lang->{'Specify the password for used database.'} = 'Gibt das Passwort der Datenbank an.';
    $Lang->{'Specify the table for used database.'}    = 'Gibt die Tabelle der Datenbank an.';
    $Lang->{'Specify the field containing key in used database.'}
        = 'Gibt die Schlüsselspalte in der Datenbank an.';
    $Lang->{'Uses DatabaseFieldKey if not specified.'}
        = 'Nutzt die Schlüsselspalte wenn nichts angegeben ist.';
    $Lang->{'Specify the field containing value in used database.'}
        = 'Gibt die Wertspalte in der Datenbank an.';
    $Lang->{'Specify Constrictions for search-queries. [TableColumn]::[Object]::[Attribute/Value]::[Mandatory]'}
        = 'Gibt Einschränkungen für Suchanfragen an. [Tabellenspalte]::[Objekt]::[Attribut/Wert]::[Pflichtfeld]';
    $Lang->{'Cache any database queries for time in seconds.'}
        = 'Gibt die Zeit in Sekunden an, welche Datenbankanfragen gecached werden.';
    $Lang->{'Cache all possible values.'} = 'Mögliche Werte der Datenbank werden gecached.';
    $Lang->{'0 deactivates caching.'} = '0 deaktiviert den Cache.';
    $Lang->{'If active, the usage of values which recently added to the database may cause an error.'}
        = 'Wenn aktiv, kann die Verwendung von Werten, welche kürzlich zur Datenbank hinzugefügt wurden, Fehler verursachen.';
    $Lang->{'Specify if key is added to HTML-attribute title.'}
        = 'Gibt an, ob der Schlüssel im HTML-Attribut title angefügt wird.';
    $Lang->{'Specify if key is added to entries in search.'}
        = 'Gibt an, ob der Schlüssel an Auswahlwerte in der Suche angefügt wird.';
    $Lang->{'Specify the separator of displayed values for this field.'}
        = 'Gibt den Trenner für die angezeigten Werte an.';
    $Lang->{'for Agent'}                 = 'für Agent';
    $Lang->{'Used in AgentFrontend.'}    = 'Verwendet im Agentenfrontend.';
    $Lang->{'for Customer'}              = 'für Kunde';
    $Lang->{'Used in CustomerFrontend.'} = 'Verwendet im Kundenfrontend.';
    $Lang->{'Following placeholders can be used:'}
        = 'Folgende Platzhalter können verwendet werden:';
    $Lang->{'Same placeholders as for agent link available.'}
        = 'Gleiche Platzhalter wie für Agentenlink verfügbar.';
    $Lang->{'Specify the field for search.'} = 'Gibt die Suchspalte in der Datenbank an.';
    $Lang->{'Multiple columns to search can be configured comma separated.'} = 'Mehrere Suchspalten können kommasepariert angegeben werden.';
    $Lang->{'Specify a prefix for the search.'} = 'Gib ein Prefix für die Suche an.';
    $Lang->{'Specify a suffix for the search.'} = 'Gib ein Suffix für die Suche an.';
    $Lang->{'Specify the MinQueryLength. 0 deactivates the autocomplete.'}
        = 'Gibt die Mindestzahl von Zeichen an, bevor die Autovervollständigung aktiv wird. 0 deaktiviert die Autovervollständigung.';
    $Lang->{'Specify the QueryDelay.'} = 'Gibt die Verzögerung für die Autovervollständigung an';
    $Lang->{'Specify the MaxQueryResult.'}
        = 'Gibt die Maximalzahl an Vorschlägen für die Autovervollständigung an.';
    $Lang->{'Should the search be case sensitive?'} = 'Soll die Suche "Case Sensitive" sein?';
    $Lang->{'Some database systems don\'t support this. (For example MySQL with default settings)'}
        = 'Manche Datenbanksysteme unterstützen dies nicht. (Beispielsweise MySQL mit Standardkonfiguration)';

    $Lang->{'Comma (,)'}      = 'Komma (,)';
    $Lang->{'Semicolon (;)'}  = 'Semikolon (;)';
    $Lang->{'Whitespace ( )'} = 'Leerzeichen ( )';

    return 0;

    # $$STOP$$
}
1;
