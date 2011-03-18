# --
# Kernel/Language/en_GB_FAQ.pm - translation file for British English
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: en_GB_FAQ.pm,v 1.1 2011-03-18 12:44:39 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::en_GB_FAQ;

use strict;

sub Data {
    my $Self = shift;

    # Tags that are substituted:
    $Self->{Translation}->{'LatestChangedItems'} = 'Latest updated FAQ articles';
    $Self->{Translation}->{'LatestCreatedItems'} = 'Latest created FAQ articles';
    $Self->{Translation}->{'Top10Items'} = 'Top 10 FAQ articles';
    $Self->{Translation}->{'SubCategoryOf'} = 'Subcategory of';
    $Self->{Translation}->{'StartDay'} = 'Start day';
    $Self->{Translation}->{'StartMonth'} = 'Start month';
    $Self->{Translation}->{'StartYear'} = 'Start year';
    $Self->{Translation}->{'EndDay'} = 'End day';
    $Self->{Translation}->{'EndMonth'} = 'End month';
    $Self->{Translation}->{'EndYear'} = 'End year';
    $Self->{Translation}->{'ArticleVotingQuestion'} = 'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!';

}

1;
