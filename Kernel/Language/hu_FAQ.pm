# --
# Kernel/Language/hu_FAQ.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: hu_FAQ.pm,v 1.1 2011-07-30 16:06:17 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::hu_FAQ;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAFAQ
    $Self->{Translation}->{'internal'} = 'belsõ';
    $Self->{Translation}->{'public'} = 'publikus';
    $Self->{Translation}->{'external'} = 'külsõ';
    $Self->{Translation}->{'FAQ Number'} = 'FAQ-sorszám';
    $Self->{Translation}->{'LatestChangedItems'} = 'Legutóbb változott elemek';
    $Self->{Translation}->{'LatestCreatedItems'} = 'Legutóbb létrehozott elemek';
    $Self->{Translation}->{'Top10Items'} = 'Top 10 elemek';
    $Self->{Translation}->{'SubCategoryOf'} = 'Alkategóriája';
    $Self->{Translation}->{'No rate selected!'} = 'Nincs értékelés kiválasztva!';
    $Self->{Translation}->{'public (all)'} = 'nyilvános (összes)';
    $Self->{Translation}->{'external (customer)'} = 'külsõ (ügyfél)';
    $Self->{Translation}->{'internal (agent)'} = 'belsõ (ügyintézõ)';
    $Self->{Translation}->{'StartDay'} = 'Kezdõ nap';
    $Self->{Translation}->{'StartMonth'} = 'Kezdõ hónap';
    $Self->{Translation}->{'StartYear'} = 'Kezdõ év';
    $Self->{Translation}->{'EndDay'} = 'Záró nap';
    $Self->{Translation}->{'EndMonth'} = 'Záró hónap';
    $Self->{Translation}->{'EndYear'} = 'Záró év';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Szavazatát köszönjük!';
    $Self->{Translation}->{'You have already voted!'} = 'Már szavazott!';
    $Self->{Translation}->{'FAQ Article Print'} = 'FAQ cikk nyomtatás';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'FAQ cikk (Top 10)';
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'FAQ cikk (új)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'FAQ cikk (változott)';
    $Self->{Translation}->{'FAQ category updated!'} = 'FAQ kategória módosult!';
    $Self->{Translation}->{'FAQ category added!'} = 'FAQ kategória hozzáadva!';
    $Self->{Translation}->{'A category should have a name!'} = 'Szükséges, hogy a kategóriát elnevezze!';
    $Self->{Translation}->{'This category already exists'} = 'A kategória már létezik!';
    $Self->{Translation}->{'FAQ language added!'} = 'FAQ nyelv hozzáadva!';
    $Self->{Translation}->{'FAQ language updated!'} = 'FAQ nyelv módosult!';
    $Self->{Translation}->{'The name is required!'} = 'A név szükséges!';
    $Self->{Translation}->{'This language already exists!'} = 'A nyelv már létezik!';

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'FAQ cikk hozzáadása';
    $Self->{Translation}->{'A category is required.'} = 'A kategória szükséges.';
    $Self->{Translation}->{'Approval'} = 'Jóváhagyás';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'FAQ kategória kezelés';
    $Self->{Translation}->{'Add category'} = 'Kategória hozzáadása';
    $Self->{Translation}->{'Delete Category'} = 'Kategória törlése';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Add Category'} = 'Kategória hozzáadása';
    $Self->{Translation}->{'Edit Category'} = 'Kategória szerkesztése';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'A böngészõben megjegyzésként fog megjelenni.';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Kérem, válasszon legalább egy jogosultság csoportot.';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Ügyintézõ csoport, amelyik hozzáfér a cikkekhez ebben a kategóriában.';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'Valóban törölni akarja a kategóriát?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} = 'A kategória nem törölhetõ. FAQ cikk használja vagy más kategória szülõje!';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'A kategória a következõ FAQ cikkeknél használt';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'A kategória a következõ kategóriák szülõje';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'Valóban törölni akarja ezt a FAQ cikket?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'FAQ-Böngészõ';
    $Self->{Translation}->{'Quick Search'} = 'Gyorskeresés';
    $Self->{Translation}->{'Advanced Search'} = 'Összetett keresés';
    $Self->{Translation}->{'Subcategories'} = 'Alkategória';
    $Self->{Translation}->{'FAQ Articles'} = 'FAQ cikk';
    $Self->{Translation}->{'No subcategories found.'} = 'Nincs alkategória.';

    # Template: AgentFAQHistory

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'Nincs FAQ-Journal adat.';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'FAQ nyelv kezelés';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languges.'} = 'Használja ezt a szolgáltatást, ha több nyelvvel szeretne dolgozni.';
    $Self->{Translation}->{'Add language'} = 'Nyelv hozzáadása';
    $Self->{Translation}->{'Delete Language'} = 'Nyelv törlése';
    $Self->{Translation}->{'Add Language'} = 'Nyelv hozzáadása';
    $Self->{Translation}->{'Edit Language'} = 'Nyelv szerkesztése';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'Valóban törölni szeretné ezt a nyelvet?';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} = 'A nyelv nem törölhetõ, legalább egy FAQ cikk használja!';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'Ez a nyelv használatban van a következõ FAQ cikknél';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Tartalom beállítások';
    $Self->{Translation}->{'FAQ articles per page'} = 'FAQ cikkek oldalanként';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'Nincs FAQ adat.';

    # Template: AgentFAQPrint
    $Self->{Translation}->{'FAQ-Info'} = 'FAQ-infó';
    $Self->{Translation}->{'Votes'} = 'Szavazatok';

    # Template: AgentFAQSearch

    # Template: AgentFAQSearchOpenSearchDescriptionFAQNumber

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'FAQ teljes szöveg';

    # Template: AgentFAQSearchResultPrint

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'FAQ keresés';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'FAQ információ';
    $Self->{Translation}->{'Rating'} = 'Értékelés';
    $Self->{Translation}->{'Rating %'} = 'Értékelés %';
    $Self->{Translation}->{'out of 5'} = '5-bõl';
    $Self->{Translation}->{'No votes found!'} = 'Nincs szavazat!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Nincs szavazat! Legyen az elsõ, aki értékeli a FAQ cikket.';
    $Self->{Translation}->{'Download Attachment'} = 'Melléklet letöltése';
    $Self->{Translation}->{'ArticleVotingQuestion'} = 'ArticleVotingQuestion';
    $Self->{Translation}->{'not helpful'} = 'nem segít';
    $Self->{Translation}->{'very helpful'} = 'nagyon segít';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Insert FAQ Text'} = 'FAQ szöveg beírása';
    $Self->{Translation}->{'Insert FAQ Link'} = 'FAQ link beírása';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'FAQ szöveg és link beírása';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'Nem található FAQ cikk.';

    # Template: CustomerFAQPrint

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Teljes szöveges keresés a FAQ cikkekben (pl. "J*nos" or "Kov*")';

    # Template: CustomerFAQSearchOpenSearchDescription

    # Template: CustomerFAQSearchResultPrint

    # Template: CustomerFAQSearchResultShort

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Details'} = 'Részletek';
    $Self->{Translation}->{'Search for articles with keyword'} = 'Cikkek keresése kulcsszavakkal';

    # Template: PublicFAQExplorer

    # Template: PublicFAQPrint

    # Template: PublicFAQSearch

    # Template: PublicFAQSearchOpenSearchDescription
    $Self->{Translation}->{'Public'} = 'Nyilvános';

    # Template: PublicFAQSearchResultPrint

    # Template: PublicFAQSearchResultShort

    # Template: PublicFAQZoom

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} = 'Egy szûrõ a HTML kimenethez, hogy hozzáadjon linkeket a definiált szövegekhez. Az Image elem kétféle bemenetet enged. A kép neve az elsõ (pl. faq.png). Ebben az esetben az OTRS képek útvonala kerül felhasználásra. A második lehetõség a képre mutató link belillesztése.';
    $Self->{Translation}->{'CSS color for the voting result.'} = 'CSS szinek a szavazás eredményéhez.';
    $Self->{Translation}->{'Category Management'} = 'Kategóriakezelés';
    $Self->{Translation}->{'Decimal places of the voting result.'} = 'A szavazási eredmény tizedesjegyeinek száma.';
    $Self->{Translation}->{'Default category name.'} = 'Alapértelmezett kategória neve.';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = 'Egynyelvû mód esetén a FAQ cikkek alapértelmezett nyelve.';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} = 'FAQ cikkek jóváhagyásához a jegyek alapértelmezett prioritása.';
    $Self->{Translation}->{'Default state for FAQ entry.'} = 'A FAQ cikk alapértelmezett állapota.';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'FAQ cikkek jóváhagyásához a jegyek alapértelmezett állapota.';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} = 'A public frontend Action parameterének alapértelmezett értéke. Az Action parameter a rendszer sciprt-jeiben kerül felhasználásra.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} = 'Egy áttekintõ modult definiál a FAQ journal kicsi nézetének megmutatásához.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} = 'Egy áttekintõ modult definiál a FAQ lista kicsi nézetének megmutatásához.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} = 'Az alapértelmezett FAQ attribútumokat definiálja a FAQ rendezéshez az ügyintézõ felületén a FAQ keresésnél.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} = 'Az alapértelmezett FAQ attribútumokat definiálja a FAQ rendezéshez az ügyfél felületén a FAQ keresésnél.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} = 'Az alapértelmezett FAQ attribútumokat definiálja a FAQ rendezéshez a nyilvános felületen a FAQ keresésnél.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the agent interface.'} = 'Az alapértelmezett FAQ attribútumokat definiálja a FAQ rendezéshez az ügyintézõ felületén a FAQ böngészõnél.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the customer interface.'} = 'Az alapértelmezett FAQ attribútumokat definiálja a FAQ rendezéshez az ügyfél felületén a FAQ böngészõnél.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} = 'Az alapértelmezett FAQ attribútumokat definiálja a FAQ rendezéshez a nyilvános felületen a FAQ böngészõnél.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the agent interface. Up: oldest on top. Down: latest on top.'} = 'Az alapértelmezett FAQ sorrendet definiálja a FAQ böngészõben az ügyintézõ felületén. Up: régebbiek felül, Down: legfrissebb felül.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the customer interface. Up: oldest on top. Down: latest on top.'} = 'Az alapértelmezett FAQ sorrendet definiálja a FAQ böngészõben az ügyfél felületén. Up: régebbiek felül, Down: legfrissebb felül.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the public interface. Up: oldest on top. Down: latest on top.'} = 'Az alapértelmezett FAQ sorrendet definiálja a FAQ böngészõben a nyilvános felületen. Up: régebbiek felül, Down: legfrissebb felül.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} = 'Az alapértelmezett FAQ sorrendet definiálja a keresésnél az ügyintézõ felületén. Up: régebbiek felül, Down: legfrissebb felül.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} = 'Az alapértelmezett FAQ sorrendet definiálja a keresésnél az ügyfél felületén. Up: régebbiek felül, Down: legfrissebb felül.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} = 'Az alapértelmezett FAQ sorrendet definiálja a keresésnél a nyilvános felületen. Up: régebbiek felül, Down: legfrisesbb felül.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} = 'A FAQ böngészõben látható oszlopokat definiálja. A paraméter nincs hatással az oszlop pozíciójára.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} = 'A FAQ journal-ban látható oszlopokat definiálja. A paraméter nincs hatással az oszlop pozíciójára.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} = 'A FAQ keresésnél látható oszlopokat definiálja. A paraméter nincs hatással az oszlop pozíciójára.';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed. Note: AgentTicketActionCommon includes AgentTicketNote, AgentTicketClose, AgentTicketFreeText, AgentTicketOwner, AgentTicketPending, AgentTicketPriority and AgentTicketResponsible.'} = 'Definiálja, hogy a \'Insert FAQ\' link hol látható. Megjegyzés: AgentTicketActionCommon tartalmazza az AgentTicketNote, AgentTicketClose, AgentTicketFreeText, AgentTicketOwner, AgentTicketPending, AgentTicketPriority és  AgentTicketResponsible.';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = 'A FAQ cikk szabad-szöveges mezõjét definiálja.';
    $Self->{Translation}->{'Delete this FAQ'} = 'Töröld ezt a FAQ-t';
    $Self->{Translation}->{'Edit this FAQ'} = 'Szerkeszd ezt a FAQ-t';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = 'Több nyelv használatát engedélyezi a FAQ modulban.';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = 'A szavazás engedélyezése a FAQ modulban.';
    $Self->{Translation}->{'FAQ Journal'} = 'FAQ Journal';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = 'FAQ Journal áttekintõ "kicsi nézet" limit';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = 'FAQ áttekintõ "Kicsi nézet" limit';
    $Self->{Translation}->{'FAQ limit per page for FAQ Journal Overview "Small"'} = 'FAQ limit oldalanként a FAQ Journal áttekintõ "kicsi nézetéhez"';
    $Self->{Translation}->{'FAQ limit per page for FAQ Overview "Small"'} = 'FAQ limit oldalanként a FAQ  áttekintõ "kicsi nézetéhez"';
    $Self->{Translation}->{'FAQ path separator.'} = 'FAQ útvonal elválasztó.';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = 'FAQ search backend router of the agent interface.';
    $Self->{Translation}->{'FAQ-Area'} = 'FAQ-terület';
    $Self->{Translation}->{'Frontend module registration for the public interface.'} = 'A nyilvános interface frontend module regisztrációja.';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = 'Csoport a FAQ cikk jóváhagyáshoz.';
    $Self->{Translation}->{'History of this FAQ'} = 'FAQ története';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = 'Belsõ mezõket tartalmaz a FAQ alapú jegyekhez.';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = 'Minden mezõ nevét tartalmazza a FAQ alapú jegyekben.';
    $Self->{Translation}->{'Interfaces where the quicksearch should be shown.'} = 'Felület, ahol a gyorskeresés látható.';
    $Self->{Translation}->{'Journal'} = 'Journal';
    $Self->{Translation}->{'Language Management'} = 'Nyelvek kezelése';
    $Self->{Translation}->{'Languagekey which is defined in the language file *_FAQ.pm.'} = 'A *_FAQ.pm fájlban definiált nyelv kulcsa.';
    $Self->{Translation}->{'Link another object to this FAQ item'} = 'A FAQ elemben más objektumra való hivatkozás.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the agent interface.'} = 'A megjelenõ FAQ cikkek maximális száma a FAQ böngészõ ügyintézõ felületén.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the customer interface.'} = 'A megjelenõ FAQ cikkek maximális száma a FAQ böngészõ ügyfél felületén.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the public interface.'} = 'A megjelenõ FAQ cikkek maximális száma a FAQ böngészõ nyilvános felületén.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} = 'A megjelenõ FAQ cikkek maximális száma a FAQ journal ügyintézõ felületén.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} = 'A megjelenõ FAQ cikkek maximális száma a keresésnél az ügyintézõ felületén.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} = 'A megjelenõ FAQ cikkek maximális száma a keresésnél az ügyfél felületén.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} = 'A megjelenõ FAQ cikkek maximális száma a keresésnél a nyilvános felületen.';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search.'} = 'Modul html OpenSearch profile létrehozásához rövid FAQ keresésnél.';
    $Self->{Translation}->{'New FAQ Article'} = 'Új FAQ cikk';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = 'Az új FAQ cikk jóváhagyása szükséges a publikálás elõtt.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the customer interface.'} = 'A megjelenõ FAQ cikkek száma a FAQ böngészõ ügyintézõ felületén.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the public interface.'} = 'A megjelenõ FAQ cikkek száma a FAQ böngészõ nyilvános felületén.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the customer interface.'} = 'A megjelenõ FAQ cikkek száma minden lapon a keresésnél az ügyfél felületén.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the public interface.'} = 'A megjelenõ FAQ cikkek száma minden lapon a keresésnél a nyilvános felületen.';
    $Self->{Translation}->{'Number of shown items in last changes.'} = 'A megjelenõ elemek száma az utolsó  módosultaknál.';
    $Self->{Translation}->{'Number of shown items in last created.'} = 'A megjelenõ elemek száma az utolsó létrehozottaknál.';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = 'A megjelenõ elemek száma a TOP10-nél.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} = 'Paraméterek a lapokhoz (amelyeken a FAQ elemek megjelennek) a kicsi FAQ journal áttekintésénél.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} = 'Paraméterek a lapokhoz (amelyeken a FAQ elemek megjelennek) a kicsi FAQ áttekintésénél.';
    $Self->{Translation}->{'Print this FAQ'} = 'Nyomtasd ezt a FAQ-t';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = 'Várólista a FAQ cikkek jóváhagyásához';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = 'Értékek a szavazáshoz. A kulcs százalék kell legyen!';
    $Self->{Translation}->{'Search FAQ'} = 'FAQ keresés';
    $Self->{Translation}->{'Show "Insert FAQ Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} = 'Megmutatja a "FAQ link beszúrás" gombot az AgentFAQZoomSmall a nyilvános FAQ cikkekhez.';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} = 'Megmutatja a "FAQ link és szöveg beszúrás" gombot az AgentFAQZoomSmall a nyilvános FAQ cikkekhez.';
    $Self->{Translation}->{'Show "Insert FAQ Text" Button in AgentFAQZoomSmall.'} = 'Megmutatja a "FAQ szöveg beszúrás" gombot az AgentFAQZoomSmall.';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = 'FAQ cikk megjelenítése HTML-ben';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = 'FAQ útvonal megjelenítése igen/nem.';
    $Self->{Translation}->{'Show WYSIWYG editor in agent interface.'} = 'WYSIWYG editor megjelenítése az ügyintézõ felületén.';
    $Self->{Translation}->{'Show items of subcategories.'} = 'Az alkategória elemeinek megjelenítése';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = 'Az utolsó módosított elemek megjelenítése a definiált felületen.';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = 'Az utolsó létrehozott elemek megjelenítése a definiált felületen.';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = 'A TOP 10 elemek megjelenítése a definiált felületen.';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = 'Szavazás megjelenítése a definiált felületen.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'} = 'Link megjelenítése a menüben ami engedi a FAQ linkelését más objektumokkal a FAQ részleteinél az ügyintézõ felületén.';
    $Self->{Translation}->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'} = 'Link megjelenítése a menüben ami engedi a FAQ törlését a FAQ részleteinél az ügyintézõ felületén.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface.'} = 'Link megjelenítése a menüben ami eléri a FAQ történetét a FAQ részleteinél az ügyintézõ felületén.';
    $Self->{Translation}->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'} = 'Link megjelenítése a menüben ami engedi a FAQ szerkesztését a FAQ részleteinél az ügyintézõ felületén.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'} = 'Link megjelenítése a menüben ami engedi a visszalépést a FAQ részleteinél az ügyintézõ felületén.';
    $Self->{Translation}->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'} = 'Link megjelenítése a menüben ami engedi a FAQ nyomtatását a FAQ részleteinél az ügyintézõ felületén.';
    $Self->{Translation}->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'} = 'A FAQ azonosítója, pl. FAQ#, KB#, MyFAQ#. Az alapértelmezett: FAQ#.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'} = 'Ez a beállítás definiálja, hogy a \'FAQ\' objektum összekapcsolható más \'FAQ\' objektummal \'Normal\' link típus használatával.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'} = 'Ez a beállítás definiálja, hogy a \'FAQ\' objektum összekapcsolható más \'FAQ\' objektummal \'ParentChild\' link típus használatával.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'} = 'Ez a beállítás definiálja, hogy a \'FAQ\' objektum összekapcsolható más \'Jegy\' objektummal \'Normal\' link típus használatával.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'} = 'Ez a beállítás definiálja, hogy a \'FAQ\' objektum összekapcsolható más \'Jegy\' objektummal \'ParentChild\' link típus használatával.';
    $Self->{Translation}->{'Ticket body for approval of FAQ article.'} = 'Jegy törzse a FAQ cikk jóváhagyásához.';
    $Self->{Translation}->{'Ticket subject for approval of FAQ article.'} = 'Jegy tárgya a FAQ cikk jóváhagyásához.';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ Explorer of the agent interface.'} = 'Definiert das Standard-FAQ-Attribut für die Sortierung des FAQ-Explorers im Agenten-Interface.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the explorer in the customer interface.'} = 'Definiert das Standard-FAQ-Attribut für die Sortierung des FAQ-Explorers im Kunden-Interface.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the explorer in the public interface.'} = 'Definiert das Standard-FAQ-Attribut für die Sortierung des FAQ-Explorers im Public-Interface.';
    $Self->{Translation}->{'Defines the default FAQ order in the explorer in the customer interface. Up: oldest on top. Down: latest on top.'} = 'Definiert die Standard-Sortierung des FAQ-Explorers im Kunden-Interface. Auf: Ältester FAQ-Artikel oben. Ab: Neuester FAQ-Artikel oben.';
    $Self->{Translation}->{'Defines the default FAQ order in the explorer in the public interface. Up: oldest on top. Down: latest on top.'} = 'Definiert die Standard-Sortierung des FAQ-Explorers im Public-Interface. Auf: Ältester FAQ-Artikel oben. Ab: Neuester FAQ-Artikel oben.';
    $Self->{Translation}->{'Defines the default FAQ order of a Explorer result in the agent interface. Up: oldest on top. Down: latest on top.'} = 'Definiert die Standard-Sortierung des FAQ-Explorers im Agenten-Interface. Auf: Ältester FAQ-Artikel oben. Ab: Neuester FAQ-Artikel oben.';
    $Self->{Translation}->{'Delete: '} = 'Löschen: ';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the explorer in the customer interface.'} = 'Maximale Anzahl von FAQ-Artikeln die im FAQ-Explorer im Kunden-Interface angezeigt werden.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the explorer in the public interface.'} = 'Maximale Anzahl von FAQ-Artikeln die im FAQ-Explorer im Public-Interface angezeigt werden.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a Explorer in the agent interface.'} = 'Maximale Anzahl von FAQ-Artikeln die im FAQ-Explorer im Agenten-Interface angezeigt werden.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in each page of a search result in the customer interface.'} = 'Anzahl von FAQ-Artikeln die in der FAQ-Suche im Kunden-Interface pro Seite angezeigt werden.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in each page of a search result in the public interface.'} = 'Anzahl von FAQ-Artikeln die in der FAQ-Suche im Public-Interface pro Seite angezeigt werden.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the explorer in the customer interface.'} = 'Anzahl von FAQ-Artikeln die im FAQ-Explorer im Kunden-Interface angezeigt werden.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the explorer in the public interface.'} = 'Anzahl von FAQ-Artikeln die im FAQ-Explorer im Public-Interface angezeigt werden.';
    $Self->{Translation}->{'Show "Insert Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} = 'Zeige "Link Einfügen"-Button in AgentFAQZoomSmall für öffentliche FAQ-Artikel.';
    $Self->{Translation}->{'Show "Insert Text & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} = 'Zeige "Text & Link Einfügen"-Button in AgentFAQZoomSmall für öffentliche FAQ-Artikel.';
    $Self->{Translation}->{'Show "Insert Text" Button in AgentFAQZoomSmall.'} = 'Zeige "Text Einfügen"-Button in AgentFAQZoomSmall für öffentliche FAQ-Artikel.';

}

1;
