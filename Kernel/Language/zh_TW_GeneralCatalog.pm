# --
# Kernel/Language/zh_TW_GeneralCatalog.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# Copyright (C) 2013 Michael Shi <micshi at 163.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_TW_GeneralCatalog;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = '功能';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = '目錄管理';
    $Self->{Translation}->{'Add Catalog Item'} = '添加目錄項目';
    $Self->{Translation}->{'Add Catalog Class'} = '添加新目錄類別';
    $Self->{Translation}->{'Catalog Class'} = '目錄類別';

    # SysConfig
    $Self->{Translation}->{'Create and manage the General Catalog.'} = '創建和管理目錄';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        '';
    $Self->{Translation}->{'General Catalog'} = '目錄';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        '';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
