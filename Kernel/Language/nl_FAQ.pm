# --
# Kernel/Language/nl_FAQ.pm - the Dutch translation of FAQ
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: nl_FAQ.pm,v 1.15 2010-12-06 20:11:04 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nl_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.15 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'FAQ'} = 'FAQ';
    $Lang->{'FAQ-Area'} = 'Knowledge Base';
    $Lang->{'You have already voted!'} = 'U heeft al gestemd.';
    $Lang->{'No rate selected!'}       = 'Geen beoordeling geselecteerd.';
    $Lang->{'Thanks for your vote!'}   = 'Dank voor uw stem.';
    $Lang->{'Votes'}                   = 'Stemmen';
    $Lang->{'LatestChangedItems'}      = 'Laatst veranderde artikelen';
    $Lang->{'LatestCreatedItems'}      = 'Nieuwste artikel';
    $Lang->{'Top10Items'}              = 'Top 10 artikelen';
    $Lang->{'ArticleVotingQuestion'}   = '';
    $Lang->{'SubCategoryOf'}           = 'Subcategorie van';
    $Lang->{'QuickSearch'}             = 'Snelzoeken';
    $Lang->{'DetailSearch'}            = 'Geavanceerd zoeken';
    $Lang->{'Categories'}              = 'Categoriën';
    $Lang->{'SubCategories'}           = 'Subcategoriën';
    $Lang->{'New FAQ Article'}         = 'Nieuw FAQ artikel';
    $Lang->{'FAQ Category'}            = 'FAQ categorie';
    $Lang->{'A category should have a name!'}    = 'Geef een naam op voor de categorie';
    $Lang->{'A category should have a comment!'} = 'Geef een beschrijving op voor de categorie';
    $Lang->{'FAQ Articles (new created)'}        = 'FAQ artikelen (nieuw aangemaakt)';
    $Lang->{'FAQ Articles (recently changed)'}   = 'FAQ artikelen (laatst veranderd)';
    $Lang->{'FAQ Articles (Top 10)'}             = 'FAQ artikelen (top 10)';
    $Lang->{'StartDay'}                          = 'Eerste dag';
    $Lang->{'StartMonth'}                        = 'Eerste maand';
    $Lang->{'StartYear'}                         = 'Eerste jaar';
    $Lang->{'EndDay'}                            = 'Laatste dag';
    $Lang->{'EndMonth'}                          = 'Laatste maand';
    $Lang->{'EndYear'}                           = 'Laatste jaar';
    $Lang->{'Approval'}                          = 'Goedkeuring';
    $Lang->{'internal'}                          = 'intern';
    $Lang->{'external'}                          = 'extern';
    $Lang->{'public'}                            = 'publiek';
    $Lang->{
        'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'
        }
        = 'Geen categorie toegankelijk. Om een artikel te kunnen aanmaken moet u toegan hebben tot tenminste een categorie. Controleer uw groep/categorie rechten';
    $Lang->{'Agent groups which can access this category.'}
        = 'Behandelgroepen met toegang tot deze categorie';
    $Lang->{'A category needs at least one permission group!'}
        = 'Voeg tenminste een permissiegroep toe per categorie.';
    $Lang->{'Will be shown as comment in Explorer.'} = 'Wordt in webinterface getoond';

    $Lang->{'Default category name.'}                                      = 'Standaard categorie';
    $Lang->{'Rates for voting. Key must be in percent.'}                   = '';
    $Lang->{'Show voting in defined interfaces.'}                          = 'Toon stem-feature';
    $Lang->{'Languagekey which is defined in the language file *_FAQ.pm.'} = 'Taal zoals gedefiniëerd in de language file *_FAQ.pm';
    $Lang->{'Show FAQ path yes/no.'}                                       = 'Toon FAQ pad ja/nee';
    $Lang->{'Decimal places of the voting result.'}                        = '';
    $Lang->{'CSS color for the voting result.'}                            = '';
    $Lang->{'FAQ path separator.'}                                         = '';
    $Lang->{'Interfaces where the quicksearch should be shown.'}           = '';
    $Lang->{'Show items of subcategories.'}                                = '';
    $Lang->{'Show last change items in defined interfaces.'}               = '';
    $Lang->{'Number of shown items in last changes.'}                      = '';
    $Lang->{'Show last created items in defined interfaces.'}              = '';
    $Lang->{'Number of shown items in last created.'}                      = '';
    $Lang->{'Show top 10 items in defined interfaces.'}                    = '';
    $Lang->{'Number of shown items in the top 10 feature.'}                = '';
    $Lang->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'}
        = '';
    $Lang->{'Default state for FAQ entry.'}                                = '';
    $Lang->{'Show WYSIWYG editor in agent interface.'}                     = '';
    $Lang->{'New FAQ articles need approval before they get published.'}   = '';
    $Lang->{'Group for the approval of FAQ articles.'}                     = '';
    $Lang->{'Queue for the approval of FAQ articles.'}                     = '';
    $Lang->{'Ticket subject for approval of FAQ article.'}                 = '';
    $Lang->{'Ticket body for approval of FAQ article.'}                    = '';
    $Lang->{'Default priority of tickets for the approval of FAQ articles.'}
        = '';
    $Lang->{'Default state of tickets for the approval of FAQ articles.'}  = '';
    $Lang->{'Definition of FAQ item free text field.'}                     = '';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'}
        = '';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'}
        = '';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'}
        = '';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'}
        = '';
    $Lang->{'Frontend module registration for the agent interface.'}    = '';
    $Lang->{'Frontend module registration for the customer interface.'} = '';
    $Lang->{'Frontend module registration for the public interface.'}   = '';
    $Lang->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'}
        = '';
    $Lang->{'Show FAQ Article with HTML.'}                              = '';
    $Lang->{'Module to generate html OpenSearch profile for short faq search.'}
        = '';
    $Lang->{'Defines where the \'Insert FAQ\' link will be displayed.'} = '';
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
    $Lang->{'FAQ Explorer'}             = 'FAQ verkenner';
    $Lang->{'Subcategories'}            = 'Subcategoriën';
    $Lang->{'Articles'}                 = 'Artikelen';
    $Lang->{'No subcategories found.'}  = 'Geen subcategoriën gevonden.';
    $Lang->{'No FAQ data found.'}       = 'Geen FAQ data gevonden.';

    # template: AgentFAQAdd
    $Lang->{'Add FAQ Article'}         = 'Artikel toevoegen';
    $Lang->{'The title is required.'}  = 'Vul een titel in.';
    $Lang->{'A category is required.'} = 'Kies een categorie.';

   # template: AgentFAQJournal
    $Lang->{'FAQ Journal'} = 'FAQ journaal';

    # template: AgentFAQLanguage
    $Lang->{'FAQ Language Management'}                               = 'Beheer talen';
    $Lang->{'Add Language'}                                          = 'Taal toevoegen';
    $Lang->{'Add language'}                                          = 'Taal toevoegen';
    $Lang->{'Edit Language'}                                         = 'Taal bewerken';
    $Lang->{'Delete Language'}                                       = 'Taal verwijderen';
    $Lang->{'The name is required!'}                                 = 'De naam is verplicht.';
    $Lang->{'This language already exists!'}                         = 'Deze taal bestaat al.';
    $Lang->{'FAQ language added!'}                                   = 'Taal toegevoegd.';
    $Lang->{'FAQ language updated!'}                                 = 'Taal bijgewerkt.';
    $Lang->{'Do you really want to delete this Language?'}           = 'Wil je deze taal verwijderen?';
    $Lang->{'This Language is used in the following FAQ Article(s)'} = 'Deze taal is gebruikt in de volgende artikel(en)';
    $Lang->{'You can not delete this Language. It is used in at least one FAQ Article!'}
        = 'U kunt deze taal niet verwijderen. Hij is gebruikt in tenminste één artikel.';

    # template: AgentFAQCategory
    $Lang->{'FAQ Category Management'}                         = 'FAQ categoriebeheer';
    $Lang->{'Add Category'}                                    = 'Categorie toevoegen';
    $Lang->{'Add category'}                                    = 'Categorie toevoegen';
    $Lang->{'Edit Category'}                                   = 'Categorie bewerken';
    $Lang->{'Delete Category'}                                 = 'Categorie verwijderen';
    $Lang->{'A category should have a name!'}                  = 'Vul een naam in.';
    $Lang->{'A category should have a comment!'}                = 'Vul een opmerking in.';
    $Lang->{'A category needs at least one permission group!'} = 'Kies tenminste één permissiegroep';
    $Lang->{'This category already exists!'}                   = 'Deze categorie bestaat al.';
    $Lang->{'FAQ category updated!'}                           = 'Categorie bijgewerkt.';
    $Lang->{'FAQ category added!'}                             = 'Categorie toegevoegd.';
    $Lang->{'Do you really want to delete this Category?'}     = 'Wilt u deze categorie verwijderen?';
    $Lang->{'This Category is used in the following FAQ Artice(s)'}
        = 'Deze categorie is gebruikt in de volgende artikelen';
    $Lang->{'This Category is parent of the following SubCategories'}
        = 'Deze categorie is ouder van de volgende subcategoriën';
    $Lang->{'You can not delete this Category. It is used in at least one FAQ Article! and/or is parent of at least another Category'}
        = 'U kunt deze taal niet verwijderen. Hij is gebruikt in tenminste één artikel en/of is ouder in teminste één andere categorie';

    # template: AgentFAQZoom
    $Lang->{'FAQ Information'}                      = 'Informatie';
    $Lang->{'Rating'}                               = 'Beoordeling';
    $Lang->{'No votes found!'}                      = 'Geen stemmen gevonden';
    $Lang->{'Details'}                              = 'Details';
    $Lang->{'Edit this FAQ'}                        = 'Bewerk dit artikel';
    $Lang->{'History of this FAQ'}                  = 'Geschiedenis van dit artikel';
    $Lang->{'Print this FAQ'}                       = 'Print dit artikel';
    $Lang->{'Link another object to this FAQ item'} = 'Koppel een object aan dit artikel';
    $Lang->{'Delete this FAQ'}                      = 'Verwijder dit artikel';
    $Lang->{'not helpful'}                          = 'niet behulpzaam';
    $Lang->{'very helpful'}                         = 'heel behulpzaam';
    $Lang->{'out of 5'}                             = 'van 5';
    $Lang->{'No votes found! Be the first one to rate this FAQ article.'}
         = 'Geen stemmen gevonden. Wees de eerste om dit artikel te beoordelen.';

    # template: AgentFAQHistory
    $Lang->{'History Content'} = 'Geschiedenis';
    $Lang->{'Updated'}         = 'Bijgewerkt';

    # template: AgentFAQDelete
    $Lang->{'Do you really want to delete this FAQ article?'} = 'Wilt u dit artikel verwijderen?';

    # template: AgentFAQPrint
    $Lang->{'FAQ Article Print'} = 'FAQ afdrukken';

    # template: CustomerFAQSearch
    $Lang->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'}
         = 'Zoeken in tekst van artikelen (bijv. "Jans*en" of "Print*")';
    return 1;
}

1;
