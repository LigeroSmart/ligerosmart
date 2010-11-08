# --
# Kernel/Language/zh_CN_FAQ.pm - the Chinese simple translation for FAQ
# Copyright (C) 2009 Never Min <never at qnofae.org>
# --
# $Id: zh_CN_FAQ.pm,v 1.5 2010-11-08 15:41:12 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::zh_CN_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Explorer'}                 = '浏览';
    $Lang->{'You have already voted!'}           = '您已经评分!';
    $Lang->{'No rate selected!'}                 = '没有选择评分!';
    $Lang->{'Thanks for your vote!'}             = '感谢您的评分';
    $Lang->{'Votes'}                             = '评分';
    $Lang->{'LatestChangedItems'}                = '最近修改的文章';
    $Lang->{'LatestCreatedItems'}                = '最新创建的文章';
    $Lang->{'Top10Items'}                        = '最常用的文章';
    $Lang->{'ArticleVotingQuestion'}             = '此文章对您有帮助吗?';
    $Lang->{'SubCategoryOf'}                     = '子目录于';
    $Lang->{'QuickSearch'}                       = '快速搜索';
    $Lang->{'DetailSearch'}                      = '高级搜索';
    $Lang->{'Categories'}                        = '目录';
    $Lang->{'SubCategories'}                     = '子目录';
    $Lang->{'New FAQ Article'}                   = '添加新文章';
    $Lang->{'FAQ Category'}                      = 'FAQ 目录';
    $Lang->{'A category should have a name!'}    = '目录名不能为空!';
    $Lang->{'A category should have a comment!'} = '请为该目录写上注释!';
    $Lang->{'FAQ Articles (new created)'}        = 'FAQ 更新(新创建)';
    $Lang->{'FAQ Articles (recently changed)'}   = 'FAQ 更新(最近更改)';
    $Lang->{'FAQ Articles (Top 10)'}             = 'FAQ 更新';
    $Lang->{'StartDay'}                          = '开始日期';
    $Lang->{'StartMonth'}                        = '开始月份';
    $Lang->{'StartYear'}                         = '开始年份';
    $Lang->{'EndDay'}                            = '结束日期';
    $Lang->{'EndMonth'}                          = '开始月份';
    $Lang->{'EndYear'}                           = '结束年份';
    $Lang->{'Approval'}                          = '认可度';

    $Lang->{'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'} = '没有归类到目录. 要创建一篇文章需要归类到目录里, 请在 -目录菜单- 里选择您有权限创建文章的目录';
    $Lang->{'Agent groups which can access this category.'} = '哪一个群组可以访问此目录.';
    $Lang->{'A category needs at least one permission group!'}   = '一个目录至少要分配一个权限群组';
    $Lang->{'Will be shown as comment in Explorer.'}         = '注释将浏览时显示.';

    return 1;
}

1;
