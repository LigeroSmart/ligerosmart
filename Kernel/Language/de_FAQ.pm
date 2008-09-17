# --
# Kernel/Language/de_FAQ.pm - the german translation of FAQ
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: de_FAQ.pm,v 1.9 2008-09-17 11:55:59 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::de_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

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
    $Lang->{'A category should have a name!'}    = 'Eine Kategorien sollte einen Namen haben!';
    $Lang->{'A category should have a comment!'} = 'Eine Kategorien sollte einen Kommentar haben!';
    $Lang->{'FAQ News (new created)'}            = 'FAQ News (neu erstellte)';
    $Lang->{'FAQ News (recently changed)'}       = 'FAQ News (zuletzt geänderte)';
    $Lang->{
        'No category accesable. To create an article you need have at lease access to min. one category. Please check your group/category permission under -category menu-!'
        }
        = 'Keine Kategorie-Auswahl möglich. Um einen Artikel erstellen zu können, muss man min. Zugriff auf eine Kategorie haben. Bitte überprüfen Sie die Gruppen/Kategorie Berechtigung im Menupunkt -Kategorie-!';
    $Lang->{'Agent Groups which can access this category.'}
        = 'Agenten Gruppe welche auf diese Kategorie Zugriff hat.';
    $Lang->{'A category need min. one permission group!'}
        = 'Eine Kategorie muss min. eine Berechtigung-Gruppe haben.';
    $Lang->{'Will be shown as comment in Explorer.'} = 'Wird im Explorer als Kommentar angezeigt.';

    return 1;
}

1;
