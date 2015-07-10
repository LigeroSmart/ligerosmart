# --
# Kernel/Language/zh_CN_FAQ.pm - translation file
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_FAQ;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAFAQ
    $Self->{Translation}->{'internal'} = '内部';
    $Self->{Translation}->{'public'} = '公开';
    $Self->{Translation}->{'external'} = '外部';
    $Self->{Translation}->{'FAQ Number'} = 'FAQ编号';
    $Self->{Translation}->{'Latest updated FAQ articles'} = '最近修改的FAQ文章';
    $Self->{Translation}->{'Latest created FAQ articles'} = '最近创建的FAQ文章';
    $Self->{Translation}->{'Top 10 FAQ articles'} = '最常用的文章';
    $Self->{Translation}->{'Subcategory of'} = '子类别于';
    $Self->{Translation}->{'No rate selected!'} = '没有选择投票!';
    $Self->{Translation}->{'Explorer'} = '浏览';
    $Self->{Translation}->{'public (all)'} = '公开(内外)';
    $Self->{Translation}->{'external (customer)'} = '外部(用户)';
    $Self->{Translation}->{'internal (agent)'} = '内部(服务人员)';
    $Self->{Translation}->{'Start day'} = '开始日期';
    $Self->{Translation}->{'Start month'} = '开始月份';
    $Self->{Translation}->{'Start year'} = '开始年份';
    $Self->{Translation}->{'End day'} = '结束日期';
    $Self->{Translation}->{'End month'} = '开始月份';
    $Self->{Translation}->{'End year'} = '结束年份';
    $Self->{Translation}->{'Thanks for your vote!'} = '感谢您的投票!';
    $Self->{Translation}->{'You have already voted!'} = '您已经投票!';
    $Self->{Translation}->{'FAQ Article Print'} = 'FAQ文章打印';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'FAQ文章(前10名)';
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'FAQ文章(新创建的)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'FAQ文章(最近修改的)';
    $Self->{Translation}->{'FAQ category updated!'} = 'FAQ类别已更新!';
    $Self->{Translation}->{'FAQ category added!'} = 'FAQ类别已添加!';
    $Self->{Translation}->{'A category should have a name!'} = '必需输入类别名称!';
    $Self->{Translation}->{'This category already exists'} = '类别已存在';
    $Self->{Translation}->{'FAQ language added!'} = 'FAQ语言已添加!';
    $Self->{Translation}->{'FAQ language updated!'} = 'FAQ语言已更新!';
    $Self->{Translation}->{'The name is required!'} = '名称是必需的!';
    $Self->{Translation}->{'This language already exists!'} = '该语言已经存在!';
    $Self->{Translation}->{'Symptom'} = '';
    $Self->{Translation}->{'Solution'} = '';

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = '添加FAQ文章';
    $Self->{Translation}->{'Keywords'} = '关键字';
    $Self->{Translation}->{'A category is required.'} = '类别是必需的.';
    $Self->{Translation}->{'Approval'} = '审批';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'FAQ类别管理';
    $Self->{Translation}->{'Add category'} = '添加类别';
    $Self->{Translation}->{'Delete Category'} = '删除类别';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Add Category'} = '添加类别';
    $Self->{Translation}->{'Edit Category'} = '编辑类别';
    $Self->{Translation}->{'Please select at least one permission group.'} = '请至少选择一个组权限.';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = '能访问此类别文章的服务人员组';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = '将作为注释在浏览时显示.';
    $Self->{Translation}->{'Do you really want to delete this category?'} = '你确定要删除这个类别吗?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        '你不能删除这个类别. 该类别至少包含一篇FAQ文章，或者至少包含一个子类别。';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = '下列FAQ文章使用该类别';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = '该类别是下列子类别的父类别';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = '你确定要删除该FAQ文章吗?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ知识库';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'FAQ浏览器';
    $Self->{Translation}->{'Quick Search'} = '快速搜索';
    $Self->{Translation}->{'Wildcards are allowed.'} = '允许使用通配符。';
    $Self->{Translation}->{'Advanced Search'} = '高级搜索';
    $Self->{Translation}->{'Subcategories'} = '子类别';
    $Self->{Translation}->{'FAQ Articles'} = 'FAQ文章';
    $Self->{Translation}->{'No subcategories found.'} = '没有找到子类别.';

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = '没有找到FAQ日志数据.';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'FAQ语言管理';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languges.'} =
        '如果需要支持多种语言，请使用此功能.';
    $Self->{Translation}->{'Add language'} = '添加语言';
    $Self->{Translation}->{'Delete Language %s'} = '删除语言 %s';
    $Self->{Translation}->{'Add Language'} = '添加语言';
    $Self->{Translation}->{'Edit Language'} = '编辑语言';
    $Self->{Translation}->{'Do you really want to delete this language?'} = '你确定要删除这个语言吗?';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        '你不能删除这个语言. 至少有一篇FAQ文章使用该语言!';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = '下列FAQ文章使用该语言';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = '上下文设置';
    $Self->{Translation}->{'FAQ articles per page'} = '每页显示的FAQ文章个数';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = '没有找到FAQ数据.';

    # Template: AgentFAQPrint
    $Self->{Translation}->{'FAQ-Info'} = 'FAQ信息';
    $Self->{Translation}->{'Votes'} = '投票次数';
    $Self->{Translation}->{'Last update'} = '上次更新';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = '关键字';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = '投票次数 (例如，= 10 或 >= 60)';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = '评分 (例如，= 10% 或 >= 75%)';
    $Self->{Translation}->{'Approved'} = '通过审批';
    $Self->{Translation}->{'Last changed by'} = '上次修改人';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = 'FAQ文章创建时间(相对)';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = 'FAQ文章创建时间(绝对)';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = 'FAQ文章创建时间(相对)';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = 'FAQ文章创建时间(绝对)';

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'FAQ全文';

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'FAQ搜索';
    $Self->{Translation}->{'Profile Selection'} = '';
    $Self->{Translation}->{'Vote'} = '投票';
    $Self->{Translation}->{'No vote settings'} = '';
    $Self->{Translation}->{'Specific votes'} = '';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = '';
    $Self->{Translation}->{'Rate'} = '评分';
    $Self->{Translation}->{'No rate settings'} = '';
    $Self->{Translation}->{'Specific rate'} = '';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = '';
    $Self->{Translation}->{'FAQ Article Create Time'} = 'FAQ文章创建时间';
    $Self->{Translation}->{'Specific date'} = '';
    $Self->{Translation}->{'Date range'} = '日期范围';
    $Self->{Translation}->{'FAQ Article Change Time'} = 'FAQ文章修改时间';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'FAQ详细信息';
    $Self->{Translation}->{'Rating'} = '投票';
    $Self->{Translation}->{'out of 5'} = '(5分制)';
    $Self->{Translation}->{'No votes found!'} = '没有找到投票!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = '没有找到投票! 这将是该 FAQ 文章的第一个投票.';
    $Self->{Translation}->{'Download Attachment'} = '下载附件';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        '';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        '此文档对您有帮助吗？请给出您的评价，谢谢！';
    $Self->{Translation}->{'not helpful'} = '没有帮助';
    $Self->{Translation}->{'very helpful'} = '很有帮助';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Add FAQ title to article subject'} = '';
    $Self->{Translation}->{'Insert FAQ Text'} = '插入FAQ文本';
    $Self->{Translation}->{'Insert Full FAQ'} = '插入FAQ';
    $Self->{Translation}->{'Insert FAQ Link'} = '插入FAQ链接';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = '插入FAQ正文和链接';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = '插入FAQ和链接';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = '';

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = '';
    $Self->{Translation}->{'Vote restrictions'} = '';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = '';
    $Self->{Translation}->{'Rate restrictions'} = '';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = '';
    $Self->{Translation}->{'Only FAQ articles created'} = '';
    $Self->{Translation}->{'Only FAQ articles created between'} = '';
    $Self->{Translation}->{'Search-Profile as Template?'} = '搜索配置作为模板？';

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = '';
    $Self->{Translation}->{'Search for articles with keyword'} = '';

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = '公开';

    # Template: PublicFAQSearchResultShort
    $Self->{Translation}->{'Back to FAQ Explorer'} = '';

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} =
        '';
    $Self->{Translation}->{'CSS color for the voting result.'} = '';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = '';
    $Self->{Translation}->{'Category Management'} = '管理类别';
    $Self->{Translation}->{'Decimal places of the voting result.'} = '以十分制显示评分结果.';
    $Self->{Translation}->{'Default category name.'} = '默认的目录名.';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = '';
    $Self->{Translation}->{'Default maximum size of the titles in a FAQ article to be shown.'} =
        '';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        'FAQ 文章批准请求的 Ticket 的优先级.';
    $Self->{Translation}->{'Default state for FAQ entry.'} = '默认的 FAQ 统计条目.';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'FAQ 文章批准请求的 Ticket 的默认状态.';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} =
        '';
    $Self->{Translation}->{'Define if the FAQ title should be concatenated to article subject.'} =
        '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} =
        '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the customer interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the agent interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the customer interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the public interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default shown FAQ search attribute for FAQ search screen.'} =
        '';
    $Self->{Translation}->{'Defines the information to be inserted in a FAQ based Ticket. "Full FAQ" includes text, attachments and inline images.'} =
        '';
    $Self->{Translation}->{'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed.'} = '';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = '定义 FAQ 项目的不受限文字字段.';
    $Self->{Translation}->{'Delete this FAQ'} = '删除FAQ';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ add screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ edit screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Edit this FAQ'} = '编辑FAQ';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = '';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = '';
    $Self->{Translation}->{'FAQ Journal'} = 'FAQ日志';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = '';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = '';
    $Self->{Translation}->{'FAQ limit per page for FAQ Journal Overview "Small"'} = '';
    $Self->{Translation}->{'FAQ limit per page for FAQ Overview "Small"'} = '';
    $Self->{Translation}->{'FAQ path separator.'} = 'FAQ 路径分隔符.';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = '';
    $Self->{Translation}->{'FAQ-Area'} = '';
    $Self->{Translation}->{'Field4'} = '';
    $Self->{Translation}->{'Field5'} = '';
    $Self->{Translation}->{'Frontend module registration for the public interface.'} = '';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = '批准 FAQ 文章请求的群组.';
    $Self->{Translation}->{'History of this FAQ'} = 'FAQ文章历史信息';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Interfaces where the quick search should be shown.'} = '';
    $Self->{Translation}->{'Journal'} = '日志';
    $Self->{Translation}->{'Language Management'} = '管理语言';
    $Self->{Translation}->{'Link another object to this FAQ item'} = '链接对象至FAQ';
    $Self->{Translation}->{'List of state types which can be used in the agent interface.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the customer interface.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the customer interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the customer interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ journal in the agent interface.'} =
        '';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the public interface.'} =
        '';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short faq search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search.'} =
        '';
    $Self->{Translation}->{'New FAQ Article'} = '创建FAQ文章';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the customer interface.'} =
        '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the public interface.'} =
        '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the customer interface.'} =
        '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the public interface.'} =
        '';
    $Self->{Translation}->{'Number of shown items in last changes.'} = '显示最近更改项目的数量.';
    $Self->{Translation}->{'Number of shown items in last created.'} = '显示最新创建项目的数量.';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = '显示点击量前十位项目的数量.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} =
        '';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} =
        '';
    $Self->{Translation}->{'Print this FAQ'} = '打印FAQ';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = '批准 FAQ 文章请求的队列.';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = '好评率, 键值必须在百分比以内.';
    $Self->{Translation}->{'Search FAQ'} = '搜索FAQ';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        '';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        '';
    $Self->{Translation}->{'Show "Insert FAQ Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        '';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" / "Insert Full FAQ & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        '';
    $Self->{Translation}->{'Show "Insert FAQ Text" / "Insert Full FAQ" Button in AgentFAQZoomSmall.'} =
        '';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = '以 HTML 格式显示 FAQ 文章';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = '是/否显示 FAQ 路径.';
    $Self->{Translation}->{'Show items of subcategories.'} = '显示子目录的数量.';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = '在介面上显示最近更改的项目.';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = '在介面上显示最新创建的项目.';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = '在介面上显示点击量前十位.';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = '定义显示评分的介面.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'} =
        'FAQ 的标识符, 例如 (常见问题)FAQ#, (知识库)KB#, 默认为 FAQ#';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'Ticket body for approval of FAQ article.'} = 'FAQ 文章批准请求的 Ticket 内容.';
    $Self->{Translation}->{'Ticket subject for approval of FAQ article.'} = 'FAQ 文章批准请求的 Ticket 主题.';

}

1;
