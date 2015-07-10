# --
# Kernel/Language/fr_FAQ.pm - translation file
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr_FAQ;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAFAQ
    $Self->{Translation}->{'internal'} = 'interne';
    $Self->{Translation}->{'public'} = 'publi';
    $Self->{Translation}->{'external'} = 'externe';
    $Self->{Translation}->{'FAQ Number'} = 'Numéro de FAQ';
    $Self->{Translation}->{'Latest updated FAQ articles'} = 'Dernières questions modifiées';
    $Self->{Translation}->{'Latest created FAQ articles'} = 'Dernières questions créées';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Top 10 des questions';
    $Self->{Translation}->{'Subcategory of'} = 'Sous catégorie de';
    $Self->{Translation}->{'No rate selected!'} = 'Pas de sélection !';
    $Self->{Translation}->{'Explorer'} = 'Explorateur';
    $Self->{Translation}->{'public (all)'} = 'public (tous)';
    $Self->{Translation}->{'external (customer)'} = 'externe (client)';
    $Self->{Translation}->{'internal (agent)'} = 'interne (opérateur)';
    $Self->{Translation}->{'Start day'} = 'Jour de départ';
    $Self->{Translation}->{'Start month'} = 'Mois de départ';
    $Self->{Translation}->{'Start year'} = 'Année de Départ';
    $Self->{Translation}->{'End day'} = 'Jour de Fin';
    $Self->{Translation}->{'End month'} = 'Mois de Fin';
    $Self->{Translation}->{'End year'} = 'Année de Fin';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Merci pour votre vote !';
    $Self->{Translation}->{'You have already voted!'} = 'Vous avez déjà voté !';
    $Self->{Translation}->{'FAQ Article Print'} = 'Imprimer Article de FAQ';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'Articles de FAQ (Top 10)';
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'Articles de FAQ (nouvelles questions)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'Articles de FAQ (derniers changements)';
    $Self->{Translation}->{'FAQ category updated!'} = 'Catégorie de FAQ mise à jour!';
    $Self->{Translation}->{'FAQ category added!'} = 'Catégorie de FAQ ajoutée!';
    $Self->{Translation}->{'A category should have a name!'} = 'Une catégorie devrait avoir un nom!';
    $Self->{Translation}->{'This category already exists'} = 'Cette catégorie existe déjà!';
    $Self->{Translation}->{'FAQ language added!'} = 'Langue de FAQ ajouté!';
    $Self->{Translation}->{'FAQ language updated!'} = 'Langue de FAQ mise à jour!';
    $Self->{Translation}->{'The name is required!'} = 'Le nom est requis!';
    $Self->{Translation}->{'This language already exists!'} = 'Cette langue existe déjà!';
    $Self->{Translation}->{'Symptom'} = 'Symptôme';
    $Self->{Translation}->{'Solution'} = 'Solution';

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'Ajouter Article de FAQ';
    $Self->{Translation}->{'Keywords'} = 'Mots-clés';
    $Self->{Translation}->{'A category is required.'} = 'Une catégorie est requise';
    $Self->{Translation}->{'Approval'} = 'Autorisation';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'Gestion Catégories de FAQ';
    $Self->{Translation}->{'Add category'} = 'Ajout Catégorie';
    $Self->{Translation}->{'Delete Category'} = 'Effacer Catégorie';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Add Category'} = 'Ajout Catégorie';
    $Self->{Translation}->{'Edit Category'} = 'Editer Catégorie';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Merci de Sélectionner au moins un groupe de permission.';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Groupes d\'agents pouvant accéder aux articles de cette catégorie.';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Sera affiché comme un commentaire dans l\'Explorer.';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'Voulez-vous vraiment effacer cette catégorie?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        'Impossible d\'effacer cette catégorie. Elle est utilisée dans au moins un article de FAQ et/ou est parente d\'au moins une autre catégorie.';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'Cette catégorie est utilisée dans les articles de FAQ suivants';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'Cette catégorie est parente';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'Voulez-vous vraiment effacer cet article de FAQ?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'Navigateur FAQ';
    $Self->{Translation}->{'Quick Search'} = 'Recherche rapide';
    $Self->{Translation}->{'Wildcards are allowed.'} = 'Les métacaractères sont autorisés';
    $Self->{Translation}->{'Advanced Search'} = 'Recherche Avancée';
    $Self->{Translation}->{'Subcategories'} = 'Sous-catégories';
    $Self->{Translation}->{'FAQ Articles'} = 'Articles de FAQ';
    $Self->{Translation}->{'No subcategories found.'} = 'Pas de sous-catégorie trouvée.';

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'Pas de journal de données FAQ trouvé';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'Gestion Langue FAQ';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languges.'} =
        'Utiliser cette fonction afin de travailler avec de multiples langues';
    $Self->{Translation}->{'Add language'} = 'Ajouter une langue';
    $Self->{Translation}->{'Delete Language %s'} = 'Effacer une langue %s';
    $Self->{Translation}->{'Add Language'} = 'Ajouter une langue';
    $Self->{Translation}->{'Edit Language'} = 'Editer la langue';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'Voulez-vous vraiment effacer cette langue';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        'Impossible d\'effacer cette langue. Elle est utilisée dans au moins un article de FAQ';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'Cette langue est utilisée dans les articles FAQ suivants';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Réglages de Contexte';
    $Self->{Translation}->{'FAQ articles per page'} = 'Articles FAQ par page';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'pas de données FAQ trouvées';

    # Template: AgentFAQPrint
    $Self->{Translation}->{'FAQ-Info'} = 'FAQ-Info';
    $Self->{Translation}->{'Votes'} = 'Votes';
    $Self->{Translation}->{'Last update'} = 'Dernière mise à jour';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = 'Mot-clé';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = 'Vote (ex. EgalA 10 ou SuperieurA 60)';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = 'Note (ex. EgalA 25% ou SuperieurA 75%)';
    $Self->{Translation}->{'Approved'} = 'Approuvé';
    $Self->{Translation}->{'Last changed by'} = 'Dernière modification par';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = '';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = '';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = '';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = '';

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'Texte Intégral FAQ';

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'Recherche dans la FAQ';
    $Self->{Translation}->{'Profile Selection'} = 'Sélection du profil';
    $Self->{Translation}->{'Vote'} = 'Vote';
    $Self->{Translation}->{'No vote settings'} = 'Pas de paramètres de vote';
    $Self->{Translation}->{'Specific votes'} = 'Vote spécifique';
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
    $Self->{Translation}->{'FAQ Information'} = 'Information FAQ';
    $Self->{Translation}->{'Rating'} = 'Cote';
    $Self->{Translation}->{'out of 5'} = 'sur 5';
    $Self->{Translation}->{'No votes found!'} = 'Aucun vote trouvé!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Soyez le premier à noter cete article de FAQ';
    $Self->{Translation}->{'Download Attachment'} = 'Télécharger Fichier Joint';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        '';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        'Cet Article était-il utile? Merci de donner une note et de participer à l\'amélioration de la base de données. Merci!';
    $Self->{Translation}->{'not helpful'} = 'peu utile';
    $Self->{Translation}->{'very helpful'} = 'très utile';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Add FAQ title to article subject'} = 'Ajouter un titre de la FAQ au sujet de l\'article';
    $Self->{Translation}->{'Insert FAQ Text'} = 'Insérer Texte dans la FAQ';
    $Self->{Translation}->{'Insert Full FAQ'} = 'Insérer toute la FAQ';
    $Self->{Translation}->{'Insert FAQ Link'} = 'Insérer Lien dans la FAQ';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'Insérer Texte & Lien dans la FAQ';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = '';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'Pas d\'article de FAQ trouvé.';

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Recherche texte intégrale dans les articles FAQ (ex. "Emilie*")';
    $Self->{Translation}->{'Vote restrictions'} = 'Restrictions de vote';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = '';
    $Self->{Translation}->{'Rate restrictions'} = '';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = '';
    $Self->{Translation}->{'Only FAQ articles created'} = '';
    $Self->{Translation}->{'Only FAQ articles created between'} = '';
    $Self->{Translation}->{'Search-Profile as Template?'} = '';

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = 'Numéro d\'Article';
    $Self->{Translation}->{'Search for articles with keyword'} = 'Recherche des Articles avec mot clé';

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = 'Public';

    # Template: PublicFAQSearchResultShort
    $Self->{Translation}->{'Back to FAQ Explorer'} = 'Revenir au Navigateur FAQ';

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} =
        '';
    $Self->{Translation}->{'CSS color for the voting result.'} = 'Couleur CSS pour le résultat du vote';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = 'Durée de validité du Cache pour les éléments de la FAQ';
    $Self->{Translation}->{'Category Management'} = 'Gestion des catégories';
    $Self->{Translation}->{'Decimal places of the voting result.'} = '';
    $Self->{Translation}->{'Default category name.'} = 'Nom de catégorie par défaut';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = 'Langue par défaut pour les articles de la FAQ en mode langage unique.';
    $Self->{Translation}->{'Default maximum size of the titles in a FAQ article to be shown.'} =
        'Taille maximum par défaut des titres dans un article de la FAQ à montrer.';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        'Priorité par défaut des tickets pour l\'approbation d\'articles de la FAQ.';
    $Self->{Translation}->{'Default state for FAQ entry.'} = 'Etat par défaut d\'une entrée de la FAQ.';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'Etat par défaut des tickets pour l\'approbation d\'articles de la FAQ.';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = 'Type par défaut des tickets pour l\'approbation d\'articles de la FAQ.';
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
    $Self->{Translation}->{'Delete this FAQ'} = 'Supprimer cette FAQ';
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
    $Self->{Translation}->{'Edit this FAQ'} = 'Modifier cette FAQ';
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
    $Self->{Translation}->{'History of this FAQ'} = 'Historique de cette FAQ';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Interfaces where the quick search should be shown.'} = '';
    $Self->{Translation}->{'Journal'} = 'Journal';
    $Self->{Translation}->{'Language Management'} = 'Gestion des langues';
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
    $Self->{Translation}->{'New FAQ Article'} = 'Nouvel Article FAQ';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = 'Les nouveaux articles FAQ doivent être approuvés avant d\'être publiés';
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
    $Self->{Translation}->{'Print this FAQ'} = 'Imprimer cette FAQ';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = '';
    $Self->{Translation}->{'Search FAQ'} = 'Recherche dans FAQ';
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
    $Self->{Translation}->{'Show items of subcategories.'} = 'Afficher les éléments des sous-catégories';
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
