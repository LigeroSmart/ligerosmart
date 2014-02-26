# --
# Kernel/Language/pt_BR_FAQ.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_FAQ;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAFAQ
    $Self->{Translation}->{'internal'} = 'interno';
    $Self->{Translation}->{'public'} = 'público';
    $Self->{Translation}->{'external'} = 'externo';
    $Self->{Translation}->{'Symptom'} = 'Sintoma';
    $Self->{Translation}->{'Problem'} = 'Problema';
    $Self->{Translation}->{'Solution'} = 'Solução';
    $Self->{Translation}->{'FAQ Number'} = 'Número do FAQ';
    $Self->{Translation}->{'Latest updated FAQ articles'} = 'Artigos modificados recentemente';
    $Self->{Translation}->{'Latest created FAQ articles'} = 'Últimos artigos adicionados';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Os 10 artigos mais acessados';
    $Self->{Translation}->{'Subcategory of'} = 'Subcategoria de';
    $Self->{Translation}->{'No rate selected!'} = 'Selecione a pontuação!';
    $Self->{Translation}->{'Explorer'} = 'Explorador';
    $Self->{Translation}->{'public (all)'} = 'público (todos)';
    $Self->{Translation}->{'external (customer)'} = 'externo (cliente)';
    $Self->{Translation}->{'internal (agent)'} = 'interno (atendente)';
    $Self->{Translation}->{'Start day'} = 'Dia de início';
    $Self->{Translation}->{'Start month'} = 'Mês de início';
    $Self->{Translation}->{'Start year'} = 'Ano de início';
    $Self->{Translation}->{'End day'} = 'Dia de término';
    $Self->{Translation}->{'End month'} = 'Mês de término';
    $Self->{Translation}->{'End year'} = 'Ano de término';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Obrigado por seu Voto';
    $Self->{Translation}->{'You have already voted!'} = 'Você já votou!';
    $Self->{Translation}->{'FAQ Article Print'} = 'Imprimir Artigo FAQ';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'Artigos FAQ (Top 10)';
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'Artigos FAQ (criado novo)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'Artigos FAQ (alterados recentemente)';
    $Self->{Translation}->{'FAQ category updated!'} = 'Categoria FAQ atualizada!';
    $Self->{Translation}->{'FAQ category added!'} = 'Categoria FAQ adicionada!';
    $Self->{Translation}->{'A category should have a name!'} = 'Uma categoria precisa ter um nome!';
    $Self->{Translation}->{'This category already exists'} = 'Esta categoria já existe!';
    $Self->{Translation}->{'FAQ language added!'} = 'Idioma FAQ adicionado!';
    $Self->{Translation}->{'FAQ language updated!'} = 'Idioma FAQ atualizado!';
    $Self->{Translation}->{'The name is required!'} = 'O nome é obrigatório!';
    $Self->{Translation}->{'This language already exists!'} = 'Esse idioma já existe!';

    # Template: AgentDashboardFAQOverview

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'Adicionar Artigo de FAQ';
    $Self->{Translation}->{'Keywords'} = 'Palavras-chave';
    $Self->{Translation}->{'A category is required.'} = 'A categoria é necessária.';
    $Self->{Translation}->{'Approval'} = 'Aprovação';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'Gerenciamento de Categoria de FAQ';
    $Self->{Translation}->{'Add category'} = 'Adicionar categoria';
    $Self->{Translation}->{'Delete Category'} = 'Excluir Categoria';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Add Category'} = 'Adicionar Categoria';
    $Self->{Translation}->{'Edit Category'} = 'Alterar Categoria';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Será exibido como comentário no Explorador';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Por favor, selecione pelo menos um grupo de permissão.';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Grupos de atendentes que podem acessar artigos nesta categoria.';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'Você realmente quer apagar esta categoria?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        '';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'Esta categoria é utilizada no(s) seguinte(s) artigo(s) FAQ';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'Esta categoria é pai das seguintes subcategorias';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'Você realmente quer excluir este artigo FAQ?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'Explorador FAQ';
    $Self->{Translation}->{'Quick Search'} = 'Busca Rápida';
    $Self->{Translation}->{'Wildcards are allowed.'} = 'Coringas são permitidos.';
    $Self->{Translation}->{'Advanced Search'} = 'Pesquisa Avançada';
    $Self->{Translation}->{'Subcategories'} = 'Subcategorias';
    $Self->{Translation}->{'FAQ Articles'} = 'Artigos FAQ';
    $Self->{Translation}->{'No subcategories found.'} = 'Subcategorias não encontradas.';

    # Template: AgentFAQHistory

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'Não foram encontrados dados de Jornal FAQ.';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'Gerenciamento de Idiomas FAQ';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languges.'} =
        'Use esse recurso se você deseja trabalhar com múltiplos idiomas.';
    $Self->{Translation}->{'Add language'} = 'Adicionar idioma';
    $Self->{Translation}->{'Delete Language'} = 'Excluir idioma';
    $Self->{Translation}->{'Add Language'} = 'Adicionar idioma';
    $Self->{Translation}->{'Edit Language'} = 'Editar idioma';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'Você realmente quer excluir este idioma?';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        'Você não pode excluir este idioma. Ele é usado em pelo menos um artigo FAQ!';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'Este idioma é usado nos seguintes artigo(s) FAQ';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Configurações de Contexto';
    $Self->{Translation}->{'FAQ articles per page'} = 'Artigos FAQ por página';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'Não foram encontrados dados de FAQ.';
    $Self->{Translation}->{'A generic FAQ table'} = 'Uma tabela de FAQ genérica';
    $Self->{Translation}->{'","50'} = '';

    # Template: AgentFAQPrint
    $Self->{Translation}->{'FAQ-Info'} = 'FAQ Informação';
    $Self->{Translation}->{'Votes'} = 'Votos';
    $Self->{Translation}->{'Last update'} = 'Última atualização';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = 'Palavra-chave';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = 'Voto (ex. Igual a 10 ou maior que 60)';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = 'Pontuação (ex. Igual a 25% ou maior que 75%)';
    $Self->{Translation}->{'Approved'} = 'Aprovado';
    $Self->{Translation}->{'Last Changed by'} = 'Última alteração por';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = 'Horário de criação de artigo de FAQ (antes/depois)';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = 'Horário de criação de artigo de FAQ (entre)';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = 'Horário de alteração de artigo de FAQ (antes/depois)';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = 'Horário de alteração de artigo de FAQ (entre)';
    $Self->{Translation}->{'FAQ Item Create Time (before/after)'} = 'Horário de criação do FAQ (antes/depois)';
    $Self->{Translation}->{'FAQ Item Create Time (between)'} = 'Horário de criação do FAQ (entre)';
    $Self->{Translation}->{'FAQ Item Change Time (before/after)'} = 'Horário de alteração do FAQ (antes/depois)';
    $Self->{Translation}->{'FAQ Item Change Time (between)'} = 'Horário de alteração do FAQ (entre)';
    $Self->{Translation}->{'Run Search'} = 'Executar Pesquisa';

    # Template: AgentFAQSearchOpenSearchDescriptionFAQNumber

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'FAQ-TextoCompleto';

    # Template: AgentFAQSearchResultPrint

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'Busca FAQ';
    $Self->{Translation}->{'Profile Selection'} = 'Seleção de perfil';
    $Self->{Translation}->{'Vote'} = 'Voto';
    $Self->{Translation}->{'No vote settings'} = 'Sem configurações de voto';
    $Self->{Translation}->{'Specific votes'} = 'Votos específicos';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = 'ex. Igual a 10 ou maior que 60';
    $Self->{Translation}->{'Rate'} = 'Pontuação';
    $Self->{Translation}->{'No rate settings'} = 'Sem configurações de pontuação';
    $Self->{Translation}->{'Specific rate'} = 'Pontuação específica';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = 'ex. Igual a 25% ou maior que 75%';
    $Self->{Translation}->{'FAQ Article Create Time'} = 'Horário de criação de artigo de FAQ';
    $Self->{Translation}->{'Specific date'} = 'Data específica';
    $Self->{Translation}->{'Date range'} = 'Período de data';
    $Self->{Translation}->{'FAQ Article Change Time'} = 'Horário de alteração de artigo de FAQ';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'Informação do FAQ';
    $Self->{Translation}->{'","18'} = '","18';
    $Self->{Translation}->{'","25'} = '","25';
    $Self->{Translation}->{'Rating'} = 'Nota';
    $Self->{Translation}->{'Rating %'} = 'Nota %';
    $Self->{Translation}->{'out of 5'} = 'de 5';
    $Self->{Translation}->{'No votes found!'} = 'Nenhum voto encontrado!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Nenhum voto encontrado! Seja o primeiro a avaliar este artigo FAQ.';
    $Self->{Translation}->{'Download Attachment'} = 'Baixar anexos';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        'Este artigo te ajudou?';
    $Self->{Translation}->{'not helpful'} = 'pouco útil';
    $Self->{Translation}->{'very helpful'} = 'muito útil';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Insert FAQ Text'} = 'Inserir texto do FAQ';
    $Self->{Translation}->{'Insert Full FAQ'} = 'Inserir todo o FAQ';
    $Self->{Translation}->{'Insert FAQ Link'} = 'Inserir link do FAQ';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'Inserir texto do FAQ e link';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = 'Inserir todo o FAQ e link';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'Nenhum artigo FAQ encontrado.';

    # Template: CustomerFAQPrint

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Pesquisa completa de textos em artigos FAQ (por exemplo, "Jo*o" or "Will*")';
    $Self->{Translation}->{'Vote restrictions'} = 'Restrições de voto';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = 'Apenas artigos de FAQ com votos...';
    $Self->{Translation}->{'Rate restrictions'} = 'Restrições de pontuação';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = 'Apenas artigos de FAQ com pontuação...';
    $Self->{Translation}->{'Only FAQ articles created'} = 'Apenas artigos de FAQ criados';
    $Self->{Translation}->{'Only FAQ articles created between'} = 'Apenas artigos de FAQ criados entre';
    $Self->{Translation}->{'Search-Profile as Template?'} = 'Perfil de pesquisa como modelo?';

    # Template: CustomerFAQSearchOpenSearchDescriptionFAQNumber

    # Template: CustomerFAQSearchOpenSearchDescriptionFullText

    # Template: CustomerFAQSearchResultPrint

    # Template: CustomerFAQSearchResultShort

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = 'Número do Artigo';
    $Self->{Translation}->{'Search for articles with keyword'} = 'Procure por artigos com palavras-chave';

    # Template: PublicFAQExplorer

    # Template: PublicFAQPrint

    # Template: PublicFAQSearch

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = 'Público';

    # Template: PublicFAQSearchOpenSearchDescriptionFullText

    # Template: PublicFAQSearchResultPrint

    # Template: PublicFAQSearchResultShort

    # Template: PublicFAQZoom

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} =
        'Um filtro de saída HTML para adicionar links para trás uma seqüência definida. O elemento de imagem permite dois tipos de entrada. Primeiro, o nome de uma imagem (faq.png, por exemplo). Neste caso, o caminho da imagem OTRS será usado. A segunda possibilidade é inserir o link para a imagem.';
    $Self->{Translation}->{'CSS color for the voting result.'} = 'CSS cor para o resultado da votação.';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = '';
    $Self->{Translation}->{'Category Management'} = 'Gerenciamento de Categoria';
    $Self->{Translation}->{'Decimal places of the voting result.'} = 'Casas decimais do resultado da votação.';
    $Self->{Translation}->{'Default category name.'} = 'Nome padrão da categoria.';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = 'Idioma padrão para os artigos FAQ no modo de idioma único.';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        'Prioridade padrão de chamados para a aprovação dos artigos FAQ.';
    $Self->{Translation}->{'Default state for FAQ entry.'} = 'Estado padrão de entrada FAQ.';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'Estado padrão de chamados para a aprovação dos artigos FAQ.';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} =
        'Valor padrão para o parâmetro de Recurso para a interface pública. O parâmetro de ação é usado nos scripts do sistema.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} =
        'Define um módulo de resumo para mostrar a visualização pequena de um jornal FAQ.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} =
        'Define um módulo de resumo para mostrar a visualizar de uma pequena lista de FAQ.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} =
        'Define o atributo padrão FAQ para classificar o FAQ em uma pesquisa FAQ da interface do atendente.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} =
        'Define o atributo padrão FAQ para classificar o FAQ em uma pesquisa FAQ da interface do cliente.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} =
        'Define o atributo padrão FAQ para classificar o FAQ em uma pesquisa FAQ da interface pública.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the agent interface.'} =
        'Define o atributo padrão FAQ para classificar o FAQ no Gerenciador FAQ da interface do atendente';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the customer interface.'} =
        'Define o atributo padrão FAQ para classificar o FAQ no Gerenciador FAQ da interface do cliente';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} =
        'Define o atributo padrão FAQ para classificar o FAQ no Gerenciador FAQ da interface pública';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the agent interface. Up: oldest on top. Down: latest on top.'} =
        'Define a ordem padrão de FAQ no resultado do Gerenciador FAQ da interface do atendente. Acima: A mais antiga no topo. Abaixo: mais recentes no topo.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the customer interface. Up: oldest on top. Down: latest on top.'} =
        'Define a ordem padrão de FAQ no resultado do Gerenciador FAQ da interface do cliente. Acima: A mais antiga no topo. Abaixo: mais recentes no topo.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the public interface. Up: oldest on top. Down: latest on top.'} =
        'Define a ordem padrão de FAQ no resultado do Gerenciador FAQ da interface pública. Acima: A mais antiga no topo. Abaixo: mais recentes no topo.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} =
        'Define a ordem padrão de FAQ no resultado da pesquisa na interface do atendente. Acima: A mais antiga no topo. Abaixo: mais recentes no topo.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} =
        'Define a ordem padrão de FAQ no resultado da pesquisa na interface do cliente. Acima: A mais antiga no topo. Abaixo: mais recentes no topo.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} =
        'Define a ordem padrão de FAQ no resultado da pesquisa na interface pública. Acima: A mais antiga no topo. Abaixo: mais recentes no topo.';
    $Self->{Translation}->{'Defines the information to be inserted in a FAQ based Ticket. "Full FAQ" includes text, attachments and inline images.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} =
        'Define as colunas mostradas no Gerenciador FAQ. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} =
        'Define as colunas mostradas no jornal FAQ. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} =
        'Define as colunas mostradas na pesquisa FAQ. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed. Note: AgentTicketActionCommon includes AgentTicketNote, AgentTicketClose, AgentTicketFreeText, AgentTicketOwner, AgentTicketPending, AgentTicketPriority and AgentTicketResponsible.'} =
        'Define onde o link \'Inserir FAQ\' será exibido. Nota: Os Recurso comum do Atendente inclui Abrir Chamado, Fechar Chamado, Chamado de Texto Livre, Chamado do proprietário, Chamado pendente, Chamado prioritário e Responsável pelo Chamado.';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = 'Definição de campos de texto livre.';
    $Self->{Translation}->{'Delete this FAQ'} = 'Excluir este FAQ!';
    $Self->{Translation}->{'Edit this FAQ'} = 'Editar este FAQ';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = 'Permitir vários idiomas no módulo FAQ.';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = 'Permitir mecanismo de Avaliação no módulo FAQ.';
    $Self->{Translation}->{'FAQ Journal'} = 'Jornal FAQ';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = 'Limite da Visão Geral "Pequeno" do Jornal FAQ';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = 'Limite da Visão Geral FAQ "Pequeno"';
    $Self->{Translation}->{'FAQ limit per page for FAQ Journal Overview "Small"'} = 'Limite de FAQs por página da Visão Geral "Pequeno" do Jornal FAQ';
    $Self->{Translation}->{'FAQ limit per page for FAQ Overview "Small"'} = 'Limite de FAQs por página da Visão Geral "Pequeno" de FAQ';
    $Self->{Translation}->{'FAQ path separator.'} = 'Delimitador de caminho FAQ.';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = 'FAQ busca servidor roteador da interface do atendente.';
    $Self->{Translation}->{'FAQ-Area'} = 'Área FAQ';
    $Self->{Translation}->{'Frontend module registration for the public interface.'} = 'Frontend de registo do módulo para a interface pública.';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = 'Grupo para a aprovação dos artigos FAQ.';
    $Self->{Translation}->{'History of this FAQ'} = 'Histórico deste FAQ';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = 'Incluir campos internos de um Chamado base FAQ.';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = 'Incluir o nome de cada campo em um Chamado base FAQ.';
    $Self->{Translation}->{'Interfaces where the quicksearch should be shown.'} = 'Interfaces onde a busca rápida deve ser demonstrada.';
    $Self->{Translation}->{'Journal'} = 'Jornal';
    $Self->{Translation}->{'Language Management'} = 'Gestão de idiomas';
    $Self->{Translation}->{'Link another object to this FAQ item'} = 'Link de outro artigo para este item FAQ';
    $Self->{Translation}->{'List of state types which can be used in the agent interface.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the customer interface.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the agent interface.'} =
        'O número máximo de artigos FAQ para ser exibido no resultado do Gerenciador FAQ da interface do atendente.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the customer interface.'} =
        'O número máximo de artigos FAQ para ser exibido no resultado do Gerenciador FAQ da interface do cliente.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the public interface.'} =
        'O número máximo de artigos FAQ para ser exibido no resultado do Gerenciador FAQ da interface pública.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} =
        'O número máximo de artigos FAQ para ser exibido no jornal FAQ da interface do atendente.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} =
        'O número máximo de artigos FAQ para ser exibido no resultado de uma pesquisa na interface do atendente.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} =
        'O número máximo de artigos FAQ para ser exibido no resultado de uma pesquisa na interface do cliente.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} =
        'O número máximo de artigos FAQ para ser exibido no resultado de uma pesquisa na interface publica.';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search in the public interface.'} =
        '';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search.'} =
        'Módulo para gerar html "OpenSearch" perfil de pesquisa faq curta.';
    $Self->{Translation}->{'New FAQ Article'} = 'Novo artigo FAQ';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = 'Novos artigos FAQ precisam de aprovação antes de ser publicados.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the customer interface.'} =
        'Número de artigos FAQ para ser exibido no Gerenciador FAQ do interface do cliente';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the public interface.'} =
        'Número de artigos FAQ para ser exibido no Gerenciador FAQ do interface publica';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the customer interface.'} =
        'Número de artigos FAQ para ser exibido em cada página de um resultado de pesquisa na interface do cliente';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the public interface.'} =
        'Número de artigos FAQ para ser exibido em cada página de um resultado de pesquisa na interface publica';
    $Self->{Translation}->{'Number of shown items in last changes.'} = 'Número de itens mostrados em últimas alterações.';
    $Self->{Translation}->{'Number of shown items in last created.'} = 'Número de itens mostrados em últimas criações.';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = 'Número de itens mostrados no recurso top 10.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} =
        'Parâmetros de páginas (nas quais os itens FAQ são mostrados) da visão geral pequena do jornal FAQ.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} =
        'Parâmetros de páginas (nas quais os itens FAQ são mostrados) da visão geral pequena de FAQ.';
    $Self->{Translation}->{'Print this FAQ'} = 'Imprimir este FAQ';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = 'Fila para a aprovação dos artigos FAQ.';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = 'Condição para a avaliação. Chave deve ser em percentual.';
    $Self->{Translation}->{'Search FAQ'} = 'Pesquisa FAQ';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        '';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        '';
    $Self->{Translation}->{'Show "Insert FAQ Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        'Mostra botão "Inserir Link FAQ" em Ampliação pequena para o artigos FAQ públicos';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" / "Insert Full FAQ & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        '';
    $Self->{Translation}->{'Show "Insert FAQ Text" / "Insert Full FAQ" Button in AgentFAQZoomSmall.'} =
        '';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = 'Mostrar artigo FAQ com HTML.';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = 'Mostrar caminho FAQ sim / não.';
    $Self->{Translation}->{'Show items of subcategories.'} = 'Mostrar itens de subcategorias.';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = 'Mostrar as últimas alterações de itens em interfaces definidas.';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = 'Mostrar os últimos itens criados em interfaces definidas.';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = 'Mostrar os 10 itens superior em interfaces definidas.';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = 'Mostrar votação em interfaces definidas.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'} =
        'Mostra um link no menu que permite ligar um FAQ com outro objeto no modo de exibição ampliada na interface do atendente.';
    $Self->{Translation}->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'} =
        'Mostra um link no menu que permite excluir um FAQ no modo de exibição ampliada na interface do atendente.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface.'} =
        'Mostra um link no menu para acessar o histórico de um FAQ no modo de exibição ampliada na interface do atendente.';
    $Self->{Translation}->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'} =
        'Mostra um link no menu para editar um FAQ no modo de exibição ampliada na interface do atendente.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'} =
        'Mostra um link no menu para voltar um FAQ no modo de exibição ampliada na interface do atendente.';
    $Self->{Translation}->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'} =
        'Mostra um link no menu para imprimir um FAQ no modo de exibição ampliada na interface do atendente.';
    $Self->{Translation}->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'} =
        'O identificador para um FAQ, exemplo FAQ # KB # # MyFAQ. O padrão é FAQ #.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'} =
        'Essa configuração define que um objeto \'FAQ\' pode ser relacionado com outros objetos \'FAQ\' usando o tipo de vínculo \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Essa configuração define que um objeto \'FAQ\' pode ser relacionado com outros objetos \'FAQ\' usando o tipo de vínculo \'Pai e filho\'';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'} =
        'Essa configuração define que um objeto \'FAQ\' pode ser relacionado com outros objetos \'Chamado\' usando o tipo de vínculo \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'} =
        'Essa configuração define que um objeto \'FAQ\' pode ser relacionado com outros objetos \'Chamado\' usando o tipo de vínculo \'Pai e filho\'';
    $Self->{Translation}->{'Ticket body for approval of FAQ article.'} = 'Corpo do chamado para aprovação de um artigo FAQ.';
    $Self->{Translation}->{'Ticket subject for approval of FAQ article.'} = 'O assunto do chamado para aprovação de um artigo FAQ.';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Languagekey which is defined in the language file *_FAQ.pm.'} = 'Idioma chave que está definido no arquivo de idioma *_FAQ.pm.';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        'Mostra botão "Inserir texto e Link FAQ" em Ampliação pequena para o artigos FAQ públicos';
    $Self->{Translation}->{'Show "Insert FAQ Text" Button in AgentFAQZoomSmall.'} = 'Mostrar botão "Inserir FAQ Texto" com pequena ampliação para o atendente.';
    $Self->{Translation}->{'Show WYSIWYG editor in agent interface.'} = 'Mostrar editor WYSIWYG na interface do atendente.';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ artigo and/or is parent of at least one other category'} =
        'Você não pode excluir esta categoria. Ela é usada em pelo menos um artigo FAQ e/ou é pai de pelo menos uma outra categoria!';

}

1;
