# --
# Kernel/Language/fi_FAQ.pm - translation file
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fi_FAQ;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAFAQ
    $Self->{Translation}->{'internal'} = 'sisäinen';
    $Self->{Translation}->{'public'} = 'julkinen';
    $Self->{Translation}->{'external'} = 'ulkoinen';
    $Self->{Translation}->{'FAQ Number'} = 'FAQ-numero';
    $Self->{Translation}->{'Latest updated FAQ articles'} = 'Viimeksi päivitetyt artikkelit';
    $Self->{Translation}->{'Latest created FAQ articles'} = 'Viimeksi julkaistut artikkelit';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Top 10 artikkelit';
    $Self->{Translation}->{'Subcategory of'} = 'Alakategoria';
    $Self->{Translation}->{'No rate selected!'} = 'Ei valittua arviota';
    $Self->{Translation}->{'Explorer'} = '';
    $Self->{Translation}->{'public (all)'} = 'julkinen (kaikki)';
    $Self->{Translation}->{'external (customer)'} = 'ulkoinen (asiakkaat)';
    $Self->{Translation}->{'internal (agent)'} = 'sisäinen (agentit)';
    $Self->{Translation}->{'Start day'} = 'Aloituspäivä';
    $Self->{Translation}->{'Start month'} = 'Aloitus kuukausi';
    $Self->{Translation}->{'Start year'} = 'Aloitusvuosi';
    $Self->{Translation}->{'End day'} = 'Loppupäivä';
    $Self->{Translation}->{'End month'} = 'Loppukuukausi';
    $Self->{Translation}->{'End year'} = 'Loppuvuosi';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Kiitos arvostelustasi!';
    $Self->{Translation}->{'You have already voted!'} = 'Olet jo arvostellut tämän artikkelin!';
    $Self->{Translation}->{'FAQ Article Print'} = 'Tulosta artikkeli';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'Artikkelit (Top 10)';
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'Artikkeli (uudet)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'Artikkeli (päivitetty äskettäin)';
    $Self->{Translation}->{'FAQ category updated!'} = 'Kategoria päivitetty!';
    $Self->{Translation}->{'FAQ category added!'} = 'Kategoria lisätty!';
    $Self->{Translation}->{'A category should have a name!'} = 'Kategorialla tulee olla nimi!';
    $Self->{Translation}->{'This category already exists'} = 'Tämä kategoria on jo olemassa';
    $Self->{Translation}->{'FAQ language added!'} = 'Kieli lisätty';
    $Self->{Translation}->{'FAQ language updated!'} = 'Kieli päivitetty!';
    $Self->{Translation}->{'The name is required!'} = 'Nimi on pakollinen!';
    $Self->{Translation}->{'This language already exists!'} = 'Tämä kieli on jo olemassa!';
    $Self->{Translation}->{'Symptom'} = '';
    $Self->{Translation}->{'Solution'} = '';

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'Lisää FAQ artikkeli';
    $Self->{Translation}->{'Keywords'} = '';
    $Self->{Translation}->{'A category is required.'} = 'Kategoria on pakollinen.';
    $Self->{Translation}->{'Approval'} = 'Hyväksyntä';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'FAQ:n Kategorioiden hallinta';
    $Self->{Translation}->{'Add category'} = 'Lisää kategoria';
    $Self->{Translation}->{'Delete Category'} = 'Poista kategoria';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Add Category'} = 'Lisää kategoria';
    $Self->{Translation}->{'Edit Category'} = 'Muokkaa kategoriaa';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Valitse ainakin yksi oikeusryhmä.';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Agenttiryhmät, joilla on pääsy artikkeleihin tässä kategoriassa';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Näytetään kommenttina Selaimessa.';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'Haluatko varmasti poistaa tämän kategorian?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        'Et voi poistaa tätä kategoriaa! Se sisältää joko artikkeleita tai se on toisen kategorian isäntäkategoria.';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'Seuraavat artikkelit kuuluvat tähän kategoriaan';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'Nämä kategoriat ovat tämän kategorian alakategorioita';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'Haluatko varmasti poistaa tämän artikkelin?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'Selain';
    $Self->{Translation}->{'Quick Search'} = 'Pikahaku';
    $Self->{Translation}->{'Wildcards are allowed.'} = '';
    $Self->{Translation}->{'Advanced Search'} = 'Monipuolinen haku';
    $Self->{Translation}->{'Subcategories'} = 'Alakategoriat';
    $Self->{Translation}->{'FAQ Articles'} = 'Artikkelit';
    $Self->{Translation}->{'No subcategories found.'} = 'Ei alakategorioita.';

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = '';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'FAQ:n kielten hallinta';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languges.'} =
        'Käytä tätä ominaisuutta, jos haluat käyttää useampaa kieltä.';
    $Self->{Translation}->{'Add language'} = 'Lisää kieli';
    $Self->{Translation}->{'Delete Language %s'} = 'Poista kieli %s';
    $Self->{Translation}->{'Add Language'} = 'Lisää kieli';
    $Self->{Translation}->{'Edit Language'} = 'Muokkaa kieltä';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'Haluatko varmasti poistaa tämän kielen?';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        'Et voi poistaa tätä kieltä. Ainakin yksi artikkeli käyttää tätä kieltä!';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'Seuraavat artikkelit käyttävät tätä kieltä';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = '';
    $Self->{Translation}->{'FAQ articles per page'} = 'Artikkeleita per sivu';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'Yhtään artikkelia ei löytynyt';

    # Template: AgentFAQPrint
    $Self->{Translation}->{'FAQ-Info'} = 'FAQ tiedot';
    $Self->{Translation}->{'Votes'} = 'Äänestykset';
    $Self->{Translation}->{'Last update'} = '';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = '';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = '';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = '';
    $Self->{Translation}->{'Approved'} = '';
    $Self->{Translation}->{'Last changed by'} = '';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = '';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = '';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = '';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = '';

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = '';

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'FAQ haku';
    $Self->{Translation}->{'Profile Selection'} = '';
    $Self->{Translation}->{'Vote'} = '';
    $Self->{Translation}->{'No vote settings'} = '';
    $Self->{Translation}->{'Specific votes'} = '';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = '';
    $Self->{Translation}->{'Rate'} = '';
    $Self->{Translation}->{'No rate settings'} = '';
    $Self->{Translation}->{'Specific rate'} = '';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = '';
    $Self->{Translation}->{'FAQ Article Create Time'} = '';
    $Self->{Translation}->{'Specific date'} = '';
    $Self->{Translation}->{'Date range'} = '';
    $Self->{Translation}->{'FAQ Article Change Time'} = '';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'FAQ-informaatio';
    $Self->{Translation}->{'Rating'} = 'Arvostelut';
    $Self->{Translation}->{'out of 5'} = '/ 5';
    $Self->{Translation}->{'No votes found!'} = 'Ei ääniä!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Ei annettuja ääniä! Äänestä tätä artikkelia ensimmäisenä.';
    $Self->{Translation}->{'Download Attachment'} = 'Lataa liitetiedosto';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        '';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        'Kuinka hyödyllinen tämä artikkeli oli? Arvostele artikkeli, jotta voimme kehittää FAQ-tietokantaamme. Kiitos!';
    $Self->{Translation}->{'not helpful'} = 'hyödytön';
    $Self->{Translation}->{'very helpful'} = 'hyödyllinen';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Add FAQ title to article subject'} = '';
    $Self->{Translation}->{'Insert FAQ Text'} = 'Lisää FAQ-teksti';
    $Self->{Translation}->{'Insert Full FAQ'} = '';
    $Self->{Translation}->{'Insert FAQ Link'} = 'Lisää FAQ-linkki';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'Lisää FAQ-teksti ja -linkki';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = '';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'Yhtään artikkelia ei löytynyt.';

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Hae artikkeleista (esim. "Matti*" tai "Meik*nen")';
    $Self->{Translation}->{'Vote restrictions'} = '';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = '';
    $Self->{Translation}->{'Rate restrictions'} = '';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = '';
    $Self->{Translation}->{'Only FAQ articles created'} = '';
    $Self->{Translation}->{'Only FAQ articles created between'} = '';
    $Self->{Translation}->{'Search-Profile as Template?'} = '';

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = '';
    $Self->{Translation}->{'Search for articles with keyword'} = '';

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = 'Julkinen';

    # Template: PublicFAQSearchResultShort
    $Self->{Translation}->{'Back to FAQ Explorer'} = '';

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} =
        '';
    $Self->{Translation}->{'CSS color for the voting result.'} = '';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = '';
    $Self->{Translation}->{'Category Management'} = 'Kategoriahallinta';
    $Self->{Translation}->{'Decimal places of the voting result.'} = '';
    $Self->{Translation}->{'Default category name.'} = '';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = '';
    $Self->{Translation}->{'Default maximum size of the titles in a FAQ article to be shown.'} =
        '';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        '';
    $Self->{Translation}->{'Default state for FAQ entry.'} = '';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} =
        '';
    $Self->{Translation}->{'Define if the FAQ title should be concatenated to article subject.'} =
        '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} =
        '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the customer interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the agent interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the customer interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the public interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default shown FAQ search attribute for FAQ search screen.'} =
        '';
    $Self->{Translation}->{'Defines the information to be inserted in a FAQ based Ticket. "Full FAQ" includes text, attachments and inline images.'} =
        '';
    $Self->{Translation}->{'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed.'} = '';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = '';
    $Self->{Translation}->{'Delete this FAQ'} = '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ add screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ edit screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
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
    $Self->{Translation}->{'Field4'} = '';
    $Self->{Translation}->{'Field5'} = '';
    $Self->{Translation}->{'Frontend module registration for the public interface.'} = '';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'History of this FAQ'} = '';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Interfaces where the quick search should be shown.'} = '';
    $Self->{Translation}->{'Journal'} = '';
    $Self->{Translation}->{'Language Management'} = 'Kielten hallinta';
    $Self->{Translation}->{'Link another object to this FAQ item'} = '';
    $Self->{Translation}->{'List of state types which can be used in the agent interface.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the customer interface.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the customer interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the customer interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ journal in the agent interface.'} =
        '';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the public interface.'} =
        '';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short faq search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search.'} =
        '';
    $Self->{Translation}->{'New FAQ Article'} = '';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the customer interface.'} =
        '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the public interface.'} =
        '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the customer interface.'} =
        '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the public interface.'} =
        '';
    $Self->{Translation}->{'Number of shown items in last changes.'} = '';
    $Self->{Translation}->{'Number of shown items in last created.'} = '';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = '';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} =
        '';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} =
        '';
    $Self->{Translation}->{'Print this FAQ'} = '';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = '';
    $Self->{Translation}->{'Search FAQ'} = '';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        '';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        '';
    $Self->{Translation}->{'Show "Insert FAQ Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        '';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" / "Insert Full FAQ & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        '';
    $Self->{Translation}->{'Show "Insert FAQ Text" / "Insert Full FAQ" Button in AgentFAQZoomSmall.'} =
        '';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = '';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = '';
    $Self->{Translation}->{'Show items of subcategories.'} = '';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'Ticket body for approval of FAQ article.'} = '';
    $Self->{Translation}->{'Ticket subject for approval of FAQ article.'} = '';

}

1;
