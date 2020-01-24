# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sr_Latn_FAQ;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'Dodaj FAQ članak';
    $Self->{Translation}->{'Keywords'} = 'Ključne reči';
    $Self->{Translation}->{'A category is required.'} = 'Kategorija je obavezna.';
    $Self->{Translation}->{'Approval'} = 'Odobrenje';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'Upravljanje FAQ kategorijama';
    $Self->{Translation}->{'Add FAQ Category'} = 'Dodaj FAQ kategoriju';
    $Self->{Translation}->{'Edit FAQ Category'} = 'Uredi FAQ kategoriju';
    $Self->{Translation}->{'Add category'} = 'Dodaj kategoriju';
    $Self->{Translation}->{'Add Category'} = 'Dodaj kategoriju';
    $Self->{Translation}->{'Edit Category'} = 'Uredi kategoriju';
    $Self->{Translation}->{'Subcategory of'} = 'Podkategorija od';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Molimo da izaberete bar jednu grupu dozvola.';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Grupe operatera koje mogu pristupiti člancima u ovoj kategoriji.';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Biće prikazano kao komentar u Istraživaču.';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'Da li stvarno želite da obrišete ovu kategoriju?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        'Ne možete obrisati ovu kategoriju. Upotrebljena je u bar jednom FAQ članku i/ili je nadređena najmanje jednoj drugoj kategoriji';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'Ova kategorija je upotrebljena u sledećim FAQ člancima';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'Ova kategorija je nadređena sledećim podkategorijama';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'Da li stvarno želite da obrišete ovaj FAQ članak?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'FAQ pretraživač';
    $Self->{Translation}->{'Quick Search'} = 'Brzo traženje';
    $Self->{Translation}->{'Wildcards are allowed.'} = 'Džokerski znaci su dozvoljeni.';
    $Self->{Translation}->{'Advanced Search'} = 'Napredna pretraga';
    $Self->{Translation}->{'Subcategories'} = 'Podkategorije';
    $Self->{Translation}->{'FAQ Articles'} = 'FAQ članci';
    $Self->{Translation}->{'No subcategories found.'} = 'Podkategorije nisu pronađene.';

    # Template: AgentFAQHistory
    $Self->{Translation}->{'History of'} = 'Istorija od';
    $Self->{Translation}->{'History Content'} = 'Sadržaj istorije';
    $Self->{Translation}->{'Createtime'} = 'Vreme kreiranja';

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'Nisu pronađeni podaci FAQ dnevnika.';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'Upravljanje FAQ jezicima';
    $Self->{Translation}->{'Add FAQ Language'} = 'Dodaj FAQ jezik';
    $Self->{Translation}->{'Edit FAQ Language'} = 'Uredi FAQ jezik';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languages.'} =
        'Upotrebite ovu funkciju ako želite da koristite više jezika.';
    $Self->{Translation}->{'Add language'} = 'Dodaj jezik';
    $Self->{Translation}->{'Add Language'} = 'Dodaj Jezik';
    $Self->{Translation}->{'Edit Language'} = 'Uredi Jezik';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'Da li zaista želite da izbrišete ovaj jezik?';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        'Ne možete obrisati ovaj jezik. Upotrebljen je u bar jednom FAQ članku!';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'Ovaj jezik je upotrebljen u sledećim FAQ člancima';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Podešavanje konteksta';
    $Self->{Translation}->{'FAQ articles per page'} = 'FAQ članaka po strani';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'Nisu pronađeni FAQ podaci.';

    # Template: AgentFAQRelatedArticles
    $Self->{Translation}->{'out of 5'} = 'od 5';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = 'Ključna reč';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = 'Glasaj (npr jednako 10 ili veće od 60)';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = 'Oceni (npr jednako 25% ili veće od 75%)';
    $Self->{Translation}->{'Approved'} = 'Odobreno';
    $Self->{Translation}->{'Last changed by'} = 'Poslednji je menjao';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = 'Vreme kreiranja FAQ članka (pre/posle)';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = 'Vreme kreiranja FAQ članka (između)';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = 'Vreme promene FAQ članka (pre/posle)';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = 'Vreme promene FAQ članka (između)';

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'FAQ tekst';

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'FAQ pretraga';
    $Self->{Translation}->{'Profile Selection'} = 'Izbor profila';
    $Self->{Translation}->{'Vote'} = 'Glas';
    $Self->{Translation}->{'No vote settings'} = 'Nema podešavanja za glasanje';
    $Self->{Translation}->{'Specific votes'} = 'Specifični glasovi';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = 'npr jednako 10 ili veće od 60';
    $Self->{Translation}->{'Rate'} = 'Ocena';
    $Self->{Translation}->{'No rate settings'} = 'Nema podešavanja za ocenjivanje';
    $Self->{Translation}->{'Specific rate'} = 'Specifična ocena';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = 'npr jednako 25% ili veće od 75%';
    $Self->{Translation}->{'FAQ Article Create Time'} = 'Vreme kreiranja FAQ članka';
    $Self->{Translation}->{'FAQ Article Change Time'} = 'Vreme promene FAQ članka';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'FAQ informacija';
    $Self->{Translation}->{'Rating'} = 'Ocenjivanje';
    $Self->{Translation}->{'Votes'} = 'Glasovi';
    $Self->{Translation}->{'No votes found!'} = 'Glasovi nisu pronađeni!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Glasovi nisu pronađeni! Budite prvi koji će oceniti ovaj FAQ članak.';
    $Self->{Translation}->{'Download Attachment'} = 'Preuzmi prilog';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Da biste otvorili veze u sledećim blokovima opisa, možda ćete trebati da pritisnete „Ctrl” ili „Cmd” ili „Shift” taster dok istovremeno kliknete na vezu (zavisi od vašeg OS i pregledača).';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        'Koliko je koristan ovaj članak? Molimo vas da date vašu ocenu i pomognete podizanju kvalitata baze često postavljanih pitanja. Hvala Vam! ';
    $Self->{Translation}->{'not helpful'} = 'nije korisno';
    $Self->{Translation}->{'very helpful'} = 'vrlo korisno';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Add FAQ title to article subject'} = 'Dodaj naslov FAQ članku';
    $Self->{Translation}->{'Insert FAQ Text'} = 'Unesi FAQ tekst';
    $Self->{Translation}->{'Insert Full FAQ'} = 'Unesi kompletan FAQ';
    $Self->{Translation}->{'Insert FAQ Link'} = 'Unesi FAQ vezu';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'Unesi FAQ tekst i vezu';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = 'Unesi kompletan FAQ i vezu';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'Nisu pronađeni FAQ članci.';

    # Template: CustomerFAQRelatedArticles
    $Self->{Translation}->{'This might be helpful'} = 'Ovo može da bude od pomoći';
    $Self->{Translation}->{'Found no helpful resources for the subject and text.'} = 'Korisni resursi za uneti predmet i tekst nisu pronađeni.';
    $Self->{Translation}->{'Type a subject or text to get a list of helpful resources.'} = 'Za listu korisnih resursa, molimo unesite predmet ili tekst.';

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Potpuna tekstualna pretraga u FAQ člancima (npr. "John*n" ili "Will*")';
    $Self->{Translation}->{'Vote restrictions'} = 'Ograničenja glasanja';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = 'Samo FAQ članci sa glasovima...';
    $Self->{Translation}->{'Rate restrictions'} = 'Ograničenja ocenjivanja';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = 'Samo FAQ članci sa ocenom...';
    $Self->{Translation}->{'Time restrictions'} = 'Vremenska ograničenja';
    $Self->{Translation}->{'Only FAQ articles created'} = 'Samo FAQ članci kreirani';
    $Self->{Translation}->{'Only FAQ articles created between'} = 'Samo FAQ članci kreirani između';
    $Self->{Translation}->{'Search-Profile as Template?'} = 'Profil pretrage kao šablon?';

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = 'Broj članka';
    $Self->{Translation}->{'Search for articles with keyword'} = 'Traži članke sa ključnom reči';

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = 'Javno';

    # Template: PublicFAQSearchResultShort
    $Self->{Translation}->{'Back to FAQ Explorer'} = 'Nazad na FAQ pretraživač';

    # Perl Module: Kernel/Modules/AgentFAQAdd.pm
    $Self->{Translation}->{'You need rw permission!'} = 'Potrebna vam je „rw” dozvola!';
    $Self->{Translation}->{'No categories found where user has read/write permissions!'} = 'Kategorije u kojoj korisnik ima pristup bez ograničenja nisu pronađene!';
    $Self->{Translation}->{'No default language found and can\'t create a new one.'} = 'Nije pronađen podrazumevani jezik i ne može se kreirati nov.';

    # Perl Module: Kernel/Modules/AgentFAQCategory.pm
    $Self->{Translation}->{'Need CategoryID!'} = 'Potreban ID Kategorije!';
    $Self->{Translation}->{'A category should have a name!'} = 'Kategorija treba da ima ime!';
    $Self->{Translation}->{'This category already exists'} = 'Ova kategorija već postoji';
    $Self->{Translation}->{'This category already exists!'} = 'Ova kategorija već postoji!';
    $Self->{Translation}->{'No CategoryID is given!'} = 'Nije dat ID Kategorije!';
    $Self->{Translation}->{'Was not able to delete the category %s!'} = 'Nije bilo moguće obrisati kategoriju %s!';
    $Self->{Translation}->{'FAQ category updated!'} = 'FAQ kategorija ažurirana!';
    $Self->{Translation}->{'FAQ category added!'} = 'FAQ kategorija dodata!';
    $Self->{Translation}->{'Delete Category'} = 'Obriši kategoriju';

    # Perl Module: Kernel/Modules/AgentFAQDelete.pm
    $Self->{Translation}->{'No ItemID is given!'} = 'Nije dat ID Stavke!';
    $Self->{Translation}->{'You have no permission for this category!'} = 'Nemate dozvolu za ovu kategoriju!';
    $Self->{Translation}->{'Was not able to delete the FAQ article %s!'} = 'Nije bilo moguće obrisati FAQ članak %s!';

    # Perl Module: Kernel/Modules/AgentFAQExplorer.pm
    $Self->{Translation}->{'The CategoryID %s is invalid.'} = 'ID Kategorije %s je neispravan!';

    # Perl Module: Kernel/Modules/AgentFAQHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ItemID is given!'} = 'Ne može se prikazati istorijat, jer nije dat ID Stavke!';
    $Self->{Translation}->{'FAQ History'} = 'FAQ istorijat';

    # Perl Module: Kernel/Modules/AgentFAQJournal.pm
    $Self->{Translation}->{'FAQ Journal'} = 'FAQ dnevnik';
    $Self->{Translation}->{'Need config option FAQ::Frontend::Overview'} = 'Potrebna konfiguraciona opcija FAQ::Frontend::Overview';
    $Self->{Translation}->{'Config option FAQ::Frontend::Overview needs to be a HASH ref!'} =
        'Konfiguraciona opcija FAQ::Frontend::Overview mora da bude HASH referenca!';
    $Self->{Translation}->{'No config option found for the view "%s"!'} = 'Nije pronađena konfiguraciona stavka za pregled "%s"!';

    # Perl Module: Kernel/Modules/AgentFAQLanguage.pm
    $Self->{Translation}->{'No LanguageID is given!'} = 'Nije dat ID Jezika!';
    $Self->{Translation}->{'The name is required!'} = 'Ime je obavezno!';
    $Self->{Translation}->{'This language already exists!'} = 'Ovaj jezik već postoji!';
    $Self->{Translation}->{'Was not able to delete the language %s!'} = 'Nije bilo moguće obrisati jezik %s!';
    $Self->{Translation}->{'FAQ language updated!'} = 'Ažuriran FAQ jezik!';
    $Self->{Translation}->{'FAQ language added!'} = 'Dodat FAQ jezik!';
    $Self->{Translation}->{'Delete Language %s'} = 'Obriši jezik %s';

    # Perl Module: Kernel/Modules/AgentFAQPrint.pm
    $Self->{Translation}->{'Result'} = 'Rezultat';
    $Self->{Translation}->{'Last update'} = 'Poslednje ažuriranje';
    $Self->{Translation}->{'FAQ Dynamic Fields'} = 'FAQ dinamička polja';

    # Perl Module: Kernel/Modules/AgentFAQRichText.pm
    $Self->{Translation}->{'No %s is given!'} = 'Nije dat %s!';
    $Self->{Translation}->{'Can\'t load LanguageObject!'} = 'Jezički objekt se ne može učitati!';

    # Perl Module: Kernel/Modules/AgentFAQSearch.pm
    $Self->{Translation}->{'No Result!'} = 'Nema rezultata!';
    $Self->{Translation}->{'FAQ Number'} = 'FAQ broj';
    $Self->{Translation}->{'Last Changed by'} = 'Poslednji je menjao';
    $Self->{Translation}->{'FAQ Item Create Time (before/after)'} = 'Vreme kreiranja FAQ stavke (pre/posle)';
    $Self->{Translation}->{'FAQ Item Create Time (between)'} = 'Vreme kreiranja FAQ stavke (između)';
    $Self->{Translation}->{'FAQ Item Change Time (before/after)'} = 'Vreme izmene FAQ stavke (pre/posle)';
    $Self->{Translation}->{'FAQ Item Change Time (between)'} = 'Vreme izmene FAQ stavke (između)';
    $Self->{Translation}->{'Equals'} = 'Jednako';
    $Self->{Translation}->{'Greater than'} = 'Veće od';
    $Self->{Translation}->{'Greater than equals'} = 'Jednako ili veće od';
    $Self->{Translation}->{'Smaller than'} = 'Manje od';
    $Self->{Translation}->{'Smaller than equals'} = 'Jednako ili manje od';

    # Perl Module: Kernel/Modules/AgentFAQZoom.pm
    $Self->{Translation}->{'Need FileID!'} = 'Potreban ID Polja!';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Hvala na vašem glasu!';
    $Self->{Translation}->{'You have already voted!'} = 'Već ste glasali!';
    $Self->{Translation}->{'No rate selected!'} = 'Nije izabrana ni jedna ocena!';
    $Self->{Translation}->{'The voting mechanism is not enabled!'} = 'Mehanizam za glasanje nije aktiviran!';
    $Self->{Translation}->{'The vote rate is not defined!'} = 'Ocenjivanje glasanja nije definisano!';

    # Perl Module: Kernel/Modules/CustomerFAQPrint.pm
    $Self->{Translation}->{'FAQ Article Print'} = 'Štampa FAQ članka';

    # Perl Module: Kernel/Modules/CustomerFAQSearch.pm
    $Self->{Translation}->{'Created between'} = 'Kreiran između';

    # Perl Module: Kernel/Modules/CustomerFAQZoom.pm
    $Self->{Translation}->{'Need ItemID!'} = 'Potreban ID Stavke!';

    # Perl Module: Kernel/Modules/PublicFAQExplorer.pm
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'FAQ članci (novo kreirani)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'FAQ članci (nedavno menjani)';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'FAQ članci (prvih 10)';

    # Perl Module: Kernel/Modules/PublicFAQRSS.pm
    $Self->{Translation}->{'No Type is given!'} = 'Nije dat Tip!';
    $Self->{Translation}->{'Type must be either LastCreate or LastChange or Top10!'} = 'Type mora biti LastCreate, LastChange ili Top10!';
    $Self->{Translation}->{'Can\'t create RSS file!'} = 'RSS datoteka ne moće biti snimljena!';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/AgentFAQSearch.pm
    $Self->{Translation}->{'%s (FAQFulltext)'} = '%s (FAQ tekst)';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/CustomerFAQSearch.pm
    $Self->{Translation}->{'%s - Customer (%s)'} = '%s - Klijent (%s)';
    $Self->{Translation}->{'%s - Customer (FAQFulltext)'} = '%s - Klijent (FAQ tekst)';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/PublicFAQSearch.pm
    $Self->{Translation}->{'%s - Public (%s)'} = '%s - Javno (%s)';
    $Self->{Translation}->{'%s - Public (FAQFulltext)'} = '%s - Javno (FAQ tekst)';

    # Perl Module: Kernel/Output/HTML/Layout/FAQ.pm
    $Self->{Translation}->{'Need rate!'} = 'Neophodna ocena!';
    $Self->{Translation}->{'This article is empty!'} = 'Članak je prazan!';
    $Self->{Translation}->{'Latest created FAQ articles'} = 'Poslednje kreirani FAQ članci';
    $Self->{Translation}->{'Latest updated FAQ articles'} = 'Poslednje ažurirani FAQ članci';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Najpopularnijih 10 FAQ članaka';

    # Perl Module: Kernel/Output/HTML/LinkObject/FAQ.pm
    $Self->{Translation}->{'Content Type'} = 'Tip sadržaja';

    # Database XML Definition: FAQ.sopm
    $Self->{Translation}->{'internal'} = 'interno';
    $Self->{Translation}->{'external'} = 'eksterno';
    $Self->{Translation}->{'public'} = 'javno';

    # JS File: FAQ.Agent.ConfirmationDialog
    $Self->{Translation}->{'Ok'} = 'U redu';

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} =
        'Filter za „HTML” izlaz za dodavanje veze iza definisanog niza znakova. Element Slika dozvoljava dva načina unosa. Prvi je naziv slike (npr faq.png). u ovom slučaju biće korišćena „OTRS” putanja do slike.  Druga mogućnost je unos veze do slike.';
    $Self->{Translation}->{'Add FAQ article'} = 'Dodaj FAQ članak';
    $Self->{Translation}->{'CSS color for the voting result.'} = '„CSS” boja za rezultat glasanja.';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = 'Vreme oslobađanja keša za FAQ stavke.';
    $Self->{Translation}->{'Category Management'} = 'Upravljanje kategorijama';
    $Self->{Translation}->{'Category Management.'} = 'Upravljanje kategorijama.';
    $Self->{Translation}->{'Customer FAQ Print.'} = 'Štampanje klijentskog FAQ.';
    $Self->{Translation}->{'Customer FAQ Related Articles'} = 'Srodni FAQ članci u interfejsu klijenta';
    $Self->{Translation}->{'Customer FAQ Related Articles.'} = 'Srodni FAQ članci u interfejsu klijenta.';
    $Self->{Translation}->{'Customer FAQ Zoom.'} = 'Detalji klijentskog FAQ.';
    $Self->{Translation}->{'Customer FAQ search.'} = 'Pretraga klijentskog FAQ.';
    $Self->{Translation}->{'Customer FAQ.'} = 'Klijentski FAQ.';
    $Self->{Translation}->{'Decimal places of the voting result.'} = 'Broj decimala u rezultatu glasanja.';
    $Self->{Translation}->{'Default category name.'} = 'Naziv podrazumevane kategorije.';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = 'Podrazumevani jezik FAQ članaka u jednojezičkom načinu rada.';
    $Self->{Translation}->{'Default maximum size of the titles in a FAQ article to be shown.'} =
        'Podrazumevana maksimalna dužina naslova FAQ članka koja će biti prikazana.';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        'Podrazumevani prioritet tiketa za odobravanje FAQ članaka.';
    $Self->{Translation}->{'Default state for FAQ entry.'} = 'Podrazumevano stanje FAQ unosa.';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'Podrazumevano stanje tiketa za odobravanje FAQ članaka.';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = 'Podrazumevani tip tiketa za odobravanje FAQ članaka.';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} =
        'Podrazumevana vrednost za „Action” parametar u javnom frontendu. Ovaj parametar koriste skripte sistema. ';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'Definiše Akcije gde je dugme postavki dostupno u povezanom grafičkom elementu objekta (LinkObject::ViewMode = "complex"). Molimo da imate na umu da ove Akcije moraju da budu registrovane u sledećim JS i CSS datotekama: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js i Core.Agent.LinkObject.js.';
    $Self->{Translation}->{'Define if the FAQ title should be concatenated to article subject.'} =
        'Određuje da li naslov FAQ treba da bude dodat na temu članka.';
    $Self->{Translation}->{'Define which columns are shown in the linked FAQs widget (LinkObject::ViewMode = "complex"). Note: Only FAQ attributes and dynamic fields (DynamicField_NameX) are allowed for DefaultColumns.'} =
        'Određuje koje kolone će biti prikazane u dodatku povezanih FAQ članaka (LinkObject::ViewMode = "složeno"). Napomena: samo atributi FAQ članka i dinamička polja (DynamicField_NameX) su dozvoljeni za DefaultColumns.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} =
        'Definiše modul pregleda za mali prikaz FAQ dnevnika. ';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} =
        'Definiše modul pregleda za mali prikaz FAQ liste. ';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} =
        'Definiše podrazumevani atribut za sortiranje FAQ pretrazi FAQ  u interfejsu  operatera.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} =
        'Definiše podrazumevani atribut za sortiranje FAQ u pretrazi FAQ  u interfejsu klijenta.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} =
        'Definiše podrazumevani atribut za sortiranje FAQ u pretrazi FAQ  u javnom interfejsu.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the agent interface.'} =
        'Definiše podrazumevani atribut za sortiranje FAQ u FAQ pretraživaču u interfejsu operatera.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the customer interface.'} =
        'Definiše podrazumevani atribut za sortiranje FAQ u FAQ pretraživaču u interfejsu klijenta.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} =
        'Definiše podrazumevani atribut za sortiranje FAQ u FAQ pretraživaču u javnom interfejsu.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the agent interface. Up: oldest on top. Down: latest on top.'} =
        'Definiše podrazumevani redosled FAQ u rezultatima FAQ pretraživača u interfejsu opreratera. Gore: najstariji na vrhu. Dole: najnovije na vrhu.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the customer interface. Up: oldest on top. Down: latest on top.'} =
        'Definiše podrazumevani redosled FAQ u rezultatima FAQ pretraživača u interfejsu klijenta. Gore: najstariji na vrhu. Dole: najnovije na vrhu.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the public interface. Up: oldest on top. Down: latest on top.'} =
        'Definiše podrazumevani redosled FAQ rezultatima FAQ pretraživača u javnom interfejsu. Gore: najstariji na vrhu. Dole: najnovije na vrhu.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} =
        'Definiše podrazumevani redosled FAQ u rezultatima pretrage u interfejsu opreratera. Gore: najstariji na vrhu. Dole: najnovije na vrhu.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} =
        'Definiše podrazumevani redosled FAQ u rezultatima pretrage u interfejsu klijenta. Gore: najstariji na vrhu. Dole: najnovije na vrhu.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} =
        'Definiše podrazumevani redosled FAQ u rezultatima pretrage u javnom interfejsu. Gore: najstariji na vrhu. Dole: najnovije na vrhu.';
    $Self->{Translation}->{'Defines the default shown FAQ search attribute for FAQ search screen.'} =
        'Definiše podrazumevani prikazani FAQ atribut pretrage za FAQ prozor za pretragu. ';
    $Self->{Translation}->{'Defines the information to be inserted in a FAQ based Ticket. "Full FAQ" includes text, attachments and inline images.'} =
        'Određuje informacije koje će biti ubačene u FAQ bazirani tiket. "Kompletan FAQ" uključuje tekst, priloge i umetnute slike.';
    $Self->{Translation}->{'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.'} =
        'Definiše pozadinske parametre za kontrolnu tablu. "Limit" definiše broj podrezumevano prikazanih unosa. "Grupa" se koristi da ograniči pristup dodatku (npr. Grupa: admin;group1;group2;)."Podrazumevano" ukazuje na to da li je dodatak podrazumevano aktiviran ili da je potrebno da ga korisnik manuelno aktivira.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} =
        'Definiše prikazane kolone u FAQ pretraživaču. Ova opcija nema uticaj na pozicije kolona.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} =
        'Definiše prikazane kolone u FAQ dnevniku. Ova opcija nema uticaj na pozicije kolona.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} =
        'Definiše prikazane kolone u FAQ pretrazi. Ova opcija nema uticaj na pozicije kolona.';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed.'} = 'Definiše gde će "Ubaci FAQ" veza biti prikazana.';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = 'Definicija polja slobodnog teksta za FAQ stavku.';
    $Self->{Translation}->{'Delete this FAQ'} = 'Obriši ovaj FAQ';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ add screen of the agent interface.'} =
        'Dinamička polja prikatana u ekranu dodavanja FAQ u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ edit screen of the agent interface.'} =
        'Dinamička polja prikazana u ekranu izmene FAQ u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the customer interface.'} =
        'Dinamička polja prikazana u pregledu FAQ u interfejsu klijenta.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the public interface.'} =
        'Dinamička polja prikazana u pregledu FAQ u javnom interfejsu.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the agent interface.'} =
        'Dinamička polja prikazana u ekranu štampe FAQ u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the customer interface.'} =
        'Dinamička polja prikazana u ekranu štampe FAQ u interfejsu klijenta.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the public interface.'} =
        'Dinamička polja prikazana u ekranu štampe FAQ u javnom interfejsu.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the agent interface.'} =
        'Dinamička polja prikazana u ekranu pretrage FAQ u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the customer interface.'} =
        'Dinamička polja prikazana u ekranu pretrage FAQ u interfejsu klijenta.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the public interface.'} =
        'Dinamička polja prikazana u ekranu pretrage FAQ u javnom interfejsu.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ small format overview screen of the agent interface.'} =
        'Dinamička polja prikazana u pregledu FAQ malog formata u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the agent interface.'} =
        'Dinamička polja prikazana u detaljnom pregledu FAQ u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the customer interface.'} =
        'Dinamička polja prikazana u detaljnom pregledu FAQ u interfejsu klijenta.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the public interface.'} =
        'Dinamička polja prikazana u detaljnom pregledu FAQ u javnom interfejsu.';
    $Self->{Translation}->{'Edit this FAQ'} = 'Uredi ovaj FAQ';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = 'Aktiviranje više jezika na FAQ modulu.';
    $Self->{Translation}->{'Enable the related article feature for the customer frontend.'} =
        'Aktivira funkciju srodnih članaka za interfejs klijenta.';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = 'Aktiviranje mehanizma za glasanje na FAQ modulu.';
    $Self->{Translation}->{'Explorer'} = 'Istraživač';
    $Self->{Translation}->{'FAQ AJAX Responder'} = 'FAQ AJAX odgovarač';
    $Self->{Translation}->{'FAQ AJAX Responder for Richtext.'} = 'FAQ AJAX odgovarač za FAQ.';
    $Self->{Translation}->{'FAQ Area'} = 'FAQ prostor';
    $Self->{Translation}->{'FAQ Area.'} = 'FAQ prostor.';
    $Self->{Translation}->{'FAQ Delete.'} = 'Obriši FAQ.';
    $Self->{Translation}->{'FAQ Edit.'} = 'Uredi FAQ.';
    $Self->{Translation}->{'FAQ History.'} = 'Istorijat FAQ.';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = 'Ograničenje pregleda FAQ dnevnika "malo"';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = 'Ograničenje pregleda FAQ "malo"';
    $Self->{Translation}->{'FAQ Print.'} = 'Štampaj FAQ.';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = 'Modul rutera FAQ pretrage u interfejsu operatera.';
    $Self->{Translation}->{'Field4'} = 'Polje4';
    $Self->{Translation}->{'Field5'} = 'Polje5';
    $Self->{Translation}->{'Full FAQ'} = 'Kompletan FAQ';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = 'Grupa za odobravanje FAQ članaka.';
    $Self->{Translation}->{'History of this FAQ'} = 'Istorijat ovog FAQ';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = 'Uključi interna polja u FAQ baziran tiket.';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = 'Uključi naziv svakog polja u FAQ baziran tiket.';
    $Self->{Translation}->{'Interfaces where the quick search should be shown.'} = 'Interfejs na kom treba prikazati brzu pretragu.';
    $Self->{Translation}->{'Journal'} = 'Dnevnik';
    $Self->{Translation}->{'Language Management'} = 'Upravljanje jezicima';
    $Self->{Translation}->{'Language Management.'} = 'Upravljanje jezicima.';
    $Self->{Translation}->{'Limit for the search to build the keyword FAQ article list.'} = 'Ograničenje pretrage za generisanje liste ključnih reči FAQ članaka.';
    $Self->{Translation}->{'Link another object to this FAQ item'} = 'Poveži drugi objekat sa ovom stavkom FAQ';
    $Self->{Translation}->{'List of queue names for which the related article feature is enabled.'} =
        'Lista imena redova za koje je funcija srodnih članaka aktivirana.';
    $Self->{Translation}->{'List of state types which can be used in the agent interface.'} =
        'Lista tipova stanja koji se mogu koristiti u interfejsu operatera.';
    $Self->{Translation}->{'List of state types which can be used in the customer interface.'} =
        'Lista tipova stanja koji se mogu koristiti u interfejsu klijenta.';
    $Self->{Translation}->{'List of state types which can be used in the public interface.'} =
        'Lista tipova stanja koji se mogu koristiti u javnom interfejsu.';
    $Self->{Translation}->{'Loader module registration for the public interface.'} = 'Registracija modula za učitavanje za javni interfejs.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the agent interface.'} =
        'Maksimalni broj FAQ članaka koji će biti prikazani u rezultatu FAQ pretraživača u interfejsu operatera.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the customer interface.'} =
        'Maksimalni broj FAQ članaka koji će biti prikazani u rezultatu FAQ pretraživača u interfejsu klijenta.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the public interface.'} =
        'Maksimalni broj FAQ članaka koji će biti prikazani u rezultatu FAQ pretraživača u javnom interfejsu.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} =
        'Maksimalni broj FAQ članaka koji će biti prikazani u FAQ dnevniku u interfejsu operatera.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} =
        'Maksimalni broj FAQ članaka koji će biti prikazani u rezultatu pretrage u interfejsu operatera.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} =
        'Maksimalni broj FAQ članaka koji će biti prikazani u rezultatu pretrage u interfejsu klijenta.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} =
        'Maksimalni broj FAQ članaka koji će biti prikazani u rezultatu pretrage u javnom interfejsu.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the agent interface.'} =
        'Maksimalna dužina naslova u FAQ članku koji će biti prikazani u FAQ pretraživaču u interfejsu operatera.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the customer interface.'} =
        'Maksimalna dužina naslova u FAQ članku koji će biti prikazani u FAQ pretraživaču u interfejsu klijenta.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the public interface.'} =
        'Maksimalna dužina naslova u FAQ članku koji će biti prikazani u FAQ istraživaču u javnom interfejsu.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the agent interface.'} =
        'Maksimalna dužina naslova u FAQ članku koji će biti prikazani u FAQ pretrazi u interfejsu operatera.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the customer interface.'} =
        'Maksimalna dužina naslova u FAQ članku koji će biti prikazani u FAQ pretrazi u interfejsu klijenta.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the public interface.'} =
        'Maksimalna dužina naslova u FAQ članku koji će biti prikazani u FAQ pretrazi u javnom interfejsu.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ journal in the agent interface.'} =
        'Maksimalna dužina naslova u FAQ članku koji će biti prikazani u FAQ dnevniku u interfejsu operatera.';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the customer interface.'} =
        'Modul za generisanje HTML OpenSearch profila za kratku FAQ pretragu u interfejsu klijenta.';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the public interface.'} =
        'Modul za generisanje HTML OpenSearch profila za kratku FAQ pretragu u javnom profilu.';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short FAQ search.'} =
        'Modul za generisanje HTML OpenSearch profila za kratku FAQ pretragu.';
    $Self->{Translation}->{'New FAQ Article.'} = 'Novi FAQ članak.';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = 'Novi FAQ članci trebaju biti odobreni pre objavljivanja.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the customer interface.'} =
        'Broj FAQ članaka koji će biti prikazani u FAQ pretraživaču u interfejsu klijenta.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the public interface.'} =
        'Broj FAQ članaka koji će biti prikazani u FAQ pretraživaču u javnom interfejsu.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the customer interface.'} =
        'Broj FAQ članaka koji će biti prikazani na svakoj strani rezultata pretrage u interfejsu klijenta.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the public interface.'} =
        'Broj FAQ članaka koji će biti prikazani na svakoj strani rezultata pretrage u javnom interfejsu.';
    $Self->{Translation}->{'Number of shown items in last changes.'} = 'Broj prikazanih stavki u poslednjim izmenama.';
    $Self->{Translation}->{'Number of shown items in last created.'} = 'Broj prikazanih stavki u poslednje kreiranim.';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = 'Broj prikazanih stavki u "prvih 10" .';
    $Self->{Translation}->{'Output filter to add Java-script to CustomerTicketMessage screen.'} =
        'Izlazni filter za ubacivanje JavaScript u CustomerTicketMessage ekran.';
    $Self->{Translation}->{'Output limit for the related FAQ articles.'} = 'Ograničenje broja prikazanih srodnih FAQ članaka.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} =
        'Parametri stranica (na kojima su FAQ stavke prikazane) na malom prikazu pregleda FAQ dnevnika.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} =
        'Parametri stranica (na kojima su vidljive FAQ stavke) smanjenog pregleda FAQ.';
    $Self->{Translation}->{'Print this FAQ'} = 'Štampaj ovaj FAQ';
    $Self->{Translation}->{'Public FAQ Print.'} = 'Štampanje javnih FAQ.';
    $Self->{Translation}->{'Public FAQ Zoom.'} = 'Detalji javnih FAQ.';
    $Self->{Translation}->{'Public FAQ search.'} = 'Pretraga javnih FAQ.';
    $Self->{Translation}->{'Public FAQ.'} = 'Javni FAQ.';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = 'Red za odobravanje FAQ članaka.';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = 'Ocene za glasanje. Ključ mora biti u procentima.';
    $Self->{Translation}->{'S'} = 'S';
    $Self->{Translation}->{'Search FAQ'} = 'Pretraži FAQ';
    $Self->{Translation}->{'Search FAQ Small.'} = 'Mala FAQ pretraga.';
    $Self->{Translation}->{'Search FAQ.'} = 'Pretraga FAQ.';
    $Self->{Translation}->{'Select how many items should be shown in Journal Overview "Small" by default.'} =
        'Izaberite koliko će stavki biti podrazumevano prikazano u pregledu dnevnika malog formata.';
    $Self->{Translation}->{'Select how many items should be shown in Overview "Small" by default.'} =
        'Izaberite koliko će stavki biti podrazumevano prikazano u pregledu malog formata.';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        'Podesi podrazumevanu visinu (u pikselima) inline HTML polja u AgentFAQZoom.';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        'Podesi podrazumevanu visinu (u pikselima) inline HTML polja u CustomerFAQZoom (i PublicFAQZoom).';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        'Podesi maksimalnu visinu (u pikselima) inline HTML polja u AgentFAQZoom.';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        'Podesi maksimalnu visinu (u pikselima) inline HTML polja u CustomerFAQZoom (i PublicFAQZoom).';
    $Self->{Translation}->{'Show "Insert FAQ Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        'Prikaži "Ubaci FAQ vezu" dugme u AgentFAQZoomSmall za javne FAQ artikle.';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" / "Insert Full FAQ & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        'Prikaži "Ubaci FAQ tekst i vezu" / "Ubaci ceo FAQ i vezu dugme u AgentFAQZoomSmall za javne FAQ artikle.';
    $Self->{Translation}->{'Show "Insert FAQ Text" / "Insert Full FAQ" Button in AgentFAQZoomSmall.'} =
        'Prikaži "Ubaci FAQ tekst" / "Ubaci ceo FAQ" dugme u AgentFAQZoomSmall.';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = 'Prikaz FAQ članka kao HTML.';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = 'Prikaži putanju do FAQ da/ne.';
    $Self->{Translation}->{'Show invalid items in the FAQ Explorer result of the agent interface.'} =
        'Prikaz neisprvnih stavki u rezultatima FAQ pretraživača u interfejsu operatera.';
    $Self->{Translation}->{'Show items of subcategories.'} = 'Prikaži stavke subkategorija.';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = 'Prikaži zadnje promenjene stavke u definisanim interfejsima.';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = 'Prikaži zadnje kreirane stavke u definisanim interfejsima.';
    $Self->{Translation}->{'Show the stars for the articles with a rating equal or greater like the defined value (set value \'0\' to deactivate the output).'} =
        'Prikaži zvezdice za članke sa jednakom ili boljom ocenom od definisane vrednosti (postavite vrednost \'0\' za deaktiviranje prikaza).';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = 'Prikaži prvih 10 stavki u definisanim interfejsima.';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = 'Prikaži glasanje u definisanim interfejsima.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'} =
        'U meniju prikazuje vezu koja omogućava povezivanje FAQ sa drugim objektom u detaljnom prikazu tog FAQ u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'} =
        'U meniju prikazuje vezu koja omogućava brisanje FAQ u detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za pristup FAQ istorijatu u detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za izmenu FAQ u detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za povratak u detaljni prikaz FAQ u  interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za štampanje FAQ u detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Solution'} = 'Rešenje';
    $Self->{Translation}->{'Symptom'} = 'Simptom';
    $Self->{Translation}->{'Text Only'} = 'Samo tekst';
    $Self->{Translation}->{'The default languages for the related FAQ articles.'} = 'Podrazumevani jezici za srodne FAQ članke.';
    $Self->{Translation}->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'} =
        'Identifikator za FAQ, npr. FAQ#, KB#, MyFAQ#. Podrazumevano je FAQ#.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'} =
        'Ovo podešavanje definiše da FAQ objekt može da se poveže sa drugim FAQ objektima koristeći vezu tipa \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Ovo podešavanje definiše da FAQ objekat može da se poveže sa drugim FAQ objektima koristeći vezu tipa \'ParentChild\'.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'} =
        'Ovo podešavanje definiše da FAQ objekt može da se poveže sa drugim tiket objektima koristeći vezu tipa \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'} =
        'Ovo podešavanje definiše da FAQ objekt može da se poveže sa drugim tiket objektima koristeći vezu tipa \'ParentChild\'.';
    $Self->{Translation}->{'Ticket body for approval of FAQ article.'} = 'Sadržaj tiketa za odobravanje FAQ članaka.';
    $Self->{Translation}->{'Ticket subject for approval of FAQ article.'} = 'Predmet tiketa za odobravanje FAQ članaka.';
    $Self->{Translation}->{'Toolbar Item for a shortcut.'} = 'Stavka alatne linije za skraćenicu.';
    $Self->{Translation}->{'external (customer)'} = 'eksterno (klijent)';
    $Self->{Translation}->{'internal (agent)'} = 'interno (operater)';
    $Self->{Translation}->{'public (all)'} = 'javno (sve)';
    $Self->{Translation}->{'public (public)'} = 'javno (javno)';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'No',
    'Ok',
    'Settings',
    'Submit',
    'This might be helpful',
    'Yes',
    );

}

1;
