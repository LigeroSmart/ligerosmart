# --
# Kernel/Language/fr_FAQ.pm - the french translation of FAQ
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2009 Jonathan Peyrot
# --
# $Id: fr_FAQ.pm,v 1.4 2010-11-19 10:34:46 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

package Kernel::Language::fr_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'You have already voted!'}           = 'Vous avez déjà voté !';
    $Lang->{'No rate selected!'}                 = 'Pas de sélection !';
    $Lang->{'Thanks for your vote!'}             = 'Merci pour votre vote !';
    $Lang->{'Votes'}                             = 'Votes';
    $Lang->{'LatestChangedItems'}                = 'Dernières questions modifiées';
    $Lang->{'LatestCreatedItems'}                = 'Dernières questions créées';
    $Lang->{'Top10Items'}                        = 'Top 10 des questions';
    $Lang->{'ArticleVotingQuestion'}             = 'Voulez vous voter pour cette question ?';
    $Lang->{'SubCategoryOf'}                     = 'Sous catégorie de';
    $Lang->{'QuickSearch'}                       = 'Recherche rapide';
    $Lang->{'DetailSearch'}                      = 'Détails de la recherche';
    $Lang->{'Categories'}                        = 'Catégories';
    $Lang->{'SubCategories'}                     = 'Sous-catégories';
    $Lang->{'New FAQ Article'}                   = 'Nouvelle question dans la FAQ';
    $Lang->{'FAQ Category'}                      = 'Catégorie FAQ';
    $Lang->{'A category should have a name!'}    = 'Une catégorie doit avoir un nom !';
    $Lang->{'A category should have a comment!'} = 'Une catégorie doit posséder un commentaire';
    $Lang->{'FAQ Articles (new created)'}        = 'FAQ Articles (nouvelles questions)';
    $Lang->{'FAQ Articles (recently changed)'}   = 'FAQ Articles (derniers changements)';
    $Lang->{'FAQ Articles (Top 10)'}             = 'FAQ Articles (Top 10)';
    $Lang->{'StartDay'}                          = 'Jour Début';
    $Lang->{'StartMonth'}                        = 'Mois Début';
    $Lang->{'StartYear'}                         = 'Année Début';
    $Lang->{'EndDay'}                            = 'Jour Fin';
    $Lang->{'EndMonth'}                          = 'Mois Fin';
    $Lang->{'EndYear'}                           = 'Année Fin';
    $Lang->{'Approval'}                          = 'Autorisation';
    $Lang->{'internal'}                          = '';
    $Lang->{'external'}                          = '';
    $Lang->{'public'}                            = '';
    $Lang->{
        'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'
        }
        = 'Aucun catégorie accessible. Pour créer une question, vous devez avoir accès à au moins une catégorie. SVP vérifiez les permissions de votre groupe/catégorie via le menu -catégorie- !';
    $Lang->{'Agent groups which can access this category.'}
        = 'Groupes d\'Agents pouvant accéder à cette catégorie';
    $Lang->{'A category needs at least one permission group!'}
        = 'Une catégorie nécessite au minimum une permission de groupe !';
    $Lang->{'Will be shown as comment in Explorer.'} = 'Sera affiché comme un commentaire dans l\'Explorer.';

    return 1;
}

1;
