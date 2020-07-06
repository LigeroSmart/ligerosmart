# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::nl_FAQ;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'FAQ-artikel toevoegen';
    $Self->{Translation}->{'Keywords'} = 'Zoekwoorden';
    $Self->{Translation}->{'A category is required.'} = 'Een categorie is vereist.';
    $Self->{Translation}->{'Approval'} = 'Goedkeuring';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'FAQ-categoriebeheer';
    $Self->{Translation}->{'Add FAQ Category'} = 'FAQ-categorie toevoegen';
    $Self->{Translation}->{'Edit FAQ Category'} = 'FAQ-categorie bewerken';
    $Self->{Translation}->{'Add category'} = 'Categorie toevoegen';
    $Self->{Translation}->{'Add Category'} = 'Categorie toevoegen';
    $Self->{Translation}->{'Edit Category'} = 'Categorie bewerken';
    $Self->{Translation}->{'Subcategory of'} = 'Subcategorie van';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Selecteer ten minste één permissiegroep.';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Agentgroepen die toegang hebben tot artikelen in deze categorie.';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Wordt weergegeven als opmerking in Verkenner.';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'Wil je deze categorie echt verwijderen?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        'Je kan deze categorie niet verwijderen. Het wordt gebruikt in ten minste één FAQ-artikel en/of is ouder van ten minste één andere categorie';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'Deze categorie wordt gebruikt in de volgende FAQ-artikel(en)';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'Deze categorie is de bovenliggende van de volgende subcategorieën';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'Wil je dit FAQ-artikel echt verwijderen?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'FAQ Verkenner';
    $Self->{Translation}->{'Quick Search'} = 'Snelzoeken';
    $Self->{Translation}->{'Wildcards are allowed.'} = 'Wildcards zijn toegestaan.';
    $Self->{Translation}->{'Advanced Search'} = 'Geavanceerd zoeken';
    $Self->{Translation}->{'Subcategories'} = 'Subcategorieën';
    $Self->{Translation}->{'FAQ Articles'} = 'FAQ-artikelen';
    $Self->{Translation}->{'No subcategories found.'} = 'Geen Subcategorieën gevonden.';

    # Template: AgentFAQHistory
    $Self->{Translation}->{'History of'} = 'Geschiedenis van';
    $Self->{Translation}->{'History Content'} = 'Geschiedenisinhoud';
    $Self->{Translation}->{'Createtime'} = 'Maak tijd';

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'Geen FAQ-journaalgegevens gevonden.';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'FAQ Taalbeheer';
    $Self->{Translation}->{'Add FAQ Language'} = 'FAQ-taal toevoegen';
    $Self->{Translation}->{'Edit FAQ Language'} = 'FAQ-taal bewerken';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languages.'} =
        'Gebruik deze functie als je met meerdere talen wilt werken.';
    $Self->{Translation}->{'Add language'} = 'Taal toevoegen';
    $Self->{Translation}->{'Add Language'} = 'Taal toevoegen';
    $Self->{Translation}->{'Edit Language'} = 'Taal bewerken';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'Wil je deze taal echt verwijderen?';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        'Je kunt deze taal niet verwijderen. Het wordt gebruikt in ten minste één FAQ-artikel!';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'Deze taal wordt gebruikt in de volgende FAQ-artikel(en)';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Contextinstellingen';
    $Self->{Translation}->{'FAQ articles per page'} = 'FAQ-artikelen per pagina';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'Geen FAQ-gegevens gevonden.';

    # Template: AgentFAQRelatedArticles
    $Self->{Translation}->{'out of 5'} = 'van de 5';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = 'Zoekwoord';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = 'Stem (bijv. is gelijk aan 10 of groter dan 60)';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = 'Beoordeling (bijv. Is gelijk aan 25% of Groter dan 75%)';
    $Self->{Translation}->{'Approved'} = 'Goedgekeurd';
    $Self->{Translation}->{'Last changed by'} = 'Laatst gewijzigd door';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = 'FAQ-artikel maak tijd (voor/na)';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = 'FAQ-artikel maak tijd (tussen)';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = 'FAQ-artikel wijzigingstijd (voor/na)';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = 'FAQ-artikel wijzigingstijd (tussen)';

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'FAQ volledige tekst';

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'FAQ Zoeken';
    $Self->{Translation}->{'Profile Selection'} = 'Profielselectie';
    $Self->{Translation}->{'Vote'} = 'Stem';
    $Self->{Translation}->{'No vote settings'} = 'Geen steminstellingen';
    $Self->{Translation}->{'Specific votes'} = 'Specifieke stemmen';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = 'bijv. Is gelijk aan 10 of groter dan 60';
    $Self->{Translation}->{'Rate'} = 'Beoordeling';
    $Self->{Translation}->{'No rate settings'} = 'Geen beoordelingsinstellingen';
    $Self->{Translation}->{'Specific rate'} = 'Specifieke beoordeling';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = 'bijv. Is gelijk 25% of groter dan 75%';
    $Self->{Translation}->{'FAQ Article Create Time'} = 'FAQ-artikel maak tijd';
    $Self->{Translation}->{'FAQ Article Change Time'} = 'FAQ-artikel wijzigingstijd';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'FAQ Informatie';
    $Self->{Translation}->{'Rating'} = 'Beoordeling';
    $Self->{Translation}->{'Votes'} = 'Stemmen';
    $Self->{Translation}->{'No votes found!'} = 'Geen stemmen gevonden!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Geen stemmen gevonden! Wees de eerste die dit FAQ-artikel beoordeelt.';
    $Self->{Translation}->{'Download Attachment'} = 'Bijlage downloaden';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Om links in de volgende beschrijvingsblokken te openen, moet je mogelijk op Ctrl of Cmd of Shift drukken terwijl je op de link klikt (afhankelijk van je browser en besturingssysteem).';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        'Hoe nuttig was dit artikel? Geef ons je beoordeling en help om de FAQ-database te verbeteren. Dank je!';
    $Self->{Translation}->{'not helpful'} = 'niet nuttig';
    $Self->{Translation}->{'very helpful'} = 'erg nuttig';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Add FAQ title to article subject'} = 'Voeg FAQ-titel toe aan het onderwerp van het artikel';
    $Self->{Translation}->{'Insert FAQ Text'} = 'Voeg FAQ-tekst in';
    $Self->{Translation}->{'Insert Full FAQ'} = 'Voeg de volledige FAQ in';
    $Self->{Translation}->{'Insert FAQ Link'} = 'FAQ-link invoegen';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'Voeg FAQ Tekst & Link in';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = 'Volledige FAQ & Link invoegen';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'Geen FAQ-artikelen gevonden.';

    # Template: CustomerFAQRelatedArticles
    $Self->{Translation}->{'This might be helpful'} = 'Dit kan nuttig zijn';
    $Self->{Translation}->{'Found no helpful resources for the subject and text.'} = 'Geen nuttige bronnen gevonden voor het onderwerp en de tekst.';
    $Self->{Translation}->{'Type a subject or text to get a list of helpful resources.'} = 'Typ een onderwerp of tekst om een lijst met nuttige bronnen te krijgen.';

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Zoeken in volledige tekst in FAQ-artikelen (bijv. "John*n" of "Will*")';
    $Self->{Translation}->{'Vote restrictions'} = 'Stem beperkingen';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = 'Alleen FAQ-artikelen met stemmen ...';
    $Self->{Translation}->{'Rate restrictions'} = 'Beoordelingbeperkingen';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = 'Alleen FAQ-artikelen met een beoordeling...';
    $Self->{Translation}->{'Time restrictions'} = 'Tijdsbeperkingen';
    $Self->{Translation}->{'Only FAQ articles created'} = 'Alleen FAQ-artikelen gemaakt';
    $Self->{Translation}->{'Only FAQ articles created between'} = 'Alleen FAQ-artikelen gemaakt tussen';
    $Self->{Translation}->{'Search-Profile as Template?'} = 'Zoekprofiel als sjabloon?';

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = 'Artikelnummer';
    $Self->{Translation}->{'Search for articles with keyword'} = 'Zoek naar artikelen met trefwoord';

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = 'Openbaar';

    # Template: PublicFAQSearchResultShort
    $Self->{Translation}->{'Back to FAQ Explorer'} = 'Terug naar FAQ Verkenner';

    # Perl Module: Kernel/Modules/AgentFAQAdd.pm
    $Self->{Translation}->{'You need rw permission!'} = 'Je hebt rw toestemming nodig!';
    $Self->{Translation}->{'No categories found where user has read/write permissions!'} = 'Geen categorieën gevonden waar de gebruiker lees-/schrijfrechten heeft!';
    $Self->{Translation}->{'No default language found and can\'t create a new one.'} = 'Geen standaardtaal gevonden en kan geen nieuwe maken.';

    # Perl Module: Kernel/Modules/AgentFAQCategory.pm
    $Self->{Translation}->{'Need CategoryID!'} = 'CategoryID nodig!';
    $Self->{Translation}->{'A category should have a name!'} = 'Een categorie moet een naam hebben!';
    $Self->{Translation}->{'This category already exists'} = 'Deze categorie bestaat al';
    $Self->{Translation}->{'This category already exists!'} = 'Deze categorie bestaat al!';
    $Self->{Translation}->{'No CategoryID is given!'} = 'Er wordt geen CategoryID gegeven!';
    $Self->{Translation}->{'Was not able to delete the category %s!'} = 'Kon de categorie %s niet verwijderen!';
    $Self->{Translation}->{'FAQ category updated!'} = 'FAQ-categorie bijgewerkt!';
    $Self->{Translation}->{'FAQ category added!'} = 'FAQ-categorie toegevoegd!';
    $Self->{Translation}->{'Delete Category'} = 'Categorie verwijderen';

    # Perl Module: Kernel/Modules/AgentFAQDelete.pm
    $Self->{Translation}->{'No ItemID is given!'} = 'Er wordt geen ItemID gegeven!';
    $Self->{Translation}->{'You have no permission for this category!'} = 'U heeft geen toestemming voor deze categorie!';
    $Self->{Translation}->{'Was not able to delete the FAQ article %s!'} = 'Kan het FAQ-artikel %s niet verwijderen!';

    # Perl Module: Kernel/Modules/AgentFAQExplorer.pm
    $Self->{Translation}->{'The CategoryID %s is invalid.'} = 'De CategoryID %s is ongeldig.';

    # Perl Module: Kernel/Modules/AgentFAQHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ItemID is given!'} = 'Kan de geschiedenis niet weergeven, omdat er geen ItemID wordt gegeven!';
    $Self->{Translation}->{'FAQ History'} = 'FAQ geschiedenis';

    # Perl Module: Kernel/Modules/AgentFAQJournal.pm
    $Self->{Translation}->{'FAQ Journal'} = 'FAQ journaal';
    $Self->{Translation}->{'Need config option FAQ::Frontend::Overview'} = 'Configuratieoptie FAQ::Frontend::Overzicht nodig';
    $Self->{Translation}->{'Config option FAQ::Frontend::Overview needs to be a HASH ref!'} =
        'Configuratie-optie FAQ::Frontend::Overzicht moet een HASH-ref zijn!';
    $Self->{Translation}->{'No config option found for the view "%s"!'} = 'Geen configuratieoptie gevonden voor de weergave "%s"!';

    # Perl Module: Kernel/Modules/AgentFAQLanguage.pm
    $Self->{Translation}->{'No LanguageID is given!'} = 'Er wordt geen LanguageID gegeven!';
    $Self->{Translation}->{'The name is required!'} = 'De naam is verplicht!';
    $Self->{Translation}->{'This language already exists!'} = 'Deze taal bestaat al!';
    $Self->{Translation}->{'Was not able to delete the language %s!'} = 'Kan de taal %s niet verwijderen!';
    $Self->{Translation}->{'FAQ language updated!'} = 'FAQ-taal bijgewerkt!';
    $Self->{Translation}->{'FAQ language added!'} = 'FAQ-taal toegevoegd!';
    $Self->{Translation}->{'Delete Language %s'} = 'Taal %s verwijderen';

    # Perl Module: Kernel/Modules/AgentFAQPrint.pm
    $Self->{Translation}->{'Result'} = 'Resultaat';
    $Self->{Translation}->{'Last update'} = 'Laatste update';
    $Self->{Translation}->{'FAQ Dynamic Fields'} = 'FAQ Dynamische velden';

    # Perl Module: Kernel/Modules/AgentFAQRichText.pm
    $Self->{Translation}->{'No %s is given!'} = 'Er wordt geen %s gegeven!';
    $Self->{Translation}->{'Can\'t load LanguageObject!'} = 'Kan LanguageObject niet laden!';

    # Perl Module: Kernel/Modules/AgentFAQSearch.pm
    $Self->{Translation}->{'No Result!'} = 'Geen resultaat!';
    $Self->{Translation}->{'FAQ Number'} = 'FAQ-nummer';
    $Self->{Translation}->{'Last Changed by'} = 'Laatst gewijzigd door';
    $Self->{Translation}->{'FAQ Item Create Time (before/after)'} = 'FAQ-item maaktijd (voor/na)';
    $Self->{Translation}->{'FAQ Item Create Time (between)'} = 'FAQ-item maaktijd (tussen)';
    $Self->{Translation}->{'FAQ Item Change Time (before/after)'} = 'FAQ-item wijzigingstijd (voor/na)';
    $Self->{Translation}->{'FAQ Item Change Time (between)'} = 'FAQ-item wijzigingstijd (tussen)';
    $Self->{Translation}->{'Equals'} = 'Is gelijk aan';
    $Self->{Translation}->{'Greater than'} = 'Groter dan';
    $Self->{Translation}->{'Greater than equals'} = 'Groter dan is gelijk aan';
    $Self->{Translation}->{'Smaller than'} = 'Kleiner dan';
    $Self->{Translation}->{'Smaller than equals'} = 'Kleiner dan is gelijk aan';

    # Perl Module: Kernel/Modules/AgentFAQZoom.pm
    $Self->{Translation}->{'Need FileID!'} = 'FileID nodig!';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Bedankt voor je stem!';
    $Self->{Translation}->{'You have already voted!'} = 'Je hebt al gestemd!';
    $Self->{Translation}->{'No rate selected!'} = 'Geen beoordeling geselecteerd!';
    $Self->{Translation}->{'The voting mechanism is not enabled!'} = 'Het stemmechanisme is niet ingeschakeld!';
    $Self->{Translation}->{'The vote rate is not defined!'} = 'Het stempercentage is niet gedefinieerd!';

    # Perl Module: Kernel/Modules/CustomerFAQPrint.pm
    $Self->{Translation}->{'FAQ Article Print'} = 'FAQ-artikel afdrukken';

    # Perl Module: Kernel/Modules/CustomerFAQSearch.pm
    $Self->{Translation}->{'Created between'} = 'Gemaakt tussen';

    # Perl Module: Kernel/Modules/CustomerFAQZoom.pm
    $Self->{Translation}->{'Need ItemID!'} = 'ItemID nodig!';

    # Perl Module: Kernel/Modules/PublicFAQExplorer.pm
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'FAQ-artikelen (nieuw gemaakt)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'FAQ-artikelen (onlangs gewijzigd)';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'FAQ-artikelen (Top 10)';

    # Perl Module: Kernel/Modules/PublicFAQRSS.pm
    $Self->{Translation}->{'No Type is given!'} = 'Er wordt geen Type gegeven!';
    $Self->{Translation}->{'Type must be either LastCreate or LastChange or Top10!'} = 'Type moet LastCreate of LastChange of Top10 zijn!';
    $Self->{Translation}->{'Can\'t create RSS file!'} = 'Kan geen RSS-bestand maken!';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/AgentFAQSearch.pm
    $Self->{Translation}->{'%s (FAQFulltext)'} = '%s (FAQ volledige tekst)';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/CustomerFAQSearch.pm
    $Self->{Translation}->{'%s - Customer (%s)'} = '%s - Klant (%s)';
    $Self->{Translation}->{'%s - Customer (FAQFulltext)'} = '%s - Klant (FAQ volledige tekst)';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/PublicFAQSearch.pm
    $Self->{Translation}->{'%s - Public (%s)'} = '%s - Openbaar (%s)';
    $Self->{Translation}->{'%s - Public (FAQFulltext)'} = '%s - Openbaar (FAQ volledige tekst)';

    # Perl Module: Kernel/Output/HTML/Layout/FAQ.pm
    $Self->{Translation}->{'Need rate!'} = 'Beoordeling nodig!';
    $Self->{Translation}->{'This article is empty!'} = 'Dit artikel is leeg!';
    $Self->{Translation}->{'Latest created FAQ articles'} = 'Laatst gemaakte FAQ-artikelen';
    $Self->{Translation}->{'Latest updated FAQ articles'} = 'Laatst bijgewerkte FAQ-artikelen';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Top 10 FAQ-artikelen';

    # Perl Module: Kernel/Output/HTML/LinkObject/FAQ.pm
    $Self->{Translation}->{'Content Type'} = 'Inhoudstype';

    # Database XML / SOPM Definition: FAQ.sopm
    $Self->{Translation}->{'internal'} = 'intern';
    $Self->{Translation}->{'external'} = 'extern';
    $Self->{Translation}->{'public'} = 'openbaar';

    # JS File: FAQ.Agent.ConfirmationDialog
    $Self->{Translation}->{'Ok'} = 'Ok';

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} =
        'Een filter voor HTML-uitvoer om links toe te voegen achter een gedefinieerde tekenreeks. Het element Image staat twee invoertypes toe. Eerst de naam van een afbeelding (bijv. Faq.png). In dit geval wordt het OTRS-afbeeldingspad gebruikt. De tweede mogelijkheid is om de link naar de afbeelding in te voegen.';
    $Self->{Translation}->{'Add FAQ article'} = 'FAQ-artikel toevoegen';
    $Self->{Translation}->{'CSS color for the voting result.'} = 'CSS-kleur voor het stemresultaat.';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = 'Cachetijd voor FAQ-items.';
    $Self->{Translation}->{'Category Management'} = 'Categorie beheer';
    $Self->{Translation}->{'Category Management.'} = 'Categorie beheer.';
    $Self->{Translation}->{'Customer FAQ Print.'} = 'Klant FAQ afdrukken.';
    $Self->{Translation}->{'Customer FAQ Related Articles'} = 'Klant FAQ Gerelateerde artikelen';
    $Self->{Translation}->{'Customer FAQ Related Articles.'} = 'Klant FAQ Gerelateerde artikelen.';
    $Self->{Translation}->{'Customer FAQ Zoom.'} = 'Klant FAQ Zoom.';
    $Self->{Translation}->{'Customer FAQ search.'} = 'Klant FAQ zoeken.';
    $Self->{Translation}->{'Customer FAQ.'} = 'Klant FAQ.';
    $Self->{Translation}->{'Decimal places of the voting result.'} = 'Decimalen van het stemresultaat.';
    $Self->{Translation}->{'Default category name.'} = 'Standaard categorienaam.';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = 'Standaardtaal voor FAQ-artikelen over de modus voor één taal.';
    $Self->{Translation}->{'Default maximum size of the titles in a FAQ article to be shown.'} =
        'Standaard maximale grootte van de titels in een FAQ-artikel dat moet worden weergegeven.';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        'Standaardprioriteit van tickets voor de goedkeuring van FAQ-artikelen.';
    $Self->{Translation}->{'Default state for FAQ entry.'} = 'Standaardstatus voor FAQ-item.';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'Standaardstatus van tickets voor de goedkeuring van FAQ-artikelen.';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = 'Standaard type tickets voor de goedkeuring van FAQ-artikelen.';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} =
        'Standaardwaarde voor de parameter Actie voor de openbare frontend. De parameter Actie wordt gebruikt in de scripts van het systeem.';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'Definieer acties waarbij een instellingenknop beschikbaar is in de widget voor gekoppelde objecten (LinkObject::ViewMode = "complex"). Houd er rekening mee dat deze acties de volgende JS- en CSS-bestanden moeten hebben geregistreerd: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js en Core.Agent .LinkObject.js.';
    $Self->{Translation}->{'Define if the FAQ title should be concatenated to article subject.'} =
        'Bepaal of de titel van de FAQ moet worden samengevoegd met het onderwerp van het artikel.';
    $Self->{Translation}->{'Define which columns are shown in the linked FAQs widget (LinkObject::ViewMode = "complex"). Note: Only FAQ attributes and dynamic fields (DynamicField_NameX) are allowed for DefaultColumns.'} =
        'Definieer welke kolommen worden weergegeven in de gekoppelde widget voor veelgestelde vragen (LinkObject::ViewMode = "complex"). Opmerking: alleen standaardkenmerken en dynamische velden (DynamicField_NameX) zijn toegestaan voor DefaultColumns.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} =
        'Definieert een overzichtsmodule om de kleine weergave van een FAQ-journaal te tonen.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} =
        'Definieert een overzichtsmodule om de kleine weergave van een FAQ-lijst weer te geven.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} =
        'Definieert het standaard FAQ-kenmerk voor het sorteren van FAQ in een FAQ zoekopdracht in de agentinterface.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} =
        'Definieert het standaard FAQ-kenmerk voor het sorteren van FAQ in een FAQ zoekopdracht in de klanteninterface.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} =
        'Definieert het standaard FAQ-kenmerk voor het sorteren van FAQ in een FAQ-zoekopdracht in de openbare interface.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the agent interface.'} =
        'Definieert het standaard FAQ-kenmerk voor het sorteren van FAQ in de FAQ Verkenner van de agentinterface.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the customer interface.'} =
        'Definieert het standaard FAQ-kenmerk voor het sorteren van FAQ in de FAQ Verkenner van de klanteninterface.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} =
        'Definieert het standaard FAQ-kenmerk voor het sorteren van FAQ in de FAQ Verkenner van de openbare interface.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the agent interface. Up: oldest on top. Down: latest on top.'} =
        'Definieert de standaard FAQ-volgorde in het FAQ Verkenner-resultaat van de agentinterface. Omhoog: oudste bovenaan. Omlaag: laatste bovenaan.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the customer interface. Up: oldest on top. Down: latest on top.'} =
        'Definieert de standaard FAQ-volgorde in het FAQ Verkenner-resultaat van de klanteninterface. Omhoog: oudste bovenaan. Omlaag: laatste bovenaan.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the public interface. Up: oldest on top. Down: latest on top.'} =
        'Definieert de standaard FAQ-volgorde in het FAQ Verkenner-resultaat van de openbare interface. Omhoog: oudste bovenaan. Omlaag: laatste bovenaan.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} =
        'Definieert de standaard FAQ-volgorde van een zoekresultaat in de agentinterface. Omhoog: oudste bovenaan. Omlaag: laatste bovenaan.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} =
        'Definieert de standaard FAQ-volgorde van een zoekresultaat in de klanteninterface. Omhoog: oudste bovenaan. Omlaag: laatste bovenaan.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} =
        'Definieert de standaard FAQ-volgorde van een zoekresultaat in de openbare interface. Omhoog: oudste bovenaan. Omlaag: laatste bovenaan.';
    $Self->{Translation}->{'Defines the default shown FAQ search attribute for FAQ search screen.'} =
        'Definieert het standaard weergegeven FAQ-zoekattribuut voor het FAQ-zoekscherm.';
    $Self->{Translation}->{'Defines the information to be inserted in a FAQ based Ticket. "Full FAQ" includes text, attachments and inline images.'} =
        'Definieert de informatie die in een op FAQ gebaseerd ticket moet worden ingevoegd. "Volledige FAQ" bevat tekst, bijlagen en inline afbeeldingen.';
    $Self->{Translation}->{'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.'} =
        'Definieert de parameters voor de dashboardbackend. "Limiet" definieert het aantal items dat standaard wordt weergegeven. "Groep" wordt gebruikt om de toegang tot de plug-in te beperken (bijv. Groep: admin; groep1; groep2;). "Standaard" geeft aan of de plug-in standaard is ingeschakeld of dat de gebruiker deze handmatig moet inschakelen.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} =
        'Definieert de weergegeven kolommen in de FAQ Verkenner. Deze optie heeft geen invloed op de positie van de kolom.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} =
        'Definieert de weergegeven kolommen in het FAQ-journaal. Deze optie heeft geen invloed op de positie van de kolom.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} =
        'Definieert de weergegeven kolommen in de FAQ-zoekopdracht. Deze optie heeft geen invloed op de positie van de kolom.';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed.'} = 'Bepaalt waar de link \'FAQ invoegen\' wordt weergegeven.';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = 'Definitie van het vrije tekstveld van het FAQ-item.';
    $Self->{Translation}->{'Delete this FAQ'} = 'Verwijder deze FAQ';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ add screen of the agent interface.'} =
        'Dynamische velden die worden weergegeven in het FAQ toevoegen scherm van de agentinterface.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ edit screen of the agent interface.'} =
        'Dynamische velden weergegeven in het FAQ bewerkingsscherm van de interface van de agent.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the customer interface.'} =
        'Dynamische velden weergegeven in het FAQ overzichtscherm van de klanteninterface.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the public interface.'} =
        'Dynamische velden weergegeven in het FAQ overzichtscherm van de openbare interface.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the agent interface.'} =
        'Dynamische velden weergegeven in het FAQ afdrukken scherm van de agentinterface.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the customer interface.'} =
        'Dynamische velden weergegeven in het FAQ-afdrukscherm van de klantinterface.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the public interface.'} =
        'Dynamische velden weergegeven in het FAQ-afdrukscherm van de openbare interface.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the agent interface.'} =
        'Dynamische velden weergegeven in het FAQ-zoekscherm van de agentinterface.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the customer interface.'} =
        'Dynamische velden weergegeven in het FAQ-zoekscherm van de klantinterface.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the public interface.'} =
        'Dynamische velden weergegeven in het FAQ-zoekscherm van de openbare interface.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ small format overview screen of the agent interface.'} =
        'Dynamische velden weergegeven in het FAQ-kleineoverzichtsscherm van de agentinterface.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the agent interface.'} =
        'Dynamische velden weergegeven in het FAQ-zoomscherm van de agentinterface.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the customer interface.'} =
        'Dynamische velden weergegeven in het FAQ-zoomscherm van de klantinterface.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the public interface.'} =
        'Dynamische velden weergegeven in het FAQ-zoomscherm van de openbare interface.';
    $Self->{Translation}->{'Edit this FAQ'} = 'Bewerk deze FAQ';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = 'Schakel meerdere talen in op de FAQ-module.';
    $Self->{Translation}->{'Enable the related article feature for the customer frontend.'} =
        'Schakel de gerelateerde artikelfunctie in voor de frontend van de klant.';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = 'Stemmechanisme inschakelen op de FAQ-module.';
    $Self->{Translation}->{'Explorer'} = 'Verkenner';
    $Self->{Translation}->{'FAQ AJAX Responder'} = 'FAQ AJAX-responder';
    $Self->{Translation}->{'FAQ AJAX Responder for Richtext.'} = 'FAQ AJAX Responder voor Richtext.';
    $Self->{Translation}->{'FAQ Area'} = 'FAQ-gebied';
    $Self->{Translation}->{'FAQ Area.'} = 'FAQ-gebied.';
    $Self->{Translation}->{'FAQ Delete.'} = 'FAQ verwijderen.';
    $Self->{Translation}->{'FAQ Edit.'} = 'FAQ bewerken.';
    $Self->{Translation}->{'FAQ History.'} = 'FAQ geschiedenis.';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = 'FAQ journaaloverzicht "Kleine" limiet';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = 'FAQ-overzicht "Kleine" limiet';
    $Self->{Translation}->{'FAQ Print.'} = 'FAQ Afdrukken.';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = 'FAQ zoeken backend router van de agent-interface.';
    $Self->{Translation}->{'Field4'} = 'Veld4';
    $Self->{Translation}->{'Field5'} = 'Veld5';
    $Self->{Translation}->{'Full FAQ'} = 'Volledige FAQ';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = 'Groep voor de goedkeuring van FAQ-artikelen.';
    $Self->{Translation}->{'History of this FAQ'} = 'Geschiedenis van deze FAQ';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = 'Voeg interne velden toe aan een FAQ gebaseerd ticket.';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = 'Vermeld de naam van elk veld in een op FAQ gebaseerd ticket.';
    $Self->{Translation}->{'Interfaces where the quick search should be shown.'} = 'Interfaces waar de snelle zoekopdracht moet worden weergegeven.';
    $Self->{Translation}->{'Journal'} = 'Journaal';
    $Self->{Translation}->{'Language Management'} = 'Taalbeheer';
    $Self->{Translation}->{'Language Management.'} = 'Taalbeheer.';
    $Self->{Translation}->{'Limit for the search to build the keyword FAQ article list.'} = 'Limiet voor de zoekopdracht om de FAQ-artikellijst zoekwoorden te maken.';
    $Self->{Translation}->{'Link another object to this FAQ item'} = 'Koppel een ander object aan dit FAQ-item';
    $Self->{Translation}->{'List of queue names for which the related article feature is enabled.'} =
        'Lijst met wachtrijnamen waarvoor de gerelateerde artikelfunctie is ingeschakeld.';
    $Self->{Translation}->{'List of state types which can be used in the agent interface.'} =
        'Lijst met statustypen die kunnen worden gebruikt in de agentinterface.';
    $Self->{Translation}->{'List of state types which can be used in the customer interface.'} =
        'Lijst met statustypen die in de klanteninterface kunnen worden gebruikt.';
    $Self->{Translation}->{'List of state types which can be used in the public interface.'} =
        'Lijst met statustypen die in de openbare interface kunnen worden gebruikt.';
    $Self->{Translation}->{'Loader module registration for the public interface.'} = 'Registratie van ladermodule voor de openbare interface.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the agent interface.'} =
        'Maximumaantal FAQ-artikelen dat moet worden weergegeven in het FAQ Verkenner-resultaat van de agentinterface.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the customer interface.'} =
        'Maximumaantal FAQ-artikelen dat moet worden weergegeven in het FAQ Verkenner-resultaat van de klanteninterface.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the public interface.'} =
        'Maximumaantal FAQ-artikelen dat moet worden weergegeven in het FAQ Verkenner-resultaat van de openbare interface.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} =
        'Maximumaantal FAQ-artikelen dat moet worden weergegeven in het FAQ-journaal in de agentinterface.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} =
        'Maximumaantal FAQ-artikelen dat moet worden weergegeven als resultaat van een zoekopdracht in de agentinterface.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} =
        'Maximumaantal FAQ-artikelen dat moet worden weergegeven als resultaat van een zoekopdracht in de klanteninterface.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} =
        'Maximumaantal FAQ-artikelen dat moet worden weergegeven als resultaat van een zoekopdracht in de openbare interface.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the agent interface.'} =
        'Maximale grootte van de titels in een FAQ-artikel dat moet worden weergegeven in de FAQ-Verkenner in de agentinterface.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the customer interface.'} =
        'Maximale grootte van de titels in een FAQ-artikel dat in de FAQ Verkenner in de klanteninterface moet worden weergegeven.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the public interface.'} =
        'Maximale grootte van de titels in een FAQ-artikel dat in de FAQ Verkenner in de openbare interface moet worden weergegeven.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the agent interface.'} =
        'Maximale grootte van de titels in een FAQ-artikel dat moet worden weergegeven in de FAQ-zoekopdracht in de agentinterface.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the customer interface.'} =
        'Maximale grootte van de titels in een FAQ-artikel dat moet worden weergegeven in de FAQ-zoekopdracht in de klanteninterface.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the public interface.'} =
        'Maximale grootte van de titels in een FAQ-artikel dat moet worden weergegeven in de FAQ-zoekopdracht in de openbare interface.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ journal in the agent interface.'} =
        'Maximale grootte van de titels in een FAQ-artikel dat in het FAQ-journaal in de agentinterface moet worden weergegeven.';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the public interface.'} =
        '';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short FAQ search.'} =
        '';
    $Self->{Translation}->{'New FAQ Article.'} = '';
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
    $Self->{Translation}->{'Output filter to add Java-script to CustomerTicketMessage screen.'} =
        '';
    $Self->{Translation}->{'Output limit for the related FAQ articles.'} = '';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} =
        '';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} =
        '';
    $Self->{Translation}->{'Print this FAQ'} = 'Artikel afdrukken';
    $Self->{Translation}->{'Public FAQ Print.'} = '';
    $Self->{Translation}->{'Public FAQ Zoom.'} = '';
    $Self->{Translation}->{'Public FAQ search.'} = '';
    $Self->{Translation}->{'Public FAQ.'} = '';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = '';
    $Self->{Translation}->{'S'} = '';
    $Self->{Translation}->{'Search FAQ'} = 'Zoeken in FAQ';
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
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = 'FAQ-artikel met HTML weergeven.';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = 'FAQ-pad weergeven ja/nee.';
    $Self->{Translation}->{'Show invalid items in the FAQ Explorer result of the agent interface.'} =
        '';
    $Self->{Translation}->{'Show items of subcategories.'} = 'Items van subcategorieën weergeven.';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show the stars for the articles with a rating equal or greater like the defined value (set value \'0\' to deactivate the output).'} =
        '';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = 'Stemmen in gedefinieerde interfaces weergeven.';
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
    $Self->{Translation}->{'Solution'} = 'Oplossing';
    $Self->{Translation}->{'Symptom'} = 'Symptoom';
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
    $Self->{Translation}->{'Toolbar Item for a shortcut.'} = '';
    $Self->{Translation}->{'external (customer)'} = 'extern (klanten)';
    $Self->{Translation}->{'internal (agent)'} = 'intern (gebruikers)';
    $Self->{Translation}->{'public (all)'} = 'publiek';
    $Self->{Translation}->{'public (public)'} = '';


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
