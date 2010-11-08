# --
# Kernel/Language/pt_BR_FAQ.pm - the portuguese brazillian translation of FAQ
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2009 Ronaldo Richieri <richieri@gmail.com>
# --
# $Id: pt_BR_FAQ.pm,v 1.4 2010-11-08 15:41:12 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::pt_BR_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'You have already voted!'}           = 'Você já votou!';
    $Lang->{'No rate selected!'}                 = 'Selecione a pontuação!';
    $Lang->{'Thanks for your vote!'}             = 'Obrigado por seu Voto';
    $Lang->{'Votes'}                             = 'Votos';
    $Lang->{'LatestChangedItems'}                = 'Artigos modificados recentemente';
    $Lang->{'LatestCreatedItems'}                = 'Últimos artigos adicionados';
    $Lang->{'Top10Items'}                        = 'Os 10 artigos mais acessados';
    $Lang->{'ArticleVotingQuestion'}             = 'Este artigo te ajudou?';
    $Lang->{'SubCategoryOf'}                     = 'Subcategoria de';
    $Lang->{'QuickSearch'}                       = 'Pesquisa';
    $Lang->{'DetailSearch'}                      = 'Pesquisa Avançada';
    $Lang->{'Categories'}                        = 'Categorias';
    $Lang->{'SubCategories'}                     = 'Subcategorias';
    $Lang->{'A category should have a name!'}    = 'Uma categoria precisa ter um nome!';
    $Lang->{'A category should have a comment!'} = 'Uma categoria precisa ter um comentário!';
    $Lang->{'FAQ Articles (new created)'}        = 'FAQ Articles (recém criados)';
    $Lang->{'FAQ Articles (recently changed)'}   = 'FAQ Articles (alterados recentemente)';
    $Lang->{'FAQ Articles (Top 10)'}             = 'FAQ Articles (as 10 mais)';
    $Lang->{'StartDay'}                          = 'Dia de início';
    $Lang->{'StartMonth'}                        = 'Mês de início';
    $Lang->{'StartYear'}                         = 'Ano de início';
    $Lang->{'EndDay'}                            = 'Dia de término';
    $Lang->{'EndMonth'}                          = 'M?s de término';
    $Lang->{'EndYear'}                           = 'Ano de término';
    $Lang->{'Approval'}                          = 'Aprovação';

    $Lang->{
        'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'
        } = 'Você está sem acesso a nenhuma categoria. Para criar um artigo, você precisa ter acesso a pelo menos uma categoria. Por favor, confira as permissões de seu grupo no menu Categoria!';
    $Lang->{'Agent groups which can access this category.'} = 'Grupo de agentes que podem acessar esta categoria.';
    $Lang->{'A category needs at least one permission group!'}   = 'Selecione pelo menos um grupo que poderá acessar esta categoria!';
    $Lang->{'Will be shown as comment in Explorer.'}         = 'Será exibido como comentário no Explorer';

    return 1;
}

1;
