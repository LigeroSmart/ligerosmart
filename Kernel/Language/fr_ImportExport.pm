# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = 'Ajouter un template de mappage';
    $Self->{Translation}->{'Charset'} = 'Jeu de caractères';
    $Self->{Translation}->{'Colon (:)'} = 'Deux points (:)';
    $Self->{Translation}->{'Column'} = 'Colonne';
    $Self->{Translation}->{'Column Separator'} = 'Séparateur de colonne';
    $Self->{Translation}->{'Dot (.)'} = 'Point (.)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Point virgule (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulation (TAB)';
    $Self->{Translation}->{'Include Column Headers'} = 'Inclure les en-têtes de colonnes';
    $Self->{Translation}->{'Import summary for'} = 'Résumé de l\'import pour';
    $Self->{Translation}->{'Imported records'} = 'Enregistrements importés';
    $Self->{Translation}->{'Exported records'} = 'Enregistrements exportés';
    $Self->{Translation}->{'Records'} = 'Enregistrements';
    $Self->{Translation}->{'Skipped'} = 'Passé(s)';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Gestion de l\'Import/Export';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Créer un modèle pour importer et exporter les informations d\'objet';
    $Self->{Translation}->{'Start Import'} = 'Démarrer Import';
    $Self->{Translation}->{'Start Export'} = 'Démarrer Export';
    $Self->{Translation}->{'Step'} = 'Etape';
    $Self->{Translation}->{'Edit common information'} = 'Editer les informations communes';
    $Self->{Translation}->{'Name is required!'} = 'Un Nom est requis!';
    $Self->{Translation}->{'Object is required!'} = 'Un Objet est requis!';
    $Self->{Translation}->{'Format is required!'} = 'Un Format est requis!';
    $Self->{Translation}->{'Edit object information'} = 'Editer les informations de l\'objet';
    $Self->{Translation}->{'Edit format information'} = 'Editer les informations de format';
    $Self->{Translation}->{'is required!'} = 'est requis !';
    $Self->{Translation}->{'Edit mapping information'} = 'Editer les informations de mappage';
    $Self->{Translation}->{'No map elements found.'} = '';
    $Self->{Translation}->{'Add Mapping Element'} = '';
    $Self->{Translation}->{'Edit search information'} = 'Editer les informations de recherche';
    $Self->{Translation}->{'Restrict export per search'} = 'Restreindre l\'export par recherche';
    $Self->{Translation}->{'Import information'} = 'Informations d\'import';
    $Self->{Translation}->{'Source File'} = 'Fichier Source';
    $Self->{Translation}->{'Success'} = 'Réussi';
    $Self->{Translation}->{'Failed'} = 'Echoué';
    $Self->{Translation}->{'Duplicate names'} = 'Noms en double';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Numéro de la dernière ligne traitée dans le fichier d\'import';
    $Self->{Translation}->{'Ok'} = 'Ok';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        '';
    $Self->{Translation}->{'Import and export object information.'} = 'Importer et exporter des informations d\'objet';
    $Self->{Translation}->{'Import/Export'} = 'Importer/Exporter';

}

1;
