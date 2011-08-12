# --
# Kernel/Language/da_FAQ.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: da_FAQ.pm,v 1.16 2011-08-12 21:48:22 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::da_FAQ;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAFAQ
    $Self->{Translation}->{'internal'} = '';
    $Self->{Translation}->{'public'} = '';
    $Self->{Translation}->{'external'} = '';
    $Self->{Translation}->{'FAQ Number'} = '';
    $Self->{Translation}->{'Latest updated FAQ articles'} = 'Sidst ændrede artikler';
    $Self->{Translation}->{'Latest created FAQ articles'} = 'Nyeste artikler';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Top 10 artikler';
    $Self->{Translation}->{'Subcategory of'} = 'Underkategori af';
    $Self->{Translation}->{'No rate selected!'} = 'Ingen rate valgt!';
    $Self->{Translation}->{'public (all)'} = '';
    $Self->{Translation}->{'external (customer)'} = '';
    $Self->{Translation}->{'internal (agent)'} = '';
    $Self->{Translation}->{'Start day'} = 'Start dag';
    $Self->{Translation}->{'Start month'} = 'Start måned';
    $Self->{Translation}->{'Start year'} = 'Start år';
    $Self->{Translation}->{'End day'} = 'Slut dag';
    $Self->{Translation}->{'End month'} = 'Slut måned';
    $Self->{Translation}->{'End year'} = 'Slut år';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Tak for din stemme!';
    $Self->{Translation}->{'You have already voted!'} = 'Du har allerede stemt!';
    $Self->{Translation}->{'FAQ Article Print'} = '';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = '';
    $Self->{Translation}->{'FAQ Articles (new created)'} = '';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = '';
    $Self->{Translation}->{'FAQ category updated!'} = '';
    $Self->{Translation}->{'FAQ category added!'} = '';
    $Self->{Translation}->{'A category should have a name!'} = '';
    $Self->{Translation}->{'This category already exists'} = '';
    $Self->{Translation}->{'FAQ language added!'} = '';
    $Self->{Translation}->{'FAQ language updated!'} = '';
    $Self->{Translation}->{'The name is required!'} = '';
    $Self->{Translation}->{'This language already exists!'} = '';

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = '';
    $Self->{Translation}->{'Keywords'} = '';
    $Self->{Translation}->{'A category is required.'} = '';
    $Self->{Translation}->{'Approval'} = 'Godkendt';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = '';
    $Self->{Translation}->{'Add category'} = '';
    $Self->{Translation}->{'Delete Category'} = '';
    $Self->{Translation}->{'Ok'} = '';
    $Self->{Translation}->{'Add Category'} = '';
    $Self->{Translation}->{'Edit Category'} = '';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Vil blive vist som kommentar i Explore.';
    $Self->{Translation}->{'Please select at least one permission group.'} = '';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = '';
    $Self->{Translation}->{'Do you really want to delete this category?'} = '';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} = '';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = '';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = '';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = '';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = '';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = '';
    $Self->{Translation}->{'Quick Search'} = '';
    $Self->{Translation}->{'Advanced Search'} = '';
    $Self->{Translation}->{'Subcategories'} = '';
    $Self->{Translation}->{'FAQ Articles'} = '';
    $Self->{Translation}->{'No subcategories found.'} = '';

    # Template: AgentFAQHistory

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = '';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = '';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languges.'} = '';
    $Self->{Translation}->{'Add language'} = '';
    $Self->{Translation}->{'Delete Language'} = '';
    $Self->{Translation}->{'Add Language'} = '';
    $Self->{Translation}->{'Edit Language'} = '';
    $Self->{Translation}->{'Do you really want to delete this language?'} = '';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} = '';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = '';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = '';
    $Self->{Translation}->{'FAQ articles per page'} = '';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = '';

    # Template: AgentFAQPrint
    $Self->{Translation}->{'FAQ-Info'} = '';
    $Self->{Translation}->{'Votes'} = 'Stemmer';
    $Self->{Translation}->{'Last update'} = '';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = '';

    # Template: AgentFAQSearchOpenSearchDescriptionFAQNumber

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = '';

    # Template: AgentFAQSearchResultPrint

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = '';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = '';
    $Self->{Translation}->{'Rating'} = '';
    $Self->{Translation}->{'Rating %'} = '';
    $Self->{Translation}->{'out of 5'} = '';
    $Self->{Translation}->{'No votes found!'} = '';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = '';
    $Self->{Translation}->{'Download Attachment'} = '';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} = '';
    $Self->{Translation}->{'not helpful'} = '';
    $Self->{Translation}->{'very helpful'} = '';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Insert FAQ Text'} = '';
    $Self->{Translation}->{'Insert FAQ Link'} = '';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = '';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = '';

    # Template: CustomerFAQPrint

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = '';

    # Template: CustomerFAQSearchOpenSearchDescription

    # Template: CustomerFAQSearchResultPrint

    # Template: CustomerFAQSearchResultShort

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Details'} = '';
    $Self->{Translation}->{'Search for articles with keyword'} = '';

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
    $Self->{Translation}->{'CSS color for the voting result.'} = '';
    $Self->{Translation}->{'Category Management'} = '';
    $Self->{Translation}->{'Configure your own log text for PGP.'} = '';
    $Self->{Translation}->{'Custom text for the page shown to customers that have no tickets yet.'} = '';
    $Self->{Translation}->{'Decimal places of the voting result.'} = '';
    $Self->{Translation}->{'Default category name.'} = '';
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
    $Self->{Translation}->{'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.'} = '';
    $Self->{Translation}->{'Defines the free key field number 1 for articles to add a new article attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 10 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 11 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 12 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 13 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 14 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 15 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 16 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 2 for articles to add a new article attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 2 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 3 for articles to add a new article attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 3 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 4 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 5 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 6 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 7 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 8 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the free key field number 9 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.'} = '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} = '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} = '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} = '';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed. Note: AgentTicketActionCommon includes AgentTicketNote, AgentTicketClose, AgentTicketFreeText, AgentTicketOwner, AgentTicketPending, AgentTicketPriority and AgentTicketResponsible.'} = '';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = '';
    $Self->{Translation}->{'Delete this FAQ'} = '';
    $Self->{Translation}->{'Edit this FAQ'} = '';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = '';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = '';
    $Self->{Translation}->{'FAQ Journal'} = '';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = '';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = '';
    $Self->{Translation}->{'FAQ limit per page for FAQ Journal Overview "Small"'} = '';
    $Self->{Translation}->{'FAQ limit per page for FAQ Overview "Small"'} = '';
    $Self->{Translation}->{'FAQ path separator.'} = '';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = '';
    $Self->{Translation}->{'FAQ-Area'} = '';
    $Self->{Translation}->{'Frontend module registration for the public interface.'} = '';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'History of this FAQ'} = '';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Interfaces where the quicksearch should be shown.'} = '';
    $Self->{Translation}->{'Journal'} = '';
    $Self->{Translation}->{'Language Management'} = '';
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
    $Self->{Translation}->{'New FAQ Article'} = 'Ny FAQ Artikel';
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
    $Self->{Translation}->{'Search FAQ'} = '';
    $Self->{Translation}->{'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.'} = '';
    $Self->{Translation}->{'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.'} = '';
    $Self->{Translation}->{'Show "Insert FAQ Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} = '';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} = '';
    $Self->{Translation}->{'Show "Insert FAQ Text" Button in AgentFAQZoomSmall.'} = '';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = '';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = '';
    $Self->{Translation}->{'Show WYSIWYG editor in agent interface.'} = '';
    $Self->{Translation}->{'Show items of subcategories.'} = '';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'} = '';
    $Self->{Translation}->{'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".'} = '';
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
    $Self->{Translation}->{'A category needs min. one permission group!'} = 'En kategori behøver mindst en rettighedsgruppe.';
    $Self->{Translation}->{'Agent groups which can access this category.'} = 'Agentgrupper som kan tilgå denne kategori.';
    $Self->{Translation}->{'Categories'} = 'Kategorier';
    $Self->{Translation}->{'DetailSearch'} = 'Detaljeret søgning';
    $Self->{Translation}->{'FAQ Category'} = 'FAQ Kategorier';
    $Self->{Translation}->{'FAQ News (Top 10)'} = 'FAQ Nyheder (Top 10)';
    $Self->{Translation}->{'FAQ News (new created)'} = 'FAQ Nyheder (nyoprettet)';
    $Self->{Translation}->{'FAQ News (recently changed)'} = 'FAQ Nyheder (sidst ændrede)';
    $Self->{Translation}->{'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'} = 'Der er ikke valgt kategori. For at oprette en ny artikel skal du have adgang til mindst en kategori. Tjek dine Gruppe/Kategori rettigheder under -Kategori menuen-!';
    $Self->{Translation}->{'QuickSearch'} = 'Søgning';
    $Self->{Translation}->{'SubCategories'} = 'Underkategorier';

}

1;
