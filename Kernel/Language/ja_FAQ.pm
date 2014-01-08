# --
# Kernel/Language/ja_FAQ.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ja_FAQ;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAFAQ
    $Self->{Translation}->{'internal'} = '内部向';
    $Self->{Translation}->{'public'} = '公開';
    $Self->{Translation}->{'external'} = '外部向';
    $Self->{Translation}->{'FAQ Number'} = 'FAQナンバー';
    $Self->{Translation}->{'Latest updated FAQ articles'} = '';
    $Self->{Translation}->{'Latest created FAQ articles'} = '';
    $Self->{Translation}->{'Top 10 FAQ articles'} = '';
    $Self->{Translation}->{'Subcategory of'} = '';
    $Self->{Translation}->{'No rate selected!'} = '評価が選択されていません。';
    $Self->{Translation}->{'Explorer'} = '一覧';
    $Self->{Translation}->{'public (all)'} = '公開 (全員)';
    $Self->{Translation}->{'external (customer)'} = '外部 (顧客)';
    $Self->{Translation}->{'internal (agent)'} = '内部 (担当者)';
    $Self->{Translation}->{'Start day'} = '';
    $Self->{Translation}->{'Start month'} = '';
    $Self->{Translation}->{'Start year'} = '';
    $Self->{Translation}->{'End day'} = '';
    $Self->{Translation}->{'End month'} = '';
    $Self->{Translation}->{'End year'} = '';
    $Self->{Translation}->{'Thanks for your vote!'} = '評価をいただきありがとうございます。';
    $Self->{Translation}->{'You have already voted!'} = 'あなたはすでに評価済です。';
    $Self->{Translation}->{'FAQ Article Print'} = '記事印刷';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = '上位10件の記事';
    $Self->{Translation}->{'FAQ Articles (new created)'} = '新着記事';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = '最近更新された記事';
    $Self->{Translation}->{'FAQ category updated!'} = 'カテゴリが更新されました。';
    $Self->{Translation}->{'FAQ category added!'} = '新しいカテゴリが追加されました。';
    $Self->{Translation}->{'A category should have a name!'} = '「名前」は必須項目です。';
    $Self->{Translation}->{'This category already exists'} = 'このカテゴリはすでに存在しています。';
    $Self->{Translation}->{'FAQ language added!'} = '言語が追加されました。';
    $Self->{Translation}->{'FAQ language updated!'} = '言語が更新されました。';
    $Self->{Translation}->{'The name is required!'} = '「名前」は必須項目です。';
    $Self->{Translation}->{'This language already exists!'} = 'この言語は設定済です。';

    # Template: AgentDashboardFAQOverview

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'FAQの新規追加';
    $Self->{Translation}->{'Keywords'} = '';
    $Self->{Translation}->{'A category is required.'} = 'カテゴリは必須項目です。';
    $Self->{Translation}->{'Approval'} = '承認';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'FAQ カテゴリ管理';
    $Self->{Translation}->{'Add category'} = 'カテゴリを追加';
    $Self->{Translation}->{'Delete Category'} = 'カテゴリを削除';
    $Self->{Translation}->{'Ok'} = 'はい';
    $Self->{Translation}->{'Add Category'} = 'カテゴリを追加';
    $Self->{Translation}->{'Edit Category'} = 'カテゴリを編集';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = '一覧でコメントとして表示されます。';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'ひとつ以上の権限のグループを選択してください。';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'このカテゴリで項目にアクセスできるエージェントグループ';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'このカテゴリを削除してよろしいですか？';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        'このカテゴリを削除することはできません。一つ以上のFAQ記事で使用されているか、または他のカテゴリの親カテゴリになっています。';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'このカテゴリは以下の記事で使用されています。';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'このカテゴリは以下のカテゴリの親カテゴリです。';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'この記事を削除してよろしいですか？';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = '';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'FAQ一覧';
    $Self->{Translation}->{'Quick Search'} = '検索';
    $Self->{Translation}->{'Wildcards are allowed.'} = '';
    $Self->{Translation}->{'Advanced Search'} = '高機能検索';
    $Self->{Translation}->{'Subcategories'} = 'サブカテゴリ';
    $Self->{Translation}->{'FAQ Articles'} = 'FAQ項目';
    $Self->{Translation}->{'No subcategories found.'} = '子カテゴリはありません。';

    # Template: AgentFAQHistory

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'ジャーナルの情報がありません。';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'FAQ 言語管理';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languges.'} =
        '多言語で作業をしたい場合、この項目を設定してください。';
    $Self->{Translation}->{'Add language'} = '言語を追加';
    $Self->{Translation}->{'Delete Language'} = '言語を削除';
    $Self->{Translation}->{'Add Language'} = '言語を追加';
    $Self->{Translation}->{'Edit Language'} = '言語を編集';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'この言語を削除してよろしいですか？';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        'この言語を削除することはできません。一つ以上のFAQで使用されています！';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'この言語は、以下のFAQで使用されています。';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'コンテキストの設定';
    $Self->{Translation}->{'FAQ articles per page'} = 'ページ毎の記事数';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'FAQデータはありません。';
    $Self->{Translation}->{'A generic FAQ table'} = '';
    $Self->{Translation}->{'","50'} = '';

    # Template: AgentFAQPrint
    $Self->{Translation}->{'FAQ-Info'} = 'FAQ情報';
    $Self->{Translation}->{'Votes'} = 'Votes';
    $Self->{Translation}->{'Last update'} = '';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = '';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = '';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = '';
    $Self->{Translation}->{'Approved'} = '';
    $Self->{Translation}->{'Last changed by'} = '';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = '';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = '';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = '';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = '';
    $Self->{Translation}->{'Run Search'} = '';

    # Template: AgentFAQSearchOpenSearchDescriptionFAQNumber

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'FAQ全文';

    # Template: AgentFAQSearchResultPrint

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = '';
    $Self->{Translation}->{'Profile Selection'} = '';
    $Self->{Translation}->{'Vote'} = '';
    $Self->{Translation}->{'No vote settings'} = '';
    $Self->{Translation}->{'Specific votes'} = '';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = '';
    $Self->{Translation}->{'Rate'} = '';
    $Self->{Translation}->{'No rate settings'} = '';
    $Self->{Translation}->{'Specific rate'} = '';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = '';
    $Self->{Translation}->{'FAQ Article Create Time'} = '';
    $Self->{Translation}->{'Specific date'} = '';
    $Self->{Translation}->{'Date range'} = '';
    $Self->{Translation}->{'FAQ Article Change Time'} = '';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'FAQ情報';
    $Self->{Translation}->{'","18'} = '';
    $Self->{Translation}->{'","25'} = '';
    $Self->{Translation}->{'Rating'} = 'レーティング';
    $Self->{Translation}->{'Rating %'} = 'レーティング（％）';
    $Self->{Translation}->{'out of 5'} = '5つ星のうち';
    $Self->{Translation}->{'No votes found!'} = '投票はありません。';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = '投票はありません。この記事に始めて評価を投票しましょう。';
    $Self->{Translation}->{'Download Attachment'} = '添付ファイルをダウンロード';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        '';
    $Self->{Translation}->{'not helpful'} = 'あまり役に立たなかった';
    $Self->{Translation}->{'very helpful'} = 'とても役に立った';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Insert FAQ Text'} = '記事を挿入する';
    $Self->{Translation}->{'Insert Full FAQ'} = '';
    $Self->{Translation}->{'Insert FAQ Link'} = 'リンクを挿入する';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = '記事とリンクを挿入する';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = '';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = '該当する記事はありません。';

    # Template: CustomerFAQPrint

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'FAQ全文検索（例："John*n"、"Will*"）';
    $Self->{Translation}->{'Vote restrictions'} = '';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = '';
    $Self->{Translation}->{'Rate restrictions'} = '';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = '';
    $Self->{Translation}->{'Only FAQ articles created'} = '';
    $Self->{Translation}->{'Only FAQ articles created between'} = '';
    $Self->{Translation}->{'Search-Profile as Template?'} = '';

    # Template: CustomerFAQSearchOpenSearchDescriptionFAQNumber

    # Template: CustomerFAQSearchOpenSearchDescriptionFullText

    # Template: CustomerFAQSearchResultPrint

    # Template: CustomerFAQSearchResultShort

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = '';
    $Self->{Translation}->{'Search for articles with keyword'} = '記事のキーワード検索';

    # Template: PublicFAQExplorer

    # Template: PublicFAQPrint

    # Template: PublicFAQSearch

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = '公開';

    # Template: PublicFAQSearchOpenSearchDescriptionFullText

    # Template: PublicFAQSearchResultPrint

    # Template: PublicFAQSearchResultShort

    # Template: PublicFAQZoom

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} =
        '';
    $Self->{Translation}->{'CSS color for the voting result.'} = '評価の結果表示ようのカラー（スタイルシート）';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = '';
    $Self->{Translation}->{'Category Management'} = 'カテゴリー管理';
    $Self->{Translation}->{'Decimal places of the voting result.'} = '投票の結果の小数点以下の桁数';
    $Self->{Translation}->{'Default category name.'} = '既定のカテゴリ';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = '規定の言語（単一言語モードで運用時）';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        'FAQへの取り込みを行うチケットの優先順位の既定値';
    $Self->{Translation}->{'Default state for FAQ entry.'} = '記事エントリー時の規定のステータス';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'FAQへの取り込みを行うチケットの優先順位の既定値';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} =
        '公開画面用パラメータのデフォルト値。パラメータ（Action=XXXXXX）は、スクリプトで使用されています。';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} =
        '簡易版FAQジャーナル表示用モジュールの概要を定義';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} =
        '簡易版FAQ一覧表示用モジュールの概要を定義';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} =
        'エージェント用画面における、FAQ検索結果並び替えに利用する属性順の既定値を定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} =
        '顧客用画面における、FAQ検索結果並び替えに利用する属性順の既定値を定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} =
        '公開画面における、FAQ検索結果並び替えに利用する属性順の既定値を定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the agent interface.'} =
        'エージェント用画面（FAQ一覧）における、FAQ検索結果並び替えに利用する属性順の既定値を定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the customer interface.'} =
        '顧客用画面（FAQ一覧）における、FAQ検索結果並び替えに利用する属性順の既定値を定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} =
        '公開画面（FAQ一覧）における、FAQ検索結果並び替えに利用する属性順の既定値を定義します。';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the agent interface. Up: oldest on top. Down: latest on top.'} =
        'エージェント用画面における、FAQ一覧の表示順の既定値を定義します。\'Up\'→古い順 / \'Down\'→新しい順';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the customer interface. Up: oldest on top. Down: latest on top.'} =
        '顧客用画面における、FAQ一覧の表示順の既定値を定義します。\'Up\'→古い順 / \'Down\'→新しい順';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the public interface. Up: oldest on top. Down: latest on top.'} =
        '公開画面における、FAQ一覧の表示順の既定値を定義します。\'Up\'→古い順 / \'Down\'→新しい順';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} =
        'エージェント用画面（FAQ一覧）における、FAQ検索結果並び順の既定値を定義します。\'Up\'→古い順 / \'Down\'→新しい順';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} =
        '顧客用画面における、FAQ検索結果並び順の既定値を定義します。\'Up\'→古い順 / \'Down\'→新しい順';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} =
        '公開画面における、FAQ検索結果並び順の既定値を定義します。\'Up\'→古い順 / \'Down\'→新しい順';
    $Self->{Translation}->{'Defines the information to be inserted in a FAQ based Ticket. "Full FAQ" includes text, attachments and inline images.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} =
        'エージェント用画面における、FAQ一覧での表示項目の設定。この設定によって項目の並び順を制御することはできません。';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} =
        '顧客用画面における、FAQ一覧での表示項目の設定。この設定によって項目の並び順を制御することはできません。';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} =
        '公開画面における、FAQ一覧での表示項目の設定。この設定によって項目の並び順を制御することはできません。';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed. Note: AgentTicketActionCommon includes AgentTicketNote, AgentTicketClose, AgentTicketFreeText, AgentTicketOwner, AgentTicketPending, AgentTicketPriority and AgentTicketResponsible.'} =
        '定義済の要素にリンクを付加するモジュールです。画像要素については2通りの入力方法があります。ひとつは「faq.png」のように画像のファイル名を指定する方法。このケースではOTRSのイメージパスが使用されます。もうひとつはURLを指定する方法です。';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = 'FAQのフリーテキストフィールドの定義。';
    $Self->{Translation}->{'Delete this FAQ'} = 'この記事を削除';
    $Self->{Translation}->{'Edit this FAQ'} = 'この記事を編集';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = '多言語を有効にする';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = '評価の機能を有効にする';
    $Self->{Translation}->{'FAQ Journal'} = 'FAQ ジャーナル';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = 'FAQジャーナル一覧(S)の表示数';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = 'FAQ一覧(S)の表示数';
    $Self->{Translation}->{'FAQ limit per page for FAQ Journal Overview "Small"'} = 'FAQジャーナル一覧(S)の1ページ毎の表示数';
    $Self->{Translation}->{'FAQ limit per page for FAQ Overview "Small"'} = 'FAQ一覧(S)の1ページ毎の表示数';
    $Self->{Translation}->{'FAQ path separator.'} = 'パスインフォを使用する際のセパレータ文字（例：\'/\'）';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = 'エージェント用画面における、FAQ検索のバックエンドルータ';
    $Self->{Translation}->{'FAQ-Area'} = '';
    $Self->{Translation}->{'Frontend module registration for the public interface.'} = '公開画面のフロントエンドモジュールの定義';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = 'FAQの記事の承認のためのグループ';
    $Self->{Translation}->{'History of this FAQ'} = 'この記事の履歴';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = 'FAQ由来のチケットに含まれる内部項目';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = 'FAQ由来のチケットに含まれる内部項目すべての名称';
    $Self->{Translation}->{'Interfaces where the quicksearch should be shown.'} = '検索窓を表示する画面を設定';
    $Self->{Translation}->{'Journal'} = 'ジャーナル';
    $Self->{Translation}->{'Language Management'} = '言語管理';
    $Self->{Translation}->{'Link another object to this FAQ item'} = 'この記事から他の記事へのリンク';
    $Self->{Translation}->{'List of state types which can be used in the agent interface.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the customer interface.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the agent interface.'} =
        'エージェント画面のFAQ一覧で表示する記事の最大数';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the customer interface.'} =
        '顧客用画面のFAQ一覧で表示する記事の最大数';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the public interface.'} =
        '公開画面のFAQ一覧で表示する記事の最大数';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} =
        'エージェント画面のFAQジャーナルで表示する記事の最大数';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} =
        '';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search in the public interface.'} =
        '';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search.'} =
        '';
    $Self->{Translation}->{'New FAQ Article'} = '';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the customer interface.'} =
        '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the public interface.'} =
        '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the customer interface.'} =
        '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the public interface.'} =
        '';
    $Self->{Translation}->{'Number of shown items in last changes.'} = '「最近の変更」に何件まで表示するか';
    $Self->{Translation}->{'Number of shown items in last created.'} = '「最新の新規作成」に何件まで表示するか';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = '「トップ10記事」に何件まで表示するか';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} =
        '簡易版FAQジャーナル一覧のページ指定用のパラメータ';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} =
        '簡易版FAQ概要のページ指定用のパラメータ';
    $Self->{Translation}->{'Print this FAQ'} = 'この記事を印刷';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = '記事承認キュー';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = '評価率。キーは、パーセントで指定する必要があります。';
    $Self->{Translation}->{'Search FAQ'} = 'FAQを検索';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        '';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        '';
    $Self->{Translation}->{'Show "Insert FAQ Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        '\'AgentFAQZoomSmall\'の設定。公開画面において「リンクを挿入する」ボタンを表示する/表示しない';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" / "Insert Full FAQ & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        '';
    $Self->{Translation}->{'Show "Insert FAQ Text" / "Insert Full FAQ" Button in AgentFAQZoomSmall.'} =
        '';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = '記事でHTMLタグを表示する/表示しない';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = '記事のパスを表示する/表示しない';
    $Self->{Translation}->{'Show items of subcategories.'} = 'サブカテゴリーのトピックを表示する/表示しない';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = '最新の変更を表示する画面（エージェント用/顧客用/公開）を定義';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = '最新の新規作成を表示する画面（エージェント用/顧客用/公開）を定義';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = 'トップ10を表示する画面（エージェント用/顧客用/公開）を定義';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = '評価を表示する画面（エージェント用/顧客用/公開）を定義';
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
        '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'} =
        '‘Normal’リンク・タイプを使用して、‘FAQ’オブジェクトが他の‘FAQ’オブジェクトとリンクされるように、定義します。';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '‘ParentChild’リンク・タイプを使用して、‘FAQ’オブジェクトが他の‘FAQ’オブジェクトとリンクされるように、定義します。';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'} =
        '‘Normal’リンク・タイプを使用して、‘FAQ’オブジェクトが他の‘Ticket’オブジェクトとリンクされるように、定義します。';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'} =
        '‘ParentChild’リンク・タイプを使用して、‘FAQ’オブジェクトが他の‘Ticket’オブジェクトとリンクされるように、定義します。';
    $Self->{Translation}->{'Ticket body for approval of FAQ article.'} = '';
    $Self->{Translation}->{'Ticket subject for approval of FAQ article.'} = '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Agent groups which can access this category.'} = 'このカテゴリにアクセス可能なエージェントグループ';
    $Self->{Translation}->{'Categories'} = 'カテゴリ';
    $Self->{Translation}->{'DetailSearch'} = '詳細検索';
    $Self->{Translation}->{'EndDay'} = '終了日';
    $Self->{Translation}->{'EndMonth'} = '終了月';
    $Self->{Translation}->{'EndYear'} = '終了年';
    $Self->{Translation}->{'Languagekey which is defined in the language file *_FAQ.pm.'} = '言語ファイル（*_FAQ.pm）で定義されているLanguagekey';
    $Self->{Translation}->{'LatestChangedItems'} = '最近変更されたアイテム';
    $Self->{Translation}->{'LatestCreatedItems'} = '最近作成されたアイテム';
    $Self->{Translation}->{'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'} =
        'カテゴリにアクセスできません。記事を作成するには、1つ以上のカテゴリにアクセスする必要があります。カテゴリのメニューにおいて、あなたのグループ/カテゴリに権限を与えてください。';
    $Self->{Translation}->{'Problem'} = '問題';
    $Self->{Translation}->{'QuickSearch'} = '検索';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        '\'AgentFAQZoomSmall\'の設定。公開画面において「テキストとリンクを挿入する」ボタンを表示する/表示しない';
    $Self->{Translation}->{'Show "Insert FAQ Text" Button in AgentFAQZoomSmall.'} = '\'AgentFAQZoomSmall\'の設定。「テキストを挿入する」ボタンを表示する/表示しない';
    $Self->{Translation}->{'Show WYSIWYG editor in agent interface.'} = 'エージェント画面においてWYSIWYGエディタを表示する/表示しない';
    $Self->{Translation}->{'StartDay'} = '開始日';
    $Self->{Translation}->{'StartMonth'} = '開始月';
    $Self->{Translation}->{'StartYear'} = '開始年';
    $Self->{Translation}->{'SubCategoryOf'} = '親カテゴリ';
    $Self->{Translation}->{'Symptom'} = '症状';
    $Self->{Translation}->{'Top10Items'} = 'トップ10アクセス';

}

1;
