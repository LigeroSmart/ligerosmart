# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ja_GeneralCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = '機能性';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'ジェネラル・カタログ管理';
    $Self->{Translation}->{'Items in Class'} = 'クラス内のアイテム';
    $Self->{Translation}->{'Edit Item'} = '';
    $Self->{Translation}->{'Add Class'} = 'クラスの追加';
    $Self->{Translation}->{'Add Item'} = '';
    $Self->{Translation}->{'Add Catalog Item'} = 'カタログ項目を追加';
    $Self->{Translation}->{'Add Catalog Class'} = 'カタログクラスを追加';
    $Self->{Translation}->{'Catalog Class'} = 'カタログクラス';
    $Self->{Translation}->{'Edit Catalog Item'} = 'カタログ・アイテムを修正';

    # JS File: ITSM.GeneralCatalog
    $Self->{Translation}->{'Warning incident state can not be set to invalid.'} = '';

    # SysConfig
    $Self->{Translation}->{'Comment 2'} = '';
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'ジャネラル・カタログの作成と管理';
    $Self->{Translation}->{'Define the general catalog comment 2.'} = '';
    $Self->{Translation}->{'Defines the URL JS Color Picker path.'} = 'URL JS カラーピッカーのパスを定義します。';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        '管理エリアでのAdminGeneralCatalogのフロントエンドモジュールの登録';
    $Self->{Translation}->{'General Catalog'} = 'ジェネラル・カタログ';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        'ジェネラル・カタログ属性のコメント例 2　の設定値';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        'ジェネラル・カタログ属性の権限グループ　の設定値';
    $Self->{Translation}->{'Permission Group'} = '権限グループ';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Warning',
    'Warning incident state can not be set to invalid.',
    );

}

1;
