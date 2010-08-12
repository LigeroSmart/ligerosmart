# --
# Kernel/Language/fr_GeneralCatalog.pm - the french translation of GeneralCatalog
# Copyright (C) 2001-2009 Olivier Sallou <olivier.sallou at irisa.fr>
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: fr_GeneralCatalog.pm,v 1.4 2010-08-12 22:50:38 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'Catalogue Général';
    $Lang->{'General Catalog Management'} = 'Gestion du Catalogue Général';
    $Lang->{'Catalog Class'}              = 'Classe de Catalogue';
    $Lang->{'Add a new Catalog Class.'}   = 'Ajouter une nouvelle classes de Catalogue.';
    $Lang->{'Add Catalog Item'}           = 'Ajouter un Element au Catalogue';
    $Lang->{'Add Catalog Class'}          = 'Ajouter une Classe de Catalogue';
    $Lang->{'Functionality'}              = 'Fonctionnalité';
    $Lang->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = '';
    $Lang->{'Parameters for the example comment 2 of general catalog attributes.'} = '';
    $Lang->{'Parameters for the example permission groups of general catalog attributes.'} = '';

    return 1;
}

1;
