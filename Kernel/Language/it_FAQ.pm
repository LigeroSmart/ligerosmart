# --
# Kernel/Language/it_FAQ.pm - translation file
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::it_FAQ;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAFAQ
    $Self->{Translation}->{'internal'} = 'interno';
    $Self->{Translation}->{'public'} = 'pubblico';
    $Self->{Translation}->{'external'} = 'esterno';
    $Self->{Translation}->{'FAQ Number'} = 'Numero FAQ';
    $Self->{Translation}->{'Latest updated FAQ articles'} = 'Ultimi articoli FAQ aggiornati';
    $Self->{Translation}->{'Latest created FAQ articles'} = 'Ultimi articoli FAQ creati';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Top 10 articoli FAQ';
    $Self->{Translation}->{'Subcategory of'} = 'Sottocategoria di';
    $Self->{Translation}->{'No rate selected!'} = 'Nessuna valutazione selezionata!';
    $Self->{Translation}->{'Explorer'} = 'Esplora';
    $Self->{Translation}->{'public (all)'} = 'pubblico (tutti)';
    $Self->{Translation}->{'external (customer)'} = 'esterno (cliente)';
    $Self->{Translation}->{'internal (agent)'} = 'interno (agente)';
    $Self->{Translation}->{'Start day'} = 'Dal giorno ';
    $Self->{Translation}->{'Start month'} = 'Dal mese';
    $Self->{Translation}->{'Start year'} = 'Dall\'anno';
    $Self->{Translation}->{'End day'} = 'Al giorno';
    $Self->{Translation}->{'End month'} = 'Al mese';
    $Self->{Translation}->{'End year'} = 'All\'anno';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Grazie per il tuo voto!';
    $Self->{Translation}->{'You have already voted!'} = 'Hai già votato!';
    $Self->{Translation}->{'FAQ Article Print'} = 'Stampa articolo FAQ';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'Articoli FAQ (Primi 10)';
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'Articoli FAQ (nuovi creati)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'Articoli FAQ (recentemente modificati)';
    $Self->{Translation}->{'FAQ category updated!'} = 'Categoria FAQ aggiornata!';
    $Self->{Translation}->{'FAQ category added!'} = 'Categoria FAQ aggiunta!';
    $Self->{Translation}->{'A category should have a name!'} = 'Una categoria deve avere un nome!';
    $Self->{Translation}->{'This category already exists'} = 'Categoria esistente';
    $Self->{Translation}->{'FAQ language added!'} = 'Linguaggio FAQ aggiunto!';
    $Self->{Translation}->{'FAQ language updated!'} = 'Linguaggio FAQ aggiornato!';
    $Self->{Translation}->{'The name is required!'} = 'Il nome è obbligatorio!';
    $Self->{Translation}->{'This language already exists!'} = 'Linguaggio esistente!';
    $Self->{Translation}->{'Symptom'} = '';
    $Self->{Translation}->{'Solution'} = '';

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'Aggiungere articolo FAQ';
    $Self->{Translation}->{'Keywords'} = 'Parole chiave';
    $Self->{Translation}->{'A category is required.'} = 'Una categoria è obbligatoria';
    $Self->{Translation}->{'Approval'} = 'Approvazione';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'Gestioni Categorie FAQ';
    $Self->{Translation}->{'Add category'} = 'Aggiungi categoria';
    $Self->{Translation}->{'Delete Category'} = 'Elimina categoria';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Add Category'} = 'Aggiungi Categoria';
    $Self->{Translation}->{'Edit Category'} = 'Modifica Categoria';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Selezionare almeno un gruppo di permessi.';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Gruppo di tecnici the può accedere agli aritcoli in questa categoria';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Saranno visibili come commenti in Explorer.';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'Si desidera veramente eliminare questa categoria?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        'Non è possibile eliminare questa categoria. Viene utilizzata in almeno un articolo e/o è collegata ad almeno un\'altra categoria';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'Questa categoria è utilizzata nel(i) seguente(i) articoli della FAQ';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'Questa categoria è capogruppo delle seguenti sottocategorie';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'Si desidera veramente eliminare questo articolo di FAQ?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'Esplorartore di FAQ';
    $Self->{Translation}->{'Quick Search'} = 'Ricerca Veloce';
    $Self->{Translation}->{'Wildcards are allowed.'} = 'Wildcard sono permessi.';
    $Self->{Translation}->{'Advanced Search'} = 'Ricerca Avanzata';
    $Self->{Translation}->{'Subcategories'} = 'Sottocategorie';
    $Self->{Translation}->{'FAQ Articles'} = 'Articoli FAQ';
    $Self->{Translation}->{'No subcategories found.'} = 'Nessuna sottocategoria trovata.';

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'Nessun dato trovato nel Riepilogo FAQ.';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'Gestione Linguaggio FAQ';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languges.'} =
        'Utilizzare questa funzione se si desidera lavorare con più lingue.';
    $Self->{Translation}->{'Add language'} = 'Aggiungi lingua';
    $Self->{Translation}->{'Delete Language %s'} = 'Elimina Lingua %s';
    $Self->{Translation}->{'Add Language'} = 'Aggiungi Lingua';
    $Self->{Translation}->{'Edit Language'} = 'Modifica della lingua';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'Si desidera veramente eliminare questa lingua?';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        'Non è possibile eliminare questa lingua. E\' utilizzata in almeno un articolo della FAQ!';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'Questo linguaggio è utilizzato nel(i) seguente(i) articoli della FAQ';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Impostazioni di contesto';
    $Self->{Translation}->{'FAQ articles per page'} = 'Articoli FAQ per pagina';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'Nessun dato della FAQ trovato.';

    # Template: AgentFAQPrint
    $Self->{Translation}->{'FAQ-Info'} = 'FAQ-Info';
    $Self->{Translation}->{'Votes'} = 'Voti';
    $Self->{Translation}->{'Last update'} = 'Ultimo aggiornamento';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = 'Parola chiave';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = 'Voto (es: Uguale 10 o Maggiore di 60)';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = 'Percentuale (es: Uguale 25% o Maggiore di 75%)';
    $Self->{Translation}->{'Approved'} = 'Approvato';
    $Self->{Translation}->{'Last changed by'} = 'Ultima modifica effettuata da';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = 'Istante di creazione dell\'Articolo FAQ (prima/dopo)';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = 'Istante di creazione dell\'Articolo FAQ (fra)';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = 'Istante di modifica dell\'Articolo FAQ (prima/dopo)';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = 'Istante di modifica dell\'Articolo FAQ (fra)';

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'FAQFullText';

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'Cerca nelle FAQ';
    $Self->{Translation}->{'Profile Selection'} = 'Seleziona Profilo';
    $Self->{Translation}->{'Vote'} = 'Voto';
    $Self->{Translation}->{'No vote settings'} = 'Nessuna impostazione voto';
    $Self->{Translation}->{'Specific votes'} = 'Voti specifici';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = 'es. Uguale a 10 o Maggiore di 60';
    $Self->{Translation}->{'Rate'} = 'Percentuale';
    $Self->{Translation}->{'No rate settings'} = 'Non ci sono impostazioni sulla percentuale';
    $Self->{Translation}->{'Specific rate'} = 'Percentuale specifica';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = 'es. Uguale a 25% o Maggiore di 75%';
    $Self->{Translation}->{'FAQ Article Create Time'} = 'Istante di Creazione dell\'Articolo FAQ';
    $Self->{Translation}->{'Specific date'} = 'Data specifica';
    $Self->{Translation}->{'Date range'} = 'Periodo';
    $Self->{Translation}->{'FAQ Article Change Time'} = 'Istante di modifica dell\'Articolo FAQ';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'Informazioni sulle FAQ';
    $Self->{Translation}->{'Rating'} = 'Valutazione';
    $Self->{Translation}->{'out of 5'} = 'su 5';
    $Self->{Translation}->{'No votes found!'} = 'Nessun voto trovato!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Nessun voto trovato! Puoi essere il primo a votare questa FAQ.';
    $Self->{Translation}->{'Download Attachment'} = 'Scarica Allegato';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        '';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        'Vi è stato utile questo articolo? Vi preghiamo di dare un voto per contribuire a migliorare il Database delle FAQ. Grazie!';
    $Self->{Translation}->{'not helpful'} = 'non è stato utile';
    $Self->{Translation}->{'very helpful'} = 'molto utile';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Add FAQ title to article subject'} = 'Aggiungi il titolo della FAQ nel soggetto dell\'articolo';
    $Self->{Translation}->{'Insert FAQ Text'} = 'Inserisci il testo della FAQ';
    $Self->{Translation}->{'Insert Full FAQ'} = 'Inserisci una FAQ completa';
    $Self->{Translation}->{'Insert FAQ Link'} = 'Inserisci FAQ Link';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'Inserire Testo e link della FAQ';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = 'Inserire la FAQ completa e il Link';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'Nessun articolo FAQ trovato.';

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Ricerca testuale negli articoli FAQ (ad esempio "John*n" or "Will*")';
    $Self->{Translation}->{'Vote restrictions'} = 'Restrizioni sul Voto';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = 'Solo articoli di FAQ con voti...';
    $Self->{Translation}->{'Rate restrictions'} = 'Restrizioni sulle percentuali';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = 'Solo articoli di FAQ con percentuale...';
    $Self->{Translation}->{'Only FAQ articles created'} = 'Solo articoli di FAQ creati';
    $Self->{Translation}->{'Only FAQ articles created between'} = 'Solo articoli di FAQ creati fra';
    $Self->{Translation}->{'Search-Profile as Template?'} = 'Profilo di Ricerca come Modello?';

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = 'Numero Articolo';
    $Self->{Translation}->{'Search for articles with keyword'} = 'Cerca articoli con parola chiave';

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = 'Pubblico';

    # Template: PublicFAQSearchResultShort
    $Self->{Translation}->{'Back to FAQ Explorer'} = '';

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} =
        'Un filtro per l\'output HTML per aggiungere collegamenti ad una stringa definita. L\'elemento Immagine permette due tipi di ingresso. Primo il nome di un\'immagine (ad esempio faq.png). In questo caso verrà utilizzato il percorso delle immagini di OTRS. La seconda possibilità è quella di inserire il collegamento all\'immagine.';
    $Self->{Translation}->{'CSS color for the voting result.'} = 'Colore CSS per il risultato del voto.';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = 'Tempo di durata nella Cache delle voci di FAQ';
    $Self->{Translation}->{'Category Management'} = 'Category Management';
    $Self->{Translation}->{'Decimal places of the voting result.'} = 'Posizioni decimali del risultato del voto.';
    $Self->{Translation}->{'Default category name.'} = 'Nome Predefinito della categoria.';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = 'Lingua predefinita per gli articoli  FAQ per la modalità singola lingua.';
    $Self->{Translation}->{'Default maximum size of the titles in a FAQ article to be shown.'} =
        '';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        'Priorità predefinita dei ticket per l\'approvazione di articoli FAQ.';
    $Self->{Translation}->{'Default state for FAQ entry.'} = 'Stato di default per la voce delle FAQ.';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'Stato Predefinito dei ticket per l\'approvazione di articoli FAQ.';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = 'Tipo predefinito dei ticket per l\'approvazione di articoli FAQ.';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} =
        'Il valore predefinito per il parametro Azione per il frontend pubblico. Il parametro Azione viene utilizzato negli script del sistema.';
    $Self->{Translation}->{'Define if the FAQ title should be concatenated to article subject.'} =
        'Definisce se il titolo FAQ dovrebbe essere concatenato con l\'oggetto dell\'articolo.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} =
        '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} =
        'Definisce un modulo panoramica per mostrare la vista piccola di una lista di FAQ.';
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
        'Definisce l\'ordine FAQ predefinito nel risultato FAQ Explorer dell\'interfaccia cliente. Up: più antico sulla parte superiore. Giù: più recente in cima.';
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
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed. Note: AgentTicketActionCommon includes AgentTicketNote, AgentTicketClose, AgentTicketFreeText, AgentTicketOwner, AgentTicketPending, AgentTicketPriority and AgentTicketResponsible.'} =
        '';
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
    $Self->{Translation}->{'Language Management'} = '';
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
