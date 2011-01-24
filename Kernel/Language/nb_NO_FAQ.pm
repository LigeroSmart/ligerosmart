# --
# Kernel/Language/nb_NO_FAQ.pm - the Norwegian translation of FAQ
# Copyright (C) 2011 Eirik Wulff <eirik@epledoktor.no>
# --
# $Id: nb_NO_FAQ.pm,v 1.1 2011-01-24 12:32:25 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

package Kernel::Language::nb_NO_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';
    $Lang->{'FAQ'}                         = 'OSS';
    $Lang->{'public'}                   = 'publiseres';
    $Lang->{'internal'}                   = 'internt';
    $Lang->{'public (all)'}                   = 'offentlig (alle)';
    $Lang->{'internal (agent)'}                   = 'kun internt (agenter)';
    $Lang->{'external (customer)'}                   = 'kun til kunder';

    $Lang->{'You have already voted!'}           = 'Du har allerede stemt';
    $Lang->{'No rate selected!'}                 = 'Ingen rating valgt';
    $Lang->{'Thanks for your vote!'}             = 'Takk for din stemme!';
    $Lang->{'Votes'}                             = 'Stemmer';
    $Lang->{'LatestChangedItems'}                = 'Sist oppdaterte OSS-artikler';
    $Lang->{'LatestCreatedItems'}                = 'Sist opprettede OSS-artikler';
    $Lang->{'Top10Items'}                        = 'Topp 10 OSS';
    $Lang->{'ArticleVotingQuestion'}             = 'Var denne artikkelen til hjelp? Vær snill og gi oss din stemme, slik at vi kan forbedre databasen. Tusen takk!';
    $Lang->{'SubCategoryOf'}                     = 'Underkategori av';
    $Lang->{'QuickSearch'}                       = 'Hurtigsøk';
    $Lang->{'DetailSearch'}                      = 'Detaljsøk';
    $Lang->{'Categories'}                        = 'Kategorier';
    $Lang->{'SubCategories'}                     = 'Underkategorier';
    $Lang->{'New FAQ Article'}                   = 'Ny OSS-artikkel';
    $Lang->{'FAQ Category'}                      = 'OSS-kategori';
    $Lang->{'A category should have a name!'}    = 'En kategori må ha et navn!';
    $Lang->{'A category should have a comment!'} = 'En kategori burde ha en kommentar!';
    $Lang->{'FAQ Articles'}                 = 'Ofte Stilte Spørsmål';
    $Lang->{'FAQ Articles (new created)'}        = 'OSS-artikler (nylig opprettet)';
    $Lang->{'FAQ Articles (recently changed)'}   = 'OSS-artikler (nylig endret)';
    $Lang->{'FAQ Articles (Top 10)'}             = 'OSS-artikler (Topp 10)';
    $Lang->{'StartDay'}                          = 'Startdag';
    $Lang->{'StartMonth'}                        = 'Måned';
    $Lang->{'StartYear'}                         = 'År';
    $Lang->{'EndDay'}                            = 'Sluttdag';
    $Lang->{'EndMonth'}                          = 'Måned';
    $Lang->{'EndYear'}                           = 'År';
    $Lang->{'Approval'}                          = 'Godkjenning';

    $Lang->{
        'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'
        } = 'Ingen tilgang til kategori. For å opprette en artikkel må du ha tilgang til minst én kategori. Vennligst sjekk dine gruppe-/kategori-tilganger under -kategorimeny-';
    $Lang->{'Agent groups which can access this category.'}    = 'Agent-grupper som har tilgang til denne kategorien';
    $Lang->{'A category needs at least one permission group!'} = 'En kategori må ha minst én tilgangsgruppe.';
    $Lang->{'Will be shown as comment in Explorer.'}           = 'Vil vises som kommentar i utforskeren';

    $Lang->{'Default category name.'}                                      = 'Forvalgt kategori';
    $Lang->{'Rates for voting. Key must be in percent.'}                   = 'Rater for avstemming. Nøkkel må være i prosent.';
    $Lang->{'Show voting in defined interfaces.'}                          = 'Vis avstemming i definerte grensensnitt';
    $Lang->{'Languagekey which is defined in the language file *_FAQ.pm.'} = 'LanguageKey definert i språkfilen *_FAQ.pm';
    $Lang->{'Show FAQ path yes/no.'}                                       = 'Vis OSS-sti (ja/nei)';
    $Lang->{'Decimal places of the voting result.'}                        = 'Antall desimaler for avstemningsresultat';
    $Lang->{'CSS color for the voting result.'}                            = 'CSS-farge for avstemningsresultat';
    $Lang->{'FAQ path separator.'}                                         = 'Separator for OSS-sti';
    $Lang->{'Interfaces where the quicksearch should be shown.'}           = 'Grensesnitt der hurtigsøket skal vises.';
    $Lang->{'Show items of subcategories.'}                                = 'Vis innhold i underkategorier.';
    $Lang->{'Show last change items in defined interfaces.'}               = 'Vis sist endrede artikler i definerte grensesnitt.';
    $Lang->{'Number of shown items in last changes.'}                      = 'Antall objekter vist i siste endringer.';
    $Lang->{'Show last created items in defined interfaces.'}              = 'Vis sist opprettede artikler i definerte grensesnitt';
    $Lang->{'Number of shown items in last created.'}                      = 'Antall viste objekter under sist opprettet.';
    $Lang->{'Show top 10 items in defined interfaces.'}                    = 'Vis "Topp 10" i definerte grensesnitt.';
    $Lang->{'Number of shown items in the top 10 feature.'}                = 'Antall viste artikler i "Topp 10"-funksjonen';
    $Lang->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'}
        = 'Identifikator for en OSS-artikkel, f.eks. FAQ#, KB#, OSS#, MinOSS#. Standard er FAQ#.';
    $Lang->{'Default state for FAQ entry.'}                                = 'Standard status for et OSS-objekt.';
    $Lang->{'Show WYSIWYG editor in agent interface.'}                     = 'Vis WYSIWYG-redigerer i agent-delen.';
    $Lang->{'New FAQ articles need approval before they get published.'}   = 'Nye artikler trenger godkjenning før de kan publiseres.';
    $Lang->{'Group for the approval of FAQ articles.'}                     = 'Gruppe som skal godkjenne OSS-artikler.';
    $Lang->{'Queue for the approval of FAQ articles.'}                     = 'Kø for godkjenning av OSS-artikler.';
    $Lang->{'Ticket subject for approval of FAQ article.'}                 = 'Saksemne for godkjenning av OSS-artikler.';
    $Lang->{'Ticket body for approval of FAQ article.'}                    = 'Saksinnhold for godkjenning av OSS-artikler.';
    $Lang->{'Default priority of tickets for the approval of FAQ articles.'}
        = 'Standard prioritet for saker for godkjenning av OSS-artikler.';
    $Lang->{'Default state of tickets for the approval of FAQ articles.'}  = 'Standard status for saker for godkjenning av OSS-artikler.';
    $Lang->{'Definition of FAQ item free text field.'}                     = 'Definisjon av fritekstfelt for OSS-artikler';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'}
        = 'Denne innstillingen definerer at en OSS-artikkel kan lenkes til andre OSS-artikler med "Normal" lenketype.';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'}
        = 'Denne innstillingen definerer at en OSS-artikkel kan lenkes til andre OSS-artikler med "Foreldre/Barn"-lenketype.';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'}
        = 'Denne innstillingen definerer at en OSS-artikkel kan lenkes til andre saker med "Normal" lenketype.';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'}
        = 'Denne innstillingen definerer at en OSS-artikkel kan lenkes til andre saker med "Foreldre/Barn"-lenketype.';
    $Lang->{'Frontend module registration for the agent interface.'}    = 'Modulregistrering for agentdelen';
    $Lang->{'Frontend module registration for the customer interface.'} = 'Modulregistrering for kundedelen';
    $Lang->{'Frontend module registration for the public interface.'}   = 'Modulregistrering for den offentlige delen';
    $Lang->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'}
        = '';
    $Lang->{'Show FAQ Article with HTML.'}                              = 'Vis HTML i OSS-artikkel.';
    $Lang->{'Module to generate html OpenSearch profile for short faq search.'}
        = '';
    $Lang->{'Defines where the \'Insert FAQ\' link will be displayed.'} = 'Definerer hvor "Sett inn OSS"-lenken skal vises.';
    $Lang->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'}
        = '';
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
    $Lang->{'FAQ Explorer'}             = 'Utforsker';
    $Lang->{'Subcategories'}            = 'Underkategorier';
    $Lang->{'Articles'}                 = 'Artikler';
    $Lang->{'No subcategories found.'}  = 'Ingen underkategorier funnet';
    $Lang->{'No FAQ data found.'}       = 'Ingen artikler funnet';

    # template: AgentFAQAdd
    $Lang->{'Add FAQ Article'}         = 'Legg til OSS-artikkel';
    $Lang->{'The title is required.'}  = 'Emne er obligatorisk.';
    $Lang->{'A category is required.'} = 'Kategori er obligatorisk.';

   # template: AgentFAQJournal
    $Lang->{'FAQ Journal'} = 'OSS-journal';

    # template: AgentFAQLanguage
    $Lang->{'Language Management'}                               = 'Språkoppsett';
    $Lang->{'FAQ Language Management'}                               = 'Språkoppsett for OSS';
    $Lang->{'Add Language'}                                          = 'Legg til språk';
    $Lang->{'Add language'}                                          = 'Legg til språk';
    $Lang->{'Edit Language'}                                         = 'Endre språk';
    $Lang->{'Delete Language'}                                       = 'Slett språk';
    $Lang->{'The name is required!'}                                 = 'Navn er påkrevd!';
    $Lang->{'This language already exists!'}                         = 'Dette språket finnes allerede!';
    $Lang->{'FAQ language added!'}                                   = 'OSS-språk lagt til!';
    $Lang->{'FAQ language updated!'}                                 = 'OSS-språk oppdatert!';
    $Lang->{'Do you really want to delete this Language?'}           = 'Vil du virkelig slette dette språket?';
    $Lang->{'This Language is used in the following FAQ Article(s)'} = 'Dette språket er i bruk på følgende artikler';
    $Lang->{'You can not delete this Language. It is used in at least one FAQ Article!'}
        = 'Du kan ikke slette dette språket, det er i bruk på minst én artikkel.';

    # template: AgentFAQCategory
    $Lang->{'Category Management'}                         = 'Kategorioppsett';
    $Lang->{'FAQ Category Management'}                         = 'Kategorioppsett for OSS';
    $Lang->{'Add Category'}                                    = 'Legg til kategori';
    $Lang->{'Add category'}                                    = 'Legg til kategori';
    $Lang->{'Edit Category'}                                   = 'Endre kategori';
    $Lang->{'Delete Category'}                                 = 'Slett kategori';
    $Lang->{'A category should have a name!'}                  = 'En kategori må ha et navn!';
    $Lang->{'A category should have a comment!'}                = 'En kategori må ha en kommentar!';
    $Lang->{'A category needs at least one permission group!'} = 'En kategori trenger minst én tilgangsgruppe';
    $Lang->{'This category already exists!'}                   = 'Denne kategorien finnes allerede!';
    $Lang->{'FAQ category updated!'}                           = 'OSS-kategori oppdatert!';
    $Lang->{'FAQ category added!'}                             = 'OSS-kategori lagt til';
    $Lang->{'Do you really want to delete this Category?'}     = 'Vil du virkelig slette denne katgorien?';
    $Lang->{'This Category is used in the following FAQ Artice(s)'}
        = 'Denne kategorien brukes i følgende OSS-artikler';
    $Lang->{'This Category is parent of the following SubCategories'}
        = 'Denne kategorien er forelder til følgende underkategorier';
    $Lang->{'You can not delete this Category. It is used in at least one FAQ Article! and/or is parent of at least another Category'}
        = 'Du kan ikke slette denne kategorien. Den brukes av minst én artikkel og/eller av minst én underkategori';

    # template: AgentFAQZoom
    $Lang->{'FAQ Information'}                      = 'Info om OSS';
    $Lang->{'Rating'}                               = 'Rating';
    $Lang->{'No votes found!'}                      = 'Ingen stemmer funnet!';
    $Lang->{'Details'}                              = 'Detaljer';
    $Lang->{'Edit this FAQ'}                        = 'Endre denne artikkelen';
    $Lang->{'History of this FAQ'}                  = 'Historikk over denne artikkelen';
    $Lang->{'Print this FAQ'}                       = 'Skriv ut denne artikkelen';
    $Lang->{'Link another object to this FAQ item'} = 'Lenk opp et annet objekt til denne artikkelen';
    $Lang->{'Delete this FAQ'}                      = 'Slett denne artikkelen';
    $Lang->{'not helpful'}                          = 'ikke til hjelp';
    $Lang->{'very helpful'}                         = 'veldig nyttig';
    $Lang->{'out of 5'}                             = 'av 5';
    $Lang->{'No votes found! Be the first one to rate this FAQ article.'}
         = 'Ingen stemmer avgitt! Bli den første til å stemme på denne artikkelen.';

    # template: AgentFAQHistory
    $Lang->{'History Content'} = 'Historikkinnhold';
    $Lang->{'Updated'}         = 'Oppdatert';

    # template: AgentFAQDelete
    $Lang->{'Do you really want to delete this FAQ article?'} = 'Vil du virkelig slette denne artikkelen?';

    # template: AgentFAQPrint
    $Lang->{'FAQ Article Print'} = 'Utskrift av OSS-artikkel';

    # template: CustomerFAQSearch
    $Lang->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'}
         = 'Fulltekstsøk i OSS-artikler (f.eks. "Ol*" eller "Andreas*n"';

    return 1;
}

1;
