# --
# Kernel/Language/sv_FAQ.pm - translation file
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::sv_FAQ;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAFAQ
    $Self->{Translation}->{'internal'} = 'intern';
    $Self->{Translation}->{'public'} = 'offentlig';
    $Self->{Translation}->{'external'} = 'extern';
    $Self->{Translation}->{'FAQ Number'} = 'FAQ-nummer';
    $Self->{Translation}->{'Latest updated FAQ articles'} = 'Senast uppdaterade FAQ-artiklar';
    $Self->{Translation}->{'Latest created FAQ articles'} = 'Senast skapade FAQ-artiklar';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Topp 10 FAQ-artiklar';
    $Self->{Translation}->{'Subcategory of'} = 'Underkategori till';
    $Self->{Translation}->{'No rate selected!'} = '';
    $Self->{Translation}->{'Explorer'} = 'Utforskare';
    $Self->{Translation}->{'public (all)'} = 'offentlig (alla)';
    $Self->{Translation}->{'external (customer)'} = 'extern (kunder)';
    $Self->{Translation}->{'internal (agent)'} = 'intern (agent)';
    $Self->{Translation}->{'Start day'} = 'Start dag';
    $Self->{Translation}->{'Start month'} = 'Start månad';
    $Self->{Translation}->{'Start year'} = 'Start år';
    $Self->{Translation}->{'End day'} = 'Slut dag';
    $Self->{Translation}->{'End month'} = 'Slut månad';
    $Self->{Translation}->{'End year'} = 'Slut år';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Tack för din röst!';
    $Self->{Translation}->{'You have already voted!'} = 'Du har redan röstat!';
    $Self->{Translation}->{'FAQ Article Print'} = 'FAQ-artikel utskrift';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'FAQ-artiklar (Topp 10)';
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'FAQ-artiklar (nyligen skapad)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'FAQ-artiklar (nyligen ändrade)';
    $Self->{Translation}->{'FAQ category updated!'} = 'FAQ-kategori uppdaterad!';
    $Self->{Translation}->{'FAQ category added!'} = 'FAQ-kategori tillagd!';
    $Self->{Translation}->{'A category should have a name!'} = 'En kategori behöver ett namn!';
    $Self->{Translation}->{'This category already exists'} = 'Denna kategori finns redan!';
    $Self->{Translation}->{'FAQ language added!'} = 'FAQ-språk skapat!';
    $Self->{Translation}->{'FAQ language updated!'} = 'FAQ-språk uppdaterat!';
    $Self->{Translation}->{'The name is required!'} = 'Namn krävs!';
    $Self->{Translation}->{'This language already exists!'} = 'Detta språk finns redan!';
    $Self->{Translation}->{'Symptom'} = '';
    $Self->{Translation}->{'Solution'} = 'Lösning';

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'Skapa FAQ artikel';
    $Self->{Translation}->{'Keywords'} = 'Nyckelord';
    $Self->{Translation}->{'A category is required.'} = 'En kategori krävs.';
    $Self->{Translation}->{'Approval'} = 'Godkännande';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'FAQ kategorihantering';
    $Self->{Translation}->{'Add category'} = 'Skapa kategori';
    $Self->{Translation}->{'Delete Category'} = 'Ta bort kategori';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Add Category'} = 'Skapa kategori';
    $Self->{Translation}->{'Edit Category'} = 'Redigera kategori';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Vänligen välj minst en rättighetsgrupp';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Agent-grupper med åtkomst till artiklarna i denna kategori.';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Visas som kommentar i Utforskaren.';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'Vill du verkligen ta bort denna kategori?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        '';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = '';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = '';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'Vill du verkligen ta bort denna FAQ-artikel?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'FAQ-utforskare';
    $Self->{Translation}->{'Quick Search'} = 'Snabbsök';
    $Self->{Translation}->{'Wildcards are allowed.'} = 'Jokertecken är tillåtna.';
    $Self->{Translation}->{'Advanced Search'} = 'Avancerad sökning';
    $Self->{Translation}->{'Subcategories'} = 'Underkategorier';
    $Self->{Translation}->{'FAQ Articles'} = 'FAQ-artiklar';
    $Self->{Translation}->{'No subcategories found.'} = 'Inga underkategorier hittades.';

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = '';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'FAQ språkhantering';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languges.'} =
        'Använd den här funktionen om du vill arbeta med flera språk.';
    $Self->{Translation}->{'Add language'} = 'Lägg till språk';
    $Self->{Translation}->{'Delete Language %s'} = 'Ta bort språk %s';
    $Self->{Translation}->{'Add Language'} = 'Lägg till språk';
    $Self->{Translation}->{'Edit Language'} = 'Redigera språk';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'Vill du verkligen ta bort detta språk?';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        'Du kan inte ta bort detta språk. Det används i minst en FAQ-artikel!';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = '';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Anpassa vy';
    $Self->{Translation}->{'FAQ articles per page'} = 'FAQ-artiklar per sida';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'Ingen FAQ-information hittades.';

    # Template: AgentFAQPrint
    $Self->{Translation}->{'FAQ-Info'} = 'FAQ-information';
    $Self->{Translation}->{'Votes'} = 'Röster';
    $Self->{Translation}->{'Last update'} = 'Senast uppdaterad';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = 'Nyckelord';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = '';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = '';
    $Self->{Translation}->{'Approved'} = 'Godkänd';
    $Self->{Translation}->{'Last changed by'} = 'Senast ändrad av';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = '';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = '';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = '';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = '';

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = '';

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'FAQ sök';
    $Self->{Translation}->{'Profile Selection'} = '';
    $Self->{Translation}->{'Vote'} = 'Rösta';
    $Self->{Translation}->{'No vote settings'} = 'Inga röstinställningar';
    $Self->{Translation}->{'Specific votes'} = 'Specifika röster';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = 'e.g. Lika med 10 eller StörreÄn 60';
    $Self->{Translation}->{'Rate'} = 'Betygsätt';
    $Self->{Translation}->{'No rate settings'} = 'Inga betygsinställningar';
    $Self->{Translation}->{'Specific rate'} = 'Specifikt betyg';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = 'e.g. Lika med 25% eller StörreÄn 75%';
    $Self->{Translation}->{'FAQ Article Create Time'} = '';
    $Self->{Translation}->{'Specific date'} = 'Specifikt datum';
    $Self->{Translation}->{'Date range'} = 'Datumintervall';
    $Self->{Translation}->{'FAQ Article Change Time'} = 'FAQ artikel ändringstidpunkt';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'FAQ-Information';
    $Self->{Translation}->{'Rating'} = 'Betyg';
    $Self->{Translation}->{'out of 5'} = 'av 5';
    $Self->{Translation}->{'No votes found!'} = 'Inga röster funna!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Inga röster funna! Bli den första att betygsätta denna FAQ-artikel.';
    $Self->{Translation}->{'Download Attachment'} = 'Ladda ner bilaga';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        '';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        'Hur hjälpsam var den här artikeln? Vänligen ge oss ditt betyg och hjälp oss förbättra FAQ-databasen. Tack!';
    $Self->{Translation}->{'not helpful'} = 'inte hjälpsam';
    $Self->{Translation}->{'very helpful'} = 'väldigt hjälpsam';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Add FAQ title to article subject'} = 'Lägg till FAQ-titeln till artikelns ämne';
    $Self->{Translation}->{'Insert FAQ Text'} = 'Klistra in FAQ-text';
    $Self->{Translation}->{'Insert Full FAQ'} = 'Klistra in fullständig FAQ';
    $Self->{Translation}->{'Insert FAQ Link'} = 'Klistra in länk till FAQ';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'Klistra in FAQ-text & länk';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = 'Klistra in fullständig FAQ & länk';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'Inga FAQ artiklar funna.';

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Fulltext-sök i FAQ-artiklar (e. g. "John*n" eller "Will*")';
    $Self->{Translation}->{'Vote restrictions'} = 'Röst-restriktioner';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = 'Endast FAQ artiklar med röster...';
    $Self->{Translation}->{'Rate restrictions'} = 'Betygs-restriktioner';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = 'Endast FAQ artiklar med betyg...';
    $Self->{Translation}->{'Only FAQ articles created'} = 'Endast FAQ artiklar skapade';
    $Self->{Translation}->{'Only FAQ articles created between'} = 'Endast FAQ artiklar skapade mellan';
    $Self->{Translation}->{'Search-Profile as Template?'} = 'Sök-profil som mall?';

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = 'Artikelnummer';
    $Self->{Translation}->{'Search for articles with keyword'} = 'Sök efter artiklar med nyckelord';

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = 'Offentlig';

    # Template: PublicFAQSearchResultShort
    $Self->{Translation}->{'Back to FAQ Explorer'} = 'Tillbaka till FAQ-utforskaren';

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} =
        '';
    $Self->{Translation}->{'CSS color for the voting result.'} = '';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = '';
    $Self->{Translation}->{'Category Management'} = 'Kategorihantering';
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
    $Self->{Translation}->{'Delete this FAQ'} = 'Radera denna FAQ';
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
    $Self->{Translation}->{'Edit this FAQ'} = 'Redigera FAQ';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = '';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = '';
    $Self->{Translation}->{'FAQ Journal'} = 'FAQ Journal';
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
    $Self->{Translation}->{'History of this FAQ'} = 'FAQ-historik';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Interfaces where the quick search should be shown.'} = '';
    $Self->{Translation}->{'Journal'} = 'Journal';
    $Self->{Translation}->{'Language Management'} = 'Språkhantering';
    $Self->{Translation}->{'Link another object to this FAQ item'} = 'Länka ett annat objekt till denna FAQ-artikel';
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
    $Self->{Translation}->{'New FAQ Article'} = 'Ny FAQ-Artikel';
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
    $Self->{Translation}->{'Print this FAQ'} = 'Skriv ut FAQ';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = 'Kö för godkännande av FAQ-artiklar.';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = '';
    $Self->{Translation}->{'Search FAQ'} = 'Sök FAQ';
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
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = 'Visa FAQ-artikel med HTML.';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = 'Visa FAQ sökväg ja/nej.';
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
