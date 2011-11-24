# --
# Kernel/Language/es_GeneralCatalog.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: es_GeneralCatalog.pm,v 1.11 2011-11-24 15:22:10 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_GeneralCatalog;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Funcionalidad';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Gestión del Catálogo General';
    $Self->{Translation}->{'Add Catalog Item'} = 'Añadir Elemento al Catálogo';
    $Self->{Translation}->{'Add Catalog Class'} = 'Añadir Clase al Catálogo';
    $Self->{Translation}->{'Catalog Class'} = 'Clase de Catálogo';

    # SysConfig
    $Self->{Translation}->{'Create and manage the General Catalog.'} = '';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = '';
    $Self->{Translation}->{'General Catalog'} = 'Catálogo General';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} = 'Parámetros para el ejemplo comentario 2 de los atributos del catálogo general.';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} = 'Parámetros para los permisos de ejemplo de los atributos del catálogo general.';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
