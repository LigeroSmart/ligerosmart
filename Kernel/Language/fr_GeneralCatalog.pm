# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::fr_GeneralCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Fonctionnalité';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Gestion du catalogue général';
    $Self->{Translation}->{'Items in Class'} = 'Éléments dans la classe';
    $Self->{Translation}->{'Edit Item'} = 'Éditer un élément';
    $Self->{Translation}->{'Add Class'} = 'Ajouter une classe';
    $Self->{Translation}->{'Add Item'} = 'Ajouter un élément';
    $Self->{Translation}->{'Add Catalog Item'} = 'Ajouter un élément au catalogue';
    $Self->{Translation}->{'Add Catalog Class'} = 'Ajouter une classe au catalogue';
    $Self->{Translation}->{'Catalog Class'} = 'Classe de catalogue';
    $Self->{Translation}->{'Edit Catalog Item'} = 'Éditer un élément du catalogue';

    # JS File: ITSM.GeneralCatalog
    $Self->{Translation}->{'Warning incident state can not be set to invalid.'} = '';

    # SysConfig
    $Self->{Translation}->{'Comment 2'} = 'Commentaire 2';
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Créer et gérer le catalogue général.';
    $Self->{Translation}->{'Define the general catalog comment 2.'} = 'Définir le commentaire 2 du catalogue général.';
    $Self->{Translation}->{'Defines the URL JS Color Picker path.'} = 'Définit l\'URL du chemin "JS Color Picker".';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        'Interface d\'enregistrement de module pour la configuration du catalogue général dans la zone administrateur';
    $Self->{Translation}->{'General Catalog'} = 'Catalogue général';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        'Paramètres pour l\'exemple du commentaire 2 des attributs du catalogue général';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        'Paramètres pour l\'exemple des permissions de groupes des attributs du catalogue général.';
    $Self->{Translation}->{'Permission Group'} = '';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Warning',
    'Warning incident state can not be set to invalid.',
    );

}

1;
