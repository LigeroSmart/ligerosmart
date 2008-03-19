# --
# Kernel/Language/en_FAQ.pm - provides en language translation
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: en_FAQ.pm,v 1.3 2008-03-19 10:55:43 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --
package Kernel::Language::en_FAQ;

use strict;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my $Self = shift;
    my $Translation = $Self->{Translation};

    return if ref $Translation ne 'HASH';

    # $$START$$

    # own translations
    $Translation->{Votes} = 'Votes';
    $Translation->{LatestChangedItems} = 'latest changed article';
    $Translation->{LatestCreatedItems} = 'latest created article';
    $Translation->{ArticleVotingQuestion} = 'Did this article help?';
    $Translation->{QuickSearch} = 'Quick Search';
    $Translation->{DetailSearch} = 'Detail Search';
    $Translation->{'You have already voted!'} = 'You have already vote!';
    $Translation->{'No rate selected!'} = 'No rate selected!';
    $Translation->{'Thanks for vote!'} = 'Thanks for vote!';
    $Translation->{Categories} = 'Categories';
    $Translation->{SubCategories} = 'Subcategories';

    # $$STOP$$
    return 1;
}

1;
