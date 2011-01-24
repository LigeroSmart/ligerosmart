# --
# Kernel/Language/zh_CN_GeneralCatalog.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: zh_CN_GeneralCatalog.pm,v 1.5 2011-01-24 17:32:49 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_GeneralCatalog;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = '功能用途';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = '总目录管理';
    $Self->{Translation}->{'Add Catalog Item'} = '增加目录项目';
    $Self->{Translation}->{'Add Catalog Class'} = '增加新目录分级';
    $Self->{Translation}->{'Catalog Class'} = '目录分级';
    $Self->{Translation}->{'A Catalog Class should have a description!'} = '';
    $Self->{Translation}->{'Catalog Class is required.'} = '';
    $Self->{Translation}->{'A Catalog Class should have a Name!'} = '';
    $Self->{Translation}->{'Name is required.'} = '';

    # SysConfig
    $Self->{Translation}->{'Create and manage the General Catalog.'} = '';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = '';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} = '';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} = '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
