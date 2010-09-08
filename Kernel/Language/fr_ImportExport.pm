# --
# Kernel/Language/fr_ImportExport.pm - the french translation of ImportExport
# Copyright (C) 2001-2009 Olivier Sallou <olivier.sallou at irisa.fr>
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: fr_ImportExport.pm,v 1.4 2010-09-08 18:02:53 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'}              = 'Importer/Exporter';
    $Lang->{'Import/Export Management'}   = 'Gestion de l\'Import/Export';
    $Lang->{'Add mapping template'}       = 'Ajouter un template de mappage';
    $Lang->{'Start Import'}               = 'Démarrer Import';
    $Lang->{'Start Export'}               = 'Démarrer Export';
    $Lang->{'Step'}                       = 'Etape';
    $Lang->{'Edit common information'}    = 'Editer les informations communes';
    $Lang->{'Edit object information'}    = 'Editer les informations de l\'objet';
    $Lang->{'Edit format information'}    = 'Editer les informations de format';
    $Lang->{'Edit mapping information'}   = 'Editer les informations de mappage';
    $Lang->{'Edit search information'}    = 'Editer les informations de recherche';
    $Lang->{'Import information'}         = 'Informations d\'import';
    $Lang->{'Column'}                     = 'Colonne';
    $Lang->{'Restrict export per search'} = 'Restreindre l\'export par recherche';
    $Lang->{'Source File'}                = 'Fichier Source';
    $Lang->{'Column Separator'}           = 'Séparateur de colonne';
    $Lang->{'Tabulator (TAB)'}            = 'Tabulation (TAB)';
    $Lang->{'Semicolon (;)'}              = 'Point virgule (;)';
    $Lang->{'Colon (:)'}                  = 'Deux points (:)';
    $Lang->{'Dot (.)'}                    = 'Point (.)';
    $Lang->{'Charset'}                    = 'Jeu de caractères';
    $Lang->{'Frontend module registration for the agent interface.'} = '';
    $Lang->{'Format backend module registration for the import/export module.'} = '';
    $Lang->{'Import and export object information.'} = '';

    return 1;
}

1;
