# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ja_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'インポート/エクスポートの管理';
    $Self->{Translation}->{'Add template'} = 'テンプレートを追加';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'オブジェクトのインポート・エクスポート用のテンプレートを作成する';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        'このモジュールを利用するには、 ITSMConfigurationManagement か、オブジェクトのインポートおよびエクスポートの機能を提供するパッケージをインストールする必要があります。';
    $Self->{Translation}->{'Start Import'} = 'インポート開始';
    $Self->{Translation}->{'Start Export'} = 'エクスポート開始';
    $Self->{Translation}->{'Delete this template'} = '';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = 'Step 1 of 5 - 基本情報の設定';
    $Self->{Translation}->{'Name is required!'} = '名称は必須です!';
    $Self->{Translation}->{'Object is required!'} = 'オブジェクトは必須です!';
    $Self->{Translation}->{'Format is required!'} = 'フォーマットは必須です!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = 'Step 2 of 5 - オブジェクト情報の設定';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = 'Step 3 of 5 - フォーマット情報の設定';
    $Self->{Translation}->{'is required!'} = '必須です';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = 'Step 4 of 5 - マッピング情報の設定';
    $Self->{Translation}->{'No map elements found.'} = 'マッピング要素が見つかりませんでした';
    $Self->{Translation}->{'Add Mapping Element'} = 'マッピング要素の追加';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = 'Step 5 of 5 - 検索情報の設定';
    $Self->{Translation}->{'Restrict export per search'} = '検索あたりの出力を制限';
    $Self->{Translation}->{'Import information'} = '情報をインポート';
    $Self->{Translation}->{'Source File'} = 'ソースファイル';
    $Self->{Translation}->{'Import summary for %s'} = '%sのインポート・サマリー';
    $Self->{Translation}->{'Records'} = 'レコード';
    $Self->{Translation}->{'Success'} = '成功';
    $Self->{Translation}->{'Duplicate names'} = '名前が重複しています';
    $Self->{Translation}->{'Last processed line number of import file'} = '読み込み済みファイルの最終実行行数';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Do you really want to delete this template item?'} = '本当にこのテンプレートを削除してよろしいですか？';

    # Perl Module: Kernel/Modules/AdminImportExport.pm
    $Self->{Translation}->{'No object backend found!'} = '指定されたオブジェクトのバックエンドが見つかりません！';
    $Self->{Translation}->{'No format backend found!'} = '指定されたフォーマットのバックエンドが見つかりません！';
    $Self->{Translation}->{'Template not found!'} = 'テンプレートが見つかりません！';
    $Self->{Translation}->{'Can\'t insert/update template!'} = 'テンプレートの挿入・更新ができません！';
    $Self->{Translation}->{'Needed TemplateID!'} = 'テンプレートIDの入力が必要です！';
    $Self->{Translation}->{'Error occurred. Import impossible! See Syslog for details.'} = 'インポートが出来ません（エラーが発生しました。詳細はシステムログをご確認ください）！';
    $Self->{Translation}->{'Error occurred. Export impossible! See Syslog for details.'} = 'エクスポートが出来ません（エラーが発生しました。詳細はシステムログをご確認ください）！';
    $Self->{Translation}->{'Template List'} = 'テンプレート・リスト';
    $Self->{Translation}->{'number'} = '数値';
    $Self->{Translation}->{'number bigger than zero'} = '0以上の数値';
    $Self->{Translation}->{'integer'} = '整数値';
    $Self->{Translation}->{'integer bigger than zero'} = '0以上の整数値';
    $Self->{Translation}->{'Element required, please insert data'} = 'データを入力する必要があります。';
    $Self->{Translation}->{'Invalid data, please insert a valid %s'} = '無効なデータです。有効な %s を入力してください。';
    $Self->{Translation}->{'Format not found!'} = '指定されたフォーマットが見つかりません！';

    # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
    $Self->{Translation}->{'Column Separator'} = '桁のセパレータ';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'タブ (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = 'セミコロン (;)';
    $Self->{Translation}->{'Colon (:)'} = 'コロン (:)';
    $Self->{Translation}->{'Dot (.)'} = 'ドット(.)';
    $Self->{Translation}->{'Comma (,)'} = 'カンマ (,)';
    $Self->{Translation}->{'Charset'} = 'キャラクタセット';
    $Self->{Translation}->{'Include Column Headers'} = 'ヘッダ情報を含む';
    $Self->{Translation}->{'Column'} = '桁';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = 'テンプレートを削除中…';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        'テンプレートの削除中にエラーが発生しました。詳細はログを確認してください。';
    $Self->{Translation}->{'Template was deleted successfully.'} = 'テンプレートが正常に削除されました。';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'import/exportモジュールのバックエンドモジュールを登録';
    $Self->{Translation}->{'Import and export object information.'} = 'オブジェクト情報のインポート・エクスポート';
    $Self->{Translation}->{'Import/Export'} = 'インポート/エクスポート';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Confirm',
    'Delete this template',
    'Deleting template...',
    'Template was deleted successfully.',
    'There was an error deleting the template. Please check the logs for more information.',
    );

}

1;
