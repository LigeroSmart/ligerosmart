# --
# Kernel/Language/zh_CN_FAQ.pm - the Chinese simple translation for FAQ
# Copyright (C) 2009 Never Min <never at qnofae.org>
# --
# $Id: zh_CN_FAQ.pm,v 1.16 2010-12-06 09:51:50 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

package Kernel::Language::zh_CN_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.16 $) [1];

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
    $Lang->{'ArticleVotingQuestion'}             = '';
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
    $Lang->{'internal'}                          = '内部';
    $Lang->{'external'}                          = '外部';
    $Lang->{'public'}                            = '公开';

    $Lang->{'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'} = '没有归类到目录. 要创建一篇文章需要归类到目录里, 请在 -目录菜单- 里选择您有权限创建文章的目录';
    $Lang->{'Agent groups which can access this category.'} = '哪一个群组可以访问此目录.';
    $Lang->{'A category needs at least one permission group!'}   = '一个目录至少要分配一个权限群组';
    $Lang->{'Will be shown as comment in Explorer.'}         = '注释将浏览时显示.';

    $Lang->{'Default category name.'}                                      = '默认的目录名.';
    $Lang->{'Rates for voting. Key must be in percent.'}                   = '好评率, 键值必须在百分比以内.';
    $Lang->{'Show voting in defined interfaces.'}                          = '定义显示评分的介面.';
    $Lang->{'Languagekey which is defined in the language file *_FAQ.pm.'} = '';
    $Lang->{'Show FAQ path yes/no.'}                                       = '是/否显示 FAQ 路径.';
    $Lang->{'Decimal places of the voting result.'}                        = '以十分制显示评分结果.';
    $Lang->{'CSS color for the voting flag.'}                              = '评分标记的 CSS 颜色.';
    $Lang->{'FAQ path separator.'}                                         = 'FAQ 路径分隔符.';
    $Lang->{'Interfaces where the quicksearch should be shown.'}           = '在介面的那里显示快速搜索.';
    $Lang->{'Show items of subcategories.'}                                = '显示子目录的数量.';
    $Lang->{'Show last change items in defined interfaces.'}               = '在介面上显示最近更改的项目.';
    $Lang->{'Number of shown items in last changes.'}                      = '显示最近更改项目的数量.';
    $Lang->{'Show last created items in defined interfaces.'}              = '在介面上显示最新创建的项目.';
    $Lang->{'Number of shown items in last created.'}                      = '显示最新创建项目的数量.';
    $Lang->{'Show top 10 items in defined interfaces.'}                    = '在介面上显示点击量前十位.';
    $Lang->{'Number of shown items in the top 10 feature.'}                = '显示点击量前十位项目的数量.';
    $Lang->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'}
        = 'FAQ 的标识符, 例如 (常见问题)FAQ#, (知识库)KB#, 默认为 FAQ#';
    $Lang->{'Default state for FAQ entry.'}                                = '默认的 FAQ 统计条目.';
    $Lang->{'Show WYSIWYG editor in agent interface.'}                     = '在服务人员介面显示 WYSIWYG(所见即所得)编辑器.';
    $Lang->{'New FAQ articles need approval before they get published.'}   = '新的 FAQ 文章在发布前需要批准.';
    $Lang->{'Group for the approval of FAQ articles.'}                     = '批准 FAQ 文章请求的群组.';
    $Lang->{'Queue for the approval of FAQ articles.'}                     = '批准 FAQ 文章请求的队列.';
    $Lang->{'Ticket subject for approval of FAQ article.'}                 = 'FAQ 文章批准请求的 Ticket 主题.';
    $Lang->{'Ticket body for approval of FAQ article.'}                    = 'FAQ 文章批准请求的 Ticket 内容.';
    $Lang->{'Default priority of tickets for the approval of FAQ articles.'}
        = 'FAQ 文章批准请求的 Ticket 的优先级.';
    $Lang->{'Default state of tickets for the approval of FAQ articles.'}  = 'FAQ 文章批准请求的 Ticket 的默认状态.';
    $Lang->{'Definition of FAQ item free text field.'}                     = '定义 FAQ 项目的不受限文字字段.';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'}
        = '';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'}
        = '';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'}
        = '';
    $Lang->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'}
        = '';
    $Lang->{'Frontend module registration for the agent interface.'}    = '';
    $Lang->{'Frontend module registration for the customer interface.'} = '';
    $Lang->{'Frontend module registration for the public interface.'}   = '';
    $Lang->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'}
        = '';
    $Lang->{'Show FAQ Article with HTML.'}                              = '';
    $Lang->{'Module to generate html OpenSearch profile for short faq search.'}
        = '';
    $Lang->{'Defines where the \'Insert FAQ\' link will be displayed.'} = '';
    $Lang->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'}
        = '';
    $Lang->{'FAQ search backend router of the agent interface.'} = '';
    $Lang->{'Defines an overview module to show the small view of a FAQ list.'}
        = '';
    $Lang->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'}
        = '';
    $Lang->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'}
        = '';
    $Lang->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'}
        = '';
    $Lang->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'}
        = '';
    $Lang->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'}
        = '';
    $Lang->{'Defines the default FAQ attribute for FAQ sorting in a FAQ Explorer of the agent interface.'}
        = '';
    $Lang->{'Defines the default FAQ order of a Explorer result in the agent interface. Up: oldest on top. Down: latest on top.'}
        = '';
    $Lang->{'Maximum number of FAQ articles to be displayed in the result of a Explorer in the agent interface.'}
        = '';
    $Lang->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'}
        = '';
    $Lang->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'}
        = '';
    $Lang->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'}
        = '';
    $Lang->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface'}
        = '';
    $Lang->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'}
        = '';
    $Lang->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'}
        = '';
    $Lang->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'}
        = '';
    $Lang->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'}
        = '';
    $Lang->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'}
        = '';
    $Lang->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'}
        = '';
    $Lang->{'Number of FAQ articles to be displayed in each page of a search result in the customer interface.'}
        = '';
    $Lang->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'}
        = '';
    $Lang->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'}
        = '';
    $Lang->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'}
        = '';
    $Lang->{'Number of FAQ articles to be displayed in each page of a search result in the public interface.'}
        = '';
    $Lang->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'}
        = '';
    $Lang->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'}
        = '';
    $Lang->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'}
        = '';
    $Lang->{'Defines an overview module to show the small view of a FAQ journal.'}
        = '';

    # template: AgentFAQExplorer
    $Lang->{'FAQ Explorer'}             = 'FAQ 浏览器';
    $Lang->{'Subcategories'}            = '子目录';
    $Lang->{'Articles'}                 = '文章';
    $Lang->{'No subcategories found.'}  = '没有找到子目录.';
    $Lang->{'No FAQ data found.'}       = '没有找到 FAQ 数据.';

    # template: AgentFAQAdd
    $Lang->{'Add FAQ Article'}         = '增加 FAQ 文章';
    $Lang->{'The title is required.'}  = '标题是必须的.';
    $Lang->{'A category is required.'} = '目录是必须的.';

   # template: AgentFAQJournal
    $Lang->{'FAQ Journal'} = 'FAQ 日志';

    # template: AgentFAQLanguage
    $Lang->{'FAQ Language Management'}                               = 'FAQ 语言管理';
    $Lang->{'Add Language'}                                          = '增加语言';
    $Lang->{'Edit Language'}                                         = '编辑语言';
    $Lang->{'Delete Language'}                                       = '删除语言';
    $Lang->{'The name is required!'}                                 = '必须要有一个语言名称!';
    $Lang->{'This language already exists!'}                         = '该语言已经存在!';
    $Lang->{'FAQ language added!'}                                   = 'FAQ 语言已经增加!';
    $Lang->{'FAQ language updated!'}                                 = 'FAQ 语言已经更新!';
    $Lang->{'Do you really want to delete this Language?'}           = '真的要删除该语言吗?';
    $Lang->{'This Language is used in the following FAQ Article(s)'} = '该语言正被以下的 FAQ 文章所使用';
    $Lang->{'You can not delete this Language. It is used in at least one FAQ Article!'}
        = '不能删除该语言. 它至少还被一篇 FAQ 文章所使用!';

    # template: AgentFAQCategory
    $Lang->{'FAQ Category Management'}                         = 'FAQ 目录管理';
    $Lang->{'Add Category'}                                    = '增加目录';
    $Lang->{'Edit Category'}                                   = '编辑目录';
    $Lang->{'Delete Category'}                                 = '删除目录';
    $Lang->{'A category should have a name!'}                  = '目录应该要有一个名称!';
    $Lang->{'A category should have a comment!'}               = '目录应该要有一个注释!';
    $Lang->{'A category needs at least one permission group!'} = '至少要指定一个群组对该目录拥有权限!';
    $Lang->{'This category already exists!'}                   = '该目录已经在存在!';
    $Lang->{'FAQ category updated!'}                           = 'FAQ 目录已更新!';
    $Lang->{'FAQ category added!'}                             = 'FAQ 目录已增加!';
    $Lang->{'Do you really want to delete this Category?'}     = '真的要删除该目录吗?';
    $Lang->{'This Category is used in the following FAQ Artice(s)'}
        = '该目录正被以下的 FAQ 文章所使用';
    $Lang->{'This Category is parent of the following SubCategories'}
        = '该目录是以下子目录的父目录';
    $Lang->{'You can not delete this Category. It is used in at least one FAQ Article! and/or is parent of at least another Category'}
        = '不能删除该目录. 它至少还被一篇 FAQ 文章所使用 并/或 它是其中目录的父目录!';

    # template: AgentFAQZoom
    $Lang->{'FAQ Information'}                      = 'FAQ 详细信息';
    $Lang->{'Rating'}                               = '评分';
    $Lang->{'No votes found!'}                      = '没有找到评分!';
    $Lang->{'Details'}                              = '详细';
    $Lang->{'Edit this FAQ'}                        = '编辑';
    $Lang->{'History of this FAQ'}                  = '历史';
    $Lang->{'Print this FAQ'}                       = '打印';
    $Lang->{'Link another object to this FAQ item'} = '链接';
    $Lang->{'Delete this FAQ'}                      = '删除';
    $Lang->{'not helpful'}                          = '没有帮助';
    $Lang->{'very helpful'}                         = '很有帮助';
    $Lang->{'out of 5'}                             = '超过五星';
    $Lang->{'No votes found! Be the first one to rate this FAQ article.'}
         = '没有找到评分! 这将是该 FAQ 文章的第一个评分.';

    # template: AgentFAQHistory
    $Lang->{'History Content'} = '历史';
    $Lang->{'Updated'}         = '更新';

    # template: AgentFAQDelete
    $Lang->{'Do you really want to delete this FAQ article?'} = '真的要删除该 FAQ 文章吗?';

    return 1;
}

1;
