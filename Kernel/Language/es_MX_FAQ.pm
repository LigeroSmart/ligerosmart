# --
# Kernel/Language/es_MX_FAQ.pm - the spanish (Mexico) translation of FAQ
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Aquiles Cohen
# --
# $Id: es_MX_FAQ.pm,v 1.10 2010-12-01 20:14:02 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

package Kernel::Language::es_MX_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'You have already voted!'}           = 'Usted ya ha votado!';
    $Lang->{'No rate selected!'}                 = 'No selecciono puntaje!';
    $Lang->{'Thanks for your vote!'}             = 'Gracias por su voto!';
    $Lang->{'Votes'}                             = 'Votos';
    $Lang->{'LatestChangedItems'}                = 'Ultimos artículos modificados';
    $Lang->{'LatestCreatedItems'}                = 'Ultimos artículos creados';
    $Lang->{'Top10Items'}                        = 'Top 10 artículos';
    $Lang->{'ArticleVotingQuestion'}             = '¿Qué tan útil fue este artículo? Por favor, dénos su valoración y ayude a mejorar la base de datos de FAQ. Gracias.';
    $Lang->{'SubCategoryOf'}                     = 'Sub Categoria de';
    $Lang->{'QuickSearch'}                       = 'Busqueda rápida';
    $Lang->{'DetailSearch'}                      = 'Busqueda detallada';
    $Lang->{'Categories'}                        = 'Categorias';
    $Lang->{'SubCategories'}                     = 'Subcategorias';
    $Lang->{'New FAQ Article'}                   = 'Nuevo FAQ';
    $Lang->{'FAQ Category'}                      = 'Categoría de FAQ';
    $Lang->{'A category should have a name!'}    = 'Cada categoría debe tener un nombre!';
    $Lang->{'A category should have a comment!'} = 'Cada categoria debe tener un comentario';
    $Lang->{'FAQ Articles (new created)'}        = 'Noticias FAQ (creado nuevo)';
    $Lang->{'FAQ Articles (recently changed)'}   = 'Noticias FAQ (Recientemente modificado)';
    $Lang->{'FAQ Articles (Top 10)'}             = 'Noticias FAQ (Top 10)';
    $Lang->{'StartDay'}                          = 'Start day';
    $Lang->{'StartMonth'}                        = 'Start month';
    $Lang->{'StartYear'}                         = 'Start year';
    $Lang->{'EndDay'}                            = 'End day';
    $Lang->{'EndMonth'}                          = 'End month';
    $Lang->{'EndYear'}                           = 'End year';
    $Lang->{'Approval'}                          = 'Approval';
    $Lang->{'internal'}                          = 'interno';
    $Lang->{'external'}                          = 'externo';
    $Lang->{'public'}                            = 'público';
    $Lang->{
        'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'
        }
        = 'No se puede acceder a ninguna categoría. Para crear un articulo usted debe tener acceso a mínimo una categoría. Por favor revise sus permisos de grupo/categoría en el -menú categoría-!';
    $Lang->{'Agent groups which can access this category.'}
        = 'Los grupos agentes pueden acceder a esta categoría';
    $Lang->{'A category needs at least one permission group!'}
        = 'Una categoria necesita minimo un permiso de grupo!';
    $Lang->{'Will be shown as comment in Explorer.'} = 'Seran mostrados como comentarios en Explorer.';

    $Lang->{'Default category name.'}                            = 'Nombre de categoría por omisión';
    $Lang->{'Rates for voting. Key must be in percent.'}         = 'Rangos para la votación. La llave debe estar expresada en porcentajes.';
    $Lang->{'Show voting in defined interfaces.'}                = 'Mostrar la votación en las interfaces definidas.';
    $Lang->{'Languagekey which is defined in the language file *_FAQ.pm.'}
        = 'La clave se encuentra definida en el archivo de idioma *_FAQ.pm.';
    $Lang->{'Show FAQ path yes/no.'}                             = '¿Mostrar la ruta del FAQ? si/no.';
    $Lang->{'Decimal places of the voting result.'}              = 'Número de decimales para el resultado de la votación';
    $Lang->{'CSS color for the voting result.'}                  = 'Color CSS para el resultado de la votación.';
    $Lang->{'FAQ path separator.'}                               = 'Separador de la ruta del FAQ.';
    $Lang->{'Interfaces where the quicksearch should be shown.'} = 'Interfaces donde la Busqueda Rápida debe ser mostrada.';
    $Lang->{'Show items of subcategories.'}                      = '¿Mostrar los artículos de las subcategorías? si/no.';
    $Lang->{'Show last change items in defined interfaces.'}     = 'Mostrar los últimos artículos actualizados en las interfaces definidas.';
    $Lang->{'Number of shown items in last changes.'}            = 'Número de últimos artículos actualizados que se mostrarán.';
    $Lang->{'Show last created items in defined interfaces.'}    = 'Mostrar los últimos artículos creados en las interfaces definidas.';
    $Lang->{'Number of shown items in last created.'}            = 'Número de últimos artículos creados que se mostrarán.';
    $Lang->{'Show top 10 items in defined interfaces.'}          = 'Mostrar artículos Top 10 en las interfaces definidas.';
    $Lang->{'Number of shown items in the top 10 feature.'}      = 'Número de artículos que se mostrarán en el Top 10.';
    $Lang->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'}
        = 'El identificador para un FAQ, por ejemplo FAQ#, KB#, MiFAQ#. FAQ# es la opción por omisión';
    $Lang->{'Default state for FAQ entry.'}                      = 'Estado por omisión para los artículos FAQ.';
    $Lang->{'Show WYSIWYG editor in agent interface.'}           = 'Mostrar el editor WYSIWYG en la interface del agente.';
    $Lang->{'New FAQ articles need approval before they get published.'}
        = '¿Los nuevos artículos FAQ requieren aprobación antes de ser publicados?';
    $Lang->{'Group for the approval of FAQ articles.'}           = 'Grupo para la aprobación de los artículos FAQ.';
    $Lang->{'Queue for the approval of FAQ articles.'}           = 'Fila para la aprobación de los artículos FAQ.';
    $Lang->{'Ticket subject for approval of FAQ article.'}       = 'Asunto del Ticket para aprobación de artículos FAQ.';
    $Lang->{'Ticket body for approval of FAQ article.'}          = 'Cuepo del Ticket para aprobación de artículos FAQ.';
    $Lang->{'Default priority of tickets for the approval of FAQ articles.'}
        = 'Prioridad por omisión de los tickets para aprobación de los artículos FAQ.';
    $Lang->{'Default state of tickets for the approval of FAQ articles.'}
        = 'Estado por omisión de los tickets para aprobación de los artículos FAQ.';
    $Lang->{'Definition of FAQ item free text field.'}           = 'Definición del campo "free text" para los artículos FAQ.';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'}
        = 'Este ajuste define que un objeto \'FAQ\' puede ligarse con otros objetos \'FAQ\' utilizando el tipo de liga \'Normal\'.';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'}
        = 'Este ajuste define que un objeto \'FAQ\' puede ligarse con otros objetos \'FAQ\' utilizando el tipo de liga \'ParentChild\'.';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'}
        = 'Este ajuste define que un objeto \'FAQ\' puede ligarse con otros objetos \'Ticket\' utilizando el tipo de liga \'Normal\'.';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'}
        = 'Este ajuste define que un objeto \'FAQ\' puede ligarse con otros objetos \'Ticket\' utilizando el tipo de liga \'ParentChild\'.';
    $Lang->{'Frontend module registration for the agent interface.'}    = 'Registro de módulo "Frontend" en la interface del agente.';
    $Lang->{'Frontend module registration for the customer interface.'} = 'Registro de módulo "Frontend" en la interface del cliente.';
    $Lang->{'Frontend module registration for the public interface.'}   = 'Registro de módulo "Frontend" en la interface pública.';
    $Lang->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'}
        = 'Valor por omisión para el parámetro "Action" para el "fronend" público. El parámetro "Action" es usado do en los "scripts" del sistema.';
    $Lang->{'Show FAQ Article with HTML.'}                              = '¿Mostrar contenido HTML en los artículos FAQ?.';
    $Lang->{'Module to generate html OpenSearch profile for short faq search.'}
        = 'Módulo para generar el perfil html "OpenSearch" para búsquedas cortas de FAQ.';
    $Lang->{'Defines where the \'Insert FAQ\' link will be displayed.'} = 'Define dónde es que la liga \'Insertar FAQ\' será desplegada.';
    $Lang->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'}
        = 'Filtro para el HTML resultante para agregar ligas a una cadena determinada. El elemento Imagen contempla dos tipos de registros. El primero es el nombre de una imagen (por ejemplo faq.png). En este caso se utilizará la ruta de imágenes de OTRS. El segundo es una liga a una imagen externa.';
    $Lang->{'FAQ search backend router of the agent interface.'} = 'Enrutador para la búsqueda de FAQ en la interface del agente.';
    $Lang->{'Defines an overview module to show the small view of a FAQ list.'}
        = 'Define un módulo tipo resumen para mostrar la vista corta de un listado de FAQs';
    $Lang->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'}
        = 'Define las columnas que se mostrarán en la búsqueda FAQ. Esta opción no tiene efectos en la posición de las columnas.';
    $Lang->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'}
        = 'Define el atributo por omisión para ordenar los artículos FAQ en una búsqeda de FAQ en la interface del agente.';
    $Lang->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'}
        = 'Define el sentido del orden por omisión en el resultado de una búsqueda en la interface del agente. Arriba: los más antiguos en la parte superior. Abajo: los últimos en la parte superior.';
    $Lang->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'}
        = 'Número máximo de artículos FAQ a ser mostrados como resultado de una búsqueda en la interface del agente.';
    $Lang->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'}
        = 'Define las columnas que se mostrarán en el Explorador FAQ. Esta opción no tiene efectos en la posición de las columnas.';
    $Lang->{'Defines the default FAQ attribute for FAQ sorting in a FAQ Explorer of the agent interface.'}
        = 'Define el atributo por omisión para ordenar los artículos FAQ en el Explorador FAQ en la interface del agente.';
    $Lang->{'Defines the default FAQ order of a Explorer result in the agent interface. Up: oldest on top. Down: latest on top.'}
        = 'Define el sentido del orden por omisión en el resultado del Explorador FAQ en la interface del agente. Arriba: los más antiguos en la parte superior. Abajo: los últimos en la parte superior.';
    $Lang->{'Maximum number of FAQ articles to be displayed in the result of a Explorer in the agent interface.'}
        = 'Número máximo de artículos FAQ a ser mostrados como resultado del Explorador FAQ en la interface del agente.';
    $Lang->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'}
        = 'Parámetros de las páginas (donde se muestran los artículos FAQ) de la vista tipo resumen corto.';
    $Lang->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'}
        = 'Muestra un liga en el menú para ir hacia atras en la vista de detalles de FAQ en la interface del agente.';
    $Lang->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'}
        = 'Muestra un liga en el menú para editar un artículo FAQ en su vista de detalles en la interface del agente.';
    $Lang->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface'}
        = 'Muestra un liga en el menú para acceder al historial de un artículo FAQ en su vista de detalles en la interface del agente.';
    $Lang->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'}
        = 'Muestra un liga en el menú para imprimir un artículo FAQ en su vista de detalles en la interface del agente.';
    $Lang->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'}
        = 'Muestra un liga en el menú que permite ligar un artículo FAQ con otros objetos en su vista de detalles en la interface del agente.';
    $Lang->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'}
        = 'Muestra un liga en el menú que permite borrar un artículo FAQ en su vista de detalles en la interface del agente.';
    $Lang->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'}
        = 'Define el atributo por omisión para ordenar los artículos FAQ en una búsqeda de FAQ en la interface del cliente.';
    $Lang->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'}
        = 'Define el sentido del orden por omisión en el resultado de una búsqueda en la interface del cliente. Arriba: los más antiguos en la parte superior. Abajo: los últimos en la parte superior.';
    $Lang->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'}
        = 'Número máximo de artículos FAQ a ser mostrados como resultado de una búsqueda en la interface del cliente.';
    $Lang->{'Number of FAQ articles to be displayed in each page of a search result in the customer interface.'}
        = 'Número de artículos FAQ a ser mostrados por cada página como resultado de una búsqueda en la interface del cliente.';
    $Lang->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'}
        = 'Define el atributo por omisión para ordenar los artículos FAQ en una búsqeda de FAQ en la interface pública.';
    $Lang->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'}
        = 'Define el sentido del orden por omisión en el resultado de una búsqueda en la interface pública. Arriba: los más antiguos en la parte superior. Abajo: los últimos en la parte superior.';
    $Lang->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'}
        = 'Número máximo de artículos FAQ a ser mostrados como resultado de una búsqueda en la interface pública.';
    $Lang->{'Number of FAQ articles to be displayed in each page of a search result in the public interface.'}
        = 'Número de artículos FAQ a ser mostrados por cada página como resultado de una búsqueda en la interface pública.';
    $Lang->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'}
        = 'Define las columnas que se mostrarán en la bitácora de FAQ. Esta opción no tiene efectos en la posición de las columnas.';
    $Lang->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'}
        = 'Número máximo de artículos FAQ a ser mostrados como en la bitácora de FAQ en la interface del agente.';
    $Lang->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'}
        = 'Parámetros de las páginas (donde se muestran los artículos FAQ) de la vista tipo resumen corto de la bitácora de FAQ.';
    $Lang->{'Defines an overview module to show the small view of a FAQ journal.'}
        = 'Define un módulo de tipo resumen para mostrar la vista corta de la bitácora de FAQ';

    # template: AgentFAQExplorer
    $Lang->{'FAQ Explorer'}             = 'Explorador FAQ';
    $Lang->{'Subcategories'}            = 'Subcategorías';
    $Lang->{'Articles'}                 = 'Artículos';
    $Lang->{'No subcategories found.'}  = 'No se encontraron subcategorías.';
    $Lang->{'No FAQ data found.'}       = 'No se encontraron registros FAQ.';

    # template: AgentFAQAdd
    $Lang->{'Add FAQ Article'}         = 'Agregar FAQ.';
    $Lang->{'The title is required.'}  = 'El título es requerido.';
    $Lang->{'A category is required.'} = 'La categoría es requerida.';

    # template: AgentFAQJournal
    $Lang->{'FAQ Journal'} = 'Bitácora de FAQ';

    # template: AgentFAQLanguage
    $Lang->{'FAQ Language Management'}                               = 'Administración de Idiomas de FAQ';
    $Lang->{'Add Language'}                                          = 'Agregar Idioma';
    $Lang->{'Add language'}                                          = 'Agregar idioma';
    $Lang->{'Edit Language'}                                         = 'Editar Idioma';
    $Lang->{'Delete Language'}                                       = 'Borrar Idioma';
    $Lang->{'The name is required!'}                                 = 'El nombre es requerido';
    $Lang->{'This language already exists!'}                         = 'Este idioma ya existe!';
    $Lang->{'FAQ language added!'}                                   = 'Idioma de FAQ agregado';
    $Lang->{'FAQ language updated!'}                                 = 'Idioma de FAQ actualizado!';

    $Lang->{'Do you really want to delete this Language?'}           = '¿Está seguro de querer borrar este Idioma?';
    $Lang->{'This Language is used in the following FAQ Article(s)'} = 'Este Idioma esta siendo usado por los siguientes Artículos FAQ';
    $Lang->{'You can not delete this Language. It is used in at least one FAQ Article!'}
        = 'No puede borrar este Idioma. Está siendo usado por al menos un Artículo FAQ';

    # template: AgentFAQCategory
    $Lang->{'FAQ Category Management'}                         = 'Administración de Categorías de FAQ';
    $Lang->{'Add Category'}                                    = 'Agregar Categoría';
    $Lang->{'Add category'}                                    = 'Agregar categoría';
    $Lang->{'Edit Category'}                                   = 'Editar Categoría';
    $Lang->{'Delete Category'}                                 = 'Borrar Categoría';
    $Lang->{'A category should have a name!'}                  = 'Una categoría debe tener un nombre!';
    $Lang->{'A category should have a comment!'}               = 'Una categoría debe tener un comentario!';
    $Lang->{'A category needs at least one permission group!'} = 'Una categoría debe tener al menos un grupo de permisos';
    $Lang->{'This category already exists!'}                   = 'Esta categoría ya existe';
    $Lang->{'FAQ category updated!'}                           = 'Categoría de FAQ actualizada';
    $Lang->{'FAQ category added!'}                             = 'Categoría de FAQ agregada';
    $Lang->{'Do you really want to delete this Category?'}     = '¿Está seguro de querer borrar esta Categoría?';
    $Lang->{'This Category is used in the following FAQ Artice(s)'}
        = 'Esta Categoría esta siendo usada por los siguientes Artículos FAQ';
    $Lang->{'This Category is parent of the following SubCategories'}
        = 'Esta Categoría es padre de las siguientes SubCategorías';
    $Lang->{'You can not delete this Category. It is used in at least one FAQ Article! and/or is parent of at least another Category'}
        = 'No puede borrar esta Categoría. Está siendo usada por al menos un Artículo FAQ y/o es padre de al menos otra Categoría';

    # template: AgentFAQZoom
    $Lang->{'FAQ Information'}                      = 'Información del Artículo FAQ';
    $Lang->{'Rating'}                               = 'Valoración';
    $Lang->{'No votes found!'}                      = 'No se encontraron votos!';
    $Lang->{'Details'}                              = 'Detalles';
    $Lang->{'Edit this FAQ'}                        = 'Editar este artículo FAQ';
    $Lang->{'History of this FAQ'}                  = 'Historia de este artículo FAQ';
    $Lang->{'Print this FAQ'}                       = 'Imprimir este artículo FAQ';
    $Lang->{'Link another object to this FAQ item'} = 'Vincular otro objecto a este artículo FAQ';
    $Lang->{'Delete this FAQ'}                      = 'Borrar este artículo FAQ';
    $Lang->{'not helpful'}                          = 'poco útil';
    $Lang->{'very helpful'}                         = 'muy útil';
    $Lang->{'out of 5'}                             = 'de 5';
    $Lang->{'No votes found! Be the first one to rate this FAQ article.'}
         = 'No se encontraron votos! Sea el primero en valorar este artículo FAQ';

    # template: AgentFAQHistory
    $Lang->{'History Content'} = 'Historial';
    $Lang->{'Updated'}         = 'Actualizado';

    # template: AgentFAQDelete
    $Lang->{'Do you really want to delete this FAQ article?'} = '¿Está seguro de querer borrar este artículo FAQ?';

    # template: AgentFAQPrint
    $Lang->{'FAQ Article Print'} = 'Imprimir Artículo FAQ';

    # template: CustomerFAQSearch
    $Lang->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'}
         = 'Búsqueda de texto completo en artículos FAQ (ej: "John*n" o "Will*")';

    return 1;
}

1;
