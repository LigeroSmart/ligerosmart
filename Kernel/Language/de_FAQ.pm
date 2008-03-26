# --
# Kernel/Language/de_FAQ.pm - provides de language translation
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: de_FAQ.pm,v 1.4 2008-03-26 08:43:01 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --
package Kernel::Language::de_FAQ;

use strict;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub Data {
    my $Self = shift;
    my $Translation = $Self->{Translation};

    return if ref $Translation ne 'HASH';

    # $$START$$

    # own translations
    $Translation->{'You have already voted!'} = 'Sie haben bereits bewertet!';
    $Translation->{'No rate selected!'} = 'Keine Bewertung auswählt!';
    $Translation->{'Thanks for vote!'} = 'Danke für Ihre Bewertungen!';
    $Translation->{Votes} = 'Bewertungen';
    $Translation->{LatestChangedItems} = 'zuletzt geänderte Artikel';
    $Translation->{LatestCreatedItems} = 'zuletzt erstellte Artikel';
    $Translation->{ArticleVotingQuestion} = 'Wie gut wurde mit diesem Artikel Ihre Frage beantwortet?';
    $Translation->{SubCategoryOf} = 'Unterkategorie von';
    $Translation->{QuickSearch} = 'Schnellsuche';
    $Translation->{DetailSearch} = 'Detailsuche';
    $Translation->{Categories} = 'Kategorien';
    $Translation->{SubCategories} = 'Subkategorien';
    $Translation->{'A category should have a name!'} = 'Eine Kategorien sollte einen Namen haben!';
    $Translation->{'A category should have a comment!'} = 'Eine Kategorien sollte einen Kommentar haben!';
    $Translation->{'FAQ News (new created)'} = 'FAQ News (neu erstellte)';
    $Translation->{'FAQ News (recently changed)'} = 'FAQ News (zuletzt geänderte)';
    $Translation->{'No category accesable. To create an article you need have at lease access to min. one category. Please check your group/category permission under -category menu-!'} = 'Keine Kategorie-Auswahl möglich. Um einen Artikel erstellen zu können, muss man min. Zugriff auf eine Kategorie haben. Bitte überprüfen Sie die Gruppen/Kategorie Berechtigung im Menupunkt -Kategorie-!';
    $Translation->{'Agent Groups which can access this category.'} = 'Agenten Gruppe welche auf diese Kategorie Zugriff hat.';
    $Translation->{'A category need min. one permission group!'} = 'Eine Kategorie muss min. eine Berechtigung-Gruppe haben.';
    $Translation->{'Will be shown as comment in Explore.'} = 'Wird  im Explorer als Kommentar angezeigt.';

    # $$STOP$$
    return 1;
}

1;
