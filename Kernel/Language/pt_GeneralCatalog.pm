# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pt_GeneralCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Funcionalidade';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Gestão do Catálogo Geral';
    $Self->{Translation}->{'Items in Class'} = 'Items na Classe';
    $Self->{Translation}->{'Edit Item'} = 'Editar Item';
    $Self->{Translation}->{'Add Class'} = 'Adicionar Classe';
    $Self->{Translation}->{'Add Item'} = 'Adicionar Item';
    $Self->{Translation}->{'Add Catalog Item'} = 'Adicionar Item ao Catálogo';
    $Self->{Translation}->{'Add Catalog Class'} = 'Adicionar Classe ao Catálogo';
    $Self->{Translation}->{'Catalog Class'} = 'Classe do Catálogo';
    $Self->{Translation}->{'Edit Catalog Item'} = 'Editar Item do Catálogo';

    # JS File: ITSM.GeneralCatalog
    $Self->{Translation}->{'Warning incident state can not be set to invalid.'} = '';

    # SysConfig
    $Self->{Translation}->{'Comment 2'} = 'Comentário 2';
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Criar e gerir o Catálogo Geral.';
    $Self->{Translation}->{'Define the general catalog comment 2.'} = 'Definir o Catálogo Geral comentário 2.';
    $Self->{Translation}->{'Defines the URL JS Color Picker path.'} = 'Definir o URL para o caminho do JS Color Picker';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        'Módulo de registo da interface para a configuração AdminGeneralCatalog na área administrativa.';
    $Self->{Translation}->{'General Catalog'} = 'Catálogo Geral';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        'Parâmetros para o comentário de exemplo 2 dos atributos do catálogo geral.';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        'Parâmetros para os grupos de permissão de exemplo dos atributos do catálogo geral.';
    $Self->{Translation}->{'Permission Group'} = '';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Warning',
    'Warning incident state can not be set to invalid.',
    );

}

1;
