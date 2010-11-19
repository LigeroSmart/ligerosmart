# --
# Kernel/Language/de_FAQ.pm - the german translation of FAQ
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: de_FAQ.pm,v 1.18 2010-11-19 10:34:46 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

package Kernel::Language::de_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.18 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'You have already voted!'} = 'Sie haben bereits bewertet!';
    $Lang->{'No rate selected!'}       = 'Keine Bewertung auswählt!';
    $Lang->{'Thanks for your vote!'}   = 'Danke für Ihre Bewertungen!';
    $Lang->{'Votes'}                   = 'Bewertungen';
    $Lang->{'LatestChangedItems'}      = 'zuletzt geänderte Artikel';
    $Lang->{'LatestCreatedItems'}      = 'zuletzt erstellte Artikel';
    $Lang->{'Top10Items'}              = 'Top 10 Artikel';
    $Lang->{'ArticleVotingQuestion'}   = 'Wie gut wurde mit diesem Artikel Ihre Frage beantwortet?';
    $Lang->{'SubCategoryOf'}           = 'Unterkategorie von';
    $Lang->{'QuickSearch'}             = 'Schnellsuche';
    $Lang->{'DetailSearch'}            = 'Detailsuche';
    $Lang->{'Categories'}              = 'Kategorien';
    $Lang->{'SubCategories'}           = 'Subkategorien';
    $Lang->{'New FAQ Article'}         = 'Neuer FAQ Artikel';
    $Lang->{'FAQ Category'}            = 'FAQ Kategorie';
    $Lang->{'A category should have a name!'}        = 'Eine Kategorien sollte einen Namen haben!';
    $Lang->{'A category should have a comment!'}     = 'Eine Kategorien sollte einen Kommentar haben!';
    $Lang->{'FAQ Articles (new created)'}            = 'FAQ Articles (neu erstellte)';
    $Lang->{'FAQ Articles (recently changed)'}       = 'FAQ Articles (zuletzt geänderte)';
    $Lang->{'FAQ Articles (Top 10)'}                 = 'FAQ Articles (Top 10)';
    $Lang->{'StartDay'}                              = 'Start Tag';
    $Lang->{'StartMonth'}                            = 'Start Monat';
    $Lang->{'StartYear'}                             = 'Start Jahr';
    $Lang->{'EndDay'}                                = 'End Tag';
    $Lang->{'EndMonth'}                              = 'End Monat';
    $Lang->{'EndYear'}                               = 'End Jahr';
    $Lang->{'Approval'}                              = 'Freigabe';
    $Lang->{'internal'}                              = 'intern';
    $Lang->{'external'}                              = 'extern';
    $Lang->{'public'}                                = 'öffentlich';

    $Lang->{
        'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'
        }
        = 'Keine Kategorie-Auswahl möglich. Um einen Artikel erstellen zu können, muss man min. Zugriff auf eine Kategorie haben. Bitte überprüfen Sie die Gruppen/Kategorie Berechtigung im Menupunkt -Kategorie-!';
    $Lang->{'Agent groups which can access this category.'}
        = 'Agenten Gruppe welche auf diese Kategorie Zugriff hat.';
    $Lang->{'A category needs at least one permission group!'}
        = 'Eine Kategorie muss mindestens eine Berechtigungs-Gruppe haben.';
    $Lang->{'Will be shown as comment in Explorer.'} = 'Wird im Explorer als Kommentar angezeigt.';

    return 1;
}

1;
