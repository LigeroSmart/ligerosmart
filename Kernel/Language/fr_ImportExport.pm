# --
# Kernel/Language/fr_ImportExport.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr_ImportExport;

use strict;
use warnings;

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
    $Self->{Translation}->{'Include Column Headers'} = '';
    $Self->{Translation}->{'Import summary for'} = '';
    $Self->{Translation}->{'Imported records'} = '';
    $Self->{Translation}->{'Exported records'} = '';
    $Self->{Translation}->{'Records'} = '';
    $Self->{Translation}->{'Skipped'} = '';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Gestion de l\'Import/Export';
    $Self->{Translation}->{'Create a template to import and export object information.'} = '';
    $Self->{Translation}->{'Start Import'} = 'Démarrer Import';
    $Self->{Translation}->{'Start Export'} = 'Démarrer Export';
    $Self->{Translation}->{'Delete Template'} = '';
    $Self->{Translation}->{'Step'} = 'Etape';
    $Self->{Translation}->{'Edit common information'} = 'Editer les informations communes';
    $Self->{Translation}->{'Name is required!'} = '';
    $Self->{Translation}->{'Object is required!'} = '';
    $Self->{Translation}->{'Format is required!'} = '';
    $Self->{Translation}->{'Edit object information'} = 'Editer les informations de l\'objet';
    $Self->{Translation}->{'Edit format information'} = 'Editer les informations de format';
    $Self->{Translation}->{' is required!'} = '';
    $Self->{Translation}->{'Edit mapping information'} = 'Editer les informations de mappage';
    $Self->{Translation}->{'No map elements found.'} = '';
    $Self->{Translation}->{'Add Mapping Element'} = '';
    $Self->{Translation}->{'Edit search information'} = 'Editer les informations de recherche';
    $Self->{Translation}->{'Restrict export per search'} = 'Restreindre l\'export par recherche';
    $Self->{Translation}->{'Import information'} = 'Informations d\'import';
    $Self->{Translation}->{'Source File'} = 'Fichier Source';
    $Self->{Translation}->{'Success'} = '';
    $Self->{Translation}->{'Failed'} = '';
    $Self->{Translation}->{'Duplicate names'} = '';
    $Self->{Translation}->{'Last processed line number of import file'} = '';
    $Self->{Translation}->{'Ok'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        '';
    $Self->{Translation}->{'Import and export object information.'} = '';
    $Self->{Translation}->{'Import/Export'} = 'Importer/Exporter';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
