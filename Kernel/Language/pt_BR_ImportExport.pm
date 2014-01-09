# --
# Kernel/Language/pt_BR_ImportExport.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_ImportExport;

use strict;
use warnings;

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
    $Self->{Translation}->{'Include Column Headers'} = 'Incluir Cabeçalhos de Colunas';
    $Self->{Translation}->{'Import summary for'} = 'Resumo de importação para';
    $Self->{Translation}->{'Imported records'} = 'Registros importados';
    $Self->{Translation}->{'Exported records'} = 'Registros exportados';
    $Self->{Translation}->{'Records'} = 'Registros';
    $Self->{Translation}->{'Skipped'} = 'Desconsiderados';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Gerenciamento de Importação/Exportação';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Criar um modelo para importar e exportar informações de objeto.';
    $Self->{Translation}->{'Start Import'} = 'Iniciar Importação';
    $Self->{Translation}->{'Start Export'} = 'Iniciar Exportação';
    $Self->{Translation}->{'Delete Template'} = 'Excluir Modelo';
    $Self->{Translation}->{'Step'} = 'Passo';
    $Self->{Translation}->{'Edit common information'} = 'Editar informações comuns';
    $Self->{Translation}->{'Name is required!'} = 'Nome é obrigatório!';
    $Self->{Translation}->{'Object is required!'} = 'Objeto é obrigatório!';
    $Self->{Translation}->{'Format is required!'} = 'O formato é obrigatório!';
    $Self->{Translation}->{'Edit object information'} = 'Editar informações do objeto';
    $Self->{Translation}->{'Edit format information'} = 'Editar informações do formato';
    $Self->{Translation}->{' is required!'} = ' é obrigatório!';
    $Self->{Translation}->{'Edit mapping information'} = 'Editar informações do mapeamento';
    $Self->{Translation}->{'No map elements found.'} = 'Não há elementos mapa encontrado.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Adicionar elemento de mapeamento';
    $Self->{Translation}->{'Edit search information'} = 'Editar informações de pesquisa';
    $Self->{Translation}->{'Restrict export per search'} = 'Restringir exportação por pesquisa';
    $Self->{Translation}->{'Import information'} = 'Informações de importação';
    $Self->{Translation}->{'Source File'} = 'Arquivo de Origem';
    $Self->{Translation}->{'Success'} = 'Sucesso';
    $Self->{Translation}->{'Failed'} = 'Falhou';
    $Self->{Translation}->{'Duplicate names'} = 'Nomes duplicados';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Último número de linha processada do arquivo de imporatação';
    $Self->{Translation}->{'Ok'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Formato de registro backend do módulo de importação / exportação módulo.';
    $Self->{Translation}->{'Import and export object information.'} = 'Importar e exportar informações de objeto.';
    $Self->{Translation}->{'Import/Export'} = 'Importação/Exportação';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
