# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::fr_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Gestion de l\'importation/exportation';
    $Self->{Translation}->{'Add template'} = 'Ajouter un modèle';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Créer un modèle pour importer et exporter les informations d\'objet';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        '';
    $Self->{Translation}->{'Start Import'} = 'Démarrer l\'import';
    $Self->{Translation}->{'Start Export'} = 'Démarrer l\'export';
    $Self->{Translation}->{'Delete this template'} = '';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = 'Étape 1 sur 5 - Éditer les information communes';
    $Self->{Translation}->{'Name is required!'} = 'Un nom est requis !';
    $Self->{Translation}->{'Object is required!'} = 'Un objet est requis !';
    $Self->{Translation}->{'Format is required!'} = 'Un format est requis !';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = 'Étape 2 sur 5 - Éditer les informations de l\'objet';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = 'Étape 3 sur 5 - Éditer les informations du format';
    $Self->{Translation}->{'is required!'} = 'est requis !';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = 'Étape 4 sur 5 - Éditer les informations de mappage';
    $Self->{Translation}->{'No map elements found.'} = 'Aucun élément de mappage trouvé.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Ajouter un élément de mappage';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = 'Étape 5 sur 5 - Éditer les informations de recherche';
    $Self->{Translation}->{'Restrict export per search'} = 'Restreindre l\'exportation par recherche';
    $Self->{Translation}->{'Import information'} = 'Informations d\'importation';
    $Self->{Translation}->{'Source File'} = 'Fichier source';
    $Self->{Translation}->{'Import summary for %s'} = 'Importer le résumé pour %s';
    $Self->{Translation}->{'Records'} = 'Enregistrements';
    $Self->{Translation}->{'Success'} = 'Réussi';
    $Self->{Translation}->{'Duplicate names'} = 'Noms en double';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Numéro de la dernière ligne traitée dans le fichier d\'importation';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Do you really want to delete this template item?'} = '';

    # Perl Module: Kernel/Modules/AdminImportExport.pm
    $Self->{Translation}->{'No object backend found!'} = 'Aucun objet "backend" n\'a été trouvé !';
    $Self->{Translation}->{'No format backend found!'} = 'Aucun format "backend" n\'a été trouvé !';
    $Self->{Translation}->{'Template not found!'} = 'Modèle non trouvé !';
    $Self->{Translation}->{'Can\'t insert/update template!'} = 'Impossible d\'insérer ou mettre à jour le modèle !';
    $Self->{Translation}->{'Needed TemplateID!'} = 'L\'ID du modèle est requis !';
    $Self->{Translation}->{'Error occurred. Import impossible! See Syslog for details.'} = 'Une erreur est survenue, importation impossible ! Pour plus de détails, consultez le journal d’événements système.';
    $Self->{Translation}->{'Error occurred. Export impossible! See Syslog for details.'} = 'Une erreur est survenue, exportation impossible ! Pour plus de détails, consultez le journal d’événements système.';
    $Self->{Translation}->{'Template List'} = 'Liste des modèles';
    $Self->{Translation}->{'number'} = 'nombre';
    $Self->{Translation}->{'number bigger than zero'} = 'nombre plus grand que zéro';
    $Self->{Translation}->{'integer'} = 'entier';
    $Self->{Translation}->{'integer bigger than zero'} = 'entier plus grand que zéro';
    $Self->{Translation}->{'Element required, please insert data'} = 'Élément requis, veuillez entrer des données';
    $Self->{Translation}->{'Invalid data, please insert a valid %s'} = 'Données invalides. Veuillez insérer une %s valide';
    $Self->{Translation}->{'Format not found!'} = 'Format non trouvé !';

    # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
    $Self->{Translation}->{'Column Separator'} = 'Séparateur de colonne';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulation (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Point virgule (;)';
    $Self->{Translation}->{'Colon (:)'} = 'Deux points (:)';
    $Self->{Translation}->{'Dot (.)'} = 'Point (.)';
    $Self->{Translation}->{'Comma (,)'} = 'Virgule (,)';
    $Self->{Translation}->{'Charset'} = 'Jeu de caractères';
    $Self->{Translation}->{'Include Column Headers'} = 'Inclure les en-têtes de colonnes';
    $Self->{Translation}->{'Column'} = 'Colonne';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = '';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        '';
    $Self->{Translation}->{'Template was deleted successfully.'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Enregistrement du module "Format backend" pour le module d\'importation/exportation';
    $Self->{Translation}->{'Import and export object information.'} = 'Importer et exporter des informations d\'objet';
    $Self->{Translation}->{'Import/Export'} = 'Importer/Exporter';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Confirm',
    'Delete this template',
    'Deleting template...',
    'Template was deleted successfully.',
    'There was an error deleting the template. Please check the logs for more information.',
    );

}

1;
