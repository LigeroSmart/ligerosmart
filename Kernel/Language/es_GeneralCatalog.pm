# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::es_GeneralCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Funcionalidad';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Gestión del Catálogo General';
    $Self->{Translation}->{'Items in Class'} = 'Items en Clase';
    $Self->{Translation}->{'Edit Item'} = 'Editar elemento';
    $Self->{Translation}->{'Add Class'} = 'Añadir Clase';
    $Self->{Translation}->{'Add Item'} = 'Añadir elemento';
    $Self->{Translation}->{'Add Catalog Item'} = 'Añadir Elemento al Catálogo';
    $Self->{Translation}->{'Add Catalog Class'} = 'Añadir Clase al Catálogo';
    $Self->{Translation}->{'Catalog Class'} = 'Clase de Catálogo';
    $Self->{Translation}->{'Edit Catalog Item'} = 'Editar Elemento del Catálogo';

    # JS File: ITSM.GeneralCatalog
    $Self->{Translation}->{'Warning incident state can not be set to invalid.'} = '';

    # SysConfig
    $Self->{Translation}->{'Comment 2'} = 'Comentario 2';
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Crea y gestiona el Catálogo General';
    $Self->{Translation}->{'Define the general catalog comment 2.'} = 'Definir el comentario 2 del catálogo general.';
    $Self->{Translation}->{'Defines the URL JS Color Picker path.'} = 'Define la ruta URL JS del selector de color';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        'El Frontend del registro del módulo para la configuración del AdminGeneralCatalog en el área admin';
    $Self->{Translation}->{'General Catalog'} = 'Catálogo General';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        'Parámetros para el ejemplo comentario 2 de los atributos del catálogo general.';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        'Parámetros para los permisos de ejemplo de los atributos del catálogo general.';
    $Self->{Translation}->{'Permission Group'} = '';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Warning',
    'Warning incident state can not be set to invalid.',
    );

}

1;
