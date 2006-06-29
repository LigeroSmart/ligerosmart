# --
# Kernel/Language/xx_Custom.pm - provides xx custom language translation
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: en_FAQ.pm,v 1.1.1.1 2006-06-29 09:29:51 ct Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::en_FAQ;

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
        Votes => 'Votes',        
        LatestChangedItems => 'latest changed article',
        LatestCreatedItems => 'latest created article',     
        ArticleVotingQuestion => 'Did this article help?', 
        QuickSearch => 'quick search',  
        DetailSearch => 'detail search', 
        'You have already voted!' => 'You have already vote!',
        'No rate selected!' => 'No rate selected!', 
        'Thanks for vote!' => 'Thanks for vote!',
        Categories => 'Categories',  
        SubCategories => 'subcategories',                                   
    };

    # $$STOP$$
}
# --
1;
