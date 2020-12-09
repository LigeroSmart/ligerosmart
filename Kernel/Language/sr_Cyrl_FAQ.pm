# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sr_Cyrl_FAQ;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'Додај FAQ чланак';
    $Self->{Translation}->{'Keywords'} = 'Кључне речи';
    $Self->{Translation}->{'A category is required.'} = 'Категорија је обавезна.';
    $Self->{Translation}->{'Approval'} = 'Одобрење';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'Управљање FAQ категоријама';
    $Self->{Translation}->{'Add FAQ Category'} = 'Додај FAQ категорију';
    $Self->{Translation}->{'Edit FAQ Category'} = 'Уреди FAQ категорију';
    $Self->{Translation}->{'Add category'} = 'Додај категорију';
    $Self->{Translation}->{'Add Category'} = 'Додај категорију';
    $Self->{Translation}->{'Edit Category'} = 'Уреди категорију';
    $Self->{Translation}->{'Subcategory of'} = 'Подкатегорија од';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Молимо да изаберете бар једну групу дозвола.';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Групе оператера које могу приступити чланцима у овој категорији.';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Биће приказано као коментар у Истраживачу.';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'Да ли стварно желите да обришете ову категорију?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        'Не можете обрисати ову категорију. Употребљена је у бар једном FAQ чланку и/или је надређена најмање једној другој категорији';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'Ова категорија је употребљена у следећим FAQ чланцима';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'Ова категорија је надређена следећим подкатегоријама';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'Да ли стварно желите да обришете овај FAQ чланак?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'FAQ претраживач';
    $Self->{Translation}->{'Quick Search'} = 'Брзо тражење';
    $Self->{Translation}->{'Wildcards are allowed.'} = 'Џокерски знаци су дозвољени.';
    $Self->{Translation}->{'Advanced Search'} = 'Напредна претрага';
    $Self->{Translation}->{'Subcategories'} = 'Подкатегорије';
    $Self->{Translation}->{'FAQ Articles'} = 'FAQ чланци';
    $Self->{Translation}->{'No subcategories found.'} = 'Подкатегорије нису пронађене.';

    # Template: AgentFAQHistory
    $Self->{Translation}->{'History of'} = 'Историја од';
    $Self->{Translation}->{'History Content'} = 'Садржај историје';
    $Self->{Translation}->{'Createtime'} = 'Време креирања';

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'Нису пронађени подаци FAQ дневника.';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'Управљање FAQ језицима';
    $Self->{Translation}->{'Add FAQ Language'} = 'Додај FAQ језик';
    $Self->{Translation}->{'Edit FAQ Language'} = 'Уреди FAQ језик';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languages.'} =
        'Употребите ову функцију ако желите да користите више језика.';
    $Self->{Translation}->{'Add language'} = 'Додај језик';
    $Self->{Translation}->{'Add Language'} = 'Додај Језик';
    $Self->{Translation}->{'Edit Language'} = 'Уреди Језик';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'Да ли заиста желите да избришете овај језик?';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        'Не можете обрисати овај језик. Употребљен је у бар једном FAQ чланку!';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'Овај језик је употребљен у следећим FAQ чланцима';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Подешавање контекста';
    $Self->{Translation}->{'FAQ articles per page'} = 'FAQ чланака по страни';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'Нису пронађени FAQ подаци.';

    # Template: AgentFAQRelatedArticles
    $Self->{Translation}->{'out of 5'} = 'од 5';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = 'Кључна реч';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = 'Гласај (нпр једнако 10 или веће од 60)';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = 'Оцени (нпр једнако 25% или веће од 75%)';
    $Self->{Translation}->{'Approved'} = 'Одобрено';
    $Self->{Translation}->{'Last changed by'} = 'Последњи је мењао';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = 'Време креирања FAQ чланка (пре/после)';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = 'Време креирања FAQ чланка (између)';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = 'Време промене FAQ чланка (пре/после)';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = 'Време промене FAQ чланка (између)';

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'FAQ текст';

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'FAQ претрага';
    $Self->{Translation}->{'Profile Selection'} = 'Избор профила';
    $Self->{Translation}->{'Vote'} = 'Глас';
    $Self->{Translation}->{'No vote settings'} = 'Нема подешавања за гласање';
    $Self->{Translation}->{'Specific votes'} = 'Специфични гласови';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = 'нпр једнако 10 или веће од 60';
    $Self->{Translation}->{'Rate'} = 'Оцена';
    $Self->{Translation}->{'No rate settings'} = 'Нема подешавања за оцењивање';
    $Self->{Translation}->{'Specific rate'} = 'Специфична оцена';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = 'нпр једнако 25% или веће од 75%';
    $Self->{Translation}->{'FAQ Article Create Time'} = 'Време креирања FAQ чланка';
    $Self->{Translation}->{'FAQ Article Change Time'} = 'Време промене FAQ чланка';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'FAQ информација';
    $Self->{Translation}->{'Rating'} = 'Оцењивање';
    $Self->{Translation}->{'Votes'} = 'Гласови';
    $Self->{Translation}->{'No votes found!'} = 'Гласови нису пронађени!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Гласови нису пронађени! Будите први који ће оценити овај FAQ чланак.';
    $Self->{Translation}->{'Download Attachment'} = 'Преузми прилог';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Да бисте отворили везе у следећим блоковима описа, можда ћете требати да притиснете „Ctrl” или „Cmd” или „Shift” тастер док истовремено кликнете на везу (зависи од вашег ОС и прегледача).';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        'Колико је користан овај чланак? Молимо вас да дате вашу оцену и помогнете подизању квалитата базе често постављаних питања. Хвала Вам! ';
    $Self->{Translation}->{'not helpful'} = 'није корисно';
    $Self->{Translation}->{'very helpful'} = 'врло корисно';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Add FAQ title to article subject'} = 'Додај наслов FAQ чланку';
    $Self->{Translation}->{'Insert FAQ Text'} = 'Унеси FAQ текст';
    $Self->{Translation}->{'Insert Full FAQ'} = 'Унеси комплетан FAQ';
    $Self->{Translation}->{'Insert FAQ Link'} = 'Унеси FAQ везу';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'Унеси FAQ текст и везу';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = 'Унеси комплетан FAQ и везу';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'Нису пронађени FAQ чланци.';

    # Template: CustomerFAQRelatedArticles
    $Self->{Translation}->{'This might be helpful'} = 'Ово може да буде од помоћи';
    $Self->{Translation}->{'Found no helpful resources for the subject and text.'} = 'Корисни ресурси за унети предмет и текст нису пронађени.';
    $Self->{Translation}->{'Type a subject or text to get a list of helpful resources.'} = 'За листу корисних ресурса, молимо унесите предмет или текст.';

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Потпуна текстуална претрага у FAQ чланцима (нпр. "John*n" или "Will*")';
    $Self->{Translation}->{'Vote restrictions'} = 'Ограничења гласања';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = 'Само FAQ чланци са гласовима...';
    $Self->{Translation}->{'Rate restrictions'} = 'Ограничења оцењивања';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = 'Само FAQ чланци са оценом...';
    $Self->{Translation}->{'Time restrictions'} = 'Временска ограничења';
    $Self->{Translation}->{'Only FAQ articles created'} = 'Само FAQ чланци креирани';
    $Self->{Translation}->{'Only FAQ articles created between'} = 'Само FAQ чланци креирани између';
    $Self->{Translation}->{'Search-Profile as Template?'} = 'Профил претраге као шаблон?';

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = 'Број чланка';
    $Self->{Translation}->{'Search for articles with keyword'} = 'Тражи чланке са кључном речи';

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = 'Јавно';

    # Template: PublicFAQSearchResultShort
    $Self->{Translation}->{'Back to FAQ Explorer'} = 'Назад на FAQ претраживач';

    # Perl Module: Kernel/Modules/AgentFAQAdd.pm
    $Self->{Translation}->{'You need rw permission!'} = 'Потребна вам је „rw” дозвола!';
    $Self->{Translation}->{'No categories found where user has read/write permissions!'} = 'Категорије у којој корисник има приступ без ограничења нису пронађене!';
    $Self->{Translation}->{'No default language found and can\'t create a new one.'} = 'Није пронађен подразумевани језик и не може се креирати нов.';

    # Perl Module: Kernel/Modules/AgentFAQCategory.pm
    $Self->{Translation}->{'Need CategoryID!'} = 'Потребан ИД Категорије!';
    $Self->{Translation}->{'A category should have a name!'} = 'Категорија треба да има име!';
    $Self->{Translation}->{'This category already exists'} = 'Ова категорија већ постоји';
    $Self->{Translation}->{'This category already exists!'} = 'Ова категорија већ постоји!';
    $Self->{Translation}->{'No CategoryID is given!'} = 'Није дат ИД Категорије!';
    $Self->{Translation}->{'Was not able to delete the category %s!'} = 'Није било могуће обрисати категорију %s!';
    $Self->{Translation}->{'FAQ category updated!'} = 'FAQ категорија ажурирана!';
    $Self->{Translation}->{'FAQ category added!'} = 'FAQ категорија додата!';
    $Self->{Translation}->{'Delete Category'} = 'Обриши категорију';

    # Perl Module: Kernel/Modules/AgentFAQDelete.pm
    $Self->{Translation}->{'No ItemID is given!'} = 'Није дат ИД Ставке!';
    $Self->{Translation}->{'You have no permission for this category!'} = 'Немате дозволу за ову категорију!';
    $Self->{Translation}->{'Was not able to delete the FAQ article %s!'} = 'Није било могуће обрисати FAQ чланак %s!';

    # Perl Module: Kernel/Modules/AgentFAQExplorer.pm
    $Self->{Translation}->{'The CategoryID %s is invalid.'} = 'ИД Категорије %s је неисправан!';

    # Perl Module: Kernel/Modules/AgentFAQHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ItemID is given!'} = 'Не може се приказати историјат, јер није дат ИД Ставке!';
    $Self->{Translation}->{'FAQ History'} = 'FAQ историјат';

    # Perl Module: Kernel/Modules/AgentFAQJournal.pm
    $Self->{Translation}->{'FAQ Journal'} = 'FAQ дневник';
    $Self->{Translation}->{'Need config option FAQ::Frontend::Overview'} = 'Потребна конфигурациона опција FAQ::Frontend::Overview';
    $Self->{Translation}->{'Config option FAQ::Frontend::Overview needs to be a HASH ref!'} =
        'Конфигурациона опција FAQ::Frontend::Overview мора да буде HASH референца!';
    $Self->{Translation}->{'No config option found for the view "%s"!'} = 'Није пронађена конфигурациона ставка за преглед "%s"!';

    # Perl Module: Kernel/Modules/AgentFAQLanguage.pm
    $Self->{Translation}->{'No LanguageID is given!'} = 'Није дат ИД Језика!';
    $Self->{Translation}->{'The name is required!'} = 'Име је обавезно!';
    $Self->{Translation}->{'This language already exists!'} = 'Овај језик већ постоји!';
    $Self->{Translation}->{'Was not able to delete the language %s!'} = 'Није било могуће обрисати језик %s!';
    $Self->{Translation}->{'FAQ language updated!'} = 'Ажуриран FAQ језик!';
    $Self->{Translation}->{'FAQ language added!'} = 'Додат FAQ језик!';
    $Self->{Translation}->{'Delete Language %s'} = 'Обриши језик %s';

    # Perl Module: Kernel/Modules/AgentFAQPrint.pm
    $Self->{Translation}->{'Result'} = 'Резултат';
    $Self->{Translation}->{'Last update'} = 'Последње ажурирање';
    $Self->{Translation}->{'FAQ Dynamic Fields'} = 'FAQ динамичка поља';

    # Perl Module: Kernel/Modules/AgentFAQRichText.pm
    $Self->{Translation}->{'No %s is given!'} = 'Није дат %s!';
    $Self->{Translation}->{'Can\'t load LanguageObject!'} = 'Језички објект се не може учитати!';

    # Perl Module: Kernel/Modules/AgentFAQSearch.pm
    $Self->{Translation}->{'No Result!'} = 'Нема резултата!';
    $Self->{Translation}->{'FAQ Number'} = 'FAQ број';
    $Self->{Translation}->{'Last Changed by'} = 'Последњи је мењао';
    $Self->{Translation}->{'FAQ Item Create Time (before/after)'} = 'Време креирања FAQ ставке (пре/после)';
    $Self->{Translation}->{'FAQ Item Create Time (between)'} = 'Време креирања FAQ ставке (између)';
    $Self->{Translation}->{'FAQ Item Change Time (before/after)'} = 'Време измене FAQ ставке (пре/после)';
    $Self->{Translation}->{'FAQ Item Change Time (between)'} = 'Време измене FAQ ставке (између)';
    $Self->{Translation}->{'Equals'} = 'Једнако';
    $Self->{Translation}->{'Greater than'} = 'Веће од';
    $Self->{Translation}->{'Greater than equals'} = 'Једнако или веће од';
    $Self->{Translation}->{'Smaller than'} = 'Мање од';
    $Self->{Translation}->{'Smaller than equals'} = 'Једнако или мање од';

    # Perl Module: Kernel/Modules/AgentFAQZoom.pm
    $Self->{Translation}->{'Need FileID!'} = 'Потребан ИД Поља!';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Хвала на вашем гласу!';
    $Self->{Translation}->{'You have already voted!'} = 'Већ сте гласали!';
    $Self->{Translation}->{'No rate selected!'} = 'Није изабрана ни једна оцена!';
    $Self->{Translation}->{'The voting mechanism is not enabled!'} = 'Механизам за гласање није активиран!';
    $Self->{Translation}->{'The vote rate is not defined!'} = 'Оцењивање гласања није дефинисано!';

    # Perl Module: Kernel/Modules/CustomerFAQPrint.pm
    $Self->{Translation}->{'FAQ Article Print'} = 'Штампа FAQ чланка';

    # Perl Module: Kernel/Modules/CustomerFAQSearch.pm
    $Self->{Translation}->{'Created between'} = 'Креиран између';

    # Perl Module: Kernel/Modules/CustomerFAQZoom.pm
    $Self->{Translation}->{'Need ItemID!'} = 'Потребан ИД Ставке!';

    # Perl Module: Kernel/Modules/PublicFAQExplorer.pm
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'FAQ чланци (ново креирани)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'FAQ чланци (недавно мењани)';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'FAQ чланци (првих 10)';

    # Perl Module: Kernel/Modules/PublicFAQRSS.pm
    $Self->{Translation}->{'No Type is given!'} = 'Није дат Тип!';
    $Self->{Translation}->{'Type must be either LastCreate or LastChange or Top10!'} = 'Type мора бити LastCreate, LastChange или Top10!';
    $Self->{Translation}->{'Can\'t create RSS file!'} = 'RSS датотека не моће бити снимљена!';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/AgentFAQSearch.pm
    $Self->{Translation}->{'%s (FAQFulltext)'} = '%s (FAQ текст)';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/CustomerFAQSearch.pm
    $Self->{Translation}->{'%s - Customer (%s)'} = '%s - Клијент (%s)';
    $Self->{Translation}->{'%s - Customer (FAQFulltext)'} = '%s - Клијент (FAQ текст)';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/PublicFAQSearch.pm
    $Self->{Translation}->{'%s - Public (%s)'} = '%s - Јавно (%s)';
    $Self->{Translation}->{'%s - Public (FAQFulltext)'} = '%s - Јавно (FAQ текст)';

    # Perl Module: Kernel/Output/HTML/Layout/FAQ.pm
    $Self->{Translation}->{'Need rate!'} = 'Неопходна оцена!';
    $Self->{Translation}->{'This article is empty!'} = 'Чланак је празан!';
    $Self->{Translation}->{'Latest created FAQ articles'} = 'Последње креирани FAQ чланци';
    $Self->{Translation}->{'Latest updated FAQ articles'} = 'Последње ажурирани FAQ чланци';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Најпопуларнијих 10 FAQ чланака';

    # Perl Module: Kernel/Output/HTML/LinkObject/FAQ.pm
    $Self->{Translation}->{'Content Type'} = 'Тип садржаја';

    # Database XML Definition: FAQ.sopm
    $Self->{Translation}->{'internal'} = 'интерно';
    $Self->{Translation}->{'external'} = 'екстерно';
    $Self->{Translation}->{'public'} = 'јавно';

    # JS File: FAQ.Agent.ConfirmationDialog
    $Self->{Translation}->{'Ok'} = 'У реду';

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} =
        'Филтер за „HTML” излаз за додавање везе иза дефинисаног низа знакова. Елемент Слика дозвољава два начина уноса. Први је назив слике (нпр faq.png). у овом случају биће коришћена „OTRS” путања до слике.  Друга могућност је унос везе до слике.';
    $Self->{Translation}->{'Add FAQ article'} = 'Додај FAQ чланак';
    $Self->{Translation}->{'CSS color for the voting result.'} = '„CSS” боја за резултат гласања.';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = 'Време ослобађања кеша за FAQ ставке.';
    $Self->{Translation}->{'Category Management'} = 'Управљање категоријама';
    $Self->{Translation}->{'Category Management.'} = 'Управљање категоријама.';
    $Self->{Translation}->{'Customer FAQ Print.'} = 'Штампање клијентског FAQ.';
    $Self->{Translation}->{'Customer FAQ Related Articles'} = 'Сродни FAQ чланци у интерфејсу клијента';
    $Self->{Translation}->{'Customer FAQ Related Articles.'} = 'Сродни FAQ чланци у интерфејсу клијента.';
    $Self->{Translation}->{'Customer FAQ Zoom.'} = 'Детаљи клијентског FAQ.';
    $Self->{Translation}->{'Customer FAQ search.'} = 'Претрага клијентског FAQ.';
    $Self->{Translation}->{'Customer FAQ.'} = 'Клијентски FAQ.';
    $Self->{Translation}->{'Decimal places of the voting result.'} = 'Број децимала у резултату гласања.';
    $Self->{Translation}->{'Default category name.'} = 'Назив подразумеване категорије.';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = 'Подразумевани језик FAQ чланака у једнојезичком начину рада.';
    $Self->{Translation}->{'Default maximum size of the titles in a FAQ article to be shown.'} =
        'Подразумевана максимална дужина наслова FAQ чланка која ће бити приказана.';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        'Подразумевани приоритет тикета за одобравање FAQ чланака.';
    $Self->{Translation}->{'Default state for FAQ entry.'} = 'Подразумевано стање FAQ уноса.';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'Подразумевано стање тикета за одобравање FAQ чланака.';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = 'Подразумевани тип тикета за одобравање FAQ чланака.';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} =
        'Подразумевана вредност за „Action” параметар у јавном фронтенду. Овај параметар користе скрипте система. ';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'Дефинише Акције где је дугме поставки доступно у повезаном графичком елементу објекта (LinkObject::ViewMode = "complex"). Молимо да имате на уму да ове Акције морају да буду регистроване у следећим JS и CSS датотекама: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js и Core.Agent.LinkObject.js.';
    $Self->{Translation}->{'Define if the FAQ title should be concatenated to article subject.'} =
        'Одређује да ли наслов FAQ треба да буде додат на тему чланка.';
    $Self->{Translation}->{'Define which columns are shown in the linked FAQs widget (LinkObject::ViewMode = "complex"). Note: Only FAQ attributes and dynamic fields (DynamicField_NameX) are allowed for DefaultColumns.'} =
        'Одређује које колоне ће бити приказане у додатку повезаних FAQ чланака (LinkObject::ViewMode = "сложено"). Напомена: само атрибути FAQ чланка и динамичка поља (DynamicField_NameX) су дозвољени за DefaultColumns.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} =
        'Дефинише модул прегледа за мали приказ FAQ дневника. ';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} =
        'Дефинише модул прегледа за мали приказ FAQ листе. ';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} =
        'Дефинише подразумевани атрибут за сортирање FAQ претрази FAQ  у интерфејсу  оператера.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} =
        'Дефинише подразумевани атрибут за сортирање FAQ у претрази FAQ  у интерфејсу клијента.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} =
        'Дефинише подразумевани атрибут за сортирање FAQ у претрази FAQ  у јавном интерфејсу.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the agent interface.'} =
        'Дефинише подразумевани атрибут за сортирање FAQ у FAQ претраживачу у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the customer interface.'} =
        'Дефинише подразумевани атрибут за сортирање FAQ у FAQ претраживачу у интерфејсу клијента.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} =
        'Дефинише подразумевани атрибут за сортирање FAQ у FAQ претраживачу у јавном интерфејсу.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the agent interface. Up: oldest on top. Down: latest on top.'} =
        'Дефинише подразумевани редослед FAQ у резултатима FAQ претраживача у интерфејсу опрератера. Горе: најстарији на врху. Доле: најновије на врху.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the customer interface. Up: oldest on top. Down: latest on top.'} =
        'Дефинише подразумевани редослед FAQ у резултатима FAQ претраживача у интерфејсу клијента. Горе: најстарији на врху. Доле: најновије на врху.';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the public interface. Up: oldest on top. Down: latest on top.'} =
        'Дефинише подразумевани редослед FAQ резултатима FAQ претраживача у јавном интерфејсу. Горе: најстарији на врху. Доле: најновије на врху.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} =
        'Дефинише подразумевани редослед FAQ у резултатима претраге у интерфејсу опрератера. Горе: најстарији на врху. Доле: најновије на врху.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} =
        'Дефинише подразумевани редослед FAQ у резултатима претраге у интерфејсу клијента. Горе: најстарији на врху. Доле: најновије на врху.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} =
        'Дефинише подразумевани редослед FAQ у резултатима претраге у јавном интерфејсу. Горе: најстарији на врху. Доле: најновије на врху.';
    $Self->{Translation}->{'Defines the default shown FAQ search attribute for FAQ search screen.'} =
        'Дефинише подразумевани приказани FAQ атрибут претраге за FAQ прозор за претрагу. ';
    $Self->{Translation}->{'Defines the information to be inserted in a FAQ based Ticket. "Full FAQ" includes text, attachments and inline images.'} =
        'Одређује информације које ће бити убачене у FAQ базирани тикет. "Комплетан FAQ" укључује текст, прилоге и уметнуте слике.';
    $Self->{Translation}->{'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.'} =
        'Дефинише позадинске параметре за контролну таблу. "Лимит" дефинише број подрезумевано приказаних уноса. "Група" се користи да ограничи приступ додатку (нпр. Група: admin;group1;group2;)."Подразумевано" указује на то да ли је додатак подразумевано активиран или да је потребно да га корисник мануелно активира.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} =
        'Дефинише приказане колоне у FAQ претраживачу. Ова опција нема утицај на позиције колона.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} =
        'Дефинише приказане колоне у FAQ дневнику. Ова опција нема утицај на позиције колона.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} =
        'Дефинише приказане колоне у FAQ претрази. Ова опција нема утицај на позиције колона.';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed.'} = 'Дефинише где ће "Убаци FAQ" веза бити приказана.';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = 'Дефиниција поља слободног текста за FAQ ставку.';
    $Self->{Translation}->{'Delete this FAQ'} = 'Обриши овај FAQ';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ add screen of the agent interface.'} =
        'Динамичка поља прикатана у екрану додавања FAQ у интерфејсу оператера.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ edit screen of the agent interface.'} =
        'Динамичка поља приказана у екрану измене FAQ у интерфејсу оператера.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the customer interface.'} =
        'Динамичка поља приказана у прегледу FAQ у интерфејсу клијента.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the public interface.'} =
        'Динамичка поља приказана у прегледу FAQ у јавном интерфејсу.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the agent interface.'} =
        'Динамичка поља приказана у екрану штампе FAQ у интерфејсу оператера.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the customer interface.'} =
        'Динамичка поља приказана у екрану штампе FAQ у интерфејсу клијента.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the public interface.'} =
        'Динамичка поља приказана у екрану штампе FAQ у јавном интерфејсу.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the agent interface.'} =
        'Динамичка поља приказана у екрану претраге FAQ у интерфејсу оператера.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the customer interface.'} =
        'Динамичка поља приказана у екрану претраге FAQ у интерфејсу клијента.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the public interface.'} =
        'Динамичка поља приказана у екрану претраге FAQ у јавном интерфејсу.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ small format overview screen of the agent interface.'} =
        'Динамичка поља приказана у прегледу FAQ малог формата у интерфејсу оператера.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the agent interface.'} =
        'Динамичка поља приказана у детаљном прегледу FAQ у интерфејсу оператера.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the customer interface.'} =
        'Динамичка поља приказана у детаљном прегледу FAQ у интерфејсу клијента.';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the public interface.'} =
        'Динамичка поља приказана у детаљном прегледу FAQ у јавном интерфејсу.';
    $Self->{Translation}->{'Edit this FAQ'} = 'Уреди овај FAQ';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = 'Активирање више језика на FAQ модулу.';
    $Self->{Translation}->{'Enable the related article feature for the customer frontend.'} =
        'Активира функцију сродних чланака за интерфејс клијента.';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = 'Активирање механизма за гласање на FAQ модулу.';
    $Self->{Translation}->{'Explorer'} = 'Истраживач';
    $Self->{Translation}->{'FAQ AJAX Responder'} = 'FAQ AJAX одговарач';
    $Self->{Translation}->{'FAQ AJAX Responder for Richtext.'} = 'FAQ AJAX одговарач за FAQ.';
    $Self->{Translation}->{'FAQ Area'} = 'FAQ простор';
    $Self->{Translation}->{'FAQ Area.'} = 'FAQ простор.';
    $Self->{Translation}->{'FAQ Delete.'} = 'Обриши FAQ.';
    $Self->{Translation}->{'FAQ Edit.'} = 'Уреди FAQ.';
    $Self->{Translation}->{'FAQ History.'} = 'Историјат FAQ.';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = 'Ограничење прегледа FAQ дневника "мало"';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = 'Ограничење прегледа FAQ "мало"';
    $Self->{Translation}->{'FAQ Print.'} = 'Штампај FAQ.';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = 'Модул рутера FAQ претраге у интерфејсу оператера.';
    $Self->{Translation}->{'Field4'} = 'Поље4';
    $Self->{Translation}->{'Field5'} = 'Поље5';
    $Self->{Translation}->{'Full FAQ'} = 'Kомплетан FAQ';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = 'Група за одобравање FAQ чланака.';
    $Self->{Translation}->{'History of this FAQ'} = 'Историјат овог FAQ';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = 'Укључи интерна поља у FAQ базиран тикет.';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = 'Укључи назив сваког поља у FAQ базиран тикет.';
    $Self->{Translation}->{'Interfaces where the quick search should be shown.'} = 'Интерфејс на ком треба приказати брзу претрагу.';
    $Self->{Translation}->{'Journal'} = 'Дневник';
    $Self->{Translation}->{'Language Management'} = 'Управљање језицима';
    $Self->{Translation}->{'Language Management.'} = 'Управљање језицима.';
    $Self->{Translation}->{'Limit for the search to build the keyword FAQ article list.'} = 'Ограничење претраге за генерисање листе кључних речи FAQ чланака.';
    $Self->{Translation}->{'Link another object to this FAQ item'} = 'Повежи други објекат са овом ставком FAQ';
    $Self->{Translation}->{'List of queue names for which the related article feature is enabled.'} =
        'Листа имена редова за које је фунција сродних чланака активирана.';
    $Self->{Translation}->{'List of state types which can be used in the agent interface.'} =
        'Листа типова стања који се могу користити у интерфејсу оператера.';
    $Self->{Translation}->{'List of state types which can be used in the customer interface.'} =
        'Листа типова стања који се могу користити у интерфејсу клијента.';
    $Self->{Translation}->{'List of state types which can be used in the public interface.'} =
        'Листа типова стања који се могу користити у јавном интерфејсу.';
    $Self->{Translation}->{'Loader module registration for the public interface.'} = 'Регистрација модула за учитавање за јавни интерфејс.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the agent interface.'} =
        'Максимални број FAQ чланака који ће бити приказани у резултату FAQ претраживача у интерфејсу оператера.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the customer interface.'} =
        'Максимални број FAQ чланака који ће бити приказани у резултату FAQ претраживача у интерфејсу клијента.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the public interface.'} =
        'Максимални број FAQ чланака који ће бити приказани у резултату FAQ претраживача у јавном интерфејсу.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} =
        'Максимални број FAQ чланака који ће бити приказани у FAQ дневнику у интерфејсу оператера.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} =
        'Максимални број FAQ чланака који ће бити приказани у резултату претраге у интерфејсу оператера.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} =
        'Максимални број FAQ чланака који ће бити приказани у резултату претраге у интерфејсу клијента.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} =
        'Максимални број FAQ чланака који ће бити приказани у резултату претраге у јавном интерфејсу.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the agent interface.'} =
        'Максимална дужина наслова у FAQ чланку који ће бити приказани у FAQ претраживачу у интерфејсу оператера.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the customer interface.'} =
        'Максимална дужина наслова у FAQ чланку који ће бити приказани у FAQ претраживачу у интерфејсу клијента.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the public interface.'} =
        'Максимална дужина наслова у FAQ чланку који ће бити приказани у FAQ истраживачу у јавном интерфејсу.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the agent interface.'} =
        'Максимална дужина наслова у FAQ чланку који ће бити приказани у FAQ претрази у интерфејсу оператера.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the customer interface.'} =
        'Максимална дужина наслова у FAQ чланку који ће бити приказани у FAQ претрази у интерфејсу клијента.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the public interface.'} =
        'Максимална дужина наслова у FAQ чланку који ће бити приказани у FAQ претрази у јавном интерфејсу.';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ journal in the agent interface.'} =
        'Максимална дужина наслова у FAQ чланку који ће бити приказани у FAQ дневнику у интерфејсу оператера.';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the customer interface.'} =
        'Модул за генерисање HTML OpenSearch профила за кратку FAQ претрагу у интерфејсу клијента.';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the public interface.'} =
        'Модул за генерисање HTML OpenSearch профила за кратку FAQ претрагу у јавном профилу.';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short FAQ search.'} =
        'Модул за генерисање HTML OpenSearch профила за кратку FAQ претрагу.';
    $Self->{Translation}->{'New FAQ Article.'} = 'Нови FAQ чланак.';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = 'Нови FAQ чланци требају бити одобрени пре објављивања.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the customer interface.'} =
        'Број FAQ чланака који ће бити приказани у FAQ претраживачу у интерфејсу клијента.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the public interface.'} =
        'Број FAQ чланака који ће бити приказани у FAQ претраживачу у јавном интерфејсу.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the customer interface.'} =
        'Број FAQ чланака који ће бити приказани на свакој страни резултата претраге у интерфејсу клијента.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the public interface.'} =
        'Број FAQ чланака који ће бити приказани на свакој страни резултата претраге у јавном интерфејсу.';
    $Self->{Translation}->{'Number of shown items in last changes.'} = 'Број приказаних ставки у последњим изменама.';
    $Self->{Translation}->{'Number of shown items in last created.'} = 'Број приказаних ставки у последње креираним.';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = 'Број приказаних ставки у "првих 10" .';
    $Self->{Translation}->{'Output filter to add Java-script to CustomerTicketMessage screen.'} =
        'Излазни филтер за убацивање JavaScript у CustomerTicketMessage екран.';
    $Self->{Translation}->{'Output limit for the related FAQ articles.'} = 'Ограничење броја приказаних сродних FAQ чланака.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} =
        'Параметри страница (на којима су FAQ ставке приказане) на малом приказу прегледа FAQ дневника.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} =
        'Параметри страница (на којима су видљиве FAQ ставке) смањеног прегледа FAQ.';
    $Self->{Translation}->{'Print this FAQ'} = 'Штампај овај FAQ';
    $Self->{Translation}->{'Public FAQ Print.'} = 'Штампање јавних FAQ.';
    $Self->{Translation}->{'Public FAQ Zoom.'} = 'Детаљи јавних FAQ.';
    $Self->{Translation}->{'Public FAQ search.'} = 'Претрага јавних FAQ.';
    $Self->{Translation}->{'Public FAQ.'} = 'Јавни FAQ.';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = 'Ред за одобравање FAQ чланака.';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = 'Оцене за гласање. Кључ мора бити у процентима.';
    $Self->{Translation}->{'S'} = 'С';
    $Self->{Translation}->{'Search FAQ'} = 'Претражи FAQ';
    $Self->{Translation}->{'Search FAQ Small.'} = 'Мала FAQ претрага.';
    $Self->{Translation}->{'Search FAQ.'} = 'Претрага FAQ.';
    $Self->{Translation}->{'Select how many items should be shown in Journal Overview "Small" by default.'} =
        'Изаберите колико ће ставки бити подразумевано приказано у прегледу дневника малог формата.';
    $Self->{Translation}->{'Select how many items should be shown in Overview "Small" by default.'} =
        'Изаберите колико ће ставки бити подразумевано приказано у прегледу малог формата.';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        'Подеси подразумевану висину (у пикселима) инлине HTML поља у AgentFAQZoom.';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        'Подеси подразумевану висину (у пикселима) инлине HTML поља у CustomerFAQZoom (и PublicFAQZoom).';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        'Подеси максималну висину (у пикселима) инлине HTML поља у AgentFAQZoom.';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        'Подеси максималну висину (у пикселима) инлине HTML поља у CustomerFAQZoom (и PublicFAQZoom).';
    $Self->{Translation}->{'Show "Insert FAQ Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        'Прикажи "Убаци FAQ везу" дугме у AgentFAQZoomSmall за јавне FAQ артикле.';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" / "Insert Full FAQ & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        'Прикажи "Убаци FAQ текст и везу" / "Убаци цео FAQ и везу дугме у AgentFAQZoomSmall за јавне FAQ артикле.';
    $Self->{Translation}->{'Show "Insert FAQ Text" / "Insert Full FAQ" Button in AgentFAQZoomSmall.'} =
        'Прикажи "Убаци FAQ текст" / "Убаци цео FAQ" дугме у AgentFAQZoomSmall.';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = 'Приказ FAQ чланка као HTML.';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = 'Прикажи путању до FAQ да/не.';
    $Self->{Translation}->{'Show invalid items in the FAQ Explorer result of the agent interface.'} =
        'Приказ неиспрвних ставки у резултатима FAQ претраживача у интерфејсу оператера.';
    $Self->{Translation}->{'Show items of subcategories.'} = 'Прикажи ставке субкатегорија.';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = 'Прикажи задње промењене ставке у дефинисаним интерфејсима.';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = 'Прикажи задње креиране ставке у дефинисаним интерфејсима.';
    $Self->{Translation}->{'Show the stars for the articles with a rating equal or greater like the defined value (set value \'0\' to deactivate the output).'} =
        'Прикажи звездице за чланке са једнаком или бољом оценом од дефинисане вредности (поставите вредност \'0\' за деактивирање приказа).';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = 'Прикажи првих 10 ставки у дефинисаним интерфејсима.';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = 'Прикажи гласање у дефинисаним интерфејсима.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'} =
        'У менију приказује везу која омогућава повезивање FAQ са другим објектом у детаљном приказу тог FAQ у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'} =
        'У менију приказује везу која омогућава брисање FAQ у детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface.'} =
        'У менију приказује везу за приступ FAQ историјату у детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'} =
        'У менију приказује везу за измену FAQ у детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'} =
        'У менију приказује везу за повратак у детаљни приказ FAQ у  интерфејсу оператера.';
    $Self->{Translation}->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'} =
        'У менију приказује везу за штампање FAQ у детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Solution'} = 'Решење';
    $Self->{Translation}->{'Symptom'} = 'Симптом';
    $Self->{Translation}->{'Text Only'} = 'Само текст';
    $Self->{Translation}->{'The default languages for the related FAQ articles.'} = 'Подразумевани језици за сродне FAQ чланке.';
    $Self->{Translation}->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'} =
        'Идентификатор за FAQ, нпр. FAQ#, KB#, MyFAQ#. Подразумевано је FAQ#.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'} =
        'Ово подешавање дефинише да FAQ објект може да се повеже са другим FAQ објектима користећи везу типа \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Ово подешавање дефинише да FAQ објекaт може да се повеже са другим FAQ објектима користећи везу типа \'ParentChild\'.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'} =
        'Ово подешавање дефинише да FAQ објект може да се повеже са другим тикет објектима користећи везу типа \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'} =
        'Ово подешавање дефинише да FAQ објект може да се повеже са другим тикет објектима користећи везу типа \'ParentChild\'.';
    $Self->{Translation}->{'Ticket body for approval of FAQ article.'} = 'Садржај тикета за одобравање FAQ чланака.';
    $Self->{Translation}->{'Ticket subject for approval of FAQ article.'} = 'Предмет тикета за одобравање FAQ чланака.';
    $Self->{Translation}->{'Toolbar Item for a shortcut.'} = 'Ставка алатне линије за скраћеницу.';
    $Self->{Translation}->{'external (customer)'} = 'екстерно (клијент)';
    $Self->{Translation}->{'internal (agent)'} = 'интерно (оператер)';
    $Self->{Translation}->{'public (all)'} = 'јавно (све)';
    $Self->{Translation}->{'public (public)'} = 'јавно (јавно)';


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
