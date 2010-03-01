# --
# Kernel/Language/pt_BR_GeneralCatalog.pm - the pt_BR translation of GeneralCatalog
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2010 Cristiano Korndörfer, http://www.dorfer.com.br/
# --
# $Id: pt_BR_GeneralCatalog.pm,v 1.1 2010-03-01 09:41:42 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = 'Catálogo Geral';
    $Lang->{'General Catalog Management'} = 'Gerenciamento do Catálogo Geral';
    $Lang->{'Catalog Class'}              = 'Classe do Catálogo';
    $Lang->{'Add a new Catalog Class.'}   = 'Adiciona uma nova classe ao catálogo.';
    $Lang->{'Add Catalog Item'}           = 'Adicionar Item ao Catálogo';
    $Lang->{'Add Catalog Class'}          = 'Adicionar Classe ao Catálogo';
    $Lang->{'Functionality'}              = 'Funcionalidade';

    return 1;
}

1;
