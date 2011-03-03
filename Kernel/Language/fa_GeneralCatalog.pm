# --
# Kernel/Language/fa_GeneralCatalog.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: fa_GeneralCatalog.pm,v 1.5 2011-03-03 18:39:46 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fa_GeneralCatalog;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'کارکردی';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'مدیریت فهرست عمومی';
    $Self->{Translation}->{'Add Catalog Item'} = 'اضافه کردن یک قلم فهرست';
    $Self->{Translation}->{'Add Catalog Class'} = 'اضافه کردن کلاس فهرستی';
    $Self->{Translation}->{'Catalog Class'} = 'فهرست کلاسی';

    # SysConfig
    $Self->{Translation}->{'Create and manage the General Catalog.'} = '';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = '';
    $Self->{Translation}->{'General Catalog'} = 'فهرست عمومی';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} = '';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} = '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
