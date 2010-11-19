# --
# Kernel/Language/nl_FAQ.pm - the Dutch translation of FAQ
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2009 Michiel Beijen <michiel 'at' beefreeit.nl>
# --
# $Id: nl_FAQ.pm,v 1.5 2010-11-19 10:34:46 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nl_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'FAQ'} = 'FAQ';
    $Lang->{'FAQ-Area'} = 'Knowledge Base';
    $Lang->{'You have already voted!'} = 'U heeft al gestemd!';
    $Lang->{'No rate selected!'}       = 'Geen beoordeling geselecteerd!';
    $Lang->{'Thanks for your vote!'}   = 'Dank voor uw stem!';
    $Lang->{'Votes'}                   = 'Stemmen';
    $Lang->{'LatestChangedItems'}      = 'Laatst veranderde artikelen';
    $Lang->{'LatestCreatedItems'}      = 'Nieuwste artikel';
    $Lang->{'Top10Items'}              = 'Top 10 artikelen';
    $Lang->{'ArticleVotingQuestion'}   = 'Hoe goed gaf dit artikel antwoord op uw probleem?';
    $Lang->{'SubCategoryOf'}           = 'Subcategorie van';
    $Lang->{'QuickSearch'}             = 'Snelzoeken';
    $Lang->{'DetailSearch'}            = 'Geavanceerd zoeken';
    $Lang->{'Categories'}              = 'Categoriën';
    $Lang->{'SubCategories'}           = 'Subcategoriën';
    $Lang->{'New FAQ Article'}         = 'Nieuw FAQ artikel';
    $Lang->{'FAQ Category'}            = 'FAQ categorie';
    $Lang->{'A category should have a name!'}    = 'Geef een naam op voor de categorie';
    $Lang->{'A category should have a comment!'} = 'Geef een beschrijving op voor de categorie';
    $Lang->{'FAQ Articles (new created)'}        = 'FAQ artikelen (nieuw aangemaakt)';
    $Lang->{'FAQ Articles (recently changed)'}   = 'FAQ artikelen (laatst veranderd)';
    $Lang->{'FAQ Articles (Top 10)'}             = 'FAQ artikelen (Top 10)';
    $Lang->{'StartDay'}                          = 'Eerste dag';
    $Lang->{'StartMonth'}                        = 'Eerste maand';
    $Lang->{'StartYear'}                         = 'Eerste jaar';
    $Lang->{'EndDay'}                            = 'Laatste dag';
    $Lang->{'EndMonth'}                          = 'Laatste maand';
    $Lang->{'EndYear'}                           = 'Laatste jaar';
    $Lang->{'Approval'}                          = 'Goedkeuring';
    $Lang->{'internal'}                          = '';
    $Lang->{'external'}                          = '';
    $Lang->{'public'}                            = '';
    $Lang->{
        'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'
        }
        = 'Geen categorie toegankelijk. Om een artikel te kunnen aanmaken moet u toegan hebben tot tenminste een categorie. Controleer uw groep/categorie rechten';
    $Lang->{'Agent groups which can access this category.'}
        = 'Behandelgroepen met toegang tot deze categorie';
    $Lang->{'A category needs at least one permission group!'}
        = 'Voeg tenminste een permissiegroep toe per categorie.';
    $Lang->{'Will be shown as comment in Explorer.'} = 'Wordt in webinterface getoond';

    return 1;
}

1;
