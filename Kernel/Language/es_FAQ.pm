# --
# Kernel/Language/es_FAQ.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: es_FAQ.pm,v 1.27 2011-01-24 10:37:17 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_FAQ;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAFAQ
    $Self->{Translation}->{'internal'} = 'interno';
    $Self->{Translation}->{'public'} = 'público';
    $Self->{Translation}->{'external'} = 'externo';
    $Self->{Translation}->{'FAQ Number'} = 'Número de FAQ';
    $Self->{Translation}->{'LatestChangedItems'} = 'Ultimos artículos modificados';
    $Self->{Translation}->{'LatestCreatedItems'} = 'Ultimos artículos creados';
    $Self->{Translation}->{'Top10Items'} = 'Top 10 artículos';
    $Self->{Translation}->{'SubCategoryOf'} = 'Sub Categoria de';
    $Self->{Translation}->{'No rate selected!'} = 'No selecciono puntaje!';
    $Self->{Translation}->{'public (all)'} = 'público (todos)';
    $Self->{Translation}->{'external (customer)'} = 'externo (cliente)';
    $Self->{Translation}->{'internal (agent)'} = 'interno (agente)';
    $Self->{Translation}->{'StartDay'} = 'Start day';
    $Self->{Translation}->{'StartMonth'} = 'Start month';
    $Self->{Translation}->{'StartYear'} = 'Start year';
    $Self->{Translation}->{'EndDay'} = 'End day';
    $Self->{Translation}->{'EndMonth'} = 'End month';
    $Self->{Translation}->{'EndYear'} = 'End year';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Gracias por su voto!';
    $Self->{Translation}->{'You have already voted!'} = 'Usted ya ha votado!';
    $Self->{Translation}->{'FAQ Article Print'} = 'Imprimir Artículo FAQ';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'Noticias FAQ (Top 10)';
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'Noticias FAQ (creado nuevo)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'Noticias FAQ (Recientemente modificado)';
    $Self->{Translation}->{'FAQ category updated!'} = 'Categoría de FAQ actualizada';
    $Self->{Translation}->{'FAQ category added!'} = 'Categoría de FAQ agregada';
    $Self->{Translation}->{'A category should have a name!'} = 'Una categoría debe tener un nombre!';
    $Self->{Translation}->{'This category already exists'} = '';
    $Self->{Translation}->{'FAQ language added!'} = 'Idioma de FAQ agregado';
    $Self->{Translation}->{'FAQ language updated!'} = 'Idioma de FAQ actualizado!';
    $Self->{Translation}->{'The name is required!'} = 'El nombre es requerido';
    $Self->{Translation}->{'This language already exists!'} = 'Este idioma ya existe!';

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'Agregar Artículo FAQ.';
    $Self->{Translation}->{'A category is required.'} = 'La categoría es requerida.';
    $Self->{Translation}->{'Approval'} = 'Aprovación';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'Administración de Categorías de FAQ';
    $Self->{Translation}->{'Add category'} = 'Agregar categoría';
    $Self->{Translation}->{'Delete Category'} = 'Borrar Categoría';
    $Self->{Translation}->{'Ok'} = 'Aceptar';
    $Self->{Translation}->{'Add Category'} = 'Agregar Categoría';
    $Self->{Translation}->{'Edit Category'} = 'Editar Categoría';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Seran mostrados como comentarios en el explorador.';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Por favor seleccione al menos un grupo de permisos';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Grupos de agentes que pueden acceder a los artículos de esta categoría';
    $Self->{Translation}->{'Do you really want to delete this category?'} = '¿Está seguro de querer borrar esta categoría?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} = 'No puede borrar esta categoría. Está siendo usada por al menos un artículo FAQ y/o es padre de al menos otra categoría';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'Esta categoría esta siendo usada por los siguientes artículos FAQ';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'Esta categoría es padre de las siguientes SubCategorías';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = '¿Está seguro de querer borrar este artículo FAQ?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'Explorador FAQ';
    $Self->{Translation}->{'Quick Search'} = 'Búsqueda Rápida';
    $Self->{Translation}->{'Advanced Search'} = 'Búsqueda Avanzada';
    $Self->{Translation}->{'Subcategories'} = 'Subcategorías';
    $Self->{Translation}->{'FAQ Articles'} = 'Artículos FAQ';
    $Self->{Translation}->{'No subcategories found.'} = 'No se encontraron subcategorías.';

    # Template: AgentFAQHistory

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'No se encontraron datos en la Bitácora FAQ';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'Administración de Idiomas de FAQ';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languges.'} = 'Utilice esta funcionalidad si desea trabajar con múltiples idiomas.';
    $Self->{Translation}->{'Add language'} = 'Agregar idioma';
    $Self->{Translation}->{'Delete: '} = 'Borrar: ';
    $Self->{Translation}->{'Delete Language'} = 'Borrar Idioma';
    $Self->{Translation}->{'Add Language'} = 'Agregar Idioma';
    $Self->{Translation}->{'Edit Language'} = 'Editar Idioma';
    $Self->{Translation}->{'Do you really want to delete this language?'} = '¿Está seguro de querer borrar este idioma?';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} = 'No puede borrar este idioma. Está siendo usado por al menos un artículo FAQ';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'Este idioma esta siendo usado por los siguientes Artículos FAQ';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Configuraciones del Contexto';
    $Self->{Translation}->{'FAQ articles per page'} = 'Artículos FAQ por página';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'No se encontraron registros FAQ.';

    # Template: AgentFAQPrint
    $Self->{Translation}->{'FAQ-Info'} = 'Información-FAQ';
    $Self->{Translation}->{'Votes'} = 'Votos';

    # Template: AgentFAQSearch

    # Template: AgentFAQSearchOpenSearchDescriptionFAQNumber

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'Texto Completo FAQ';

    # Template: AgentFAQSearchResultPrint

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'Búsqueda FAQ';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'Información del Artículo FAQ';
    $Self->{Translation}->{'Rating'} = 'Valoración';
    $Self->{Translation}->{'Rating %'} = 'Valoracion %';
    $Self->{Translation}->{'out of 5'} = 'de 5';
    $Self->{Translation}->{'No votes found!'} = 'No se encontraron votos!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'No se encontraron votos! Sea el primero en valorar este artículo FAQ';
    $Self->{Translation}->{'Download Attachment'} = 'Descargar Adjunto';
    $Self->{Translation}->{'ArticleVotingQuestion'} = '¿Qué tan útil fue este artículo? Por favor, dénos su valoración y ayude a mejorar la base de datos de FAQ. Gracias.';
    $Self->{Translation}->{'not helpful'} = 'poco útil';
    $Self->{Translation}->{'very helpful'} = 'muy útil';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Insert FAQ Text'} = 'Insertar Texto del FAQ';
    $Self->{Translation}->{'Insert FAQ Link'} = 'Insertar Vínculo al FAQ';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'Insertar Texto y Vínculo al FAQ';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'No se encontraron artículos FAQ';

    # Template: CustomerFAQPrint

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Búsqueda de texto completo en artículos FAQ (ej: "John*n" o "Will*")';

    # Template: CustomerFAQSearchOpenSearchDescription

    # Template: CustomerFAQSearchResultPrint

    # Template: CustomerFAQSearchResultShort

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Details'} = 'Detalles';
    $Self->{Translation}->{'Search for articles with keyword'} = 'Buscar artículos con la palabra clave';

    # Template: PublicFAQExplorer

    # Template: PublicFAQPrint

    # Template: PublicFAQSearch

    # Template: PublicFAQSearchOpenSearchDescription
    $Self->{Translation}->{'Public'} = 'Público';

    # Template: PublicFAQSearchResultPrint

    # Template: PublicFAQSearchResultShort

    # Template: PublicFAQZoom

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} = 'Filtro para el HTML resultante para agregar vínculos a una cadena determinada. El elemento Imagen contempla dos tipos de registros. El primero es el nombre de una imagen (por ejemplo faq.png). En este caso se utilizará la ruta de imágenes de OTRS. El segundo es un vínculo a una imagen externa.';
    $Self->{Translation}->{'CSS color for the voting result.'} = 'Color CSS para el resultado de la votación.';
    $Self->{Translation}->{'Category Management'} = 'Administración de Categorías';
    $Self->{Translation}->{'Decimal places of the voting result.'} = 'Número de decimales para el resultado de la votación';
    $Self->{Translation}->{'Default category name.'} = 'Nombre de categoría por omisión';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = 'Idioma por omisión para los artículos FAQ en modo idioma simple';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} = 'Prioridad por omisión de los tickets para aprobación de los artículos FAQ.';
    $Self->{Translation}->{'Default state for FAQ entry.'} = 'Estado por omisión para los artículos FAQ.';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'Estado por omisión de los tickets para aprobación de los artículos FAQ.';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} = 'Valor por omisión para el parámetro "Action" para el "fronend" público. El parámetro "Action" es usado do en los "scripts" del sistema.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} = 'Define un módulo de tipo resumen para mostrar la vista corta de la bitácora de FAQ';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} = 'Define un módulo tipo resumen para mostrar la vista corta de un listado de FAQs';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ Explorer of the agent interface.'} = 'Define el atributo por omisión para ordenar los artículos FAQ en el Explorador FAQ en la interface del agente.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} = 'Define el atributo por omisión para ordenar los artículos FAQ en una búsqeda de FAQ en la interface del agente.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} = 'Define el atributo por omisión para ordenar los artículos FAQ en una búsqeda de FAQ en la interface del cliente.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} = 'Define el atributo por omisión para ordenar los artículos FAQ en una búsqeda de FAQ en la interface pública.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the explorer in the customer interface.'} = 'Define el atributo por omisión para ordenar los artículos FAQ en el Explorador FAQ en la interface del cliente.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the explorer in the public interface.'} = 'Define el atributo por omisión para ordenar los artículos FAQ en el Explorador FAQ en la interface pública.';
    $Self->{Translation}->{'Defines the default FAQ order in the explorer in the customer interface. Up: oldest on top. Down: latest on top.'} = 'Define el sentido del orden por omisión en el resultado del Explorador FAQ en la interface del cliente. Arriba: los más antiguos en la parte superior. Abajo: los últimos en la parte superior.';
    $Self->{Translation}->{'Defines the default FAQ order in the explorer in the public interface. Up: oldest on top. Down: latest on top.'} = 'Define el sentido del orden por omisión en el resultado del Explorador FAQ en la interface pública. Arriba: los más antiguos en la parte superior. Abajo: los últimos en la parte superior.';
    $Self->{Translation}->{'Defines the default FAQ order of a Explorer result in the agent interface. Up: oldest on top. Down: latest on top.'} = 'Define el sentido del orden por omisión en el resultado del Explorador FAQ en la interface del agente. Arriba: los más antiguos en la parte superior. Abajo: los últimos en la parte superior.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} = 'Define el sentido del orden por omisión en el resultado de una búsqueda en la interface del agente. Arriba: los más antiguos en la parte superior. Abajo: los últimos en la parte superior.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} = 'Define el sentido del orden por omisión en el resultado de una búsqueda en la interface del cliente. Arriba: los más antiguos en la parte superior. Abajo: los últimos en la parte superior.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} = 'Define el sentido del orden por omisión en el resultado de una búsqueda en la interface pública. Arriba: los más antiguos en la parte superior. Abajo: los últimos en la parte superior.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} = 'Define las columnas que se mostrarán en el Explorador FAQ. Esta opción no tiene efectos en la posición de las columnas.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} = 'Define las columnas que se mostrarán en la bitácora de FAQ. Esta opción no tiene efectos en la posición de las columnas.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} = 'Define las columnas que se mostrarán en la búsqueda FAQ. Esta opción no tiene efectos en la posición de las columnas.';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed. Note: AgentTicketActionCommon includes AgentTicketNote, AgentTicketClose, AgentTicketFreeText, AgentTicketOwner, AgentTicketPending, AgentTicketPriority and AgentTicketResponsible.'} = 'Define dónde se mostrará el vínculo \'Insertar FAQ\'. Nota: AgentTicketActionCommon incluye AgentTicketNote, AgentTicketClose, AgentTicketFreeText, AgentTicketOwner, AgentTicketPending, AgentTicketPriority y AgentTicketResponsible.';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = 'Definición del campo "free text" para los artículos FAQ.';
    $Self->{Translation}->{'Delete this FAQ'} = 'Borrar este artículo FAQ';
    $Self->{Translation}->{'Edit this FAQ'} = 'Editar este artículo FAQ';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = 'Habilitar múltiples idiomas en el módulo FAQ';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = 'Habilitar el mecanismo de valoración en el módulo FAQ';
    $Self->{Translation}->{'FAQ Journal'} = 'Bitácora de FAQ';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = 'Límite para la vista tipo resumen "Corto" de la Bitácora de FAQ';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = 'Límite para la vista tipo resumen "Corto" de FAQ';
    $Self->{Translation}->{'FAQ limit per page for FAQ Journal Overview "Small"'} = 'Límite por página para la vista tipo resumen "Corto" de la Bitácora de FAQ';
    $Self->{Translation}->{'FAQ limit per page for FAQ Overview "Small"'} = 'Límite por página para la vista tipo resumen "Corto" de FAQ';
    $Self->{Translation}->{'FAQ path separator.'} = 'Separador de la ruta de FAQ.';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = 'Enrutador para la búsqueda de FAQ en la interface del agente.';
    $Self->{Translation}->{'FAQ-Area'} = 'Área-FAQ';
    $Self->{Translation}->{'Frontend module registration for the public interface.'} = 'Registro de módulo "Frontend" en la interface pública.';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = 'Grupo para la aprobación de los artículos FAQ.';
    $Self->{Translation}->{'History of this FAQ'} = 'Historia de este artículo FAQ';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = 'Incluir campos internos en los tickets basados en un artículo FAQ';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = 'Incluir el nombre de cada campo en los tickets basados en un artículo FAQ';
    $Self->{Translation}->{'Interfaces where the quicksearch should be shown.'} = 'Interfaces donde la Busqueda Rápida debe ser mostrada.';
    $Self->{Translation}->{'Journal'} = 'Bitácora';
    $Self->{Translation}->{'Language Management'} = 'Administración de Idiomas';
    $Self->{Translation}->{'Languagekey which is defined in the language file *_FAQ.pm.'} = 'La clave se encuentra definida en el archivo de idioma *_FAQ.pm.';
    $Self->{Translation}->{'Link another object to this FAQ item'} = 'Vincular otro objecto a este artículo FAQ';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} = 'Número máximo de artículos FAQ a ser mostrados en la bitácora de FAQ en la interface del agente.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the explorer in the customer interface.'} = 'Número máximo de artículos FAQ a ser mostrados dentro del explorador en la interface del cliente.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the explorer in the public interface.'} = 'Número máximo de artículos FAQ a ser mostrados dentro del explorador en la interface pública.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a Explorer in the agent interface.'} = 'Número máximo de artículos FAQ a ser mostrados como resultado del Explorador FAQ en la interface del agente.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} = 'Número máximo de artículos FAQ a ser mostrados como resultado de una búsqueda en la interface del agente.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} = 'Número máximo de artículos FAQ a ser mostrados como resultado de una búsqueda en la interface del cliente.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} = 'Número máximo de artículos FAQ a ser mostrados como resultado de una búsqueda en la interface pública.';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search.'} = 'Módulo para generar el perfil html "OpenSearch" para búsquedas cortas de FAQ.';
    $Self->{Translation}->{'New FAQ Article'} = 'Nuevo FAQ';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = '¿Los nuevos artículos FAQ requieren aprobación antes de ser publicados?';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in each page of a search result in the customer interface.'} = 'Número de artículos FAQ a ser mostrados por cada página como resultado de una búsqueda en la interface del cliente.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in each page of a search result in the public interface.'} = 'Número de artículos FAQ a ser mostrados por cada página como resultado de una búsqueda en la interface pública.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the explorer in the customer interface.'} = 'Número de artículos FAQ a ser mostrados dentro del explorador en la interface del cliente.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the explorer in the public interface.'} = 'Número de artículos FAQ a ser mostrados dentro del explorador en la interface pública.';
    $Self->{Translation}->{'Number of shown items in last changes.'} = 'Número de últimos artículos actualizados que se mostrarán.';
    $Self->{Translation}->{'Number of shown items in last created.'} = 'Número de últimos artículos creados que se mostrarán.';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = 'Número de artículos que se mostrarán en el Top 10.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} = 'Parámetros de las páginas (donde se muestran los artículos FAQ) de la vista tipo resumen corto de la bitácora de FAQ.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} = 'Parámetros de las páginas (donde se muestran los artículos FAQ) de la vista tipo resumen corto.';
    $Self->{Translation}->{'Print this FAQ'} = 'Imprimir este artículo FAQ';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = 'Fila para la aprobación de los artículos FAQ.';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = 'Rangos para la votación. La llave debe estar expresada en porcentajes.';
    $Self->{Translation}->{'Search FAQ'} = 'Búsqueda FAQ';
    $Self->{Translation}->{'Show "Insert Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} = 'Mostrar el Botón "Insertar Vínculo" en AgentFAQZoomSmall para artículos FAQ públicos';
    $Self->{Translation}->{'Show "Insert Text & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} = 'Mostrar el Botón "Insertar Texto & Vínculo" en AgentFAQZoomSmall para artículos FAQ públicos';
    $Self->{Translation}->{'Show "Insert Text" Button in AgentFAQZoomSmall.'} = 'Mostrar el Botón "Insertar Texto" en AgentFAQZoomSmall para artículos FAQ públicos';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = '¿Mostrar contenido HTML en los artículos FAQ?.';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = '¿Mostrar la ruta del FAQ? si/no.';
    $Self->{Translation}->{'Show WYSIWYG editor in agent interface.'} = 'Mostrar el editor WYSIWYG en la interface del agente.';
    $Self->{Translation}->{'Show items of subcategories.'} = '¿Mostrar los artículos de las subcategorías? si/no.';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = 'Mostrar los últimos artículos actualizados en las interfaces definidas.';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = 'Mostrar los últimos artículos creados en las interfaces definidas.';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = 'Mostrar artículos Top 10 en las interfaces definidas.';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = 'Mostrar la votación en las interfaces definidas.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'} = 'Muestra un vínculo en el menú que permite vínculor un artículo FAQ con otros objetos en su vista de detalles en la interface del agente.';
    $Self->{Translation}->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'} = 'Muestra un vínculo en el menú que permite borrar un artículo FAQ en su vista de detalles en la interface del agente.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface.'} = 'Muestra un vínculo en el menú para acceder al historial de un artículo FAQ en su vista de detalles en la interface del agente.';
    $Self->{Translation}->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'} = 'Muestra un vínculo en el menú para editar un artículo FAQ en su vista de detalles en la interface del agente.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'} = 'Muestra un vínculo en el menú para ir hacia atras en la vista de detalles de FAQ en la interface del agente.';
    $Self->{Translation}->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'} = 'Muestra un vínculo en el menú para imprimir un artículo FAQ en su vista de detalles en la interface del agente.';
    $Self->{Translation}->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'} = 'El identificador para un FAQ, por ejemplo FAQ#, KB#, MiFAQ#. FAQ# es la opción por omisión';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'} = 'Este ajuste define que un objeto \'FAQ\' puede vincularse con otros objetos \'FAQ\' utilizando el tipo de vínculo \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'} = 'Este ajuste define que un objeto \'FAQ\' puede vincularse con otros objetos \'FAQ\' utilizando el tipo de vínculo \'ParentChild\'.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'} = 'Este ajuste define que un objeto \'FAQ\' puede vincularse con otros objetos \'Ticket\' utilizando el tipo de vínculo \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'} = 'Este ajuste define que un objeto \'FAQ\' puede vincularse con otros objetos \'Ticket\' utilizando el tipo de vínculo \'ParentChild\'.';
    $Self->{Translation}->{'Ticket body for approval of FAQ article.'} = 'Cuepo del Ticket para aprobación de artículos FAQ.';
    $Self->{Translation}->{'Ticket subject for approval of FAQ article.'} = 'Asunto del Ticket para aprobación de artículos FAQ.';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'A category needs at least one permission group!'} = 'Una categoría debe tener al menos un grupo de permisos';
    $Self->{Translation}->{'A category should have a comment!'} = 'Una categoría debe tener un comentario!';
    $Self->{Translation}->{'Agent groups which can access this category.'} = 'Los grupos agentes pueden acceder a esta categoría';
    $Self->{Translation}->{'Articles'} = 'Artículos';
    $Self->{Translation}->{'Categories'} = 'Categorias';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed.'} = 'Define dónde es que la liga \'Insertar FAQ\' será desplegada.';
    $Self->{Translation}->{'DetailSearch'} = 'Busqueda detallada';
    $Self->{Translation}->{'Do you really want to delete this Category?'} = '¿Está seguro de querer borrar esta Categoría?';
    $Self->{Translation}->{'Do you really want to delete this Language?'} = '¿Está seguro de querer borrar este Idioma?';
    $Self->{Translation}->{'FAQ Category'} = 'Categoría de FAQ';
    $Self->{Translation}->{'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'} = 'No se puede acceder a ninguna categoría. Para crear un articulo usted debe tener acceso a mínimo una categoría. Por favor revise sus permisos de grupo/categoría en el -menú categoría-!';
    $Self->{Translation}->{'QuickSearch'} = 'Busqueda rápida';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface'} = 'Muestra un liga en el menú para acceder al historial de un artículo FAQ en su vista de detalles en la interface del agente.';
    $Self->{Translation}->{'SubCategories'} = 'Subcategorias';
    $Self->{Translation}->{'The title is required.'} = 'El título es requerido.';
    $Self->{Translation}->{'This Category is parent of the following SubCategories'} = 'Esta Categoría es padre de las siguientes SubCategorías';
    $Self->{Translation}->{'This Category is used in the following FAQ Artice(s)'} = 'Esta Categoría esta siendo usada por los siguientes Artículos FAQ';
    $Self->{Translation}->{'This Language is used in the following FAQ Article(s)'} = 'Este Idioma esta siendo usado por los siguientes Artículos FAQ';
    $Self->{Translation}->{'This category already exists!'} = 'Esta categoría ya existe';
    $Self->{Translation}->{'Updated'} = 'Actualizado';
    $Self->{Translation}->{'You can not delete this Category. It is used in at least one FAQ Article! and/or is parent of at least another Category'} = 'No puede borrar esta Categoría. Está siendo usada por al menos un Artículo FAQ y/o es padre de al menos otra Categoría';
    $Self->{Translation}->{'You can not delete this Language. It is used in at least one FAQ Article!'} = 'No puede borrar este Idioma. Está siendo usado por al menos un Artículo FAQ';

}

1;
