# --
# Kernel/Language/zh_CN_FAQ.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: zh_CN_FAQ.pm,v 1.21 2011-08-12 21:48:22 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_FAQ;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAFAQ
    $Self->{Translation}->{'internal'} = '内部';
    $Self->{Translation}->{'public'} = '公开';
    $Self->{Translation}->{'external'} = '外部';
    $Self->{Translation}->{'FAQ Number'} = '';
    $Self->{Translation}->{'Latest updated FAQ articles'} = '最近修改的文章';
    $Self->{Translation}->{'Latest created FAQ articles'} = '最新创建的文章';
    $Self->{Translation}->{'Top 10 FAQ articles'} = '最常用的文章';
    $Self->{Translation}->{'Subcategory of'} = '子目录于';
    $Self->{Translation}->{'No rate selected!'} = '没有选择评分!';
    $Self->{Translation}->{'public (all)'} = '';
    $Self->{Translation}->{'external (customer)'} = '';
    $Self->{Translation}->{'internal (agent)'} = '';
    $Self->{Translation}->{'Start day'} = '开始日期';
    $Self->{Translation}->{'Start month'} = '开始月份';
    $Self->{Translation}->{'Start year'} = '开始年份';
    $Self->{Translation}->{'End day'} = '结束日期';
    $Self->{Translation}->{'End month'} = '开始月份';
    $Self->{Translation}->{'End year'} = '结束年份';
    $Self->{Translation}->{'Thanks for your vote!'} = '感谢您的评分';
    $Self->{Translation}->{'You have already voted!'} = '您已经评分!';
    $Self->{Translation}->{'FAQ Article Print'} = '';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'FAQ 更新';
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'FAQ 更新(新创建)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'FAQ 更新(最近更改)';
    $Self->{Translation}->{'FAQ category updated!'} = 'FAQ 目录已更新!';
    $Self->{Translation}->{'FAQ category added!'} = 'FAQ 目录已增加!';
    $Self->{Translation}->{'A category should have a name!'} = '目录应该要有一个名称!';
    $Self->{Translation}->{'This category already exists'} = '';
    $Self->{Translation}->{'FAQ language added!'} = 'FAQ 语言已经增加!';
    $Self->{Translation}->{'FAQ language updated!'} = 'FAQ 语言已经更新!';
    $Self->{Translation}->{'The name is required!'} = '必须要有一个语言名称!';
    $Self->{Translation}->{'This language already exists!'} = '该语言已经存在!';

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = '增加 FAQ 文章';
    $Self->{Translation}->{'A category is required.'} = '目录是必须的.';
    $Self->{Translation}->{'Approval'} = '认可度';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'FAQ 目录管理';
    $Self->{Translation}->{'Add category'} = '';
    $Self->{Translation}->{'Delete Category'} = '删除目录';
    $Self->{Translation}->{'Ok'} = '';
    $Self->{Translation}->{'Add Category'} = '增加目录';
    $Self->{Translation}->{'Edit Category'} = '编辑目录';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = '注释将浏览时显示.';
    $Self->{Translation}->{'Please select at least one permission group.'} = '';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = '';
    $Self->{Translation}->{'Do you really want to delete this category?'} = '';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} = '';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = '';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = '';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = '真的要删除该 FAQ 文章吗?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = '';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'FAQ 浏览器';
    $Self->{Translation}->{'Quick Search'} = '';
    $Self->{Translation}->{'Advanced Search'} = '';
    $Self->{Translation}->{'Subcategories'} = '子目录';
    $Self->{Translation}->{'FAQ Articles'} = '';
    $Self->{Translation}->{'No subcategories found.'} = '没有找到子目录.';

    # Template: AgentFAQHistory

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = '';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'FAQ 语言管理';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languges.'} = '';
    $Self->{Translation}->{'Add language'} = '';
    $Self->{Translation}->{'Delete Language'} = '删除语言';
    $Self->{Translation}->{'Add Language'} = '增加语言';
    $Self->{Translation}->{'Edit Language'} = '编辑语言';
    $Self->{Translation}->{'Do you really want to delete this language?'} = '';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} = '';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = '';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = '';
    $Self->{Translation}->{'FAQ articles per page'} = '';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = '没有找到 FAQ 数据.';

    # Template: AgentFAQPrint
    $Self->{Translation}->{'FAQ-Info'} = '';
    $Self->{Translation}->{'Votes'} = '评分';

    # Template: AgentFAQSearch

    # Template: AgentFAQSearchOpenSearchDescriptionFAQNumber

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = '';

    # Template: AgentFAQSearchResultPrint

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = '';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'FAQ 详细信息';
    $Self->{Translation}->{'Rating'} = '评分';
    $Self->{Translation}->{'Rating %'} = '';
    $Self->{Translation}->{'out of 5'} = '超过五星';
    $Self->{Translation}->{'No votes found!'} = '没有找到评分!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = '没有找到评分! 这将是该 FAQ 文章的第一个评分.';
    $Self->{Translation}->{'Download Attachment'} = '';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} = '';
    $Self->{Translation}->{'not helpful'} = '没有帮助';
    $Self->{Translation}->{'very helpful'} = '很有帮助';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Insert FAQ Text'} = '';
    $Self->{Translation}->{'Insert FAQ Link'} = '';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = '';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = '';

    # Template: CustomerFAQPrint

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = '';

    # Template: CustomerFAQSearchOpenSearchDescription

    # Template: CustomerFAQSearchResultPrint

    # Template: CustomerFAQSearchResultShort

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Details'} = '详细';
    $Self->{Translation}->{'Search for articles with keyword'} = '';

    # Template: PublicFAQExplorer

    # Template: PublicFAQPrint

    # Template: PublicFAQSearch

    # Template: PublicFAQSearchOpenSearchDescription
    $Self->{Translation}->{'Public'} = '';

    # Template: PublicFAQSearchResultPrint

    # Template: PublicFAQSearchResultShort

    # Template: PublicFAQZoom

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} = '';
    $Self->{Translation}->{'Article free text options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###AttributesView.'} = '';
    $Self->{Translation}->{'CSS color for the voting result.'} = '';
    $Self->{Translation}->{'Category Management'} = '';
    $Self->{Translation}->{'Configure your own log text for PGP.'} = '';
    $Self->{Translation}->{'Custom text for the page shown to customers that have no tickets yet.'} = '';
    $Self->{Translation}->{'Decimal places of the voting result.'} = '以十分制显示评分结果.';
    $Self->{Translation}->{'Default category name.'} = '默认的目录名.';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = '';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} = 'FAQ 文章批准请求的 Ticket 的优先级.';
    $Self->{Translation}->{'Default state for FAQ entry.'} = '默认的 FAQ 统计条目.';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'FAQ 文章批准请求的 Ticket 的默认状态.';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} = '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} = '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the customer interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the agent interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the customer interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the public interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} = '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} = '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} = '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} = '';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed. Note: AgentTicketActionCommon includes AgentTicketNote, AgentTicketClose, AgentTicketFreeText, AgentTicketOwner, AgentTicketPending, AgentTicketPriority and AgentTicketResponsible.'} = '';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = '定义 FAQ 项目的不受限文字字段.';
    $Self->{Translation}->{'Delete this FAQ'} = '删除';
    $Self->{Translation}->{'Edit this FAQ'} = '编辑';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = '';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = '';
    $Self->{Translation}->{'FAQ Journal'} = 'FAQ 日志';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = '';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = '';
    $Self->{Translation}->{'FAQ limit per page for FAQ Journal Overview "Small"'} = '';
    $Self->{Translation}->{'FAQ limit per page for FAQ Overview "Small"'} = '';
    $Self->{Translation}->{'FAQ path separator.'} = 'FAQ 路径分隔符.';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = '';
    $Self->{Translation}->{'FAQ-Area'} = '';
    $Self->{Translation}->{'Frontend module registration for the public interface.'} = '';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = '批准 FAQ 文章请求的群组.';
    $Self->{Translation}->{'History of this FAQ'} = '历史';
    $Self->{Translation}->{'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).'} = '';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Interfaces where the quicksearch should be shown.'} = '在介面的那里显示快速搜索.';
    $Self->{Translation}->{'Journal'} = '';
    $Self->{Translation}->{'Language Management'} = '';
    $Self->{Translation}->{'Languagekey which is defined in the language file *_FAQ.pm.'} = '';
    $Self->{Translation}->{'Link another object to this FAQ item'} = '链接';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the agent interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the customer interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the public interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} = '';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search.'} = '';
    $Self->{Translation}->{'New FAQ Article'} = '添加新文章';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = '新的 FAQ 文章在发布前需要批准.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the customer interface.'} = '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the public interface.'} = '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the customer interface.'} = '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the public interface.'} = '';
    $Self->{Translation}->{'Number of shown items in last changes.'} = '显示最近更改项目的数量.';
    $Self->{Translation}->{'Number of shown items in last created.'} = '显示最新创建项目的数量.';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = '显示点击量前十位项目的数量.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} = '';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} = '';
    $Self->{Translation}->{'Print this FAQ'} = '打印';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = '批准 FAQ 文章请求的队列.';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = '好评率, 键值必须在百分比以内.';
    $Self->{Translation}->{'Search FAQ'} = '';
    $Self->{Translation}->{'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.'} = '';
    $Self->{Translation}->{'Show "Insert FAQ Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} = '';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} = '';
    $Self->{Translation}->{'Show "Insert FAQ Text" Button in AgentFAQZoomSmall.'} = '';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = '';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = '是/否显示 FAQ 路径.';
    $Self->{Translation}->{'Show WYSIWYG editor in agent interface.'} = '在服务人员介面显示 WYSIWYG(所见即所得)编辑器.';
    $Self->{Translation}->{'Show items of subcategories.'} = '显示子目录的数量.';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = '在介面上显示最近更改的项目.';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = '在介面上显示最新创建的项目.';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = '在介面上显示点击量前十位.';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = '定义显示评分的介面.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'} = '';
    $Self->{Translation}->{'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".'} = '';
    $Self->{Translation}->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'} = 'FAQ 的标识符, 例如 (常见问题)FAQ#, (知识库)KB#, 默认为 FAQ#';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'} = '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'} = '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'} = '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'} = '';
    $Self->{Translation}->{'Ticket body for approval of FAQ article.'} = 'FAQ 文章批准请求的 Ticket 内容.';
    $Self->{Translation}->{'Ticket free text options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###AttributesView.'} = '';
    $Self->{Translation}->{'Ticket free time options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###AttributesView.'} = '';
    $Self->{Translation}->{'Ticket subject for approval of FAQ article.'} = 'FAQ 文章批准请求的 Ticket 主题.';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'A category needs at least one permission group!'} = '至少要指定一个群组对该目录拥有权限!';
    $Self->{Translation}->{'A category should have a comment!'} = '目录应该要有一个注释!';
    $Self->{Translation}->{'Agent groups which can access this category.'} = '哪一个群组可以访问此目录.';
    $Self->{Translation}->{'Articles'} = '文章';
    $Self->{Translation}->{'CSS color for the voting flag.'} = '评分标记的 CSS 颜色.';
    $Self->{Translation}->{'Categories'} = '目录';
    $Self->{Translation}->{'DetailSearch'} = '高级搜索';
    $Self->{Translation}->{'Do you really want to delete this Category?'} = '真的要删除该目录吗?';
    $Self->{Translation}->{'Do you really want to delete this Language?'} = '真的要删除该语言吗?';
    $Self->{Translation}->{'Explorer'} = '浏览';
    $Self->{Translation}->{'FAQ Category'} = 'FAQ 目录';
    $Self->{Translation}->{'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'} = '没有归类到目录. 要创建一篇文章需要归类到目录里, 请在 -目录菜单- 里选择您有权限创建文章的目录';
    $Self->{Translation}->{'SubCategories'} = '子目录';
    $Self->{Translation}->{'The title is required.'} = '标题是必须的.';
    $Self->{Translation}->{'This Category is parent of the following SubCategories'} = '该目录是以下子目录的父目录';
    $Self->{Translation}->{'This Category is used in the following FAQ Artice(s)'} = '该目录正被以下的 FAQ 文章所使用';
    $Self->{Translation}->{'This Language is used in the following FAQ Article(s)'} = '该语言正被以下的 FAQ 文章所使用';
    $Self->{Translation}->{'This category already exists!'} = '该目录已经在存在!';
    $Self->{Translation}->{'Updated'} = '更新';
    $Self->{Translation}->{'You can not delete this Category. It is used in at least one FAQ Article! and/or is parent of at least another Category'} = '不能删除该目录. 它至少还被一篇 FAQ 文章所使用 并/或 它是其中目录的父目录!';
    $Self->{Translation}->{'You can not delete this Language. It is used in at least one FAQ Article!'} = '不能删除该语言. 它至少还被一篇 FAQ 文章所使用!';

}

1;
