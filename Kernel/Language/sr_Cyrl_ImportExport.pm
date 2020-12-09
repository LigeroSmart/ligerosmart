# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sr_Cyrl_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Увоз/Извоз управљање';
    $Self->{Translation}->{'Add template'} = 'Додај шаблон';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Креирај шаблон за увоз и извоз информација о објекту.';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        'За коришћење овог модула, морате инсталирати ITSMConfigurationManagement или неки други пакет који обезбеђује позадинске модуле за ентитете увоза и извоза.';
    $Self->{Translation}->{'Start Import'} = 'Почни увоз';
    $Self->{Translation}->{'Start Export'} = 'Почни извоз';
    $Self->{Translation}->{'Delete this template'} = '';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = 'Корак 1 од 5 - Уреди заједничке информације';
    $Self->{Translation}->{'Name is required!'} = 'Име је обавезно!';
    $Self->{Translation}->{'Object is required!'} = 'Објект је обавезан!';
    $Self->{Translation}->{'Format is required!'} = 'Формат је обавезан!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = 'Корак 2 од 5 - Уреди информације о објекту';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = 'Корак 3 од 5 - Уреди информације о формату';
    $Self->{Translation}->{'is required!'} = 'је обавезно!';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = 'Корак 4 од 5 - Уреди информације о мапирању';
    $Self->{Translation}->{'No map elements found.'} = 'Ниједан елемент мапе није пронађен.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Додај елемент за мапирање';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = 'Корак 5 од 5 - Уреди информације за претрагу';
    $Self->{Translation}->{'Restrict export per search'} = 'Ограничење извоза по претрази';
    $Self->{Translation}->{'Import information'} = 'Увоз информација';
    $Self->{Translation}->{'Source File'} = 'Изворна датотека';
    $Self->{Translation}->{'Import summary for %s'} = 'Резиме увоза за %s';
    $Self->{Translation}->{'Records'} = 'Записи';
    $Self->{Translation}->{'Success'} = 'Успешно';
    $Self->{Translation}->{'Duplicate names'} = 'Дупликат имена';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Број последње обрађене линије увезене датотеке';
    $Self->{Translation}->{'Ok'} = 'У реду';
    $Self->{Translation}->{'Do you really want to delete this template item?'} = 'Да ли стварно желите да обришете овај шаблон?';

    # Perl Module: Kernel/Modules/AdminImportExport.pm
    $Self->{Translation}->{'No object backend found!'} = 'Није пронађен позадински модул објекта!';
    $Self->{Translation}->{'No format backend found!'} = 'Није пронађен позадински модул формата!';
    $Self->{Translation}->{'Template not found!'} = 'Шаблон није пронађен!';
    $Self->{Translation}->{'Can\'t insert/update template!'} = 'Шаблон се не може унети/ажурирати!';
    $Self->{Translation}->{'Needed TemplateID!'} = 'Потребан ИД шаблона!';
    $Self->{Translation}->{'Error occurred. Import impossible! See Syslog for details.'} = 'Догодила се грешка. Увоз је немогућ! За детаље погледајте у системски дневник.';
    $Self->{Translation}->{'Error occurred. Export impossible! See Syslog for details.'} = 'Догодила се грешка. Извоз је немогућ! За детаље погледајте у системски дневник.';
    $Self->{Translation}->{'Template List'} = 'Листа шаблона';
    $Self->{Translation}->{'number'} = 'број';
    $Self->{Translation}->{'number bigger than zero'} = 'број већи од нула';
    $Self->{Translation}->{'integer'} = 'цео број';
    $Self->{Translation}->{'integer bigger than zero'} = 'цео број већи од нула';
    $Self->{Translation}->{'Element required, please insert data'} = 'Неопходан елемент, молимо унесите податке';
    $Self->{Translation}->{'Invalid data, please insert a valid %s'} = 'Неисправни подаци, унесете важећи %s';
    $Self->{Translation}->{'Format not found!'} = 'Формат није пронађен!';

    # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
    $Self->{Translation}->{'Column Separator'} = 'Сепаратор колона';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Табулатор (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Тачка и запета (;)';
    $Self->{Translation}->{'Colon (:)'} = 'Двотачка (:)';
    $Self->{Translation}->{'Dot (.)'} = 'Тачка (.)';
    $Self->{Translation}->{'Comma (,)'} = 'Зарез (,)';
    $Self->{Translation}->{'Charset'} = 'Карактерсет';
    $Self->{Translation}->{'Include Column Headers'} = 'Укључи наслове колона';
    $Self->{Translation}->{'Column'} = 'Колона';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = 'Брисање шаблона...';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        'Грешка приликом брисања шаблона. Молимо проверите лог датотеку за више информација.';
    $Self->{Translation}->{'Template was deleted successfully.'} = 'Шаблон је успешно обрисан.';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Формат регистрације „backend” модула за увоз/извоз модул.';
    $Self->{Translation}->{'Import and export object information.'} = 'Информације о увозу и извозу објеката';
    $Self->{Translation}->{'Import/Export'} = 'Увоз/Извоз';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Confirm',
    'Delete this template',
    'Deleting template...',
    'Template was deleted successfully.',
    'There was an error deleting the template. Please check the logs for more information.',
    );

}

1;
