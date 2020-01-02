# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pt_FAQ;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'Adicionar artigo de FAQ';
    $Self->{Translation}->{'Keywords'} = 'Palavras-chave';
    $Self->{Translation}->{'A category is required.'} = 'É necessária uma categoria.';
    $Self->{Translation}->{'Approval'} = 'Aprovação';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'Gestão de Categorias de FAQ';
    $Self->{Translation}->{'Add FAQ Category'} = 'Adicionar Categoria de Perguntas e Respostas';
    $Self->{Translation}->{'Edit FAQ Category'} = 'Editrar categoria de Perguntas e Respostas';
    $Self->{Translation}->{'Add category'} = 'Adicionar categoria.';
    $Self->{Translation}->{'Add Category'} = 'Adicionar Categoria';
    $Self->{Translation}->{'Edit Category'} = 'Editar Categoria';
    $Self->{Translation}->{'Subcategory of'} = 'Subcategoria de';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Selecione pelo menos um grupo de permissões.';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Grupos de agentes com acesso a artigos nesta categoria';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Comentário a apresentar no browser';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'Confirma a remoção desta categoria?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        'Não pode remover esta categoria. Tem pelo menos um artigo e/ou uma subcategoria';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'Esta categoria é utilizada no(s) seguinte(s) artigo(s)';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'Esta categoria tem as seguintes subcategorias';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'Confirma a remoção deste artigo?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'Explorador da FAQ';
    $Self->{Translation}->{'Quick Search'} = 'Pesquisa rápida';
    $Self->{Translation}->{'Wildcards are allowed.'} = 'Asteriscos(*) são permitidos';
    $Self->{Translation}->{'Advanced Search'} = 'Pesquisa avançada';
    $Self->{Translation}->{'Subcategories'} = 'Subcategorias';
    $Self->{Translation}->{'FAQ Articles'} = 'Artigos';
    $Self->{Translation}->{'No subcategories found.'} = 'Nenhuma subcategoria';

    # Template: AgentFAQHistory
    $Self->{Translation}->{'History of'} = 'Histórico de';
    $Self->{Translation}->{'History Content'} = 'Histórico do conteúdo';
    $Self->{Translation}->{'Createtime'} = 'Hora de criação';

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'Sem dados de diário.';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'Gestão de idiomas de FAQ';
    $Self->{Translation}->{'Add FAQ Language'} = 'Adicionar Perguntas e Respostas em Lingua Estrangeira ';
    $Self->{Translation}->{'Edit FAQ Language'} = 'Editar Linguagem de Perguntas e Respostas';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languages.'} =
        'Use esta funcionalidade se deseja trabalhar com múltiplos idiomas.';
    $Self->{Translation}->{'Add language'} = 'Adicionar idioma';
    $Self->{Translation}->{'Add Language'} = 'Adicionar idioma';
    $Self->{Translation}->{'Edit Language'} = 'Editar idioma';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'Confirma a remoção deste idioma?';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        'Não pode remover este idioma. É utilizado em pelo menos um artigo da FAQ.';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'Este idioma é utilizado no(s) seguinte(s) artigo(s)';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Configurações de Contexto';
    $Self->{Translation}->{'FAQ articles per page'} = 'Artigos por página';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'Nenhumas Perguntas e Respostas Encontradas';

    # Template: AgentFAQRelatedArticles
    $Self->{Translation}->{'out of 5'} = 'de 5';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = 'Palavra-chave';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = 'Votar';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = 'Classificar';
    $Self->{Translation}->{'Approved'} = 'Aprovado';
    $Self->{Translation}->{'Last changed by'} = 'Última alteração por';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = 'Data de criação do artigo (antes/depois)';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = 'Data de criação do artigo (entre)';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = 'Data de modificação do artigo (antes/depois)';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = 'Data de modificação do artigo (entre)';

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'Texto integral';

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'Pesquisa';
    $Self->{Translation}->{'Profile Selection'} = 'Seleção de perfil';
    $Self->{Translation}->{'Vote'} = 'Votar';
    $Self->{Translation}->{'No vote settings'} = 'Sem definição de voto';
    $Self->{Translation}->{'Specific votes'} = 'Votos específicos';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = 'ex: Igual a 10 ou Superior a 60';
    $Self->{Translation}->{'Rate'} = 'Classificar';
    $Self->{Translation}->{'No rate settings'} = 'Sem configurações de pontuação';
    $Self->{Translation}->{'Specific rate'} = 'Classificação específica';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = 'ex. Igual a 25% ou maior que 75%';
    $Self->{Translation}->{'FAQ Article Create Time'} = 'Data de criação';
    $Self->{Translation}->{'FAQ Article Change Time'} = 'Data de modificação';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'Informação do artigo';
    $Self->{Translation}->{'Rating'} = 'Classificação';
    $Self->{Translation}->{'Votes'} = 'Votos';
    $Self->{Translation}->{'No votes found!'} = 'Sem votos.';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Sem votos. Seja o primeiro a classificar este artigo.';
    $Self->{Translation}->{'Download Attachment'} = 'Descarregar Anexo';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Para abrir as ligações abaixo poderá necessitar de premir a tecla CTRL (ou CMD) ou Shift (dependendo do browser e do sistema operativo) quando clicar sobre a ligação';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        'Este artigo foi útil? Utilize a classificação para nos ajudar a melhorar a FAQ.';
    $Self->{Translation}->{'not helpful'} = 'não ajudou';
    $Self->{Translation}->{'very helpful'} = 'ajudou muito';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Add FAQ title to article subject'} = 'Adicionar o título da FAQ ao assunto do artigo';
    $Self->{Translation}->{'Insert FAQ Text'} = 'Inserir o texto da FAQ';
    $Self->{Translation}->{'Insert Full FAQ'} = 'Inserir a FAQ completa';
    $Self->{Translation}->{'Insert FAQ Link'} = 'Inserir ligação para a FAQ';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'Inserir texto e a ligação para a FAQ';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = 'Inserir o texto completo e a ligação para a FAQ';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'Nenhum artigo FAQ encontrado.';

    # Template: CustomerFAQRelatedArticles
    $Self->{Translation}->{'This might be helpful'} = 'Isto pode Ajudar';
    $Self->{Translation}->{'Found no helpful resources for the subject and text.'} = 'Não foram encontrados resultados úteis para o assunto ou texto.';
    $Self->{Translation}->{'Type a subject or text to get a list of helpful resources.'} = 'Insira um assunto ou texto para listar artigos relevantes.';

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Pesquisa no texto integral dos artigos da FAQ';
    $Self->{Translation}->{'Vote restrictions'} = 'Restrições de votos';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = 'Apenas artigos com votos...';
    $Self->{Translation}->{'Rate restrictions'} = 'Restrições de classificação';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = 'Apenas artigos com classificação...';
    $Self->{Translation}->{'Time restrictions'} = 'Restrição horária';
    $Self->{Translation}->{'Only FAQ articles created'} = 'Apenas artigos criados';
    $Self->{Translation}->{'Only FAQ articles created between'} = 'Apenas artigos criados entre';
    $Self->{Translation}->{'Search-Profile as Template?'} = 'Guardar modelo de pesquisa?';

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = 'Número do artigo';
    $Self->{Translation}->{'Search for articles with keyword'} = 'Procurar artigos com a palavra-chave';

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = 'Publico';

    # Template: PublicFAQSearchResultShort
    $Self->{Translation}->{'Back to FAQ Explorer'} = 'Voltar ao explorador da FAQ';

    # Perl Module: Kernel/Modules/AgentFAQAdd.pm
    $Self->{Translation}->{'You need rw permission!'} = 'Necessita de permissão de escrita.';
    $Self->{Translation}->{'No categories found where user has read/write permissions!'} = 'Não foram encontradas categorias onde o utilizador possua permissões de leitura e escrita!';
    $Self->{Translation}->{'No default language found and can\'t create a new one.'} = 'Não foi encontrado um idioma padrão e tão pouco criar um novo.';

    # Perl Module: Kernel/Modules/AgentFAQCategory.pm
    $Self->{Translation}->{'Need CategoryID!'} = 'Necessário CategoryID!';
    $Self->{Translation}->{'A category should have a name!'} = 'A categoria deve ter um nome!';
    $Self->{Translation}->{'This category already exists'} = 'Esta categoria já existe';
    $Self->{Translation}->{'This category already exists!'} = 'Esta categoria já existe.';
    $Self->{Translation}->{'No CategoryID is given!'} = 'CategoryID em falta!';
    $Self->{Translation}->{'Was not able to delete the category %s!'} = 'Não foi possível apagar a categoria %s!';
    $Self->{Translation}->{'FAQ category updated!'} = 'Categoria de FAQ atualizada!';
    $Self->{Translation}->{'FAQ category added!'} = 'Categoria de FAQ adicionada!';
    $Self->{Translation}->{'Delete Category'} = 'Eliminar Categoria';

    # Perl Module: Kernel/Modules/AgentFAQDelete.pm
    $Self->{Translation}->{'No ItemID is given!'} = 'ItemID em falta!';
    $Self->{Translation}->{'You have no permission for this category!'} = 'Não dispõe de permissões para esta categoria.';
    $Self->{Translation}->{'Was not able to delete the FAQ article %s!'} = 'Não foi possível apagar o artigo %s!';

    # Perl Module: Kernel/Modules/AgentFAQExplorer.pm
    $Self->{Translation}->{'The CategoryID %s is invalid.'} = 'A CategoriaID %s é inválida.';

    # Perl Module: Kernel/Modules/AgentFAQHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ItemID is given!'} = 'Não é possível mostrar o histórico, falta o ItemID!';
    $Self->{Translation}->{'FAQ History'} = 'Histórico da FAQ';

    # Perl Module: Kernel/Modules/AgentFAQJournal.pm
    $Self->{Translation}->{'FAQ Journal'} = 'Diário da FAQ';
    $Self->{Translation}->{'Need config option FAQ::Frontend::Overview'} = 'É necessária a opção de configuração FAQ::Frontend::Overview';
    $Self->{Translation}->{'Config option FAQ::Frontend::Overview needs to be a HASH ref!'} =
        'A opção de configuração FAQ::Frontend::Overview precisa ser um valor HASH';
    $Self->{Translation}->{'No config option found for the view "%s"!'} = 'Não foram encontradas opções de configuração para a visualização "%s"!';

    # Perl Module: Kernel/Modules/AgentFAQLanguage.pm
    $Self->{Translation}->{'No LanguageID is given!'} = 'IdiomaID em falta!';
    $Self->{Translation}->{'The name is required!'} = 'É necessário o nome!';
    $Self->{Translation}->{'This language already exists!'} = 'Esta Linguagem já existe!';
    $Self->{Translation}->{'Was not able to delete the language %s!'} = 'Não foi possível apagar o idioma %s!';
    $Self->{Translation}->{'FAQ language updated!'} = 'Linguagem de FAQ atualizada!';
    $Self->{Translation}->{'FAQ language added!'} = 'Linguagem de FAQ adicionada!';
    $Self->{Translation}->{'Delete Language %s'} = 'Remover idioma %s';

    # Perl Module: Kernel/Modules/AgentFAQPrint.pm
    $Self->{Translation}->{'Result'} = 'Resultado';
    $Self->{Translation}->{'Last update'} = 'Última atualização';
    $Self->{Translation}->{'FAQ Dynamic Fields'} = 'Campos dinâmicos FAQ';

    # Perl Module: Kernel/Modules/AgentFAQRichText.pm
    $Self->{Translation}->{'No %s is given!'} = '%s em falta!';
    $Self->{Translation}->{'Can\'t load LanguageObject!'} = 'Não foi possível carregar LanguageObject!';

    # Perl Module: Kernel/Modules/AgentFAQSearch.pm
    $Self->{Translation}->{'No Result!'} = 'Sem resultado!';
    $Self->{Translation}->{'FAQ Number'} = 'Número FAQ';
    $Self->{Translation}->{'Last Changed by'} = 'Última modificação por';
    $Self->{Translation}->{'FAQ Item Create Time (before/after)'} = 'Data de criação do artigo (antes/depois)';
    $Self->{Translation}->{'FAQ Item Create Time (between)'} = 'Data de criação do artigo (entre)';
    $Self->{Translation}->{'FAQ Item Change Time (before/after)'} = 'Data de alteração do artigo (entre)';
    $Self->{Translation}->{'FAQ Item Change Time (between)'} = 'Data de alteração do artigo (entre)';
    $Self->{Translation}->{'Equals'} = 'Igual a';
    $Self->{Translation}->{'Greater than'} = 'Superior a';
    $Self->{Translation}->{'Greater than equals'} = 'Maior ou igual a';
    $Self->{Translation}->{'Smaller than'} = 'Inferior a';
    $Self->{Translation}->{'Smaller than equals'} = 'Menor ou igual a';

    # Perl Module: Kernel/Modules/AgentFAQZoom.pm
    $Self->{Translation}->{'Need FileID!'} = 'Necessita do ArquivoID!';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Obrigado pelo seu voto!';
    $Self->{Translation}->{'You have already voted!'} = 'Já votou!';
    $Self->{Translation}->{'No rate selected!'} = 'Pontuação não seleccionada!';
    $Self->{Translation}->{'The voting mechanism is not enabled!'} = 'A funcionalidade de votação não está activa!';
    $Self->{Translation}->{'The vote rate is not defined!'} = 'O peso dos votos não foi definido!';

    # Perl Module: Kernel/Modules/CustomerFAQPrint.pm
    $Self->{Translation}->{'FAQ Article Print'} = 'Imprimir artigo de FAQ';

    # Perl Module: Kernel/Modules/CustomerFAQSearch.pm
    $Self->{Translation}->{'Created between'} = 'Criado entre';

    # Perl Module: Kernel/Modules/CustomerFAQZoom.pm
    $Self->{Translation}->{'Need ItemID!'} = 'É necessário o ItemID.';

    # Perl Module: Kernel/Modules/PublicFAQExplorer.pm
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'Artigos de FAQ (criados recentemente)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'Artigos de FAQ (alterados recentemente)';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'Artigos de FAQ (Top 10)';

    # Perl Module: Kernel/Modules/PublicFAQRSS.pm
    $Self->{Translation}->{'No Type is given!'} = 'Tipo em falta!';
    $Self->{Translation}->{'Type must be either LastCreate or LastChange or Top10!'} = 'O Tipo deve ser ÚltimoCriado, ÚltimoAlterado ou Top10!';
    $Self->{Translation}->{'Can\'t create RSS file!'} = 'Não foi possível criar o ficheiro RSS!';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/AgentFAQSearch.pm
    $Self->{Translation}->{'%s (FAQFulltext)'} = '%s (FAQ-TextoCompleto)';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/CustomerFAQSearch.pm
    $Self->{Translation}->{'%s - Customer (%s)'} = '%s - Cliente (%s)';
    $Self->{Translation}->{'%s - Customer (FAQFulltext)'} = '%s - Cliente (FAQ-TextoCompleto)';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/PublicFAQSearch.pm
    $Self->{Translation}->{'%s - Public (%s)'} = '%s - Público (%s)';
    $Self->{Translation}->{'%s - Public (FAQFulltext)'} = '%s - Público (FAQ-TextoCompleto)';

    # Perl Module: Kernel/Output/HTML/Layout/FAQ.pm
    $Self->{Translation}->{'Need rate!'} = 'Necessita de classificação!';
    $Self->{Translation}->{'This article is empty!'} = 'Este artigo está vazio!';
    $Self->{Translation}->{'Latest created FAQ articles'} = 'Últimos artigos FAQ criados';
    $Self->{Translation}->{'Latest updated FAQ articles'} = 'Últimos artigos FAQ atualizados';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Top 10 artigos FAQ';

    # Perl Module: Kernel/Output/HTML/LinkObject/FAQ.pm
    $Self->{Translation}->{'Content Type'} = 'Tipo de conteúdo';

    # Database XML Definition: FAQ.sopm
    $Self->{Translation}->{'internal'} = 'interno';
    $Self->{Translation}->{'external'} = 'externo';
    $Self->{Translation}->{'public'} = 'público';

    # JS File: FAQ.Agent.ConfirmationDialog
    $Self->{Translation}->{'Ok'} = 'Ok';

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} =
        'Um filtro de HTML de output para adicionar links antes de um determinado texto. O elemento Imagem permite dois tipos de input. Primeiro, o nome de uma imagem (ex. faq.png). Neste caso, o caminho para imagens OTRS será usado. A segunda possibilidade é inserir o link para a imagem.';
    $Self->{Translation}->{'Add FAQ article'} = 'Adicionar artigo à FAQ';
    $Self->{Translation}->{'CSS color for the voting result.'} = 'Cor CSS para o resultado da votação.';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = 'Tempo de permanência em cache dos artigos da FAQ.';
    $Self->{Translation}->{'Category Management'} = 'Gestão de categorias';
    $Self->{Translation}->{'Category Management.'} = 'Gestão de Categorias.';
    $Self->{Translation}->{'Customer FAQ Print.'} = 'Impressão da FAQ';
    $Self->{Translation}->{'Customer FAQ Related Articles'} = '';
    $Self->{Translation}->{'Customer FAQ Related Articles.'} = '';
    $Self->{Translation}->{'Customer FAQ Zoom.'} = 'Visualização da FAQ.';
    $Self->{Translation}->{'Customer FAQ search.'} = 'Pesquisa da FAQ.';
    $Self->{Translation}->{'Customer FAQ.'} = 'FAQ do cliente.';
    $Self->{Translation}->{'Decimal places of the voting result.'} = 'Número de casas decimais do resultado da votação.';
    $Self->{Translation}->{'Default category name.'} = 'Nome da categoria por omissão.';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = 'Idioma por omissão dos artigos da FAQ.';
    $Self->{Translation}->{'Default maximum size of the titles in a FAQ article to be shown.'} =
        'Tamanho máximo do título do artigo FAQ a ser exibido.';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        'Prioridade dos tickets para aprovação dos artigos FAQ.';
    $Self->{Translation}->{'Default state for FAQ entry.'} = 'Estado por omissão para novas entradas na FAQ.';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'Estado dos tickets para aprovação dos artigos FAQ.';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = 'Tipo de tickets para a aprovação de artigos da FAQ.';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} =
        'Valor do parâmetro \'Action\' na interface pública. Este parâmetro é usado nos scripts do sistema.';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'Definir Acções onde um botão de configurações está disponível na widget the objectos ligados (LinkObject::ViewMode = "complex").  Estas Acções devem estar registadas nos seguintes ficheiros JS e CSS: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.';
    $Self->{Translation}->{'Define if the FAQ title should be concatenated to article subject.'} =
        'Indique se o título do FAQ deve ser concatenado ao assunto do artigo.';
    $Self->{Translation}->{'Define which columns are shown in the linked FAQs widget (LinkObject::ViewMode = "complex"). Note: Only FAQ attributes and dynamic fields (DynamicField_NameX) are allowed for DefaultColumns.'} =
        '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} =
        'Define um módulo de resumo para mostrar a visualização pequena de um jornal FAQ.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} =
        'Define um módulo de resumo para mostrar a visualização pequena de uma lista de FAQ.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} =
        'Define o atributo padrão FAQ para classificar o FAQ em uma pesquisa FAQ da interface do agente.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} =
        'Define o atributo padrão FAQ para classificar o FAQ em uma pesquisa FAQ da interface do cliente.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} =
        'Define o atributo padrão FAQ para classificar o FAQ em uma pesquisa FAQ da interface pública.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the agent interface.'} =
        'Define o atributo padrão de ordenação no Explorador de FAQ da interface do agente.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the customer interface.'} =
        'Define o atributo padrão de ordenação no Explorador de FAQ da interface do cliente.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} =
        'Define o atributo padrão de ordenação no Explorador de FAQ da interface pública.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the agent interface. Up: oldest on top. Down: latest on top.'} =
        'Define a ordenação padrão dos resultados no Explorador de FAQ na interface do agente. Acima: mais antigos no topo. Abaixo: mais recentes no topo.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the customer interface. Up: oldest on top. Down: latest on top.'} =
        'Define a ordenação padrão dos resultados no Explorador de FAQ na interface do cliente. Acima: mais antigos no topo. Abaixo: mais recentes no topo.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the public interface. Up: oldest on top. Down: latest on top.'} =
        'Define a ordenação padrão dos resultados no Explorador de FAQ na interface pública. Acima: mais antigos no topo. Abaixo: mais recentes no topo.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} =
        'Define a ordenação padrão dos resultados na pesquisa de FAQ na interface do agente. Acima: mais antigos no topo. Abaixo: mais recentes no topo.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} =
        'Define a ordenação padrão dos resultados na pesquisa de FAQ na interface do cliente. Acima: mais antigos no topo. Abaixo: mais recentes no topo.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} =
        'Define a ordenação padrão dos resultados na pesquisa de FAQ na interface pública. Acima: mais antigos no topo. Abaixo: mais recentes no topo.';
    $Self->{Translation}->{'Defines the default shown FAQ search attribute for FAQ search screen.'} =
        'Define o atributo padrão no ecrã de pesquisa de FAQ.';
    $Self->{Translation}->{'Defines the information to be inserted in a FAQ based Ticket. "Full FAQ" includes text, attachments and inline images.'} =
        'Define a informação a ser inserida no chamado baseado em FAQ. "Todo o FAQ" inclui texto, anexos e imagens embutidas.';
    $Self->{Translation}->{'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.'} =
        'Define os parâmetros para o backend do dashboard. "Limite" define o número de entradas exibidas por padrão. "Grupo" é usado para restringir o acesso ao plugin (ex.: Grupo: admin, grupo1, grupo2). "Padrão" indica se o plugin é habilitado por padrão ou se o usuário precisa habilitá-lo manualmente.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} =
        'Define as colunas mostradas no Explorador de FAQ. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} =
        'Define as colunas mostradas no jornal FAQ. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} =
        'Define as colunas mostradas na pesquisa FAQ. Esta opção não tem efeito sobre a posição da coluna.';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed.'} = 'Define onde o link "Inserir FAQ" será exibido.';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = 'Definição de campos de texto livre.';
    $Self->{Translation}->{'Delete this FAQ'} = 'Apagar esta FAQ!';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ add screen of the agent interface.'} =
        'Campos dinâmicos exibidos no ecrã de adicionar FAQ da interface de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ edit screen of the agent interface.'} =
        'Campos dinâmicos exibidos np ecrã de editar FAQ da interface de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the customer interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the public interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the agent interface.'} =
        'Campos dinâmicos exibidos no ecrã de imprimir FAQ da interface de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the customer interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the public interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the agent interface.'} =
        'Campos dinâmicos mostrados no ecrã de pesquisa de FAQ da interface de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the customer interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the public interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ small format overview screen of the agent interface.'} =
        'Campos dinâmicos exibidos no ecrã visão geral de FAQ em formato pequeno da interface de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the agent interface.'} =
        'Campos dinâmicos exibidos no ecrã de zoom de FAQ da interface de agente.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the customer interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the public interface.'} =
        '';
    $Self->{Translation}->{'Edit this FAQ'} = 'Editar esta FAQ';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = 'Permitir vários idiomas no módulo FAQ.';
    $Self->{Translation}->{'Enable the related article feature for the customer frontend.'} =
        'Ativar a funcionalidade de artigos relacionados na interface do cliente.';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = 'Ativar funcionalidade de votação no módulo FAQ.';
    $Self->{Translation}->{'Explorer'} = 'Explorador';
    $Self->{Translation}->{'FAQ AJAX Responder'} = 'FAQ AJAX Responder';
    $Self->{Translation}->{'FAQ AJAX Responder for Richtext.'} = 'FAQ AJAX Responder em Richtext.';
    $Self->{Translation}->{'FAQ Area'} = 'Área FAQ';
    $Self->{Translation}->{'FAQ Area.'} = 'Área FAQ.';
    $Self->{Translation}->{'FAQ Delete.'} = 'Apagar FAQ.';
    $Self->{Translation}->{'FAQ Edit.'} = 'Editar FAQ.';
    $Self->{Translation}->{'FAQ History.'} = 'Histórico de FAQ.';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = 'Limite da Visão Geral "Pequeno" do Jornal FAQ';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = 'Limite da Visão Geral FAQ "Pequeno"';
    $Self->{Translation}->{'FAQ Print.'} = 'Imprimir FAQ.';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = 'FAQ busca servidor roteador da interface do atendente.';
    $Self->{Translation}->{'Field4'} = 'Campo4';
    $Self->{Translation}->{'Field5'} = 'Campo5';
    $Self->{Translation}->{'Full FAQ'} = 'FAQ completo';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = 'Grupo para a aprovação dos artigos FAQ.';
    $Self->{Translation}->{'History of this FAQ'} = 'Histórico deste FAQ';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = 'Incluir campos internos de um Chamado base FAQ.';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = 'Incluir o nome de cada campo em um Chamado base FAQ.';
    $Self->{Translation}->{'Interfaces where the quick search should be shown.'} = 'Interfaces onde a pesquisa rápida deve ser mostrada.';
    $Self->{Translation}->{'Journal'} = 'Jornal';
    $Self->{Translation}->{'Language Management'} = 'Gestão de idiomas';
    $Self->{Translation}->{'Language Management.'} = 'Gerenciamento de Idiomas.';
    $Self->{Translation}->{'Limit for the search to build the keyword FAQ article list.'} = 'Limite para a pesquisa construir a lista de palavras-chave de FAQ.';
    $Self->{Translation}->{'Link another object to this FAQ item'} = 'Link de outro artigo para este item FAQ';
    $Self->{Translation}->{'List of queue names for which the related article feature is enabled.'} =
        'Lista do nomes de filas para os quais o recurso desse artigo está ativado.';
    $Self->{Translation}->{'List of state types which can be used in the agent interface.'} =
        'Lista dos tipos de estado que pode ser utilizado na interface de agente.';
    $Self->{Translation}->{'List of state types which can be used in the customer interface.'} =
        'Lista dos tipos de estado que pode ser utilizado na interface de cliente.';
    $Self->{Translation}->{'List of state types which can be used in the public interface.'} =
        'Lista dos tipos de estado que pode ser utilizado na interface pública.';
    $Self->{Translation}->{'Loader module registration for the public interface.'} = '';
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
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the agent interface.'} =
        'Tamanho máximo de títulos em um artigo FAQ a serem exibidos na lista de entradas da FAQ da interface de atendente.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the customer interface.'} =
        'Tamanho máximo de títulos em um artigo FAQ a serem exibidos na lista de entradas da FAQ da interface de cliente.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the public interface.'} =
        'Tamanho máximo de títulos em um artigo FAQ a serem exibidos na lista de entradas da FAQ da interface pública.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the agent interface.'} =
        'Tamanho máximo de títulos em um artigo FAQ a serem exibidos na Pesquisa de FAQ da interface de atendente.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the customer interface.'} =
        'Tamanho máximo de títulos em um artigo FAQ a serem exibidos na Pesquisa de FAQ da interface de cliente.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the public interface.'} =
        'Tamanho máximo de títulos em um artigo FAQ a serem exibidos na Pesquisa de FAQ da interface pública.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ journal in the agent interface.'} =
        'Tamanho máximo de títulos em um artigo FAQ a serem exibidos no Jornal FAQ da interface de atendente.';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the public interface.'} =
        'Módulo para gerar perfil HTML OpenSearch para pesquisas curtas de FAQ na interface pública.';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short FAQ search.'} =
        '';
    $Self->{Translation}->{'New FAQ Article.'} = 'Novo Artigo de FAQ.';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = 'Novos artigos FAQ precisam de aprovação antes de ser publicados.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the customer interface.'} =
        'Número de artigos FAQ para ser exibido no Gerenciador FAQ da interface do cliente';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the public interface.'} =
        'Número de artigos FAQ para ser exibido no Gerenciador FAQ da interface publica';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the customer interface.'} =
        'Número de artigos FAQ para ser exibido em cada página de um resultado de pesquisa na interface do cliente';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the public interface.'} =
        'Número de artigos FAQ para ser exibido em cada página de um resultado de pesquisa na interface publica';
    $Self->{Translation}->{'Number of shown items in last changes.'} = 'Número de itens mostrados em últimas alterações.';
    $Self->{Translation}->{'Number of shown items in last created.'} = 'Número de itens mostrados em últimas criações.';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = 'Número de itens mostrados no recurso top 10.';
    $Self->{Translation}->{'Output filter to add Java-script to CustomerTicketMessage screen.'} =
        '';
    $Self->{Translation}->{'Output limit for the related FAQ articles.'} = 'Limite de saída para os artigos desse FAQ.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} =
        'Parâmetros de páginas (nas quais os itens FAQ são mostrados) da visão geral pequena do jornal FAQ.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} =
        'Parâmetros de páginas (nas quais os itens FAQ são mostrados) da visão geral pequena de FAQ.';
    $Self->{Translation}->{'Print this FAQ'} = 'Imprimir este FAQ';
    $Self->{Translation}->{'Public FAQ Print.'} = 'Imprimir FAQ público.';
    $Self->{Translation}->{'Public FAQ Zoom.'} = 'Zoom em FAQ público.';
    $Self->{Translation}->{'Public FAQ search.'} = 'Busca FAQ público.';
    $Self->{Translation}->{'Public FAQ.'} = 'FAQ público.';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = 'Fila para a aprovação dos artigos FAQ.';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = 'Condição para a avaliação. Chave deve ser em percentual.';
    $Self->{Translation}->{'S'} = 'S';
    $Self->{Translation}->{'Search FAQ'} = 'Pesquisa FAQ';
    $Self->{Translation}->{'Search FAQ Small.'} = 'Pesquisar FAQ Pequena';
    $Self->{Translation}->{'Search FAQ.'} = 'Pesquisar FAQ.';
    $Self->{Translation}->{'Select how many items should be shown in Journal Overview "Small" by default.'} =
        'Selecione quantos itens devem ser mostrados na visão geral do diário "Small" por padrão.';
    $Self->{Translation}->{'Select how many items should be shown in Overview "Small" by default.'} =
        'Selecione quantos itens devem ser mostrados na visão geral "Small" por padrão.';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        'Configura a altura padrão (em pixels) de campos HTML embutidos no AgentFAQZoom.';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        'Configura a altura padrão (em pixels) de campos HTML embutidos em CustomerFAQZoom (e PublicFAQZoom).';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        'Configura a altura máxima (em pixels) de campos HTML embutidos no AgentFAQZoom.';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        'Configura a altura máxima (em pixels) de campos HTML embutidos em CustomerFAQZoom (e PublicFAQZoom).';
    $Self->{Translation}->{'Show "Insert FAQ Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        'Mostra botão "Inserir Link FAQ" em Ampliação pequena para o artigos FAQ públicos';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" / "Insert Full FAQ & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        'Mostrar botões "Inserir texto do FAQ e link" / "Inserir todo o FAQ e link" em AgentFAQZoomSmall para Artigos de FAQ públicos.';
    $Self->{Translation}->{'Show "Insert FAQ Text" / "Insert Full FAQ" Button in AgentFAQZoomSmall.'} =
        'Mostrar botões "Inserir texto do FAQ" / "Inserir todo o FAQ" em AgentFAQZoomSmall.';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = 'Mostrar artigo FAQ com HTML.';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = 'Mostrar caminho FAQ sim / não.';
    $Self->{Translation}->{'Show invalid items in the FAQ Explorer result of the agent interface.'} =
        'Mostrar itens inválidos no resultado do Explorador de FAQ na interface de agente.';
    $Self->{Translation}->{'Show items of subcategories.'} = 'Mostrar itens de subcategorias.';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = 'Mostrar as últimas alterações de itens em interfaces definidas.';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = 'Mostrar os últimos itens criados em interfaces definidas.';
    $Self->{Translation}->{'Show the stars for the articles with a rating equal or greater like the defined value (set value \'0\' to deactivate the output).'} =
        'Mostre as estrelas para os artigos com uma classificação igual ou maior do valor definido (defina o valor \'0\' para desativar a saída).';
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
    $Self->{Translation}->{'Solution'} = 'Solução';
    $Self->{Translation}->{'Symptom'} = 'Sintoma';
    $Self->{Translation}->{'Text Only'} = 'Apenas texto';
    $Self->{Translation}->{'The default languages for the related FAQ articles.'} = 'O idioma padrão para os artigos desse FAQ.';
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
    $Self->{Translation}->{'Toolbar Item for a shortcut.'} = 'Item da barra de ferramentas para um atalho. ';
    $Self->{Translation}->{'external (customer)'} = 'externo (cliente)';
    $Self->{Translation}->{'internal (agent)'} = 'interno (agente)';
    $Self->{Translation}->{'public (all)'} = 'público (todos)';
    $Self->{Translation}->{'public (public)'} = 'público (público)';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'No',
    'Ok',
    'Settings',
    'Submit',
    'This might be helpful',
    'Yes',
    );

}

1;
