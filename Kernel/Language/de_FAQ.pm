# --
# Kernel/Language/de_FAQ.pm - the german translation of FAQ
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: de_FAQ.pm,v 1.24 2010-12-01 10:14:17 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

package Kernel::Language::de_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.24 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'You have already voted!'} = 'Sie haben bereits bewertet!';
    $Lang->{'No rate selected!'}       = 'Keine Bewertung auswählt!';
    $Lang->{'Thanks for your vote!'}   = 'Danke für Ihre Bewertung!';
    $Lang->{'Votes'}                   = 'Bewertungen';
    $Lang->{'LatestChangedItems'}      = 'Zuletzt geänderte FAQ Artikel';
    $Lang->{'LatestCreatedItems'}      = 'Zuletzt erstellte FAQ Artikel';
    $Lang->{'Top10Items'}              = 'Top 10 FAQ Artikel';
    $Lang->{'ArticleVotingQuestion'}   = '';
    $Lang->{'SubCategoryOf'}           = 'Unterkategorie von';
    $Lang->{'QuickSearch'}             = 'Schnellsuche';
    $Lang->{'DetailSearch'}            = 'Detailsuche';
    $Lang->{'Categories'}              = 'Kategorien';
    $Lang->{'SubCategories'}           = 'Subkategorien';
    $Lang->{'New FAQ Article'}         = 'Neuer FAQ Artikel';
    $Lang->{'FAQ Category'}            = 'FAQ Kategorie';
    $Lang->{'A category should have a name!'}        = 'Eine Kategorien sollte einen Namen haben!';
    $Lang->{'A category should have a comment!'}     = 'Eine Kategorien sollte einen Kommentar haben!';
    $Lang->{'FAQ Articles (new created)'}            = 'FAQ Artikel (neu erstellte)';
    $Lang->{'FAQ Articles (recently changed)'}       = 'FAQ Artikel (zuletzt geänderte)';
    $Lang->{'FAQ Articles (Top 10)'}                 = 'FAQ Artikel (Top 10)';
    $Lang->{'StartDay'}                              = 'Start Tag';
    $Lang->{'StartMonth'}                            = 'Start Monat';
    $Lang->{'StartYear'}                             = 'Start Jahr';
    $Lang->{'EndDay'}                                = 'End Tag';
    $Lang->{'EndMonth'}                              = 'End Monat';
    $Lang->{'EndYear'}                               = 'End Jahr';
    $Lang->{'Approval'}                              = 'Freigabe';
    $Lang->{'internal'}                              = 'intern';
    $Lang->{'external'}                              = 'extern';
    $Lang->{'public'}                                = 'öffentlich';

    $Lang->{
        'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'
        }
        = 'Keine Kategorie-Auswahl möglich. Um einen Artikel erstellen zu können, muss man min. Zugriff auf eine Kategorie haben. Bitte überprüfen Sie die Gruppen/Kategorie Berechtigung im Menupunkt -Kategorie-!';
    $Lang->{'Agent groups which can access this category.'}
        = 'Agenten Gruppe welche auf diese Kategorie Zugriff hat.';
    $Lang->{'A category needs at least one permission group!'}
        = 'Eine Kategorie muss mindestens eine Berechtigungs-Gruppe haben.';
    $Lang->{'Will be shown as comment in Explorer.'} = 'Wird im Explorer als Kommentar angezeigt.';

    $Lang->{'Default category name.'}                            = 'Root Kategorie Name.';
    $Lang->{'Rates for voting. Key must be in percent.'}         = 'Gewichtung für die Bewertung. Der Key muss in Prozent angegeben werden.';
    $Lang->{'Show voting in defined interfaces.'}                = 'Interfaces in denen das Voting Feature angezeigt werden soll.';
    $Lang->{'Languagekey which is defined in the language file *_FAQ.pm.'}
        = 'LanguageKey für die Frage bei der Artikelbewertung. Wird in den Sprachfiles definiert.';
    $Lang->{'Show FAQ path yes/no.'}                             = 'FAQ Pfad anzeigen ja/nein.';
    $Lang->{'Decimal places of the voting result.'}              = 'Dezimalstellen des Ergebnisses bei der Artikelbewertung.';
    $Lang->{'CSS color for the voting flag.'}                    = '';
    $Lang->{'FAQ path separator.'}                               = 'Trennzeichen im FAQ Pfad.';
    $Lang->{'Interfaces where the quicksearch should be shown.'} = 'Interfaces in denen das QuickSearch Feature angezeigt wird.';
    $Lang->{'Show items of subcategories.'}                      = 'Artikel aus Subkategorien anzeigen ja/nein.';
    $Lang->{'Show last change items in defined interfaces.'}     = 'Interfaces in denen das LastChange Feature angezeigt werden soll.';
    $Lang->{'Number of shown items in last changes.'}            = 'Anzahl der zu anzeigenden Artikel in letzten Änderungen.';
    $Lang->{'Show last created items in defined interfaces.'}    = 'Interfaces in denen das LastCreate Feature angezeigt werden soll.';
    $Lang->{'Number of shown items in last created.'}            = 'Anzahl der anzuzeigenden Artikel in zuletzt erstellte Artikel.';
    $Lang->{'Show top 10 items in defined interfaces.'}          = 'Interfaces in denen das Top 10 Feature angezeigt werden soll.';
    $Lang->{'Number of shown items in the top 10 feature.'}      = 'Anzahl der anzuzeigenden Artikel im Top 10 Feature.';
    $Lang->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'}
        = '';
    $Lang->{'Default state for FAQ entry.'}                      = 'Standard Status eines FAQ-Eintrags.';
    $Lang->{'Show WYSIWYG editor in agent interface.'}           = 'Anzeige eines WYSIWYG Editors im Agenten-Interface.';
    $Lang->{'New FAQ articles need approval before they get published.'}
        = 'Neue FAQ Artikel benötigen eine Freigabe vor der Veröffentlichung.';
    $Lang->{'Group for the approval of FAQ articles.'}           = 'Gruppe für die Freigabe von FAQ Artikeln.';
    $Lang->{'Queue for the approval of FAQ articles.'}           = 'Queue für die Freigabe von FAQ Artikeln.';
    $Lang->{'Ticket subject for approval of FAQ article.'}       = 'Betreff des Tickets zur Freigabe eines FAQ Artikels.';
    $Lang->{'Ticket body for approval of FAQ article.'}          = 'Body des Tickets zur Freigabe eines FAQ Artikels.';
    $Lang->{'Default priority of tickets for the approval of FAQ articles.'}
        = 'Standard Priorität von Tickets für die Freigabe von FAQ Artikeln.';
    $Lang->{'Default state of tickets for the approval of FAQ articles.'}
        = 'Standard Status von Tickets für die Freigabe von FAQ Artikeln.';
    $Lang->{'Definition of FAQ item free text field.'}           = 'Definition der freien Textfelder.';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'}
        = 'Definiert, dass ein \'FAQ\'-Objekte mit dem Linktyp \'Normal\' mit anderen \'FAQ\'-Objekten verlinkt werden kann.';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'}
        = 'Definiert, dass ein \'FAQ\'-Objekte mit dem Linktyp \'ParentChild\' mit anderen \'FAQ\'-Objekten verlinkt werden kann.';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'}
        = 'Definiert, dass ein \'FAQ\'-Objekte mit dem Linktyp \'Normal\' mit anderen \'Ticket\'-Objekten verlinkt werden kann.';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'}
        = 'Definiert, dass ein \'FAQ\'-Objekte mit dem Linktyp \'ParentChild\' mit anderen \'Ticket\'-Objekten verlinkt werden kann.';
    $Lang->{'Frontend module registration for the agent interface.'}    = '';
    $Lang->{'Frontend module registration for the customer interface.'} = '';
    $Lang->{'Frontend module registration for the public interface.'}   = '';
    $Lang->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'}
        = 'Standardwert des Action-Parameters für den öffentlichen FAQ-Bereich. Der Action-Parameter wird von den Skripten des Systems benutzt.';
    $Lang->{'Show FAQ Article with HTML.'}                              = 'HTML Darstellung der FAQ Artikel einschalten.';
    $Lang->{'Module to generate html OpenSearch profile for short faq search.'}
        = 'Modul zum Generieren des HTML "OpenSearch" Profils zur FAQ-Suche über das Browser-Suchfeld.';
    $Lang->{'Defines where the \'Insert FAQ\' link will be displayed.'} = 'Definiert wo der Link \'FAQ einfügen\' angezeigt werden soll.';
    $Lang->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'}
        = 'Ein Filter zur automatischen Generierung von FAQ-Links, wenn ein Hinweis auf einen FAQ-Artikel identifiziert wird. Das Element Image erlaubt zwei Eingabeformen: Erstens der Name eines Icons (z. B. faq.png). In diesem Fall wird auf das Graphikverzeichnis des OTRS zugegriffen. Als zweite Möglichkeit kann man aber auch den direkten Link zur Grafik angeben (z. B. http://otrs.org/faq.png).';
    $Lang->{'FAQ search backend router of the agent interface.'} = '';
    $Lang->{'Defines an overview module to show the small view of a FAQ list.'}
        = '';
    $Lang->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'}
        = '';
    $Lang->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'}
        = '';
    $Lang->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'}
        = '';
    $Lang->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'}
        = '';
    $Lang->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'}
        = '';
    $Lang->{'Defines the default FAQ attribute for FAQ sorting in a FAQ Explorer of the agent interface.'}
        = '';
    $Lang->{'Defines the default FAQ order of a Explorer result in the agent interface. Up: oldest on top. Down: latest on top.'}
        = '';
    $Lang->{'Maximum number of FAQ articles to be displayed in the result of a Explorer in the agent interface.'}
        = '';
    $Lang->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'}
        = '';
    $Lang->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'}
        = '';
    $Lang->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'}
        = '';
    $Lang->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface'}
        = '';
    $Lang->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'}
        = '';
    $Lang->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'}
        = '';
    $Lang->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'}
        = '';
    $Lang->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'}
        = '';
    $Lang->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'}
        = '';
    $Lang->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'}
        = '';
    $Lang->{'Number of FAQ articles to be displayed in each page of a search result in the customer interface.'}
        = '';
    $Lang->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'}
        = '';
    $Lang->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'}
        = '';
    $Lang->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'}
        = '';
    $Lang->{'Number of FAQ articles to be displayed in each page of a search result in the public interface.'}
        = '';
    $Lang->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'}
        = '';
    $Lang->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'}
        = '';
    $Lang->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'}
        = '';
    $Lang->{'Defines an overview module to show the small view of a FAQ journal.'}
        = '';

    # template: AgentFAQExplorer
    $Lang->{'FAQ Explorer'}             = '';
    $Lang->{'Subcategories'}            = '';
    $Lang->{'Articles'}                 = '';
    $Lang->{'No subcategories found.'}  = '';
    $Lang->{'No FAQ data found.'}       = '';

    # template: AgentFAQAdd
    $Lang->{'Add FAQ Article'}         = '';
    $Lang->{'Actions'}                 = '';
    $Lang->{'Go to explorer'}          = '';
    $Lang->{'The title is required.'}  = '';
    $Lang->{'A category is required.'} = '';

   # template: AgentFAQJournal
    $Lang->{'FAQ Journal'} = '';

    # template: AgentFAQLanguage
    $Lang->{'FAQ Language Management'}                               = '';
    $Lang->{'Add FAQ language'}                                      = '';
    $Lang->{'Add Language'}                                          = '';
    $Lang->{'Edit Language'}                                         = '';
    $Lang->{'Delete Language'}                                       = '';
    $Lang->{'The name is required!'}                                 = '';
    $Lang->{'This language already exists!'}                         = '';
    $Lang->{'FAQ language added!'}                                   = '';
    $Lang->{'FAQ language updated!'}                                 = '';
    $Lang->{'Do you really want to delete this Language?'}           = '';
    $Lang->{'This Language is used in the following FAQ Article(s)'} = '';
    $Lang->{'You can not delete this Language. It is used in at least one FAQ Article!'}
        = '';

    # template: AgentFAQCategory
    $Lang->{'FAQ Category Management'}                         = '';
    $Lang->{'Add FAQ category'}                                = '';
    $Lang->{'Add Category'}                                    = '';
    $Lang->{'Edit Category'}                                   = '';
    $Lang->{'Delete Category'}                                 = '';
    $Lang->{'A category should have a name!'}                  = '';
    $Lang->{'A category should have a comment!'}                = '';
    $Lang->{'A category needs at least one permission group!'} = '';
    $Lang->{'This category already exists!'}                   = '';
    $Lang->{'FAQ category updated!'}                           = '';
    $Lang->{'FAQ category added!'}                             = '';
    $Lang->{'Do you really want to delete this Category?'}     = '';
    $Lang->{'This Category is used in the following FAQ Artice(s)'}
        = '';
    $Lang->{'This Category is parent of the following SubCategories'}
        = '';
    $Lang->{'You can not delete this Category. It is used in at least one FAQ Article! and/or is parent of at least another Category'}
        = '';

    # template: AgentFAQZoom
    $Lang->{'FAQ Information'}                      = '';
    $Lang->{'Rating'}                               = '';
    $Lang->{'No votes found!'}                      = '';
    $Lang->{'Details'}                              = '';
    $Lang->{'Edit this FAQ'}                        = '';
    $Lang->{'History of this FAQ'}                  = '';
    $Lang->{'Print this FAQ'}                       = '';
    $Lang->{'Link another object to this FAQ item'} = '';
    $Lang->{'Delete this FAQ'}                      = '';
    $Lang->{'not helpful'}                          = '';
    $Lang->{'very helpful'}                         = '';
    $Lang->{'out of 5'}                             = '';
    $Lang->{'No votes found! Be the first one to rate this FAQ article.'}
         = '';

    # template: AgentFAQHistory
    $Lang->{'History Content'} = '';
    $Lang->{'Updated'}         = '';

    # template: AgentFAQDelete
    $Lang->{'Do you really want to delete this FAQ article?'} = '';

    return 1;
}

1;
