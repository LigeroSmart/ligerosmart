# --
# Kernel/Language/es_FAQ.pm - the spanish translation of FAQ
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Aquiles Cohen
# --
# $Id: es_FAQ.pm,v 1.3 2008-08-25 17:30:05 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::es_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'You have already voted!'}           = 'Usted ya ha votado!';
    $Lang->{'No rate selected!'}                 = 'No selecciono puntaje!';
    $Lang->{'Thanks for vote!'}                  = 'Gracias por su voto!';
    $Lang->{'Votes'}                             = 'Votos';
    $Lang->{'LatestChangedItems'}                = 'ultimo articulo modificado';
    $Lang->{'LatestCreatedItems'}                = 'ultimos articulo creado';
    $Lang->{'ArticleVotingQuestion'}             = 'Lo ayudo este articulo?';
    $Lang->{'SubCategoryOf'}                     = 'Sub Categoria de';
    $Lang->{'QuickSearch'}                       = 'Busqueda rápida';
    $Lang->{'DetailSearch'}                      = 'Busqueda detallada';
    $Lang->{'Categories'}                        = 'Categorias';
    $Lang->{'SubCategories'}                     = 'Subcategorias';
    $Lang->{'A category should have a name!'}    = 'Cada categoría debe tener un nombre!';
    $Lang->{'A category should have a comment!'} = 'Cada categoria debe tener un comentario';
    $Lang->{'FAQ News (new created)'}            = 'Noticias FAQ (creado nuevo)';
    $Lang->{'FAQ News (recently changed)'}       = 'Noticias FAQ (Recientemente modificado)';
    $Lang->{
        'No category accesable. To create an article you need have at lease access to min. one category. Please check your group/category permission under -category menu-!'
        }
        = 'No se puede acceder a ninguna categoría. Para crear un articulo usted debe tener acceso a mínimo una categoría. Por favor revise sus permisos de grupo/categoría en el -menú categoría-!';
    $Lang->{'Agent Groups which can access this category.'}
        = 'Los grupos agentes pueden acceder a esta categoría';
    $Lang->{'A category need min. one permission group!'}
        = 'Una categoria necesita minimo un permiso de grupo!';
    $Lang->{'Will be shown as comment in Explore.'} = 'Seran mostrados como comentarios en Explore';

    return 1;
}

1;
