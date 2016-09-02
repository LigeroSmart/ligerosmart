# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ja_FAQ;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAFAQ
    $Self->{Translation}->{'internal'} = '内部向';
    $Self->{Translation}->{'public'} = '公開';
    $Self->{Translation}->{'external'} = '外部向';
    $Self->{Translation}->{'FAQ Number'} = 'FAQナンバー';
    $Self->{Translation}->{'Latest updated FAQ articles'} = '最後に更新されたFAQ項目';
    $Self->{Translation}->{'Latest created FAQ articles'} = '最後に作成されたFAQ項目';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Top 10 FAQ項目';
    $Self->{Translation}->{'Subcategory of'} = '親カテゴリ';
    $Self->{Translation}->{'No rate selected!'} = '評価が選択されていません。';
    $Self->{Translation}->{'Explorer'} = '一覧';
    $Self->{Translation}->{'public (all)'} = '公開 (全員)';
    $Self->{Translation}->{'external (customer)'} = '外部 (顧客)';
    $Self->{Translation}->{'internal (agent)'} = '内部 (担当者)';
    $Self->{Translation}->{'Start day'} = '開始日';
    $Self->{Translation}->{'Start month'} = '開始月';
    $Self->{Translation}->{'Start year'} = '開始年';
    $Self->{Translation}->{'End day'} = '終了日';
    $Self->{Translation}->{'End month'} = '終了月';
    $Self->{Translation}->{'End year'} = '終了年';
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
    $Self->{Translation}->{'Symptom'} = '症状';
    $Self->{Translation}->{'Solution'} = '解決';

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'FAQの新規追加';
    $Self->{Translation}->{'Keywords'} = 'キーワード';
    $Self->{Translation}->{'A category is required.'} = 'カテゴリは必須項目です。';
    $Self->{Translation}->{'Approval'} = '承認';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'FAQ カテゴリ管理';
    $Self->{Translation}->{'Add category'} = 'カテゴリを追加';
    $Self->{Translation}->{'Delete Category'} = 'カテゴリを削除';
    $Self->{Translation}->{'Ok'} = 'はい';
    $Self->{Translation}->{'Add Category'} = 'カテゴリを追加';
    $Self->{Translation}->{'Edit Category'} = 'カテゴリを編集';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'ひとつ以上の権限のグループを選択してください。';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'このカテゴリで項目にアクセスできる担当者グループ';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = '一覧でコメントとして表示されます。';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'このカテゴリを削除してよろしいですか？';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        'このカテゴリを削除することはできません。一つ以上のFAQ記事で使用されているか、または他のカテゴリの親カテゴリになっています。';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'このカテゴリは以下の記事で使用されています。';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'このカテゴリは以下のカテゴリの親カテゴリです。';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'この記事を削除してよろしいですか？';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'FAQ一覧';
    $Self->{Translation}->{'Quick Search'} = '検索';
    $Self->{Translation}->{'Wildcards are allowed.'} = 'ワイルドカードが利用可能です。';
    $Self->{Translation}->{'Advanced Search'} = '高機能検索';
    $Self->{Translation}->{'Subcategories'} = 'サブカテゴリ';
    $Self->{Translation}->{'FAQ Articles'} = 'FAQ項目';
    $Self->{Translation}->{'No subcategories found.'} = '子カテゴリはありません。';

    # Template: AgentFAQHistory
    $Self->{Translation}->{'History of'} = '履歴: ';

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'ジャーナルの情報がありません。';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'FAQ 言語管理';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languages.'} =
        '';
    $Self->{Translation}->{'Add language'} = '言語を追加';
    $Self->{Translation}->{'Delete Language %s'} = '言語を削除 %s';
    $Self->{Translation}->{'Add Language'} = '言語を追加';
    $Self->{Translation}->{'Edit Language'} = '言語を編集';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'この言語を削除してよろしいですか？';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        'この言語を削除することはできません。一つ以上のFAQで使用されています！';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'この言語は、以下のFAQで使用されています。';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = '設定';
    $Self->{Translation}->{'FAQ articles per page'} = 'ページ毎の記事数';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'FAQデータはありません。';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = 'キーワード';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = '投票 (例. 10に等しい あるいは 60より大きい)';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = 'レート (例. 25%に等しい あるいは 75%より大きい)';
    $Self->{Translation}->{'Approved'} = '承認';
    $Self->{Translation}->{'Last changed by'} = '最終更新者';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = 'FAQ項目作成日時 (範囲指定)';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = 'FAQ項目作成日時 (期間指定)';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = 'FAQ項目変更日時 (範囲指定)';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = 'FAQ項目変更日時 (期間指定)';

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'FAQ全文';

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'FAQ検索';
    $Self->{Translation}->{'Profile Selection'} = 'プロファイル選択';
    $Self->{Translation}->{'Vote'} = '投票';
    $Self->{Translation}->{'No vote settings'} = '投票の設定がありません';
    $Self->{Translation}->{'Specific votes'} = '特定の投票';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = '例. 10 に等しい あるいは 60 より大きい';
    $Self->{Translation}->{'Rate'} = 'レート';
    $Self->{Translation}->{'No rate settings'} = 'れーとの設定がありません';
    $Self->{Translation}->{'Specific rate'} = '特定のレート';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = '例. 25%に等しい あるいは 75%以上';
    $Self->{Translation}->{'FAQ Article Create Time'} = 'FAQ項目作成時間';
    $Self->{Translation}->{'FAQ Article Change Time'} = 'FAQ項目変更時間';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'FAQ情報';
    $Self->{Translation}->{'Rating'} = 'レーティング';
    $Self->{Translation}->{'out of 5'} = '5つ星のうち';
    $Self->{Translation}->{'Votes'} = 'Votes';
    $Self->{Translation}->{'No votes found!'} = '投票はありません。';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = '投票はありません。この記事に最初の評価を投票しましょう。';
    $Self->{Translation}->{'Download Attachment'} = '添付ファイルをダウンロード';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        '(一部のOSにおいては)下記のリンクをオープンするためにクリック時に、Ctrl あるいは Cmd または Shiftキーを押下する必要がる場合があります。';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        'このFAQ項目はお役にたちましたか? 　FAQデーターベースの改善に役立てますので、レーティングに協力ください。よろしくお願いします';
    $Self->{Translation}->{'not helpful'} = 'あまり役に立たなかった';
    $Self->{Translation}->{'very helpful'} = 'とても役に立った';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Add FAQ title to article subject'} = '項目の主題にFAQタイトルを追加する';
    $Self->{Translation}->{'Insert FAQ Text'} = '記事を挿入する';
    $Self->{Translation}->{'Insert Full FAQ'} = 'FAQ全文を挿入する';
    $Self->{Translation}->{'Insert FAQ Link'} = 'リンクを挿入する';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = '記事とリンクを挿入する';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = 'FAQ全文とリンクを挿入する';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = '該当する記事はありません。';

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'FAQ全文検索（例："John*n"、"Will*"）';
    $Self->{Translation}->{'Vote restrictions'} = '投票規制';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = '投票されているFAQのみ...';
    $Self->{Translation}->{'Rate restrictions'} = 'レート規制';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = 'レートされているFAQのみ...';
    $Self->{Translation}->{'Only FAQ articles created'} = '作成されたFAQ項目のみ';
    $Self->{Translation}->{'Only FAQ articles created between'} = '期間内に作成されたFAQ項目のみ';
    $Self->{Translation}->{'Search-Profile as Template?'} = 'Search-Profile-検索プロフィール　をテンプレートにしますか?';

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = ' FAQ 項目ナンバー';
    $Self->{Translation}->{'Search for articles with keyword'} = '記事のキーワード検索';

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = '公開';

    # Template: PublicFAQSearchResultShort
    $Self->{Translation}->{'Back to FAQ Explorer'} = 'FAQエクスプローラーに戻る';

    # Perl Module: Kernel/Modules/AgentFAQJournal.pm
    $Self->{Translation}->{'FAQ Journal'} = 'FAQ ジャーナル';

    # Perl Module: Kernel/Modules/AgentFAQPrint.pm
    $Self->{Translation}->{'Last update'} = '最終更新日';
    $Self->{Translation}->{'FAQ Dynamic Fields'} = 'FAQ ダイナミック・フィールド';

    # Perl Module: Kernel/Modules/AgentFAQSearch.pm
    $Self->{Translation}->{'No Result!'} = '結果がありません。';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/AgentFAQSearch.pm
    $Self->{Translation}->{'%s (FAQFulltext)'} = '';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/CustomerFAQSearch.pm
    $Self->{Translation}->{'%s - Customer (%s)'} = '';
    $Self->{Translation}->{'%s - Customer (FAQFulltext)'} = '';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/PublicFAQSearch.pm
    $Self->{Translation}->{'%s - Public (%s)'} = '';
    $Self->{Translation}->{'%s - Public (FAQFulltext)'} = '';

    # Perl Module: Kernel/Output/HTML/Layout/FAQ.pm
    $Self->{Translation}->{'This article is empty!'} = 'この記事は空です!';

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} =
        'フィルタ定義　-定義された文字列（string）にリンクを追加するhtmlアウトプット-  エレメント・イメージは、2種類のインプットが可能です。1つ目、イメージの名前です (例. faq.png)。この場合、OTRSイメージ・パスが使用されます。2つ目、イメージにリンクを挿入することが可能性です。';
    $Self->{Translation}->{'Add FAQ article'} = '';
    $Self->{Translation}->{'CSS color for the voting result.'} = '評価の結果表示ようのカラー（スタイルシート）';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = 'FAQ項目から離脱するまでのキャッシュ時間';
    $Self->{Translation}->{'Category Management'} = 'カテゴリー管理';
    $Self->{Translation}->{'Customer FAQ Print.'} = '';
    $Self->{Translation}->{'Customer FAQ Zoom.'} = '';
    $Self->{Translation}->{'Customer FAQ search.'} = '';
    $Self->{Translation}->{'Customer FAQ.'} = '';
    $Self->{Translation}->{'Decimal places of the voting result.'} = '投票の結果の小数点以下の桁数';
    $Self->{Translation}->{'Default category name.'} = '既定のカテゴリ';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = '規定の言語（単一言語モードで運用時）';
    $Self->{Translation}->{'Default maximum size of the titles in a FAQ article to be shown.'} =
        'デフォルトで表示されるFAQ項目タイトルのデフォルト最大値';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        'FAQへの取り込みを行うチケットの優先順位の既定値';
    $Self->{Translation}->{'Default state for FAQ entry.'} = '記事エントリー時の規定のステータス';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'FAQへの取り込みを行うチケットの優先順位の既定値';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = 'FAQ項目承認用デフォルトチケットタイプ';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} =
        '公開画面用パラメータのデフォルト値。パラメータ（Action=XXXXXX）は、スクリプトで使用されています。';
    $Self->{Translation}->{'Define if the FAQ title should be concatenated to article subject.'} =
        'FAQタイトルが記事の件名に連結するかどうかを定義します';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} =
        '簡易版FAQジャーナル表示用モジュールの概要を定義';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} =
        '簡易版FAQ一覧表示用モジュールの概要を定義';
    $Self->{Translation}->{'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} =
        '担当者インターフェイスにおける、FAQ検索結果並び替えに利用する属性順の既定値を定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} =
        '顧客用画面における、FAQ検索結果並び替えに利用する属性順の既定値を定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} =
        '公開画面における、FAQ検索結果並び替えに利用する属性順の既定値を定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the agent interface.'} =
        '担当者インターフェイス（FAQ一覧）における、FAQ検索結果並び替えに利用する属性順の既定値を定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the customer interface.'} =
        '顧客用画面（FAQ一覧）における、FAQ検索結果並び替えに利用する属性順の既定値を定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} =
        '公開画面（FAQ一覧）における、FAQ検索結果並び替えに利用する属性順の既定値を定義します。';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the agent interface. Up: oldest on top. Down: latest on top.'} =
        '担当者インターフェイスにおける、FAQ一覧の表示順の既定値を定義します。Up: 古い順 / Down: 新しい順';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the customer interface. Up: oldest on top. Down: latest on top.'} =
        '顧客用画面における、FAQ一覧の表示順の既定値を定義します。Up: 古い順 / Down: 新しい順';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the public interface. Up: oldest on top. Down: latest on top.'} =
        '公開画面における、FAQ一覧の表示順の既定値を定義します。Up: 古い順 / Down: 新しい順';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} =
        '担当者インターフェイス（FAQ一覧）における、FAQ検索結果並び順の既定値を定義します。Up: 古い順 / Down: 新しい順';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} =
        '顧客用画面における、FAQ検索結果並び順の既定値を定義します。Up: 古い順 / Down: 新しい順';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} =
        '公開画面における、FAQ検索結果並び順の既定値を定義します。Up: 古い順 / Down: 新しい順';
    $Self->{Translation}->{'Defines the default shown FAQ search attribute for FAQ search screen.'} =
        'FAQ 検索画面に表示されるFAQ 検索属性のデフォルト値を定義する。';
    $Self->{Translation}->{'Defines the information to be inserted in a FAQ based Ticket. "Full FAQ" includes text, attachments and inline images.'} =
        'FAQ記事からチケットへの挿入される情報を定義する。「FAQすべて」にはテキスト・添付・及びインラインの画像が含まれます。';
    $Self->{Translation}->{'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.'} =
        'ダッシュボードのバックエンドパラメータを定義。「Limit リミット」は標準で表示されるエントリーを定義します。「Group グループ」はプラグインへのアクセスを制限します。(例. Group: admin;group1;group2)。「Default　デフォルト」はプラグインが標準で有効になっているか、ユーザーが手動で有効にする必要があるかを定義します。';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} =
        '担当者画面における、FAQ一覧での表示項目の設定。この設定によって項目の並び順を制御することはできません。';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} =
        '顧客用画面における、FAQ一覧での表示項目の設定。この設定によって項目の並び順を制御することはできません。';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} =
        '公開画面における、FAQ一覧での表示項目の設定。この設定によって項目の並び順を制御することはできません。';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed.'} = 'FAQリンクがどこに表示されるか定義する';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = 'FAQのフリーテキストフィールドの定義。';
    $Self->{Translation}->{'Delete this FAQ'} = 'この記事を削除';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ add screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '担当者インターフェイスのFAQ追加画面で表示される動的領域。 選択可能な設定値: 0 = 無効, 1 = 有効, 2 = 有効 さらに 必須';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ edit screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '担当者インターフェイスのFAQ編集画面で表示される動的領域。 選択可能な設定値: 0 = 無効, 1 = 有効, 2 = 有効 さらに 必須';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '担当者インターフェイスのFAQオーバービュー画面で表示される動的領域。 選択可能な設定値: 0 = 無効, 1 = 有効, 2 = 有効 さらに 必須';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '公開インターフェイスのFAQ追加画面で表示される動的領域。 選択可能な設定値: 0 = 無効, 1 = 有効, 2 = 有効 さらに 必須';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '担当者インターフェイスのFAQ印刷画面で表示される動的領域。 選択可能な設定値: 0 = 無効, 1 = 有効';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '顧客インターフェイスのFAQ印刷画面で表示される動的領域。 選択可能な設定値: 0 = 無効, 1 = 有効';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '公開インターフェイスのFAQ印刷画面で表示される動的領域。 選択可能な設定値: 0 = 無効, 1 = 有効';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.'} =
        '担当者インターフェイスのFAQ検索画面で表示される動的領域。 選択可能な設定値: 0 = 無効, 1 = 有効, 2 = 有効 さらに デフォルトで表示する';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.'} =
        '顧客インターフェイスのFAQ検索画面で表示される動的領域。 選択可能な設定値: 0 = 無効, 1 = 有効, 2 = 有効 さらに デフォルトで表示する';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.'} =
        '公開インターフェイスのFAQ検索画面で表示される動的領域。 選択可能な設定値: 0 = 無効, 1 = 有効, 2 = 有効 さらに デフォルトで表示する';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '担当者インターフェイスのFAQ オーバービュー「Sフォーマット」で表示される動的領域。 選択可能な設定値: 0 = 無効, 1 = 有効';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '担当者インターフェイスのFAQ ズームスクリーンで表示される動的領域。 選択可能な設定値: 0 = 無効, 1 = 有効';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '顧客インターフェイスのFAQズーム画面に表示される動的領域。 選択可能な設定値: 0 = 無効, 1 = 有効';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '公開インターフェイスのFAQズーム画面に表示される動的領域。 選択可能な設定値: 0 = 無効, 1 = 有効';
    $Self->{Translation}->{'Edit this FAQ'} = 'この記事を編集';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = '多言語を有効にする';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = '評価の機能を有効にする';
    $Self->{Translation}->{'FAQ AJAX Responder'} = '';
    $Self->{Translation}->{'FAQ AJAX Responder for Richtext.'} = '';
    $Self->{Translation}->{'FAQ Area'} = '';
    $Self->{Translation}->{'FAQ Area.'} = '';
    $Self->{Translation}->{'FAQ Delete.'} = '';
    $Self->{Translation}->{'FAQ Edit.'} = '';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = 'FAQジャーナル一覧(S)の表示数';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = 'FAQ一覧(S)の表示数';
    $Self->{Translation}->{'FAQ Print.'} = '';
    $Self->{Translation}->{'FAQ limit per page for FAQ Journal Overview "Small"'} = 'FAQジャーナル一覧(S)の1ページ毎の表示数';
    $Self->{Translation}->{'FAQ limit per page for FAQ Overview "Small"'} = 'FAQ一覧(S)の1ページ毎の表示数';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = '担当者インターフェイスにおける、FAQ検索のバックエンドルータ';
    $Self->{Translation}->{'Field4'} = 'Field4';
    $Self->{Translation}->{'Field5'} = 'Field5';
    $Self->{Translation}->{'Frontend module registration for the public interface.'} = '公開画面のフロントエンドモジュールの定義';
    $Self->{Translation}->{'Full FAQ'} = '';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = 'FAQの記事の承認のためのグループ';
    $Self->{Translation}->{'History of this FAQ'} = 'この記事の履歴';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = 'FAQ由来のチケットに含まれる内部項目';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = 'FAQ由来のチケットに含まれる内部項目すべての名称';
    $Self->{Translation}->{'Interfaces where the quick search should be shown.'} = 'クイック検索が表示される画面';
    $Self->{Translation}->{'Journal'} = 'ジャーナル';
    $Self->{Translation}->{'Language Management'} = '言語管理';
    $Self->{Translation}->{'Link another object to this FAQ item'} = 'このFAQ記事に他オブジェクトを関連付ける';
    $Self->{Translation}->{'List of state types which can be used in the agent interface.'} =
        '担当者インターフェイスで利用可能なステートタイプリスト';
    $Self->{Translation}->{'List of state types which can be used in the customer interface.'} =
        '顧客画面で利用可能なステートタイプリスト';
    $Self->{Translation}->{'List of state types which can be used in the public interface.'} =
        '公開画面で利用可能なステートタイプリスト';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the agent interface.'} =
        '担当者インターフェイスのFAQ一覧で表示する記事の最大数';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the customer interface.'} =
        '顧客用画面のFAQ一覧で表示する記事の最大数';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the public interface.'} =
        '公開画面のFAQ一覧で表示する記事の最大数';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} =
        '担当者インターフェイスのFAQジャーナルで表示する記事の最大数';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} =
        '検索結果として担当者インターフェイスで表示されるFAQ項目の最大数';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} =
        '検索結果として顧客画面で表示されるFAQ項目の最大数';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} =
        '検索結果として公開画面で表示されるFAQ項目の最大数';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the agent interface.'} =
        '担当者インターフェイスのFAQ Explorerで表示される件名のFAQ記事の最大サイズ';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the customer interface.'} =
        '顧客インターフェイスのFAQ Explorer に表示される「FAQ項目の件名」の最大値。';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the public interface.'} =
        '公開インターフェイスのFAQ Explorer に表示される「FAQ項目の件名」の最大値。';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the agent interface.'} =
        '担当者インターフェイスのFAQ 検索で表示される件名のFAQ記事の最大サイズ';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the customer interface.'} =
        '顧客インターフェイスのFAQ 検索 に表示される「FAQ項目の件名」の最大値。';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the public interface.'} =
        '公開インターフェイスのFAQ 検索 に表示される「FAQ項目の件名」の最大値。';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ journal in the agent interface.'} =
        '担当者インターフェイスのFAQ ジャーナルで表示される件名のFAQ記事の最大サイズ';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the public interface.'} =
        '公開インタフェースにおいて、ショート・チケット検索のためのhtml OpenSearchプロフィールを生成するモジュールです';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short faq search in the customer interface.'} =
        '顧客インタフェースにおいて、ショート・チケット検索のためのhtml OpenSearchプロフィールを生成するモジュールです';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search.'} =
        'ショート検索のhtml OpenSearchプロフィールを生成するモジュール';
    $Self->{Translation}->{'New FAQ Article'} = '新規 FAQ 項目';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = '新規 FAQ 項目を公開するには事前に承認されることが必要です';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the customer interface.'} =
        '顧客用インターフェイスで表示される FAQ 項目の数';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the public interface.'} =
        '公開用インターフェイスで表示される FAQ 項目の数';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the customer interface.'} =
        '顧客用インターフェイス 検索結果表示の各画面で表示される FAQ 項目の数';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the public interface.'} =
        '公開インターフェイス の検索結果表示の各画面で表示される FAQ 項目の数';
    $Self->{Translation}->{'Number of shown items in last changes.'} = '「最近の変更」に何件まで表示するか';
    $Self->{Translation}->{'Number of shown items in last created.'} = '「最新の新規作成」に何件まで表示するか';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = '「トップ10記事」に何件まで表示するか';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} =
        '簡易版FAQジャーナル一覧のページ指定用のパラメータ';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} =
        '簡易版FAQ概要のページ指定用のパラメータ';
    $Self->{Translation}->{'Print this FAQ'} = 'この記事を印刷';
    $Self->{Translation}->{'Public FAQ Print.'} = '';
    $Self->{Translation}->{'Public FAQ Zoom.'} = '';
    $Self->{Translation}->{'Public FAQ search.'} = '';
    $Self->{Translation}->{'Public FAQ.'} = '';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = '記事承認キュー';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = '評価率。キーは、パーセントで指定する必要があります。';
    $Self->{Translation}->{'S'} = '';
    $Self->{Translation}->{'Search FAQ'} = 'FAQを検索';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        'AgentFAQZoomで表示されるインラインHTMLのデフォルト高さ(ピクセル表記)を設定';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        'CustomerFAQZoom (及び PublicFAQZoom)で表示されるインラインHTMLのデフォルト高さ(ピクセル表記)を設定';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        'AgentFAQZoomで表示されるインラインHTMLの最大の高さ(ピクセル表記)を設定';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        'CustomerFAQZoom (及び PublicFAQZoom)で表示されるインラインHTMLの最大の高さ(ピクセル表記)を設定';
    $Self->{Translation}->{'Show "Insert FAQ Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        '\'AgentFAQZoomSmall\'の設定。公開画面において「リンクを挿入する」ボタンを表示する/表示しない';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" / "Insert Full FAQ & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        '公開されたFAQ記事のAgentFAQZoomSmallに"FAQのテキスト、およびリンクを挿入" / "FAQのすべて、およびリンクを挿入" ボタンを表示する';
    $Self->{Translation}->{'Show "Insert FAQ Text" / "Insert Full FAQ" Button in AgentFAQZoomSmall.'} =
        'AgentFAQZoomSmallに"FAQのテキストを挿入" / "FAQのすべてを挿入"ボタンを表示する';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = '記事でHTMLタグを表示する/表示しない';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = '記事のパスを表示する/表示しない';
    $Self->{Translation}->{'Show items of subcategories.'} = 'サブカテゴリーのトピックを表示する/表示しない';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = '最新の変更を表示する画面（担当者用/顧客用/公開）を定義';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = '最新の新規作成を表示する画面（担当者用/顧客用/公開）を定義';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = 'トップ10を表示する画面（担当者用/顧客用/公開）を定義';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = '評価を表示する画面（担当者用/顧客用/公開）を定義';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'} =
        '担当者インタフェースなどのズーム・ビューで、FAQを他のオブジェクトとリンクさせるリンクをメニューに表示します。';
    $Self->{Translation}->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'} =
        '担当者インターフェイスのズームビューでFAQ削除のリンクを表示する。';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface.'} =
        '担当者インターフェイスのズームビューでFAQの履歴のリンクを表示する。';
    $Self->{Translation}->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'} =
        '担当者インターフェイスのズームビューでFAQ編集のリンクを表示する。';
    $Self->{Translation}->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'} =
        '担当者インターフェイスのズームビューで「戻る」のリンクを表示する。';
    $Self->{Translation}->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'} =
        '担当者インターフェイスのズームビューでFAQを印刷リンクを表示する。';
    $Self->{Translation}->{'Text Only'} = '';
    $Self->{Translation}->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'} =
        'FAQ用の識別子 例. FAQ#, KB#, MyFAQ#. デフォルトでは FAQ# となっています';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'} =
        '‘Normal’リンク・タイプを使用して、‘FAQ’オブジェクトが他の‘FAQ’オブジェクトとリンクされるように、定義します。';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '‘ParentChild’リンク・タイプを使用して、‘FAQ’オブジェクトが他の‘FAQ’オブジェクトとリンクされるように、定義します。';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'} =
        '‘Normal’リンク・タイプを使用して、‘FAQ’オブジェクトが他の‘Ticket’オブジェクトとリンクされるように、定義します。';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'} =
        '‘ParentChild’リンク・タイプを使用して、‘FAQ’オブジェクトが他の‘Ticket’オブジェクトとリンクされるように、定義します。';
    $Self->{Translation}->{'Ticket body for approval of FAQ article.'} = 'FAQ承認チケット用　チケット本文';
    $Self->{Translation}->{'Ticket subject for approval of FAQ article.'} = 'FAQ承認チケット用　チケット件名 ';
    $Self->{Translation}->{'Toolbar Item for a shortcut.'} = 'ショートカットのためのツールバー・アイテムです。';
    $Self->{Translation}->{'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.'} =
        '';
    $Self->{Translation}->{'Your service selection of your preferred services. You also get notified about those services via email if enabled.'} =
        '';
    $Self->{Translation}->{'public (public)'} = '';

}

1;
