# --
# Kernel/Language/da_FAQ.pm - provides da (Danish) language translation
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: da_FAQ.pm,v 1.2 2010-11-19 10:34:46 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

package Kernel::Language::da_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'You have already voted!'} = 'Du har allerede stemt!';
    $Lang->{'No rate selected!'}       = 'Ingen rate valgt!';
    $Lang->{'Thanks for your vote!'}   = 'Tak for din stemme!';
    $Lang->{'Votes'}                   = 'Stemmer';
    $Lang->{'LatestChangedItems'}      = 'Sidst ændrede artikler';
    $Lang->{'LatestCreatedItems'}      = 'Nyeste artikler';
    $Lang->{'Top10Items'}              = 'Top 10 artikler';
    $Lang->{'ArticleVotingQuestion'}   = 'Hvor godt svarede denne artikel på dit spørgsmål?';
    $Lang->{'SubCategoryOf'}           = 'Underkategori af';
    $Lang->{'QuickSearch'}             = 'Søgning';
    $Lang->{'DetailSearch'}            = 'Detaljeret søgning';
    $Lang->{'Categories'}              = 'Kategorier';
    $Lang->{'SubCategories'}           = 'Underkategorier';
    $Lang->{'New FAQ Article'}         = 'Ny FAQ Artikel';
    $Lang->{'FAQ Category'}            = 'FAQ Kategorier';
    $Lang->{'A category should have a name!'}    = 'En kategori skal have et navn!';
    $Lang->{'A category should have a comment!'} = 'En kategori skal have en kommentar!';
    $Lang->{'FAQ News (new created)'}            = 'FAQ Nyheder (nyoprettet)';
    $Lang->{'FAQ News (recently changed)'}       = 'FAQ Nyheder (sidst ændrede)';
    $Lang->{'FAQ News (Top 10)'}                 = 'FAQ Nyheder (Top 10)';
    $Lang->{'StartDay'}                          = 'Start dag';
    $Lang->{'StartMonth'}                        = 'Start måned';
    $Lang->{'StartYear'}                         = 'Start år';
    $Lang->{'EndDay'}                            = 'Slut dag';
    $Lang->{'EndMonth'}                          = 'Slut måned';
    $Lang->{'EndYear'}                           = 'Slut år';
    $Lang->{'Approval'}                          = 'Godkendt';
    $Lang->{'internal'}                          = '';
    $Lang->{'external'}                          = '';
    $Lang->{'public'}                            = '';
    $Lang->{
        'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'
        }
        = 'Der er ikke valgt kategori. For at oprette en ny artikel skal du have adgang til mindst en kategori. Tjek dine Gruppe/Kategori rettigheder under -Kategori menuen-!';
    $Lang->{'Agent groups which can access this category.'}
        = 'Agentgrupper som kan tilgå denne kategori.';
    $Lang->{'A category needs min. one permission group!'}
        = 'En kategori behøver mindst en rettighedsgruppe.';
    $Lang->{'Will be shown as comment in Explorer.'} = 'Vil blive vist som kommentar i Explore.';

    return 1;
}

1;
