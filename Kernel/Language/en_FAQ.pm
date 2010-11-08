# --
# Kernel/Language/en_FAQ.pm - the english translation of FAQ
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: en_FAQ.pm,v 1.17 2010-11-08 15:41:12 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::en_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.17 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'You have already voted!'}           = 'You have already voted!';
    $Lang->{'No rate selected!'}                 = 'No rate selected!';
    $Lang->{'Thanks for your vote!'}             = '';
    $Lang->{'Votes'}                             = '';
    $Lang->{'LatestChangedItems'}                = 'latest changed article';
    $Lang->{'LatestCreatedItems'}                = 'latest created article';
    $Lang->{'Top10Items'}                        = 'Top 10 articles';
    $Lang->{'ArticleVotingQuestion'}             = 'How helpful was this aticle? Please give us your rating and help to improve the FAQ Database. Thank You.';
    $Lang->{'SubCategoryOf'}                     = 'Subcategory of';
    $Lang->{'QuickSearch'}                       = 'Quick Search';
    $Lang->{'DetailSearch'}                      = 'Detail Search';
    $Lang->{'Categories'}                        = '';
    $Lang->{'SubCategories'}                     = 'Subcategories';
    $Lang->{'New FAQ Article'}                   = '';
    $Lang->{'FAQ Category'}                      = '';
    $Lang->{'A category should have a name!'}    = '';
    $Lang->{'A category should have a comment!'} = '';
    $Lang->{'FAQ Articles (new created)'}        = '';
    $Lang->{'FAQ Articles (recently changed)'}   = '';
    $Lang->{'FAQ Articles (Top 10)'}             = '';
    $Lang->{'StartDay'}                          = 'Start day';
    $Lang->{'StartMonth'}                        = 'Start month';
    $Lang->{'StartYear'}                         = 'Start year';
    $Lang->{'EndDay'}                            = 'End day';
    $Lang->{'EndMonth'}                          = 'End month';
    $Lang->{'EndYear'}                           = 'End year';
    $Lang->{'Approval'}                          = 'Approval';

    $Lang->{
        'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'
        } = '';
    $Lang->{'Agent groups which can access this category.'}    = '';
    $Lang->{'A category needs at least one permission group!'} = '';
    $Lang->{'Will be shown as comment in Explorer.'}           = '';

    return 1;
}

1;
