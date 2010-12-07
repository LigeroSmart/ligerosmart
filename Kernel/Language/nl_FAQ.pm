# --
# Kernel/Language/nl_FAQ.pm - translation file
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: nl_FAQ.pm,v 1.16 2010-12-07 15:25:49 mb Exp $

package Kernel::Language::nl_FAQ;

use strict;

sub Data {
    my $Self = shift;

        # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'Artikel toevoegen';
    $Self->{Translation}->{'A category is required.'} = 'Kies een categorie.';
    $Self->{Translation}->{'Approval'} = 'Goedkeuring';

        # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'FAQ categoriebeheer';
    $Self->{Translation}->{'Add category'} = 'Categorie toevoegen';
    $Self->{Translation}->{'Delete: '} = '';
    $Self->{Translation}->{'Delete Category'} = 'Categorie verwijderen';
    $Self->{Translation}->{'Ok'} = '';
    $Self->{Translation}->{'Add Category'} = 'Categorie toevoegen';
    $Self->{Translation}->{'Edit Category'} = 'Categorie bewerken';
    $Self->{Translation}->{'SubCategoryOf'} = 'Subcategorie van';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Wordt in webinterface getoond';
    $Self->{Translation}->{'Please select at least one permission group.'} = '';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = '';
    $Self->{Translation}->{'Do you really want to delete this category?'} = '';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} = '';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = '';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = '';

        # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'Wilt u dit artikel verwijderen?';

        # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

        # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'FAQ verkenner';
    $Self->{Translation}->{'Subcategories'} = 'Subcategoriën';
    $Self->{Translation}->{'No subcategories found.'} = 'Geen subcategoriën gevonden.';

        # Template: AgentFAQHistory

        # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = '';

        # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'Beheer talen';
    $Self->{Translation}->{'Add language'} = 'Taal toevoegen';
    $Self->{Translation}->{'Delete Language'} = 'Taal verwijderen';
    $Self->{Translation}->{'Add Language'} = 'Taal toevoegen';
    $Self->{Translation}->{'Edit Language'} = 'Taal bewerken';
    $Self->{Translation}->{'Do you really want to delete this language?'} = '';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} = '';
    $Self->{Translation}->{'This kanguage is used in the following FAQ Article(s)'} = '';

        # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Max. shown FAQ items a page'} = '';

        # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'Geen FAQ data gevonden.';
    $Self->{Translation}->{'changed'} = '';

        # Template: AgentFAQPrint
    $Self->{Translation}->{'FAQ-Info'} = '';
    $Self->{Translation}->{'Votes'} = 'Stemmen';

        # Template: AgentFAQSearch

        # Template: AgentFAQSearchOpenSearchDescriptionFAQNumber

        # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = '';

        # Template: AgentFAQSearchResultPrint

        # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'Informatie';
    $Self->{Translation}->{'Rating'} = 'Beoordeling';
    $Self->{Translation}->{'Rating %'} = '';
    $Self->{Translation}->{'out of 5'} = 'van 5';
    $Self->{Translation}->{'No votes found!'} = 'Geen stemmen gevonden';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Geen stemmen gevonden. Wees de eerste om dit artikel te beoordelen.';
    $Self->{Translation}->{'Details'} = 'Details';
    $Self->{Translation}->{'Download Attachment'} = '';
    $Self->{Translation}->{'ArticleVotingQuestion'} = 'Hielp dit artikel bij het beantwoorden van uw vraag?';
    $Self->{Translation}->{'not helpful'} = 'helemaal niet';
    $Self->{Translation}->{'very helpful'} = 'heel erg';

        # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Insert FAQ Text'} = '';
    $Self->{Translation}->{'Insert FAQ Link'} = '';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = '';

        # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'Geen artikelen gevonden.';

        # Template: CustomerFAQPrint

        # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Zoeken in tekst van artikelen (bijv. "Jans*en" of "Print*")';

        # Template: CustomerFAQSearchOpenSearchDescription

        # Template: CustomerFAQSearchResultPrint

        # Template: CustomerFAQSearchResultShort

        # Template: CustomerFAQZoom
    $Self->{Translation}->{'Search for articles with keyword'} = 'Zoek op artikelen met trefwoord';

        # Template: PublicFAQExplorer

        # Template: PublicFAQPrint

        # Template: PublicFAQSearch

        # Template: PublicFAQSearchOpenSearchDescription
    $Self->{Translation}->{'Public'} = '';

        # Template: PublicFAQSearchResultPrint

        # Template: PublicFAQSearchResultShort

        # Template: PublicFAQZoom

        # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} = '';
    $Self->{Translation}->{'Article free text options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###AttributesView.'} = '';
    $Self->{Translation}->{'CSS color for the voting result.'} = '';
    $Self->{Translation}->{'Category Management'} = 'Beheer categoriën';
    $Self->{Translation}->{'Configure your own log text for PGP.'} = '';
    $Self->{Translation}->{'Custom text for the page shown to customers that have no tickets yet.'} = '';
    $Self->{Translation}->{'Decimal places of the voting result.'} = '';
    $Self->{Translation}->{'Default category name.'} = 'Standaard categorie';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Default state for FAQ entry.'} = '';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} = '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} = '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ Explorer of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order of a Explorer result in the agent interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} = '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} = '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} = '';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed. Note: AgentTicketActionCommon includes AgentTicketNote, AgentTicketClose, AgentTicketFreeText, AgentTicketOwner, AgentTicketPending, AgentTicketPriority and AgentTicketResponsible.'} = '';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = '';
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
    $Self->{Translation}->{'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).'} = '';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Interfaces where the quicksearch should be shown.'} = '';
    $Self->{Translation}->{'Journal'} = 'Logboek';
    $Self->{Translation}->{'Language Management'} = 'Beheer talen';
    $Self->{Translation}->{'Languagekey which is defined in the language file *_FAQ.pm.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a Explorer in the agent interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} = '';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search.'} = '';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in each page of a search result in the customer interface.'} = '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in each page of a search result in the public interface.'} = '';
    $Self->{Translation}->{'Number of shown items in last changes.'} = '';
    $Self->{Translation}->{'Number of shown items in last created.'} = '';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = '';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} = '';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} = '';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = '';
    $Self->{Translation}->{'Search FAQ'} = 'Zoeken in FAQ';
    $Self->{Translation}->{'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.'} = '';
    $Self->{Translation}->{'Show "Insert Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} = '';
    $Self->{Translation}->{'Show "Insert Text & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} = '';
    $Self->{Translation}->{'Show "Insert Text" Button in AgentFAQZoomSmall.'} = '';
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
    $Self->{Translation}->{'Ticket free text options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###AttributesView.'} = '';
    $Self->{Translation}->{'Ticket free time options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###AttributesView.'} = '';
    $Self->{Translation}->{'Ticket subject for approval of FAQ article.'} = '';

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
;

}

1;
