# --
# Kernel/Language/nl_FAQ.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: nl_FAQ.pm,v 1.26 2011-11-24 17:15:12 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nl_FAQ;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAFAQ
    $Self->{Translation}->{'internal'} = 'intern';
    $Self->{Translation}->{'public'} = 'publiek';
    $Self->{Translation}->{'external'} = 'extern';
    $Self->{Translation}->{'FAQ Number'} = 'FAQ nummer';
    $Self->{Translation}->{'Latest updated FAQ articles'} = 'Laatst gewijzigde artikelen';
    $Self->{Translation}->{'Latest created FAQ articles'} = 'Laatst aangemaakte artikelen';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Populairste artikelen';
    $Self->{Translation}->{'Subcategory of'} = 'Subcategorie van';
    $Self->{Translation}->{'No rate selected!'} = 'Geen waardering geselecteerd.';
    $Self->{Translation}->{'public (all)'} = 'publiek';
    $Self->{Translation}->{'external (customer)'} = 'extern (klanten)';
    $Self->{Translation}->{'internal (agent)'} = 'intern (gebruikers)';
    $Self->{Translation}->{'Start day'} = 'Eerste dag';
    $Self->{Translation}->{'Start month'} = 'Eerste maand';
    $Self->{Translation}->{'Start year'} = 'Eerste jaar';
    $Self->{Translation}->{'End day'} = 'Laatste dag';
    $Self->{Translation}->{'End month'} = 'Laatste maand';
    $Self->{Translation}->{'End year'} = 'Laatste jaar';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Bedankt voor uw stem!';
    $Self->{Translation}->{'You have already voted!'} = 'U heeft al gestemd.';
    $Self->{Translation}->{'FAQ Article Print'} = 'Artikel afdrukken';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'Artikelen (top 10)';
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'Artikelen (nieuw aangemaakt)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'Artikelen (laatst gewijzigd)';
    $Self->{Translation}->{'FAQ category updated!'} = 'FAQ categorie bijgewerkt.';
    $Self->{Translation}->{'FAQ category added!'} = 'FAQ categorie toegevoegd.';
    $Self->{Translation}->{'A category should have a name!'} = 'Geef een naam op voor de categorie.';
    $Self->{Translation}->{'This category already exists'} = 'Deze categorie bestaat al';
    $Self->{Translation}->{'FAQ language added!'} = 'Taal toegevoegd.';
    $Self->{Translation}->{'FAQ language updated!'} = 'Taal bijgewerkt';
    $Self->{Translation}->{'The name is required!'} = 'De naam is verplicht.';
    $Self->{Translation}->{'This language already exists!'} = 'Deze taal bestaat al.';

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'Artikel toevoegen';
    $Self->{Translation}->{'A category is required.'} = 'Kies een categorie.';
    $Self->{Translation}->{'Approval'} = 'Goedkeuring';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'FAQ categoriebeheer';
    $Self->{Translation}->{'Add category'} = 'Categorie toevoegen';
    $Self->{Translation}->{'Delete Category'} = 'Categorie verwijderen';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Add Category'} = 'Categorie toevoegen';
    $Self->{Translation}->{'Edit Category'} = 'Categorie bewerken';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Wordt in webinterface getoond.';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Selecteer tenminste één permissiegroep.';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Gebruikers met rechten op artikelen in deze categorie.';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'Wilt u deze categorie verwijderen?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} = 'U kunt deze categorie niet verwijderen. Hij wordt gebruikt in een of meer artikelen en/of heeft onderliggende categoriën.';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'Deze categorie wordt gebruikt door de volgende artikelen';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'Deze categorie heeft de volgende subcategoriën';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'Wilt u dit artikel verwijderen?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'FAQ verkenner';
    $Self->{Translation}->{'Quick Search'} = 'Zoeken';
    $Self->{Translation}->{'Advanced Search'} = 'Uitgebreid zoeken';
    $Self->{Translation}->{'Subcategories'} = 'Subcategoriën';
    $Self->{Translation}->{'FAQ Articles'} = 'Artikelen';
    $Self->{Translation}->{'No subcategories found.'} = 'Geen subcategoriën gevonden.';

    # Template: AgentFAQHistory

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'Geen data gevonden.';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'Beheer talen';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languges.'} = 'Gebruik deze feature als u met meerdere talen wilt werken.';
    $Self->{Translation}->{'Add language'} = 'Taal toevoegen';
    $Self->{Translation}->{'Delete Language'} = 'Taal verwijderen';
    $Self->{Translation}->{'Add Language'} = 'Taal toevoegen';
    $Self->{Translation}->{'Edit Language'} = 'Taal bewerken';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'Wilt u deze taal verwijderen?';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} = 'U kunt deze taal niet verwijderen, hij wordt gebruikt door een of meer artikelen.';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'Deze taal is gebruikt voor de volgende artikelen';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'FAQ articles per page'} = 'Aantal artikelen per pagina';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'Geen FAQ data gevonden.';

    # Template: AgentFAQPrint
    $Self->{Translation}->{'FAQ-Info'} = 'FAQ Informatie';
    $Self->{Translation}->{'Votes'} = 'Stemmen';

    # Template: AgentFAQSearch

    # Template: AgentFAQSearchOpenSearchDescriptionFAQNumber

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'Zoeken in FAQ';

    # Template: AgentFAQSearchResultPrint

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'FAQ zoeken';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'Informatie';
    $Self->{Translation}->{'Rating'} = 'Beoordeling';
    $Self->{Translation}->{'Rating %'} = 'Beoordeling %';
    $Self->{Translation}->{'out of 5'} = 'van 5';
    $Self->{Translation}->{'No votes found!'} = 'Geen stemmen gevonden';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Geen stemmen gevonden. Wees de eerste om dit artikel te beoordelen.';
    $Self->{Translation}->{'Download Attachment'} = 'Sla bijlage op';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} = 'Hielp dit artikel bij het beantwoorden van uw vraag?';
    $Self->{Translation}->{'not helpful'} = 'helemaal niet';
    $Self->{Translation}->{'very helpful'} = 'heel erg';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Insert FAQ Text'} = 'Voeg FAQ tekst in';
    $Self->{Translation}->{'Insert FAQ Link'} = 'Voeg link naar FAQ in';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'Voeg FAQ tekst en link in';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'Geen artikelen gevonden.';

    # Template: CustomerFAQPrint

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Zoeken in tekst van artikelen (bijv. "Jans*en" of "Print*")';

    # Template: CustomerFAQSearchOpenSearchDescription

    # Template: CustomerFAQSearchResultPrint

    # Template: CustomerFAQSearchResultShort

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Details'} = 'Details';
    $Self->{Translation}->{'Search for articles with keyword'} = 'Zoek op artikelen met trefwoord';

    # Template: PublicFAQExplorer

    # Template: PublicFAQPrint

    # Template: PublicFAQSearch

    # Template: PublicFAQSearchOpenSearchDescription
    $Self->{Translation}->{'Public'} = 'Openbaar';

    # Template: PublicFAQSearchResultPrint

    # Template: PublicFAQSearchResultShort

    # Template: PublicFAQZoom

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} = '';
    $Self->{Translation}->{'CSS color for the voting result.'} = '';
    $Self->{Translation}->{'Category Management'} = 'Beheer categoriën';
    $Self->{Translation}->{'Decimal places of the voting result.'} = '';
    $Self->{Translation}->{'Default category name.'} = 'Standaard categorie';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = '';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Default state for FAQ entry.'} = '';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} = '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} = '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the customer interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the agent interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the customer interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the public interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} = '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} = '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} = '';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed. Note: AgentTicketActionCommon includes AgentTicketNote, AgentTicketClose, AgentTicketFreeText, AgentTicketOwner, AgentTicketPending, AgentTicketPriority and AgentTicketResponsible.'} = '';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = '';
    $Self->{Translation}->{'Delete this FAQ'} = '';
    $Self->{Translation}->{'Edit this FAQ'} = '';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = '';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = '';
    $Self->{Translation}->{'FAQ Journal'} = 'FAQ journaal';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = '';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = '';
    $Self->{Translation}->{'FAQ limit per page for FAQ Journal Overview "Small"'} = '';
    $Self->{Translation}->{'FAQ limit per page for FAQ Overview "Small"'} = '';
    $Self->{Translation}->{'FAQ path separator.'} = '';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = '';
    $Self->{Translation}->{'FAQ-Area'} = 'Knowledge Base';
    $Self->{Translation}->{'Frontend module registration for the public interface.'} = '';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'History of this FAQ'} = '';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Interfaces where the quicksearch should be shown.'} = '';
    $Self->{Translation}->{'Journal'} = 'Logboek';
    $Self->{Translation}->{'Language Management'} = 'Beheer talen';
    $Self->{Translation}->{'Languagekey which is defined in the language file *_FAQ.pm.'} = '';
    $Self->{Translation}->{'Link another object to this FAQ item'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the agent interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the customer interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the public interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} = '';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search.'} = '';
    $Self->{Translation}->{'New FAQ Article'} = 'Nieuw artikel';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the customer interface.'} = '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the public interface.'} = '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the customer interface.'} = '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the public interface.'} = '';
    $Self->{Translation}->{'Number of shown items in last changes.'} = '';
    $Self->{Translation}->{'Number of shown items in last created.'} = '';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = '';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} = '';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} = '';
    $Self->{Translation}->{'Print this FAQ'} = '';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = '';
    $Self->{Translation}->{'Search FAQ'} = 'Zoeken in FAQ';
    $Self->{Translation}->{'Show "Insert FAQ Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} = '';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} = '';
    $Self->{Translation}->{'Show "Insert FAQ Text" Button in AgentFAQZoomSmall.'} = '';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = '';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = 'Toon FAQ pad ja/nee';
    $Self->{Translation}->{'Show WYSIWYG editor in agent interface.'} = '';
    $Self->{Translation}->{'Show items of subcategories.'} = '';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = 'Toon stem-feature';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'} = '';
    $Self->{Translation}->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'} = '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'} = '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'} = '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'} = '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'} = '';
    $Self->{Translation}->{'Ticket body for approval of FAQ article.'} = '';
    $Self->{Translation}->{'Ticket subject for approval of FAQ article.'} = '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
