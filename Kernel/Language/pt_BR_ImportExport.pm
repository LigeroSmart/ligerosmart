# --
# Kernel/Language/pt_BR_ImportExport.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: pt_BR_ImportExport.pm,v 1.9 2011-11-24 15:42:26 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_ImportExport;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = 'Adicionar modelo de mapeamento';
    $Self->{Translation}->{'Charset'} = 'Codificação de Caracteres';
    $Self->{Translation}->{'Colon (:)'} = 'Dois Pontos (:)';
    $Self->{Translation}->{'Column'} = 'Coluna';
    $Self->{Translation}->{'Column Separator'} = 'Separador de Colunas';
    $Self->{Translation}->{'Dot (.)'} = 'Ponto (.)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Ponto e Vírgula (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulação (TAB)';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Gerenciamento de Importação/Exportação';
    $Self->{Translation}->{'Add template'} = 'Adicionar modelo';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Criar um modelo para importar e exportar informações de objeto.';
    $Self->{Translation}->{'Start Import'} = 'Iniciar Importação';
    $Self->{Translation}->{'Start Export'} = 'Iniciar Exportação';
    $Self->{Translation}->{'Delete Template'} = 'Excluir Modelo';
    $Self->{Translation}->{'Step'} = 'Passo';
    $Self->{Translation}->{'Edit common information'} = 'Editar informações comuns';
    $Self->{Translation}->{'Object is required!'} = 'Objeto é necessário!';
    $Self->{Translation}->{'Format is required!'} = 'O formato é necessário!';
    $Self->{Translation}->{'Edit object information'} = 'Editar informações do objeto';
    $Self->{Translation}->{'Edit format information'} = 'Editar informações do formato';
    $Self->{Translation}->{' is required!'} = ' é necessário!';
    $Self->{Translation}->{'Edit mapping information'} = 'Editar informações do mapeamento';
    $Self->{Translation}->{'No map elements found.'} = 'Não há elementos mapa encontrado.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Adicionar elemento de mapeamento';
    $Self->{Translation}->{'Edit search information'} = 'Editar informações de pesquisa';
    $Self->{Translation}->{'Restrict export per search'} = 'Restringir exportação por pesquisa';
    $Self->{Translation}->{'Import information'} = 'Informações de importação';
    $Self->{Translation}->{'Source File'} = 'Arquivo de Origem';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} = 'Formato de registro backend do módulo de importação / exportação módulo.';
    $Self->{Translation}->{'Import and export object information.'} = 'Importar e exportar informações de objeto.';
    $Self->{Translation}->{'Import/Export'} = 'Importação/Exportação';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
