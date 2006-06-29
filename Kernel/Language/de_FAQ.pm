# --
# Kernel/Language/xx_Custom.pm - provides xx custom language translation
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: de_FAQ.pm,v 1.1.1.1 2006-06-29 09:29:51 ct Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::de_FAQ;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1.1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$

    $Self->{Translation} = {
        %{$Self->{Translation}},
        
        # own translations
        'You have already voted!' => 'Sie haben bereits bewertet!',        
        'No rate selected!' => 'Keine Bewertung auswählt!',        
        'Thanks for vote!' => 'Danke für Ihre Bewertungen!',                 
        Votes => 'Bewertungen',
        LatestChangedItems => 'zuletzt geänderte Artikel',
        LatestCreatedItems => 'zuletzt erstellte Artikel',     
        ArticleVotingQuestion => 'Wie gut wurde mit diesem Artikel Ihre Frage beantwortet?',   
        SubCategoryOf => 'Unterkategorie von',
        QuickSearch => 'Schnellsuche',                
        DetailSearch => 'Detailsuche', 
        Categories => 'Kategorien',
        SubCategories => 'Subkategorien',        
    };

    # $$STOP$$
}
# --
1;
