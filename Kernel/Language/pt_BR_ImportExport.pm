# --
# Kernel/Language/pt_BR_ImportExport.pm - the Brazilian translation of ImportExport
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2010 Cristiano Korndörfer, http://www.dorfer.com.br/
# --
# $Id: pt_BR_ImportExport.pm,v 1.2 2010-05-17 13:49:43 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'}              = 'Importação/Exportação';
    $Lang->{'Import/Export Management'}   = 'Gerenciamento de Importação/Exportação';
    $Lang->{'Add mapping template'}       = 'Adicionar Modelo de Mapeamento';
    $Lang->{'Start Import'}               = 'Iniciar Importação';
    $Lang->{'Start Export'}               = 'Iniciar Exportação';
    $Lang->{'Step'}                       = 'Passo';
    $Lang->{'Edit common information'}    = 'Editar informações comuns';
    $Lang->{'Edit object information'}    = 'Editar informações do objeto';
    $Lang->{'Edit format information'}    = 'Editar informações do formato';
    $Lang->{'Edit mapping information'}   = 'Editar informações do mapeamento';
    $Lang->{'Edit search information'}    = 'Editar informações de pesquisa';
    $Lang->{'Import information'}         = 'Informações de importação';
    $Lang->{'Column'}                     = 'Coluna';
    $Lang->{'Restrict export per search'} = 'Restringir exportação por pesquisa';
    $Lang->{'Source File'}                = 'Arquivo de Origem';
    $Lang->{'Column Separator'}           = 'Separador de Colunas';
    $Lang->{'Tabulator (TAB)'}            = 'Tabulação (TAB)';
    $Lang->{'Semicolon (;)'}              = 'Ponto e Vírgula (;)';
    $Lang->{'Colon (:)'}                  = 'Dois Pontos (:)';
    $Lang->{'Dot (.)'}                    = 'Ponto (.)';
    $Lang->{'Charset'}                    = 'Codificação de Caracteres';

    return 1;
}

1;
