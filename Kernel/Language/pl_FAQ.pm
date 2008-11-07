# --
# Kernel/Language/pl_FAQ.pm - the polish translation of FAQ
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# Copyright (C) 2008 Patryk ¦ciborek <patryk@sciborek.com>
# --
# $Id: pl_FAQ.pm,v 1.2 2008-11-07 10:40:10 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::pl_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'You have already voted!'}           = 'Ju¿ raz g³osowa³e¶!';
    $Lang->{'No rate selected!'}                 = 'Nie wybra³e¶ oceny!';
    $Lang->{'Thanks for your vote!'}             = 'Dziêkujemy za oddanie g³osu!';
    $Lang->{'Votes'}                             = 'G³osy';
    $Lang->{'LatestChangedItems'}                = 'ostatnio zmienione artyku³y';
    $Lang->{'LatestCreatedItems'}                = 'ostatnio utworzone artyku³y';
    $Lang->{'Top10Items'}                        = '10 najlepszych artyku³ów';
    $Lang->{'ArticleVotingQuestion'}             = 'Czy ten artyku³ pomóg³ Ci??';
    $Lang->{'SubCategoryOf'}                     = 'Podkategoria';
    $Lang->{'QuickSearch'}                       = 'Szybkie wyszukiwanie';
    $Lang->{'DetailSearch'}                      = 'Dok³adne wyszukiwanie';
    $Lang->{'Categories'}                        = 'Kategorie';
    $Lang->{'SubCategories'}                     = 'Podkategorie';
    $Lang->{'A category should have a name!'}    = 'Kategoria musi posiadaæ nazwê!';
    $Lang->{'A category should have a comment!'} = 'Kategoria musi posiadaæ komentarz!';
    $Lang->{'FAQ News (new created)'}            = 'Zmiany w FAQ (nowe artyku³y)';
    $Lang->{'FAQ News (recently changed)'}       = 'Zmiany w FAQ (zmienione artyku³y)';
    $Lang->{'FAQ News (Top 10)'}                 = 'Zmiany w FAQ (10 najlepszych artyku³ów)';
    $Lang->{'StartDay'}                          = 'Dzieñ pocz±tkowy';
    $Lang->{'StartMonth'}                        = 'Miesi±c pocz±tkowy';
    $Lang->{'StartYear'}                         = 'Rok pocz±tkowy';
    $Lang->{'EndDay'}                            = 'Dzieñ koñcowy';
    $Lang->{'EndMonth'}                          = 'Miesi±c koñcowy';
    $Lang->{'EndYear'}                           = 'Rok koñcowy';
    $Lang->{'Approval'}                          = 'Zatwierdzone';
    $Lang->{'FAQ-Area'}                 = 'FAQ: czêsto zadawane pytania';
    $Lang->{'Result'}                 = 'Ocena';

    $Lang->{
        'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'
        } = 'Brak zdefiniowanych kategorii. Abu utworzyæ artyku³ musi istnieæ co najmniej jedna kategoria. Sprawd¼ proszê swoje uprawnienia w menu Kategorie.';
    $Lang->{'Agent groups which can access this category.'}  = 'Grupy agentów, które maj± dostêp do tej kategorii';
    $Lang->{'A category needs min. one permission group!'}   = 'Kategoria wymaga co najmniej jednej grupy uprawnieñ!';
    $Lang->{'Will be shown as comment in Explorer.'}         = 'Zostanie pokazany jako komentarz w eksplorerze.';

    return 1;
}

1;
