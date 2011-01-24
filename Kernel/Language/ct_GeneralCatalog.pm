# --
# Kernel/Language/ct_GeneralCatalog.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ct_GeneralCatalog.pm,v 1.6 2011-01-24 17:32:49 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ct_GeneralCatalog;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Funcionalitat';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Gestió del catàleg general';
    $Self->{Translation}->{'Add Catalog Item'} = 'Afegir article de catàleg';
    $Self->{Translation}->{'Add Catalog Class'} = 'Afegir classe de catàleg';
    $Self->{Translation}->{'Catalog Class'} = 'Classe de catáleg';
    $Self->{Translation}->{'A Catalog Class should have a description!'} = '';
    $Self->{Translation}->{'Catalog Class is required.'} = '';
    $Self->{Translation}->{'A Catalog Class should have a Name!'} = '';
    $Self->{Translation}->{'Name is required.'} = '';

    # SysConfig
    $Self->{Translation}->{'Create and manage the General Catalog.'} = '';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = '';
    $Self->{Translation}->{'General Catalog'} = 'Catàleg general';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} = '';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} = '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
