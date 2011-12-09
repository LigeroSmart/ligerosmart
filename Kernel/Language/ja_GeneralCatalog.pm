# --
# Kernel/Language/ja_GeneralCatalog.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# Copyright (C) 2011/12/08 Kaoru Hayama TIS Inc.
# --
# $Id: ja_GeneralCatalog.pm,v 1.1 2011-12-09 16:11:08 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ja_GeneralCatalog;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} ||= '';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = '一般カタログ管理';
    $Self->{Translation}->{'Add Catalog Item'} = 'カタログ項目を追加';
    $Self->{Translation}->{'Add Catalog Class'} = 'カタログクラスを追加';
    $Self->{Translation}->{'Catalog Class'} ||= '';

    # SysConfig
    $Self->{Translation}->{'Create and manage the General Catalog.'} ||= '';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} ||= '';
    $Self->{Translation}->{'General Catalog'} ||= '';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} ||= '';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} ||= '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
