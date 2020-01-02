# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pl_FAQ;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'Dodaj artykuł FAQ';
    $Self->{Translation}->{'Keywords'} = 'słowa kluczowe';
    $Self->{Translation}->{'A category is required.'} = 'Kategoria jest wymagana.';
    $Self->{Translation}->{'Approval'} = 'Zatwierdzenie';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'Zarządzanie kategoriami FAQ';
    $Self->{Translation}->{'Add FAQ Category'} = 'Dodaj kategorię FAQ';
    $Self->{Translation}->{'Edit FAQ Category'} = 'Edytuj kategorię FAQ';
    $Self->{Translation}->{'Add category'} = 'Dodaj kategorię';
    $Self->{Translation}->{'Add Category'} = 'Dodaj kategorię';
    $Self->{Translation}->{'Edit Category'} = 'Edytuj kategorię';
    $Self->{Translation}->{'Subcategory of'} = 'Podkategoria';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Zaznacz przynajmniej jedną grupę uprawnień.';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Grupy agnetów, które mają dostęp do tej kategorii.';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Zostanie pokazany jako komentarz w eksplorerze.';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'Czy na pewno chcesz usunąć tę kategorię?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        'Nie możesz usunąć tej kategorii. Jest ona używana przez przynajmniej jeden artykuł FAQ lub/i jest rodzicem prznajmniej jednej innej kategorii';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'Ta kategoria jest używana w następujących artykułach FAQ';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'Ta kategoria jest rodzicem następujących podkategorii';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'Czy na pewno chcesz usunąć ten artykuł FAQ?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'Eksplorer FAQ';
    $Self->{Translation}->{'Quick Search'} = 'Szybkie wyszukiwanie';
    $Self->{Translation}->{'Wildcards are allowed.'} = 'Znaki wieloznaczne są dozwolone.';
    $Self->{Translation}->{'Advanced Search'} = 'Wyszukiwanie zaawansowane';
    $Self->{Translation}->{'Subcategories'} = 'Podkategorie';
    $Self->{Translation}->{'FAQ Articles'} = 'Artykuły FAQ';
    $Self->{Translation}->{'No subcategories found.'} = 'Brak podkategorii.';

    # Template: AgentFAQHistory
    $Self->{Translation}->{'History of'} = 'Historia';
    $Self->{Translation}->{'History Content'} = 'Zawartość historii';
    $Self->{Translation}->{'Createtime'} = 'Utworzone';

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'Brak danych w dzienniku FAQ.';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'Zarządzanie językami FAQ';
    $Self->{Translation}->{'Add FAQ Language'} = 'Dodaj język FAQ';
    $Self->{Translation}->{'Edit FAQ Language'} = 'Edytuj język FAQ';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languages.'} =
        'Użyj tej funkcji jeśli chcesz pracować z wieloma językami.';
    $Self->{Translation}->{'Add language'} = 'Dodaj język';
    $Self->{Translation}->{'Add Language'} = 'Dodaj język';
    $Self->{Translation}->{'Edit Language'} = 'Edytuj język';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'Czy na pewno chcesz usunąć ten język?';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        'Nie możesz usunąć tego języka. Jest on używany w przynajmniej jednym artykule FAQ!';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'Ten język jest używany w następujących artukułach FAQ';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Ustawienia kontekstowe';
    $Self->{Translation}->{'FAQ articles per page'} = 'Liczba artykułów FAQ na stronę';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'Brak danych FAQ.';

    # Template: AgentFAQRelatedArticles
    $Self->{Translation}->{'out of 5'} = 'z 5';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = 'Słowo kluczowe';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = 'Głosuj (np.: równe 10 lub więcej niż 60)';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = 'Oceń (np.: równe 25% lub więcej niż 75%)';
    $Self->{Translation}->{'Approved'} = 'Zatwierdzone';
    $Self->{Translation}->{'Last changed by'} = 'Ostatnio zmienione przez';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = 'FAQ Czas tworzenia zgłoszenia (przed/po)';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = 'FAQ Czas tworzenia zgłoszenia (pomiędzy)';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = 'FAQ Czas zmiany zgłoszenia (przed/po)';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = 'FAQ Czas zmiany zgłoszenia (pomiędzy)';

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'FAQ pełnotekstowo';

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'Wyszukiwanie FAQ';
    $Self->{Translation}->{'Profile Selection'} = 'Wybór profilu';
    $Self->{Translation}->{'Vote'} = 'Głosuj';
    $Self->{Translation}->{'No vote settings'} = 'Brak ustawień głosowania';
    $Self->{Translation}->{'Specific votes'} = 'Konkretne głosy';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = 'np.: równe 10 lub więcej niż 60';
    $Self->{Translation}->{'Rate'} = 'Oceń';
    $Self->{Translation}->{'No rate settings'} = 'Brak ustawień ocen';
    $Self->{Translation}->{'Specific rate'} = 'Konkretna ocena';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = 'np.: równe 25% lub więcej niż 75%';
    $Self->{Translation}->{'FAQ Article Create Time'} = 'Czas utworzenia artykułu FAQ';
    $Self->{Translation}->{'FAQ Article Change Time'} = 'FAQ Czas zmiany zgłoszenia';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'Informacje FAQ';
    $Self->{Translation}->{'Rating'} = 'Ocena';
    $Self->{Translation}->{'Votes'} = 'Głosy';
    $Self->{Translation}->{'No votes found!'} = 'Brak głosów!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Brak głosów! Bądź pierwszy i oceń ten artykuł FAQ.';
    $Self->{Translation}->{'Download Attachment'} = 'Pobierz załącznik';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Aby otworzyć łącza, w poniższych blokach opisu, należy przycisnąć klawisz Ctrl, Cmd lub Shift podczas kliknięcia (w zależności od przeglądarki i systemu operacyjnego).';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        'Jak pomocny był ten artykuł? Prosimy o twoją ocenę i pomoc przy udoskonalaniu bazy FAQ. Dziękujemy!';
    $Self->{Translation}->{'not helpful'} = 'nieprzydatne';
    $Self->{Translation}->{'very helpful'} = 'pomocne';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Add FAQ title to article subject'} = 'Dodaj tytuł FAQ jako temat wiadomości';
    $Self->{Translation}->{'Insert FAQ Text'} = 'Wstaw tekst FAQ';
    $Self->{Translation}->{'Insert Full FAQ'} = 'Wstaw cały FAQ';
    $Self->{Translation}->{'Insert FAQ Link'} = 'Wstaw odnośnik FAQ';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'Wstaw tekst i odnośnik FAQ';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = 'Wstaw cały FAQ i odnośnik';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'Nie znaleziono artykułów FAQ.';

    # Template: CustomerFAQRelatedArticles
    $Self->{Translation}->{'This might be helpful'} = 'To może być przydatne';
    $Self->{Translation}->{'Found no helpful resources for the subject and text.'} = 'Nie znaleziono zasobów pomocy dla podanego tematu i treści';
    $Self->{Translation}->{'Type a subject or text to get a list of helpful resources.'} = 'Wpisz obok temat lub treść zgłoszenia aby przeszukać zasoby pomocy.';

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Wyszukiwanie pełnotekstowe w artykułach FAQ (np. "Naj*pszy" lub "Kowalsk*")';
    $Self->{Translation}->{'Vote restrictions'} = 'Ograniczenia głosowania';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = 'Tylko artykuły FAQ z głosami...';
    $Self->{Translation}->{'Rate restrictions'} = 'Ograniczenia ocen';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = 'Tylko artykuły FAQ z oceną...';
    $Self->{Translation}->{'Time restrictions'} = 'Ograniczenia czasowe';
    $Self->{Translation}->{'Only FAQ articles created'} = 'Tylko utworzone artykuły FAQ';
    $Self->{Translation}->{'Only FAQ articles created between'} = 'Tylko artykuły FAQ utworzone pomiędzy';
    $Self->{Translation}->{'Search-Profile as Template?'} = 'Profil wyszukiwania jako Szablon?';

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = 'Numer artykułu';
    $Self->{Translation}->{'Search for articles with keyword'} = 'Szukaj artykułów za pomocą słowa kluczowego';

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = 'Pobliczne';

    # Template: PublicFAQSearchResultShort
    $Self->{Translation}->{'Back to FAQ Explorer'} = 'Wróć do Przeglądu FAQ';

    # Perl Module: Kernel/Modules/AgentFAQAdd.pm
    $Self->{Translation}->{'You need rw permission!'} = 'Potrzebujesz praw odczytu/zapisu!';
    $Self->{Translation}->{'No categories found where user has read/write permissions!'} = 'Brak kategorii gdzie użytkownik posiada prawa zapisu/odczytu!';
    $Self->{Translation}->{'No default language found and can\'t create a new one.'} = 'Brak domyślnego języka i nie można stworzyć nowego.';

    # Perl Module: Kernel/Modules/AgentFAQCategory.pm
    $Self->{Translation}->{'Need CategoryID!'} = 'Potrzebne CategoryID!';
    $Self->{Translation}->{'A category should have a name!'} = 'Kategoria powinna posiadać nazwę!';
    $Self->{Translation}->{'This category already exists'} = 'Ta kategoria już istnieje';
    $Self->{Translation}->{'This category already exists!'} = 'Ta kategoria już istnieje!';
    $Self->{Translation}->{'No CategoryID is given!'} = 'Nie zadeklarowano CategoryID!';
    $Self->{Translation}->{'Was not able to delete the category %s!'} = 'Nie można usunąć kategorii %s!';
    $Self->{Translation}->{'FAQ category updated!'} = 'Kategoria FAQ zaktualizowana!';
    $Self->{Translation}->{'FAQ category added!'} = 'Kategoria FAQ dodana!';
    $Self->{Translation}->{'Delete Category'} = 'Usuń kategorię';

    # Perl Module: Kernel/Modules/AgentFAQDelete.pm
    $Self->{Translation}->{'No ItemID is given!'} = 'Nie zadeklarowano ItemID!';
    $Self->{Translation}->{'You have no permission for this category!'} = 'Nie masz uprawnień do tych kategorii!';
    $Self->{Translation}->{'Was not able to delete the FAQ article %s!'} = 'Nie możesz usunąć artykułu FAQ %s!';

    # Perl Module: Kernel/Modules/AgentFAQExplorer.pm
    $Self->{Translation}->{'The CategoryID %s is invalid.'} = 'CategoryID %s jest nie prawidłowe.';

    # Perl Module: Kernel/Modules/AgentFAQHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ItemID is given!'} = 'Nie można wyświetlić historii, nie podano ItemID!';
    $Self->{Translation}->{'FAQ History'} = 'Historia FAQ';

    # Perl Module: Kernel/Modules/AgentFAQJournal.pm
    $Self->{Translation}->{'FAQ Journal'} = 'Dziennik FAQ';
    $Self->{Translation}->{'Need config option FAQ::Frontend::Overview'} = 'Potrzebna konfiguracja opcji FAQ::Frontend::Overview';
    $Self->{Translation}->{'Config option FAQ::Frontend::Overview needs to be a HASH ref!'} =
        '';
    $Self->{Translation}->{'No config option found for the view "%s"!'} = 'Brak konfiguracji opcji dla widoku "%s"!';

    # Perl Module: Kernel/Modules/AgentFAQLanguage.pm
    $Self->{Translation}->{'No LanguageID is given!'} = 'Brak zadeklarowanego LanguageID!';
    $Self->{Translation}->{'The name is required!'} = 'Nazwa jest wymagana!';
    $Self->{Translation}->{'This language already exists!'} = 'Ten język już istnieje!';
    $Self->{Translation}->{'Was not able to delete the language %s!'} = 'Nie możemy usunąć języka %s!';
    $Self->{Translation}->{'FAQ language updated!'} = 'Język FAQ zaktualizowany!';
    $Self->{Translation}->{'FAQ language added!'} = 'Język FAQ dodany!';
    $Self->{Translation}->{'Delete Language %s'} = 'Usuń język %s';

    # Perl Module: Kernel/Modules/AgentFAQPrint.pm
    $Self->{Translation}->{'Result'} = 'Wynik';
    $Self->{Translation}->{'Last update'} = 'Ostatnia aktualizacja';
    $Self->{Translation}->{'FAQ Dynamic Fields'} = 'Pola Dynamiczne FAQ';

    # Perl Module: Kernel/Modules/AgentFAQRichText.pm
    $Self->{Translation}->{'No %s is given!'} = 'Nie zadeklarowano %s!';
    $Self->{Translation}->{'Can\'t load LanguageObject!'} = 'Nie można załadować LanguageObject!';

    # Perl Module: Kernel/Modules/AgentFAQSearch.pm
    $Self->{Translation}->{'No Result!'} = 'Brak Wyników!';
    $Self->{Translation}->{'FAQ Number'} = 'Numer FAQ';
    $Self->{Translation}->{'Last Changed by'} = 'Ostatnio Zmienione przez';
    $Self->{Translation}->{'FAQ Item Create Time (before/after)'} = 'Czas utworzenia elementu FAQ (przed/po)';
    $Self->{Translation}->{'FAQ Item Create Time (between)'} = 'Czas utworzenia elementu FAQ (pomiędzy)';
    $Self->{Translation}->{'FAQ Item Change Time (before/after)'} = 'Czas zmiany elementu FAQ (przed/po)';
    $Self->{Translation}->{'FAQ Item Change Time (between)'} = 'Czas zmiany elementu FAQ (pomiędzy)';
    $Self->{Translation}->{'Equals'} = 'Równe';
    $Self->{Translation}->{'Greater than'} = 'Większe niż';
    $Self->{Translation}->{'Greater than equals'} = 'Większe lub równe';
    $Self->{Translation}->{'Smaller than'} = 'Mniejsze niż';
    $Self->{Translation}->{'Smaller than equals'} = 'Mniejsze lub równe';

    # Perl Module: Kernel/Modules/AgentFAQZoom.pm
    $Self->{Translation}->{'Need FileID!'} = 'Potrzebny FileID!';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Dziękujemy za oddanie głosu!';
    $Self->{Translation}->{'You have already voted!'} = 'Już raz głosowałeś!';
    $Self->{Translation}->{'No rate selected!'} = 'Nie wybrałeś oceny!';
    $Self->{Translation}->{'The voting mechanism is not enabled!'} = 'Mechanizm głosowania nie jest włączony!';
    $Self->{Translation}->{'The vote rate is not defined!'} = 'Wskaźnik głosowania nie jest określony!';

    # Perl Module: Kernel/Modules/CustomerFAQPrint.pm
    $Self->{Translation}->{'FAQ Article Print'} = 'Drukuj informację FAQ';

    # Perl Module: Kernel/Modules/CustomerFAQSearch.pm
    $Self->{Translation}->{'Created between'} = 'Stworzone pomiędzy';

    # Perl Module: Kernel/Modules/CustomerFAQZoom.pm
    $Self->{Translation}->{'Need ItemID!'} = 'Potrzebne ItemID!';

    # Perl Module: Kernel/Modules/PublicFAQExplorer.pm
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'Artykuły FAQ (nowe)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'Artykuły FAQ (ostatnio zmienione)';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'Artykuły FAQ (10 najlepszych)';

    # Perl Module: Kernel/Modules/PublicFAQRSS.pm
    $Self->{Translation}->{'No Type is given!'} = 'Brak zadeklarowanego Typu!';
    $Self->{Translation}->{'Type must be either LastCreate or LastChange or Top10!'} = '';
    $Self->{Translation}->{'Can\'t create RSS file!'} = 'Nie można stworzyć pliku RSS!';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/AgentFAQSearch.pm
    $Self->{Translation}->{'%s (FAQFulltext)'} = '';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/CustomerFAQSearch.pm
    $Self->{Translation}->{'%s - Customer (%s)'} = '%s - Klient (%s)';
    $Self->{Translation}->{'%s - Customer (FAQFulltext)'} = '%s - Klient (FAQFulltext)';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/PublicFAQSearch.pm
    $Self->{Translation}->{'%s - Public (%s)'} = '%s - Publiczne (%s)';
    $Self->{Translation}->{'%s - Public (FAQFulltext)'} = '%s - Publiczne (FAQFulltext)';

    # Perl Module: Kernel/Output/HTML/Layout/FAQ.pm
    $Self->{Translation}->{'Need rate!'} = '';
    $Self->{Translation}->{'This article is empty!'} = 'Ten artykuł jest pusty!';
    $Self->{Translation}->{'Latest created FAQ articles'} = 'Ostatnio dodane informacje FAQ';
    $Self->{Translation}->{'Latest updated FAQ articles'} = 'Ostatnio zaktualizowane informacje FAQ';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Top 10 informacji FAQ';

    # Perl Module: Kernel/Output/HTML/LinkObject/FAQ.pm
    $Self->{Translation}->{'Content Type'} = '';

    # Database XML Definition: FAQ.sopm
    $Self->{Translation}->{'internal'} = 'wewnętrzny';
    $Self->{Translation}->{'external'} = 'zewnętrzne';
    $Self->{Translation}->{'public'} = 'publiczny';

    # JS File: FAQ.Agent.ConfirmationDialog
    $Self->{Translation}->{'Ok'} = 'Ok';

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} =
        '';
    $Self->{Translation}->{'Add FAQ article'} = 'Dodaj artykuł FAQ';
    $Self->{Translation}->{'CSS color for the voting result.'} = 'Kolor CSS dla wyników głosowania.';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = '';
    $Self->{Translation}->{'Category Management'} = 'Zarządzanie kategoriami';
    $Self->{Translation}->{'Category Management.'} = 'Zarządzanie Kategorią.';
    $Self->{Translation}->{'Customer FAQ Print.'} = '';
    $Self->{Translation}->{'Customer FAQ Related Articles'} = '';
    $Self->{Translation}->{'Customer FAQ Related Articles.'} = '';
    $Self->{Translation}->{'Customer FAQ Zoom.'} = '';
    $Self->{Translation}->{'Customer FAQ search.'} = '';
    $Self->{Translation}->{'Customer FAQ.'} = '';
    $Self->{Translation}->{'Decimal places of the voting result.'} = 'Miejsca po potrzecinku w wynikach głosowania.';
    $Self->{Translation}->{'Default category name.'} = 'Domyślna nazwa kategorii.';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = 'Domyślny język dla artykułów FAQ w trybie pojedynczego języka.';
    $Self->{Translation}->{'Default maximum size of the titles in a FAQ article to be shown.'} =
        '';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        'Domyślny priorytet zgłoszeń dla zatwierdzeń artykułów FAQ.';
    $Self->{Translation}->{'Default state for FAQ entry.'} = 'Domyślny stan dla pozycji FAQ.';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} =
        '';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        '';
    $Self->{Translation}->{'Define if the FAQ title should be concatenated to article subject.'} =
        '';
    $Self->{Translation}->{'Define which columns are shown in the linked FAQs widget (LinkObject::ViewMode = "complex"). Note: Only FAQ attributes and dynamic fields (DynamicField_NameX) are allowed for DefaultColumns.'} =
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
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = 'Definicja pola free text pozycji FAQ.';
    $Self->{Translation}->{'Delete this FAQ'} = 'Usuń to FAQ';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ add screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the customer interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the public interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the customer interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the public interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the customer interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the public interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ small format overview screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the customer interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the public interface.'} =
        '';
    $Self->{Translation}->{'Edit this FAQ'} = 'Edytuj to FAQ';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = 'Włącz wiele języków w module FAQ.';
    $Self->{Translation}->{'Enable the related article feature for the customer frontend.'} =
        '';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = 'Włącz mechanizm głosowania w module FAQ.';
    $Self->{Translation}->{'Explorer'} = 'Eksplorer';
    $Self->{Translation}->{'FAQ AJAX Responder'} = '';
    $Self->{Translation}->{'FAQ AJAX Responder for Richtext.'} = '';
    $Self->{Translation}->{'FAQ Area'} = '';
    $Self->{Translation}->{'FAQ Area.'} = '';
    $Self->{Translation}->{'FAQ Delete.'} = '';
    $Self->{Translation}->{'FAQ Edit.'} = 'Edycja FAQ.';
    $Self->{Translation}->{'FAQ History.'} = 'Historia FAQ.';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = 'Limit FAQ w przeglądzie dziennika w trybie "Małe"';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = 'Limit FAQ w przeglądzie w trybie "Małe"';
    $Self->{Translation}->{'FAQ Print.'} = 'Drukuj FAQ.';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = '';
    $Self->{Translation}->{'Field4'} = 'Pole4';
    $Self->{Translation}->{'Field5'} = 'Pole5';
    $Self->{Translation}->{'Full FAQ'} = '';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = 'Grupaa dla akceptacji artykułów FAQ.';
    $Self->{Translation}->{'History of this FAQ'} = 'Historia tego FAQ';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Interfaces where the quick search should be shown.'} = '';
    $Self->{Translation}->{'Journal'} = 'Dziennik';
    $Self->{Translation}->{'Language Management'} = 'Zarządzanie językami';
    $Self->{Translation}->{'Language Management.'} = 'Zarządzanie Językiem';
    $Self->{Translation}->{'Limit for the search to build the keyword FAQ article list.'} = '';
    $Self->{Translation}->{'Link another object to this FAQ item'} = 'Połącz inny obiekt z tym elementem FAQ';
    $Self->{Translation}->{'List of queue names for which the related article feature is enabled.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the agent interface.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the customer interface.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the public interface.'} =
        '';
    $Self->{Translation}->{'Loader module registration for the public interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the agent interface.'} =
        'Maksymalna liczba artykułów FAQ które będą wyświetlane w Przeglądzie FAQ w interfejsie użytkownika.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the customer interface.'} =
        'Maksymalna liczba artykułów FAQ które będą wyświetlane w Przeglądzie FAQ w interfejsie klienta.';
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
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the public interface.'} =
        '';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short FAQ search.'} =
        '';
    $Self->{Translation}->{'New FAQ Article.'} = 'Nowy Artykuł FAQ.';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = 'Nowe artykuły FAQ wymagają zatwierdzenia przed publikacją.';
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
    $Self->{Translation}->{'Output filter to add Java-script to CustomerTicketMessage screen.'} =
        '';
    $Self->{Translation}->{'Output limit for the related FAQ articles.'} = '';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} =
        '';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} =
        '';
    $Self->{Translation}->{'Print this FAQ'} = 'Wydrukuj to FAQ';
    $Self->{Translation}->{'Public FAQ Print.'} = '';
    $Self->{Translation}->{'Public FAQ Zoom.'} = '';
    $Self->{Translation}->{'Public FAQ search.'} = '';
    $Self->{Translation}->{'Public FAQ.'} = '';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = 'Kolejka dla zatwierdzeń aartykułów FAQ.';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = '';
    $Self->{Translation}->{'S'} = '';
    $Self->{Translation}->{'Search FAQ'} = 'Szukaj FAQ';
    $Self->{Translation}->{'Search FAQ Small.'} = '';
    $Self->{Translation}->{'Search FAQ.'} = '';
    $Self->{Translation}->{'Select how many items should be shown in Journal Overview "Small" by default.'} =
        '';
    $Self->{Translation}->{'Select how many items should be shown in Overview "Small" by default.'} =
        '';
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
    $Self->{Translation}->{'Show invalid items in the FAQ Explorer result of the agent interface.'} =
        '';
    $Self->{Translation}->{'Show items of subcategories.'} = '';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show the stars for the articles with a rating equal or greater like the defined value (set value \'0\' to deactivate the output).'} =
        '';
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
    $Self->{Translation}->{'Solution'} = 'Rozwiązanie';
    $Self->{Translation}->{'Symptom'} = 'Objaw';
    $Self->{Translation}->{'Text Only'} = '';
    $Self->{Translation}->{'The default languages for the related FAQ articles.'} = '';
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
    $Self->{Translation}->{'Toolbar Item for a shortcut.'} = 'Pozycja paska narzędziowego dla skrótu.';
    $Self->{Translation}->{'external (customer)'} = 'zewnętrzne (klienci)';
    $Self->{Translation}->{'internal (agent)'} = 'wewnętrzne (agenci)';
    $Self->{Translation}->{'public (all)'} = 'publiczne (wszyscy)';
    $Self->{Translation}->{'public (public)'} = 'publiczne (public)';


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
