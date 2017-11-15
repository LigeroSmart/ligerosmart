# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::vi_VN_GeneralCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Chức năng';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Quản lý danh mục chung';
    $Self->{Translation}->{'Add Catalog Item'} = 'Thêm danh mục';
    $Self->{Translation}->{'Add Catalog Class'} = 'Thêm lớp danh mục';
    $Self->{Translation}->{'Catalog Class'} = 'Lớp danh mục';
    $Self->{Translation}->{'Edit Catalog Item'} = '';

    # SysConfig
    $Self->{Translation}->{'Comment 2'} = '';
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Tạo và quản lý danh mục chung';
    $Self->{Translation}->{'Define the general catalog comment 2.'} = '';
    $Self->{Translation}->{'Define the group with permissions.'} = '';
    $Self->{Translation}->{'Defines the URL JS Color Picker path.'} = '';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        'Đăng ký mô-đun để cấu hình AdminGeneralCatalog trong giao diện quản trị';
    $Self->{Translation}->{'General Catalog'} = 'Danh mục chung';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        'Tham số cho chú thích thứ 2 của thuộc tính danh mục chung.';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        'Tham số cho nhóm cấp phép của thuộc tính danh mục chung.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
